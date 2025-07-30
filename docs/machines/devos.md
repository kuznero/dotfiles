# DevOS Virtual Machine Configuration

Development virtual machine running on aarch64-linux architecture.

## Overview

DevOS is designed as a lightweight development environment suitable for
ARM-based virtual machines.

## Prerequisites

- ARM64/aarch64 compatible virtualization platform
- Nix with flakes enabled
- Sufficient RAM (recommended: 8GB+)

## Installation

### System Configuration

Apply the NixOS configuration:

```bash
sudo nixos-rebuild switch --flake github:kuznero/dotfiles#devos --impure
```

### Home Manager Configuration

Set up the user environment:

```bash
# First time
nix run home-manager/master -- switch --flake github:kuznero/dotfiles#devos

# Subsequent updates
home-manager switch --flake github:kuznero/dotfiles#devos
```

## Configuration Details

### Hardware

- Architecture: aarch64-linux
- Type: Virtual Machine
- Optimized for ARM processors

### Included Features

The DevOS configuration includes:

- Core development tools
- Terminal utilities
- Git configuration
- Shell environment (zsh)
- Text editors

### Base System

Located at `hosts/devos/configuration.nix`, the system configuration provides:

- Basic NixOS setup
- User account management
- System packages
- Network configuration

## Usage Notes

1. This configuration is minimal by design
2. Add additional features by modifying the flake configuration
3. Suitable for development and testing workflows
4. Can be extended with desktop environments if needed
