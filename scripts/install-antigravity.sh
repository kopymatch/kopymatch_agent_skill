#!/bin/bash
# install-antigravity.sh — Cài skill vào project cho Antigravity (.agent/skills)
# Usage: bash scripts/install-antigravity.sh /path/to/project

set -e

PROJECT_DIR="$1"

if [ -z "$PROJECT_DIR" ]; then
  echo "❌ Thiếu đường dẫn project."
  echo "Usage: bash scripts/install-antigravity.sh /path/to/project"
  exit 1
fi

if [ ! -d "$PROJECT_DIR" ]; then
  echo "❌ Thư mục '$PROJECT_DIR' không tồn tại."
  exit 1
fi

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
REPO_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"
TARGET_DIR="$PROJECT_DIR/.agent/skills"

echo "📦 Cài skill vào: $TARGET_DIR"

mkdir -p "$TARGET_DIR"

# Copy P0 Core skills
echo "  → P0 Core skills..."
cp -r "$REPO_DIR/skills/p0-core/"* "$TARGET_DIR/"

# Copy P1 Dev skills
echo "  → P1 Dev skills..."
cp -r "$REPO_DIR/skills/p1-dev/"* "$TARGET_DIR/"

echo "✅ Đã cài $(ls -d "$TARGET_DIR"/*/ 2>/dev/null | wc -l) skills vào $TARGET_DIR"
echo ""
echo "Antigravity sẽ tự phát hiện skills trong .agent/skills/"
