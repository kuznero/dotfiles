#!/usr/bin/env bash

set -euo pipefail

# Determine the script's directory and package path
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PKG_DIR="${SCRIPT_DIR}"
DEFAULT_NIX="${PKG_DIR}/default.nix"
PACKAGE_LOCK="${PKG_DIR}/package-lock.json"

# If we're running from repo root, adjust paths
if [[ ! -f "${DEFAULT_NIX}" ]]; then
  PKG_DIR="home-manager/programs/pkgs/ccusage"
  DEFAULT_NIX="${PKG_DIR}/default.nix"
  PACKAGE_LOCK="${PKG_DIR}/package-lock.json"

  if [[ ! -f "${DEFAULT_NIX}" ]]; then
    echo "❌ Error: Cannot find ccusage package directory"
    echo "   Please run from repository root or ccusage directory"
    exit 1
  fi
fi

echo "🔄 Updating ccusage package..."
echo "   Package directory: ${PKG_DIR}"

# Get latest version from npm
echo "📦 Fetching latest version from npm..."
CURRENT_VERSION=$(grep -oP 'version = "\K[^"]+' "${DEFAULT_NIX}")
LATEST_VERSION=$(npm view ccusage version)
echo "   Versions: $CURRENT_VERSION -> $LATEST_VERSION"

if [ "$LATEST_VERSION" = "$CURRENT_VERSION" ]; then
  echo "✅ Already up to date!"
  exit 0
fi

echo ""
echo "📝 Updating to version $LATEST_VERSION..."

# Update version in default.nix
sed -i "s/version = \".*\"/version = \"$LATEST_VERSION\"/" "${DEFAULT_NIX}"

# Generate updated package-lock.json
echo "🔧 Generating new package-lock.json..."
cd "${PKG_DIR}"
npm i --package-lock-only ccusage@"$LATEST_VERSION"
rm -f package.json
cd - > /dev/null

# Fetch new source hash
echo "🔍 Fetching new source hash..."
URL="https://registry.npmjs.org/ccusage/-/ccusage-${LATEST_VERSION}.tgz"
# Note: ccusage uses fetchurl (not fetchzip), so we don't use --unpack
HASH_OUTPUT=$(nix-prefetch-url "$URL" 2>/dev/null | tail -n1)
NEW_HASH=$(nix hash convert --hash-algo sha256 --to sri "$HASH_OUTPUT")

# Update hash in default.nix
echo "   New source hash: $NEW_HASH"
sed -i "s|hash = \"sha256-.*\"|hash = \"$NEW_HASH\"|" "${DEFAULT_NIX}"

# Update npm dependencies hash
echo "📦 Building to get new npm dependencies hash..."
echo "   (This may take a moment...)"

# Try to build and capture the new npmDepsHash
BUILD_OUTPUT=$(cd "${PKG_DIR}" && nix-build -E 'with import <nixpkgs> {}; callPackage ./default.nix {}' 2>&1 || true)
if echo "$BUILD_OUTPUT" | grep -q "got:    sha256-"; then
  NEW_NPM_HASH=$(echo "$BUILD_OUTPUT" | grep -oP 'got:\s+\Ksha256-[^\s]+')
  echo "   New npmDepsHash: $NEW_NPM_HASH"
  sed -i "s|npmDepsHash = \"sha256-.*\"|npmDepsHash = \"$NEW_NPM_HASH\"|" "${DEFAULT_NIX}"

  # Build again to verify
  echo "🔨 Verifying build..."
  if (cd "${PKG_DIR}" && nix-build -E 'with import <nixpkgs> {}; callPackage ./default.nix {}' > /dev/null 2>&1); then
    echo "✅ Successfully updated ccusage to version $LATEST_VERSION!"
  else
    echo "⚠️  Build failed, but files have been updated. May need manual adjustment."
  fi
else
  echo "⚠️  Couldn't automatically determine npmDepsHash."
  echo "   You'll need to build manually and update the hash."
fi
