# AI Handoff

Last Updated: 2026-05-10

## Current State Summary
Generic AI project starter (v0.5.4). Not yet initialized — no
application description, tech stack, or tooling chosen.

## Last Completed Task
None. v0.5.4 fixed six downstream-init hygiene issues found while
reviewing the first real init: DONE_LOG now ships empty, INIT/ADOPT
got an explicit "replace starter-history + remove starter-setup
files" step, SHA in DONE_LOG is now optional (no more
`commit: pending`), TASK_TEMPLATE heading levels corrected, and the
CONTRIBUTING template lists all four AI branch prefixes.

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
