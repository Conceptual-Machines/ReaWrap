#!/bin/bash
# Version bump script for ReaWrap
# Usage: ./tools/bump_version.sh [major|minor|patch]

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(dirname "$SCRIPT_DIR")"

# Read current version from lua/version.lua
CURRENT_MAJOR=$(grep "^M.MAJOR" "$ROOT_DIR/lua/version.lua" | grep -o '[0-9]*')
CURRENT_MINOR=$(grep "^M.MINOR" "$ROOT_DIR/lua/version.lua" | grep -o '[0-9]*')
CURRENT_PATCH=$(grep "^M.PATCH" "$ROOT_DIR/lua/version.lua" | grep -o '[0-9]*')

CURRENT_VERSION="$CURRENT_MAJOR.$CURRENT_MINOR.$CURRENT_PATCH"
echo "Current version: $CURRENT_VERSION"

# Determine bump type
BUMP_TYPE="${1:-patch}"
case "$BUMP_TYPE" in
    major)
        NEW_MAJOR=$((CURRENT_MAJOR + 1))
        NEW_MINOR=0
        NEW_PATCH=0
        ;;
    minor)
        NEW_MAJOR=$CURRENT_MAJOR
        NEW_MINOR=$((CURRENT_MINOR + 1))
        NEW_PATCH=0
        ;;
    patch)
        NEW_MAJOR=$CURRENT_MAJOR
        NEW_MINOR=$CURRENT_MINOR
        NEW_PATCH=$((CURRENT_PATCH + 1))
        ;;
    *)
        echo "Usage: $0 [major|minor|patch]"
        exit 1
        ;;
esac

NEW_VERSION="$NEW_MAJOR.$NEW_MINOR.$NEW_PATCH"
TODAY=$(date +%Y-%m-%d)
TIMESTAMP="${TODAY}T00:00:00Z"

echo "New version: $NEW_VERSION ($BUMP_TYPE bump)"
echo ""

# Update lua/version.lua
echo "Updating lua/version.lua..."
sed -i '' "s/^M.MAJOR = .*/M.MAJOR = $NEW_MAJOR/" "$ROOT_DIR/lua/version.lua"
sed -i '' "s/^M.MINOR = .*/M.MINOR = $NEW_MINOR/" "$ROOT_DIR/lua/version.lua"
sed -i '' "s/^M.PATCH = .*/M.PATCH = $NEW_PATCH/" "$ROOT_DIR/lua/version.lua"

# Update config.ld
echo "Updating config.ld..."
sed -i '' "s/^version = '.*'/version = '$NEW_VERSION'/" "$ROOT_DIR/config.ld"

# Update ReaWrap.lua version line
echo "Updating ReaWrap.lua..."
sed -i '' "s/^-- @version .*/-- @version $NEW_VERSION/" "$ROOT_DIR/ReaWrap.lua"

echo ""
echo "✓ Updated version to $NEW_VERSION in:"
echo "  - lua/version.lua"
echo "  - config.ld"
echo "  - ReaWrap.lua"
echo ""
echo "⚠️  Manual updates still needed:"
echo "  - ReaWrap.lua @changelog section"
echo "  - CHANGELOG.md"
echo "  - index.xml (version entry and changelog)"
echo ""
echo "Today's date: $TODAY"
