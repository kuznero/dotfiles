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
PACKAGE_LOCK="${PKG_DIR}/package-lock.json"

# If we're running from repo root, adjust paths
if [[ ! -f "${DEFAULT_NIX}" ]]; then
  PKG_DIR="nixpkgs/claude-code"
  DEFAULT_NIX="${PKG_DIR}/default.nix"
  PACKAGE_LOCK="${PKG_DIR}/package-lock.json"

  if [[ ! -f "${DEFAULT_NIX}" ]]; then
    echo "❌ Error: Cannot find claude-code package directory"
    echo "   Please run from repository root or claude-code directory"
    exit 1
  fi
fi

echo "🔄 Updating claude-code package..."
echo "   Package directory: ${PKG_DIR}"

echo "📦 Fetching latest version from npm..."
CURRENT_VERSION=$(sed -n 's/.*version = "\([^"]*\)".*/\1/p' "${DEFAULT_NIX}")
LATEST_VERSION=$(npm view @anthropic-ai/claude-code version)
echo "   Versions: $CURRENT_VERSION -> $LATEST_VERSION"

if [ "$LATEST_VERSION" = "$CURRENT_VERSION" ]; then
  echo "✅ Already up to date!"
  exit 0
fi

echo ""
echo "📝 Updating to version $LATEST_VERSION..."

# Update version in default.nix
eval "$SED_INPLACE \"s/version = \\\".*\\\"/version = \\\"$LATEST_VERSION\\\"/\" \"${DEFAULT_NIX}\""

# Generate updated package-lock.json
echo "🔧 Generating new package-lock.json..."
cd "${PKG_DIR}"
npm i --package-lock-only @anthropic-ai/claude-code@"$LATEST_VERSION"
rm -f package.json
cd - > /dev/null

# Fetch new source hash
echo "🔍 Fetching new source hash..."
URL="https://registry.npmjs.org/@anthropic-ai/claude-code/-/claude-code-${LATEST_VERSION}.tgz"
TEMP_DIR=$(mktemp -d)
CURRENT_DIR=$(pwd)
cd "$TEMP_DIR"
nix-prefetch-url --unpack "$URL" 2>/dev/null | tail -n1 > hash.txt
NEW_HASH=$(nix hash convert --hash-algo sha256 --to sri $(cat hash.txt))
cd "$CURRENT_DIR"
rm -rf "$TEMP_DIR"

# Update hash in default.nix
echo "   New source hash: $NEW_HASH"
eval "$SED_INPLACE \"s|hash = \\\"sha256-.*\\\"|hash = \\\"$NEW_HASH\\\"|\" \"${DEFAULT_NIX}\""

# Update npm dependencies hash
echo "📦 Building to get new npm dependencies hash..."
echo "   (This may take a moment...)"

# Try to build and capture the new npmDepsHash
# Check if nix-build is available
if ! command -v nix-build &> /dev/null; then
  echo "❌ Error: nix-build command not found. Cannot update npmDepsHash."
  echo "   Please ensure Nix is installed in the build environment."
  exit 1
fi

# Temporarily set npmDepsHash to empty string to force hash mismatch error
eval "$SED_INPLACE \"s|npmDepsHash = \\\".*\\\"|npmDepsHash = \\\"\\\"|\" \"${DEFAULT_NIX}\""

# First, try with <nixpkgs> if available
BUILD_OUTPUT=$(cd "${PKG_DIR}" && NIXPKGS_ALLOW_UNFREE=1 nix-build -E 'with import <nixpkgs> {}; callPackage ./default.nix {}' 2>&1 || true)

# If <nixpkgs> is not available, try using a pinned nixpkgs from GitHub
if echo "$BUILD_OUTPUT" | grep -q "while calling the 'findFile' builtin"; then
  echo "   <nixpkgs> not found, trying with pinned nixpkgs..."
  BUILD_OUTPUT=$(cd "${PKG_DIR}" && NIXPKGS_ALLOW_UNFREE=1 nix-build -E '
    let
      pkgs = import (fetchTarball "https://github.com/NixOS/nixpkgs/archive/nixpkgs-unstable.tar.gz") {};
    in pkgs.callPackage ./default.nix {}' 2>&1 || true)
fi
if echo "$BUILD_OUTPUT" | grep -q "got:    sha256-"; then
  NEW_NPM_HASH=$(echo "$BUILD_OUTPUT" | sed -n 's/.*got:[[:space:]]*\(sha256-[^[:space:]]*\).*/\1/p')
  echo "   New npmDepsHash: $NEW_NPM_HASH"
  eval "$SED_INPLACE \"s|npmDepsHash = \\\".*\\\"|npmDepsHash = \\\"$NEW_NPM_HASH\\\"|\" \"${DEFAULT_NIX}\""

  # Build again to verify
  echo "🔨 Verifying build..."
  # Try with <nixpkgs> first, fallback to pinned nixpkgs
  if (cd "${PKG_DIR}" && NIXPKGS_ALLOW_UNFREE=1 nix-build -E 'with import <nixpkgs> {}; callPackage ./default.nix {}' > /dev/null 2>&1); then
    echo "✅ Successfully updated claude-code to version $LATEST_VERSION!"
  elif (cd "${PKG_DIR}" && NIXPKGS_ALLOW_UNFREE=1 nix-build -E '
    let
      pkgs = import (fetchTarball "https://github.com/NixOS/nixpkgs/archive/nixpkgs-unstable.tar.gz") {};
    in pkgs.callPackage ./default.nix {}' > /dev/null 2>&1); then
    echo "✅ Successfully updated claude-code to version $LATEST_VERSION!"
  else
    echo "❌ Error: Build verification failed after updating npmDepsHash."
    exit 1
  fi
else
  echo "❌ Error: Could not determine npmDepsHash from build output."
  echo "   Build output did not contain expected hash format."
  echo ""
  echo "Build output:"
  echo "$BUILD_OUTPUT"
  exit 1
fi