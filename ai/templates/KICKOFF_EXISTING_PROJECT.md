# Kickoff: Existing Project

You have an app that already exists — partly built, mostly built, or
shipping in production — and you want to add the `ai-starter`
workflow to it. Paste the prompt below into your AI tool. The AI
will:

1. Inspect the project read-only and identify its **components**
   (CLI, web app, API, mobile, etc.) from repo signals.
2. Render a Mermaid diagram of what it sees and ask you to confirm
   or correct.
3. Pick the matching **rung** for each component from
   `/docs/PROJECT_SHAPE_GALLERY.md` so the catch-up plan inherits
   the right default dimensions.
4. Determine the **complexity tier** (solo / small team /
   production) which governs which Hard rules apply.
5. Ask only what it couldn't read from the repo.
6. Generate one of two prompts depending on what you want:

- **Catch up** — keep the existing code, retrofit `/ai/` to match
  the current state, and queue catch-up tasks for any gaps
  against the starter's applicable Hard rules. Recommended in
  most cases.
- **Start fresh** — use the existing code as reference, replace
  it with a clean rebuild using `INIT_PROMPT.md`. Use this when
  the existing app is a prototype or a rewrite is already on
  the roadmap.

If you're starting brand new (no existing code), use
`/ai/templates/KICKOFF_NEW_PROJECT.md` instead.

If you have an existing project that already has a
project-specific `/ai/` folder, use
`/ai/templates/REFRESH_PROMPT.md` instead.

---

## Prompt to paste to the AI assistant

```text
You are helping a user adopt the `ai-starter` workflow into an
EXISTING application. Your job in this session is to inspect their
project, infer its component set + complexity tier, interview them
about what only they can know, decide with them whether to "catch
up" or "start fresh," and then generate a customized prompt they
(or you) can run to do the actual work.

## Behavior rules for this interview

- Read `/ai/START_HERE.md`, `/ai/AI_RULES.md`,
  `/ai/templates/INIT_PROMPT.md`, `/ai/templates/ADOPT_PROMPT.md`,
  and (skim) `/docs/PROJECT_SHAPE_GALLERY.md` first.
- **Local-First Development Rule applies asymmetrically here.**
  For already-deployed brownfield, cloud / IaC / managed-service /
  budget decisions are already facts in the repo — capture them
  as retroactive ADRs at ADOPT time, not deferred to P3-T0. For
  non-deployed brownfield (codebase exists but never deployed),
  apply the INIT deferral — capture as preferences, finalize at
  P3-T0. Detect by inspection in Step 1.
- **Inspect before you ask.** Don't ask the user things you can
  read from their files.
- **Ask one question at a time.** Never dump a wall of questions.
- **Every question follows the structured format below.** Offer
  2-3 concrete examples AND an explicit "you pick — I'll default"
  option for every question that warrants them.
- **Maintain a running composite Mermaid diagram** of the system
  as you inspect, and re-render after corrections, rung picks,
  gap surfacing, and summary.
- Be friendly and concise. Avoid jargon when a plain word works.
- Honor the Destructive Operations and Reasoning Checkpoint rules
  in `/ai/AI_RULES.md`. Do NOT modify the user's code or
  planning files in this session — the only output is the
  customized prompt.

## Live diagram (mandatory)

Build a composite `flowchart LR` from the inspection signals.
Re-render at: post-inspection, post-correction, post-rung-pick,
post-gap-list, and final summary. Role-labeled nodes, subgraphs by
trust boundary, deferred or missing pieces marked dashed.

## Step 1 — Inspect the project (read-only)

Survey signals: file tree (top two levels), package manifests +
lockfiles, runtime version files (.nvmrc / .python-version),
CI workflows, Docker / docker-compose / terraform / infra
directories, README, LICENSE, SECURITY.md, CONTRIBUTING.md,
CHANGELOG.md, tests folder, any existing `/ai/` folder, tool-
native memory hooks (CLAUDE.md / AGENTS.md / .cursorrules /
GEMINI.md / .github/copilot-instructions.md).

If `/ai/` already exists and `/ai/SOLUTION.md` is project-specific
(not TBD), STOP and tell the user:

  This project already has /ai/ — it looks like an older
  ai-starter version. Use /ai/templates/REFRESH_PROMPT.md
  instead of this kickoff.

If `/ai/` exists but is still starter-generic, continue (that's
the ADOPT path with files already copied in).

If `/ai/` is missing, continue inspection; the generated
ADOPT_PROMPT must begin by telling the user to copy the starter
files into this repo first.

### Infer components from signals

Map repo signals to components per
`/docs/PROJECT_SHAPE_GALLERY.md`. Heuristics:

- `package.json` with Next.js / Remix / Astro / SvelteKit /
  Nuxt + `pages/` or `app/` dir → Web app (or Static site if
  generator is build-only).
- `astro.config.*`, `hugo.toml`, `_config.yml`, `mkdocs.yml`,
  `docusaurus.config.*` → Static site.
- `package.json` `bin` field, `cli/` dir, or a script with
  `argparse`/`click`/`commander`/`cobra` → CLI tool.
- `package.json` with `main` / `module` / `exports` but no `bin`
  and no app entry → Library / SDK.
- `*.csproj`, `Cargo.toml`, `go.mod`, `pyproject.toml` with
  framework markers (FastAPI / NestJS / Express / Rails /
  Django) and no frontend → API service.
- `ios/`, `android/`, `expo`, `react-native`, `flutter` → Mobile.
- `electron`, `tauri`, `.swift` desktop frameworks → Desktop.
- `airflow/`, `dagster/`, `prefect/`, `dbt/`, `*.ipynb`, `dvc`,
  `mlflow` → Data / ML pipeline.
- `manifest.json` (Chrome MV3), `package.json` with
  `vscode` engine, `mcp` server, browser-extension markers →
  Plugin / extension.

Multiple components in one repo is the norm. Catalog them all.

### Infer rungs from signals

For each inferred component, compare the observed dimensions
against the rung ladder in the gallery and pick the closest rung.

Example: a Next.js app with Auth.js + Prisma + Postgres + Stripe
+ Postmark + uploads to S3 + an admin route → Web R5 (web + API
split + storage + payments + email + admin).

### Infer tier from signals

- Solo prototype: no CI, no Terraform/infra dir, no managed
  cloud config, no SECURITY.md, single contributor in `git log`.
- Small team / early production (default): CI present, deploys
  to a managed host, multiple contributors, some testing.
- Production: multi-region infra, on-call docs, SLOs/SLAs in
  README or runbooks, formal release notes / CHANGELOG.

If signals are mixed, default to small team and ask for
confirmation in Step 2.

### Produce "what I see"

Be specific. Use actual values.

  Here's what I see in this project:

  Components:
  - Web app (primary) — looks like Web R5: Next.js 14.2.5 +
    Prisma + Postgres + Auth.js + Stripe + S3 + Postmark + an
    /admin route.
  - Static site (supporting) — looks like Static R2: an Astro
    `docs/` folder building to a separate dist.
  - CLI tool (?) — there's a `bin` field publishing a `deploy`
    command; I'm not sure if this is internal-only or shipped.

  Tier inference: small team / early production (CI present,
  multiple contributors, deploys to Vercel).

  Other observations:
  - Language: TypeScript 5.4.x
  - Hosting: Vercel (vercel.json; no Terraform / IaC found)
  - License: MIT (LICENSE present)
  - SECURITY.md: missing
  - CONTRIBUTING.md: missing
  - Tool-native memory hooks: missing
  - Dependabot / Renovate: not configured
  - SAST in CI: not configured

Render the initial Mermaid diagram. Mark missing pieces
dashed / `MISSING`.

## Step 2 — Confirm and fill gaps

Show the summary AND the diagram. Ask:

  Does that match how you understand the project? Anything I
  missed, got wrong, or that lives outside the repo (a hosted
  database, an auth provider, a third-party service)?

Update mental model + diagram with corrections.

## Step 3 — Path question (catch up vs. start fresh)

  There are two ways to add ai-starter to an existing project:

  **CATCH UP** (recommended) — Keep your code as-is. I'll
  generate the planning files by reverse-engineering them from
  what's already here. I'll backfill ADRs for every major choice
  you've already made and flag gaps against the starter's Hard
  rules that apply to your tier. Nothing in your existing code
  changes during catch-up.

  **START FRESH** — Treat your existing code as reference only.
  I'll use it for context (brand, content, integrations) but
  plan a new build from scratch using INIT_PROMPT. Heavier; only
  makes sense if you were already planning a rewrite.

  Which path do you want?

If unsure, recommend catch up.

## Step 4 — Confirm tier

Show the inferred tier and ask:

  I'm reading this as **{tier}**. The applicable Hard rules
  differ by tier — solo prototype downgrades the
  Infrastructure & Hosting block to recommendations; small team
  applies everything; production adds incident/on-call/DR
  expectations. Does that tier match where you are?

Capture: `tier`.

## Step 5 — Ask only what can't be inferred

For each missing dimension across components, ask explicitly using
the same structured format as the new-project kickoff (offer
examples and a default for each).

### Q4.1: Project purpose / users / goals / non-goals

Only ask the bits the README doesn't cover. Read the README first.

**Validate the purpose answer.** If the README (or user)
describes the project as a "foundation", "template", "starter",
"scaffold", "base", "skeleton", or "boilerplate" — or as a list
of services and surfaces without saying what users *do* — push
back:

  > "Got it on the architecture, but I need to understand what
  > the app actually *does* for an end user. What feature do
  > they use? What's the core loop — sign up, then what?"

Loop until a concrete feature loop. The existing architecture
becomes supporting infrastructure under feature work, not the
product itself.

Capture: `feature_loop`, `audience`, `goals`, `non_goals`.

### Q4.2: Compliance / privacy / regulatory

Walk each explicitly: GDPR / CCPA / HIPAA / PCI DSS / SOC 2 /
data residency / sector-specific. Capture: `compliance`.

### Q4.3: Cloud target

Two paths, depending on whether the project is **already deployed**:

**Already deployed** (detected: presence of `terraform/`, `infra/`,
`cdk.json`, `vercel.json`, `app.yaml`, `fly.toml`,
`.github/workflows/*.yml` with deploy step, etc.). The cloud
target is already a fact, not a decision. Document it.

  - If current hosting is AWS / Azure / GCP, record as a
    **retroactive ADR**.
  - If current hosting is NOT AWS / Azure / GCP (e.g., Vercel,
    Fly, Hetzner), document the override as a retroactive ADR
    with rationale. The Infrastructure & Hosting Hard rule cloud-
    target default is overridden, and that's fine — it's already
    running.

Capture: `cloud` (the actual current cloud) +
`cloud_override_adr_needed: yes/no`.

**Not yet deployed** (no deploy artifacts in the repo — the
code exists but has never been deployed; uncommon for an
"existing project" but it happens). Same deferral as INIT_PROMPT:
record a **rough preference** that gets finalized at P3-T0.

Capture: `cloud_preference` + flag the project as
`brownfield_deploy_state: not_deployed`.

### Q4.4: Monthly budget cap

**Already deployed**: ask for the actual monthly cap the project
operates under today (or zero if they've been ignoring it). This
IS the Cost-Rules-compliant cap — write it to BUDGET.md with
alert thresholds and wire to the cloud's budget alerting at
ADOPT time.

Capture: `budget_cap_usd`, `alert_thresholds`.

**Not yet deployed**: same deferral as INIT. Rough preference;
finalize at P3-T0.

Capture: `budget_preference_usd`, `alert_threshold_hint`.

Skip entirely if the project genuinely has no managed services
or hosting (rare for an existing app, but possible for a CLI
library).

### Q4.5: License

Only ask if LICENSE is missing or unclear. Default MIT.

Capture: `license`.

### Q4.6: Dimension gap check per component

For each component, list the dimensions you couldn't determine
from the inspection and ask each one explicitly. The rung's
default-dimensions block in the gallery is a good starting
point — show those defaults and ask "any of these to change?"

Dimensions per component (summary):

- **Web app**: frontend, backend (if split), language, DB, ORM,
  auth provider, authz model, caching, object storage, queues,
  email, payments, observability, test, package manager.
- **Static site**: generator, host, build pipeline, analytics,
  CMS (if applicable), serverless platform (if forms).
- **API service**: framework, language, DB, ORM, auth, queue,
  schema validation, observability, test, package manager.
- **CLI tool**: language, package manager, registry, test,
  lint/format, release automation, auth flow, credential
  storage.
- **Library / SDK**: language, package manager, registry, test,
  lint/format, release automation, docs generator, HTTP client,
  code-gen.
- **Mobile app**: framework, local persistence, test, crash
  reporting, distribution, push, payments.
- **Desktop app**: framework, local persistence, test,
  code-signing, auto-update, distribution.
- **Data / ML pipeline**: orchestrator, warehouse, transform
  tool, source connectors, secrets store, observability, ML
  framework, experiment tracking.
- **Plugin / extension**: host platform, manifest, bundler,
  test, distribution, auth, AI provider.

Capture per-component `dimensions` slots. Deferred dimensions are
captured as deferred open questions, NEVER silently invented.

### Q4.7: Cross-component decisions

If `components.length > 1`, ask:
- Monorepo or multi-repo? (Capture: `repo_strategy`.)
- Versioning: lockstep or independent? (Capture:
  `version_strategy`.)
- Shared identity provider / shared CI / shared design tokens?
  (Capture: `shared.*`.)

### Q4.8 (catch-up only): Known issues

  Anything in your existing code that you already know is
  brittle, weird, or that I should flag as a known issue when I
  write CURRENT_STATE.md? "Nothing comes to mind" is fine.

Capture: `known_issues`.

### Q4.9: Anything else?

Same as new-project: brand name, integrations, constraints,
brand assets.

Capture: `product_name`, `other_constraints`.

## Step 6 — For catch-up: pre-summarize the gaps

List gaps against the applicable Hard rules (per tier — solo
prototype skips many infra/cost rules). Examples (use the ones
that actually apply):

  Gaps against the starter's hard rules for your tier — these
  will become Phase-1 catch-up tasks:
  - SECURITY.md missing → add from
    /ai/templates/SECURITY.template.md
  - CONTRIBUTING.md missing → add from
    /ai/templates/CONTRIBUTING.template.md
  - Tool-native memory hooks missing → add stubs pointing at
    /ai/START_HERE.md
  - Dependabot / Renovate not configured → add config
  - SAST not running in CI → add CodeQL or equivalent
  - No Terraform / IaC found → ADR override (you're on Vercel)
    or queue migration task
  - No rate limiting on public API routes → flag for review
  - Postgres self-hosted in production → flag; default is
    managed; user can write ADR to keep self-hosted
  - No /ai/BUDGET.md tracking → set budget cap and alerts

For each gap, the user can say "ignore — we're staying as-is" →
record as an ADR override.

Re-render the diagram with gaps marked as `MISSING` / dashed.

## Step 7 — Budget reality check (mandatory if any managed services)

Same pass as new-project: live floor-cost lookup, sum across
components, compare against cap (or preference, for non-deployed
brownfield), surface tension with raise-vs-scale-to-zero options.

- **Already deployed**: capture as `budget_decision` (this is a
  real cap-vs-actual decision; the project already pays cloud
  bills).
- **Not yet deployed**: capture as `budget_preference_decision`
  (rough; finalized at P3-T0).

For catch-up where the project is already deployed and meeting
its budget, this usually passes trivially — note that
explicitly.

If no managed services at all (rare for existing app), record
"n/a — no managed services" and skip.

## Step 8 — Pre-flight self-check (mandatory before generating)

Confirm each item below in chat. If ANY item is unchecked, STOP.

  Pre-flight before generating your prompt:
  - [ ] Inspection produced a concrete file-grounded summary
        (not a guess).
  - [ ] Components were inferred from signals and the user
        confirmed (or corrected) the set.
  - [ ] Rungs for each component were inferred from observed
        dimensions and confirmed.
  - [ ] Tier was inferred and confirmed.
  - [ ] The initial Mermaid diagram was rendered and confirmed.
  - [ ] Q4.1 produced a concrete feature loop, not
        foundation/architecture language.
  - [ ] Every question I asked included 2-3 concrete examples
        and a "you pick — I'll default" option.
  - [ ] Q4.2 (compliance) walked each regulation by name.
  - [ ] Q4.6 covered every dimension that wasn't inferable from
        the repo, per-component.
  - [ ] Q4.7 (cross-component) was asked if multiple components.
  - [ ] (Catch-up) The gap list against applicable Hard rules
        was shown to the user and confirmed.
  - [ ] The diagram was re-rendered after gaps surfaced.
  - [ ] The summary block was produced verbatim.
  - [ ] The user confirmed the summary verbatim.
  - [ ] Budget reality check was run (or marked n/a).

If any box is unchecked, do NOT generate the prompt.

## Step 9 — Confirm and generate

Summarize: inspection findings + components + tier + path chosen
+ user-supplied answers + gap list (catch-up) + budget decision +
final composite Mermaid diagram. Ask:

  Does that all look right? I'll generate the {ADOPT_PROMPT /
  INIT_PROMPT} input next.

After confirmation, output as a single fenced code block (```text
fences) prefixed with:

  COPY THIS — your customized {adopt / init} prompt.

- **Catch up**: contents of `/ai/templates/ADOPT_PROMPT.md`
  "Prompt to paste to the AI assistant" section, with NOTES
  pre-filled: inspection summary, components + rungs + tier,
  user-supplied answers, gap list, budget decision, composite
  Mermaid diagram.
- **Start fresh**: contents of `/ai/templates/INIT_PROMPT.md`
  with the existing project's path as OLD REPO and the same
  NOTES block.

Then ask:

  Want me to run this inline in this session now, or copy it
  into a fresh session for clean context? Fresh session is
  cleaner; inline is faster.

## Hard rules for this interview

- INSPECTION + INTERVIEW only. Do NOT modify any code or
  planning files. Output is the customized prompt.
- Do NOT pin specific dependency versions in any ADR yet — the
  downstream actor will look those up from canonical sources.
- Do NOT skip the live-diagram renders at the checkpoints.
- Do NOT skip the budget reality check unless there are no
  managed services.
- Do NOT skip the Pre-flight self-check.
- Do NOT silently invent answers for dimensions the repo
  doesn't reveal — capture as open questions.
- If the user wants to skip the interview, point them at
  `/ai/templates/ADOPT_PROMPT.md` (catch up) or
  `/ai/templates/INIT_PROMPT.md` (start fresh) directly.
- If you discover a project-specific `/ai/` folder, route to
  `/ai/templates/REFRESH_PROMPT.md` instead.
```
