# AI Handoff

Last Updated: 2026-05-02

## Current State Summary
This repository contains the AI project starter (Tommy's Edition). The
application has not yet been initialized from a user-provided app description.

## Last Completed Task
None

## Current Task
P0-T1: Initialize project-specific AI files

## Next Recommended Task
Ask the AI to initialize the project using the application description.

## What Works
- The AI workflow files are present.
- `/ai/START_HERE.md` is the single context entry point.
- `/ai/AI_RULES.md` and `/ai/DEV_ENVIRONMENT.md` define the cross-project
  hard rules (WSL-native dev, no Docker for app, no `/mnt/c` paths).

## What Is Blocked
- Application-specific planning cannot begin until an app description is
  provided.

## Important Instructions for Next AI
- Read `/ai/START_HERE.md` first.
- Follow the Context Loading Order in section 3.
- Honor `/ai/AI_RULES.md` and `/ai/DEV_ENVIRONMENT.md` as non-negotiable.
- Do not build application code during initialization unless explicitly asked.
- Replace starter placeholders with project-specific information.
- Update all project tracking files before ending work.

## Files Changed Recently
- Starter files customized for WSL-native dev with Astro 5 + React 19 +
  Tailwind 4 + Azure SWA + Postmark + Turnstile.

## Tests or Checks Last Run
None. Planning files only.

## Known Risks
- If project files are not updated after each AI session, context will drift.
- If tasks are too broad, AI tools may introduce project creep.
- If the AI proposes Docker for development, push back and reference
  `/ai/AI_RULES.md`.
