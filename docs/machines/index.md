# Machine Configurations

This section contains detailed setup instructions for each supported machine configuration.

## Available Configurations

### Linux Systems

- **[DevOS](devos.md)** - Development virtual machine running on aarch64 architecture
- **[Moon](moon.md)** - Lenovo ThinkPad X1 laptop configuration with full
desktop environment
- **[Sun](sun.md)** - GitHub Actions runner server for CI/CD workflows
- **[WSL2](wsl.md)** - Windows Subsystem for Linux with corporate environment support

### macOS Systems

- **[Mac](mac.md)** - MacBook Pro configuration with yabai window manager

## Configuration Features

Each machine configuration includes:

- Base system configuration
- Hardware-specific optimizations
- Selected desktop environment (where applicable)
- Development tools and utilities
- Custom packages and scripts

## Choosing a Configuration

Select your configuration based on:

1. **Hardware Platform**: Ensure architecture compatibility (x86_64 vs aarch64)
2. **Use Case**: Development workstation, server, or hybrid
3. **Environment**: Native Linux, macOS, or virtualized (WSL2)
4. **Features**: Desktop environment needs, development tools, etc.

## Common Patterns

All configurations share:

- Nix flakes for reproducibility
- Catppuccin theming
- Core development tools
- Git configuration
- Shell environment (zsh)

Machine-specific variations include desktop environments, hardware drivers, and
specialized tools.
