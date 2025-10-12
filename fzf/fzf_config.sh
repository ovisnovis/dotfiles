# FZF Configuration for a modern workflow
#
# Dependencies:
# - fzf: The core fuzzy finder
# - fd: A simple, fast and user-friendly alternative to 'find'
# - ripgrep (rg): A line-oriented search tool that recursively searches your current directory for a regex pattern.
# - bat: A cat(1) clone with syntax highlighting and Git integration. Used for previews.
# - zoxide: A smarter cd command, inspired by z and autojump.
#
# Installation (Arch Linux):
# sudo pacman -S fzf fd ripgrep bat zoxide

# -----------------------------------------------------------------------------
# FZF_DEFAULT_OPTS: General Appearance & Behavior
# -----------------------------------------------------------------------------
# For a full list of options, see 'man fzf'
export FZF_DEFAULT_OPTS='
--height 50% --layout=reverse --border=rounded
--info=inline --prompt="❯ " --pointer="▶" --marker="✔"
--header="CTRL-T: Files | CTRL-R: History | ALT-C: Dirs"

# Blue-ish Color Scheme
--color="fg:#d0d0d0,bg:#181a26,hl:#5897e0"
--color="fg+:#d0d0d0,bg+:#232530,hl+:#5897e0"
--color="info:#afcde0,prompt:#81a1c1,pointer:#81a1c1"
--color="marker:#81a1c1,spinner:#81a1c1,header:#81a1c1"
--color="border:#2e3440"

# Preview window settings
# Use bat for syntax highlighting, fallback to head
--preview="([[ -f {} ]] && (bat --style=numbers --color=always --line-range :500 {} || head -500 {})) || ([[ -d {} ]] && (ls -la {} | head -500)) || echo {} 2> /dev/null | head -500"
--preview-window="right:50%:border-left"
'

# -----------------------------------------------------------------------------
# FZF_DEFAULT_COMMAND: Default file finder (fd)
# -----------------------------------------------------------------------------
# Use fd to find files.
# - --type f: find only files
# - --hidden: include hidden files
# - --follow: follow symlinks
# - --exclude .git: exclude the .git directory
export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git'

# For CTRL-T, we want to find files and directories
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"

# -----------------------------------------------------------------------------
# Key Bindings & Completions
# -----------------------------------------------------------------------------
# This is typically handled by the fzf installation script which sources
# key-bindings.zsh, completion.zsh, etc.
# Ensure your shell's config file sources these files.
# Example for Zsh in ~/.zshrc:
#   [ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
# Example for Bash in ~/.bashrc:
#   [ -f ~/.fzf.bash ] && source ~/.fzf.bash
# -----------------------------------------------------------------------------
# Ripgrep Integration
# -----------------------------------------------------------------------------
# Override the default `fzf-file-widget` which is bound to CTRL-T to also use fd.
# This ensures that when you type `vim **<TAB>`, you get the same fd command.
_fzf_compgen_path() {
	fd --hidden --follow --exclude .git . "$1"
}

# Use fd to generate the list for directory completion
_fzf_compgen_dir() {
	fd --type d --hidden --follow --exclude .git . "$1"
}

# -----------------------------------------------------------------------------
# Zoxide Integration
# -----------------------------------------------------------------------------
# `zi`: Interactive directory jumping with zoxide
# This will show your most used directories and let you fuzzy find to jump.
# Add `eval "$(zoxide init zsh)"` or `eval "$(zoxide init bash)"` to your shell config first.
zi() {
	cd "$(zoxide query -l | fzf --preview 'ls -la {}')"
}
# `fps`: Fuzzy search and kill processes
fps() {
	local pid
	pid=$(ps -ef | sed 1d | fzf -m --height 40% --layout reverse | awk '{print $2}')

	if [ "x$pid" != "x" ]; then
		echo "$pid" | xargs kill -"${1:-9}"
		echo "Killed processes: $pid"
	fi
}

pacmans() {
	pacman -Slq | fzf --preview 'pacman -Si {}' --layout=reverse
}
