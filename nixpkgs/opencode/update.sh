#!/usr/bin/env bash

set -euo pipefail

# Helper function for sed in-place editing (macOS compatible)
sed_inplace() {
  if [[ "$OSTYPE" == "darwin"* ]]; then
    sed -i '' "$@"
  else
    sed -i "$@"
  fi
}

# Determine the script's directory and package path
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PKG_DIR="${SCRIPT_DIR}"
DEFAULT_NIX="${PKG_DIR}/default.nix"

# If we're running from repo root, adjust paths
if [[ ! -f "${DEFAULT_NIX}" ]]; then
  PKG_DIR="nixpkgs/opencode"
  DEFAULT_NIX="${PKG_DIR}/default.nix"

  if [[ ! -f "${DEFAULT_NIX}" ]]; then
    echo "Error: Cannot find opencode package directory"
    echo "   Please run from repository root or opencode directory"
    exit 1
  fi
fi

echo "Updating opencode package..."
echo "   Package directory: ${PKG_DIR}"

echo "Fetching latest version from GitHub..."
CURRENT_VERSION=$(sed -n 's/.*version = "\([^"]*\)".*/\1/p' "${DEFAULT_NIX}" | head -1)
LATEST_VERSION=$(curl -sL "https://api.github.com/repos/anomalyco/opencode/releases/latest" | grep '"tag_name"' | sed 's/.*"v\([^"]*\)".*/\1/')

if [ -z "$LATEST_VERSION" ]; then
  echo "Error: Could not fetch latest version from GitHub"
  exit 1
fi

echo "   Versions: $CURRENT_VERSION -> $LATEST_VERSION"

if [ "$LATEST_VERSION" = "$CURRENT_VERSION" ]; then
  echo "Already up to date!"
  exit 0
fi

echo ""
echo "Updating to version $LATEST_VERSION..."

# Update version in default.nix (first occurrence only)
if [[ "$OSTYPE" == "darwin"* ]]; then
  sed -i '' "1,/version = \".*\"/s/version = \".*\"/version = \"$LATEST_VERSION\"/" "${DEFAULT_NIX}"
else
  sed -i "0,/version = \".*\"/s/version = \".*\"/version = \"$LATEST_VERSION\"/" "${DEFAULT_NIX}"
fi

# Fetch new source hash
echo "Fetching new source hash..."
NEW_SRC_HASH=""

# Try nix-prefetch-github first if available
if command -v nix-prefetch-github &> /dev/null; then
  NEW_SRC_HASH=$(nix-prefetch-github anomalyco opencode --rev "v${LATEST_VERSION}" 2>/dev/null | grep '"hash"' | sed 's/.*"\(sha256-[^"]*\)".*/\1/' || true)
fi

if [ -z "$NEW_SRC_HASH" ]; then
  # Fallback: use nix-prefetch-url
  URL="https://github.com/anomalyco/opencode/archive/refs/tags/v${LATEST_VERSION}.tar.gz"
  TEMP_HASH=$(nix-prefetch-url --unpack "$URL" 2>/dev/null)
  if [ -n "$TEMP_HASH" ]; then
    NEW_SRC_HASH=$(nix hash convert --hash-algo sha256 --to sri "$TEMP_HASH")
  fi
fi

if [ -z "$NEW_SRC_HASH" ]; then
  echo "Error: Could not determine source hash"
  exit 1
fi

echo "   New source hash: $NEW_SRC_HASH"

# Update source hash in default.nix (in the src fetchFromGitHub block)
sed_inplace "/fetchFromGitHub/,/};/s|hash = \"sha256-[^\"]*\"|hash = \"$NEW_SRC_HASH\"|" "${DEFAULT_NIX}"

echo ""
echo "Source updated. Now attempting to update node_modules hash..."
echo "(This requires building the package to get the correct hash)"

# Set outputHash to empty to force hash mismatch
CURRENT_OUTPUT_HASH=$(grep 'outputHash = "sha256-' "${DEFAULT_NIX}" | head -1 | sed 's/.*"\(sha256-[^"]*\)".*/\1/')
sed_inplace 's|outputHash = "sha256-[^"]*"|outputHash = ""|' "${DEFAULT_NIX}"

# Try to build and capture the new outputHash
echo "Building to get new node_modules hash..."
BUILD_OUTPUT=$(cd "${PKG_DIR}" && nix-build -E '
  let
    pkgs = import (fetchTarball "https://github.com/NixOS/nixpkgs/archive/nixos-unstable.tar.gz") {};
  in (pkgs.callPackage ./default.nix {}).node_modules' 2>&1 || true)

if echo "$BUILD_OUTPUT" | grep -q "got:    sha256-"; then
  NEW_OUTPUT_HASH=$(echo "$BUILD_OUTPUT" | sed -n 's/.*got:[[:space:]]*\(sha256-[^[:space:]]*\).*/\1/p')
  echo "   New node_modules hash: $NEW_OUTPUT_HASH"
  sed_inplace "s|outputHash = \"\"|outputHash = \"$NEW_OUTPUT_HASH\"|" "${DEFAULT_NIX}"
else
  echo "Warning: Could not determine new node_modules hash automatically."
  echo "   Restoring previous hash: $CURRENT_OUTPUT_HASH"
  sed_inplace "s|outputHash = \"\"|outputHash = \"$CURRENT_OUTPUT_HASH\"|" "${DEFAULT_NIX}"
  echo ""
  echo "   To update manually:"
  echo "   1. Set outputHash = \"\" in default.nix"
  echo "   2. Run: nix-build -E 'with import <nixpkgs> {}; (callPackage ./default.nix {}).node_modules'"
  echo "   3. Copy the 'got: sha256-...' hash from the error message"
  echo "   4. Update outputHash in default.nix with the new hash"
fi

echo ""
echo "Verifying build..."
if (cd "${PKG_DIR}" && nix-build -E '
  let
    pkgs = import (fetchTarball "https://github.com/NixOS/nixpkgs/archive/nixos-unstable.tar.gz") {};
  in pkgs.callPackage ./default.nix {}' > /dev/null 2>&1); then
  echo "Successfully updated opencode to version $LATEST_VERSION!"
else
  echo "Warning: Build verification failed. You may need to update hashes manually."
  echo "   Run the build command above to see the actual error."
fi
