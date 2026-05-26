#!/bin/bash
# SubagentStart hook — 记录子 Agent 调度日志
LOG_FILE="docs/superpowers/pm-audit.log"
mkdir -p "$(dirname "$LOG_FILE")"
TIMESTAMP=$(date '+%Y-%m-%d %H:%M:%S')
AGENT_DESC="${CLAUDE_TOOL_INPUT:-unknown}"
echo "[$TIMESTAMP] SUBAGENT_START: $AGENT_DESC" >> "$LOG_FILE"
