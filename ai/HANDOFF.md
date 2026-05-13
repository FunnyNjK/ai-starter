# AI Handoff

Last Updated: 2026-05-13

## Current State Summary
Generic AI project starter (v1.0.0). Not yet initialized — no
application description, tech stack, or tooling chosen.

## Last Completed Task
Starter v1.0.0 release. Composite component model (1-N components
per gallery), behavioral-diagnostic kickoff (D1-D5), complexity
tier dial, per-component rung pick + dimension walk, cross-
component decisions, composite Mermaid diagram, and rule
applicability in AI_RULES.md. ADOPT and REFRESH updated for v1.0.0
inheritance; PROJECT.md template ships with Components / Tier /
Rules-in-force slots; EXAMPLE_PROJECT.md shows the v1.0.0 shape.

## Active Task
None

## Next Recommended Task
**P0-T1: pick the right entry point.**
- New project → `/ai/templates/KICKOFF_NEW_PROJECT.md`
- Existing app → `/ai/templates/KICKOFF_EXISTING_PROJECT.md`
- Older starter version → `/ai/templates/REFRESH_PROMPT.md`

The KICKOFF interviews are the foolproof default. Direct paths
(`INIT_PROMPT.md`, `ADOPT_PROMPT.md`) are for skip-the-interview
users.

## What Is Blocked
- Planning can't begin until an app description is provided.

## Important Instructions for Next AI
- Read `/ai/START_HERE.md` first (memory hooks point here).
- Honor `/ai/AI_RULES.md` — every applicable (Hard) block applies.
- The new Rule Applicability section makes some blocks conditional
  on tier and component set; resolve them explicitly in
  `/ai/PROJECT.md`.
- Both kickoffs now require an explicit pre-flight self-check
  before generating the init prompt. Do not skip it.
- Reference `/docs/PROJECT_SHAPE_GALLERY.md` for component rungs.

## Known Risks
- Skipping planning-file updates causes drift between sessions.
- Skipping Cost / Destructive Ops / Reasoning Checkpoint rules can
  silently trigger expensive or risky actions.

## Tests / Checks Last Run
- `python3 scripts/lint-planning.py` — pass after v1.0.0 edits.
