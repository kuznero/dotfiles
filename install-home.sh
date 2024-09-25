#!/usr/bin/env bash

SELF=$(readlink -f "$0")
ROOT=$(dirname "${SELF}")

stow -R --override='.*' -d "${ROOT}" -t "${HOME}" home
