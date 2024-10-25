# Roku Labs Dotfiles

> `.#moon` can be replaced with other hosts supported.

## Deploy OS setup to the Moon laptop (NixOS configuration)

```bash
# build
sudo nixos-rebuild build --flake .#moon --impure

# or switch
sudo nixos-rebuild switch --flake .#moon --impure
```

## Deploy user setup to the Moon laptop (Home Manager configuration)

```bash
# build
home-manager build --flake .#moon

# or switch
home-manager switch --flake .#moon
```

