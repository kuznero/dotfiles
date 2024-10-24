#!/usr/bin/env bash

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

command -v home-manager >/dev/null 2>&1 && {
  echo "[info] Un-installing home-manager"
  nix-env --uninstall home-manager-path
  echo
}

nix-channel --list | grep -q home-manager && {
  echo "[info] Removing home-manager channel"
  nix-channel --remove home-manager
  nix-channel --update
  nix-channel --list
  echo
}
