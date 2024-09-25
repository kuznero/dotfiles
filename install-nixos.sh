#!/usr/bin/env bash

SELF=$(readlink -f "$0")
ROOT=$(dirname "${SELF}")

sudo nix-channel --list | grep -q nixos-unstable || {
  sudo nix-channel --add https://nixos.org/channels/nixos-unstable nixos-unstable
  sudo nix-channel --list
  sudo nix-channel --update
}

sudo stow -R --override='.*' -d "${ROOT}" -t /etc/nixos nixos
sudo nixos-rebuild switch
