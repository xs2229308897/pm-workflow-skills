# PM 多 Agent 工作流技能库

Claude Code 多 Agent 技能，覆盖产品经理全流程：需求分析 → PRD → 原型 → 测试 → 反馈迭代。

## 核心特性

- **单一入口** — 通过 `/pm-leader` 与一个领导者对话，自动调度 8 个子 Agent
- **动态反馈循环** — 子 Agent 之间可互相补充、迭代，非线性流水线
- **学习机制** — 从用户纠正中学习，经验跨会话持久化
- **技术栈无关** — 原型开发支持多种前端框架模板，按项目配置

## 包含的 Skills

| Skill | 职责 |
|-------|------|
| `pm-leader` | 领导者 — 意图识别、任务调度、成果汇总、学习更新 |
| `pm-requirement-analysis` | 需求分析 — 从非结构化文本提取结构化需求 |
| `pm-competitive-analysis` | 竞品分析 — 同类系统功能对比 |
| `pm-prd-writer` | PRD 生成 — 完整 PRD 文档（含功能逻辑说明、数据模型） |
| `pm-risk-assessor` | 风险评估 — 可行性、复杂度、跨模块影响 |
| `pm-data-modeler` | 数据建模 — ER 图、数据字典 |
| `pm-prototype-builder` | 原型开发 — 可运行的前端原型代码 |
| `pm-test-verifier` | 测试验证 — 测试用例、冒烟测试 |
| `pm-feedback-collector` | 反馈收集 — 分析反馈、生成新版本需求 |
| `pm-process-modeler` | 流程建模 — 业务流程图、状态机、审批流配置（仅 B 端模式） |
| `pm-permission-designer` | 权限设计 — RBAC/ABAC、数据权限、多租户隔离（仅 B 端模式） |

## 安装

### macOS / Linux

#### 方式一：复制到项目（推荐）

```bash
# 克隆仓库
git clone https://github.com/xs2229308897/pm-workflow-skills.git /tmp/pm-workflow-skills

# 复制技能到项目
cp -r /tmp/pm-workflow-skills/pm-* /path/to/your-project/.claude/skills/

# 复制配套模板
mkdir -p /path/to/your-project/docs/superpowers/pm-output
cp /tmp/pm-workflow-skills/docs/superpowers/pm-workflow-state.md /path/to/your-project/docs/superpowers/
cp /tmp/pm-workflow-skills/docs/superpowers/pm-lessons-learned.md /path/to/your-project/docs/superpowers/
```

#### 方式二：使用安装脚本

```bash
git clone https://github.com/xs2229308897/pm-workflow-skills.git /tmp/pm-workflow-skills
cd /path/to/your-project
bash /tmp/pm-workflow-skills/scripts/install.sh
```

#### 方式三：符号链接（开发模式）

```bash
cd /path/to/your-project/.claude/skills
ln -s /path/to/pm-workflow-skills/pm-* .
```

### Windows

#### 方式一：复制到项目（推荐）

```powershell
# 克隆仓库
git clone https://github.com/xs2229308897/pm-workflow-skills.git $env:TEMP\pm-workflow-skills

# 复制技能到项目（替换 YOUR_PROJECT 为你的项目路径）
$skills = Get-ChildItem "$env:TEMP\pm-workflow-skills" -Directory -Filter "pm-*"
foreach ($s in $skills) {
    Copy-Item $s.FullName -Destination "YOUR_PROJECT\.claude\skills\$($s.Name)" -Recurse
}

# 复制配套模板
New-Item -ItemType Directory -Force -Path "YOUR_PROJECT\docs\superpowers\pm-output"
Copy-Item "$env:TEMP\pm-workflow-skills\docs\superpowers\pm-workflow-state.md" -Destination "YOUR_PROJECT\docs\superpowers\"
Copy-Item "$env:TEMP\pm-workflow-skills\docs\superpowers\pm-lessons-learned.md" -Destination "YOUR_PROJECT\docs\superpowers\"
```

#### 方式二：使用安装脚本

PowerShell（推荐）：

```powershell
git clone https://github.com/xs2229308897/pm-workflow-skills.git $env:TEMP\pm-workflow-skills
cd YOUR_PROJECT
powershell -File "$env:TEMP\pm-workflow-skills\scripts\install.ps1"
```

Git Bash（如果已安装 Git for Windows）：

```bash
git clone https://github.com/xs2229308897/pm-workflow-skills.git /c/Users/$USER/AppData/Local/Temp/pm-workflow-skills
cd /path/to/your-project
bash /c/Users/$USER/AppData/Local/Temp/pm-workflow-skills/scripts/install.sh
```

#### 方式三：符号链接（需管理员权限）

以管理员身份打开 CMD：

```cmd
:: 替换 YOUR_PROJECT 和 PM_WORKFLOW_SKILLS 为实际路径
cd YOUR_PROJECT\.claude\skills
for /d %d in (PM_WORKFLOW_SKILLS\pm-*) do mklink /D "%~nxd" "%d"
```

或在 PowerShell（管理员）中：

```powershell
cd YOUR_PROJECT\.claude\skills
Get-ChildItem "PM_WORKFLOW_SKILLS" -Directory -Filter "pm-*" | ForEach-Object {
    New-Item -ItemType SymbolicLink -Path $_.Name -Target $_.FullName
}
```

## 配置

### 配置原型开发模板

安装后，编辑 `.claude/skills/pm-prototype-builder/SKILL.md`，将"项目规范"部分替换为你的项目技术栈：

```markdown
## 项目规范

<!-- 从以下模板中选择一个，替换本节内容 -->
<!-- 可用模板见 pm-prototype-builder/templates/ 目录 -->
```

可用模板：

| 模板文件 | 技术栈 |
|----------|--------|
| `templates/vue3-antd.md` | Vue 3 + TypeScript + Ant Design Vue + Pinia |
| `templates/react-antd.md` | React + TypeScript + Ant Design + Zustand |
| `templates/vue3-element.md` | Vue 3 + TypeScript + Element Plus + Pinia |
| `templates/vue3-naive.md` | Vue 3 + TypeScript + Naive UI + Pinia |

### 配置产出目录

默认产出目录为 `docs/superpowers/pm-output/`。如需修改，编辑 `pm-leader/SKILL.md` 中的"产出文件管理"章节。

### 经验教训（双层架构）

经验教训分两层管理，领导者启动时自动合并：

| 层级 | 文件位置 | 内容 | 更新方式 |
|------|----------|------|---------|
| 全局 | `.claude/skills/pm-leader/lessons/global-lessons.md` | 跨项目通用教训 | 随共享库 pull 更新 |
| 本地 | `docs/superpowers/pm-lessons-learned.md` | 项目特有教训 | 领导者自动维护 |

当用户纠正 PM 工作流中的问题时，领导者会判断教训类型：
- **通用教训**（如"PRD 计算逻辑必须有公式"）→ 提示是否同步到全局
- **本地教训**（如"本项目审批是三级"）→ 仅写入项目本地文件

### Hooks 配置（可选）

PM 工作流支持 Claude Code Hooks 自动化：

| Hook 事件 | 用途 |
|-----------|------|
| SubagentStart | 自动记录子 Agent 调度日志 |
| SubagentStop | 自动记录子 Agent 完成状态 |
| Stop | 会话结束时自动保存进度 |
| PreToolUse (Agent) | 校验 Agent 调用格式 |

配置方式：将 `hooks-config.example.json` 的内容合并到项目的 `.claude/settings.json`。

### MCP 工具配置（可选）

PM 工作流支持通过 MCP 协议集成外部工具：

| MCP 工具 | 增强的子 Agent | 用途 |
|----------|---------------|------|
| web-search (Brave) | 竞品分析 | 搜索竞品信息 |
| Figma | PRD、原型开发 | 获取设计稿规范 |
| pm-workflow-tools | 需求分析、PRD、数据建模 | 自动质量检查 |

配置方式：
1. 复制 `mcp-config.example.json` 到项目根目录
2. 填入 API key / token
3. 如果需要 pm-workflow-tools，先执行 `cd tools/pm-mcp-server && npm install && npm run build`

### B 端增强模式（可选）

PM 工作流支持 B 端产品管理增强。默认关闭，首次启动 `/pm-leader` 时会询问是否开启。

开启后激活的能力：

| 能力 | 说明 |
|------|------|
| PRD B 端章节 | 多租户架构、权限矩阵、系统集成、部署方案 |
| B 端数据模式 | 多租户隔离、审计字段、数据权限、通用实体模板 |
| B 端输入适配 | RFP、流程图、组织架构、合规文档 |
| B 端风险维度 | 合规、数据迁移、集成、定制化、上线割接 |
| B 端测试场景 | 多租户隔离、权限边界、审批流、批量性能 |
| 流程建模 Agent | 业务流程图、状态机、审批流配置表 |
| 权限设计 Agent | RBAC/ABAC、数据权限、多租户隔离策略 |

模式状态存储在 `docs/superpowers/pm-workflow-state.md` 的 `B 端模式` 字段中。
用户可随时说"开启/关闭 B 端模式"来切换。

### 自定义 PM 工具

`tools/pm-mcp-server/` 提供 3 个 PM 专用 MCP 工具：

| 工具 | 用途 |
|------|------|
| `assess_requirement_quality` | 评估需求清单质量（0-100 分） |
| `check_prd_consistency` | 检查 PRD 内部一致性 |
| `generate_er_diagram` | 从数据模型生成 Mermaid ER 图 |

这些工具使用纯启发式分析（正则 + 结构检测），无 LLM 调用，快速且无额外成本。

## 使用

```
/pm-leader
```

然后用自然语言描述需求：

```
# 粘贴客户聊天记录
[粘贴文本]
帮我整理需求

# 生成 PRD
根据需求清单写 PRD

# 做原型
生成可运行的原型 demo

# 收集反馈
这是用户的反馈，帮我整理新版本需求
```

## 工作流架构

```
用户 ←→ PM 领导者
           ├── 需求分析 ∥ 竞品分析（并行）
           ├── PRD 生成
           ├── 风险评估 ∥ 数据建模（并行）
           ├── 原型开发
           ├── 测试验证（独立执行）
           └── 反馈收集 → 回到需求分析（新一轮迭代）
```

子 Agent 之间通过领导者传递信息，支持动态反馈循环：

- PRD 生成发现数据模型不完整 → 领导者调度数据建模补充
- 风险评估发现高风险需求 → 领导者调度 PRD 生成标注风险
- 反馈收集产出新版本需求 → 领导者调度需求分析开始新一轮

## 自定义

### 添加新的子 Agent

1. 创建目录 `.claude/skills/pm-{name}/`
2. 创建 `SKILL.md`，遵循现有子 Agent 的格式（输入、处理流程、输出格式、自审清单、汇报格式）
3. 在 `pm-leader/SKILL.md` 的意图识别表和并行执行规则中注册新 Agent

### 修改汇报格式

所有子 Agent 使用统一的汇报格式：

```
- 状态：DONE | DONE_WITH_GAPS | BLOCKED | NEEDS_CONTEXT
- 产出：[具体内容]
- 缺口：[如有]
- 自审发现：[如有]
```

可在此基础上扩展，但建议保持这四个状态码不变，因为领导者的调度逻辑依赖它们。

## 文件结构

```
your-project/
├── .claude/skills/
│   ├── pm-leader/
│   │   ├── SKILL.md
│   │   └── lessons/
│   │       └── global-lessons.md    # 全局经验教训（跨项目通用）
│   ├── pm-requirement-analysis/SKILL.md
│   ├── pm-competitive-analysis/SKILL.md
│   ├── pm-prd-writer/SKILL.md
│   ├── pm-risk-assessor/SKILL.md
│   ├── pm-data-modeler/SKILL.md
│   ├── pm-prototype-builder/SKILL.md
│   ├── pm-test-verifier/SKILL.md
│   ├── pm-feedback-collector/SKILL.md
│   ├── pm-process-modeler/SKILL.md
│   └── pm-permission-designer/SKILL.md
├── docs/superpowers/
│   ├── pm-workflow-state.md          # 工作流状态（自动维护）
│   ├── pm-lessons-learned.md         # 本地经验教训（项目特有）
│   └── pm-output/                    # 产出目录
│       ├── v1.0/
│       │   ├── requirement-list.md
│       │   ├── competitive-analysis.md
│       │   ├── prd.md
│       │   ├── risk-assessment.md
│       │   ├── data-model.md
│       │   └── test-report.md
│       └── v2.0/
│           └── ...
└── src/                              # 你的项目源码
```

## License

MIT
