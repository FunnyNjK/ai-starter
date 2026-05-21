# Project Adopt Prompt

Use this prompt against an EXISTING project after the `ai-starter`
files have been copied into it, to retrofit the workflow on top of the
current code without changing how the app works. This is the
**catch-up** path.

If the project does not have `/ai/` yet, copy the starter files into it
first. If the project already has a project-specific `/ai/` folder from
an older starter version, use `REFRESH_PROMPT.md` instead.

This is the third sibling in the family:

- **INIT_PROMPT.md** — first-time setup of a new project (greenfield
  or migrate-from-old-repo).
- **ADOPT_PROMPT.md** (this file) — retrofit the freshly copied
  starter `/ai/` folder onto an in-place existing app; reverse-engineer
  the planning files.
- **REFRESH_PROMPT.md** — housekeeping pass on a project that already
  has `/ai/` from an older starter version.

The friendly entry point that asks the right questions and then
generates the customized version of this prompt is
`/ai/templates/KICKOFF_EXISTING_PROJECT.md`.

---

## Prompt to paste to the AI assistant

```text
You are running a project ADOPT pass against this repo. The application
already exists. Your job is to retrofit the `ai-starter` workflow into
it WITHOUT changing how the app works — only add `/ai/` planning files,
root-level docs (README / SECURITY / CONTRIBUTING / LICENSE) where
missing, tool-native memory hook files, and a Phase-1 catch-up task
list for any gaps against the starter's Hard rules.

INSPECTION SUMMARY (filled in by the kickoff interview, or by you on a
re-inspection):
{paste from KICKOFF_EXISTING_PROJECT.md output, or re-inspect now}

INHERITED FROM KICKOFF (v1.0.0+ NOTES block):
- feature_loop, audience, goals, non_goals
- tier: {solo prototype | small team | production}
- components: list of {name, primary/supporting, rung_id,
  dimension_defaults} per `/docs/PROJECT_SHAPE_GALLERY.md`
- compliance, license
- cloud_preference (rough, finalized at P3-T0 for non-deployed
  brownfield; replace with retroactive ADR for deployed
  brownfield documenting what's actually in the repo)
- budget_preference_usd, alert_threshold_hint (rough,
  finalized at P3-T0 for non-deployed brownfield; replace with
  Cost-Rules-compliant cap for deployed brownfield)
- repo_strategy, version_strategy, shared.* (if multiple
  components)
- budget_preference_decision
- Composite Mermaid system diagram

## Brownfield deploy state (read carefully)

Two ADOPT sub-paths, because the Local-First Development Rule
applies asymmetrically here:

**Deployed brownfield** — the project already runs in production
on real infrastructure. Cloud / IaC / managed-service / OIDC /
budget decisions have already been made *implicitly* by what's in
the repo. Treat ADOPT as a "document the existing state"
exercise: write retroactive ADRs for every existing deploy
choice, fill in BUDGET.md from real cloud invoices, and skip the
P3-T0 deferral entirely (there's nothing to plan — it's already
running). The Phase-4 implementation tasks (P4-T1..P4-T5+) do
NOT get queued; that work is already done.

**Non-deployed brownfield** — the codebase exists but has never
been deployed (rare; usually a half-built app that someone
adopted onto). Follow the INIT pattern: defer cloud / IaC /
managed-service / OIDC / budget-cap ADRs to a P3-T0 deploy-
planning task. Queue P3-T0 in Backlog the same way INIT does.

The kickoff interview asks which case applies. If the user
arrived at ADOPT_PROMPT.md directly without kickoff, detect by
inspection: presence of `terraform/`, `infra/`, `cdk.json`,
`vercel.json`, `app.yaml`, `fly.toml`, `.github/workflows/*.yml`
with a deploy step → deployed brownfield. Absence of any of
those → non-deployed brownfield.

If no NOTES block is present, the user is running ADOPT_PROMPT.md
directly without kickoff. Surface this and recommend
`/ai/templates/KICKOFF_EXISTING_PROJECT.md` first. If they insist
on proceeding, gather equivalent info inline (inspect + ask for
tier + propose components + per-component rung pick).

USER-SUPPLIED ANSWERS (already captured in NOTES if from kickoff):
- Project purpose / users / goals / non-goals: {fill in}
- Compliance / regulatory: {list or "none"}
- Cloud preference: {AWS / Azure / GCP / "keep current X with override ADR"}
- Monthly budget cap: ${N}/month
- License (if missing): {MIT / ...}
- Known issues / brittle areas to flag in CURRENT_STATE: {list or "none"}
- Other constraints: {list or "none"}

PRE-IDENTIFIED GAPS (from kickoff, if any):
{paste gap list, or generate one during Step 4 below}

## Bootstrap checklist

Before editing files, confirm:

- The project has the starter `/ai/` files available. If `/ai/` is
  missing, stop and ask the user to copy the starter into this repo
  before continuing.
- If `/ai/SOLUTION.md` is already project-specific (not starter-generic
  / TBD), stop and use REFRESH_PROMPT instead.
- If `/ai/SOLUTION.md` is still starter-generic (Project Name = TBD),
  continue with ADOPT.
- The user wants the catch-up path (preserve existing code; add
  workflow on top), not start-fresh (which goes through INIT_PROMPT).
- No real secrets are in your context (placeholders only).
- The user has authorized you to write the planning files (this is
  why ADOPT exists — they've consented).

## Step 1 — Read the starter's own files

Read `/ai/START_HERE.md`, `/ai/AI_RULES.md`, and the templates in
`/ai/templates/`. Honor every (Hard) rule block:

- Git, Planning-File Hygiene, Versioning, Security, Infrastructure &
  Hosting, Cost, Destructive Operations, Reasoning Checkpoint,
  **Local-First Development**, Blocked Escalation, Task Quality.

If the starter files aren't present in this repo (e.g., the user only
copied parts), STOP and tell them to copy the full starter first.

## Step 2 — Inspect the existing project (thoroughly, read-only)

Build a complete picture before writing anything. Read:

- File tree (recursive, but keep your summary at the top 2-3 levels
  unless something deeper is load-bearing).
- All package manifests + lockfiles. Identify language(s), runtime
  version(s), package manager, direct dependencies, dev dependencies.
- Runtime version files (`.nvmrc`, `.python-version`, `.tool-versions`,
  `runtime.txt`, etc.).
- CI configs (`.github/workflows/*.yml`, `.gitlab-ci.yml`,
  `azure-pipelines.yml`, etc.). Identify what runs and on what
  triggers.
- Hosting / IaC artifacts (`Dockerfile`, `docker-compose.yml`,
  `vercel.json`, `netlify.toml`, `fly.toml`, `app.yaml`, `serverless.yml`,
  `terraform/`, `infra/`, `cdk.json`, ARM / Bicep / CloudFormation
  files).
- Test configs and a sampling of test files (to gauge framework +
  rough coverage shape; don't read every spec).
- Existing root docs: README, LICENSE, SECURITY.md, CONTRIBUTING.md,
  CHANGELOG.md, CODE_OF_CONDUCT.md.
- Any existing tool-native memory hook files (CLAUDE.md, AGENTS.md,
  .cursorrules, GEMINI.md, .github/copilot-instructions.md). If they
  exist with non-stub content, preserve their wisdom (you may add a
  pointer to /ai/START_HERE.md but don't blow away project-specific
  notes).
- A handful of representative source files to confirm framework /
  pattern assumptions. Don't read the whole codebase.

## Step 3 — Reverse-engineer the planning files

Produce project-specific versions of every `/ai/*.md` file. Each one
should reflect the CURRENT state of the project, not an aspirational
state. Use the templates in `/ai/templates/` for shape.

### `/ai/SOLUTION.md`
- Name, application description, users, goals, non-goals — from the
  user's interview answers and the existing README.
- **Components** section: list each inferred component with its rung
  from `/docs/PROJECT_SHAPE_GALLERY.md`. Primary / supporting label
  for each.
- **Tier** section: the inherited (or inferred) tier.
- **Rules in force** section: which Hard rule blocks apply per the
  Rule Applicability section of `/ai/AI_RULES.md`. Note any ADR
  overrides (e.g., "Vercel hosting — ADR-XYZ overrides
  Infrastructure & Hosting Rules cloud target").
- **Validate the application description.** It must describe what end
  users *do* with the product — a concrete feature loop, not
  infrastructure or architecture.
  - REFUSE: "a foundation for X", "a template for Y", "a SaaS with
    marketing/web/API/worker", "an app using Clerk + Plaid + Postmark".
  - REQUIRE: "Users sign up, [verb] [object], and get [outcome]."
  - If the existing README is foundation/architecture-shaped AND the
    user can't articulate a real feature loop, stop and surface the
    gap. Do NOT invent product features. Mark the adopt task `Blocked`
    per the Blocked Escalation Rule and ask the user to clarify before
    continuing.
- **Tech Stack** section: list every choice you can confirm from
  manifests + lockfiles. Pin the exact installed version (lockfile is
  truth) and note the source of that fact (e.g., "TypeScript 5.4.3
  per `pnpm-lock.yaml`").
- **Security Baseline** section: link to ADRs you'll create in Step 4.
  For anything not yet implemented, mark `TBD (catch-up task P1-T?)`.
- **Infrastructure** section: same. Document what IS deployed today,
  not what should be.
- **License**: from the existing `LICENSE` file or the user's choice.
- **Repository Structure**: describe what's actually there.

### `/ai/ARCHITECTURE.md`
- System Overview — paste the composite Mermaid diagram from the
  kickoff NOTES block (or build one from inspection if missing).
- Major Components, Data Flow, External Services — inferred from
  the file structure, framework conventions, and config files
  (e.g., a Next.js App Router app has a known shape).
- Security Model, Infrastructure & Hosting — describe what IS
  configured now. Where the project doesn't yet meet the Hard rule
  baseline, write `TBD (catch-up task P1-T?)` and link to the task
  you'll queue.

### `/ai/SPEC.md`
- Core user flows — derive from existing routes / endpoints / pages.
- Edge cases / invariants / performance budgets / accessibility /
  compliance — mark `TBD — gap, ask the user`. SPEC is one of the
  most expensive files to backfill correctly without the user, so
  flag uncertainty honestly. Do NOT invent flows you can't see in
  the code.

### `/ai/DECISIONS.md`
- Backfill ADRs for every major choice currently in the code. Use this
  pattern:

    ## ADR-XXX: {Decision title}
    Date: {today}
    Status: Accepted (retroactive)

    ### Decision
    {What's currently in the project, e.g., "Next.js 14.2.5 as the
    framework."} Verified version on {today} from
    {canonical source URL}.

    ### Reason
    {The most plausible reason given the project shape; or "Existing
    project decision; rationale not documented in the original repo
    and reconstructed here for forward continuity."}

    ### Tradeoffs
    {Honest tradeoffs — same as a normal ADR.}

    ### Related Tasks
    {Phase-1 catch-up task IDs if relevant.}

  Number sequentially starting at ADR-001. Cover at minimum: language,
  framework, package manager, test runner, lint/format, database
  (if any), hosting target, CI system, license. Add ADRs for anything
  that materially shapes the project today.

- Where a current choice violates a Hard rule (e.g., self-hosted
  Postgres in production, Vercel hosting instead of AWS/Azure/GCP),
  write the ADR as **Status: Accepted (retroactive, override)** with
  a clear rationale, and queue a follow-up task to revisit if the
  user wants. Do NOT silently change the architecture in this pass.

### `/ai/DEPLOYMENT.md`
- Target environments, CI/CD, env vars, deployment commands, rollback
  — from the existing CI configs and hosting artifacts.

### `/ai/DEV_ENVIRONMENT.md`
- From any existing setup files (`README` quick-start, `Makefile`,
  `package.json` scripts, `Dockerfile.dev`, etc.).

### `/ai/TESTING.md`
- Test framework, current coverage shape, what runs in CI.

### `/ai/BUDGET.md`
- **Deployed brownfield**: Monthly cap from the user's answer
  (this IS the Cost-Rules-compliant cap, since the project is
  already running). "Major cost contributors" filled in from
  actual cloud invoices where possible; `TBD` for any the user
  needs to look up. Alert thresholds wired to the existing cloud's
  budget alerting.
- **Non-deployed brownfield**: Same deferral as INIT — capture
  the kickoff's rough preference under "Rough budget preference
  (revisit at P3-T0)" and free-tier ceilings under "Free-tier
  and tier choices". Do NOT write a Cost-Rules-compliant cap;
  that comes from P3-T0.

### `/ai/ROADMAP.md`
- Reflect the project's actual phase.
- **Deployed brownfield**: typically starts at Phase 5
  (Enhancements) for new work, with a Phase-1 "catch-up" inserted
  for the gap-filling tasks identified in Step 4. P3-T0 (deploy
  planning) is marked Done retroactively — the deploy ADRs were
  backfilled in Step 3 from existing state.
- **Non-deployed brownfield**: typical INIT phase ordering — start
  at Phase 1, queue P3-T0 in Backlog. Apply the Local-First
  Development Rule's Phase-1 ordering (scaffold → local green →
  CI mirrors) for any catch-up tasks that touch the build loop.

### `/ai/TASKS.md`
- Mark P0-T1 (Adopt) Done, with today's date.
- Queue Phase-1 catch-up tasks (one per gap from Step 4).
- Queue Phase-2+ tasks for any new feature work the user mentioned
  during the interview.

### `/ai/CURRENT_STATE.md`
- Use the template at `/ai/templates/CURRENT_STATE.template.md`.
- ≤ 80 lines. Honest about what exists, what works, what's broken,
  what's not yet built.
- Include "Known Problems" entries for any brittle / weird areas the
  user flagged during the interview.

### `/ai/HANDOFF.md`
- Use the template at `/ai/templates/HANDOFF.template.md`.
- ≤ 50 lines. Points the next session at the first catch-up task.

### `/ai/DONE_LOG.md`
- Add today's entry: "Adopted ai-starter onto existing project."
- List the planning files created.

## Step 4 — Identify and queue catch-up tasks

For every gap between the project's current state and the starter's
**applicable** Hard rules (per tier + component set + Rule
Applicability section of `/ai/AI_RULES.md`), queue a Phase-1
catch-up task using `/ai/templates/TASK_TEMPLATE.md`. Tag each task
with the component it belongs to (e.g., `[web]`, `[api]`,
`[shared]`) so multi-component projects can route ownership.

Solo prototype tier: skip cloud / IaC / SAST gap tasks if the user
explicitly defers them; record the deferral as an ADR with the
trigger that would re-open the tasks.

Common gaps:

- **Tool-native memory hooks missing** — add `CLAUDE.md`, `AGENTS.md`,
  `.cursorrules`, `GEMINI.md`, `.github/copilot-instructions.md`
  pointing at `/ai/START_HERE.md`. Trivial; can be a single task.
- **Root docs missing** — `LICENSE`, `SECURITY.md`, `CONTRIBUTING.md`
  from the templates in `/ai/templates/`. One task each, or bundled.
- **`.github/pull_request_template.md` missing** — copy from starter.
- **Dependency-update bot missing** — add Dependabot or Renovate.
- **SAST in CI missing** — add CodeQL (GitHub) or equivalent.
- **SCA / dependency vulnerability scanning missing** — add a tool
  like `npm audit --audit-level=high` in CI, or a dedicated SCA tool.
- **OIDC federation missing for cloud auth** — replace any static
  cloud keys in CI with workload identity / OIDC.
- **Terraform / IaC missing** — separate task to evaluate; flag as a
  large task that may need its own ADR conversation before scoping.
- **Stateful services self-hosted in production** — flag for review;
  may stay self-hosted with an override ADR or migrate to managed.
- **No rate limiting on public endpoints** — task to add.
- **No deny-by-default authz** — task to audit and tighten.
- **No PII redaction in logs** — task to add.
- **No CORS/CSP allowlists** — task to add and review.
- **Container images not pinned by digest / not scanned / running as
  root** — task per problem.
- **Monthly budget cap not configured in cloud console** — task to
  configure.
- **`SPEC.md` is `TBD` for most flows** — task per major flow to
  document properly.
- **No `Last Updated:` dates on existing docs** — minor, bundle into
  one task.

Each task gets the standard template fields: Prerequisites,
Step-by-Step Instructions (when ordering matters),
Acceptance Criteria, Verification, Test Requirements, Security
Considerations, Cost Considerations, Rollback / Recovery, Known
Blockers, Dev Environment Constraints, Handoff Notes.

Order them sensibly — e.g., add tool-native memory hooks before doing
heavy work (so the AI's memory file system is wired up); add Terraform
backend before any IaC migration; add SAST + dep scanning before
shipping new features.

## Step 5 — Add tool-native memory hooks (immediate)

The single thing it's safe to do right now (without violating the
"don't change the app" rule) is add the tool-native memory hook stub
files at the project root if they're missing:

- `CLAUDE.md`, `AGENTS.md`, `.cursorrules`, `GEMINI.md`,
  `.github/copilot-instructions.md`

Each is 2-3 lines: "Always read /ai/START_HERE.md first." This is
non-invasive (no behavior change) and means the next AI session
auto-loads the workflow. Skip files that already exist with
project-specific content.

## Step 6 — Replace starter-history files and remove starter-setup files

Same cleanup as INIT_PROMPT Step 12, with one nuance: in an
adopt-into-existing-app session, the project may already have its own
`CHANGELOG.md` and `DONE_LOG.md` with real content. Detect intent
before overwriting.

### `CHANGELOG.md` at the project root

- If the file is **missing** OR contains the `ai-starter` template's
  release header (starts with `Starter Version:`), replace with fresh
  project changelog scaffolding:

  ```markdown
  # Changelog

  Last Updated: <YYYY-MM-DD>

  ## Unreleased
  - ai-starter workflow adopted (P0-T1).
  ```

- If the file already has **project-specific** entries (existing
  release history, real Unreleased notes), leave it alone and add a
  new "ai-starter workflow adopted" line under the existing Unreleased
  section instead.

### `/ai/DONE_LOG.md`

- Should ship from the starter empty. If it has starter-release
  entries, clear them. Seed with this project's adopt entry.

### Remove starter-setup files

These exist to bootstrap *new* projects and have no use after adopt.
Delete:

- `ai/templates/KICKOFF_NEW_PROJECT.md`
- `ai/templates/KICKOFF_EXISTING_PROJECT.md`
- `ai/templates/INIT_PROMPT.md`
- `ai/templates/ADOPT_PROMPT.md` (you're inside this one — delete on
  the way out)
- `ai/templates/README.template.md`, `SECURITY.template.md`,
  `CONTRIBUTING.template.md` (only if the user *did* generate
  corresponding root docs from them in this session; otherwise leave
  for follow-up tasks to use)
- `ai/EXAMPLE_PROJECT.md`
- `ai/reference/PROMPT_LIBRARY.md` (optional)

Keep:

- `ai/templates/REFRESH_PROMPT.md`, `TASK_TEMPLATE.md`,
  `INCIDENT_TEMPLATE.md`, `CHAT_END_PROMPT.md`,
  `CURRENT_STATE.template.md`, `HANDOFF.template.md`.

## Step 7 — Self-critique + handoff

End the session per `/ai/templates/CHAT_END_PROMPT.md`. The
self-critique section is especially important here — list every
assumption you made when reverse-engineering ADRs, every TBD you
left in `SPEC.md`, every gap that's queued but unprioritized, and
anything you're uncertain about in the inspection.

## Hard rules

- Do NOT modify the existing application code in this pass — only
  `/ai/`, root docs, and tool-native memory hook stubs.
- Do NOT delete or rewrite any existing root doc (README, LICENSE,
  SECURITY.md, CONTRIBUTING.md) without user confirmation. If they
  exist, leave them alone or augment them gently.
- Do NOT silently fix Hard-rule violations — queue them as tasks for
  the user to prioritize.
- Do NOT pin dependency versions in ADRs from training-data
  knowledge. Verify every version against the lockfile or canonical
  source as of today.
- Honor Destructive Operations and Reasoning Checkpoint rules — for
  anything that feels risky, confirm before doing it.
- Push after every commit (Git Rules).

Begin with the Start-of-Chat summary (START_HERE.md section 5).
End with the End-of-Chat report (START_HERE.md section 6) including
the required self-critique section, and update CURRENT_STATE, TASKS,
HANDOFF, DONE_LOG to reflect the closed P0-T1 (Adopt).
```
