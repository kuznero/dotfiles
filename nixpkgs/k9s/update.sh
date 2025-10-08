#!/usr/bin/env bash

set -euo pipefail

# Detect OS for sed compatibility
if [[ "$OSTYPE" == "darwin"* ]]; then
  SED_INPLACE="sed -i ''"
else
  SED_INPLACE="sed -i"
fi

# Determine the script's directory and package path
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PKG_DIR="${SCRIPT_DIR}"
DEFAULT_NIX="${PKG_DIR}/default.nix"

# If we're running from repo root, adjust paths
if [[ ! -f "${DEFAULT_NIX}" ]]; then
  PKG_DIR="nixpkgs/k9s"
  DEFAULT_NIX="${PKG_DIR}/default.nix"

  if [[ ! -f "${DEFAULT_NIX}" ]]; then
    echo "❌ Error: Cannot find k9s package directory"
    echo "   Please run from repository root or k9s directory"
    exit 1
  fi
fi

echo "🔄 Updating k9s package..."
echo "   Package directory: ${PKG_DIR}"

# Get latest version from GitHub API
echo "📦 Fetching latest version from GitHub..."
LATEST_RELEASE=$(curl -s https://api.github.com/repos/derailed/k9s/releases/latest)
LATEST_VERSION=$(echo "$LATEST_RELEASE" | sed -n 's/.*"tag_name":[[:space:]]*"v\([^"]*\)".*/\1/p')

if [ -z "$LATEST_VERSION" ]; then
  echo "❌ Error: Could not fetch latest version from GitHub"
  exit 1
fi

CURRENT_VERSION=$(sed -n 's/.*version = "\([^"]*\)".*/\1/p' "${DEFAULT_NIX}")
echo "   Versions: $CURRENT_VERSION -> $LATEST_VERSION"

if [ "$LATEST_VERSION" = "$CURRENT_VERSION" ]; then
  echo "✅ Already up to date!"
  exit 0
fi

echo ""
echo "📝 Updating to version $LATEST_VERSION..."

# Update version in default.nix
eval "$SED_INPLACE \"s/version = \\\".*\\\"/version = \\\"$LATEST_VERSION\\\"/\" \"${DEFAULT_NIX}\""

# Fetch new source hash for GitHub
echo "🔍 Fetching new source hash..."
OWNER="derailed"
REPO="k9s"
REV="v${LATEST_VERSION}"

# Use nix-prefetch-github or nix-prefetch-url
TEMP_OUTPUT=$(mktemp)
nix-prefetch-url --unpack "https://github.com/${OWNER}/${REPO}/archive/${REV}.tar.gz" 2>/dev/null > "$TEMP_OUTPUT"
HASH=$(tail -n1 "$TEMP_OUTPUT")
NEW_HASH=$(nix hash convert --hash-algo sha256 --to sri "$HASH")
rm -f "$TEMP_OUTPUT"

# Update hash in default.nix
echo "   New source hash: $NEW_HASH"
eval "$SED_INPLACE \"s|hash = \\\"sha256-.*\\\"|hash = \\\"$NEW_HASH\\\"|\" \"${DEFAULT_NIX}\""

# Update vendor hash for Go modules
echo "📦 Building to get new vendorHash..."
echo "   (This may take a moment...)"

# Try to build and capture the new vendorHash
# Check if nix-build is available
if ! command -v nix-build &> /dev/null; then
  echo "❌ Error: nix-build command not found. Cannot update vendorHash."
  echo "   Please ensure Nix is installed in the build environment."
  exit 1
fi

# Temporarily set vendorHash to empty string to force hash mismatch error
eval "$SED_INPLACE \"s|vendorHash = \\\".*\\\"|vendorHash = \\\"\\\"|\" \"${DEFAULT_NIX}\""

# First, try with <nixpkgs> if available
BUILD_OUTPUT=$(cd "${PKG_DIR}" && nix-build -E 'with import <nixpkgs> {}; callPackage ./default.nix {}' 2>&1 || true)

# If <nixpkgs> is not available, try using a pinned nixpkgs from GitHub
if echo "$BUILD_OUTPUT" | grep -q "while calling the 'findFile' builtin"; then
  echo "   <nixpkgs> not found, trying with pinned nixpkgs..."
  BUILD_OUTPUT=$(cd "${PKG_DIR}" && nix-build -E '
    let
      pkgs = import (fetchTarball "https://github.com/NixOS/nixpkgs/archive/nixpkgs-unstable.tar.gz") {};
    in pkgs.callPackage ./default.nix {}' 2>&1 || true)
fi
if echo "$BUILD_OUTPUT" | grep -q "got:    sha256-"; then
  NEW_VENDOR_HASH=$(echo "$BUILD_OUTPUT" | sed -n 's/.*got:[[:space:]]*\(sha256-[^[:space:]]*\).*/\1/p')
  echo "   New vendorHash: $NEW_VENDOR_HASH"
  eval "$SED_INPLACE \"s|vendorHash = \\\".*\\\"|vendorHash = \\\"$NEW_VENDOR_HASH\\\"|\" \"${DEFAULT_NIX}\""

  # Build again to verify
  echo "🔨 Verifying build..."
  # Try with <nixpkgs> first, fallback to pinned nixpkgs
  if (cd "${PKG_DIR}" && nix-build -E 'with import <nixpkgs> {}; callPackage ./default.nix {}' > /dev/null 2>&1); then
    echo "✅ Successfully updated k9s to version $LATEST_VERSION!"
  elif (cd "${PKG_DIR}" && nix-build -E '
    let
      pkgs = import (fetchTarball "https://github.com/NixOS/nixpkgs/archive/nixpkgs-unstable.tar.gz") {};
    in pkgs.callPackage ./default.nix {}' > /dev/null 2>&1); then
    echo "✅ Successfully updated k9s to version $LATEST_VERSION!"
  else
    echo "❌ Error: Build verification failed after updating vendorHash."
    exit 1
  fi
else
  echo "❌ Error: Could not determine vendorHash from build output."
  echo "   Build output did not contain expected hash format."
  echo ""
  echo "Build output:"
  echo "$BUILD_OUTPUT"
  exit 1
fi
