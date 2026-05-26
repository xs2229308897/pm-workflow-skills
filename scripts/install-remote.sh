#!/bin/bash
# 一键安装 PM 工作流技能
# 用法：cd /your/project && bash <(curl -sL https://raw.githubusercontent.com/xs2229308897/pm-workflow-skills/main/scripts/install-remote.sh)

set -e

REPO="https://github.com/xs2229308897/pm-workflow-skills.git"
TEMP_DIR=$(mktemp -d)
trap 'rm -rf "$TEMP_DIR"' EXIT

echo "PM Multi-Agent Workflow - Installing..."
echo ""

# Check project root
if [ ! -d "src" ] && [ ! -d "app" ] && [ ! -d "lib" ]; then
  echo "Warning: no src/app/lib found. Run this command from your project root."
  read -p "Continue? (y/N) " -n 1 -r
  echo ""
  [[ ! $REPLY =~ ^[Yy]$ ]] && exit 0
fi

# Clone
git clone --depth 1 "$REPO" "$TEMP_DIR/repo" 2>/dev/null

# Copy skills
mkdir -p .claude/skills
for d in "$TEMP_DIR"/repo/pm-*; do
  name=$(basename "$d")
  if [ ! -d ".claude/skills/$name" ]; then
    cp -r "$d" ".claude/skills/$name"
    echo "  + $name"
  else
    echo "  ~ $name (exists)"
  fi
done

# Copy global lessons
mkdir -p .claude/skills/pm-leader/lessons
[ ! -f ".claude/skills/pm-leader/lessons/global-lessons.md" ] && \
  cp "$TEMP_DIR"/repo/lessons/global-lessons.md ".claude/skills/pm-leader/lessons/" && \
  echo "  + global-lessons.md"

# Copy templates
mkdir -p docs/superpowers/pm-output
[ ! -f "docs/superpowers/pm-workflow-state.md" ] && \
  cp "$TEMP_DIR"/repo/docs/superpowers/pm-workflow-state.md docs/superpowers/ && \
  echo "  + pm-workflow-state.md"
[ ! -f "docs/superpowers/pm-lessons-learned.md" ] && \
  cp "$TEMP_DIR"/repo/docs/superpowers/pm-lessons-learned.md docs/superpowers/ && \
  echo "  + pm-lessons-learned.md"

echo ""
echo "Done! Run /pm-leader in Claude Code to start."
