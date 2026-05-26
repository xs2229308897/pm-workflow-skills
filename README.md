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

## 安装

### macOS / Linux

#### 方式一：复制到项目（推荐）

```bash
# 克隆仓库
git clone https://github.com/YOUR_USERNAME/pm-workflow-skills.git /tmp/pm-workflow-skills

# 复制技能到项目
cp -r /tmp/pm-workflow-skills/pm-* /path/to/your-project/.claude/skills/

# 复制配套模板
mkdir -p /path/to/your-project/docs/superpowers/pm-output
cp /tmp/pm-workflow-skills/docs/superpowers/pm-workflow-state.md /path/to/your-project/docs/superpowers/
cp /tmp/pm-workflow-skills/docs/superpowers/pm-lessons-learned.md /path/to/your-project/docs/superpowers/
```

#### 方式二：使用安装脚本

```bash
git clone https://github.com/YOUR_USERNAME/pm-workflow-skills.git /tmp/pm-workflow-skills
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
git clone https://github.com/YOUR_USERNAME/pm-workflow-skills.git $env:TEMP\pm-workflow-skills

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
git clone https://github.com/YOUR_USERNAME/pm-workflow-skills.git $env:TEMP\pm-workflow-skills
cd YOUR_PROJECT
powershell -File "$env:TEMP\pm-workflow-skills\scripts\install.ps1"
```

Git Bash（如果已安装 Git for Windows）：

```bash
git clone https://github.com/YOUR_USERNAME/pm-workflow-skills.git /c/Users/$USER/AppData/Local/Temp/pm-workflow-skills
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

### 配置经验教训路径

默认路径为 `docs/superpowers/pm-lessons-learned.md`。如需修改，编辑各子 Agent 中引用此文件的位置。

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
│   ├── pm-leader/SKILL.md
│   ├── pm-requirement-analysis/SKILL.md
│   ├── pm-competitive-analysis/SKILL.md
│   ├── pm-prd-writer/SKILL.md
│   ├── pm-risk-assessor/SKILL.md
│   ├── pm-data-modeler/SKILL.md
│   ├── pm-prototype-builder/SKILL.md
│   ├── pm-test-verifier/SKILL.md
│   └── pm-feedback-collector/SKILL.md
├── docs/superpowers/
│   ├── pm-workflow-state.md      # 工作流状态（自动维护）
│   ├── pm-lessons-learned.md     # 经验教训（自动维护）
│   └── pm-output/                # 产出目录
│       ├── v1.0/
│       │   ├── requirement-list.md
│       │   ├── competitive-analysis.md
│       │   ├── prd.md
│       │   ├── risk-assessment.md
│       │   ├── data-model.md
│       │   └── test-report.md
│       └── v2.0/
│           └── ...
└── src/                          # 你的项目源码
```

## License

MIT
