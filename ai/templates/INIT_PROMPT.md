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
Honor /ai/AI_RULES.md as non-negotiable. Pay particular attention to the
(Hard) blocks — Git, Planning-File Hygiene, Versioning, Security,
Infrastructure & Hosting, and Task Quality — because every step below
references them.

Glance at /ai/templates/ — HANDOFF.template.md, CURRENT_STATE.template.md,
and TASK_TEMPLATE.md are the target shapes for the files you'll write.
REFRESH_PROMPT.md is for existing repos; ignore here.

## Step 2 — Choose the tech stack and verify versions

Use the user's application description (and the old repo, if any) to
choose:

- Language(s) and runtime version(s)
- Frontend framework / UI toolkit (if applicable)
- Backend framework / runtime (if applicable)
- Package manager (one per repo)
- Test framework
- Lint / format tooling
- Database(s) and cache(s) (if any)
- Auth library or service

For EACH chosen item, look up the current stable version from its
canonical source (npm registry / PyPI / Maven Central / NuGet / crates.io
/ pkg.go.dev / official runtime site / Docker Hub for DB images, etc.).
Do NOT pin from training-data knowledge — versions move. No
pre-release / RC / beta / alpha / nightly versions.

Capture each major choice as an ADR in /ai/DECISIONS.md (numbered
ADR-001, ADR-002, ...) with: decision, the version, the date verified,
the canonical source URL, rationale, and trade-offs. Ask the user before
locking in choices that materially change the project's shape.

## Step 3 — Choose infrastructure and deployment

Per the Infrastructure & Hosting Rules in AI_RULES.md:

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

## Step 4 — Choose the security baseline

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

## Step 5 — Inspect the old repo (read-only, skip if greenfield)

Treat it as read-only. Never modify it. Catalog: pages or modules,
content, copy, assets, brand (colors/fonts), navigation, integrations,
features to drop, opportunities to improve.

## Step 6 — Decide a design / migration direction

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

## Step 7 — Update planning files and queue tasks

Make all /ai/*.md files project-specific. Mark P0-T1 done in TASKS.md
and DONE_LOG.md.

Queue Phase-1 tasks. Phase 1 ALWAYS has at least these, in this order
(each task names its prerequisites explicitly):

1. Scaffold the project (language, framework, lint/format, test runner,
   `.gitignore`, `.env.example` if applicable, project README).
2. Add CI workflow (lint, type-check if applicable, tests, build) — runs
   on push and pull request.
3. Set up Terraform backend bootstrap (the encrypted state bucket /
   container / lock table). This is typically a one-time bootstrap with
   manual cloud auth, documented as a runbook, then handed off to IaC.
4. Add the cloud OIDC trust for CI (federated identity for the chosen
   cloud → repo, scoped to `main` and PR refs as appropriate).
5. First IaC apply: minimal account / project / subscription scaffold
   (resource group / project, networking, secret store, log destination,
   IAM baseline).
6. Dependency-update automation (Dependabot / Renovate) and SAST in CI.
7. First production deployment of a placeholder app (not the real
   features yet) to prove the deploy pipeline works end-to-end.

Queue Phase 2 tasks for the actual feature work — one per major page,
screen, module, or service from PROJECT.md and (if applicable) the
migration inventory. Add improvement-list tasks too.

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

## Step 8 — Create /ai/MIGRATION_INVENTORY.md (skip if greenfield)

- Page / module mapping (old → new → status)
- Asset mapping (old path → new path)
- Content mapping (section → source in old repo → notes)
- Drop list (with reasons)
- Improvement list (each linked to a TASKS.md entry)

## Step 9 — Environment variables

Identify every env var the new project will need. Document them in
/ai/DEPLOYMENT.md "Required Environment Variables", with which secret
store will hold them in QA and Production. The actual local env file
(or equivalent) with placeholders gets created during scaffold (P1-T1),
not now.

## Hard rules

- Do NOT scaffold the project yet (P1-T1 task).
- Do NOT install dependencies yet.
- Do NOT create real cloud resources yet (Phase 1 task).
- Do NOT modify any read-only reference repo.
- Do NOT modify /DEVELOPER-NOTES.md if present (developer-owned).
- Use placeholders only, never real secrets.
- Look up versions from canonical sources — never assume from
  training-data knowledge.
- Push after every commit (Git Rules in AI_RULES.md).

Begin with the Start-of-Chat summary (START_HERE.md section 5).
End with the End-of-Chat report (START_HERE.md section 6) — and
remember to update CURRENT_STATE, TASKS, HANDOFF, DONE_LOG to reflect
the closed P0-T1.
```
