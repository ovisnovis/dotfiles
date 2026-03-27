# =============================================================================
# Oh-My-Zsh Configuration
# =============================================================================
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="robbyrussell"
plugins=(git zsh-autosuggestions)

# Load custom completions
fpath+=${ZSH_CUSTOM:-${ZSH:-~/.oh-my-zsh}/custom}/plugins/zsh-completions/src
autoload -U compinit && compinit

source $ZSH/oh-my-zsh.sh

# =============================================================================
# Aliases
# =============================================================================
alias ls="lsd -1"
alias ll="ls -lh"
alias la="ls -lah"
alias vi="vim"

# =============================================================================
# Environment Variables
# =============================================================================
export EDITOR=vim
export VISUAL=vim

# WSLg Configuration: Enables hardware acceleration and GUI support in WSL2
export WAYLAND_DISPLAY=wayland-0
export DISPLAY=:0
export GALLIUM_DRIVER=d3d12

# =============================================================================
# Key Bindings & Functions
# =============================================================================
# Maps Ctrl+Z to immediately bring a backgrounded process (like vim) to the foreground
_zsh_cli_fg() { fg; }
zle -N _zsh_cli_fg
bindkey '^Z' _zsh_cli_fg

# =============================================================================
# SSH Agent / Security
# =============================================================================
# Use keychain to manage SSH keys persistently across shell sessions.
# This replaces standard ssh-agent and prevents multiple agents from spawning.
eval $(keychain --eval fhkey)

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
