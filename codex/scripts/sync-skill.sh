#!/usr/bin/env bash
# Copy the canonical skill into a Codex skills folder (default: ~/.agents/skills).
# Usage: codex/scripts/sync-skill.sh [target-skills-dir]
set -euo pipefail
here="$(cd "$(dirname "$0")/../.." && pwd)"
target="${1:-$HOME/.agents/skills}/moduvoice-voice"
mkdir -p "$target"
cp "$here/skills/moduvoice-voice/SKILL.md" "$target/SKILL.md"
echo "Copied to $target"
