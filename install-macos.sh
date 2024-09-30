#!/usr/bin/env bash

SELF=$(readlink -f "$0")
ROOT=$(dirname "${SELF}")

pushd "${ROOT}/macos" >/dev/null 2>&1
nix run nix-darwin -- switch --flake .#$(scutil --get LocalHostName)
popd >/dev/null 2>&1
