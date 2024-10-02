#!/usr/bin/env bash

SELF=$(readlink -f "$0")
ROOT=$(dirname "${SELF}")

command -v nix >/dev/null 2>&1 || {
  echo "[error] nix is not found"
  exit 1
}

command -v nix-channel >/dev/null 2>&1 || {
  echo "[error] nix-channel is not found"
  exit 1
}

command -v nix-shell >/dev/null 2>&1 || {
  echo "[error] nix-shell is not found"
  exit 1
}

nix-channel --list | grep -q home-manager || {
  echo "[info] Adding home-manager channel"
  nix-channel --add https://github.com/nix-community/home-manager/archive/master.tar.gz home-manager
  nix-channel --update
  nix-channel --list
  echo
}

command -v home-manager >/dev/null 2>&1 || {
  echo "[info] Installing home-manager"
  nix-shell '<home-manager>' -A install
  echo
}

echo "[info] Updating home-manager configuration"
if [ -d $HOME/.config/home-manager ]; then
  rm -rf $HOME/.config/home-manager >/dev/null 2>&1
fi
mkdir -p $HOME/.config/home-manager >/dev/null 2>&1
cp -r $ROOT/dotfiles $HOME/.config/home-manager/dotfiles >/dev/null 2>&1
cp $ROOT/*.nix $HOME/.config/home-manager/ >/dev/null 2>&1
echo

set -e

echo "[info] Building home-manager configuration"
home-manager build
echo

echo "[info] Switching home-manager configuration"
home-manager switch -b backup
echo
