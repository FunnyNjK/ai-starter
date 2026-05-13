# AI Handoff

Last Updated: 2026-05-13

## Current State Summary
Generic AI project starter (v0.6.2). Not yet initialized — no
application description, tech stack, or tooling chosen.

## Last Completed Task
Starter maintenance v0.6.2: fixed brownfield ADOPT routing, replaced the
security-CI placeholder with failing guardrails, added phase-harness
preflight branch/dirty-worktree checks, fixed commit-subject parsing,
and expanded CI validation.

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
- `python3 scripts/lint-planning.py` — pass (0 errors, 0 warnings).
- `PYTHONPYCACHEPREFIX=/private/tmp/ai-starter-pycache python3 -m py_compile scripts/lint-planning.py scripts/mark-task-done.py` — pass.
- `bash -n run-phase.sh run-phase-codex.sh run-phase-cursor.sh run-phase-copilot.sh scripts/run-phase-lib.sh` — pass.
- `rpl_extract_subject` + `rpl_preflight` smoke tests — pass (dirty refusal exits 1 as expected).
- `git diff --check` — pass.
- `shellcheck` not run locally (not installed); CI installs it.
