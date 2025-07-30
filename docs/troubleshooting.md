<!-- markdownlint-disable MD029 -->

# Troubleshooting

Common issues and solutions for Roku Labs dotfiles.

## Installation Issues

### Nix Command Not Found

**Problem**: `nix` command is not available after installation.

**Solution**:

1. Ensure Nix is properly installed
2. Source the Nix profile:

```bash
. ~/.nix-profile/etc/profile.d/nix.sh
```

3. Verify experimental features are enabled in `~/.config/nix/nix.conf`

### Flake Not Found

**Problem**: Error about flake not being found when running nixos-rebuild.

**Solution**:

1. Ensure you're using the correct flake reference
2. Check network connectivity
3. Try with `--refresh` flag:

```bash
sudo nixos-rebuild switch \
  --flake github:kuznero/dotfiles#machine \
  --impure --refresh
```

## Configuration Issues

### Home Manager Conflicts

**Problem**: Home Manager reports conflicts with existing files.

**Solution**:

1. Back up conflicting files
2. Remove or rename them
3. Re-run Home Manager switch
4. Or use `--backup` flag to automatically backup conflicts

### Certificate Errors (Corporate/WSL)

**Problem**: SSL certificate verification failures.

**Solution**:

1. Ensure corporate certificates are properly installed
2. Set `NIX_SSL_CERT_FILE` environment variable
3. For WSL, follow the certificate setup in [WSL documentation](machines/wsl.md)

### Permission Denied

**Problem**: Permission errors when running commands.

**Solution**:

1. Use `sudo` for system-level operations
2. Ensure your user is in necessary groups (docker, wheel)
3. Check file ownership in your home directory

## Runtime Issues

### Applications Not Found

**Problem**: Installed applications not in PATH.

**Solution**:

1. Reload your shell or start a new session
2. Check if the application is in the correct profile:

```bash
which <application>
nix-env -q | grep <application>
```

3. Ensure Home Manager activation was successful

### Theme/Font Issues

**Problem**: Applications not using Catppuccin theme or fonts look wrong.

**Solution**:

1. Restart the application
2. Check GTK/Qt theme settings
3. Verify fonts are installed:

```bash
fc-list | grep -i "font-name"
```

4. Log out and back in for desktop environment changes

### Yabai Not Working (macOS)

**Problem**: Yabai fails to manage windows.

**Solution**:

1. Grant accessibility permissions in System Preferences
2. Check if SIP needs to be partially disabled
3. Restart yabai service:

```bash
brew services restart yabai
```

## Performance Issues

### Slow Nix Operations

**Problem**: Nix commands take a long time.

**Solution**:

1. Use binary caches:

```bash
nix-env --option binary-caches https://cache.nixos.org
```

2. Clean old generations:

```bash
nix-collect-garbage -d
```

3. Optimize nix store:

```bash
nix-store --optimise
```

### High Memory Usage

**Problem**: System using too much memory.

**Solution**:

1. Check running services
2. Disable unused modules in configuration
3. For WSL2, adjust memory limits in `.wslconfig`
4. Use smaller AI models (1.5b instead of 7b)

## Debugging Tips

### Enable Verbose Output

```bash
# For nixos-rebuild
sudo nixos-rebuild switch --flake .#machine --show-trace

# For home-manager
home-manager switch --flake .#machine --show-trace
```

### Check Logs

```bash
# System logs
journalctl -xe

# Service-specific logs
journalctl -u <service-name>

# Home Manager activation log
cat ~/.config/home-manager/home-manager.log
```

### Rollback Changes

```bash
# List generations
sudo nix-env --list-generations

# Rollback system
sudo nixos-rebuild switch --rollback

# Rollback home-manager
home-manager generations
home-manager rollback
```

## Getting Help

If you encounter issues not covered here:

1. Check the [Nix manual](https://nixos.org/manual/nix/stable/)
2. Visit [NixOS Discourse](https://discourse.nixos.org/)
3. Search existing [GitHub issues](https://github.com/kuznero/dotfiles/issues)
4. Create a new issue with:
   - Error messages
   - System information
   - Steps to reproduce

