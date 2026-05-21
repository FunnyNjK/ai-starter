# Adopt Prompt — Retrofit existing app into a solution

Use this prompt to retrofit the `ai-starter` workflow onto an
EXISTING repo that doesn't yet have a v1.2.0 `/ai/` folder. The
existing code becomes one or more **projects** inside a new
solution shell.

This is the actor invoked after `KICKOFF_EXISTING_SOLUTION.md`
finishes its inspection wizard.

This is one of the v1.2.0+ actor prompts:

- **INIT_PROMPT.md** — first-run greenfield: creates solution +
  first project from a recipe.
- **ADD_PROJECT_PROMPT.md** — adds a project to an existing
  solution that already has v1.2.0 planning files.
- **ADOPT_PROMPT.md** (this file) — retrofit onto an in-place
  existing app. Maps current code to v1.2.0 projects, creates
  the planning shape, but doesn't modify app code.
- **REFRESH_PROMPT.md** — housekeeping on a project that already
  has `/ai/` from an older starter version (pre-v1.2.0). Run
  REFRESH first if `/ai/PROJECT.md` exists.

The friendly entry point that generates a customized version of
this prompt is `/ai/templates/KICKOFF_EXISTING_SOLUTION.md`.

---

## Prompt to paste to the AI assistant

```text
You are running an ADOPT pass against an existing repo. The app
already exists; do NOT modify its code. Your job is to:

1. Read the NOTES block from KICKOFF_EXISTING_SOLUTION (project
   list, deploy state, tier, license, compliance, hooks/docs
   status).
2. Create the v1.2.0 solution shell (`/ai/SOLUTION.md`,
   `/ai/ARCHITECTURE.md`, etc.).
3. For each inferred project in the existing code, create
   `projects/<name>/README.md` referencing the existing code in
   place (no folder restructure unless the user explicitly
   asks).
4. Write retroactive ADRs for the existing stack picks.
5. Queue Phase-1 catch-up tasks for any gaps against the
   applicable Hard rules (per tier and deploy state).
6. Branch deploy ADRs: deployed → retroactive ADRs now, P3-T0
   marked Done; not-deployed → defer to P3-T0 same as INIT.

If no NOTES block is present, surface that and recommend the
user run KICKOFF_EXISTING_SOLUTION.md first.

## Bootstrap checklist

Before editing files, confirm:

- The project has the starter `/ai/` files available (copied
  from ai-starter). If `/ai/` is missing entirely, STOP and ask
  the user to copy the starter files into this repo first.
- `/ai/SOLUTION.md` is still starter-generic (Solution Name =
  TBD). If it's project-specific, STOP — use REFRESH_PROMPT.md
  or KICKOFF_ADD_PROJECT.md instead.
- `/ai/PROJECT.md` does NOT exist (pre-v1.2.0 indicator). If it
  does, STOP — run REFRESH_PROMPT.md first to migrate to
  v1.2.0.
- No real secrets are in your context. Placeholders only.
- The user has authorized you to write planning files (running
  this prompt = consent).

## Step 1 — Read AI files

Read `/ai/START_HERE.md`, `/ai/AI_RULES.md`, and any recipe files
referenced in the NOTES block (`{template_recipe}` per project,
when set).

Honor all (Hard) rule blocks:
- Local-First Development Rule applies asymmetrically:
  * Deployed brownfield: cloud / IaC / managed-service /
    OIDC / budget decisions are facts in the repo — write
    them as retroactive ADRs now. Mark P3-T0 Done.
  * Not-deployed brownfield: defer those decisions to P3-T0.
- Versioning Rules: verify every existing dep version against
  the lockfile (lockfile is truth; if docs disagree with
  lockfile, fix the docs).
- Task Quality Rules: every queued catch-up task tags
  `Project: <name>` or `Project: solution`.

## Step 2 — Inspect deeply (read-only)

Re-inspect (or trust the kickoff's inspection if it ran
recently):

- File tree (top 2-3 levels; deeper for load-bearing folders).
- Package manifests + lockfiles (language, framework, runtime,
  direct deps, dev deps).
- Runtime version files.
- CI configs (what runs and when).
- Hosting / IaC artifacts (Dockerfile, docker-compose,
  vercel.json, fly.toml, terraform/, infra/, cdk.json, etc.).
- Test configs.
- Existing root docs (README, LICENSE, SECURITY, CONTRIBUTING,
  CHANGELOG).
- Tool-native memory hook files.
- A handful of representative source files (don't read every
  file).

If the inspection finds projects the NOTES block didn't list,
surface them and ask the user before proceeding.

## Step 3 — Validate each project's feature loop

For each project in the NOTES block, validate that you can
articulate a feature loop in 1-3 sentences from inspection (or
ask the user if not). Per the v0.5.5 refusal logic: a project
must describe what users *do* with it, not just its surfaces.

- If the existing README is foundation- or architecture-shaped
  AND you can't infer a real feature loop from routes / endpoints
  / pages, STOP and ask the user. Don't manufacture features.

## Step 4 — Create solution-level files

Rewrite `/ai/SOLUTION.md`:
- Solution Name from kickoff or repo name.
- Application Description from the inferred feature loops
  (highest-level: what does the WHOLE product do, given all
  projects).
- Goals, non-goals, target users from existing README + the
  user's interview answers.
- Projects table: one row per inferred project.
- Tier from kickoff.
- Rules in force per tier + deploy state.
- Security / Infrastructure sections: link to retroactive ADRs
  (Step 6) for what's actually configured.

Rewrite `/ai/ARCHITECTURE.md`:
- System Overview Mermaid `flowchart LR` with one node per
  project, edges per inter-project communication observed in
  code.
- Trust boundaries annotated.
- Cloud subgraph filled in if deployed (per existing
  infrastructure); dashed "TBD@P3-T0" if not-deployed.

Rewrite `/ai/CURRENT_STATE.md`, `/ai/HANDOFF.md` per their
templates (line caps respected).

Update `/ai/ROADMAP.md` to reflect actual phase:
- Deployed in production → may start at Phase 5 (Enhancements)
  for new work, with Phase 1 catch-up inserted for gap-filling.
  P3-T0 marked Done retroactively.
- Not deployed → typical INIT phase ordering (Phase 1 catch-up;
  P3-T0 in Backlog).

## Step 5 — Create per-project README files (no code changes)

For each project, create `projects/<name>/README.md` per the
recipe's README template (when a recipe applies) or with a
free-form layout for custom projects.

Each project README MUST include:
- Project name + platform + language + (recipe name if
  applicable, else "custom").
- Verified dep versions from the lockfile (lockfile is truth;
  note source URL for each major dep + date verified).
- Local-dev story: how to run / test / build (from existing
  scripts + manifests).
- Inter-project communication: which other projects this one
  talks to and the wire-protocol.
- Links to relevant solution-level files (security baseline,
  deploy planning, tier, license).

IMPORTANT: Do NOT restructure existing code into
`projects/<name>/` subdirectories unless the user explicitly
asks. ADOPT preserves existing code layout. The
`projects/<name>/README.md` file is a planning sidecar that
points at the actual code paths (`see ../web/`, etc.) if the
existing code isn't already under `projects/<name>/`.

Mention this in the README:
- "Code lives at {actual paths}; this README is the v1.2.0
  planning sidecar." (For projects not yet organized under
  `projects/`.)

## Step 6 — Write retroactive ADRs

For every major existing stack choice, append an ADR to
`/ai/DECISIONS.md`:

  ## ADR-NNN: {Decision title}
  Date: {today}
  Status: Accepted (retroactive)
  Project: {project_name | solution}

  ### Decision
  Existing code uses {dep} {version-from-lockfile}. Verified
  against {lockfile path} on {today}.

  ### Reason
  {Most plausible reason given the project shape; or "Existing
  project decision; rationale not documented in original
  repo. Reconstructed for forward continuity."}

  ### Tradeoffs
  {Honest tradeoffs.}

  ### Related Tasks
  {Phase-1 catch-up task IDs.}

Cover at minimum, per project: language, framework, package
manager, test runner, lint/format, DB engine (if any), auth
library (if any), license, CI system.

For deployed brownfield, ALSO cover: cloud target, IaC tool
(or "no IaC; deploys via {actual mechanism}" with override
rationale), Terraform state backend (if used), managed-service
instances per stateful dep, runtime secret store, OIDC trust
shape (or current cloud auth mechanism), monthly budget cap +
alert thresholds (from actual cloud invoices if available).

For not-deployed brownfield: skip deploy ADRs; they get written
at P3-T0.

If a current choice violates a Hard rule, write the ADR as
**Status: Accepted (retroactive, override)** with a clear
rationale, and queue a follow-up task for the user to review.
Do NOT silently change the architecture in this pass.

## Step 7 — Queue Phase-1 catch-up tasks

For each gap between the existing project and the applicable
Hard rules, queue a Phase-1 catch-up task. Tag with the
relevant project (or `Project: solution` for shared
infrastructure).

Common gaps:
- Tool-native memory hooks missing → add CLAUDE.md, AGENTS.md,
  .cursorrules, GEMINI.md, .github/copilot-instructions.md.
- Root docs missing → SECURITY.md, CONTRIBUTING.md, LICENSE.
- `.github/pull_request_template.md` missing.
- Dependabot / Renovate not configured.
- SAST in CI missing.
- SCA / dependency vulnerability scanning missing.
- OIDC federation missing (deployed brownfield with static
  cloud keys).
- No rate limiting on public endpoints.
- No PII redaction in logs.
- No CORS / CSP allowlists.
- Container images not pinned by digest (deployed brownfield).
- SPEC.md TBD for major flows → one task per major flow to
  document.

Each task: TASK_TEMPLATE.md sections; `Project:` line;
Local-First-compliant ordering for any tasks that touch the
build loop.

Solo prototype tier: skip cloud / IaC / SAST gap tasks if the
user explicitly defers them; record the deferral as an ADR with
the trigger that would re-open the tasks.

## Step 8 — Add tool-native memory hooks (immediate, low-risk)

The one thing it's safe to do right now (without violating the
"don't change app code" rule) is add the tool-native memory
hook stub files at the solution root if missing:

- `CLAUDE.md`, `AGENTS.md`, `.cursorrules`, `GEMINI.md`,
  `.github/copilot-instructions.md`

Each is 2-3 lines: "Always read /ai/START_HERE.md first." Skip
files that already exist with project-specific content.

## Step 9 — Replace starter-history files and remove starter-setup files

### `CHANGELOG.md` at the solution root

- If MISSING or contains starter's release header (starts with
  `Starter Version:`), replace with project changelog scaffolding:

  ```markdown
  # Changelog

  Last Updated: <today>

  ## Unreleased
  - ai-starter workflow adopted (P0-T1).
  ```

- If file has project-specific entries already, leave it alone
  and add a new "ai-starter workflow adopted" line under the
  existing Unreleased section.

### `/ai/DONE_LOG.md`

- Should ship from the starter empty. If it has starter-release
  entries, clear them. Seed with this project's adopt entry
  (today's date).

### Remove starter-setup files

These exist to bootstrap new projects and have no use after
adopt. Delete:

- `ai/templates/KICKOFF_NEW_SOLUTION.md`
- `ai/templates/KICKOFF_NEW_PROJECT.md` (redirect stub)
- `ai/templates/KICKOFF_EXISTING_SOLUTION.md`
- `ai/templates/KICKOFF_EXISTING_PROJECT.md` (redirect stub)
- `ai/templates/INIT_PROMPT.md`
- `ai/templates/ADOPT_PROMPT.md` (you're inside this one —
  delete on the way out)
- `ai/templates/README.template.md` (if you DID generate
  root docs from it; otherwise leave for follow-up tasks)
- `ai/templates/SECURITY.template.md` (same)
- `ai/templates/CONTRIBUTING.template.md` (same)
- `ai/EXAMPLE_SOLUTION.md`
- `ai/reference/PROMPT_LIBRARY.md` (if present)

Keep:
- `ai/templates/KICKOFF_ADD_PROJECT.md` and
  `ai/templates/ADD_PROJECT_PROMPT.md` (for future projects).
- `ai/templates/recipes/` (for future projects).
- `ai/templates/REFRESH_PROMPT.md`, `TASK_TEMPLATE.md`,
  `INCIDENT_TEMPLATE.md`, `CHAT_END_PROMPT.md`,
  `CURRENT_STATE.template.md`, `HANDOFF.template.md`.

## Step 10 — Pre-flight self-check (mandatory before declaring P0-T1 done)

Confirm each item. If ANY unchecked, STOP and fix.

  Pre-flight before closing P0-T1 (ADOPT):
  - [ ] `/ai/SOLUTION.md` is fully filled in (Solution Name,
        Application Description, Goals, Non-Goals, Tier, Rules
        in force).
  - [ ] `/ai/SOLUTION.md` "Projects" table has one row per
        inferred project.
  - [ ] Every major existing stack choice has a retroactive
        ADR (Status: Accepted (retroactive) or Accepted
        (retroactive, override)) with verified version from
        lockfile + canonical source URL.
  - [ ] For DEPLOYED brownfield: deploy ADRs (cloud / IaC /
        managed-service / OIDC / secret store / network /
        budget cap) are all written; P3-T0 is marked Done in
        TASKS.md.
  - [ ] For NOT-DEPLOYED brownfield: deploy ADRs are NOT
        written; P3-T0 is queued in Backlog with
        `Prerequisites: Phase-2 complete`.
  - [ ] `/ai/ARCHITECTURE.md` Mermaid diagram shows all
        projects with edges per inter-project communication.
        Cloud subgraph filled (deployed) or dashed "TBD@P3-T0"
        (not deployed).
  - [ ] Phase-1 catch-up tasks queued for every gap, each
        tagged `Project: <name>` or `Project: solution`.
  - [ ] LICENSE, SECURITY.md, CONTRIBUTING.md present at
        solution root (or queued as catch-up tasks if missing).
  - [ ] All 5 tool-native memory hooks present.
  - [ ] `/ai/CURRENT_STATE.md` ≤ 80 lines, `/ai/HANDOFF.md` ≤
        50 lines.
  - [ ] Every touched planning file has fresh
        `Last Updated: YYYY-MM-DD`.
  - [ ] Starter-history files replaced and starter-setup files
        removed per Step 9.
  - [ ] `python3 scripts/lint-planning.py` passes with 0
        errors and 0 warnings.

## Hard rules

- Do NOT modify existing app code in this pass — only `/ai/`,
  root docs, and tool-native memory hook stubs.
- Do NOT delete or rewrite existing root docs (README, LICENSE,
  SECURITY, CONTRIBUTING) without user confirmation. Augment
  gently or leave alone.
- Do NOT restructure existing code into `projects/<name>/`
  folders unless the user explicitly asks. ADOPT preserves
  existing layout.
- Do NOT silently fix Hard-rule violations — queue them as
  catch-up tasks for the user to prioritize.
- Do NOT pin dependency versions from training-data knowledge.
  Verify every version against the lockfile or canonical source
  AS OF TODAY.
- Honor Destructive Operations and Reasoning Checkpoint rules.
- Push after every commit (Git Rules).

Begin with the Start-of-Chat summary (START_HERE.md section 5).
End with the End-of-Chat report (START_HERE.md section 6) —
including the self-critique section.
```
