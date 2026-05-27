# B 端 PM 工作流增强实现计划

> **面向 AI 代理的工作者：** 必需子技能：使用 superpowers:subagent-driven-development（推荐）或 superpowers:executing-plans 逐任务实现此计划。步骤使用复选框（`- [ ]`）语法来跟踪进度。

**目标：** 为 PM 工作流技能库添加 B 端产品管理能力（多租户、权限、集成、合规），通过模式开关控制，默认关闭

**架构：** 采用 `<!-- B-MODE-START -->` / `<!-- B-MODE-END -->` 标记在 SKILL.md 中隔离 B 端内容。pm-leader 读取 pm-workflow-state.md 中的 B_MODE 状态，构造子 Agent prompt 时决定是否注入 B 端章节。新增 2 个 B 端专用 Skill，仅在 B 端模式下注册到意图识别表。所有变更保持父子 Agent 架构和 4 状态码不变。

**技术栈：** Claude Code Skills (SKILL.md)、Markdown

**优先级：** P0（PRD + 数据建模）→ P1（需求分析 + 风险评估 + 测试验证）→ P1（新 Skill + pm-leader）

**工作目录：** `D:\Prototype\pm-workflow-skills\`

---

## 文件结构

### 新建文件（2 个）

| 文件路径 | 职责 |
|----------|------|
| `pm-process-modeler/SKILL.md` | 业务流程建模 Agent — 流程图、状态机、审批流配置 |
| `pm-permission-designer/SKILL.md` | 权限体系设计 Agent — RBAC/ABAC、数据权限、多租户隔离 |

### 修改文件（9 个）

| 文件路径 | 修改内容 |
|----------|---------|
| `pm-prd-writer/SKILL.md` | +4 个 B 端标准章节 + 增强非功能性/功能逻辑/自审 |
| `pm-data-modeler/SKILL.md` | +3 个处理步骤 + B 端数据模式 + B 端实体模板 + 增强自审 |
| `pm-requirement-analysis/SKILL.md` | +B 端输入类型 + 分类维度 + 隐含需求 + 增强自审 |
| `pm-risk-assessor/SKILL.md` | +5 个风险维度 + 风险缓解方案列 + 上线前检查清单 |
| `pm-test-verifier/SKILL.md` | +6 个 B 端测试维度 |
| `pm-leader/SKILL.md` | +检查 6（B 端模式开关）+ 意图表/并行规则/执行顺序/反馈循环更新 |
| `docs/superpowers/pm-workflow-state.md` | +B_MODE 状态字段 |
| `scripts/install.ps1` | 新增 B 端 Skill 安装逻辑 |
| `scripts/install.sh` | 同上 |
| `README.md` | 新增 B 端增强模式文档 |

---

## 任务分解

### 任务 1（P0）：pm-prd-writer — 添加 B 端增强内容

**文件：**
- 修改：`pm-prd-writer/SKILL.md`

- [ ] **步骤 1：在 PRD 标准章节之后、功能逻辑说明要求之前，插入 B 端标准章节**

在 `## PRD 标准章节` 的 `8. 非功能性需求` 之后，添加：

```markdown
<!-- B-MODE-START -->
**B 端增强章节（仅 B 端模式）：**

9. 多租户架构方案
   - 租户隔离模式选择（共享表/Schema 隔离/数据库隔离）及理由
   - 租户管理功能（租户注册/审核/停用/配额管理）
   - 租户级配置隔离（功能开关、业务规则、UI 定制）

10. 权限矩阵
    - 角色×功能×数据范围 三维矩阵表
    - SSO/LDAP 集成方案（协议选择、字段映射、回退策略）
    - 超级管理员和租户管理员的权限边界

11. 系统集成接口规范
    - API 契约（RESTful 规范、版本策略、认证方式）
    - Webhook 事件定义（事件类型、payload 格式、重试策略）
    - 数据同步策略（全量/增量、频率、冲突解决）

12. 部署与运维方案
    - 部署方式（SaaS/私有化/混合云）
    - 环境要求（硬件/网络/依赖服务）
    - 监控告警（关键指标、阈值、通知渠道）
<!-- B-MODE-END -->
```

- [ ] **步骤 2：增强"非功能性需求"章节**

在 `## 功能逻辑说明要求` 之前的 `## 非功能性需求` 引导行之后（或在功能逻辑说明要求之后），添加增强内容。在现有章节末尾追加：

```markdown
<!-- B-MODE-START -->
**B 端非功能性需求增强（仅 B 端模式）：**

- **可用性**：SLA 指标（如 99.9%）、故障恢复时间（RTO）、数据恢复点（RPO）
- **安全性**：数据加密方案（传输层 TLS/存储层 AES-256）、审计日志（操作人/时间/IP/变更内容）、数据脱敏规则（手机号/身份证/银行卡）
- **可扩展性**：并发用户数预期、数据量增长预期（3 年）、水平扩展方案
<!-- B-MODE-END -->
```

- [ ] **步骤 3：增强"功能逻辑说明要求"**

在功能逻辑说明要求的列表末尾，添加：

```markdown
<!-- B-MODE-START -->
**B 端功能逻辑增强（仅 B 端模式）：**

- 审批流设计（多级审批/条件分支/会签/加签/回退/超时自动处理）
- 数据权限逻辑（行级：本人/本部门/全公司；列级：敏感字段脱敏；部门级：组织架构树过滤）
<!-- B-MODE-END -->
```

- [ ] **步骤 4：增强"自审清单"**

在自审清单末尾，添加：

```markdown
<!-- B-MODE-START -->
**B 端自审项（仅 B 端模式）：**

- 多租户隔离方案是否明确？
- 权限矩阵是否覆盖所有角色和功能？
- 集成接口是否定义了契约和错误处理？
- 非功能性需求是否有量化指标？
<!-- B-MODE-END -->
```

- [ ] **步骤 5：Commit**

```bash
git add pm-prd-writer/SKILL.md
git commit -m "feat(pm): pm-prd-writer 添加 B 端增强内容（4 章节+增强自审）"
```

---

### 任务 2（P0）：pm-data-modeler — 添加 B 端增强内容

**文件：**
- 修改：`pm-data-modeler/SKILL.md`

- [ ] **步骤 1：在处理流程中添加 B 端步骤**

在 `## 处理流程` 的步骤 5 之后，添加：

```markdown
<!-- B-MODE-START -->
**B 端处理步骤（仅 B 端模式）：**

6. 判断是否需要多租户支持，选择隔离模式
7. 为每个实体添加审计字段模板
8. 识别是否需要数据权限字段
<!-- B-MODE-END -->
```

- [ ] **步骤 2：在 MCP 工具增强之后、处理流程之前，添加 B 端数据模式知识**

在 `## MCP 工具增强` 之后添加：

```markdown
<!-- B-MODE-START -->
## B 端数据模式知识（仅 B 端模式）

### 多租户隔离模式

**共享表模式（推荐中小规模）：**
- 每个业务表增加 `tenant_id` 字段
- 所有查询强制添加 `WHERE tenant_id = ?` 过滤
- 优点：简单、成本低；缺点：隔离性较弱

**Schema 隔离模式（推荐中大规模）：**
- 每个租户独立 Schema，共享同一数据库
- 应用层根据租户切换 Schema
- 优点：隔离性好；缺点：Schema 管理复杂

**数据库隔离模式（推荐大规模/合规要求高）：**
- 每个租户独立数据库
- 优点：完全隔离；缺点：成本高、运维复杂

### 审计字段模板

每个业务实体必须包含：
- `created_by` VARCHAR(64) — 创建人
- `created_at` TIMESTAMP — 创建时间
- `updated_by` VARCHAR(64) — 最后修改人
- `updated_at` TIMESTAMP — 最后修改时间
- `deleted_at` TIMESTAMP NULL — 软删除标记

### 数据权限字段

需要数据权限控制的实体增加：
- `org_id` VARCHAR(64) — 所属组织
- `data_scope` VARCHAR(32) — 数据范围（personal/department/company）

### 软删除模式

- 使用 `deleted_at` 字段标记删除（NULL = 未删除）
- 所有查询添加 `WHERE deleted_at IS NULL` 过滤
- 索引需包含 `deleted_at` 字段

## B 端通用实体模板（仅 B 端模式）

以下实体在 B 端项目中几乎必然存在，建模时应自动包含：

| 实体 | 用途 | 核心字段 |
|------|------|---------|
| users | 用户表 | id, username, email, phone, password_hash, status, tenant_id |
| roles | 角色表 | id, name, code, description, tenant_id |
| permissions | 权限表 | id, name, code, type (menu/button/api), resource |
| user_roles | 用户角色关联 | user_id, role_id |
| role_permissions | 角色权限关联 | role_id, permission_id |
| organizations | 组织架构 | id, name, parent_id, level, tenant_id |
| approval_records | 审批记录 | id, biz_type, biz_id, action, approver_id, opinion, created_at |
| operation_logs | 操作日志 | id, user_id, action, resource, detail, ip, created_at |
<!-- B-MODE-END -->
```

- [ ] **步骤 3：增强自审清单**

在自审清单末尾，添加：

```markdown
<!-- B-MODE-START -->
**B 端自审项（仅 B 端模式）：**

- 是否为所有实体添加了审计字段？
- 多租户隔离模式是否明确？
- 是否包含 B 端通用实体？
- 数据权限字段是否设计？
<!-- B-MODE-END -->
```

- [ ] **步骤 4：Commit**

```bash
git add pm-data-modeler/SKILL.md
git commit -m "feat(pm): pm-data-modeler 添加 B 端数据模式和通用实体模板"
```

---

### 任务 3（P1）：pm-requirement-analysis — 添加 B 端增强内容

**文件：**
- 修改：`pm-requirement-analysis/SKILL.md`

- [ ] **步骤 1：增强输入类型**

在 `## 输入` 的列表末尾，添加：

```markdown
<!-- B-MODE-START -->
**B 端输入源（仅 B 端模式）：**

- 客户 RFP/招标文件
- 业务流程图（As-Is 现状流程）
- 现有系统操作手册
- 客户组织架构描述
- 行业法规/合规要求文档
<!-- B-MODE-END -->
```

- [ ] **步骤 2：在处理流程之后、输出格式之前，添加 B 端需求分类维度和隐含需求规则**

在 `## 处理流程` 之后添加：

```markdown
<!-- B-MODE-START -->
## B 端需求分类增强（仅 B 端模式）

### 额外分类维度

在标准分类之外，增加以下维度：

- **按角色**：管理员 / 操作员 / 审计员 / 访客
- **按租户层级**：平台级（所有租户共享）/ 租户级（每租户独立）/ 部门级（租户内部门隔离）
- **按业务流程**：流程节点需求 / 审批规则需求 / 异常处理需求

### B 端隐含需求补充规则

当需求涉及以下场景时，自动补充对应的隐含需求：

| 触发场景 | 自动补充的隐含需求 |
|---------|------------------|
| 任何数据展示 | 数据导出（Excel/CSV/PDF） |
| 任何用户操作 | 操作日志（谁在什么时间做了什么） |
| 列表/表格页面 | 批量操作（批量导入/批量审批/批量分配） |
| 审批/流程操作 | 异常恢复（操作撤回/数据回滚/审批回退） |
| PC 端功能 | 多端适配（PC + 移动端 + 大屏） |
| 状态变更/提醒 | 通知机制（站内信/邮件/短信/企业微信/钉钉） |
<!-- B-MODE-END -->
```

- [ ] **步骤 3：增强自审清单**

在自审清单末尾，添加：

```markdown
<!-- B-MODE-START -->
**B 端自审项（仅 B 端模式）：**

- 是否按角色维度分类了需求？
- 是否补充了 B 端隐含需求（导出/日志/批量/恢复/多端/通知）？
- 是否识别了租户层级相关需求？
<!-- B-MODE-END -->
```

- [ ] **步骤 4：Commit**

```bash
git add pm-requirement-analysis/SKILL.md
git commit -m "feat(pm): pm-requirement-analysis 添加 B 端输入适配和隐含需求规则"
```

---

### 任务 4（P1）：pm-risk-assessor — 添加 B 端增强内容

**文件：**
- 修改：`pm-risk-assessor/SKILL.md`

- [ ] **步骤 1：在处理流程之后、输出格式之前，添加 B 端风险维度**

在 `## 处理流程` 之后添加：

```markdown
<!-- B-MODE-START -->
## B 端风险维度（仅 B 端模式）

在标准风险评估之外，增加以下风险维度：

| 风险类型 | 评估内容 | 触发条件 |
|---------|---------|---------|
| 合规风险 | 是否满足行业法规（等保/GDPR/SOC2/HIPAA） | 涉及数据存储/跨境/敏感信息 |
| 数据迁移风险 | 源系统数据质量、字段映射复杂度、回滚可行性 | 替换旧系统 |
| 集成风险 | 第三方系统 API 稳定性、文档完整性、联调周期 | 与外部系统对接 |
| 客户定制化风险 | 需求蔓延概率、定制化对产品化的影响 | 多客户需求差异大 |
| 上线割接风险 | 业务中断时长、数据一致性、回滚预案 | 替换生产系统 |
<!-- B-MODE-END -->
```

- [ ] **步骤 2：增强输出格式**

在输出格式之后添加：

```markdown
<!-- B-MODE-START -->
**B 端输出增强（仅 B 端模式）：**

4. 风险矩阵增加"风险缓解方案"列（每个风险对应具体缓解措施）
5. 上线前风险检查清单（按风险类型分组，逐项确认）
<!-- B-MODE-END -->
```

- [ ] **步骤 3：增强自审清单**

在自审清单末尾，添加：

```markdown
<!-- B-MODE-START -->
**B 端自审项（仅 B 端模式）：**

- 是否评估了合规风险？
- 是否评估了数据迁移和集成风险？
- 风险矩阵是否包含缓解方案？
- 是否生成了上线前检查清单？
<!-- B-MODE-END -->
```

- [ ] **步骤 4：Commit**

```bash
git add pm-risk-assessor/SKILL.md
git commit -m "feat(pm): pm-risk-assessor 添加 B 端风险维度和缓解方案"
```

---

### 任务 5（P1）：pm-test-verifier — 添加 B 端增强内容

**文件：**
- 修改：`pm-test-verifier/SKILL.md`

- [ ] **步骤 1：在处理流程之后、输出格式之前，添加 B 端测试维度**

在 `## 处理流程` 之后添加：

```markdown
<!-- B-MODE-START -->
## B 端测试维度（仅 B 端模式）

在标准测试用例之外，增加以下 B 端专项测试：

| 测试类型 | 测试内容 | 验收标准 |
|---------|---------|---------|
| 多租户数据隔离 | 租户 A 不能看到租户 B 的数据 | 所有 API 和页面均需验证 |
| 权限边界测试 | 越权操作验证（低权限用户访问高权限功能） | 所有受保护功能均需覆盖 |
| 审批流完整性 | 多级/会签/回退/超时自动处理 | 所有审批路径均需验证 |
| 批量数据性能 | 批量导入/导出/审批的性能 | 万级数据量下响应时间可接受 |
| 并发操作测试 | 多用户同时操作同一资源 | 无数据丢失或状态异常 |
| 数据迁移验证 | 源系统 → 目标系统的数据完整性 | 字段映射正确、数据无丢失 |
<!-- B-MODE-END -->
```

- [ ] **步骤 2：增强自审清单**

在自审清单末尾，添加：

```markdown
<!-- B-MODE-START -->
**B 端自审项（仅 B 端模式）：**

- 是否包含多租户数据隔离测试？
- 是否包含权限边界测试？
- 是否包含审批流完整性测试？
- 是否包含批量数据和并发操作测试？
<!-- B-MODE-END -->
```

- [ ] **步骤 3：Commit**

```bash
git add pm-test-verifier/SKILL.md
git commit -m "feat(pm): pm-test-verifier 添加 B 端测试维度"
```

---

### 任务 6（P1）：创建 pm-process-modeler Skill

**文件：**
- 创建：`pm-process-modeler/SKILL.md`

- [ ] **步骤 1：创建完整 SKILL.md**

```markdown
---
name: pm-process-modeler
description: 从需求中提取业务流程，生成流程图、状态机图、审批流配置表
---

# 业务流程建模 Agent

从需求描述中提取业务流程，生成 Mermaid 流程图、状态机图和审批流配置表。仅在 B 端增强模式下可被调度。

## 输入

- 需求清单（来自需求分析 Agent）
- PRD 中的功能逻辑说明（来自 PRD 生成 Agent）
- 经验教训（从 pm-lessons-learned.md 注入）

## 处理流程

1. 识别需求中的业务流程和状态流转
2. 生成 Mermaid flowchart 流程图（正常路径 + 异常路径）
3. 生成 Mermaid stateDiagram 状态机图（所有状态 + 转换条件）
4. 生成审批流配置表（节点类型/审批角色/条件表达式/SLA 时限/超时处理）
5. 识别异常流程和边界条件

## 输出格式

1. **业务流程图**（Mermaid flowchart）
   - 覆盖所有正常路径和异常路径
   - 标注分支条件和循环

2. **状态机图**（Mermaid stateDiagram）
   - 所有状态和转换条件
   - 初始状态和终止状态

3. **审批流配置表**

   | 节点名称 | 节点类型 | 审批角色 | 条件表达式 | SLA 时限 | 超时处理 |
   |---------|---------|---------|-----------|---------|---------|

4. **异常流程清单**
   - 异常场景描述
   - 触发条件
   - 处理方式

## 自审清单

- 流程图是否覆盖所有正常路径和异常路径？
- 状态机是否包含所有状态和转换条件？
- 审批流是否支持多级/条件分支/会签/加签/回退？
- SLA 时限是否合理？
- 异常流程是否完整识别？

## 汇报格式

- 状态：DONE | DONE_WITH_GAPS | BLOCKED | NEEDS_CONTEXT
- 产出：流程建模文档（流程图 + 状态机 + 审批配置表）
- 缺口：如有，列出需要补充的流程或状态
- 自审发现：如有

## 在流水线中的位置

PRD 生成之后、数据建模之前（流程决定数据结构）。

## 反馈循环

- 流程建模发现需求不完整 → 领导者调度需求分析深化
- 流程建模发现 PRD 逻辑缺失 → 领导者调度 PRD 生成补充
- 流程建模完成 → 数据建模使用流程定义设计数据结构
```

- [ ] **步骤 2：Commit**

```bash
git add pm-process-modeler/SKILL.md
git commit -m "feat(pm): 新增 pm-process-modeler 业务流程建模 Agent"
```

---

### 任务 7（P1）：创建 pm-permission-designer Skill

**文件：**
- 创建：`pm-permission-designer/SKILL.md`

- [ ] **步骤 1：创建完整 SKILL.md**

```markdown
---
name: pm-permission-designer
description: 设计 RBAC/ABAC 权限模型、数据权限方案、多租户隔离策略
---

# 权限体系设计 Agent

设计完整的权限体系，包括 RBAC 权限模型、数据权限方案和多租户隔离策略。仅在 B 端增强模式下可被调度。

## 输入

- PRD 中的功能列表和角色定义（来自 PRD 生成 Agent）
- 客户组织架构描述（来自需求分析 Agent）
- 经验教训（从 pm-lessons-learned.md 注入）

## 处理流程

1. 提取 PRD 中的角色和功能列表
2. 设计 RBAC 权限模型（角色-权限矩阵）
3. 设计数据权限方案（行级/列级/部门级）
4. 设计多租户隔离策略（共享表/Schema/数据库）
5. 设计 SSO/LDAP 集成接口规范
6. 生成权限配置表和初始化数据

## 输出格式

1. **角色-权限矩阵**

   | 角色 | 功能模块 | 操作权限 | 数据范围 |
   |------|---------|---------|---------|
   | 超级管理员 | 全部 | 读写删 | 全公司 |
   | 租户管理员 | 租户内 | 读写删 | 本租户 |
   | 操作员 | 指定模块 | 读写 | 本部门 |
   | 审计员 | 审计模块 | 只读 | 全公司 |
   | 访客 | 公开模块 | 只读 | 无 |

2. **数据权限规则表**

   | 数据类型 | 权限维度 | 控制方式 | 规则 |
   |---------|---------|---------|------|

3. **多租户架构方案文档**
   - 隔离模式选择及理由
   - 租户管理功能设计
   - 配额管理策略

4. **SSO/LDAP 集成接口规范**
   - 协议选择（SAML 2.0/OIDC/LDAP）
   - 字段映射（外部用户 → 系统用户）
   - 回退策略（SSO 不可用时的处理）

5. **权限初始化 SQL 脚本模板**
   - 角色初始化数据
   - 权限初始化数据
   - 默认角色-权限关联

## 自审清单

- 角色是否覆盖所有业务角色（管理员/操作员/审计员/访客）？
- 权限是否覆盖所有功能模块？
- 数据权限是否支持行级和列级控制？
- 多租户隔离模式是否与部署方案匹配？
- SSO/LDAP 接口是否符合目标系统的协议？

## 汇报格式

- 状态：DONE | DONE_WITH_GAPS | BLOCKED | NEEDS_CONTEXT
- 产出：权限体系设计文档
- 缺口：如有，列出需要补充的角色或权限
- 自审发现：如有

## 在流水线中的位置

PRD 生成之后，与数据建模并行（都依赖 PRD，但彼此无依赖）。

## 反馈循环

- 权限设计发现角色定义不完整 → 领导者调度 PRD 生成补充
- 权限设计完成 → 数据建模使用权限定义设计权限相关表结构
- 权限设计完成 → 原型开发使用权限矩阵生成权限配置页
```

- [ ] **步骤 2：Commit**

```bash
git add pm-permission-designer/SKILL.md
git commit -m "feat(pm): 新增 pm-permission-designer 权限体系设计 Agent"
```

---

### 任务 8：pm-leader — 添加 B 端模式开关和调度规则

**文件：**
- 修改：`pm-leader/SKILL.md`

- [ ] **步骤 1：在"检查 5：Claude Code Hooks"之后、"检查完成后"之前，添加检查 6**

在 `用户拒绝：跳过，不影响正常使用。` 之后、`### 检查完成后` 之前，插入：

```markdown
### 检查 6：是否开启 B 端增强模式

读取 `docs/superpowers/pm-workflow-state.md`，检查是否已有 `B 端模式` 字段。

**如果字段不存在（首次询问）：**

向用户展示：

```
是否开启 B 端增强模式？

开启后，以下能力将被激活：
  - PRD 新增 4 个 B 端标准章节（多租户架构、权限矩阵、系统集成、部署方案）
  - 数据建模使用 B 端数据模式（多租户隔离、审计字段、数据权限）
  - 需求分析适配 B 端输入源（RFP、流程图、组织架构）
  - 风险评估新增 B 端风险维度（合规、迁移、集成、割接）
  - 测试验证新增 B 端测试场景（多租户隔离、权限边界、审批流）
  - 新增流程建模和权限设计两个子 Agent

  1. 开启 B 端增强
  2. 不开启（使用标准模式）
```

用户选择后：
- 将 `B 端模式：已开启` 或 `B 端模式：未开启` 写入 `docs/superpowers/pm-workflow-state.md`
- 向用户确认选择

**如果字段已存在：**
- 不再询问，使用已有设置
- 用户可随时说"切换项目类型"或"开启/关闭 B 端模式"来修改

**B 端模式对子 Agent 的影响：**
- 开启时：pm-leader 构造子 Agent prompt 时，从其 SKILL.md 中提取 `<!-- B-MODE-START -->` 到 `<!-- B-MODE-END -->` 之间的内容，注入 prompt
- 关闭时：忽略所有 B 端内容，仅使用标准章节
- pm-process-modeler 和 pm-permission-designer 仅在 B 端模式开启时可被调度
```

- [ ] **步骤 2：在意图识别表中添加 B 端意图**

在意图识别表的 `"方案对比"` 行之后、`"不确定"` 行之前，添加：

```markdown
| "画流程" / "审批流" / "状态机" / "流程图" | 流程建模 | 调用流程建模 Agent（仅 B 端模式） |
| "权限设计" / "多租户" / "RBAC" / "权限矩阵" | 权限设计 | 调用权限设计 Agent（仅 B 端模式） |
```

- [ ] **步骤 3：更新并行执行规则**

在 `**可并行的组合**` 列表中，添加：

```markdown
- 权限设计 ∥ 数据建模（都依赖 PRD，但彼此无依赖）
```

在 `**必须串行的组合**` 列表中，添加：

```markdown
- PRD 生成 → 流程建模
- 流程建模 → 数据建模
```

更新 `**默认执行顺序**` 为：

```markdown
**默认执行顺序**：
1. 需求分析 ∥ 竞品分析（并行）
2. PRD 生成
3. 流程建模（仅 B 端模式，串行）
4. 权限设计 ∥ 数据建模（并行，B 端模式下权限设计加入）
5. 风险评估（可与步骤 4 并行）
6. 原型开发
7. 测试验证
8. 反馈收集 → 回到第 1 步
```

- [ ] **步骤 4：添加 B 端反馈循环规则**

在 `## 动态反馈循环规则` 表格末尾，添加：

```markdown
| 流程建模 | 需求描述不完整 | → 需求分析深化 |
| 流程建模 | PRD 逻辑缺失 | → PRD 生成补充 |
| 流程建模 | 流程定义完成 | → 数据建模 + 权限设计使用 |
| 权限设计 | 角色定义不完整 | → PRD 生成补充 |
| 权限设计 | 权限设计完成 | → 数据建模使用 |
```

- [ ] **步骤 5：在子 Agent 调用方式章节，添加 B 端 prompt 注入说明**

在 `## 子 Agent 调用方式` 的 `每个子 Agent 获得全新构造的 prompt` 之后，添加：

```markdown
**B 端模式 prompt 注入：**
当 B 端模式开启时，领导者在构造子 Agent prompt 时，从对应 SKILL.md 中提取 `<!-- B-MODE-START -->` 到 `<!-- B-MODE-END -->` 之间的内容，附加到标准 prompt 之后。子 Agent 无需自行判断是否为 B 端模式。
```

- [ ] **步骤 6：在产出文件管理中添加 B 端产出文件**

在产出文件管理的目录结构中，在 `test-report.md` 之后添加：

```markdown
│   ├── process-model.md      # 流程建模（仅 B 端模式）
│   └── permission-design.md  # 权限设计（仅 B 端模式）
```

- [ ] **步骤 7：Commit**

```bash
git add pm-leader/SKILL.md
git commit -m "feat(pm): pm-leader 添加 B 端模式开关、意图识别和调度规则"
```

---

### 任务 9：更新 pm-workflow-state.md 模板

**文件：**
- 修改：`docs/superpowers/pm-workflow-state.md`

- [ ] **步骤 1：在文件头信息之后添加 B 端模式字段**

在 `## 最后更新：[日期]` 之后、`## 阶段详情` 之前，添加：

```markdown
## B 端模式：未开启
```

- [ ] **步骤 2：在阶段详情中添加 B 端阶段**

在 `### 反馈收集 ⏳` 之后、`## 关键决策记录` 之前，添加：

```markdown
### 流程建模 ⏳（仅 B 端模式）
- 子 Agent：流程建模
- 产出：-
- 状态：待执行

### 权限设计 ⏳（仅 B 端模式）
- 子 Agent：权限设计
- 产出：-
- 状态：待执行
```

- [ ] **步骤 3：Commit**

```bash
git add docs/superpowers/pm-workflow-state.md
git commit -m "feat(pm): pm-workflow-state 模板添加 B 端模式字段和阶段"
```

---

### 任务 10：更新安装脚本和 README

**文件：**
- 修改：`scripts/install.ps1`
- 修改：`scripts/install.sh`
- 修改：`README.md`

- [ ] **步骤 1：更新 install.ps1 — 在技能文件复制循环之后添加 B 端 Skill 提示**

在技能文件复制循环（`foreach ($dir in $skillDirs)` 块）之后、`Copying global lessons` 之前，添加：

```powershell
Write-Host ""
Write-Host "B-mode skills (pm-process-modeler, pm-permission-designer) are included above." -ForegroundColor Green
Write-Host "  These skills are only active when B-mode is enabled in pm-leader." -ForegroundColor Gray
```

- [ ] **步骤 2：更新 install.sh — 在技能文件复制循环之后添加 B 端 Skill 提示**

在技能文件复制循环（`for skill_dir in "$SKILL_DIR"/pm-*` 块）之后、`# 复制全局经验教训` 之前，添加：

```bash
echo ""
echo "B 端增强 Skill（pm-process-modeler、pm-permission-designer）已包含在上方安装中。"
echo "  这些 Skill 仅在 pm-leader 中开启 B 端模式后生效。"
```

- [ ] **步骤 3：更新 README.md — 在"自定义 PM 工具"之前添加 B 端增强模式文档**

在 `### MCP 工具配置（可选）` 之后、`### 自定义 PM 工具` 之前，添加：

```markdown
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
```

- [ ] **步骤 4：更新 README.md — 更新文件结构和 Skills 表**

在 `## 包含的 Skills` 表格末尾，在 `pm-feedback-collector` 行之后添加：

```markdown
| `pm-process-modeler` | 流程建模 — 业务流程图、状态机、审批流配置（仅 B 端模式） |
| `pm-permission-designer` | 权限设计 — RBAC/ABAC、数据权限、多租户隔离（仅 B 端模式） |
```

在文件结构的 `skills/` 目录中添加：

```markdown
│   ├── pm-process-modeler/SKILL.md
│   └── pm-permission-designer/SKILL.md
```

- [ ] **步骤 5：Commit**

```bash
git add scripts/install.ps1 scripts/install.sh README.md
git commit -m "docs(pm): 安装脚本和 README 添加 B 端增强模式文档"
```

---

### 任务 11：最终验证

- [ ] **步骤 1：验证所有新文件存在**

```bash
ls -la pm-process-modeler/SKILL.md
ls -la pm-permission-designer/SKILL.md
```

- [ ] **步骤 2：验证所有 SKILL.md 包含 B-MODE 标记**

```bash
grep -l "B-MODE-START" pm-*/SKILL.md
```

预期输出：pm-prd-writer、pm-data-modeler、pm-requirement-analysis、pm-risk-assessor、pm-test-verifier 共 5 个文件。

- [ ] **步骤 3：验证 pm-leader 包含所有新增内容**

```bash
grep -c "检查 6" pm-leader/SKILL.md
grep -c "B 端增强模式" pm-leader/SKILL.md
grep -c "流程建模" pm-leader/SKILL.md
grep -c "权限设计" pm-leader/SKILL.md
```

每个 grep 应返回至少 1。

- [ ] **步骤 4：验证 pm-workflow-state.md 包含 B 端字段**

```bash
grep "B 端模式" docs/superpowers/pm-workflow-state.md
```

预期输出包含 `## B 端模式：未开启`。

- [ ] **步骤 5：验证 JSON 和 Markdown 文件格式**

```bash
# 检查新增 SKILL.md 的 frontmatter
head -3 pm-process-modeler/SKILL.md
head -3 pm-permission-designer/SKILL.md
```

- [ ] **步骤 6：最终 Commit（如有遗漏）**

```bash
git add -A
git status
git commit -m "feat(pm): 完成 B 端 PM 工作流增强（5 增强 + 2 新 Skill + 模式开关）"
```

---

## 验证标准

- [ ] pm-leader 启动时询问是否开启 B 端增强模式（检查 6）
- [ ] B 端模式状态写入 pm-workflow-state.md，后续启动不再询问
- [ ] B 端模式开启时：pm-prd-writer SKILL.md 包含 `<!-- B-MODE-START -->` 标记，含 4 个 B 端章节
- [ ] B 端模式关闭时：pm-leader 不注入 B 端内容，子 Agent 仅使用标准章节
- [ ] B 端模式开启时：pm-data-modeler 包含 B 端数据模式和通用实体模板
- [ ] B 端模式开启时：pm-requirement-analysis 包含 B 端输入源和隐含需求规则
- [ ] B 端模式开启时：pm-risk-assessor 包含 5 个 B 端风险维度
- [ ] B 端模式开启时：pm-test-verifier 包含 6 个 B 端测试维度
- [ ] pm-process-modeler/SKILL.md 创建成功，包含完整处理流程和输出格式
- [ ] pm-permission-designer/SKILL.md 创建成功，包含 RBAC 设计和输出格式
- [ ] pm-leader 意图识别表包含流程建模和权限设计（仅 B 端模式生效）
- [ ] pm-leader 并行规则和执行顺序已更新
- [ ] pm-leader 反馈循环规则包含流程建模和权限设计
- [ ] pm-workflow-state.md 包含 B 端模式字段和 B 端阶段
- [ ] 安装脚本和 README 已更新
- [ ] 所有变更保持父子 Agent 架构和 4 状态码不变
