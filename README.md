# Roku Labs Dotfiles

> `.#moon` can be replaced with other hosts supported.

## Deploy OS setup to the Moon laptop (NixOS configuration)

```bash
# build
sudo nixos-rebuild build --flake gitlab:roku-labs/dotfiles#moon --impure

# or switch
sudo nixos-rebuild switch --flake gitlab:roku-labs/dotfiles#moon --impure
```

## Deploy user setup to the Moon laptop (Home Manager configuration)

```bash
# build
home-manager build --flake gitlab:roku-labs/dotfiles#moon

# or switch
home-manager switch --flake gitlab:roku-labs/dotfiles#moon
```

