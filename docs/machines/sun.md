# Sun Server Configuration

GitHub Actions runner server for CI/CD workflows on x86_64-linux.

## Overview

Sun is a headless server configuration designed to run GitHub Actions workflows
and provide development services.

## Prerequisites

- x86_64 server hardware
- Network connectivity
- GitHub account with repository access
- Nix with flakes enabled

## Installation

### System Configuration

Apply the NixOS configuration:

```bash
sudo nixos-rebuild switch --flake github:kuznero/dotfiles#sun --impure
```

Note: Sun does not include a Home Manager configuration as it's designed for
server use.

## Configuration Details

### Server Role

- GitHub Actions self-hosted runner
- OnlyOffice document server
- Docker host for containerized services

### Included Features

System modules:

- Docker support for running containers
- Enhanced login daemon configuration
- GitHub Actions runner service
- OnlyOffice server for document collaboration

### GitHub Runner Setup

The server includes GitHub Actions runner configuration. After initial setup:

1. Register the runner with your GitHub repository/organization
2. Configure runner tokens and labels
3. The runner service will start automatically

### OnlyOffice Server

Provides:

- Document collaboration features
- Office file format support
- Web-based document editing

### System Management

- Headless operation (no desktop environment)
- Remote access via SSH
- Automated service management
- System logging and monitoring

## Security Considerations

1. Configure firewall rules for exposed services
2. Set up proper authentication for OnlyOffice
3. Secure GitHub runner tokens
4. Regular security updates via Nix

## Maintenance

### Updating Services

```bash
# Update system configuration
sudo nixos-rebuild switch --flake github:kuznero/dotfiles#sun --impure

# Check service status
systemctl status github-runner
systemctl status docker
```

### Docker Management

The server includes Docker for running containerized workloads:

```bash
# List running containers
docker ps

# View Docker logs
docker logs <container-name>
```

## Use Cases

- CI/CD pipeline execution
- Document server hosting
- Container development and testing
- Background job processing
