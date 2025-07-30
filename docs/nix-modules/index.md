# Nix Modules

This section documents the various Nix modules used throughout the dotfiles configuration.

## System Modules (NixOS)

System-level modules that configure NixOS services and features.

### Desktop Environments

- **GNOME** - Full GNOME desktop environment
- **XFCE** - Lightweight XFCE desktop

### Services

- **Docker** - Container runtime and tools
- **Ollama** - Local LLM service
- **VPN** - VPN client configurations
- **GitHub Runner** - Self-hosted CI/CD runner

### Hardware & System

- **DisplayLink** - External monitor support
- **Fonts** - System font configuration
- **Gaming** - Gaming platform support
- **Media** - Multimedia codecs and tools

## Home Manager Modules

User-level modules for application configuration.

### Development Tools

- **[Git](../home-manager/programs/git.md)** - Version control configuration
- **[Nixvim](../home-manager/programs/nixvim.md)** - Neovim distribution
- **Tmux** - Terminal multiplexer
- **VS Code** - Code editor settings

### Terminal & Shell

- **Zsh** - Shell configuration
- **FZF** - Fuzzy finder
- **Zoxide** - Smart directory navigation
- **Ghostty** - Modern terminal emulator

### Applications

- **Browsers** - Web browser configurations
- **Office** - Office suite tools
- **Messengers** - Communication apps
- **Obsidian** - Note-taking application

## Module Structure

Each module follows a common pattern:

```nix
{ config, pkgs, lib, ... }:
{
  # Module options
  options = { ... };

  # Module configuration
  config = { ... };
}
```

Modules can be:

- **Imported directly** for always-on features
- **Conditionally enabled** based on machine type
- **Parameterized** for different configurations
