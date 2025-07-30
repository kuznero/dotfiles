# Mac Configuration

MacBook Pro configuration for aarch64-darwin (Apple Silicon).

## Overview

Mac configuration provides a development environment for Apple Silicon MacBooks
with window management and development tools.

## Prerequisites

- MacBook with Apple Silicon (M1/M2/M3)
- macOS installed
- Nix with flakes enabled
- Homebrew (for some GUI applications)

## Installation

### Home Manager Configuration

Since macOS uses Darwin instead of NixOS, only Home Manager configuration is needed:

```bash
# First time
nix run home-manager/master -- switch --flake github:kuznero/dotfiles#mac

# Subsequent updates
home-manager switch --flake github:kuznero/dotfiles#mac
```

## Configuration Details

### Platform

- Architecture: aarch64-darwin
- Apple Silicon optimized
- macOS native integration

### Window Management

**Yabai** tiling window manager for efficient workspace management:

- Automatic window tiling
- Workspace switching
- Keyboard-driven navigation

### Development Environment

Terminal:

- Ghostty terminal with Catppuccin theme
- 0xProto Nerd Font at 18pt
- Optimized for Retina displays

Shell and Tools:

- Zsh with custom configuration
- Tmux terminal multiplexer
- FZF fuzzy finder
- Zoxide directory navigation

Development:

- Git configuration
- Nixvim (Neovim) with qwen2.5-coder:7b model
- MkDocs for documentation
- Custom scripts

AI/ML:

- Ollama for local LLM execution
- Configured with larger models (7b vs 1.5b)

### Font Configuration

Uses 0xProto Nerd Font optimized for high-DPI displays with larger font size
(18pt) for better readability on Retina screens.

### Theme

Catppuccin Mocha theme throughout all applications. The configuration supports
theme switching:

```nix
# For automatic dark/light mode switching:
theme = "dark:catppuccin-mocha,light:catppuccin-latte";
```

## macOS-Specific Notes

### System Preferences

Some settings require manual configuration in System Preferences:

- Accessibility permissions for Yabai
- Security settings for terminal applications
- Keyboard shortcuts that might conflict

### Homebrew Integration

While Nix manages most packages, some GUI applications might need Homebrew:

```bash
# Example for GUI apps not in nixpkgs
brew install --cask some-app
```

### Performance

The configuration is optimized for Apple Silicon:

- Native ARM64 binaries where available
- Larger AI models due to better performance
- Higher resolution fonts and UI elements

## Troubleshooting

### Yabai Permissions

If Yabai fails to manage windows:

1. Grant accessibility permissions in System Preferences
2. Disable System Integrity Protection (if needed)
3. Restart the Yabai service

### Font Rendering

If fonts appear blurry:

1. Check display scaling settings
2. Verify font size configuration
3. Ensure subpixel antialiasing is enabled
