# Init Prompt — Create Solution + First Project

Use this prompt against a FRESH repo cloned from `ai-starter` to
convert the generic starter into a solution-specific planning
folder + the first project's scaffold shape.

This is one actor prompt in the v1.2.0+ family:

- **INIT_PROMPT.md** (this file) — first-run: creates solution +
  first project.
- **ADD_PROJECT_PROMPT.md** — subsequent runs: adds a project to
  an existing solution.
- **ADOPT_PROMPT.md** — retrofit `/ai/` onto an in-place existing
  app that doesn't have planning files yet.
- **REFRESH_PROMPT.md** — housekeeping on a project that has
  `/ai/` from an older starter version.

The friendly entry point that interviews and generates a
customized version of this prompt is
`/ai/templates/KICKOFF_NEW_SOLUTION.md`.

For a worked example of what the output looks like, see
`/ai/EXAMPLE_SOLUTION.md`.

---

## Prompt to paste to the AI assistant

```text
You are running the `ai-starter` init session — first run on a
fresh repo. Your job: create the solution-level `/ai/` files,
create `projects/{project_name}/` with the first project's
scaffold shape, queue Phase-1 tasks for that project, and queue
the solution-level P3-T0 deploy-planning task.

OLD REPO (read-only, optional): {fill in path, or "none — greenfield"}
NEW REPO: current working directory.

The NOTES block below carries answers from KICKOFF_NEW_SOLUTION.
If no NOTES block is present, surface that and recommend the user
run KICKOFF_NEW_SOLUTION.md first.

## Bootstrap checklist

Before editing files, confirm:

- This is a fresh init: `/ai/SOLUTION.md` is still starter-generic
  (Solution Name = TBD). If it's already project-specific, STOP —
  use REFRESH_PROMPT.md or ADD_PROJECT_PROMPT.md.
- `/ai/PROJECT.md` does NOT exist (would indicate a pre-1.2.0
  starter). If it does, STOP — run REFRESH_PROMPT.md first.
- The NOTES block lists a `template_recipe` path that exists
  under `/ai/templates/recipes/`. If it doesn't, STOP and ask
  the user to re-run the wizard.
- Working directory is the new repo (not any OLD REPO).
- No real secrets are in your context. Placeholders only.

## Inherited from kickoff (read the NOTES block)

The NOTES block carries:

- `mode: new-solution-with-first-project`
- `platform`, `language`, `template`, `template_recipe`
- `project_name` (sensible default per platform)
- `feature_loop` (1-3 sentences, scoped to THIS first project)
- `tier` (default: small team / early production)
- `license` (default: MIT)
- `cloud_preference: deferred to P3-T0`
- `budget_preference: deferred to P3-T0`
- `compliance: none` (user adds later via SOLUTION.md edits)

If running without a NOTES block, gather equivalent info inline,
then proceed.

## Step 1 — Read AI files + recipe

Read `/ai/START_HERE.md`, `/ai/AI_RULES.md`, `/ai/SOLUTION.md`
(currently generic), `/ai/ARCHITECTURE.md`, `/ai/DECISIONS.md`,
and the template recipe at `{template_recipe}`.

Honor all (Hard) rule blocks. Particular attention to:

- Local-First Development Rule — no cloud / IaC / OIDC / monthly-
  budget-cap decisions in this session. Those are P3-T0.
- Versioning Rules — verify every dep version live from its
  canonical source. No training-data versions.
- Task Quality Rules — every queued task tags `Project: {project_name}`
  (or `Project: solution` for solution-level tasks).

The recipe at `{template_recipe}` is the canonical source for:
opinionated dep list, folder layout, design philosophy, auth
pattern, DB / cache / queue runtime versions, dev story.

## Step 2 — Validate the feature loop (under-scope + over-scope)

Before scaffolding, validate that `feature_loop` describes a real
product — what end users *do* — AND that the description scopes
to what this project's template can actually deliver.

### Under-scope refusal (foundation- or architecture-shaped)

Refuse to proceed past this step if `feature_loop`:

- Uses foundation / template / starter / scaffold / base /
  skeleton / boilerplate language without naming a concrete
  user-facing feature loop.
- Is architecture-only (a list of surfaces / services /
  technologies, no user behavior).

Loop with the user until product-shaped. If they insist they
only want a reusable foundation, point at `ai-starter` itself
and ask once more. If still no product, mark task `Blocked` per
the Blocked Escalation Rule.

### Over-scope check (required when NOTES has feature_loop_scope_check)

If the NOTES block carries `feature_loop_scope_check: required`
(every v1.3.1+ wizard sets this), also check whether the
feature_loop describes capabilities the chosen template can
actually deliver.

Read the picked recipe at `{template_recipe}` and identify what
the template DOES NOT include. Common red flags by template:

- **Astro Static**: feature_loop mentions "sign up", "upload",
  "AI generation", "order", "purchase", "API", "auth", or any
  per-user state. Astro Static is a marketing/docs/content
  site — no DB, no auth, no user state. Form handling via
  Formspree is the upper bound.
- **TS Library / Go Module / Python Library**: feature_loop
  mentions a user-facing UI or hosted endpoints. Libraries are
  imported, not used directly.
- **CLI templates**: feature_loop mentions a browser or mobile
  UI.
- **Web app templates** (Next.js / ASP.NET MVC / Django):
  feature_loop mentions mobile-specific capabilities like push
  notifications or native device APIs.

If the feature_loop mentions capabilities the template can't
deliver, **don't refuse — clarify**. The user often describes
the *broader product* the project is part of, especially when
the project is a marketing site for a larger offering. Render:

  Your feature loop mentions {list capabilities the template
  doesn't cover}. The {template} template you picked doesn't
  ship those — they'd belong to separate projects in this
  solution (which you can add later via add-project mode).

  How do you want to handle this?

    1. The feature_loop describes the WHOLE product; THIS
       project is just the {template's role — marketing site /
       CLI / library / etc.} part. I'll narrow the project-
       specific scope and put the broader description in
       SOLUTION.md "Application Description" for the eventual
       multi-project setup.
    2. The feature_loop is supposed to cover THIS project
       only — let me rewrite it. (User provides new
       feature_loop.)
    3. I want to add the other projects right now — pause
       INIT and re-run starting from KICKOFF_ADD_PROJECT after
       INIT completes for the first project.

Capture the user's choice. For (1), narrow the feature_loop
recorded in `projects/{project_name}/README.md` to just the
project's part; record the full broader description in
`/ai/SOLUTION.md` "Application Description". For (2), use the
new feature_loop and re-validate. For (3), proceed with INIT
for THIS project's narrow scope and add a note to HANDOFF.md
saying the next session should run KICKOFF_ADD_PROJECT for the
other projects mentioned.

If the NOTES block does NOT have `feature_loop_scope_check`
(pre-v1.3.1 wizards, or a user who skipped the wizard), this
sub-check is optional — but recommended if the AI notices
obvious scope mismatches.

## Step 3 — Verify dependency versions live

Per the Versioning Rules in `/ai/AI_RULES.md`, look up the current
stable version of EVERY dep in the recipe from its canonical
source AS OF TODAY. Sources: npm registry, PyPI, NuGet, Maven
Central, crates.io, pkg.go.dev, official runtime sites, Docker Hub
for container images, Terraform registry.

Do NOT pin versions from training-data knowledge. Versions move.

For each dep, capture: name, verified version, canonical source
URL, date verified. These go into per-dep ADRs in Step 8.

## Step 4 — Local infrastructure only (Phase 1)

Per the Local-First Development Rule, this step is scoped to
**local development only**. Cloud / IaC / managed-service / OIDC /
runtime-secret-store decisions are deferred to P3-T0.

Decide and record as ADRs:

- **Local container runtime**: Docker Compose / Podman / OrbStack /
  Lima. Recipe may have a preference; honor it unless the user
  overrides. Record in `/ai/DEV_ENVIRONMENT.md`.
- **Stateful dep container versions** (Postgres / Redis / etc.,
  per the recipe): pin to the verified Docker Hub version. Match
  whatever P3-T0 will eventually pick for managed-service major
  versions (but THAT decision is deferred).
- **Local `.env.example`**: list every env var the project will
  need with placeholder values. Real secret-store binding is P3-T0
  territory.

Do NOT write ADRs for cloud target, IaC tool, Terraform state,
managed-service instances, OIDC, runtime secret store, network
defaults, or monthly budget cap. Those are deferred to P3-T0.

## Step 5 — Application-layer security baseline (solution-level)

Decide and record as ADRs (solution-level, applies to all
projects unless a project overrides):

- Auth library / service for end users (if applicable).
- Password hashing algorithm (default: argon2id) + library.
- Schema-validation library.
- CORS / CSP development defaults (production allowlists at P3-T0).
- Rate-limiting library / strategy (production thresholds at P3-T0).
- Dependency-update automation (Dependabot / Renovate).
- SAST tooling per language.
- SCA tooling.
- Logging library + PII redaction strategy.
- Container base image policy (if applicable).

Record each ADR with `Project: solution` since these apply
solution-wide.

## Step 6 — Free-tier ceilings (solution-level)

Per the Cost Rules + Local-First Development Rule, only free-tier
ceilings are captured at init. The monthly cloud budget cap and
alert thresholds are deferred to P3-T0.

For each third-party service the recipe chose that has a free
tier (email provider's monthly send cap, auth provider's request
quota, etc.), record the limit and the escalation path in
`/ai/BUDGET.md` "Free-tier and tier choices".

If the kickoff captured a rough budget preference, record it in
`/ai/BUDGET.md` "Rough budget preference (revisit at P3-T0)".

## Step 7 — License

Inherit `license` from the NOTES block (default: MIT). Write the
license text to `LICENSE` at the solution root and record an ADR
in `/ai/DECISIONS.md` (`Project: solution`).

## Step 8 — Write ADRs

Append ADRs to `/ai/DECISIONS.md` for every choice from Steps 3-7.
Number sequentially. Shape:

  ## ADR-NNN: {Decision title}
  Date: {today}
  Status: Accepted
  Project: {project_name | solution}

  ### Decision
  Use {dep} {verified version}. Verified on {today} from
  {canonical source URL}.

  ### Reason
  {From the recipe or the Local-First Development Rule.}

  ### Tradeoffs
  {Honest tradeoffs.}

  ### Related Tasks
  {Phase-1 task IDs.}

Cover at minimum: language, framework, DB engine family (if any),
ORM (if any), auth library, password hashing, schema validation,
test runner, lint/format, package manager, local container
runtime, local container versions for each stateful dep, license.

## Step 9 — (Conditional) Old-repo inspection + migration direction

Skip if OLD REPO is "none — greenfield".

If OLD REPO is provided:
- Inspect read-only. Never modify it.
- Catalog: pages / modules, content, copy, assets, brand, nav,
  integrations, features to drop, opportunities to improve.
- Decide with the user: Preserve / Evolve / Rebuild. Record as an
  ADR.

## Step 10 — Fill in `/ai/SPEC.md` (solution-level, scoped to first project)

For non-trivial projects, populate `/ai/SPEC.md` with the first
project's user flows, edge cases, performance budgets,
accessibility targets, browser / device / runtime support, and
compliance requirements (if any).

When more projects are added later, SPEC.md gets per-project
sections. For now, just the first project's section.

## Step 11 — Create solution-level files + first project scaffold shape

### Solution-level updates

Rewrite `/ai/SOLUTION.md`:
- Replace TBD identity sections with the user's answers.
- Projects table gets one row: `{project_name} | {platform} | {language} | {template} | Phase 1`.
- Tier section = `{tier}` from NOTES (with the rationale).
- Rules in force section = applicable Hard rule blocks per tier.
- Tech stack / security / infrastructure sections point at the
  ADRs written in Step 8.

Rewrite `/ai/ARCHITECTURE.md`:
- "System Overview" Mermaid `flowchart LR` with one node for
  `{project_name}` (role-labeled, no vendor names).
- Cloud subgraph marked dashed and labeled "TBD — set at P3-T0".
- Trust boundaries annotated based on Step 5 security baseline.

Rewrite `/ai/CURRENT_STATE.md`, `/ai/HANDOFF.md`, `/ai/DONE_LOG.md`
per the templates (keep within line caps).

Update `/ai/ROADMAP.md` with solution-specific milestones under
the existing Phase 0..5 structure.

### Per-project files

Create `projects/{project_name}/` with:
- `README.md`: project-specific stack + verified versions +
  canonical source URLs + date verified + local-dev story
  (run, test, build). Pulled from the recipe.
- `.gitkeep` or a minimal placeholder file if the recipe
  doesn't ship one — actual scaffolding happens in P1-T1.

## Step 12 — Queue Phase-1 tasks for the first project + P3-T0

Append to `/ai/TASKS.md`. Use sequential P1-T{n} IDs. Each task
includes `Project: {project_name}` (or `Project: solution` for
solution-level tasks).

Phase-1 tasks for `{project_name}`, in order (Local-First
Development Rule):

1. P1-T1: Scaffold `{project_name}` per the recipe. Project:
   `{project_name}`.
2. P1-T2: Verify local development loop is green for
   `{project_name}` (gates P1-T3). Project: `{project_name}`.
3. P1-T3: Add Dependabot / Renovate config. Project: solution.
   (Must land before P1-T4 — the security guardrails leg of the
   CI workflow requires dependency-update automation to be
   configured, or the workflow fails on first push.)
4. P1-T4: Configure CI workflow that mirrors the local loop for
   `{project_name}` AND adds the security guardrails leg
   (`/ai/templates/ci-security.template.yml` extended with the
   real SAST / SCA tools chosen in DECISIONS.md). Project:
   `{project_name}`.
5. P1-T5: Write SECURITY.md and CONTRIBUTING.md at solution root
   from `/ai/templates/SECURITY.template.md` and
   `/ai/templates/CONTRIBUTING.template.md`. Project: solution.

Phase-3 deploy-planning task (Backlog):

  ### P3-T0: Deploy Planning (cloud, IaC, budget ADRs)
  Status: Backlog
  Project: solution
  Prerequisites: Phase 2 complete

  See `/ai/ROADMAP.md` Phase 3 "Deploy Planning" sub-section
  for full scope. Produces the cloud / IaC / managed-service /
  OIDC / network-defaults / monthly-budget-cap ADRs deferred at
  init. Queues Phase-4 implementation tasks (P4-T1..P4-T5+).

Do NOT queue Phase-1 hosting / OIDC / IaC / first-deploy / cloud-
budget tasks. Those belong to P3-T0 → Phase 4.

Each task follows `/ai/templates/TASK_TEMPLATE.md` and satisfies
the Task Quality Rules (Prerequisites, ordered steps,
Verification, Rollback/Recovery, Project line).

CURRENT_STATE ≤ 80 lines, HANDOFF ≤ 50 lines. Use the templates.
Fresh `Last Updated: YYYY-MM-DD` on every touched file.

## Step 13 — Tool-native memory hooks

Verify the following exist at the solution root with one-line
content "Always read /ai/START_HERE.md first":

- `CLAUDE.md` (Claude Code)
- `AGENTS.md` (Codex CLI, several agentic tools)
- `.cursorrules` (Cursor)
- `.github/copilot-instructions.md` (GitHub Copilot)
- `GEMINI.md` (Gemini CLI)

Add a stub for any AI tool the user uses that's missing.

## Step 14 — Replace starter-history files and remove starter-setup files

### Replace

- `CHANGELOG.md` at the solution root: currently the starter's
  own release log. Overwrite with:

  ```markdown
  # Changelog

  Last Updated: <today>

  ## Unreleased
  - Solution planning initialized (P0-T1).
  ```

- `/ai/DONE_LOG.md`: clear any starter-release entries; seed only
  the P0-T1 entry for this solution.

### Remove (starter-setup files have no use after init)

- `ai/templates/KICKOFF_NEW_PROJECT.md` (legacy redirect stub)
- `ai/templates/KICKOFF_NEW_SOLUTION.md`
- `ai/templates/KICKOFF_ADD_PROJECT.md` — KEEP (used for future
  add-project runs)
- `ai/templates/KICKOFF_EXISTING_SOLUTION.md`
- `ai/templates/INIT_PROMPT.md` (you're inside this one — delete
  on the way out)
- `ai/templates/ADD_PROJECT_PROMPT.md` — KEEP (used for future
  add-project runs)
- `ai/templates/ADOPT_PROMPT.md`
- `ai/templates/README.template.md` (already used)
- `ai/templates/SECURITY.template.md` (used in P1-T5 — KEEP until
  P1-T5 closes, then delete)
- `ai/templates/CONTRIBUTING.template.md` (same — KEEP until P1-T5)
- `ai/EXAMPLE_SOLUTION.md`
- `ai/reference/PROMPT_LIBRARY.md` (if present)
- `/ai/templates/recipes/` — KEEP if you might add more projects;
  delete if this is a permanent one-project solution.

Keep:
- `ai/templates/REFRESH_PROMPT.md` (future starter upgrades)
- `ai/templates/TASK_TEMPLATE.md` (new tasks)
- `ai/templates/INCIDENT_TEMPLATE.md` (post-mortems)
- `ai/templates/CHAT_END_PROMPT.md` (end of every session)
- `ai/templates/CURRENT_STATE.template.md`,
  `ai/templates/HANDOFF.template.md`

## Step 15 — Environment variables

Identify env vars the first project needs (from the recipe + Step
10 SPEC). Document in `/ai/DEPLOYMENT.md` "Required Environment
Variables" with placeholder values + which secret store will hold
each in QA / Production (note: real secret-store binding is P3-T0).

The actual local `.env.example` file is created during scaffold
(P1-T1), not now.

## Pre-flight self-check (mandatory before declaring P0-T1 done)

Confirm each item. If ANY unchecked, STOP and fix it.

  Pre-flight before closing P0-T1 (new-solution-with-first-project):
  - [ ] `/ai/SOLUTION.md` has no remaining TBD sections (open
        questions explicitly flagged).
  - [ ] `/ai/SOLUTION.md` "Projects" table has exactly one row
        for `{project_name}`.
  - [ ] Every major LOCAL stack / application-layer-security /
        license choice has a corresponding ADR with verified
        version + canonical source URL + date verified.
  - [ ] **NO deploy ADRs were pre-written** (cloud target, IaC,
        managed services, OIDC, runtime secret store, network
        defaults, monthly budget cap). Per the Local-First
        Development Rule, those belong to P3-T0.
  - [ ] `/ai/ARCHITECTURE.md` Mermaid diagram has one node for
        `{project_name}`. Cloud subgraph (if any) is dashed
        "TBD — set at P3-T0".
  - [ ] `/ai/BUDGET.md` has "Free-tier and tier choices" filled
        in for any third-party services with free-tier ceilings,
        AND a "Rough budget preference (revisit at P3-T0)" line
        if the kickoff captured one. Monthly cap + alert
        thresholds + Major cost contributors are NOT filled in.
  - [ ] `LICENSE`, `README.md`, `SECURITY.md`, `CONTRIBUTING.md`
        exist at the solution root.
  - [ ] All 5 tool-native memory hooks exist at the solution root.
  - [ ] Phase-1 tasks reflect the Local-First Development Rule
        ordering: scaffold → verify local green → CI mirrors →
        Dependabot → root docs. NO hosting / OIDC / IaC / first-
        deploy / cloud-budget tasks in Phase 1.
  - [ ] **P3-T0 (Deploy Planning) task is queued** in TASKS.md
        Backlog with `Project: solution`,
        `Prerequisites: Phase 2 complete`.
  - [ ] `projects/{project_name}/README.md` exists with the
        recipe's content + verified versions.
  - [ ] The first Phase-1 task in `/ai/TASKS.md` has every section
        from `/ai/templates/TASK_TEMPLATE.md` populated, including
        the new `Project:` line.
  - [ ] `/ai/CURRENT_STATE.md` ≤ 80 lines, `/ai/HANDOFF.md` ≤ 50
        lines.
  - [ ] Every touched planning file has fresh
        `Last Updated: YYYY-MM-DD`.
  - [ ] Starter-history files replaced and starter-setup files
        removed per Step 14.
  - [ ] `python3 scripts/lint-planning.py` passes with 0 errors
        and 0 warnings.

## Hard rules

- Do NOT scaffold the project's code yet (P1-T1 task).
- Do NOT install dependencies yet.
- Do NOT create real cloud resources (P4-T3 task).
- Do NOT write deploy ADRs (cloud target, IaC, Terraform state,
  managed services, OIDC, runtime secret store, monthly budget
  cap) — those belong to P3-T0.
- Do NOT queue Phase-1 hosting / OIDC / IaC / first-deploy / cloud-
  budget tasks.
- Do NOT modify any read-only reference repo.
- Use placeholders only, never real secrets.
- Look up versions from canonical sources — never assume from
  training-data knowledge.
- Push after every commit (Git Rules in AI_RULES.md).
- Confirm before any destructive operation.
- Mark Blocked, do not silently work around.
- Run the Pre-flight self-check above before declaring P0-T1 done.

Begin with the Start-of-Chat summary (START_HERE.md section 5).
End with the End-of-Chat report (START_HERE.md section 6) —
including the self-critique section.
```
