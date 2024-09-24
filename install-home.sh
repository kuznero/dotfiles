#!/usr/bin/env bash

SELF=$(readlink -f "$0")
ROOT=$(dirname "${SELF}")

stow -d "${ROOT}" -t "${HOME}" home --adopt
