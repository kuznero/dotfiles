# Roku Labs Dotfiles

## Prerequisites

```bash
# enable experimental features
mkdir -p ~/.config/nix
cat <<EOF > ~/.config/nix/nix.conf
experimental-features = flakes nix-command
EOF

# install nix package manager (assume done)

# install home-manager on non-NixOS
nix-channel --add https://github.com/nix-community/home-manager/archive/master.tar.gz home-manager
nix-channel --update
nix-shell '<home-manager>' -A install

# install home-manager on NixOS
nix-env -iA nixos.home-manager
```

## Apply configuration

> Make sure to have `git` installed before running following commands, e.g. with `nix-shell -p git`.

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
