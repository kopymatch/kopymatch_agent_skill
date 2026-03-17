#!/bin/bash
# doctor.sh — Kiểm tra sức khoẻ skill repo và installed skills
# Usage: bash scripts/doctor.sh [--installed <project-dir>]

set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
REPO_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"

ERRORS=0
WARNINGS=0

echo "🩺 KopyMatch Skill Doctor"
echo "========================="

# --- Check 1: SKILL.md files ---
echo ""
echo "📋 Kiểm tra SKILL.md..."
for dir in "$REPO_DIR"/kopymatch-core/*/ "$REPO_DIR"/repo-overlays/*/; do
  if [ -d "$dir" ]; then
    skill_name="$(basename "$dir")"
    group="$(basename "$(dirname "$dir")")"

    if [ ! -f "$dir/SKILL.md" ]; then
      echo "  ❌ $group/$skill_name — thiếu SKILL.md"
      ERRORS=$((ERRORS + 1))
      continue
    fi

    # Check frontmatter
    has_name=$(head -20 "$dir/SKILL.md" | grep -c "^name:" || true)
    has_desc=$(head -20 "$dir/SKILL.md" | grep -c "^description:" || true)
    if [ "$has_name" -eq 0 ] || [ "$has_desc" -eq 0 ]; then
      echo "  ⚠️  $group/$skill_name — thiếu name/description trong frontmatter"
      WARNINGS=$((WARNINGS + 1))
    else
      echo "  ✅ $group/$skill_name"
    fi
  fi
done

# --- Check 2: JSON files valid ---
echo ""
echo "📋 Kiểm tra JSON files..."
for json_file in $(find "$REPO_DIR/shared" "$REPO_DIR/kopymatch-core" -name "*.json" 2>/dev/null); do
  rel_path="${json_file#$REPO_DIR/}"
  if python3 -c "import json; json.load(open('$json_file'))" 2>/dev/null; then
    echo "  ✅ $rel_path"
  elif python -c "import json; json.load(open('$json_file'))" 2>/dev/null; then
    echo "  ✅ $rel_path"
  else
    echo "  ❌ $rel_path — JSON không hợp lệ"
    ERRORS=$((ERRORS + 1))
  fi
done

# --- Check 3: YAML packs ---
echo ""
echo "📋 Kiểm tra YAML packs..."
for yaml_file in "$REPO_DIR"/packs/*.yaml; do
  if [ -f "$yaml_file" ]; then
    rel_path="${yaml_file#$REPO_DIR/}"
    echo "  ✅ $rel_path"
  fi
done

# --- Check 4: Resource references ---
echo ""
echo "📋 Kiểm tra resource references..."
for dir in "$REPO_DIR"/kopymatch-core/*/; do
  if [ -d "$dir" ]; then
    skill_name="$(basename "$dir")"
    if [ -d "$dir/resources" ]; then
      file_count=$(find "$dir/resources" -type f | wc -l)
      echo "  ✅ kopymatch-core/$skill_name/resources/ — $file_count files"
    fi
    if [ -d "$dir/examples" ]; then
      file_count=$(find "$dir/examples" -type f | wc -l)
      echo "  ✅ kopymatch-core/$skill_name/examples/ — $file_count files"
    fi
  fi
done

# --- Check 5: Shared directory ---
echo ""
echo "📋 Kiểm tra shared/..."
for subdir in schemas taxonomies templates; do
  if [ -d "$REPO_DIR/shared/$subdir" ]; then
    file_count=$(find "$REPO_DIR/shared/$subdir" -type f | wc -l)
    echo "  ✅ shared/$subdir/ — $file_count files"
  else
    echo "  ❌ shared/$subdir/ — không tồn tại"
    ERRORS=$((ERRORS + 1))
  fi
done

# --- Check installed skills (optional) ---
if [ -n "$1" ] && [ "$1" = "--installed" ] && [ -n "$2" ]; then
  PROJECT_DIR="$2"
  echo ""
  echo "📋 Kiểm tra installed skills tại $PROJECT_DIR..."
  for agent_dir in ".agent/skills" ".agents/skills"; do
    target="$PROJECT_DIR/$agent_dir"
    if [ -d "$target" ]; then
      skill_count=$(ls -d "$target"/*/ 2>/dev/null | wc -l)
      echo "  ✅ $agent_dir — $skill_count skills"
      if [ -f "$target/.skill-manifest.json" ]; then
        echo "  ✅ $agent_dir/.skill-manifest.json — có manifest"
      else
        echo "  ⚠️  $agent_dir — thiếu .skill-manifest.json"
        WARNINGS=$((WARNINGS + 1))
      fi
    fi
  done
fi

# --- Summary ---
echo ""
echo "========================="
echo "📊 Kết quả: $ERRORS lỗi, $WARNINGS cảnh báo"

if [ "$ERRORS" -gt 0 ]; then
  echo "❌ Có lỗi cần sửa!"
  exit 1
else
  echo "✅ Skill repo healthy!"
  exit 0
fi
