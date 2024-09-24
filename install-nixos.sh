#!/usr/bin/env bash

SELF=$(readlink -f "$0")
ROOT=$(dirname "${SELF}")

sudo stow -d "${ROOT}" -t /etc/nixos nixos --adopt
sudo nixos-rebuild switch
