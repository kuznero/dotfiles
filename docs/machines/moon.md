# Moon Laptop Configuration

Lenovo ThinkPad X1 10th generation laptop running x86_64-linux.

## Overview

Moon is a full-featured desktop configuration optimized for Lenovo ThinkPad X1
laptops with comprehensive development tools and desktop environment.

## Prerequisites

- Lenovo ThinkPad X1 (10th gen) or compatible hardware
- x86_64 architecture
- Nix with flakes enabled

## Installation

### System Configuration

Apply the NixOS configuration:

```bash
sudo nixos-rebuild switch --flake github:kuznero/dotfiles#moon --impure
```

### Home Manager Configuration

Set up the user environment:

```bash
# First time
nix run home-manager/master -- switch --flake github:kuznero/dotfiles#moon

# Subsequent updates
home-manager switch --flake github:kuznero/dotfiles#moon
```

## Configuration Details

### Hardware Support

- ThinkPad X1 10th generation specific optimizations via nixos-hardware
- DisplayLink support for external monitors
- Power management optimizations

### Desktop Environment

Primary: **GNOME** (can be switched to XFCE)

### Included Features

System modules:

- Docker containerization
- Flatpak application support
- Gaming support (Steam, etc.)
- Media codecs and players
- Ollama AI/ML tools
- VPN configurations
- System fonts
- 1Password integration

Home Manager modules:

- Development tools (VS Code, Cursor, JetBrains IDEs)
- Terminal emulators (Ghostty, WezTerm)
- Communication tools (messengers)
- Office suite
- Web browsers
- Media applications (Spotify, Transmission)
- Cloud storage (pCloud)
- Note-taking (Obsidian)

### Development Environment

- Git with custom configuration
- Tmux terminal multiplexer
- Nixvim (Neovim configuration)
- FZF fuzzy finder
- Zoxide directory jumper
- Custom scripts and aliases
- Beyond Compare for file comparison

## Customization

### Desktop Resolution

To modify display resolution, uncomment and adjust in the flake:

```nix
services.xserver.resolutions = [{
  x = 1680;
  y = 1050;
}];
```

### Switching Desktop Environments

To use XFCE instead of GNOME:

1. Comment out `./hosts/gnome.nix`
2. Uncomment `./hosts/xfce.nix`
3. Rebuild the system

## Laptop-Specific Features

- Optimized battery management
- ThinkPad-specific keyboard and trackpad support
- Thermal management
- Suspend/resume reliability improvements

