# Current State

Last Updated: 2026-05-10

## Current Phase
Starter / Not initialized

## Current Task
None

## What Exists Now
- AI project starter files exist in `/ai/` (workflow, planning, rules,
  templates, reference).
- Tool-native memory hooks at the repo root (`CLAUDE.md`, `AGENTS.md`,
  `.cursorrules`, `GEMINI.md`, `.github/copilot-instructions.md`) all
  point at `/ai/START_HERE.md`.
- Four phase-run harnesses (`run-phase.sh`, `run-phase-cursor.sh`,
  `run-phase-codex.sh`, `run-phase-copilot.sh`) one per major agentic
  AI CLI.
- Friendly interview prompts (`KICKOFF_NEW_PROJECT.md`,
  `KICKOFF_EXISTING_PROJECT.md`) and three setup actors
  (`INIT_PROMPT.md`, `ADOPT_PROMPT.md`, `REFRESH_PROMPT.md`).
- MIT-licensed (`LICENSE`).
- Application-specific project details have not yet been filled in.
- No tech stack, hosting target, or tooling has been chosen yet.

## What Works
- The AI workflow is ready to drive a project initialization session.
- 10 (Hard) rule blocks in `/ai/AI_RULES.md` constrain AI behavior across
  Git, planning hygiene, versioning, security, infrastructure, cost,
  destructive operations, reasoning checkpoints, blocked escalation,
  and task quality.

## What Is Not Built Yet
- Project name, description, scope, target users — not filled in.
- Application code does not exist yet (this is just the workflow).

## Known Problems
- None.

## Important Files or Folders
- `/ai/START_HERE.md` — main AI entry file
- `/ai/AI_RULES.md` — hard rules (10 (Hard) blocks)
- `/ai/templates/INIT_PROMPT.md` — first-time initialization prompt
- `/ai/templates/REFRESH_PROMPT.md` — older-project housekeeping prompt
- `/ai/EXAMPLE_PROJECT.md` — worked reference example
- `/ai/WORKFLOW.md` — branching, PRs, hotfix, blocked escalation
- `/ai/SPEC.md`, `/ai/BUDGET.md` — placeholders for project behavior
  + cost (filled at init)
- `/ai/PROJECT.md`, `/ai/ARCHITECTURE.md`, `/ai/DECISIONS.md`,
  `/ai/TASKS.md`, `/ai/HANDOFF.md` — core planning files

## Next Recommended Action
Pick the right entry point and paste it into your AI tool:

- New project → `/ai/templates/KICKOFF_NEW_PROJECT.md`
- Existing app → `/ai/templates/KICKOFF_EXISTING_PROJECT.md`
- Already on an older starter version → `/ai/templates/REFRESH_PROMPT.md`

The interview prompts then generate the right customized init / adopt
prompt for P0-T1.
