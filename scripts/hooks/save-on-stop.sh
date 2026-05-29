#!/bin/bash
# Stop hook — 会话结束时记录标记和状态快照
LOG_FILE="docs/superpowers/pm-audit.log"
STATE_FILE="docs/superpowers/pm-workflow-state.md"
SNAPSHOT_FILE="docs/superpowers/pm-session-snapshot.md"
mkdir -p "$(dirname "$LOG_FILE")"
TIMESTAMP=$(date '+%Y-%m-%d %H:%M:%S')
echo "[$TIMESTAMP] SESSION_END" >> "$LOG_FILE"

# 保存会话快照：当前工作流状态 + 最后一次子 Agent 活动
if [ -f "$STATE_FILE" ]; then
  {
    echo "# 会话快照（自动生成）"
    echo "## 保存时间：$TIMESTAMP"
    echo ""
    cat "$STATE_FILE"
    # 记录最后一次子 Agent 活动
    echo ""
    echo "## 最近子 Agent 活动"
    grep -E "SUBAGENT_(START|STOP)" "$LOG_FILE" | tail -5
  } > "$SNAPSHOT_FILE"
fi
