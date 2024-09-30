#!/usr/bin/env bash

SELF=$(readlink -f "$0")
ROOT=$(dirname "${SELF}")

stow -R --override='.*' -d "${ROOT}" -t "${HOME}" home
grep -qxF 'source ~/.zshrc_ext' ~/.zshrc || echo 'source ~/.zshrc_ext' >> ~/.zshrc

