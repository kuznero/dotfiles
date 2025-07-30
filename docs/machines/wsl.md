<!-- markdownlint-disable MD029 -->

# WSL2 Configuration

Windows Subsystem for Linux configuration with corporate environment support.

## Overview

WSL configuration provides a full Linux development environment within Windows,
with special handling for corporate proxies and certificates.

## Prerequisites

- Windows 10/11 with WSL2 enabled
- PowerShell with administrator access
- Corporate proxy settings (if applicable)
- Nix with flakes enabled

## Initial WSL Setup

### Check Installed Distributions

```powershell
wsl -l -v
```

### Install NixOS on WSL2

Follow the [official NixOS-WSL installation guide](https://nix-community.github.io/NixOS-WSL/install.html).

## Corporate Environment Setup

### Certificate Configuration

For corporate environments with custom CA certificates:

1. Create the certificate file:

```bash
cat <<EOF | sudo tee /etc/pki/tls/certs/ca-zscaler.crt
-----BEGIN CERTIFICATE-----
[Your corporate CA certificate here]
-----END CERTIFICATE-----
EOF
```

2. Append default CA certificates:

```bash
cat /etc/ssl/certs/ca-certificates.crt | \
  sudo tee --append /etc/pki/tls/certs/ca-zscaler.crt
```

3. Update `/etc/nixos/configuration.nix`:

```nix
{
  security.pki.certificateFiles = [ /etc/pki/tls/certs/ca-zscaler.crt ];
  environment.variables = {
    "NIX_SSL_CERT_FILE" = "/etc/pki/tls/certs/ca-zscaler.crt";
  };
  security.sudo.extraConfig = ''
    Defaults env_keep += "NIX_SSL_CERT_FILE"
  '';
}
```

4. Apply the configuration:

```bash
sudo -E NIX_SSL_CERT_FILE=/etc/pki/tls/certs/ca-zscaler.crt nixos-rebuild switch
```

### Update Nix Channels

```bash
sudo nix-channel --update
```

## Apply Dotfiles Configuration

### System Configuration

```bash
sudo nixos-rebuild switch --flake github:kuznero/dotfiles#wsl --impure
```

### Home Manager Configuration

```bash
# First time
nix run home-manager/master -- switch --flake github:kuznero/dotfiles#wsl

# Subsequent updates
home-manager switch --flake github:kuznero/dotfiles#wsl
```

## Configuration Details

### WSL-Specific Features

- Integration with Windows filesystem
- Clipboard sharing with Windows
- Network proxy handling
- Corporate certificate management

### Included Modules

System:

- Docker support
- Flatpak applications
- GnuPG for encryption

Home Manager:

- Development tools
- Terminal configuration
- Git with Windows credential helper
- Text editors (Nixvim, VS Code via Windows)
- Note-taking (Obsidian)
- File comparison (Beyond Compare)

### Development Environment

Optimized for WSL2:

- Smaller AI models (1.5b) for resource efficiency
- Terminal-based workflow
- Integration with Windows tools

## Windows Integration

### Accessing Windows Files

Windows drives are mounted under `/mnt/`:

```bash
# Access C: drive
cd /mnt/c/Users/YourUsername
```

### Running Windows Programs

```bash
# Open file in Windows
explorer.exe .

# Use Windows VS Code
code.exe .
```

### GUI Applications

For GUI applications in WSL2:

1. Install an X server on Windows (e.g., VcXsrv, WSLg)
2. Configure display environment
3. Run Linux GUI applications

## Troubleshooting

### Certificate Errors

If you encounter SSL certificate errors:

1. Verify corporate certificate is correctly installed
2. Check `NIX_SSL_CERT_FILE` environment variable
3. Ensure proxy settings are configured

### Performance

For better performance:

1. Store projects in Linux filesystem, not `/mnt/c`
2. Adjust WSL2 memory limits in `.wslconfig`
3. Use native Linux tools when possible

### Network Issues

Corporate networks may require:

1. Proxy configuration in shell profile
2. DNS resolver adjustments
3. VPN client configuration

## Customization

### Default User

Change the default WSL user by modifying `wsl.defaultUser` in `/etc/nixos/configuration.nix`.
