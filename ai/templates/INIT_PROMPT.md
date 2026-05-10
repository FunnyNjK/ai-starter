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
- The working directory is the new repo, not any read-only reference repo.
- The user supplied either an application description or enough old-repo
  context to infer one.
- If OLD REPO is "none — greenfield", skip migration inventory and
  old-project cataloging steps.
- If OLD REPO is provided, inspect it read-only and use it for context
  (brand, content, information architecture, existing integrations).

## Step 1 — Read AI files

Read /ai/START_HERE.md first, then follow its Context Loading Strategy.
Because this is first-time initialization, load the full planning context
instead of only the Fast Context set.
Honor /ai/AI_RULES.md as non-negotiable (push after every commit, planning-
file size caps, scope control).

Glance at /ai/templates/ — HANDOFF.template.md and CURRENT_STATE.template.md
are the target shapes for the compact files you'll write.
REFRESH_PROMPT.md is for existing repos; ignore here.

## Step 2 — Choose the tech stack

Use the user's application description (and the old repo, if any) to
choose the language, framework(s), package manager, test tooling, hosting
target, and any required external services. Capture each major choice as
an ADR in /ai/DECISIONS.md (numbered ADR-001, ADR-002, ...) with
rationale and trade-offs. Do not introduce a tool or service without an
ADR. Ask the user before locking in choices that materially change the
project's shape.

## Step 3 — Inspect the old repo (read-only, skip if greenfield)

Treat it as read-only. Never modify it. Catalog: pages or modules, content,
copy, assets, brand (colors/fonts), navigation, integrations, features to
drop, opportunities to improve.

## Step 4 — Decide a design / migration direction

If migrating from an old repo, decide with the user whether to:

- **Preserve** — keep the old design and behavior as faithfully as possible
  while only re-implementing on a new stack.
- **Evolve** — preserve identity (brand, content, information
  architecture) but modernize implementation, conventions, accessibility,
  and performance.
- **Rebuild** — treat the old repo as reference only, not a constraint on
  the new design.

Document the chosen direction (and any notable evolution choices) as ADRs.

## Step 5 — Update planning files

Make all /ai/*.md files project-specific. Mark P0-T1 done. Queue the
first few Phase-1 tasks (typically: scaffold, CI, README). Queue Phase 2
tasks — one per major page, screen, or module. Add improvement-list tasks
too. Each task: small enough for one focused session, with acceptance
criteria and test requirements.

CURRENT_STATE.md ≤ 80 lines. HANDOFF.md ≤ 50 lines. Use the templates
in /ai/templates/.

Add `Last Updated: YYYY-MM-DD` (today's UTC date) to the top of every
planning file you touch.

## Step 6 — Create /ai/MIGRATION_INVENTORY.md (skip if greenfield)

- Page / module mapping (old → new → status)
- Asset mapping (old path → new path)
- Content mapping (section → source in old repo → notes)
- Drop list (with reasons)
- Improvement list (each linked to a TASKS.md entry)

## Step 7 — Environment variables

Identify every env var the new project will need. Document them in
/ai/DEPLOYMENT.md "Required Environment Variables". The actual local env
file (or equivalent) with placeholders gets created during scaffold
(P1-T1), not now.

## Hard rules

- Do NOT scaffold the project yet (P1-T1 task).
- Do NOT install dependencies yet.
- Do NOT modify any read-only reference repo.
- Do NOT modify /DEVELOPER-NOTES.md if present (developer-owned).
- Use placeholders only, never real secrets.
- Push after every commit (Git Rules in AI_RULES.md).

Begin with the Start-of-Chat summary (START_HERE.md section 5).
End with the End-of-Chat report (START_HERE.md section 6) — and
remember to update CURRENT_STATE, TASKS, HANDOFF, DONE_LOG to reflect
the closed P0-T1.
```
