#!/bin/bash

LOW_THRESHOLD=25      # Warnung: Akku wird niedrig
CRITICAL_THRESHOLD=10 # Kritisch: Sofortiges Handeln erforderlich

BATTERY_CAPACITY=$(cat /sys/class/power_supply/BAT0/capacity 2>/dev/null)
BATTERY_STATUS=$(cat /sys/class/power_supply/BAT0/status 2>/dev/null)

if [[ -z "$BATTERY_CAPACITY" || "$BATTERY_STATUS" != "Discharging" ]]; then
	exit 0
fi

# 1. Kritische Warnung & Aktion
if [ "$BATTERY_CAPACITY" -le "$CRITICAL_THRESHOLD" ]; then
	hyprctl notify 3 10000 "rgb(ff0000)" "KRITISCH: Akku (${BATTERY_CAPACITY}%)"
	# /usr/bin/systemctl hibernate

# 2. Niedrige Warnung
elif [ "$BATTERY_CAPACITY" -le "$LOW_THRESHOLD" ]; then
	hyprctl notify 1 5000 "rgb(00aaff)" "Akku Niedrig (${BATTERY_CAPACITY}%)"
fi
