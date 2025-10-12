# My Dotfiles

These are my personal dotfiles for a customized development and desktop environment.

![screenshot](https://via.placeholder.com/800x400.png?text=Desktop+Screenshot)

## Installation

The `install.sh` script creates symbolic links for the configuration files to the correct locations in your home directory (`$HOME/.config`).

```bash
./install.sh
```

## System

*   **OS:** Arch Linux

## Dependencies

These dotfiles are configured for the following applications:

*   **[fzf](https://github.com/junegunn/fzf):** A command-line fuzzy finder.
*   **[Ghostty](https://github.com/ghostty-org/ghostty):** A GPU-accelerated terminal emulator.
*   **[Hyprland](https://hyprland.org/):** A dynamic tiling Wayland compositor.
*   **[Neovim](https://neovim.io/):** A modern text editor.

## Structure

*   `fzf/`: Configuration for fzf.
*   `ghostty/`: Configuration for Ghostty terminal.
*   `hypr/`: Configuration for Hyprland, hypridle, and hyprlock.
*   `nvim/`: Neovim configuration with Lua and Lazy.nvim.

## Customization

Feel free to fork this repository and customize the configurations to your liking. The Neovim configuration is modular and can be easily extended in the `nvim/lua/custom/plugins/` directory.
