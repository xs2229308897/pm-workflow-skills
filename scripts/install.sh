#!/bin/bash
# PM 多 Agent 工作流安装脚本
# 用法：在目标项目根目录下执行 bash /path/to/pm-workflow-skills/scripts/install.sh

set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
SKILL_DIR="$(dirname "$SCRIPT_DIR")"

echo "PM 多 Agent 工作流安装脚本"
echo "=========================="
echo ""
echo "源目录：$SKILL_DIR"
echo "目标目录：$(pwd)"
echo ""

# 检查是否在项目根目录
if [ ! -d "src" ] && [ ! -d "app" ] && [ ! -d "lib" ]; then
  echo "警告：当前目录可能不是项目根目录（未找到 src/app/lib 目录）"
  read -p "是否继续？(y/N) " -n 1 -r
  echo ""
  if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo "已取消"
    exit 0
  fi
fi

# 创建 .claude/skills 目录
mkdir -p .claude/skills

# 复制技能文件
echo "正在复制技能文件..."
for skill_dir in "$SKILL_DIR"/pm-*; do
  if [ -d "$skill_dir" ]; then
    skill_name=$(basename "$skill_dir")
    if [ -d ".claude/skills/$skill_name" ]; then
      echo "  跳过 $skill_name（已存在）"
    else
      cp -r "$skill_dir" ".claude/skills/$skill_name"
      echo "  已安装 $skill_name"
    fi
  fi
done

# 复制全局经验教训
echo ""
echo "正在复制全局经验教训..."
mkdir -p ".claude/skills/pm-leader/lessons"
if [ ! -f ".claude/skills/pm-leader/lessons/global-lessons.md" ]; then
  cp "$SKILL_DIR/lessons/global-lessons.md" ".claude/skills/pm-leader/lessons/"
  echo "  已创建全局经验教训文件"
else
  echo "  跳过全局经验教训（已存在）"
fi

# 复制 hooks 脚本
echo ""
echo "正在复制 hooks 脚本..."
mkdir -p ".claude/skills/pm-leader/scripts/hooks"
if [ -d "$SKILL_DIR/scripts/hooks" ]; then
  cp "$SKILL_DIR/scripts/hooks/"* ".claude/skills/pm-leader/scripts/hooks/"
  echo "  已安装 hooks 脚本"
else
  echo "  跳过 hooks（源文件不存在）"
fi

# 复制 MCP 配置示例
echo ""
echo "正在复制 MCP 配置示例..."
if [ ! -f "mcp-config.example.json" ]; then
  cp "$SKILL_DIR/mcp-config.example.json" "."
  echo "  已创建 mcp-config.example.json"
else
  echo "  跳过 mcp-config.example.json（已存在）"
fi

# 复制 PM 工具
echo ""
echo "正在复制 PM 工具..."
if [ ! -d "tools/pm-mcp-server" ]; then
  cp -r "$SKILL_DIR/tools" "tools"
  echo "  已安装 tools 目录"
  echo ""
  echo "要构建 PM MCP 工具，请运行："
  echo "  cd tools/pm-mcp-server && npm install && npm run build"
else
  echo "  跳过 tools（已存在）"
fi

# 创建文档目录
echo ""
echo "正在创建文档目录..."
mkdir -p docs/superpowers/pm-output

# 复制模板文件
if [ ! -f "docs/superpowers/pm-workflow-state.md" ]; then
  cp "$SKILL_DIR/docs/superpowers/pm-workflow-state.md" "docs/superpowers/"
  echo "  已创建 docs/superpowers/pm-workflow-state.md"
else
  echo "  跳过 pm-workflow-state.md（已存在）"
fi

if [ ! -f "docs/superpowers/pm-lessons-learned.md" ]; then
  cp "$SKILL_DIR/docs/superpowers/pm-lessons-learned.md" "docs/superpowers/"
  echo "  已创建 docs/superpowers/pm-lessons-learned.md"
else
  echo "  跳过 pm-lessons-learned.md（已存在）"
fi

echo ""
echo "=========================="
echo "安装完成！"
echo ""
echo "下一步："
echo "  1. 编辑 .claude/skills/pm-prototype-builder/SKILL.md"
echo "     将'项目规范'章节替换为你的项目技术栈"
echo "     可用模板见 pm-prototype-builder/templates/ 目录"
echo ""
echo "  2. 在 Claude Code 中输入 /pm-leader 开始使用"
