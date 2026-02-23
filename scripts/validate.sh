#!/bin/bash
# validate.sh — Kiểm tra tất cả skills có SKILL.md và YAML frontmatter hợp lệ
# Usage: bash scripts/validate.sh

set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
REPO_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"

TOTAL=0
VALID=0
INVALID=0

echo "🔍 Kiểm tra skills trong $REPO_DIR/skills/"
echo "================================================"

check_skill() {
  local skill_dir="$1"
  local group="$2"
  local skill_name="$(basename "$skill_dir")"
  local skill_file="$skill_dir/SKILL.md"

  TOTAL=$((TOTAL + 1))

  if [ ! -f "$skill_file" ]; then
    echo "  ❌ $group/$skill_name — thiếu SKILL.md"
    INVALID=$((INVALID + 1))
    return
  fi

  # Check YAML frontmatter has name and description
  local has_name=$(head -20 "$skill_file" | grep -c "^name:" || true)
  local has_desc=$(head -20 "$skill_file" | grep -c "^description:" || true)

  if [ "$has_name" -eq 0 ] || [ "$has_desc" -eq 0 ]; then
    echo "  ⚠️  $group/$skill_name — SKILL.md thiếu name hoặc description trong frontmatter"
    INVALID=$((INVALID + 1))
    return
  fi

  local name=$(head -20 "$skill_file" | grep "^name:" | head -1 | sed 's/^name: *//')
  local desc=$(head -20 "$skill_file" | grep "^description:" | head -1 | sed 's/^description: *//' | cut -c1-60)

  echo "  ✅ $group/$skill_name — $name"
  VALID=$((VALID + 1))
}

# P0 Core
echo ""
echo "📌 P0 — Core KopyMatch"
echo "-------------------------------"
for dir in "$REPO_DIR/skills/p0-core"/*/; do
  if [ -d "$dir" ]; then
    check_skill "$dir" "p0-core"
  fi
done

# P1 Dev
echo ""
echo "📌 P1 — Dev chung"
echo "-------------------------------"
for dir in "$REPO_DIR/skills/p1-dev"/*/; do
  if [ -d "$dir" ]; then
    check_skill "$dir" "p1-dev"
  fi
done

echo ""
echo "================================================"
echo "📊 Kết quả: $VALID/$TOTAL hợp lệ, $INVALID lỗi"

if [ "$INVALID" -gt 0 ]; then
  echo "❌ Có $INVALID skill không hợp lệ!"
  exit 1
else
  echo "✅ Tất cả skills đều hợp lệ!"
  exit 0
fi
