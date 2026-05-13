# Project Init Prompt

Use this prompt against a FRESH project that was just cloned from the
`ai-starter` template, to convert the generic starter files into
project-specific planning files.

This is one of three sibling actor prompts:

- **INIT_PROMPT.md** (this file) — first-time setup of a new project
  (P0-T1), greenfield or migrate-from-old-repo.
- **ADOPT_PROMPT.md** — retrofit `/ai/` onto an in-place existing app;
  reverse-engineer the planning files without changing app code.
- **REFRESH_PROMPT.md** — housekeeping pass on a project that already
  has `/ai/` from an older starter version.

For the friendly entry point that interviews the user and generates a
customized version of one of the above, see
`/ai/templates/KICKOFF_NEW_PROJECT.md` (greenfield) or
`/ai/templates/KICKOFF_EXISTING_PROJECT.md` (brownfield).

For a worked example of what the output looks like, see
`/ai/EXAMPLE_PROJECT.md`.

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
- If the user came from KICKOFF_NEW_PROJECT.md or
  KICKOFF_EXISTING_PROJECT.md, a NOTES block at the top of this prompt
  carries the captured answers and a starting Mermaid system diagram.
  Inherit both — do not re-interview the user on settled choices.

## Inherited from kickoff (read the NOTES block carefully)

The kickoff NOTES block, if present, carries:

- `feature_loop`, `audience`, `goals`, `non_goals`.
- `tier` — solo prototype / small team / production. Tier governs
  which `/ai/AI_RULES.md` Hard rule blocks apply (see the Rule
  Applicability section of AI_RULES).
- `components` — a list of 1–N components, each with a name (per
  `/docs/PROJECT_SHAPE_GALLERY.md`), a rung (e.g., "Web R5"), and
  a `dimension_defaults` map pre-filled from the rung.
- `compliance`, `cloud`, `budget_cap_usd`, `alert_thresholds`,
  `license`, `repo_strategy`, `version_strategy`, `shared.*`,
  `budget_decision`.
- A Mermaid composite system diagram.

If no NOTES block was provided, the user is running INIT_PROMPT.md
directly without kickoff. Surface this and recommend they run
`/ai/templates/KICKOFF_NEW_PROJECT.md` first unless they're sure
they want to skip the interview. If they insist on proceeding,
gather the equivalent info inline: feature loop, tier, component
list with rungs, then the rest of the kickoff answers.

## Live diagram during init (mandatory)

If the NOTES block from kickoff includes a Mermaid system diagram,
inherit it as the starting picture. Re-render the diagram (fenced as
```mermaid```) at the following checkpoints and show it to the user so
they can sanity-check the direction at each one:

- After Step 4 (infrastructure) — once the cloud subgraph, managed
  services, and IaC layout are concrete.
- After Step 5 (security baseline) — annotate the diagram with
  trust-boundary callouts (PII flows, payment flows, secret store
  reads).
- After Step 10 (SPEC) — confirm the diagram still matches the user
  flows in SPEC.
- Before declaring P0-T1 done — the final diagram is the picture the
  next phase inherits.

Rules: `flowchart LR`, subgraphs by trust boundary, annotate nodes
with the specific choice + version once verified, mark deferred or
open dimensions with a `TBD` suffix and dashed links, keep under ~25
nodes. The final diagram is committed to `/ai/ARCHITECTURE.md`
"System Overview" section.

## Step 1 — Read AI files

Read /ai/START_HERE.md first, then follow its Context Loading Strategy.
Because this is first-time initialization, load the full planning context
instead of only the Fast Context set.
Honor /ai/AI_RULES.md as non-negotiable. Pay particular attention to the
(Hard) blocks — Git, Planning-File Hygiene, Versioning, Security,
Infrastructure & Hosting, Cost, Destructive Operations, Reasoning
Checkpoint, Blocked Escalation, and Task Quality — because every step
below references them.

Glance at /ai/templates/ — HANDOFF.template.md, CURRENT_STATE.template.md,
and TASK_TEMPLATE.md are the target shapes for the files you'll write.
/ai/EXAMPLE_PROJECT.md shows what a fully-initialized project looks
like. /ai/WORKFLOW.md defines branching, PRs, hotfixes, and how
blockers are escalated. REFRESH_PROMPT.md is for existing repos; ignore
here.

## Step 2 — Validate the application description (gate before everything else)

Before choosing any tech stack or infrastructure, validate that the
user's application description (from the kickoff NOTES block, or from
the user's chat message) describes a *real product* — what end users
*do* — and not just infrastructure, architecture, or a reusable
foundation.

**Refuse to proceed past this step if the description**:

- Uses **foundation / template / starter / scaffold / base / skeleton
  / boilerplate** language without naming a concrete user-facing
  feature loop. Examples that should refuse: "a foundation for B2C
  SaaS apps", "a secure starter template", "a scaffold for future
  products".
- Is **architecture-only**: a list of surfaces, services, or
  technologies without saying what users *do*. Examples that should
  refuse: "a SaaS with marketing, web app, API, worker", "an Azure app
  with Clerk + Plaid + Postmark + Stripe", "a multi-tenant Next.js +
  Postgres stack".

When refused, ask the user (and loop until satisfied):

> "The description so far is more about infrastructure than product.
> This starter plans infrastructure as *supporting work for a real
> product*, not as the product itself. What does an end user actually
> *do* with this app — concrete feature loop, e.g. 'users sign up,
> then [verb] [object], and get [outcome]'?"

A valid answer looks like:

- "Users sign up, link bank accounts via Plaid, categorize
  transactions, set monthly budgets, and get alerts when over."
- "Team leads create projects, add tasks, assign teammates, set due
  dates, and move tasks across a kanban board."
- "Visitors read marketing pages, fill out a contact form, and I get
  an email."

If the user insists they only want a reusable foundation, point out
that `ai-starter` itself already plays that role (they can fork it for
each new project) and ask one more time for the actual product. If
they still cannot describe a product, **mark the task `Blocked` per
the Blocked Escalation Rule** and stop — don't manufacture features.

Once the description is product-shaped, proceed to Step 3. Every later
step assumes you know what users *do* with this app.

## Step 3 — Choose the tech stack and verify versions (per component)

For each component in the inherited `components` list, walk its
dimensions per `/docs/PROJECT_SHAPE_GALLERY.md`. The kickoff
pre-filled `dimension_defaults` from the picked rung; use those as
the starting point and only re-decide where they're marked
"decide at init" or where the user explicitly defers.

Components in the gallery (with their dimension sets) are:

- Web app — frontend, backend (if split), language, DB, ORM,
  auth provider, authz model, caching, object storage, queues,
  email, payments, observability, test, package manager.
- Static site — generator, host, build pipeline, analytics, CMS
  (if applicable), serverless platform (if forms).
- API service — framework, language, DB, ORM, auth, queue,
  schema validation, observability, test, package manager.
- CLI tool — language, package manager, registry/distribution,
  test, lint/format, release automation, auth flow (if backend),
  credential storage (if auth).
- Library / SDK — language, package manager, registry, test,
  lint/format, release automation, docs generator, HTTP client
  (if SDK), code-gen (if multi-language family).
- Mobile app — framework, local persistence, test, crash
  reporting, distribution, push (if backend), payments (if any).
- Desktop app — framework, local persistence, test, code-signing,
  auto-update, distribution.
- Data / ML pipeline — orchestrator, warehouse, transform tool,
  source connectors, secrets store, observability, ML framework
  (if ML), experiment tracking (if ML).
- Plugin / extension — host platform, manifest, bundler, test,
  distribution, auth (if R2+), AI provider (if R4).

For EACH chosen item across all components, look up the current
stable version from its canonical source (npm registry / PyPI /
Maven Central / NuGet / crates.io / pkg.go.dev / official runtime
site / Docker Hub for DB images, etc.).
Do NOT pin from training-data knowledge — versions move. No
pre-release / RC / beta / alpha / nightly versions.

Capture each major choice as an ADR in /ai/DECISIONS.md (numbered
ADR-001, ADR-002, ...) with: decision, the version, the date verified,
the canonical source URL, rationale, and trade-offs. Ask the user before
locking in choices that materially change the project's shape.

## Step 4 — Choose infrastructure and deployment

**Rule applicability by tier.** Per `/ai/AI_RULES.md` Rule
Applicability:

- **Solo prototype**: Infrastructure & Hosting Hard rules are
  recommendations until tier changes. The user may legitimately
  run everything locally with containers. Still record decisions
  as ADRs.
- **Small team / early production** (default): all Infrastructure
  & Hosting Hard rules apply as written.
- **Production / enterprise**: all rules apply, plus multi-region
  / DR planning + on-call rotation documentation.

Skip this step entirely if NO component in the project requires
hosting (e.g., a CLI library that publishes to a package registry
and has no backend, a standalone desktop app). In that case,
record an ADR noting that Infrastructure & Hosting rules don't
apply for v1 because the project has no hosted surfaces.

Per the Infrastructure & Hosting Rules in AI_RULES.md (when they
apply):

- **Cloud target**: AWS, Azure, or Google Cloud — record the choice as an
  ADR with the rationale.
- **IaC**: Terraform (or OpenTofu) for all cloud resources — record an
  ADR with the version verified from the Terraform registry.
- **Terraform state backend**: encrypted remote backend with locking —
  record an ADR with the chosen storage + lock mechanism for the cloud
  (S3+DynamoDB / Azure Storage + blob lease / GCS native locking).
- **Stateful services in QA and Production**: use the cloud's managed
  offering for every database, cache, queue, search engine, and object
  store the project depends on. Record each as an ADR with the chosen
  service, the engine version, and the source URL.
- **Local development**: containerize stateful deps (Docker Compose /
  Podman / OrbStack / Lima — pick one) so contributors get a one-command
  setup. Match the major version of each container to the managed
  service version pinned for production. Record this in
  /ai/DEV_ENVIRONMENT.md.
- **CI/CD auth to the cloud**: OIDC federation. No long-lived static
  cloud keys.
- **Runtime secrets**: a cloud-managed secret store (Secrets Manager /
  Key Vault / Secret Manager). Document where each secret will live in
  /ai/DEPLOYMENT.md.

If any of the above defaults need to be overridden for this project,
write an ADR explaining why. Do not silently deviate.

## Step 5 — Choose the security baseline

Per the Security Rules in AI_RULES.md, decide and record as ADRs:

- Auth library or auth provider for end users (if the project has them).
- Password hashing algorithm (default: argon2id) and the library that
  provides it.
- Schema-validation library for request payloads.
- CORS / CSP defaults.
- Rate-limiting strategy and library / service.
- Dependency-update automation (Dependabot / Renovate).
- SAST tool(s) appropriate to the language(s).
- SCA tool / source for CVE feeds.
- Logging library and the redaction strategy for PII / secrets.
- Container image base (if containers are used) and the CVE scanner that
  will run in CI.

Record each as an ADR. The project's `/ai/PROJECT.md` should point at
these ADRs in its "Security Baseline" section.

## Step 6 — Set the budget and cost guardrails

Per the Cost Rules in AI_RULES.md:

- Ask the user for a monthly budget cap in USD (overall, or per
  environment) and record it in /ai/BUDGET.md.
- Choose alert thresholds (50% / 80% / 100%, or as the user specifies)
  and the notification channel — record both in /ai/BUDGET.md.
- For each managed service chosen in Step 4, record the tier (free /
  shared / dedicated / scale-to-zero), any free-tier limits being
  relied on, and the escalation path when limits are exceeded.
- Pre-populate /ai/BUDGET.md "Major cost contributors" with estimated
  monthly cost for the major resources from Step 4.

## Step 7 — Choose a license

Ask the user what license the project ships under. Defaults to
recommend, in rough order of permissiveness:

- **MIT** — the standard "use however you want, keep the copyright
  notice" choice. Recognized by GitHub, npm, PyPI, etc.
- **Apache 2.0** — like MIT plus an explicit patent grant. Use when
  patents matter.
- **The Unlicense / CC0** — public-domain dedication. No attribution
  required.
- **BSL / proprietary** — when the project is closed-source or
  source-available with restrictions.

Write the chosen license text to `LICENSE` at the project root and
record the choice as an ADR. Reference the license from `README.md`
and `CONTRIBUTING.md`.

## Step 8 — Inspect the old repo (read-only, skip if greenfield)

Treat it as read-only. Never modify it. Catalog: pages or modules,
content, copy, assets, brand (colors/fonts), navigation, integrations,
features to drop, opportunities to improve.

## Step 9 — Decide a design / migration direction

If migrating from an old repo, decide with the user whether to:

- **Preserve** — keep the old design and behavior as faithfully as
  possible while only re-implementing on a new stack.
- **Evolve** — preserve identity (brand, content, information
  architecture) but modernize implementation, conventions, accessibility,
  and performance.
- **Rebuild** — treat the old repo as reference only, not a constraint
  on the new design.

Document the chosen direction (and any notable evolution choices) as
ADRs.

## Step 10 — Fill in /ai/SPEC.md

For non-trivial projects (anything beyond a CRUD demo), populate
/ai/SPEC.md with:

- Core user flows (trigger, pre-conditions, happy path, failure modes,
  authorization).
- Edge cases and invariants.
- Performance budgets.
- Accessibility targets (WCAG conformance level).
- Browser / device / runtime support.
- Compliance / privacy / data-handling requirements (GDPR, CCPA,
  HIPAA, etc., if any).

This is the file Phase-2 task acceptance criteria are built from. If
it's vague, the AI will write vague feature tasks.

## Step 11 — Update planning files and queue tasks

Make all /ai/*.md files project-specific. Mark P0-T1 done in TASKS.md
and DONE_LOG.md.

Queue Phase-1 tasks. Phase 1 task content depends on (a) the
component set and (b) the tier. Use the rubric below — only
include tasks that actually apply to a component this project
contains and the tier this project runs at.

**Always (regardless of components/tier):**
1. Scaffold the project layout (language, framework, lint/format,
   test runner, `.gitignore`, `.env.example` if applicable,
   project README from `/ai/templates/README.template.md`).
   For multi-component projects: scaffold the workspace structure
   (monorepo or multi-repo) per `repo_strategy`.
2. Add CI workflows for each component: lint, type-check if
   applicable, tests, build, and real language-specific security
   scanning. Use `/ai/templates/ci-security.template.yml` only as
   a guardrail scaffold; replace/extend with chosen SAST/SCA
   tools.
3. Dependency-update automation (Dependabot / Renovate).
4. Write SECURITY.md and CONTRIBUTING.md at the project root.

**If any component requires hosting** (web, API, mobile-backend,
plugin-backend, data pipeline that runs in cloud):
5. Set up IaC state backend bootstrap (Terraform encrypted state
   bucket / container / lock table). Documented as a runbook.
6. Cloud OIDC trust for CI (federated identity → repo, scoped to
   `main` and PR refs).
7. First IaC apply: minimal account / project / subscription
   scaffold (resource group / project, networking, secret store,
   log destination, IAM baseline).
8. First production deployment of a placeholder app to prove the
   pipeline works end-to-end.
9. Wire cloud budget + alerts per `/ai/BUDGET.md`.

**Per-component additions:**
- **Library / SDK component**: package-registry publishing
  setup, release automation (changesets / release-please /
  semantic-release / cargo publish workflow).
- **CLI component**: distribution channel setup (npm bin
  publish, Homebrew formula scaffold, GitHub Releases binary
  matrix), version-bump workflow.
- **Mobile component**: code-signing setup (Apple / Google),
  store-listing scaffolds, beta-distribution channel (TestFlight
  / Play Internal Testing).
- **Desktop component**: code-signing + notarization, auto-update
  feed scaffold.
- **Plugin / extension component**: manifest scaffold for the
  target host, store-listing draft (Chrome Web Store / VS Code
  Marketplace).
- **Data pipeline component**: orchestrator scaffold (Airflow /
  Dagster / Prefect), warehouse connection, first DAG/asset that
  runs a noop transform end-to-end.

**Tier-conditional additions:**
- **Solo prototype**: skip tasks 5-9 if user explicitly declares
  no cloud yet. Add ADR noting the deferral and the trigger that
  flips the project to small-team tier.
- **Production**: add on-call rotation setup, SLO/SLI definition
  task, disaster-recovery runbook, multi-region/replica plan,
  incident template integration with `/ai/templates/INCIDENT_TEMPLATE.md`.

Queue Phase 2 tasks for the actual feature work — one per major page,
screen, module, or service from PROJECT.md and (if applicable) the
migration inventory. Use /ai/SPEC.md as the source of truth for
acceptance criteria. Add improvement-list tasks too.

EVERY task must follow `/ai/templates/TASK_TEMPLATE.md` and satisfy the
Task Quality Rules in AI_RULES.md:

- `Prerequisites: <task IDs>` is present (use `none` if empty).
- When ordering matters, the task body lists steps in the required
  order, each with its expected output / state.
- A `Verification` section is present with concrete checks.
- A `Rollback / Recovery` section is present (or `not applicable`).

CURRENT_STATE.md ≤ 80 lines. HANDOFF.md ≤ 50 lines. Use the templates
in /ai/templates/. Add `Last Updated: YYYY-MM-DD` (today's UTC date) to
the top of every planning file you touch.

## Step 12 — Tool-native memory hooks

The starter ships with these AI-tool-recognized files at the project
root pointing at `/ai/START_HERE.md`:

- `CLAUDE.md` (Claude Code)
- `AGENTS.md` (Codex CLI and several other agentic tools)
- `.cursorrules` (Cursor)
- `.github/copilot-instructions.md` (GitHub Copilot)
- `GEMINI.md` (Gemini CLI)

Verify these are present in the new project. If a tool the user uses
has a different memory-file convention, add a one-line stub for it
that says "Always read /ai/START_HERE.md first."

## Step 13 — Replace starter-history files and remove starter-setup files

The starter ships with files that exist to bootstrap *new* projects and
files that track the *starter's own* history. After P0-T1, both
categories must be replaced or removed so downstream projects don't
inherit the wrong content.

### Replace starter-history files

- **`CHANGELOG.md`** — currently contains the `ai-starter` template's
  own release history (header starts with `Starter Version:`). Overwrite
  with a fresh project changelog scaffolding:

  ```markdown
  # Changelog

  Last Updated: <YYYY-MM-DD>

  ## Unreleased
  - Project planning initialized (P0-T1).
  ```

  Downstream projects add real entries as they cut their own releases.

- **`/ai/DONE_LOG.md`** — should already be empty in a recent starter,
  but if it contains starter-release entries, clear them and seed only
  the P0-T1 entry for this project.

### Remove starter-setup files

These exist to run *this very init session* and have no use afterward.
Delete them:

- `ai/templates/KICKOFF_NEW_PROJECT.md`
- `ai/templates/KICKOFF_EXISTING_PROJECT.md`
- `ai/templates/INIT_PROMPT.md` (you're inside this one — delete on the
  way out)
- `ai/templates/ADOPT_PROMPT.md`
- `ai/templates/README.template.md` (already used to generate `README.md`)
- `ai/templates/SECURITY.template.md` (already used)
- `ai/templates/CONTRIBUTING.template.md` (already used)
- `ai/EXAMPLE_PROJECT.md` (illustrative reference for un-initialized
  projects)
- `ai/reference/PROMPT_LIBRARY.md` (general AI prompt patterns;
  optional)
- The whole `ai/reference/` directory if it ends up empty.

Keep:

- `ai/templates/REFRESH_PROMPT.md` (future starter upgrades)
- `ai/templates/TASK_TEMPLATE.md` (new tasks)
- `ai/templates/INCIDENT_TEMPLATE.md` (post-mortems)
- `ai/templates/CHAT_END_PROMPT.md` (used at end of every session)
- `ai/templates/CURRENT_STATE.template.md`,
  `ai/templates/HANDOFF.template.md` (refresh-pass shape)

If the user has a specific reason to keep any of the deleted files,
honor that — but the default is to delete.

## Step 14 — Create /ai/MIGRATION_INVENTORY.md (skip if greenfield)

- Page / module mapping (old → new → status)
- Asset mapping (old path → new path)
- Content mapping (section → source in old repo → notes)
- Drop list (with reasons)
- Improvement list (each linked to a TASKS.md entry)

## Step 15 — Environment variables

Identify every env var the new project will need. Document them in
/ai/DEPLOYMENT.md "Required Environment Variables", with which secret
store will hold them in QA and Production. The actual local env file
(or equivalent) with placeholders gets created during scaffold (P1-T1),
not now.

## Pre-flight self-check (mandatory before declaring P0-T1 done)

Before marking P0-T1 complete and writing the End-of-Chat report,
explicitly confirm each item below in chat. If ANY item is unchecked,
STOP and complete it before closing the task.

  Pre-flight before closing P0-T1:
  - [ ] /ai/PROJECT.md has no remaining TBD sections (open
        questions are explicitly flagged, not silently TBD).
  - [ ] /ai/PROJECT.md records the component set and tier
        explicitly (e.g., "Components: Web app (R5), API service
        (R3), Static site (R2). Tier: small team.").
  - [ ] Every major stack / infra / security / cost / license
        choice has a corresponding ADR in /ai/DECISIONS.md with:
        ADR number, Date, Status, Decision, Reason, Tradeoffs,
        Related Tasks, AND for versioned choices the verified
        version + canonical source URL + date verified.
  - [ ] For every component, all applicable dimensions (per its
        section in /docs/PROJECT_SHAPE_GALLERY.md) are either
        chosen-with-ADR or explicitly captured as a deferred open
        question with a task queued. Nothing was silently invented.
  - [ ] Rule applicability decisions are recorded (which Hard
        rule blocks apply at this tier; any ADR overrides for
        rules that don't).
  - [ ] The composite Mermaid system diagram is up to date and
        committed to /ai/ARCHITECTURE.md "System Overview".
  - [ ] /ai/BUDGET.md has a cap, alert thresholds, and rough
        estimates for major cost contributors based on live
        pricing lookups (or records "n/a — no managed services"
        with reason).
  - [ ] LICENSE, README.md, SECURITY.md, CONTRIBUTING.md exist at
        the project root.
  - [ ] All 5 tool-native memory hooks exist at the project root
        (CLAUDE.md, AGENTS.md, .cursorrules, GEMINI.md,
        .github/copilot-instructions.md).
  - [ ] Phase-1 tasks reflect the component set (per-component
        scaffolding, distribution, etc.) AND the tier (cloud/IaC
        tasks present for non-solo tiers when components require
        hosting; deferred with ADR for solo prototype).
  - [ ] The first Phase-1 task in /ai/TASKS.md has every section
        from /ai/templates/TASK_TEMPLATE.md populated.
  - [ ] /ai/CURRENT_STATE.md ≤ 80 lines, /ai/HANDOFF.md ≤ 50 lines.
  - [ ] Every planning file touched has a fresh
        `Last Updated: YYYY-MM-DD` header.
  - [ ] Starter-history files were replaced and starter-setup
        files removed per Step 13.
  - [ ] `python3 scripts/lint-planning.py` passes with 0 errors
        and 0 warnings.

If any box is unchecked, fix it and re-run this self-check. Do NOT
mark P0-T1 Done with unchecked items.

## Hard rules

- Do NOT scaffold the project yet (P1-T1 task).
- Do NOT install dependencies yet.
- Do NOT create real cloud resources yet (Phase 1 task).
- Do NOT modify any read-only reference repo.
- Use placeholders only, never real secrets.
- Look up versions from canonical sources — never assume from
  training-data knowledge.
- Push after every commit (Git Rules in AI_RULES.md).
- Confirm before any destructive operation (Destructive Operations
  Rules in AI_RULES.md).
- Mark Blocked, do not silently work around (Blocked Escalation Rule).
- Run the Pre-flight self-check above before declaring P0-T1 done.

Begin with the Start-of-Chat summary (START_HERE.md section 5).
End with the End-of-Chat report (START_HERE.md section 6) — including
the self-critique section — and remember to update CURRENT_STATE,
TASKS, HANDOFF, DONE_LOG to reflect the closed P0-T1.
```
