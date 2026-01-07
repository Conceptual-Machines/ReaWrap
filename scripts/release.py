#!/usr/bin/env python3
"""
Prepare a new release: bump version in lua/version.lua and update index.xml from CHANGELOG.md
Usage: python scripts/release.py
"""

import re
import xml.etree.ElementTree as ET
from pathlib import Path

# Paths
REPO_ROOT = Path(__file__).parent.parent
VERSION_FILE = REPO_ROOT / "lua" / "version.lua"
CHANGELOG_FILE = REPO_ROOT / "CHANGELOG.md"
INDEX_FILE = REPO_ROOT / "index.xml"

# Source files to include in index.xml
SOURCE_FILES = [
    "ReaWrap.lua",
    "lua/version.lua",
    "lua/imgui/init.lua",
    "lua/imgui/window.lua",
    "lua/imgui/theme.lua",
    "lua/helpers.lua",
    "lua/project.lua",
    "lua/track.lua",
    "lua/track_fx.lua",
    "lua/item.lua",
    "lua/take.lua",
    "lua/plugins.lua",
]


def get_latest_version_from_changelog():
    """Extract the latest version from CHANGELOG.md"""
    content = CHANGELOG_FILE.read_text()

    # Find first version header: ## [version] - date
    match = re.search(r'## \[(\d+\.\d+\.\d+)\] - (\d{4}-\d{2}-\d{2})', content)

    if not match:
        raise ValueError("No version found in CHANGELOG.md")

    return match.group(1), match.group(2)


def get_current_version_from_lua():
    """Extract current version from lua/version.lua"""
    content = VERSION_FILE.read_text()

    major = re.search(r'M\.MAJOR = (\d+)', content)
    minor = re.search(r'M\.MINOR = (\d+)', content)
    patch = re.search(r'M\.PATCH = (\d+)', content)

    if not (major and minor and patch):
        raise ValueError("Could not parse version from lua/version.lua")

    return f"{major.group(1)}.{minor.group(1)}.{patch.group(1)}"


def update_version_lua(version):
    """Update version in lua/version.lua"""
    parts = version.split('.')
    major, minor, patch = parts[0], parts[1], parts[2]

    content = VERSION_FILE.read_text()

    # Replace version numbers
    content = re.sub(r'M\.MAJOR = \d+', f'M.MAJOR = {major}', content)
    content = re.sub(r'M\.MINOR = \d+', f'M.MINOR = {minor}', content)
    content = re.sub(r'M\.PATCH = \d+', f'M.PATCH = {patch}', content)

    VERSION_FILE.write_text(content)
    print(f"✓ Updated lua/version.lua to {version}")


def extract_changelog_for_version(version):
    """Extract changelog entries for a specific version from CHANGELOG.md"""
    content = CHANGELOG_FILE.read_text()

    # Find the section for this version
    version_pattern = rf'## \[{re.escape(version)}\] - (\d{{4}}-\d{{2}}-\d{{2}})'
    match = re.search(version_pattern, content)

    if not match:
        raise ValueError(f"Version {version} not found in CHANGELOG.md")

    version_date = match.group(1)
    section_start = match.end()

    # Find the next version section or end of file
    next_section = re.search(r'\n## \[', content[section_start:])
    if next_section:
        section_end = section_start + next_section.start()
    else:
        section_end = len(content)

    section_content = content[section_start:section_end].strip()

    # Parse the changelog sections (### Added, ### Fixed, etc.)
    changelog_lines = []

    for line in section_content.split('\n'):
        line = line.strip()
        if not line:
            continue

        # Skip section headers
        if line.startswith('### '):
            continue

        # Bullet points
        if line.startswith('- '):
            bullet = line[2:].strip()
            if bullet and not bullet.startswith('  '):  # Skip nested bullets
                changelog_lines.append(f"  * {bullet}")

    changelog_text = f"v{version} ({version_date})\n" + '\n'.join(changelog_lines)
    return changelog_text, version_date


def update_index_xml(version, changelog, version_date):
    """Add new version entry to index.xml"""
    tree = ET.parse(INDEX_FILE)
    root = tree.getroot()

    # Find the reapack element
    reapack = root.find('.//category/reapack')

    if reapack is None:
        raise ValueError("Could not find reapack element in index.xml")

    # Check if version already exists
    for existing_version in reapack.findall('version'):
        if existing_version.get('name') == version:
            print(f"Version {version} already exists in index.xml")
            return False

    # Create new version element
    iso_date = f"{version_date}T00:00:00Z"

    version_elem = ET.Element('version', {
        'name': version,
        'author': 'Nomad Monad',
        'time': iso_date
    })

    # Add changelog as CDATA
    changelog_elem = ET.SubElement(version_elem, 'changelog')
    changelog_elem.text = changelog

    # Add source files
    for i, source_file in enumerate(SOURCE_FILES):
        source_elem = ET.SubElement(version_elem, 'source', {'file': source_file})
        if i == 0:
            source_elem.set('main', 'main')
        source_elem.text = source_file

    # Insert as first version
    reapack.insert(0, version_elem)

    # Write with proper formatting
    tree.write(INDEX_FILE, encoding='utf-8', xml_declaration=True)

    # Fix formatting and CDATA
    content = INDEX_FILE.read_text()

    # Replace changelog text with CDATA
    content = re.sub(
        r'<changelog>(.*?)</changelog>',
        lambda m: f'<changelog><![CDATA[{m.group(1)}]]></changelog>',
        content,
        flags=re.DOTALL
    )

    # Fix indentation
    lines = content.split('\n')
    formatted_lines = []
    indent_level = 0

    for line in lines:
        stripped = line.strip()
        if not stripped:
            continue

        # Decrease indent for closing tags
        if stripped.startswith('</'):
            indent_level = max(0, indent_level - 1)

        formatted_lines.append('  ' * indent_level + stripped)

        # Increase indent for opening tags
        if stripped.startswith('<') and not stripped.startswith('</'):
            if not stripped.endswith('/>') and '</' not in stripped[1:]:
                indent_level += 1

    INDEX_FILE.write_text('\n'.join(formatted_lines) + '\n')
    print(f"✓ Added version {version} to index.xml")

    return True


def main():
    print("Preparing release from CHANGELOG.md...\n")

    # Get latest version from CHANGELOG
    new_version, changelog_date = get_latest_version_from_changelog()
    print(f"Latest version in CHANGELOG.md: {new_version} ({changelog_date})")

    # Get current version from lua/version.lua
    current_version = get_current_version_from_lua()
    print(f"Current version in lua/version.lua: {current_version}")

    if new_version == current_version:
        print(f"\n⚠️  Version {new_version} is already set in lua/version.lua")
        print("Do you want to update index.xml anyway? (y/N): ", end='')
        response = input().strip().lower()
        if response != 'y':
            print("Aborted.")
            return 0
    else:
        print(f"\n→ Bumping version from {current_version} to {new_version}")
        update_version_lua(new_version)

    # Extract changelog
    changelog, version_date = extract_changelog_for_version(new_version)

    # Update index.xml
    update_index_xml(new_version, changelog, version_date)

    print("\n✓ Release prepared successfully!")
    print("\nNext steps:")
    print("  1. Review changes: git diff lua/version.lua index.xml")
    print(f"  2. Commit: git add lua/version.lua index.xml && git commit -m 'chore: release v{new_version}'")
    print(f"  3. Tag: git tag v{new_version} && git push origin v{new_version}")

    return 0


if __name__ == '__main__':
    exit(main())
