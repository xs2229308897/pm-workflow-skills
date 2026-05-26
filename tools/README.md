# PM Workflow Tools

PM 专用 MCP 工具服务器，为 pm-workflow-skills 提供自动化质量检查能力。

## 包含工具

| 工具 | 用途 | 输入 |
|------|------|------|
| `assess_requirement_quality` | 评估需求清单质量（0-100 分） | 需求清单 Markdown |
| `check_prd_consistency` | 检查 PRD 内部一致性 | PRD 文档 Markdown |
| `generate_er_diagram` | 生成 Mermaid ER 图 | 数据模型定义 Markdown |

## 安装

```bash
cd tools/pm-mcp-server
npm install
npm run build
```

## 配置

在项目的 `.claude/settings.json` 中添加：

```json
{
  "mcpServers": {
    "pm-workflow-tools": {
      "command": "node",
      "args": ["<path-to>/tools/pm-mcp-server/dist/index.js"]
    }
  }
}
```

或复制 `mcp-config.example.json` 中的配置。

## 特点

- 纯启发式分析（正则 + 结构检测），无 LLM 调用
- 快速、确定性、无额外 API 成本
- 与 pm-workflow-skills 的子 Agent 无缝集成
