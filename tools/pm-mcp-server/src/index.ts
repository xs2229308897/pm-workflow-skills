import { McpServer } from '@modelcontextprotocol/sdk/server/mcp.js';
import { StdioServerTransport } from '@modelcontextprotocol/sdk/server/stdio.js';
import { z } from 'zod';
import { assessRequirementQuality } from './tools/assess-requirement-quality.js';
import { checkPrdConsistency } from './tools/check-prd-consistency.js';
import { generateErDiagram } from './tools/generate-er-diagram.js';

const server = new McpServer({
  name: 'pm-workflow-tools',
  version: '1.0.0'
});

// Tool 1: 需求质量评估
server.tool(
  'assess_requirement_quality',
  '评估需求清单的完整性、规范性和质量',
  { requirements: z.string().describe('需求清单 Markdown 文本') },
  async ({ requirements }) => {
    const result = assessRequirementQuality(requirements);
    return { content: [{ type: 'text', text: JSON.stringify(result, null, 2) }] };
  }
);

// Tool 2: PRD 一致性检查
server.tool(
  'check_prd_consistency',
  '检查 PRD 文档的内部一致性和完整性',
  { prd: z.string().describe('PRD 文档 Markdown 文本') },
  async ({ prd }) => {
    const result = checkPrdConsistency(prd);
    return { content: [{ type: 'text', text: JSON.stringify(result, null, 2) }] };
  }
);

// Tool 3: ER 图生成
server.tool(
  'generate_er_diagram',
  '从数据模型定义生成 Mermaid ER 图',
  { data_model: z.string().describe('数据模型定义 Markdown 文本') },
  async ({ data_model }) => {
    const result = generateErDiagram(data_model);
    return { content: [{ type: 'text', text: result }] };
  }
);

const transport = new StdioServerTransport();
await server.connect(transport);
