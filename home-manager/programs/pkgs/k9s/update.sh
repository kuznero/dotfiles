#!/usr/bin/env bash

set -euo pipefail

# Determine the script's directory and package path
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PKG_DIR="${SCRIPT_DIR}"
DEFAULT_NIX="${PKG_DIR}/default.nix"

# If we're running from repo root, adjust paths
if [[ ! -f "${DEFAULT_NIX}" ]]; then
  PKG_DIR="home-manager/programs/pkgs/k9s"
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
LATEST_VERSION=$(echo "$LATEST_RELEASE" | grep -oP '"tag_name":\s*"v\K[^"]+')

if [ -z "$LATEST_VERSION" ]; then
  echo "❌ Error: Could not fetch latest version from GitHub"
  exit 1
fi

CURRENT_VERSION=$(grep -oP 'version = "\K[^"]+' "${DEFAULT_NIX}")
echo "   Versions: $CURRENT_VERSION -> $LATEST_VERSION"

if [ "$LATEST_VERSION" = "$CURRENT_VERSION" ]; then
  echo "✅ Already up to date!"
  exit 0
fi

echo ""
echo "📝 Updating to version $LATEST_VERSION..."

# Update version in default.nix
sed -i "s/version = \".*\"/version = \"$LATEST_VERSION\"/" "${DEFAULT_NIX}"

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
sed -i "s|hash = \"sha256-.*\"|hash = \"$NEW_HASH\"|" "${DEFAULT_NIX}"

# Update vendor hash for Go modules
echo "📦 Building to get new vendorHash..."
echo "   (This may take a moment...)"

# Try to build and capture the new vendorHash
BUILD_OUTPUT=$(cd "${PKG_DIR}" && nix-build -E 'with import <nixpkgs> {}; callPackage ./default.nix {}' 2>&1 || true)
if echo "$BUILD_OUTPUT" | grep -q "got:    sha256-"; then
  NEW_VENDOR_HASH=$(echo "$BUILD_OUTPUT" | grep -oP 'got:\s+\Ksha256-[^\s]+')
  echo "   New vendorHash: $NEW_VENDOR_HASH"
  sed -i "s|vendorHash = \"sha256-.*\"|vendorHash = \"$NEW_VENDOR_HASH\"|" "${DEFAULT_NIX}"

  # Build again to verify
  echo "🔨 Verifying build..."
  if (cd "${PKG_DIR}" && nix-build -E 'with import <nixpkgs> {}; callPackage ./default.nix {}' > /dev/null 2>&1); then
    echo "✅ Successfully updated k9s to version $LATEST_VERSION!"
  else
    echo "⚠️  Build failed, but files have been updated. May need manual adjustment."
  fi
else
  echo "⚠️  Couldn't automatically determine vendorHash."
  echo "   You'll need to build manually and update the hash."
fi
