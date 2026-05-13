# AI Handoff

Last Updated: 2026-05-13

## Current State Summary
Generic AI project starter (v0.6.1). Not yet initialized — no
application description, tech stack, or tooling chosen.

## Last Completed Task
None. v0.6.1 ships mark-task-done script + configurable push + security CI scaffold.
phase-script library with safe staging (no more `git add -A`,
sensitive paths refused fail-closed), a Python planning-file linter
enforcing the Task Quality / Hygiene Hard Rules, GitHub Actions CI
running shellcheck + the linter, and a web-app decision-tree doc
(`docs/CHOOSING_WEBAPP_PATH.md`) the kickoff interview can reference.

## Active Task
None

## Next Recommended Task
**P0-T1: pick the right entry point.**
- New project → `/ai/templates/KICKOFF_NEW_PROJECT.md`
- Existing app → `/ai/templates/KICKOFF_EXISTING_PROJECT.md`
- Already on older starter → `/ai/templates/REFRESH_PROMPT.md`

The KICKOFF interviews are the foolproof default. Direct paths
(`INIT_PROMPT.md`, `ADOPT_PROMPT.md`) are for skip-the-interview users.

## What Is Blocked
- Planning can't begin until an app description is provided.

## Important Instructions for Next AI
- Read `/ai/START_HERE.md` first (memory hooks point here).
- Honor `/ai/AI_RULES.md` — every (Hard) block applies.
- For first-time init, prefer the KICKOFF interview over direct
  `INIT_PROMPT.md`; only skip on explicit user opt-out.
- Reference `/ai/EXAMPLE_PROJECT.md` for shape — never copy its content.
- Include the self-critique section in the end-of-chat report.

## Known Risks
- Skipping planning-file updates causes drift between sessions.
- Skipping Cost / Destructive Ops / Reasoning Checkpoint rules can
  silently trigger expensive or risky actions.

## Tests / Checks Last Run
None. Planning files only.
