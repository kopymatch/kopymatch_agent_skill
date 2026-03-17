#!/bin/bash
# sync.sh — Tự động cập nhật third_party từ upstream repos
# Usage: bash scripts/sync.sh

set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
REPO_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"
TMP_DIR="$REPO_DIR/_tmp_upstream"

echo "🔄 KopyMatch Upstream Sync"
echo "=========================="

# Clean up any previous temp
rm -rf "$TMP_DIR"
mkdir -p "$TMP_DIR"

echo ""
echo "📥 Cloning upstream repos..."

# Vercel Agent Skills
echo "  → vercel-labs/agent-skills..."
if git clone --depth 1 https://github.com/vercel-labs/agent-skills.git "$TMP_DIR/vercel-agent-skills" 2>/dev/null; then
  echo "  ✅ vercel-agent-skills cloned"
else
  echo "  ⚠️  vercel-agent-skills — clone failed (check network)"
fi

# Anthropic Courses
echo "  → anthropics/courses..."
if git clone --depth 1 https://github.com/anthropics/courses.git "$TMP_DIR/anthropics-skills" 2>/dev/null; then
  echo "  ✅ anthropics-skills cloned"
else
  echo "  ⚠️  anthropics-skills — clone failed (check network)"
fi

# OpenAI Codex
echo "  → openai/codex..."
if git clone --depth 1 https://github.com/openai/codex.git "$TMP_DIR/openai-skills" 2>/dev/null; then
  echo "  ✅ openai-skills cloned"
else
  echo "  ⚠️  openai-skills — clone failed (check network)"
fi

echo ""
echo "📋 Updating third_party/..."

# Copy relevant content
if [ -d "$TMP_DIR/vercel-agent-skills/skills" ]; then
  cp -r "$TMP_DIR/vercel-agent-skills/skills/"* "$REPO_DIR/third_party/vercel-agent-skills/" 2>/dev/null || true
  echo "  ✅ vercel-agent-skills updated"
fi

if [ -d "$TMP_DIR/anthropics-skills" ]; then
  for dir in real_world_prompting tool_use prompt_evaluations; do
    if [ -d "$TMP_DIR/anthropics-skills/$dir" ]; then
      cp -r "$TMP_DIR/anthropics-skills/$dir" "$REPO_DIR/third_party/anthropics-skills/" 2>/dev/null || true
    fi
  done
  echo "  ✅ anthropics-skills updated"
fi

if [ -d "$TMP_DIR/openai-skills" ]; then
  for item in AGENTS.md .codex docs; do
    if [ -e "$TMP_DIR/openai-skills/$item" ]; then
      cp -r "$TMP_DIR/openai-skills/$item" "$REPO_DIR/third_party/openai-skills/" 2>/dev/null || true
    fi
  done
  echo "  ✅ openai-skills updated"
fi

# Clean up
echo ""
echo "🧹 Cleaning up temp files..."
rm -rf "$TMP_DIR"

echo ""
echo "🎉 Sync hoàn tất! Chạy 'git diff third_party/' để xem thay đổi."
