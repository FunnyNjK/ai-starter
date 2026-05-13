# Current State

Last Updated: 2026-05-13

## Current Phase
Starter / Not initialized

## Current Task
None

## What Exists Now
- AI project starter files in `/ai/` (workflow, planning, rules,
  templates, reference).
- Tool-native memory hooks at the repo root (`CLAUDE.md`,
  `AGENTS.md`, `.cursorrules`, `GEMINI.md`,
  `.github/copilot-instructions.md`) all point at
  `/ai/START_HERE.md`.
- Four phase-run harnesses (`run-phase.sh`, `run-phase-cursor.sh`,
  `run-phase-codex.sh`, `run-phase-copilot.sh`) one per major
  agentic AI CLI, sharing `scripts/run-phase-lib.sh`.
- Friendly interview prompts (`KICKOFF_NEW_PROJECT.md`,
  `KICKOFF_EXISTING_PROJECT.md`) and three setup actors
  (`INIT_PROMPT.md`, `ADOPT_PROMPT.md`, `REFRESH_PROMPT.md`).
- v1.0.0 conceptual model: behavioral diagnostic (D1-D5) classifies
  projects into 1-N components per `/docs/PROJECT_SHAPE_GALLERY.md`,
  picks rungs per component, sets a complexity tier (solo prototype
  / small team / production), runs per-component dimension walks
  pre-filled from rung defaults, asks cross-component questions
  (monorepo, versioning, shared identity/CI/design), builds a
  composite Mermaid diagram, runs a budget reality check, and ends
  with a Pre-flight self-check before generating the INIT prompt.
- **`/docs/PROJECT_SHAPE_GALLERY.md`** — reference catalog of 9
  component types × 4-6 rungs each, with role-labeled Mermaid
  diagrams and default-dimensions blocks.
- **Rule Applicability** in `AI_RULES.md` — Infrastructure & Hosting
  and Cost Hard rules are conditional on hosted-component presence
  and tier; the resolved rule set is recorded in `/ai/PROJECT.md`.
- `.gitattributes` enforces LF line endings.
- Planning linter (`scripts/lint-planning.py`) enforces Task Quality
  / Hygiene Hard Rules. CI runs shellcheck, planning lint, and
  Python helper syntax validation on every branch push and PR.
  Security CI template is a failing guardrail until real
  SAST/dependency-update config is present.
- `docs/CHOOSING_WEBAPP_PATH.md` is the web-app decision tree
  (complement to the gallery).
- MIT-licensed (`LICENSE`).
- Application-specific project details have not been filled in.
- No tech stack, hosting target, or tooling has been chosen yet.

## What Works
- The AI workflow is ready to drive a project initialization session
  for any of the 9 component shapes (or composites).
- All 10 (Hard) rule blocks in `/ai/AI_RULES.md` apply with tier-
  and component-aware conditionality.
- Kickoff templates have Pre-flight self-checks that force example/
  default offering, dimension coverage, diagram renders, budget
  reality check, and verbatim user confirmation.

## What Is Not Built Yet
- Project name, description, scope, target users — not filled in.
- Application code does not exist (this is just the workflow).

## Known Problems
- None.

## Important Files or Folders
- `/ai/START_HERE.md`, `/ai/AI_RULES.md` (10 blocks + Applicability)
- `/ai/templates/KICKOFF_NEW_PROJECT.md`,
  `/ai/templates/KICKOFF_EXISTING_PROJECT.md` — v1.0.0 interviews
- `/ai/templates/INIT_PROMPT.md` — v1.0.0 with components + tier
- `/docs/PROJECT_SHAPE_GALLERY.md` — component+rung reference
- `/ai/EXAMPLE_PROJECT.md`, `/ai/WORKFLOW.md`, `/ai/PROJECT.md`,
  `/ai/ARCHITECTURE.md`, `/ai/DECISIONS.md`, `/ai/TASKS.md`,
  `/ai/HANDOFF.md`

## Next Recommended Action
- New project → `/ai/templates/KICKOFF_NEW_PROJECT.md`
- Existing app → `/ai/templates/KICKOFF_EXISTING_PROJECT.md`
- Older starter version → `/ai/templates/REFRESH_PROMPT.md`
