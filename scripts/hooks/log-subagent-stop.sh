#!/bin/bash
# SubagentStop hook — 记录子 Agent 完成状态
LOG_FILE="docs/superpowers/pm-audit.log"
mkdir -p "$(dirname "$LOG_FILE")"
TIMESTAMP=$(date '+%Y-%m-%d %H:%M:%S')
OUTPUT="${CLAUDE_TOOL_OUTPUT:-no output}"
# 提取状态码
STATUS=$(echo "$OUTPUT" | grep -oP '(DONE|DONE_WITH_GAPS|BLOCKED|NEEDS_CONTEXT)' | head -1)
STATUS=${STATUS:-UNKNOWN}
echo "[$TIMESTAMP] SUBAGENT_STOP: status=$STATUS" >> "$LOG_FILE"
