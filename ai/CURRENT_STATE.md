# Current State

Last Updated: 2026-05-21

## Current Phase
Starter / Not initialized (v1.2.0)

## Current Task
None

## What Exists Now
- AI workflow files in `/ai/` (planning, rules, templates, recipes).
- Tool-native memory hooks at the repo root (`CLAUDE.md`,
  `AGENTS.md`, `.cursorrules`, `GEMINI.md`,
  `.github/copilot-instructions.md`) all point at
  `/ai/START_HERE.md`.
- Four phase-run harnesses (`run-phase.sh`, `run-phase-cursor.sh`,
  `run-phase-codex.sh`, `run-phase-copilot.sh`) sharing
  `scripts/run-phase-lib.sh`.
- **v1.2.0 conceptual model**: a "solution" (the repo) holds 1-N
  "projects" (apps/services/libraries inside it). First init
  creates the solution + first project. Subsequent projects are
  added one at a time via add-project mode.
- **Wizard kickoff (3 picks + 1 free-text)**: Platform →
  Language → Template → Feature loop → Generate. Modeled on
  IDE new-project dialogs.
- **Recipe library** (`ai/templates/recipes/`): 8 opinionated
  templates — Next.js / ASP.NET Core / Astro for web; NestJS /
  FastAPI for server; Python Typer for CLI; TS tsup for
  library; React Native for mobile. Each encodes design
  philosophy (auth handoff, migration ownership, credential
  isolation).
- **Local-First Development Rule** (v1.1.0, Always-on): bans
  CI-as-debug-loop; orders Phase-1 deliverables (local run →
  local tests → CI mirrors); defers deploy ADRs to Phase-3
  P3-T0.
- **Planning linter** (`scripts/lint-planning.py`) enforces Task
  Quality / Hygiene Hard Rules. CI runs shellcheck, planning
  lint, and Python syntax validation on every branch push and PR.
- `/docs/PROJECT_SHAPE_GALLERY.md` and `docs/CHOOSING_WEBAPP_PATH.md`
  remain as reference docs (no longer wizard inputs; useful for
  the "Custom" template fallback path).
- `.gitattributes` enforces LF line endings.
- MIT-licensed (`LICENSE`).
- Application-specific solution details have not been filled in.

## What Works
- The wizard is ready to drive a new-solution init or an
  add-project run against an existing solution.
- The 8 recipes cover the common language × platform combos;
  uncommon combos fall back to a "Custom" path that uses the
  shape gallery for guidance.
- All Hard rule blocks in `/ai/AI_RULES.md` apply with tier-
  and project-aware conditionality.

## What Is Not Built Yet
- Solution name, description, scope, target users — not filled in.
- No projects scaffolded (this is just the workflow).
- v1.2.1 work: ADOPT_PROMPT.md, KICKOFF_EXISTING_SOLUTION.md, and
  REFRESH_PROMPT.md still reference the v1.0.0 component model
  internally; refactors deferred to v1.2.1.

## Known Problems
- None.

## Important Files or Folders
- `/ai/START_HERE.md`, `/ai/AI_RULES.md`
- `/ai/templates/KICKOFF_NEW_SOLUTION.md` — Mode 1 wizard
- `/ai/templates/KICKOFF_ADD_PROJECT.md` — Mode 2 wizard
- `/ai/templates/INIT_PROMPT.md` — new-solution actor
- `/ai/templates/ADD_PROJECT_PROMPT.md` — add-project actor
- `/ai/templates/recipes/` — 8 template recipes
- `/ai/SOLUTION.md`, `/ai/EXAMPLE_SOLUTION.md`
- `/docs/PROJECT_SHAPE_GALLERY.md` (reference)

## Next Recommended Action
- New repo + first project → `/ai/templates/KICKOFF_NEW_SOLUTION.md`
- Add another project to existing solution → `/ai/templates/KICKOFF_ADD_PROJECT.md`
- Existing app, no `/ai/` yet → `/ai/templates/KICKOFF_EXISTING_SOLUTION.md`
- Older starter version → `/ai/templates/REFRESH_PROMPT.md`
