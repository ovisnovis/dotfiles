#!/usr/bin/env bash

# File: ~/.local/bin/volumecontrol.sh
# Dependencies: wpctl, notify-send (dunst)

# --- Utility Functions ---

print_usage() {
	cat <<EOF
Usage: $(basename "$0") <action> [step]

Actions:
i     <i>ncrease volume [+5%]
d     <d>ecrease volume [-5%]
m     toggle <m>ute
EOF
	exit 1
}

# Extracts volume and mute status from wpctl using @DEFAULT_SINK@
get_wpctl_info() {
	local INFO
	INFO=$(wpctl get-volume @DEFAULT_SINK@)

	echo "--- Debug WPCTL Output ---" >&2
	echo "INFO: $INFO" >&2

	if [ -z "$INFO" ]; then
		CURRENT_VOLUME=0
		IS_MUTED=true
		echo "ERROR: Failed to get WPCTL info." >&2
		return 1
	fi
	local VOL_DEC
	VOL_DEC=$(echo "$INFO" | grep -oE '[0-9]\.[0-9]{2,}' | head -n 1 || echo "0.00")
	if [ "$VOL_DEC" == "" ]; then
		VOL_DEC="0.00"
	fi

	# Convert to integer percentage
	CURRENT_VOLUME=$(awk "BEGIN { printf \"%.0f\", $VOL_DEC * 100 }" 2>/dev/null || echo "0")

	# Check for MUTED flag
	if echo "$INFO" | grep -q "MUTED"; then
		IS_MUTED=true
	else
		IS_MUTED=false
	fi
	return 0
}

# --- Notification Functions ---

notify_vol() {
	local delta=$1
	get_wpctl_info || return # Exit if we can't get info

	local vol=$CURRENT_VOLUME
	local muted=""

	# Volume level logic: 1 (0-33%), 2 (34-67%), 3 (68-100%)
	local level=$((vol / 34 + 1))

	if [ "$level" -gt 3 ]; then
		level=3
	fi

	if $IS_MUTED; then
		muted=" (Muted)"
		local icon_name="${icodir}/muted.svg"
		local progress_value=0
	else
		local icon_name="${icodir}/volume-${level}.svg"
		local progress_value="$vol"
	fi

	notify-send -a "volumecontrol.sh" -r 2 -t 800 \
		-h int:value:"${progress_value}" \
		-i "${icon_name}" \
		"Volume${muted}" "${vol}% (${delta})"
}

notify_mute() {
	get_wpctl_info || return # Exit if we can't get info

	if $IS_MUTED; then
		notify-send -a "volumecontrol.sh" -r 2 -t 800 \
			-h int:value:"0" \
			-i "${icodir}/muted.svg" "Muted" "${CURRENT_VOLUME}%"
	else
		# When unmuted, use the standard notify_vol to get the correct volume icon
		notify_vol "UNMUTED"
	fi
}

# --- Action Functions (Final Stabilization) ---

change_volume() {
	local action=$1
	local step=$2

	if [ "${action}" = "i" ]; then
		get_wpctl_info
		if [ "$CURRENT_VOLUME" -ge 100 ]; then
			notify_vol "..."
			exit 0
		fi
		# Increase command: Use -l 1.0 limit
		wpctl set-volume -l 1.0 @DEFAULT_SINK@ "${step}%+"
		notify_vol "+${step}%"

	elif [ "${action}" = "d" ]; then
		# Decrease command: wpctl naturally stops at 0%
		wpctl set-volume @DEFAULT_SINK@ "${step}%-"
		notify_vol "\-${step}%"
	fi
}

toggle_mute() {
	wpctl set-mute @DEFAULT_SINK@ toggle

	sleep 0.05

	notify_mute
}

# --- Main Execution ---

# Global variable initialization
step=${VOLUME_STEPS:-5}
icodir="$HOME/.config/dunst/icons"
CURRENT_VOLUME=0
IS_MUTED=false

# Execute action
case $1 in
i | d) change_volume "$1" "${2:-$step}" ;;
m) toggle_mute ;;
*) print_usage ;;
esac
