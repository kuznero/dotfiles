# Getting Started

This guide will help you set up and use the Roku Labs dotfiles on your system.

## Prerequisites

Before you begin, you need to have Nix installed with experimental features enabled.

### Enable Experimental Features

Create the Nix configuration directory and enable flakes:

```bash
# Create config directory
mkdir -p ~/.config/nix

# Enable experimental features
cat <<EOF > ~/.config/nix/nix.conf
experimental-features = flakes nix-command
EOF
```

### Install Nix Package Manager

If you haven't already installed Nix, follow the installation instructions from
the [official Nix website](https://nixos.org/download.html).

## Applying Configurations

Each machine has its own configuration profile. Choose the appropriate
instructions for your system:

- [DevOS Virtual Machine](machines/devos.md) - For aarch64 Linux VMs
- [Moon Laptop](machines/moon.md) - For x86_64 Lenovo laptops
- [Sun Server](machines/sun.md) - For GitHub Runner servers
- [Mac](machines/mac.md) - For MacBook Pro systems
- [WSL2](machines/wsl.md) - For Windows Subsystem for Linux

## Basic Commands

### NixOS System Configuration

```bash
# Apply system configuration
sudo nixos-rebuild switch \
  --flake github:kuznero/dotfiles#<machine-name> \
  --impure
```

### Home Manager Configuration

```bash
# First time setup
nix run home-manager/master -- switch \
  --flake github:kuznero/dotfiles#<machine-name>

# Subsequent updates
home-manager switch --flake github:kuznero/dotfiles#<machine-name>
```

Replace `<machine-name>` with your specific machine configuration (devos, moon,
sun, mac, or wsl).

## Next Steps

- Review the [System Architecture](architecture.md) to understand how
configurations are organized
- Check [Troubleshooting](troubleshooting.md) if you encounter any issues
- Explore individual [Machine Configurations](machines/index.md) for detailed
setup instructions
