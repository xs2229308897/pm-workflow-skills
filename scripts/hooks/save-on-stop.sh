#!/bin/bash
# Stop hook — 会话结束时记录标记
LOG_FILE="docs/superpowers/pm-audit.log"
mkdir -p "$(dirname "$LOG_FILE")"
TIMESTAMP=$(date '+%Y-%m-%d %H:%M:%S')
echo "[$TIMESTAMP] SESSION_END" >> "$LOG_FILE"
