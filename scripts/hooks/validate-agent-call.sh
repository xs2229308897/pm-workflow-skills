#!/bin/bash
# PreToolUse hook (matcher: Agent) — 校验 Agent 调用格式
INPUT="${CLAUDE_TOOL_INPUT:-}"
if [ -z "$INPUT" ]; then
  echo "Error: Agent tool call missing input" >&2
  exit 2
fi
# 检查是否包含 description 和 prompt 字段
if ! echo "$INPUT" | grep -q '"description"'; then
  echo "Error: Agent tool call missing 'description' field" >&2
  exit 2
fi
if ! echo "$INPUT" | grep -q '"prompt"'; then
  echo "Error: Agent tool call missing 'prompt' field" >&2
  exit 2
fi
exit 0
