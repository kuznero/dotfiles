# Roku Labs Dotfiles

## Prerequisites

```bash
# install nix package manager (assume done)

# install home-manager from master
nix-channel --add https://github.com/nix-community/home-manager/archive/master.tar.gz home-manager
nix-channel --update
nix-shell '<home-manager>' -A install
```

## Apply configuration

> Choose the right target, e.g. `#moon` or `#mac`.

```bash
# NixOS managed moon server
sudo nixos-rebuild switch --flake .#moon --impure
home-manager switch --flake .#moon --impure

# MacOS
home-manager switch -flake .#mac --impure
```
