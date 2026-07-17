# AGENTS.md

This file provides guidance to Codex (Codex.ai/code) when working with code in this repository.

## Project Overview

This is a **Codex multi-agent skill library** for product managers. It contains prompt-based agent definitions (SKILL.md files) that orchestrate a PM workflow from requirement analysis through PRD generation, data modeling, prototyping, testing, and feedback iteration. The entry point is `/pm-leader`.

## MCP Tool Server

The only compilable code lives in `tools/pm-mcp-server/` (TypeScript, ESM):

```bash
cd tools/pm-mcp-server
npm install
npm run build    # tsc → dist/
npm start        # node dist/index.js
```

TypeScript config: ES2022 target, Node16 module resolution, strict mode, declarations enabled. Dependencies: `@modelcontextprotocol/sdk` and `zod`. No test framework is configured yet.

Three tools in `src/tools/`, all pure heuristic (regex + structural detection, no LLM calls):
- `assess_requirement_quality` — scores requirement lists 0–100
- `check_prd_consistency` — detects missing sections, TODOs, placeholders
- `generate_er_diagram` — parses Markdown tables + FK patterns into Mermaid ER diagrams

## Architecture

**Multi-agent orchestration:** `pm-leader/SKILL.md` is the orchestrator (~700 lines). It dispatches to 10 sub-agents (12 when B-mode is active) via Codex's `Agent()` tool. Sub-agents never communicate directly — all routing goes through the leader. Each sub-agent receives a fresh prompt with no session history inheritance.

**Agent inventory (10 standard + 2 B-mode exclusive):**

| Agent | Parallel Group | B-mode Changes |
|-------|---------------|----------------|
| `pm-requirement-analysis` | Group 1 (with competitive-analysis) | B-input adapters, implicit requirement rules |
| `pm-competitive-analysis` | Group 1 | B-dimensions (vendor comparison, TCO, compliance) |
| `pm-prd-writer` | Serial (after Group 1) | 4 extra chapters + enhanced self-audit |
| `pm-architecture-designer` | Serial | Multi-tenant architecture, SSO/LDAP, API gateway |
| `pm-risk-assessor` | Group 3 (with data-modeler, permission-designer) | 5 B-risk dimensions |
| `pm-data-modeler` | Group 3 | B-data modes, audit fields, generic entity templates |
| `pm-prototype-builder` | Serial (after Group 3) | — |
| `pm-test-verifier` | Serial | 6 B-test dimensions (multi-tenant, permission boundary, approval flow) |
| `pm-feedback-collector` | Serial (loop back to start) | — |
| `pm-process-modeler` | Serial (B-mode only) | Exclusively B-mode |
| `pm-permission-designer` | Group 3 (B-mode only) | Exclusively B-mode |

**Parallel execution:** The leader runs agents in three waves: (1) requirement-analysis ∥ competitive-analysis → (2) PRD writer → architecture designer → [process modeler if B-mode] → (3) risk-assessor ∥ data-modeler ∥ [permission-designer if B-mode] → prototype builder → test verifier → feedback collector. Feedback collector can loop back to wave 1 for a new iteration.

**Sub-agent status codes:** Every sub-agent returns one of `DONE`, `DONE_WITH_GAPS`, `BLOCKED`, `NEEDS_CONTEXT`. The leader uses these to decide next steps (re-dispatch, escalate, proceed).

**Output validation:** The leader does NOT trust status codes alone. It validates every sub-agent output: non-empty check, required section presence, no TODO/TBD placeholder text. Failed validation triggers re-dispatch.

**Feedback loops:** The pipeline is non-linear. Any sub-agent can request re-work from another (e.g., PRD writer discovers incomplete data model → leader re-dispatches to data modeler). The leader's feedback loop table in `pm-leader/SKILL.md` defines 15+ routing rules.

**Two-tier lessons system:**
- `lessons/global-lessons.md` — cross-project, distributed via git
- `docs/superpowers/pm-lessons-learned.md` — per-project, local only
- Leader merges both tiers into sub-agent prompts, deduplicates, and prompts the user to sync generic lessons back to the global file

**Session recovery:** On interruption, the `save-on-stop.sh` hook writes `docs/superpowers/pm-session-snapshot.md` with current phase, active agents, and recent output. On next `/pm-leader` start, the leader detects a snapshot and offers to resume where it left off.

**Timeout & retry:** Each sub-agent type has a configured timeout (2–8 minutes depending on complexity). Failed agents are retried up to 3 times before escalating to the user.

**Versioned output:** All artifacts go to `docs/superpowers/pm-output/{version}/`. Major version = new features, minor = adjustments. The leader supports a version comparison mode to diff outputs between versions.

## Skill File Conventions

Each skill is a directory `pm-{name}/SKILL.md` with YAML frontmatter:

```yaml
---
name: pm-{name}
description: One-line description
---
```

Standard sections: Input → Processing Flow → Output Format → Self-Audit Checklist → Report Format.

**B-mode content** lives between `<!-- B-MODE-START -->` and `<!-- B-MODE-END -->` HTML comment markers. The leader reads these markers and injects B-mode blocks only when B-mode is enabled (stored in `docs/superpowers/pm-workflow-state.md` → `B 端模式` field). Two agents are B-mode exclusive (`pm-process-modeler`, `pm-permission-designer`); five others have conditional B-mode sections.

**Prototype templates:** `pm-prototype-builder/templates/` contains 4 stack-specific templates used by the prototype builder:
- `react-antd.md` — React + TypeScript + Ant Design + Zustand
- `vue3-antd.md` — Vue 3 + TypeScript + Ant Design Vue + Pinia
- `vue3-element.md` — Vue 3 + TypeScript + Element Plus + Pinia
- `vue3-naive.md` — Vue 3 + TypeScript + Naive UI + Pinia

When modifying the prototype builder, ensure all four templates stay consistent with the base SKILL.md.

## Hooks System

Four hook scripts in `scripts/hooks/` (configured via `hooks-config.example.json` → `.Codex/settings.json`):

| Hook | Script | Behavior |
|------|--------|----------|
| `SubagentStart` | `log-subagent-start.sh` | Appends agent name + timestamp to `pm-audit.log` |
| `SubagentStop` | `log-subagent-stop.sh` | Appends status code + timestamp to `pm-audit.log` |
| `Stop` | `save-on-stop.sh` | Writes `pm-session-snapshot.md` with current state |
| `PreToolUse` (Agent) | `validate-agent-call.sh` | Validates `description` and `prompt` fields exist |

Hook paths in `hooks-config.example.json` point to `.Codex/skills/pm-leader/scripts/hooks/` — these are the installed paths in target projects, not the source paths in this repo. When editing hook scripts, update both the source (`scripts/hooks/`) and the example config if paths change.

## Adding a New Sub-Agent

1. Create `pm-{name}/SKILL.md` following the standard template (Input → Processing Flow → Output Format → Self-Audit Checklist → Report Format)
2. Add YAML frontmatter with `name` and `description`
3. If B-mode relevant: wrap B-specific content in `<!-- B-MODE-START -->` / `<!-- B-MODE-END -->` markers
4. Register in `pm-leader/SKILL.md`:
   - Intent recognition table (user input pattern → dispatch)
   - Parallel execution rules (which wave/group)
   - Feedback loop table (what triggers re-dispatch to/from this agent)
   - Output file name mapping
5. Add to the skill table in `README.md`

## Commit Convention

Follow the pattern visible in git history:

```
<type>(pm): <description>
```

Types: `feat` (new feature/agent), `fix` (bug fix), `docs` (documentation), `chore` (infrastructure).

Examples: `feat(pm): 新增 pm-process-modeler 业务流程建模 Agent`, `fix(pm): 修复 pm-prd-writer B-MODE 块的插入顺序`

## Design Documents

`docs/superpowers/plans/` and `docs/superpowers/workflow/` contain implementation plans and design documents for major enhancements. Read these before working on related areas — e.g., `2026-05-26-bpm-enhancement.md` documents the full B-mode feature design across all agents.

## Installation Model

Skills are installed into a target project's `.Codex/skills/` directory via copy, symlink, or the install scripts (`scripts/install.sh`, `scripts/install.ps1`). The hooks are optional and configured by merging `hooks-config.example.json` into the target project's `.Codex/settings.json`. MCP tools are optional and configured via `mcp-config.example.json`.
