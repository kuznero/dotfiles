# System Architecture

This document explains the structure and organization of the Roku Labs dotfiles repository.

## Repository Structure

```plain
dotfiles/
├── docs/               # Documentation
├── dotfiles/           # Traditional dotfiles (vscode, etc.)
├── home-manager/       # User environment configurations
├── hosts/              # NixOS system configurations
├── pkgs/               # Custom packages
├── users/              # User account definitions
├── flake.nix           # Main Nix flake configuration
└── flake.lock          # Locked dependencies
```

## Core Components

### Flake Configuration

The `flake.nix` file is the entry point that defines:

- **Inputs**: External dependencies like nixpkgs, home-manager, nixvim
- **NixOS Configurations**: System-level configurations for each machine
- **Home Configurations**: User environment configurations

### Machine Configurations

Each machine has its own NixOS and Home Manager configuration:

| Machine | NixOS Config | Home Manager | Platform |
|---------|--------------|--------------|----------|
| DevOS | `hosts/devos/configuration.nix` | ✓ | aarch64-linux |
| Moon | `hosts/moon/configuration.nix` | ✓ | x86_64-linux |
| Sun | `hosts/sun/configuration.nix` | ✗ | x86_64-linux |
| Mac | N/A (Darwin) | ✓ | aarch64-darwin |
| WSL | `hosts/wsl/configuration.nix` | ✓ | x86_64-linux |

### Modular Design

The configuration is highly modular:

#### Host Modules (`hosts/`)

- `docker.nix` - Docker container support
- `fonts.nix` - System fonts
- `gaming.nix` - Gaming-related packages
- `gnome.nix` / `xfce.nix` - Desktop environments
- `vpn.nix` - VPN configurations
- `ollama.nix` - AI/ML tools

#### Home Manager Modules (`home-manager/programs/`)

- `common.nix` - Common tools and utilities
- `git.nix` - Git configuration
- `nixvim.nix` - Neovim configuration via nixvim
- `tmux.nix` - Terminal multiplexer
- `zsh.nix` - Shell configuration
- And many more...

### Key Features

#### Catppuccin Theming

All configurations use the Catppuccin color scheme for consistent theming
across applications.

#### Platform-Specific Configurations

- Linux systems can use either GNOME or XFCE desktop environments
- macOS uses yabai for window management
- WSL has special handling for corporate proxies and certificates

#### Development Tools

- Multiple terminal emulators (Ghostty, WezTerm)
- IDE support (VS Code, Cursor, JetBrains)
- Language-specific tools managed through Nix

## Configuration Flow

1. **System Level**: NixOS modules define system services, hardware
   configuration, and system packages
2. **User Level**: Home Manager configures user-specific applications,
   dotfiles, and environment
3. **Dotfiles**: Traditional dotfiles are managed through Home Manager's file linking

## Adding New Configurations

To add a new machine:

1. Create a new directory in `hosts/` with a `configuration.nix`
2. Add the configuration to `flake.nix` under `nixosConfigurations`
3. If needed, add a corresponding Home Manager configuration
4. Document the new machine in the appropriate documentation files
