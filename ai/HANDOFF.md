# AI Handoff

Last Updated: 2026-05-10

## Current State Summary
This repository contains the generic AI project starter (v0.4.0). The
application has not yet been initialized from a user-provided app
description, and no tech stack, hosting target, or tooling has been
chosen.

## Last Completed Task
None — but starter v0.4.0 hardening landed on `origin/main`: license,
tool-native memory hooks, workflow, spec, budget, example, and four
new (Hard) rule blocks (Cost, Destructive Ops, Reasoning Checkpoint,
Blocked Escalation).

## Active Task
None

## Next Recommended Task
P0-T1: Initialize project-specific AI files. Run
`/ai/templates/INIT_PROMPT.md` against an application description.

## What Is Blocked
- Application-specific planning cannot begin until an app description
  is provided.

## Important Instructions for Next AI
- Read `/ai/START_HERE.md` first (the tool-native memory hooks
  already point you here).
- Follow the Context Loading Strategy in section 3.
- Honor `/ai/AI_RULES.md` as non-negotiable — every (Hard) block applies.
- Follow `/ai/templates/INIT_PROMPT.md` end-to-end for first-time init.
- Reference `/ai/EXAMPLE_PROJECT.md` for the target shape of an
  initialized project — but never copy its content.
- Update all project tracking files before ending work, and include the
  required self-critique section in the end-of-chat report.

## Known Risks
- If project files are not updated after each AI session, context will
  drift.
- If tasks skip the new Cost / Destructive Ops / Reasoning Checkpoint
  rules, the AI may take expensive or risky actions silently.

## Tests / Checks Last Run
None. Planning files only.
