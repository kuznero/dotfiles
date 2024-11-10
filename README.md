# Roku Labs Dotfiles

## Prerequisites

```bash
# enable experimental features
mkdir -p ~/.config/nix
cat <<EOF > ~/.config/nix/nix.conf
experimental-features = flakes nix-command
EOF

# install nix package manager (assume done)
```

## Apply configuration

### DevOS Virtual Machine (`aarch64-linux`)

```bash
sudo nixos-rebuild switch --flake gitlab:roku-labs/dotfiles#devos --impure
nix run home-manager/master -- switch --flake gitlab:roku-labs/dotfiles#devos
# home-manager switch --flake gitlab:roku-labs/dotfiles#devos
```

### Moon Lenovo Laptop (`x86_64-linux`)

```bash
sudo nixos-rebuild switch --flake gitlab:roku-labs/dotfiles#moon --impure
nix run home-manager/master -- switch --flake gitlab:roku-labs/dotfiles#moon
# home-manager switch --flake gitlab:roku-labs/dotfiles#moon
```

### Sun GitLab Runner Server (`x86_64-linux`)

```bash
sudo nixos-rebuild switch --flake gitlab:roku-labs/dotfiles#sun --impure
```

### Roman's MacBook Pro Laptop (`aarch64-darwin`)

```bash
nix run home-manager/master -- switch --flake gitlab:roku-labs/dotfiles#mac
# home-manager switch --flake gitlab:roku-labs/dotfiles#mac
```

### WSL2 (`x86_64-linux`)

> Make sure to update custom CA certificate according to your company settings.

```bash
cat <<EOF | sudo tee /etc/pki/tls/certs/ca-zscaler.crt
-----BEGIN CERTIFICATE-----
...
-----END CERTIFICATE-----
EOF

sudo nixos-rebuild switch --flake .#wsl --impure
nix run home-manager/master -- switch --flake gitlab:roku-labs/dotfiles#wsl
# home-manager switch --flake gitlab:roku-labs/dotfiles#wsl
```
