#!/bin/bash
# install.sh — Unified skill installer cho Antigravity và Codex
# Usage:
#   bash scripts/install.sh <project-dir> [--pack <pack>] [--agent <agent>]
#
# Examples:
#   bash scripts/install.sh /path/to/project                              # Full, Antigravity
#   bash scripts/install.sh /path/to/project --pack kopymatch-core         # Core only
#   bash scripts/install.sh /path/to/project --agent both                  # Both agents
#   bash scripts/install.sh /path/to/project --pack repo-overlays --agent codex

set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
REPO_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"

# --- Defaults ---
PROJECT_DIR=""
PACK="full"
AGENT="antigravity"
FORCE=false

# --- Parse args ---
while [[ $# -gt 0 ]]; do
  case "$1" in
    --pack)   PACK="$2"; shift 2 ;;
    --agent)  AGENT="$2"; shift 2 ;;
    --force)  FORCE=true; shift ;;
    -h|--help)
      echo "Usage: bash scripts/install.sh <project-dir> [--pack <pack>] [--agent <agent>] [--force]"
      echo ""
      echo "Packs:  kopymatch-core, repo-overlays, full (default)"
      echo "Agents: antigravity (default), codex, both"
      exit 0
      ;;
    *)
      if [ -z "$PROJECT_DIR" ]; then
        PROJECT_DIR="$1"
      else
        echo "❌ Unknown argument: $1"
        exit 1
      fi
      shift
      ;;
  esac
done

if [ -z "$PROJECT_DIR" ]; then
  echo "❌ Thiếu đường dẫn project."
  echo "Usage: bash scripts/install.sh <project-dir> [--pack <pack>] [--agent <agent>]"
  exit 1
fi

if [ ! -d "$PROJECT_DIR" ]; then
  echo "❌ Thư mục '$PROJECT_DIR' không tồn tại."
  exit 1
fi

# --- Determine target directories ---
declare -a TARGET_DIRS

case "$AGENT" in
  antigravity) TARGET_DIRS=("$PROJECT_DIR/.agent/skills") ;;
  codex)       TARGET_DIRS=("$PROJECT_DIR/.agents/skills") ;;
  both)        TARGET_DIRS=("$PROJECT_DIR/.agent/skills" "$PROJECT_DIR/.agents/skills") ;;
  *)           echo "❌ Agent không hợp lệ: $AGENT (chọn: antigravity, codex, both)"; exit 1 ;;
esac

# --- Determine source directories ---
declare -a SOURCE_DIRS

case "$PACK" in
  kopymatch-core)
    SOURCE_DIRS=("$REPO_DIR/kopymatch-core")
    ;;
  repo-overlays)
    SOURCE_DIRS=("$REPO_DIR/repo-overlays")
    ;;
  full)
    SOURCE_DIRS=("$REPO_DIR/kopymatch-core" "$REPO_DIR/repo-overlays")
    ;;
  *)
    echo "❌ Pack không hợp lệ: $PACK (chọn: kopymatch-core, repo-overlays, full)"
    exit 1
    ;;
esac

# --- Install ---
TOTAL_SKILLS=0

for TARGET_DIR in "${TARGET_DIRS[@]}"; do
  echo "📦 Cài skill vào: $TARGET_DIR (pack: $PACK)"
  mkdir -p "$TARGET_DIR"

  for SOURCE_DIR in "${SOURCE_DIRS[@]}"; do
    for skill_dir in "$SOURCE_DIR"/*/; do
      if [ -d "$skill_dir" ]; then
        skill_name="$(basename "$skill_dir")"
        dest="$TARGET_DIR/$skill_name"

        if [ -d "$dest" ] && [ "$FORCE" = false ]; then
          echo "  ⏭️  $skill_name — đã tồn tại (dùng --force để ghi đè)"
          continue
        fi

        cp -r "$skill_dir" "$dest"
        echo "  ✅ $skill_name"
        TOTAL_SKILLS=$((TOTAL_SKILLS + 1))
      fi
    done
  done

  # Write manifest
  MANIFEST="$TARGET_DIR/.skill-manifest.json"
  cat > "$MANIFEST" << EOF
{
  "installed_at": "$(date -u +%Y-%m-%dT%H:%M:%SZ)",
  "source_repo": "kopymatch-agent-skill",
  "pack": "$PACK",
  "agent": "$AGENT",
  "version": "2.0.0"
}
EOF
  echo "  📋 Manifest: $MANIFEST"
done

echo ""
echo "🎉 Hoàn tất! Đã cài $TOTAL_SKILLS skills."
