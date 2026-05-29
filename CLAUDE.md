# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is a **Claude Code multi-agent skill library** for product managers. It contains prompt-based agent definitions (SKILL.md files) that orchestrate a PM workflow from requirement analysis through PRD generation, data modeling, prototyping, testing, and feedback iteration. The entry point is `/pm-leader`.

## MCP Tool Server

The only compilable code lives in `tools/pm-mcp-server/` (TypeScript, ESM):

```bash
cd tools/pm-mcp-server
npm install
npm run build    # tsc → dist/
npm start        # node dist/index.js
```

TypeScript config: ES2022 target, Node16 module resolution, strict mode. Uses `@modelcontextprotocol/sdk` and `zod`.

## Architecture

**Multi-agent orchestration:** `pm-leader/SKILL.md` is the orchestrator. It dispatches to 8+ sub-agents via Claude Code's `Agent()` tool. Sub-agents never communicate directly — all routing goes through the leader.

**Sub-agent status codes:** Every sub-agent returns one of `DONE`, `DONE_WITH_GAPS`, `BLOCKED`, `NEEDS_CONTEXT`. The leader uses these to decide next steps (re-dispatch, escalate, proceed).

**Feedback loops:** The pipeline is non-linear. Any sub-agent can request re-work from another (e.g., PRD writer discovers incomplete data model → leader re-dispatches to data modeler).

**Two-tier lessons system:**
- `lessons/global-lessons.md` — cross-project, distributed via git
- `docs/superpowers/pm-lessons-learned.md` — per-project, local only
- Leader merges both tiers into sub-agent prompts

**Versioned output:** All artifacts go to `docs/superpowers/pm-output/{version}/`. Major version = new features, minor = adjustments.

## Skill File Conventions

Each skill is a directory `pm-{name}/SKILL.md` with this structure:

```yaml
---
name: pm-{name}
description: One-line description
---
```

Standard sections: Input → Processing Flow → Output Format → Self-Audit Checklist → Report Format.

**B-mode content** lives between `<!-- B-MODE-START -->` and `<!-- B-MODE-END -->` markers. Only injected when the user enables B-mode (B2B enterprise features) at startup. Two agents are B-mode exclusive: `pm-process-modeler` and `pm-permission-designer`.

## Adding a New Sub-Agent

1. Create `pm-{name}/SKILL.md` following the standard template structure
2. Add intent recognition entry in `pm-leader/SKILL.md` (user input pattern → agent dispatch)
3. Add parallel execution rules if the new agent can run concurrently with others
4. Add feedback routing in the leader's feedback loop table
5. Register in the README skill table

## Installation Model

Skills are installed into a target project's `.claude/skills/` directory via copy, symlink, or the install scripts (`scripts/install.sh`, `scripts/install.ps1`). The hooks (`scripts/hooks/`) are optional and configured via `hooks-config.example.json`.
