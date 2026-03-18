#!/bin/bash
# ============================================================================
# Sync Claude Code commands → Copilot prompt files
# ============================================================================
# Run this after modifying any .claude/commands/*.md file to keep
# Copilot prompt files in sync. Both tools read the same instructions,
# just from different directories.
#
# Usage: ./scripts/sync-prompts.sh
# ============================================================================

set -e

CLAUDE_DIR=".claude/commands"
COPILOT_DIR=".github/prompts"

mkdir -p "$COPILOT_DIR"

echo "Syncing Claude commands → Copilot prompts..."

for cmd_file in "$CLAUDE_DIR"/*.md; do
    filename=$(basename "$cmd_file")
    prompt_file="$COPILOT_DIR/${filename%.md}.prompt.md"

    # Copy content — Copilot prompt files use the same markdown format
    cp "$cmd_file" "$prompt_file"

    echo "  ✓ $filename → ${filename%.md}.prompt.md"
done

# Also sync CLAUDE.md → copilot-instructions.md (skip if manually maintained)
if [ -f "CLAUDE.md" ] && [ ! -f ".github/copilot-instructions.md.manual" ]; then
    cp "CLAUDE.md" ".github/copilot-instructions.md"
    echo "  ✓ CLAUDE.md → .github/copilot-instructions.md"
fi

echo ""
echo "Done. Both Claude Code and Copilot will use the same instructions."
echo "Claude Code: .claude/commands/*.md"
echo "Copilot:     .github/prompts/*.prompt.md"
