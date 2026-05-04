# Project Init Prompt

Use this prompt against a FRESH project that was just cloned from the
`ai-starter` template, to convert the generic starter files into
project-specific planning files.

This is the sister document to `REFRESH_PROMPT.md`:

- **INIT_PROMPT.md** — first-time setup of a new project (P0-T1).
- **REFRESH_PROMPT.md** — housekeeping pass on an existing project that's
  drifted from current conventions.

---

## Prompt to paste to the AI assistant

```text
You are running a project initialization session.

OLD REPO (read-only reference): {fill in path, or "none — greenfield"}
NEW REPO: current working directory.

## Bootstrap checklist

Before editing files, confirm:

- This is a fresh project initialization, not a refresh of an existing app.
- The working directory is the new repo, not the read-only old reference repo.
- The user supplied either an application description or enough old-repo
  context to infer one.
- If OLD REPO is "none — greenfield", skip migration inventory and old-site
  cataloging steps.
- If OLD REPO is provided, inspect it read-only and preserve its brand,
  content, and information architecture while modernizing implementation.
- The default stack remains Astro 5 + React 19 + Tailwind 4 + Azure SWA unless
  the user explicitly requests an override and the override is recorded as an
  ADR.

## Step 1 — Read AI files

Read /ai/START_HERE.md first, then follow its Context Loading Strategy.
Because this is first-time initialization, load the full planning context
instead of only the Fast Context set.
Honor /ai/AI_RULES.md and /ai/DEV_ENVIRONMENT.md as non-negotiable
(WSL-native, no Docker for app code, no /mnt/c paths, push after every
commit, planning-file size caps).

Glance at /ai/templates/ — HANDOFF.template.md and CURRENT_STATE.template.md
are the target shapes for the compact files you'll write.
REFRESH_PROMPT.md is for existing repos; ignore here.

## Step 2 — Inspect the old repo (read-only, skip if greenfield)

Treat it as read-only. Never modify it. Never copy its code (different
stack). Catalog: pages, content, copy, assets, brand (colors/fonts),
navigation, forms, integrations, features to drop, opportunities to
improve.

## Step 3 — Design direction: EVOLVE

Preserve brand identity, content, and information architecture.
MODERNIZE the design: typography, spacing, mobile UX, accessibility,
performance, component patterns. Use the old site as reference for what
it IS, not a constraint on how it has to look. Document notable
evolution choices as ADRs.

## Step 4 — Update planning files

Make all /ai/*.md files project-specific. Mark P0-T1 done. Keep
P1-T1 (scaffold), P1-T2 (CI), and P1-T3 (README). Queue Phase 2 tasks —
one per page or major section from the old repo. Add improvement-list
tasks too. Each task: small enough for one focused session, with
acceptance criteria and test requirements.

Add project-specific ADRs starting at ADR-011. Do NOT write a Node
version ADR — the starter already pins Node 24 LTS end-to-end (see
ADR-005 / ADR-008). If you find something that genuinely overrides a
baked-in ADR (ADR-001 through ADR-010), write a new ADR that supersedes
it; do not edit the original.

CURRENT_STATE.md ≤ 80 lines. HANDOFF.md ≤ 50 lines. Use the templates
in /ai/templates/.

Add `Last Updated: YYYY-MM-DD` (today's UTC date) to the top of every
planning file you touch.

## Step 5 — Create /ai/MIGRATION_INVENTORY.md (skip if greenfield)

- Page mapping (old route → new page → status)
- Asset mapping (old path → new path)
- Content mapping (section → source in old repo → notes)
- Drop list (with reasons)
- Improvement list (each linked to a TASKS.md entry)

## Step 6 — Environment variables

Identify every env var the new project will need (Postmark, Turnstile,
plus anything from the old repo's .env.example or process.env usage).
Document them in /ai/DEPLOYMENT.md "Required Environment Variables".
The actual .env.local with placeholders gets created in P1-T1 (scaffold),
not now.

## Hard rules

- Do NOT scaffold the Astro project yet (P1-T1 task).
- Do NOT install dependencies yet.
- Do NOT modify the old reference repo.
- Do NOT introduce Docker for application processes.
- Do NOT use /mnt/c or Windows paths in any committed file.
- Do NOT modify /DEVELOPER-NOTES.md if present (developer-owned).
- Use placeholders only, never real secrets.
- Push after every commit (Git Rules in AI_RULES.md).

Begin with the Start-of-Chat summary (START_HERE.md section 5).
End with the End-of-Chat report (START_HERE.md section 6) — and
remember to update CURRENT_STATE, TASKS, HANDOFF, DONE_LOG to reflect
the closed P0-T1.
```
