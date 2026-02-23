#!/bin/bash
# install-both.sh — Cài skill cho cả Antigravity và Codex
# Usage: bash scripts/install-both.sh /path/to/project

set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

echo "=== Cài cho Antigravity ==="
bash "$SCRIPT_DIR/install-antigravity.sh" "$1"

echo ""
echo "=== Cài cho Codex ==="
bash "$SCRIPT_DIR/install-codex.sh" "$1"

echo ""
echo "🎉 Hoàn tất! Skills đã sẵn sàng cho cả Antigravity (.agent/skills) và Codex (.agents/skills)"
