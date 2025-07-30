# Roku Labs Dotfiles

Welcome to the Roku Labs Dotfiles documentation. This repository contains
Nix-based system and home configurations for various machines.

## Overview

This dotfiles repository uses:

- **Nix Flakes** for reproducible system configurations
- **NixOS** for Linux system configurations
- **Home Manager** for user environment management
- **Support for multiple platforms**: Linux (x86_64, aarch64), macOS (aarch64),
and WSL2

## Quick Links

- [Getting Started](getting-started.md) - Prerequisites and initial setup
- [Machine Configurations](machines/index.md) - Configuration profiles for
different machines
- [System Architecture](architecture.md) - Understanding the repository structure
- [Troubleshooting](troubleshooting.md) - Common issues and solutions

## Supported Systems

| Machine | Platform | Type | Description |
|---------|----------|------|-------------|
| DevOS | `aarch64-linux` | Virtual Machine | Development environment VM |
| Moon | `x86_64-linux` | Laptop | Lenovo laptop configuration |
| Sun | `x86_64-linux` | Server | GitHub Runner server |
| Mac | `aarch64-darwin` | Laptop | MacBook Pro configuration |
| WSL | `x86_64-linux` | WSL2 | Windows Subsystem for Linux |
