# Home Manager Configuration

Home Manager enables declarative management of user environments using Nix.

## Overview

The Home Manager configuration in this repository provides:

- Application configurations
- Dotfile management
- Shell environments
- Development tools
- User-specific services

## Configuration Structure

```plain
home-manager/
├── user.nix              # Main user configuration
└── programs/             # Application modules
    ├── common.nix        # Common tools
    ├── git.nix          # Git configuration
    ├── nixvim.nix       # Neovim setup
    ├── tmux.nix         # Terminal multiplexer
    ├── zsh.nix          # Shell configuration
    └── ...              # Other applications
```

## Key Applications

### Development Tools

- **[Nixvim](programs/nixvim.md)** - Powerful Neovim configuration with LSP and
AI integration
- **[Git](programs/git.md)** - Version control with custom aliases and delta
diff viewer
- **Tmux** - Terminal session management with Catppuccin theme
- **VS Code/Cursor** - Modern code editors

### Terminal Environment

- **Zsh** - Feature-rich shell with Oh My Zsh
- **Ghostty** - GPU-accelerated terminal
- **FZF** - Command-line fuzzy finder
- **Zoxide** - Smarter cd command

### Productivity Tools

- **Obsidian** - Knowledge management
- **Browsers** - Firefox and Chromium configurations
- **Office Suite** - LibreOffice and document tools

### Communication

- **Messengers** - Slack, Discord, Teams
- **Email** - Thunderbird configuration

## Custom Scripts

The configuration includes helpful scripts in `programs/scripts/`:

- `gcauto` - Automated git commits with AI-generated messages
- Various utility scripts for common tasks

## Platform-Specific Configurations

Different machines use different sets of programs:

### Moon (Linux Desktop)

Full suite including:

- GUI applications
- Development IDEs
- Media applications
- Cloud storage

### Mac

Optimized for macOS:

- Yabai window manager
- macOS-specific tools
- Larger AI models

### WSL

Lightweight configuration:

- Terminal-focused tools
- Windows integration
- Smaller resource footprint

## Dotfile Management

Home Manager links configuration files:

```nix
home.file.".config/app/config.yml".source = ./dotfiles/app-config.yml;
```

This ensures consistent configuration across machines while keeping files in
version control.

## Theming

All applications use Catppuccin color scheme for visual consistency:

- Mocha (dark theme)
- Latte (light theme)
- Automatic theme switching support

## Adding New Programs

To add a new program module:

1. Create `home-manager/programs/newapp.nix`
2. Define the configuration
3. Import in the appropriate machine configuration
4. Rebuild with `home-manager switch`

Example module structure:

```nix
{ config, pkgs, ... }:
{
  programs.newapp = {
    enable = true;
    settings = {
      theme = "catppuccin-mocha";
    };
  };
}
```
