#!/bin/bash

# This script installs the dependencies for the configurations in this repository.

# Update package database and install the following packages:
# fzf: A command-line fuzzy finder
# ghostty: A GPU-accelerated terminal emulator
# hyprland: A dynamic tiling Wayland compositor
# hypridle: Hyprland's idle daemon
# hyprlock: Hyprland's screen locker
# neovim: A modern text editor

sudo pacman -Syu fzf ghostty hyprland hypridle hyprlock neovim

# Create symbolic links to the configuration files.
# This will remove existing configuration directories if they exist.

CONFIG_DIR="$HOME/.config"
DOTFILES_DIR="/home/addy/dotfiles"

# Create .config directory if it doesn't exist
mkdir -p "$CONFIG_DIR"

# Link hypr configuration
if [ -d "$CONFIG_DIR/hypr" ] || [ -L "$CONFIG_DIR/hypr" ]; then
    echo "Removing existing hypr config"
    rm -rf "$CONFIG_DIR/hypr"
fi
echo "Linking hypr config"
ln -s "$DOTFILES_DIR/hypr" "$CONFIG_DIR/hypr"

# Link ghostty configuration
if [ -d "$CONFIG_DIR/ghostty" ] || [ -L "$CONFIG_DIR/ghostty" ]; then
    echo "Removing existing ghostty config"
    rm -rf "$CONFIG_DIR/ghostty"
fi
echo "Linking ghostty config"
ln -s "$DOTFILES_DIR/ghostty" "$CONFIG_DIR/ghostty"

# Link nvim configuration
if [ -d "$CONFIG_DIR/nvim" ] || [ -L "$CONFIG_DIR/nvim" ]; then
    echo "Removing existing nvim config"
    rm -rf "$CONFIG_DIR/nvim"
fi
echo "Linking nvim config"
ln -s "$DOTFILES_DIR/nvim" "$CONFIG_DIR/nvim"

echo "Symbolic links created."

# For fzf, you need to source the config file in your shell's rc file.
# For example, for bash, add the following line to your ~/.bashrc:
# source "$DOTFILES_DIR/fzf/fzf_config.sh"