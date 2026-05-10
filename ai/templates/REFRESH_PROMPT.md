# Project Refresh Prompt

Use this prompt against an EXISTING project that was started from an
older version of `ai-starter`, to bring its `/ai` folder in line with
the current conventions.

This is a one-shot housekeeping pass. It does not change application
code — only the `/ai` planning files, tool-native memory hook files,
and root-level docs (README.md / SECURITY.md / CONTRIBUTING.md /
LICENSE) where missing.

---

## Prompt to paste to the AI assistant

```text
You are running the `ai-starter` project refresh pass against this repo.

Read these files first, in order:
1. /ai/START_HERE.md
2. /ai/AI_RULES.md
3. /ai/PROJECT.md
4. /ai/DECISIONS.md
5. /ai/CURRENT_STATE.md
6. /ai/HANDOFF.md
7. /ai/TASKS.md

Then perform the ten checks below. For each check, report what you
found, what you changed, and link to the file(s) you touched. Do NOT
proceed to the next check until the current one is reported.

Throughout: never modify files the user has flagged as personal /
private. If you are unsure whether a file is in scope, ask before
editing it.
```

### Check 1 — Dependency / runtime version sweep (bidirectional)

Cross-check every dependency, language version, and toolchain pin
mentioned in `PROJECT.md`, `ARCHITECTURE.md`, `DEPLOYMENT.md`,
`DEV_ENVIRONMENT.md`, and any ADR in `DECISIONS.md`, against the
actual values declared in the project's manifest, lockfile, runtime
version files, and CI workflows.

If the docs say one version and the repo uses another, fix the docs to
match the repo (NOT the other way around — the lockfile is the truth).

If the repo is on a stale major (e.g., a runtime or framework that's
several versions behind current LTS), flag it as a separate finding
for the user — do NOT bump the repo silently. A version bump needs its
own ADR and its own task.

### Check 2 — Compact `CURRENT_STATE.md` to ≤ 80 lines

Read `/ai/templates/CURRENT_STATE.template.md` for the target shape.
Rewrite `CURRENT_STATE.md` to that shape:

- A short paragraph per section, not a per-task transcript.
- Move displaced detail (per-task implementation notes, file lists)
  into the matching dated entry in `DONE_LOG.md`.
- Preserve every fact — only the location changes.
- Update the `Last Updated:` date at the top.

### Check 3 — Compact `HANDOFF.md` to ≤ 50 lines

Read `/ai/templates/HANDOFF.template.md` for the target shape. Rewrite
`HANDOFF.md` to that shape:

- "Last Completed Task" = one block with task ID, title, commit, and
  one-sentence outcome. Detail goes in `DONE_LOG.md`.
- "Important Instructions for Next AI" stays focused on the live
  gotchas that affect the next session. Anything resolved moves to
  `DONE_LOG.md` or simply gets dropped.
- Update the `Last Updated:` date at the top.

### Check 4 — Archive Done tasks from `TASKS.md` into `DONE_LOG.md`

For every task in `TASKS.md` with status `Done`:

1. Confirm the task is already represented in `DONE_LOG.md`. If not,
   add a dated entry with task ID, title, key commit hash(es), and a
   one-sentence outcome.
2. Remove the full task block from `TASKS.md`.
3. Optionally leave a one-line pointer in `TASKS.md` under a `## Done
   (archived)` section. This is acceptable but not required.

`TASKS.md` after this pass should contain only `Active`, `Ready`,
`Backlog`, `Blocked`, `Review` items. Update the `Last Updated:` date.

### Check 5 — Required root-level docs exist

Confirm each of these exists at the repo root. Where missing, create
from the matching template.

- `README.md` — from `/ai/templates/README.template.md`
- `LICENSE` — recorded in an ADR; if missing, ask the user which
  license and write it.
- `SECURITY.md` — from `/ai/templates/SECURITY.template.md`
- `CONTRIBUTING.md` — from `/ai/templates/CONTRIBUTING.template.md`

If a file already exists, leave it alone unless the user asks for a
refresh.

### Check 6 — Tool-native memory hooks present

Confirm these tool-recognized memory files exist at the project root,
each pointing at `/ai/START_HERE.md`:

- `CLAUDE.md` (Claude Code)
- `AGENTS.md` (Codex CLI and several other agentic tools)
- `.cursorrules` (Cursor)
- `.github/copilot-instructions.md` (GitHub Copilot)
- `GEMINI.md` (Gemini CLI)

Where missing, create a one-line stub: "Always read /ai/START_HERE.md
first when working in this repository." If a tool the team uses has a
different convention, add a stub for it.

### Check 7 — `AI_RULES.md` has the current hard rules

Confirm `AI_RULES.md` contains all of these (Hard) rule blocks. If any
are missing, add them (do not duplicate if already present):

- Git Rules (Hard)
- Planning-File Hygiene Rules (Hard)
- Versioning Rules (Hard)
- Security Rules (Hard)
- Infrastructure & Hosting Rules (Hard)
- Cost Rules (Hard)
- Destructive Operations Rules (Hard)
- Reasoning Checkpoint Rules (Hard)
- Blocked Escalation Rule (Hard)
- Task Quality Rules (Hard)
- General Rules, Coding Rules, Review Rules, Handoff Rules
  (cross-project standard)

Also confirm `Handoff Rules` references the **self-critique** section
in `CHAT_END_PROMPT.md`. Add the requirement if missing.

Update the `Last Updated:` date if anything changed.

### Check 8 — `WORKFLOW.md`, `SPEC.md`, `BUDGET.md` exist

Confirm `/ai/WORKFLOW.md`, `/ai/SPEC.md`, and `/ai/BUDGET.md` exist.
Where missing, copy from the latest starter and prompt the user to
fill in the project-specific sections.

### Check 9 — Tasks meet Task Quality Rules

For every task in `TASKS.md`, confirm it has:

- `Prerequisites:` (or `none`)
- A `Verification` section
- A `Rollback / Recovery` section (or `not applicable`)
- A `Cost Considerations` section (or `none`)

If a task is missing any of these, flag it for the user and recommend
backfilling — do not silently invent the missing content.

### Check 10 — `origin/main` matches local `main`

Run `git status` and `git log --oneline origin/main..HEAD` (or
equivalent for the project's default branch).

- If local is ahead of origin: report each unpushed commit by short SHA
  and subject. Recommend a `git push` and stop until the user confirms.
  Do NOT update planning files to claim work is "on `origin/main`" if
  it isn't.
- If local matches origin: report "clean — `origin/main` matches local."
- If origin is ahead of local: recommend a `git pull` before further
  edits.

---

## Final report shape

After all ten checks complete, the AI returns a single summary:

```text
Refresh complete.

Files changed:
- {list}

Files created:
- {list}

Findings flagged for user attention (not auto-fixed):
- {list, e.g., "Runtime X.Y → X.Z bump recommended (separate ADR + task)"}
- {list, e.g., "5 tasks missing Verification — see TASKS.md P2-T3, P2-T7..."}

Pending pushes:
- {list, or "none"}

Suggested next step:
- {one sentence}
```
