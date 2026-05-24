# Changelog

Starter Version: 1.3.1
Last Updated: 2026-05-22

This changelog tracks the `ai-starter` template itself. Copied application
projects should maintain their own project changelog or release notes after
initialization.

## 1.3.1 - 2026-05-22

Two fixes from the live E2E test of the Mode 1 wizard:

- **Wall-of-text fix**: the three kickoff wizards
  (`KICKOFF_NEW_SOLUTION.md`, `KICKOFF_ADD_PROJECT.md`,
  `KICKOFF_EXISTING_SOLUTION.md`) previously instructed the AI to
  emit the FULL content of the corresponding actor prompt (INIT /
  ADD_PROJECT / ADOPT) — ~290 lines per generation — at the end
  of the wizard. In a real session that floods the chat without
  adding value (the actor file is already in the repo). Wizards
  now emit ONLY the NOTES block + a path reference, telling the
  user to run `/ai/templates/{actor}.md` with the NOTES.
- **Over-scope detection in feature_loop validation**: wizards
  now set `feature_loop_scope_check: required` in the generated
  NOTES block. `INIT_PROMPT.md` Step 2 and
  `ADD_PROJECT_PROMPT.md` Step 2 gained over-scope checks that
  read the picked template's recipe and detect when the
  feature_loop describes capabilities the template can't deliver
  (e.g., Astro Static + feature_loop mentioning uploads, AI
  generation, payments, auth). When detected, the AI clarifies
  with the user rather than silently proceeding — three
  resolution options: narrow scope to this project, rewrite the
  feature_loop, or pause INIT and run add-project for the other
  projects mentioned.

The under-scope refusal (foundation/architecture-shaped answers)
was already in place since v0.5.5 — that catches a different
failure mode. The new over-scope check is its mirror image: the
feature_loop describes MORE than the template covers, not less.

## 1.3.0 - 2026-05-22

Closes the v1.2.1 deferred design items (#43 monorepo workspace
setup, #44 "Custom" template path UX) and adds the Gemini phase
harness from the v1.2.1 audit gap §3.5. The "Custom" template
path is meaningfully thinner now — the 6 most common
combinations the v1.2.0 8-recipe set didn't cover are recipes.

### Recipe library: +6 platform recipes (total 14)

The new recipes follow the same shape as the v1.2.0 8 — design
philosophy, bundled stack table with placeholder versions +
canonical-source URLs, folder layout, local-dev story, free-tier
ceilings, production handoff:

- `recipes/server/go-echo.md` — Echo + sqlc + Postgres + JWT
- `recipes/server/aspnet-core-webapi.md` — ASP.NET Core Web API
  + EF Core + JWT (API-only, distinct from MVC)
- `recipes/web/django.md` — Django + Postgres + django-allauth
  + optional django-htmx
- `recipes/cli/go-cobra.md` — Cobra + Viper + goreleaser
- `recipes/library/python-poetry.md` — Poetry-managed Python
  library + Trusted Publishers
- `recipes/library/go-module.md` — Go module distributed via
  git tags + pkg.go.dev

`KICKOFF_NEW_SOLUTION.md` Turn 3 template table updated to
reflect the new combinations. The "Custom" fallback still exists
but now only fires for combos that genuinely fall outside the
14-recipe set (e.g., Desktop+TS Electron/Tauri, Mobile+C# MAUI).

### Recipe library: +4 workspace recipes (#43)

New `ai/templates/recipes/workspaces/` directory addresses the
"multi-project solution sharing code" gap that v1.2.0 left
unmachined. Solutions with multiple projects in the same
ecosystem can now wire up a workspace via:

- `workspaces/pnpm-workspace.md` — pnpm-workspace.yaml,
  workspace deps via `workspace:*`, root-level scripts.
- `workspaces/dotnet-solution.md` — `.sln` via `dotnet new sln`
  + `dotnet sln add`, ProjectReference for shared class libs.
- `workspaces/cargo-workspace.md` — `[workspace] members` in
  root Cargo.toml, workspace.dependencies for shared versions.
- `workspaces/go-work.md` — `go.work` for development-time
  cross-module imports (releases stay per-module via git tags).

Python deliberately has no workspace recipe — the ecosystem has
no first-class workspace concept.

### ADD_PROJECT_PROMPT.md: workspace-setup task detection

`ADD_PROJECT_PROMPT.md` Step 9 now detects when the new project
shares a language ecosystem with an existing project AND the
workspace file doesn't yet exist at solution root. When the
trigger fires, an additional Phase-1 task is queued (
`P1-T{n+4}: Set up <ecosystem> workspace at solution root`,
`Project: solution`) linking to the matching recipe.

Tier-aware behavior:
- **Solo prototype**: task queued with `Status: Deferred`
  (workspace not strictly needed yet for one developer).
- **Small team / production**: `Status: Ready`. Should land
  before the new project's Phase-2 work.

Multiple-ecosystem solutions get one workspace task per
ecosystem. The pre-flight self-check verifies the workspace
detection ran. Skip path: if the user has an ADR explicitly
declining workspace setup for this ecosystem.

### Google Gemini phase harness

Added `run-phase-gemini.sh`, closing v1.2.1 audit gap §3.5
where Gemini was advertised as a supported tool but had no
autonomous-phase adapter. Mirrors `run-phase-codex.sh` with
Gemini-specific flags (`--model`, optional
`RUN_PHASE_GEMINI_YOLO_FLAG`). All five harness scripts now
have parallel structure and shellcheck CI coverage. README and
shared-lib comments updated to reference five adapters.

### Migration note for projects on v1.2.x

No migration needed. New recipes and workspace machinery are
opt-in for new projects via `ADD_PROJECT_PROMPT.md`. Existing
projects that want the workspace task retroactively can run
REFRESH and add it manually based on the matching workspace
recipe.

## 1.2.2 - 2026-05-22

Bugfix sweep addressing the issues found in the post-v1.2.1 code
review. Pure fixes, no new features.

- **`scripts/mark-task-done.py`** correctness pass (review §3.1,
  §4.1, §4.2):
  - Task-extraction termination now uses
    `re.match(r"^### P\d+-T\d+:", line)` instead of
    `line.startswith("### P")`. The old check prematurely
    terminated extraction on any H3 starting with `P`
    (`### Performance`, `### Prerequisites`, `### Postgres
    schema decisions`, etc.).
  - Task-title extraction switched from `str.replace()` to an
    anchored `re.sub()`, preventing duplicate-substring removal
    if a task title happened to mention its own ID.
  - DONE_LOG date-heading insertion now finds the correct
    chronological position by parsing existing date headings
    (ISO YYYY-MM-DD sorts lexicographically), inserting today's
    section ahead of all older ones. Previous logic found the
    first matching `### 20` heading regardless of date.
- **`ai/templates/ci-security.template.yml`** robustness (review
  §3.4, §4.3):
  - SAST guard switched from a self-referential negative check
    (absence of the template's own placeholder string) to a
    positive assertion that a workflow under `.github/workflows/`
    actually invokes one of the recognized SAST tools (CodeQL,
    Semgrep, Bandit, Trivy, SonarCloud, Snyk, Checkov, tfsec,
    gitleaks, trufflehog). Workflow naming is no longer
    constrained.
  - Dependency-update guard now emits a clear `::error::`
    message pointing at the responsible Phase-1 task (P1-T3)
    when the config is missing. INIT_PROMPT.md Phase-1 task
    order is updated so Dependabot/Renovate lands BEFORE the CI
    workflow, preventing the guard from failing on first push.
  - Template gains a top-comment ordering note for future
    template users.
- **`scripts/run-phase-lib.sh`** portability + clarity (review
  §3.7, §3.8):
  - Replaced gawk-only `awk -v RS='\0' -v ORS='\0'` NUL-handling
    in `rpl_session_changed_paths` with portable bash 3.2+ using
    `read -r -d ''` and explicit substring slicing. macOS users
    no longer need `brew install gawk` to use the phase
    harnesses; stock `/bin/awk` and `/bin/bash` are sufficient.
  - Reworded the ambiguous `rpl_preflight` error message
    ("Create/switch to a $expected/* branch, or unset
    RUN_PHASE_AUTO_BRANCH=0" → "...unset RUN_PHASE_AUTO_BRANCH
    (defaults to auto-create)").
- **`.github/workflows/lint.yml`** (review §3.3): added
  `timeout-minutes: 10` to both `shellcheck` and `planning-lint`
  jobs. Prevents pathological hangs from running until GitHub's
  6-hour default.
- **`scripts/lint-planning.py`** (review §3.2): removed the
  unused `argv` parameter from `main()`. Either implement CLI
  args or don't accept them; we don't need them.

### Not addressed in this release (deferred)

- **3.5 No Gemini run-phase script.** Tracked as
  v1.3.0+ decision: fill the gap with a `run-phase-gemini.sh`
  adapter, or drop Gemini from the supported-tools list. Needs
  product-direction call.
- **3.6 docs/ deprecated component/rung terminology.** Same as
  the v1.2.1 "Custom template path UX" deferral — needs design
  work, not a bug fix.

## 1.2.1 - 2026-05-21

Catches up the brownfield + refresh paths to the v1.2.0
solution/project model and fills in the documentation gaps from
the v1.2.0 fixup audit.

- **`KICKOFF_EXISTING_PROJECT.md` → `KICKOFF_EXISTING_SOLUTION.md`
  rename + wizard rewrite.** Inspection-driven now: the AI reads
  your repo, proposes which v1.2.0 projects/recipes match the
  existing code, and asks 2-3 confirmations. Replaces the v1.0.0
  component-walk interview. Old filename kept as a redirect stub
  for one release.
- **`ADOPT_PROMPT.md` refactored for solution/project model.**
  Treats existing code as one-or-more projects inside a new
  solution shell. Creates `projects/<name>/README.md` planning
  sidecars without restructuring app code. Branches deployed
  brownfield (retroactive deploy ADRs, P3-T0 marked Done) vs
  not-deployed brownfield (defer deploy ADRs to P3-T0).
- **`REFRESH_PROMPT.md` Check 13** added: detects pre-1.2.0
  projects (have `/ai/PROJECT.md`), renames to `SOLUTION.md`,
  rewrites the file with the Projects table for the existing
  code, updates lint script reference, updates HANDOFF /
  CURRENT_STATE next-action references to the new wizard names,
  and queues an ADR documenting the migration. Existing Check 12
  (origin/main parity) renumbered to Check 13.
- **`README.template.md` and `CONTRIBUTING.template.md`** updated
  to mention the `projects/<name>/` folder structure and the
  add-project flow. Downstream-generated docs now reflect the
  v1.2.0 layout instead of a single-project layout.
- **9 other files** had stale `KICKOFF_EXISTING_PROJECT.md`
  references updated to `KICKOFF_EXISTING_SOLUTION.md`.

### Deferred beyond v1.2.1

The two audit items not addressed:

- **Monorepo workspace setup**: when multiple projects in the same
  solution share types (e.g., Next.js web + NestJS API both in
  TypeScript), there's no machinery to wire up
  `pnpm-workspace.yaml` / `Cargo workspace` / `.NET solution`.
  Design work; deferred to a future minor.
- **"Custom" template path UX**: when no v1.2.0 recipe matches the
  user's (platform, language) combo, the wizard routes to
  `docs/PROJECT_SHAPE_GALLERY.md` which still uses
  component/rung terminology. UX is thinner than the 8 supported
  templates. Deferred to a future minor.

## 1.2.0 - 2026-05-21

Wizard-style kickoff + solution/project model. Fixes the second
expensive failure mode observed in real init sessions: the
behavioral-diagnostic-driven kickoff (15-25 mostly open-ended
questions) felt confusing and gave users no clear win over a
generic "describe your project" prompt. The kit also tried to
scaffold whole composite solutions in one go, which doesn't
match how real apps actually evolve.

v1.2.0 replaces the 20+-question interview with an IDE-style
wizard (3 picks + 1 free-text) and replaces the "predict every
component up front" model with a solution-of-1-N-projects model
where you add projects one at a time.

### Concept changes

- **Solution = repo. Projects = apps inside it.** `/ai/` lives
  at the solution root. Each project gets its own
  `projects/<name>/` folder with a project-specific README. The
  composite Mermaid diagram in `/ai/ARCHITECTURE.md` is the
  source of truth for how projects connect.
- **One project per init run.** First run creates the solution +
  the first project. Subsequent runs add a project via
  `KICKOFF_ADD_PROJECT.md`. No more predicting all components
  up front.
- **Wizard pattern.** New kickoff is 3 picks + 1 free-text:
  Platform → Language → Template → Feature loop → Generate.
  Modeled on VS / Rider / IntelliJ / Xcode "new project"
  dialogs. Filters at each step (language list narrows by
  platform; template list narrows by language).
- **Opinionated templates.** Each template ships with a bundled
  DB / auth / styling / etc. opinion. No more "do you need a DB"
  / "do you need auth" wizard turns — the template pick IS that
  answer.
- **D1-D5 behavioral diagnostic removed.** Direct picker replaces
  it. Users `?` on any pick for clarifying examples if needed.
- **Per-component dimension walks removed.** Templates carry the
  dimensions; users edit `/ai/SOLUTION.md` after init if they
  want to deviate.
- **Compliance walk now conditional.** Defaults to none; user
  opts in via `+ gdpr` / `+ hipaa` / etc. on the auto-defaults
  step, or edits `/ai/SOLUTION.md` post-init.
- **Tier collapsed to one line in `/ai/SOLUTION.md`.** No longer
  asked in the wizard; defaults to "small team / early
  production" with rationale.

### Files renamed

- `/ai/PROJECT.md` → `/ai/SOLUTION.md` (content rewritten to
  describe a solution-with-N-projects rather than a single
  project with N components).
- `/ai/EXAMPLE_PROJECT.md` → `/ai/EXAMPLE_SOLUTION.md` (rewritten
  to show TaskTrack as a solution adding projects across Day 1,
  Day 30, Day 60).

### New files

- `/ai/templates/KICKOFF_NEW_SOLUTION.md` — Mode 1 wizard (first
  run: solution + first project).
- `/ai/templates/KICKOFF_ADD_PROJECT.md` — Mode 2 wizard
  (subsequent run: add a project to existing solution).
- `/ai/templates/ADD_PROJECT_PROMPT.md` — actor invoked after
  Mode 2 wizard. Appends to `/ai/`, creates new
  `projects/<name>/`, updates the Mermaid diagram.
- `/ai/templates/recipes/` directory with 8 v1.2.0 templates:
  - `web/nextjs-ts.md` — Next.js + Postgres + Drizzle + Auth.js + Tailwind
  - `web/aspnet-core-mvc.md` — ASP.NET Core MVC + EF Core + Identity
  - `web/astro-static.md` — Astro static + Tailwind + Formspree
  - `server/nestjs.md` — NestJS + Postgres + Drizzle + JWT
  - `server/fastapi.md` — FastAPI + SQLAlchemy + Postgres + JWT
  - `cli/python-typer.md` — Python Typer CLI + Poetry
  - `library/typescript-tsup.md` — TS library + tsup + changesets
  - `mobile/react-native.md` — React Native with Expo
- `/ai/templates/KICKOFF_NEW_PROJECT.md` — converted to a 5-line
  redirect stub pointing at `KICKOFF_NEW_SOLUTION.md`. Will be
  deleted in v1.3.0.

### Rewrites

- `/ai/templates/INIT_PROMPT.md` — restructured for "init one
  project + solution shell" mode. Inherits NOTES block from
  `KICKOFF_NEW_SOLUTION.md`. Uses the picked recipe as the
  canonical source for the stack + folder layout + design
  philosophy. Still verifies live versions per the Versioning
  Rules.
- `/ai/SOLUTION.md` (rebooted from `PROJECT.md` rename) —
  Projects table + Tier + Rules in force + solution-level
  security baseline + Infrastructure (deferred to P3-T0) +
  Repository Layout showing `projects/<name>/` convention.
- `/ai/EXAMPLE_SOLUTION.md` — TaskTrack worked example showing
  three projects added across time (Day 1: web; Day 30:
  marketing; Day 60: admin-api).
- `/ai/START_HERE.md` Section 4 — routes to the new wizards.

### Updated

- `/ai/AI_RULES.md` Task Quality Rules: every task gets a
  `Project: <name>` line (or `Project: solution` for solution-
  level tasks). Task IDs stay solution-level (P1-T1, P1-T2, ...)
  not per-project, so prerequisite graphs work across projects.
- `scripts/lint-planning.py` — `ai/PROJECT.md` reference replaced
  with `ai/SOLUTION.md`.
- `README.md` — "First time?" fork updated for the new wizard
  routing; new What's Included section listing recipes.
- 17 other files updated mechanically by find/replace of
  `PROJECT.md` → `SOLUTION.md` and `EXAMPLE_PROJECT.md` →
  `EXAMPLE_SOLUTION.md`.

### Migration note for projects on v1.1.0 or earlier

Run `/ai/templates/REFRESH_PROMPT.md` against your project. The
REFRESH v1.2.0 backfill check (in `v1.2.1` — not landed yet)
will:

- Rename `/ai/PROJECT.md` → `/ai/SOLUTION.md` and add the
  Projects table with one row for your current code (treated as
  the "first project").
- Reorganize your code under `projects/<name>/` if it isn't
  already.
- Update task `Project:` tags.

If you're not ready to migrate, your v1.1.0 project keeps
working — the v1.2.0 changes are forward-only and don't affect
already-initialized projects. The recipes / new wizards are
opt-in for new projects only.

### Deferred to v1.2.1

- `ADOPT_PROMPT.md` refactor for the solution/project model
  (still references the v1.0.0 component model internally).
- `KICKOFF_EXISTING_PROJECT.md` refactor (same reason).
- `REFRESH_PROMPT.md` v1.2.0 backfill check (Check 13).
- More recipes (Blazor, Django, Flask, Go Echo, Rust Axum,
  Electron, Tauri, etc.) as patterns prove out.

## 1.1.0 - 2026-05-20

Local-First Development. Fixes the most expensive failure mode
observed in real init sessions: the kit was driving the AI to write
deploy ADRs (cloud target, Terraform, OIDC, managed services,
monthly budget cap) at Phase 0 — before there was even a working
local app to deploy — which led to AI sessions burning hours on
plumbing and, in one case, using the 20-minute CI/CD pipeline as a
fix-and-retry loop. The deploy decisions now happen at Phase 3
(P3-T0), after the app actually runs locally and ships features.

- **New (Hard) rule: Local-First Development Rule** in
  `/ai/AI_RULES.md`. Always-on. Explicitly bans the CI-as-debug-loop
  pattern. Mandates: app runs locally → lint/test/build green
  locally → CI mirrors local → only then is CI passing on the first
  try. Hosting / OIDC / IaC / first-deploy work is named as
  Phase-3 / Phase-4, NOT Phase-1.
- **Infrastructure & Hosting Rules + Cost Rules: deferred decisions
  preamble.** Both blocks gained a "When these decisions are made"
  preamble that defers cloud-target / IaC / managed-service / OIDC /
  runtime-secret-store / network-defaults / monthly-budget-cap to
  the new P3-T0 deploy-planning task. The Local development bullet
  in Infrastructure & Hosting Rules remains Always-on (containers
  for local stateful deps are scaffolding).
- **`INIT_PROMPT.md` Step 4 rewritten** to "Choose local
  infrastructure (Phase 1 only)". Records the local container
  runtime + local container versions per stateful dep + a
  `.env.example`. Cloud target, IaC, managed-service instances,
  OIDC, runtime secret store: explicitly deferred to P3-T0. Brown-
  field exception preserved for already-deployed apps.
- **Step 5 (security baseline) clarified**: application-layer
  security decided at init; cloud-network-layer security (production
  CORS allowlists, prod rate-limit thresholds, OIDC, container
  digest pinning in prod manifests) deferred to P3-T0.
- **Step 6 (budget) rewritten** to "Free-tier ceilings (Phase 1 cost
  tracking)". Records free-tier ceilings for third-party services
  + a "Rough budget preference (revisit at P3-T0)" line if the
  kickoff captured one. Cost-Rules-compliant cap + alert thresholds
  + Major cost contributors: deferred to P3-T0.
- **Step 11 Phase-1 task ordering enforced.** The five "always"
  Phase-1 tasks are now ordered: scaffold → verify local green
  (gates everything else) → CI mirrors local → Dependabot →
  SECURITY/CONTRIBUTING. Tasks 5-9 from v1.0.0 (Terraform state
  bootstrap, OIDC trust, first IaC apply, first production deploy,
  cloud budget+alerts) are **removed from Phase 1** and become
  Phase-4 tasks (P4-T1..P4-T5+) queued by P3-T0.
- **New Phase-3 task: P3-T0 (Deploy Planning)** generated by INIT at
  init time, queued in Backlog with `Prerequisites: Phase-2 done`.
  Its scope: write the deferred deploy ADRs, fill BUDGET.md with a
  real cap, queue P4-T1..P4-T5+. Hard gate: no Phase-4 task may
  move to Ready until P3-T0 is Done.
- **Pre-flight self-check** in INIT_PROMPT.md updated: drops the
  "BUDGET.md has a cap" requirement; adds explicit checks that
  deploy ADRs are NOT pre-written, Phase-1 tasks contain no
  hosting/OIDC/IaC work, and P3-T0 is queued in Backlog.
- **`ROADMAP.md` Phase 1 deliverables reordered** to match the
  Local-First Development Rule (local run first, lint/test/build
  green locally second, CI passes last). **Phase 3 gains an explicit
  Deploy Planning sub-section** describing P3-T0's scope and the
  Phase-4 hard gate.
- **`KICKOFF_NEW_PROJECT.md`**: S6 (cloud preference) and S7 (budget
  preference) reframed as *rough preferences* finalized at P3-T0,
  not locked-in decisions. Slot names changed
  (`cloud_preference` / `budget_preference_usd` /
  `alert_threshold_hint`). The budget reality check still runs as a
  rough sanity check but emits a preference, not a Cost-Rules-
  compliant cap. Composite Mermaid diagram convention: cloud
  subgraph dashed and labeled "TBD — set at P3-T0".
- **`ADOPT_PROMPT.md`** distinguishes deployed brownfield (cloud /
  budget ADRs backfilled retroactively from existing state, P3-T0
  marked Done) from non-deployed brownfield (same deferral as INIT,
  queue P3-T0 Backlog). Detection by inspection if no kickoff
  NOTES.
- **`KICKOFF_EXISTING_PROJECT.md`** Q4.3 (cloud) and Q4.4 (budget)
  branch on `brownfield_deploy_state`: deployed brownfield captures
  current state as retroactive ADRs; not-deployed brownfield
  captures rough preferences finalized at P3-T0. Detection by
  inspection of deploy artifacts during Step 1.
- **`REFRESH_PROMPT.md`** gains Check 11 (v1.1.0 Local-First
  backfill) that adds the Local-First Development Rule to
  `AI_RULES.md` if missing, restructures Phase 1/3/4 task layout
  per the new pattern, and demotes premature BUDGET caps to "Rough
  budget preference" for projects that aren't yet deployed. Old
  Check 11 (origin/main parity) renumbered to Check 12.
- **`EXAMPLE_PROJECT.md`** updated to v1.1.0 shape: deploy ADRs
  shown as ADR-010..ADR-016 written at P3-T0 (not ADR-006..ADR-013
  at init). Phase-1 task example replaced with `P1-T2: Verify local
  development loop is green`. New `P3-T0: Deploy Planning` example
  block. CURRENT_STATE excerpt shows local-first ordering.

### Migration note for projects on v1.0.0

Run `/ai/templates/REFRESH_PROMPT.md` against your project. Check 11
will detect the missing Local-First Development Rule and add it,
restructure your Phase 1 / Phase 3 / Phase 4 task layout, and demote
any premature BUDGET cap (for not-yet-deployed projects) to "Rough
budget preference". Already-deployed projects keep their existing
deploy ADRs and BUDGET cap — the rule changes how future projects
init, not how deployed projects operate.

## 1.0.0 - 2026-05-13

**What 1.0.0 commits to.** The kit's conceptual model is settled:
kickoff → init → planning files → phase work. Future major versions
will be intentional, not exploratory. Specifically, the kit will not
break the following without a major version bump:
- The kickoff → INIT → ADOPT → REFRESH flow.
- The shape of `/ai/` planning files (PROJECT, ARCHITECTURE,
  CURRENT_STATE, HANDOFF, TASKS, DECISIONS, SPEC, ROADMAP, BUDGET,
  TESTING, DEPLOYMENT, DEV_ENVIRONMENT, WORKFLOW, DONE_LOG).
- The component model (1–N components per project, per the gallery).
- The tier model (solo prototype / small team / production).
- The (Hard) rule blocks in `AI_RULES.md` and their applicability
  semantics.

Minor versions (1.x) may add components, rungs, optional rules, or
templates. Patch versions (1.x.y) are pure fixes.

**Major changes from 0.x:**

- **Project Shape Gallery** (`/docs/PROJECT_SHAPE_GALLERY.md`). New
  reference catalog of 9 component types (web app, static site, API
  service, CLI tool, library/SDK, mobile app, desktop app, data/ML
  pipeline, plugin/extension), each with 4-6 rungs from simplest to
  most complex. Each rung carries a Mermaid diagram, an examples
  list, and a default-dimensions block the kickoff uses to pre-fill
  the dimension walk. Cross-references the existing
  `docs/CHOOSING_WEBAPP_PATH.md`. Composite-project examples
  included.
- **Composite component model.** Projects are now treated as 1-N
  components (not single shapes). A typical SaaS is "marketing
  static + web app + API service". A typical dev tool is "library +
  CLI + docs site". Per-component dimensions, per-component
  Phase-1 tasks, composite Mermaid diagram, cross-component
  decisions (monorepo vs. multi-repo, lockstep vs. independent
  versioning, shared identity/CI/design).
- **Behavioral diagnostic in kickoff.** The new-project kickoff
  begins with a feature-loop question (Q1) followed by D1–D5 — five
  behavioral questions that classify the project into components.
  The AI proposes a component set in plain language and waits for
  explicit user confirmation before proceeding. The
  existing-project kickoff infers components from repo signals
  before asking.
- **Complexity tier dial.** Solo prototype / small team / production.
  Tier governs which Hard rule blocks apply — solo prototype
  downgrades Infrastructure & Hosting Hard rules to recommendations
  until tier changes; production adds on-call / SLO / DR
  requirements.
- **Rule Applicability section in `AI_RULES.md`.** Some blocks
  (Infrastructure & Hosting, Cost) are now conditional on whether
  the project has hosted components and the tier. The resolved rule
  set is recorded in `/ai/PROJECT.md` "Rules in force" so every
  session inherits the same picture.
- **Per-component rung pick.** For each component, the kickoff
  shows the rung ladder from the gallery and asks "which rung is
  closest?" The picked rung pre-fills default dimensions so the
  dimension walk only asks about deviations.
- **INIT_PROMPT.md** updated to inherit the component set, tier,
  per-component dimension defaults, and composite diagram from the
  kickoff NOTES block. Phase-1 task list is now per-component and
  tier-conditional. Pre-flight self-check expanded to verify
  per-component dimension coverage, rule applicability decisions,
  and the composite diagram in `ARCHITECTURE.md`.
- **ADOPT_PROMPT.md** updated for v1.0.0: NOTES block inheritance
  (components / tier / rungs / composite diagram), PROJECT.md
  backfill now includes Components / Tier / Rules-in-force,
  ARCHITECTURE.md System Overview gets the composite Mermaid,
  catch-up tasks are tagged by component and gated by tier-applicable
  Hard rules.
- **REFRESH_PROMPT.md** gains a new Check 10 (v1.0.0 component /
  tier / rule applicability backfill) for pre-1.0.0 projects
  migrating forward. Check 7 also verifies the Rule Applicability
  section is present in `AI_RULES.md`.
- **PROJECT.md template** ships with explicit Components / Tier /
  Rules-in-force sections so INIT writes them in consistent
  locations across all projects.
- **EXAMPLE_PROJECT.md** updated to show the TaskTrack example with
  Components (Web R4 + Static R2), Tier (small team), and Rules-
  in-force sections — giving INIT a concrete reference shape.

## 0.7.0 - 2026-05-13

Kickoff hardening pass — addresses documented adherence failures in real
kickoff sessions where the AI skipped examples/defaults, skipped
follow-up dimensions, skipped summary-confirm, and shipped budget-stack
mismatches into INIT.

- **Per-question structured kickoff format.** Both
  `KICKOFF_NEW_PROJECT.md` and `KICKOFF_EXISTING_PROJECT.md` now use a
  per-question slot-fill shape (Ask / Offer examples / Offer "you pick"
  default / Reject / Probe / Capture slot / Update diagram). Summary
  blocks are now slot-filled verbatim instead of paraphrased.
- **Q9 dimension checklist (mandatory).** The stack question now walks
  15 explicit dimensions (frontend, backend, language, database, ORM,
  auth provider, authz model, caching, object storage, queues, email,
  payments, observability, test framework, package manager).
  Dimensions the user defers are captured as open questions, never
  silently invented. The brownfield kickoff applies the same checklist
  to dimensions it can't infer from the repo.
- **Compliance walk-through.** Q5 now names GDPR / CCPA / HIPAA / PCI /
  SOC 2 / data residency / other explicitly with one-sentence
  triggers, so the user doesn't have to guess what might apply.
- **Live Mermaid system diagram.** The AI now maintains a running
  `flowchart LR` diagram across the interview and re-renders at Q1, Q6,
  Q9, and Q10 (new-project) or after inspection, gap surfacing, and
  summary (existing-project) with explicit "Does this match what you're
  picturing?" checkpoints. The final diagram is included in the
  generated INIT/ADOPT prompt's NOTES block and committed to
  `/ai/ARCHITECTURE.md` "System Overview" during init.
- **Budget reality check (mandatory).** After the summary and before
  generating the prompt, the AI now looks up live floor costs for the
  chosen managed services, sums the unavoidable monthly floor, and
  surfaces any tension against the user's cap (raise-the-cap vs.
  scale-to-zero alternatives) before the user commits.
- **Pre-flight self-check (mandatory).** Both kickoffs and
  `INIT_PROMPT.md` now require an explicit checkbox self-check before
  generating the next prompt / declaring P0-T1 done. The kickoff
  checks cover examples-offered, defaults-offered, dimension coverage,
  diagram renders, slot-filled summary, verbatim user confirmation,
  and budget check. The init check covers ADR completeness, no silent
  TBDs, diagram in ARCHITECTURE.md, line caps, fresh
  `Last Updated` dates, and a green planning lint.
- **Worked Q1 example.** Both kickoff templates now include a
  good/bad worked example of the Q1 ask shape so the AI mirrors the
  right turn structure instead of asking bare questions.

## 0.6.2 - 2026-05-13

- **Brownfield adoption flow fixed.** `ADOPT_PROMPT.md` and
  `KICKOFF_EXISTING_PROJECT.md` now distinguish between a freshly copied
  starter `/ai/` folder (continue with ADOPT), a missing `/ai/` folder
  (copy starter files first), and an already project-specific `/ai/`
  folder (use REFRESH). This removes the previous "must not have `/ai/`
  but must read `/ai/START_HERE.md`" contradiction.
- **Security CI template no longer overclaims.** The default security
  workflow template is now a guardrail that fails when dependency-update
  config or real language-specific SAST is missing. `INIT_PROMPT.md`
  now tells the AI to replace or extend the guard with actual scanners
  chosen in ADRs.
- **Phase harness preflight.** The shared phase-run library now refuses
  dirty worktrees by default and auto-creates the matching AI-prefixed
  branch (`claude/*`, `codex/*`, `cursor/*`, or `copilot/*`) before
  unattended work. Escape hatches are explicit environment variables.
- **Automated commit subjects fixed.** The shared subject parser now
  recognizes the current `CHAT_END_PROMPT.md` "Work completed" bullet
  format, reducing generic fallback commit messages.
- **CI and docs cleanup.** Lint CI now runs on every branch push and PR,
  validates both Python helper scripts, and README no longer references
  a deleted chat-start template.

## 0.6.1 - 2026-05-13

- **Task-completion automation** (`scripts/mark-task-done.py`). Helper script that reliably finds a task block in `TASKS.md`, removes it, and appends the title to `DONE_LOG.md` under the current date. Prevents markdown-parsing errors during autonomous task completion.
- **Configurable git push behavior** (`SYNC_MODE=batch`). The shared phase harness now respects `SYNC_MODE=batch` or `RUN_PHASE_NO_PUSH=1` to skip pushing after every commit. Useful for rapid, autonomous iterations without network latency or CI clutter. Documented the override in `AI_RULES.md`.
- **Default security CI workflow**. Added `ai/templates/ci-security.template.yml` for Day-1 Dependabot and SAST scanning, and wired `INIT_PROMPT.md` to scaffold it automatically.

## 0.6.0 - 2026-05-13

Tighten the harness, give the kit a real lint surface, and make web-app
path choice an explicit step.

- **Shared phase-script library** (`scripts/run-phase-lib.sh`). The four
  AI-CLI adapters (`run-phase.sh`, `run-phase-codex.sh`,
  `run-phase-cursor.sh`, `run-phase-copilot.sh`) stay separate — each
  CLI has its own flag set and version churn — but now share
  log-dir setup, prompt strings, commit-subject extraction, and safe
  staging. The intent is documented in the library header so future
  refactors don't collapse the adapters.

- **Safe staging (no more `git add -A`).** The shared library
  enumerates exactly the paths git considers changed this session and
  refuses, fail-closed, to stage anything that looks like a secret,
  credential, key, certificate, local DB, or backup. Optional
  `RUN_PHASE_ALLOWLIST_REGEX` further restricts staging to a subtree.
  `RUN_PHASE_FORCE_UNSAFE=1` is the (loudly-warning) override.
  Unattended mode is preserved — push-after-commit and stop-on-push-
  failure semantics from the AI_RULES.md Git Rules are unchanged.

- **Planning linter** (`scripts/lint-planning.py`, Python stdlib only).
  Machine-readable check of the Task Quality and Planning-File Hygiene
  Hard Rules: every task in `TASKS.md` has the required H4 subsections
  (Goal, Prerequisites, Scope Included/Excluded, Acceptance Criteria,
  Verification, Test Requirements, Security / Cost Considerations,
  Rollback / Recovery, Known Blockers, Dev Environment Constraints,
  Handoff Notes) plus the metadata header (Status, Owner, Priority);
  every ADR in `DECISIONS.md` has Date, Status, Decision, Reason,
  Tradeoffs, Related Tasks; every planning file has a `Last Updated`
  line; `CURRENT_STATE.md` ≤ 80 lines and `HANDOFF.md` ≤ 50 lines.

- **CI workflow** (`.github/workflows/lint.yml`) — runs `shellcheck`
  on all four phase scripts plus the shared library, and runs the
  planning linter on every push and pull request.

- **Web-app decision tree** (`docs/CHOOSING_WEBAPP_PATH.md`). Mermaid
  diagram + checklist covering static marketing, docs, SPAs, CRUD,
  SaaS, AI apps, e-commerce / marketplace, realtime / collaboration,
  internal dashboards, public / private / internal / sensitive
  surfaces, auth / payments / user data / external APIs / AI cost /
  realtime / admin / deployment shape. Linked from README. The
  kickoff interview already asks these questions; this is the map
  behind them.

- **Docs**: README now lists the lint command, the shared library, and
  the new decision-tree doc as part of the kit. README's "manual
  setup" file list calls out the new artifacts.

## 0.5.5 - 2026-05-10

Make the kit actually build the app the user describes — not just
infrastructure that *could* host one.

**Problem this fixes**: the first real init (`secure-app-template`)
ended up planning ~14 Phase-2 tasks that were all foundation work
(auth, API skeleton, worker skeleton, GDPR controls, observability,
billing-flagged-off) and zero product features. The user's
description ("a B2C consumer SaaS foundation") was infrastructure-
shaped — and the AI took it literally. After Phase 2, there was no
actual product to ship; just a chassis ready to host one.

The fix: the kickoff interview and INIT/ADOPT actors now refuse
foundation-shaped and architecture-only application descriptions, and
loop with the user until they describe what end users actually *do*
with the app.

- **`ai/templates/KICKOFF_NEW_PROJECT.md` Question 1**: now strict.
  Asks "What does the app DO for users?" and gives concrete
  feature-loop examples. REJECTS:
  - Foundation / template / starter / scaffold / base / skeleton /
    boilerplate language without a concrete user-facing product.
  - Architecture-only listings (lists of surfaces, services,
    technologies) without saying what users *do*.

  Loops with a clarifying question until the answer is product-shaped
  ("users sign up, [verb] [object], and get [outcome]"). If the user
  insists they only want a foundation, the interview stops and reports
  back — `ai-starter` itself already plays that role.

- **`ai/templates/KICKOFF_EXISTING_PROJECT.md` Step 4 purpose
  question**: same logic applied when reading the existing README or
  asking the user. Existing architecture becomes supporting
  infrastructure under feature work, not the product itself.

- **`ai/templates/INIT_PROMPT.md` Step 2** (new) — application-
  description validation gate. Refuses to proceed past Step 2 if the
  description is foundation- or architecture-shaped. Loops with the
  user, or marks the task `Blocked` if no product can be articulated.
  Subsequent steps renumbered (Step 3 = tech stack ... Step 15 = env
  vars; total 15 steps, was 14).

- **`ai/templates/ADOPT_PROMPT.md` Step 3 `/ai/PROJECT.md` section**:
  validates the inferred application description before populating
  `PROJECT.md`. If the existing README is foundation/architecture-
  shaped AND the user can't articulate a real feature loop, the adopt
  stops and surfaces the gap rather than inventing features.

## 0.5.4 - 2026-05-10

Downstream-init hygiene pass — fixes patterns that caused
starter-template residue to leak into the first real project initialized
from this kit (`secure-app-template`).

- **`ai/DONE_LOG.md` ships empty.** Previously held the starter's own
  release notes, which downstream projects inherited verbatim. Now
  contains only a placeholder + a note explaining that the starter's
  own release history lives in `CHANGELOG.md` and git tags. Init seeds
  the first entry (P0-T1) per project.
- **INIT_PROMPT and ADOPT_PROMPT gain a new "replace starter-history
  files and remove starter-setup files" step** (INIT Step 12, ADOPT
  Step 6). It instructs the AI to:
  - Replace `CHANGELOG.md` (currently the starter's release log) with
    a fresh project changelog scaffolding. ADOPT detects existing
    project-specific content and leaves it alone.
  - Delete `ai/templates/KICKOFF_NEW_PROJECT.md`,
    `KICKOFF_EXISTING_PROJECT.md`, `INIT_PROMPT.md`, `ADOPT_PROMPT.md`,
    `README.template.md`, `SECURITY.template.md`,
    `CONTRIBUTING.template.md`, `ai/EXAMPLE_PROJECT.md`, and
    `ai/reference/PROMPT_LIBRARY.md` after their job is done.
  - Keep `REFRESH_PROMPT.md`, `TASK_TEMPLATE.md`, `INCIDENT_TEMPLATE.md`,
    `CHAT_END_PROMPT.md`, `CURRENT_STATE.template.md`, and
    `HANDOFF.template.md` (all useful post-init).
- **AI_RULES.md Planning-File Hygiene Rule: commit SHA is now optional
  in `DONE_LOG.md` entries.** Previously the rule said entries must
  include "key commit hash(es)", but the end-of-chat ritual writes
  entries *before* the commit, so the SHA isn't known yet — producing
  `commit: pending` placeholders that go stale. New rule: task ID and
  title are required; commit hash is recommended when already known but
  `git log --grep=<task-id>` recovers it. Never write
  `commit: pending`.
- **`ai/templates/TASK_TEMPLATE.md` heading levels fixed.** Subsections
  were `##` (H2), which jumped *above* the task title (`###`, H3) when
  rendered inside `TASKS.md`. Now `####` (H4), correctly nested.
- **`ai/templates/CONTRIBUTING.template.md` branching section** now
  explicitly lists all four AI-harness branch prefixes (`claude/`,
  `cursor/`, `codex/`, `copilot/`). Previously the AI improvised when
  generating downstream CONTRIBUTING.md.

## 0.5.3 - 2026-05-10

Team-review fixes — seven issues across P1/P2/P3 priorities resolved.

P1:
- **`run-phase-codex.sh`**: split shared `CODEX_FLAGS` into separate
  `CODEX_EXEC_FLAGS` (for `codex exec`) and `CODEX_RESUME_FLAGS` (for
  `codex exec resume --last`) since the two commands accept different
  flag sets. Dropped the hardcoded `--ask-for-approval never` (flag
  name varies by Codex version); replaced with an opt-in
  `RUN_PHASE_CODEX_APPROVAL_FLAG` env var so users can supply whatever
  their installed CLI accepts. Default flags are now just
  `--sandbox workspace-write`, the most universally supported.
- **`run-phase.sh`**: dropped hardcoded `--max-turns 100` (not
  supported in all Claude Code versions). Made it opt-in via
  `RUN_PHASE_CLAUDE_MAX_TURNS` env var; default is no turn cap.
- **`ai/TASKS.md` P0-T1**: expanded the live starter task to match
  `TASK_TEMPLATE.md` — added Prerequisites, Step-by-Step Instructions,
  concrete Verification, Security / Cost Considerations, Rollback /
  Recovery, Known Blockers, Handoff Notes. Resolves the embarrassment
  of the starter's own first task violating its own Hard rules.

P2:
- **`ai/EXAMPLE_PROJECT.md`**: replaced concrete future-dated versions
  (e.g. "TypeScript 5.7.2 verified 2026-05-12") with placeholder
  patterns (`<X.Y.Z>`, `<YYYY-MM-DD>`) and added a banner clarifying
  that all versions and dates are illustrative; real init verifies live
  from canonical sources. Stops users from copy-pasting stale pins.
- **`.gitattributes`** added: `* text=auto eol=lf` plus explicit
  `*.sh text eol=lf` and `*.md text eol=lf`. Prevents `core.autocrlf=true`
  on Windows from corrupting bash scripts.

P3:
- **`ai/HANDOFF.md`**: trimmed from 51 to 43 lines (under the ≤50
  target) and updated "Important Instructions for Next AI" to prefer
  the KICKOFF interview over direct `INIT_PROMPT.md`.
- **Release tags**: tagging `v0.5.2` retroactively at commit `f700530`
  and `v0.5.3` at this commit. Pushed alongside.

## 0.5.2 - 2026-05-10

Audit pass — drift cleanup found in a complete review:

- Deleted `ai/templates/CHAT_START_PROMPT.md`. Orphan file with zero
  inbound references and a stale conditional-context list (missing
  `SPEC.md`, `BUDGET.md`, `WORKFLOW.md`, `EXAMPLE_PROJECT.md`).
  Redundant with `/ai/START_HERE.md` plus the tool-native memory
  hooks.
- Updated `ai/templates/INIT_PROMPT.md` "sister documents" intro to
  list all three siblings (INIT, ADOPT, REFRESH); previously only
  mentioned INIT and REFRESH because it predated ADOPT.
- Removed stale `Do NOT modify /DEVELOPER-NOTES.md` line from
  `ai/templates/ADOPT_PROMPT.md`. `DEVELOPER-NOTES.md` was deleted
  back in v0.2.0; the reminder was harmless but obsolete.
- Added a "sister documents" intro to `ai/templates/REFRESH_PROMPT.md`
  matching the shape of INIT and ADOPT; routes users to ADOPT for
  in-place existing apps without `/ai/` and to INIT/KICKOFF for new
  projects.
- De-Tommyfied the free-tier examples in `ai/AI_RULES.md` Cost Rules
  (was "Postmark's 100/month, Cloudflare's free SSL"; now generic
  examples like email-API send caps, CDN bandwidth, DB row limits).

## 0.5.1 - 2026-05-10

- Closed first-mile UX gap: `/ai/START_HERE.md` Section 4 now routes
  users to the friendly `KICKOFF_*` interview prompts by default
  instead of `INIT_PROMPT.md` directly. The direct prompts are still
  available for users who explicitly opt out of the interview. This
  ensures users who never read the README still land in the foolproof
  entry path when an AI tool auto-loads `START_HERE.md` via a
  tool-native memory hook.

## 0.5.0 - 2026-05-10

First-mile UX: friendly interview prompts for new users plus a third
sibling actor for the brownfield retrofit case.

- Added `/ai/templates/KICKOFF_NEW_PROJECT.md` — paste-and-go interview
  prompt for greenfield projects. Asks one question at a time with
  examples and "I don't know — pick a sensible default" at every step,
  then generates a customized `INIT_PROMPT.md` invocation.
- Added `/ai/templates/KICKOFF_EXISTING_PROJECT.md` — interview prompt
  for adopting the kit into an existing app. Inspects the project
  first, then asks only what can't be inferred, then routes to either
  `ADOPT_PROMPT.md` (catch up) or `INIT_PROMPT.md` (start fresh).
- Added `/ai/templates/ADOPT_PROMPT.md` — third sibling alongside INIT
  and REFRESH. Reverse-engineers `/ai/` planning files from an
  existing project's manifests / lockfiles / configs / framework
  conventions. Backfills retroactive ADRs. Identifies gaps against
  the Hard rules and queues them as Phase-1 catch-up tasks. Does not
  modify application code.
- Updated `README.md` with a "First time? Pick your starting point"
  fork at the top — the `KICKOFF_*` prompts are now the foolproof
  entry point, with direct paths for confident users who want to skip
  the interview.

## 0.4.0 - 2026-05-10

Big "fill the gaps" pass: license + tool-native memory hooks + workflow
+ behavior spec + budget + worked example + four more (Hard) rule blocks.

- Added `LICENSE` (MIT). The starter itself is now MIT-licensed; downstream
  projects choose their own license at init time (recorded as an ADR).
- Added tool-native memory hook files at the repo root that all point at
  `/ai/START_HERE.md`, so modern AI tools auto-load the workflow:
  `CLAUDE.md`, `AGENTS.md`, `.cursorrules`, `GEMINI.md`, and
  `.github/copilot-instructions.md`.
- Added `.github/pull_request_template.md` covering verification, security,
  cost, and rollback checklists.
- Added `/ai/WORKFLOW.md` defining branching, PR workflow, hotfix flow,
  conflict resolution, and the blocked-escalation pattern.
- Added `/ai/SPEC.md` for concrete behavior — user flows, edge cases,
  performance budgets, accessibility targets, compliance.
- Added `/ai/BUDGET.md` for monthly cost cap, alert thresholds, free-tier
  tracking, and cost-impacting change log.
- Added `/ai/EXAMPLE_PROJECT.md` — worked reference example showing what
  a fully-initialized project looks like.
- Added templates `/ai/templates/README.template.md`,
  `SECURITY.template.md`, `CONTRIBUTING.template.md`, and
  `INCIDENT_TEMPLATE.md` for project root docs and post-mortems.
- Added four new (Hard) rule blocks to `/ai/AI_RULES.md`:
  - **Cost Rules** — monthly cap + alerts at init, ADRs for cost-impacting
    changes, monthly review, never trade security for cost.
  - **Destructive Operations Rules** — confirm before deleting >50 lines,
    force-push, dropping tables, terminating cloud resources, rotating
    secrets, removing deps, etc.
  - **Reasoning Checkpoint Rules** — plan-first for multi-step / multi-file
    work, surface mid-task changes, pre-flight before destructive steps.
  - **Blocked Escalation Rule** — formal Blocked status with explicit
    blocker writeup; never silently work around.
- Updated `/ai/AI_RULES.md` Task Quality Rules to require Cost
  Considerations, Known Blockers, and prerequisite-respect.
- Restructured `/ai/templates/INIT_PROMPT.md` into 13 steps (was 9) —
  added budget setup, license selection, SPEC population, file
  generation for README / SECURITY / CONTRIBUTING, and tool-native
  memory hook verification.
- Updated `/ai/templates/CHAT_END_PROMPT.md` to require a **self-critique**
  section: assumptions made, things skipped/deferred, next-session
  double-checks, unresolved risks.
- Updated `/ai/templates/TASK_TEMPLATE.md` with `Cost Considerations`
  and `Known Blockers` sections.
- Updated `/ai/templates/REFRESH_PROMPT.md` from 7 to 10 checks: now
  also verifies tool-native memory hooks, root-level docs (LICENSE /
  SECURITY / CONTRIBUTING), `/ai/WORKFLOW.md` / `SPEC.md` / `BUDGET.md`
  presence, and per-task Task Quality compliance.
- Updated `/ai/START_HERE.md` to surface tool-native memory hooks in the
  header, list the new conditional-context files (`SPEC.md`, `BUDGET.md`,
  `WORKFLOW.md`, `EXAMPLE_PROJECT.md`), and reference `INIT_PROMPT.md`
  for the full init flow.
- Updated `/ai/PROJECT.md` and `/ai/ARCHITECTURE.md` to reference
  `SPEC.md`, `BUDGET.md`, the new (Hard) rule blocks, and the License
  section.
- Updated `README.md` to document all new files, the MIT license, and
  the tool-native memory hooks.

## 0.3.0 - 2026-05-10

- Added four new (Hard) rule blocks to `ai/AI_RULES.md`:
  - **Versioning Rules** — pin from canonical sources, no pre-releases,
    each major choice gets an ADR with version + verification date.
  - **Security Rules** — secrets only in env / secret managers, TLS only,
    battle-tested auth, argon2id passwords, deny-by-default authz, schema
    validation, redacted logging, dep scanning + SAST in CI, OIDC
    federation for cloud principals.
  - **Infrastructure & Hosting Rules** — AWS / Azure / Google Cloud only,
    Terraform (or OpenTofu) for all cloud resources, encrypted remote
    state, cloud-managed stateful services in QA + Production, container
    runtime for local dev only.
  - **Task Quality Rules** — every task has explicit Prerequisites,
    ordered steps when sequence matters, a Verification section, and
    Rollback / Recovery notes.
- Expanded `ai/templates/TASK_TEMPLATE.md` with Prerequisites,
  Step-by-Step Instructions, Verification, and Rollback / Recovery
  sections.
- Expanded `ai/templates/INIT_PROMPT.md` to nine steps, adding explicit
  version verification, infrastructure choices (cloud, IaC, state
  backend, managed services), the security baseline, and detailed
  ordered Phase-1 tasks.
- Expanded `ai/ARCHITECTURE.md` Security Model section with concrete
  prompts and added a new Infrastructure & Hosting section.
- Expanded `ai/PROJECT.md` with Security Baseline and Infrastructure
  sections that point at the corresponding ADRs.

## 0.2.0 - 2026-05-10

- Removed all opinionated defaults (tech stack, OS, hosting provider, CI
  system, third-party services, package manager). The starter is now stack-
  and platform-agnostic.
- Generalized planning files, templates, and prompts to apply to any
  software development project.
- Replaced pre-populated stack-specific ADRs with a single ADR template;
  project-specific ADRs are added during initialization.

## 0.1.0 - 2026-05-04

- Documented the starter/template status in `README.md`.
- Added root ignore rules for generated `ai/logs/` phase-run output.
- Added the first starter changelog/version marker.
- Added a bootstrap checklist to the project initialization prompt.
- Changed startup context loading to a Fast Context core plus Conditional
  Context docs.
