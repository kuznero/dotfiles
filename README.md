# Roku Labs Dotfiles

## Prerequisites

```bash
# enable experimental features
mkdir -p ~/.config/nix
cat <<EOF > ~/.config/nix/nix.conf
experimental-features = flakes nix-command
EOF

# install nix package manager (assume done)

# install home-manager from master
nix-channel --add https://github.com/nix-community/home-manager/archive/master.tar.gz home-manager
nix-channel --update

# on non-NixOS
nix-shell '<home-manager>' -A install

# on NixOS
nix-env -iA nixos.home-manager
```

## Apply configuration

> Choose the right target, e.g. `#moon` or `#mac`.

```bash
# NixOS managed moon server (x86_64-linux)
sudo nixos-rebuild switch --flake .#moon --impure
home-manager switch --flake .#moon

# NixOS managed devos server (aarch64-linux)
sudo nixos-rebuild switch --flake .#devos --impure
home-manager switch --flake .#devos

# NixOS managed sun server (x86_64-linux)
sudo nixos-rebuild switch --flake .#sun --impure

# MacOS
home-manager switch -flake .#mac
```
