# AI Handoff

Last Updated: 2026-05-21

## Current State Summary
Generic AI solution starter (v1.2.1). Not yet initialized — no
solution name, project, or tech stack chosen.

## Last Completed Task
**v1.2.1 release.** Catches up the brownfield paths to the
v1.2.0 solution/project model. KICKOFF_EXISTING_PROJECT →
KICKOFF_EXISTING_SOLUTION rename + wizard rewrite,
ADOPT_PROMPT.md refactored, REFRESH_PROMPT.md gains Check 12
(v1.2.0 backfill). Template docs updated. See CHANGELOG v1.2.1.

## Active Task
None

## Next Recommended Task
**P0-T1 (init)** — pick a wizard:
- New repo + first project → `/ai/templates/KICKOFF_NEW_SOLUTION.md`
- Add project to existing solution → `/ai/templates/KICKOFF_ADD_PROJECT.md`
- Existing app, no `/ai/` yet → `/ai/templates/KICKOFF_EXISTING_SOLUTION.md`
- Older starter version → `/ai/templates/REFRESH_PROMPT.md`

Direct actors (`INIT_PROMPT.md`, `ADD_PROJECT_PROMPT.md`,
`ADOPT_PROMPT.md`) skip the wizard for confident users.

## What Is Blocked
- Planning can't begin until wizard Turn 4 (feature loop) is
  answered.

## Important Instructions for Next AI
- Read `/ai/START_HERE.md` first (memory hooks point here).
- Honor `/ai/AI_RULES.md`. Local-First Development Rule defers
  deploy ADRs to P3-T0.
- Tasks tag `Project: <name>` per the Task Quality Rule.
- Deferred to a future minor (design work): monorepo workspace
  setup; "Custom" template path UX.

## Known Risks
- Planning-file drift between sessions if updates skipped.
- "Custom" template fallback routes to PROJECT_SHAPE_GALLERY.md
  (still component/rung terms) — thinner UX than the 8 recipes.

## Tests / Checks Last Run
- `python3 scripts/lint-planning.py` — pass after v1.2.0 edits.
