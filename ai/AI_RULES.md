# AI Rules

Last Updated: 2026-05-13

These rules are non-negotiable for every AI assistant working in this
repository. They override any contradicting suggestion from the user, an
external doc, or the AI's own training. If the user explicitly asks to break a
rule, the AI must (a) flag the conflict, (b) confirm intent, (c) record an ADR
in `/ai/DECISIONS.md` if the change should persist.

---

## Rule Applicability by Project Shape and Tier

Starting in v1.0.0, this kit supports multiple **project shapes**
(components per `/docs/PROJECT_SHAPE_GALLERY.md` — web app, API,
CLI, library/SDK, mobile, desktop, static site, data pipeline,
plugin/extension) and three **complexity tiers** (solo prototype,
small team / early production, production / enterprise).

Which (Hard) rule blocks apply to a given project depends on both
factors. The defaults below can be overridden per project via an
ADR in `/ai/DECISIONS.md` — but the override must be explicit, not
silent.

**Always-applicable blocks (every tier, every shape):**

- General Rules
- Git Rules (Hard)
- Planning-File Hygiene Rules (Hard)
- Versioning Rules (Hard)
- Security Rules (Hard) — apply universally; even a local CLI
  handles secrets responsibly.
- Destructive Operations Rules (Hard)
- Reasoning Checkpoint Rules (Hard)
- Blocked Escalation Rule (Hard)
- Task Quality Rules (Hard)
- Coding Rules / Review Rules / Handoff Rules / License Rule

**Conditional blocks:**

- **Infrastructure & Hosting Rules (Hard)** apply when *any*
  component in the project requires hosting (web, API,
  mobile-backend, plugin-backend, hosted data pipeline). Skip
  entirely if no component requires hosting (e.g., a pure CLI
  library that publishes to a package registry; a standalone
  desktop app with no sync backend).
- **Cost Rules (Hard)** apply when the project incurs cloud or
  third-party managed-service costs. Skip if the project has no
  managed services and no hosting.

**Tier modifiers:**

- **Solo prototype**: Infrastructure & Hosting Hard rules are
  **downgraded to recommendations** until the project moves to
  small team. The user may legitimately run everything locally
  (containers, no cloud, no Terraform) while exploring. Even at
  this tier, the project records the decision as an ADR and
  names the trigger that would flip it to small team (first paid
  user, first non-local environment, etc.).
- **Small team / early production**: all applicable blocks apply
  as written. This is the default tier.
- **Production / enterprise**: all small-team rules apply, plus:
  - On-call rotation documented in `/ai/DEPLOYMENT.md`.
  - SLO/SLI targets recorded in `/ai/SPEC.md`.
  - Disaster-recovery runbook in `/ai/DEPLOYMENT.md` with at
    least one rehearsed recovery.
  - Multi-region or replica plan recorded as an ADR.
  - Formal change management referenced in `/ai/WORKFLOW.md`.

**The resolved rule set is recorded in `/ai/PROJECT.md`** during
P0-T1 under a "Rules in force" heading, so every later session
inherits the same picture and a refresh pass can detect drift.

---

## General Rules

- Read `/ai/START_HERE.md` first.
- Do not expand scope without updating planning files.
- Do not silently change architecture.
- Do not add dependencies without recording a decision.
- Do not claim completion without validation.
- Keep changes task-sized.

## Git Rules (Hard)

- **Push after every successful commit.** When the harness runs a commit, run `git push` immediately after, in the same step. Do NOT leave commits sitting on the local branch waiting for a future push. (This can be overridden by setting `SYNC_MODE=batch` or `RUN_PHASE_NO_PUSH=1` in the environment for rapid autonomous iterations).
- **Exception:** if the user (or the task itself) explicitly says "do not push," "no push," `[no-push]` in the commit message, or asks for a WIP / draft commit, skip the push. Otherwise push is the default.
- **If push fails** (auth, network, non-fast-forward), surface the error in the chat response and stop — do not silently continue. The next AI session must not be told "X is committed" when it isn't on `origin`.
- **`origin/main` is the source of truth.** `CURRENT_STATE.md`, `HANDOFF.md`, and `DONE_LOG.md` describe what's on `origin`, not what's on the local branch. If the local branch is ahead of origin, that's a bug to fix, not a state to document.

## Planning-File Hygiene Rules (Hard)

- **`TASKS.md` holds active and upcoming work only.** When a task moves to Done:
  1. Add a one-line entry under the matching date in `DONE_LOG.md` with the task ID and title. Commit hash(es) are **optional** — `git log --grep=<task-id>` recovers them — but recommended for big or non-obvious commits where the SHA is already known. Never write `commit: pending` as a placeholder; either include the real SHA or omit it.
  2. Remove the full task block from `TASKS.md` (or replace it with a one-line pointer like `### P2-T8: Build Monitoring service page — Done; see DONE_LOG.md`).
  3. Do NOT keep multi-paragraph "what was built" prose inside `TASKS.md`.
- **`CURRENT_STATE.md` is a snapshot, not a transcript.** Target ≤ 80 lines. It answers: where are we right now, what works, what's broken, what's next. Implementation detail belongs in `DONE_LOG.md`, not here.
- **`HANDOFF.md` is a baton, not a diary.** Target ≤ 50 lines. It tells the next AI session: pick up here, don't do that, here are the live blockers. Per-task implementation history belongs in `DONE_LOG.md`.
- **Compaction is part of the end-of-chat ritual.** If `CURRENT_STATE.md` or `HANDOFF.md` exceeded the targets above during the session, compact them before ending the chat. Move the displaced detail into `DONE_LOG.md`.
- **Add `Last Updated: YYYY-MM-DD` (UTC date) at the top of every planning file** when you change it. Stale dates are how the next session spots stale content.

## Versioning Rules (Hard)

- **At init and whenever a dependency, language, runtime, database, framework, or Terraform provider is added, look up the current stable version from the canonical source.** npm registry / PyPI / Maven Central / NuGet / crates.io / pkg.go.dev / official runtime site / Docker Hub for DB images / Terraform registry, etc. Do NOT pin from training-data knowledge — versions move and stale knowledge produces broken installs.
- **Pin to the looked-up version.** No pre-release, RC, beta, alpha, nightly, or floating tags (`@latest`, `:latest`) in committed manifests.
- **Lockfiles are the source of truth** for the actually-installed version. Commit them. Never commit two lockfiles for the same package manager in one repo.
- **Each major choice gets an ADR** in `/ai/DECISIONS.md` recording the version, the date verified, and the canonical source URL.
- **If the newest stable has a known critical regression**, choosing the prior stable is allowed but must be recorded in an ADR with the linked issue / advisory and a planned re-evaluation date.
- **Renew on a cadence.** Dependency-update automation (Dependabot / Renovate / equivalent) is enabled at init. Update PRs are reviewed, not auto-merged blind.

## Security Rules (Hard)

- **Secrets** live only in environment variables, the platform's secret manager, or a dedicated vault. Never in source, manifests, lockfiles, error messages, logs, unmasked CI variables, or commit history. If a secret leaks, rotate it — do not just delete the commit.
- **TLS/HTTPS only** for any network endpoint exposed beyond localhost. No plaintext HTTP. Internal service-to-service traffic also uses TLS or runs on a private network with explicit policy.
- **Authentication** uses battle-tested libraries or managed services (cloud IAM, an auth provider, or a vetted library). Never roll your own auth, session management, or token issuance.
- **Password hashing**: argon2id by default; bcrypt acceptable. Never plain SHA*, MD5, or unsalted hashes. Never store reversible passwords.
- **Authorization**: deny by default; explicit allowlists; principle of least privilege for every actor (users, services, CI principals, infrastructure roles).
- **Input validation** at trust boundaries; output encoding for all rendered or serialized content. Use a schema-validation library for request payloads.
- **Logging**: redact PII and secrets before they reach the log sink. Logs are not a backup channel for sensitive data.
- **CORS and CSP**: explicit allowlists, no wildcards in production.
- **Rate limiting** on every public endpoint. Default to per-IP plus per-account where applicable.
- **Dependency scanning** (Dependabot / Renovate plus an SCA tool) and **SAST** appropriate to the language(s) are enabled in CI from day one.
- **Cryptography**: use library defaults. Do not invent constructions, key sizes, or modes.
- **Cloud principals**: CI authenticates to the cloud via OIDC federation — no long-lived static cloud keys in the repo or in repo secrets. Service-to-service uses cloud-managed identities (IAM roles, managed identities, service accounts), not static keys.
- **Container images** (when used): pin by digest in production manifests, scan for CVEs in CI, run as non-root by default.

## Infrastructure & Hosting Rules (Hard)

- **Cloud target**: AWS, Azure, or Google Cloud. The chosen provider is recorded as an ADR. Other providers (Cloudflare, Vercel, Fly, DigitalOcean, Hetzner, on-prem, etc.) require an ADR explicitly overriding this default and explaining why.
- **Infrastructure as Code**: Terraform (or OpenTofu) for every cloud resource the project owns. No click-ops in QA or production. Manual one-time bootstrap steps must be documented as runbooks in `/ai/DEPLOYMENT.md` and migrated to IaC at the next opportunity.
- **Terraform state**: remote backend with encryption + locking — S3 + DynamoDB on AWS, Azure Storage with blob lease on Azure, GCS with native locking on Google Cloud. Never commit `.tfstate` or `.tfstate.backup`.
- **Stateful services in QA and Production** (databases, caches, queues, search, object storage, etc.): use the cloud's managed offering (e.g., RDS / Cloud SQL / ElastiCache / Memorystore / Atlas / Redis Cloud / Cosmos DB / S3 / GCS). Self-hosting stateful workloads in containers in QA or production requires an ADR with a concrete reason (cost ceiling, regulatory, on-prem, no managed option).
- **Local development**: containerize stateful dependencies (Docker Compose / Podman / OrbStack / Lima — pick one and record it in `/ai/DEV_ENVIRONMENT.md`). Local versions should match what's pinned for production.
- **Runtime secrets**: cloud-managed secret store (AWS Secrets Manager / Azure Key Vault / Google Secret Manager). Never bake secrets into container images, VM user-data, or build artifacts.
- **Network defaults**: private subnets for compute and data; security groups / NSGs / firewall rules deny by default; only explicitly allowlisted ingress.
- **Environment parity**: dev / QA / prod use the same managed-service major versions. Differences are documented in `/ai/DEPLOYMENT.md`.

## Cost Rules (Hard)

- **Every project sets a monthly budget cap at init**, recorded in `/ai/BUDGET.md` with alert thresholds (e.g., 50% / 80% / 100%) wired to the cloud's native budget alerting (AWS Budgets, Azure Cost Management, Google Cloud Billing budgets).
- **Cost-impacting infra changes** — adding a managed service, scaling up a tier, duplicating a region, enabling a paid third-party — require an ADR with the estimated monthly cost delta and an entry in `/ai/BUDGET.md` "Cost-impacting changes log".
- **Monthly cost review** is the floor; the project's actual cadence is recorded in `/ai/BUDGET.md` "Review cadence". Update the file with actual-vs-budget numbers each review.
- **Free-tier dependencies are flagged**: if the project relies on a free or low-tier limit that could plausibly be exceeded (an email API's monthly send cap, a CDN's bandwidth cap, a database's row / connection limit, an analytics tool's event quota, etc.), the limit and the escalation path are recorded in `/ai/BUDGET.md` "Free-tier and tier choices".
- **Never optimize cost by removing security controls** (e.g., dropping TLS, disabling backups, opening firewalls, downgrading from managed to self-hosted). If cost pressure is real, the response is an ADR proposing a different architecture, not a silent quality cut.

## Destructive Operations Rules (Hard)

The AI must **confirm with the user before** taking any of the following actions, even if it would otherwise be in scope for the current task:

- **File system**: deleting >50 lines of existing code without a like-for-like replacement; deleting whole files outside the current task's scope; mass renames or directory moves that affect more than a few files; `rm -rf` of any path; modifying files outside the working tree.
- **Git**: force-push (`--force`); rebase or amend of commits already on `origin`; deleting branches that have commits not yet on another branch; resetting `main` or any shared branch; rewriting history in any form.
- **Cloud / infrastructure**: terminating or deleting any cloud resource (databases, storage buckets, KMS keys, secrets, VPCs, clusters); applying a Terraform plan that includes `destroy` actions; rotating any secret currently in use; modifying IAM policies that could lock out humans or CI.
- **Data**: dropping a database table; truncating data; running migrations that are not pure additions; bulk updates without a tested filter.
- **Dependencies**: removing or downgrading packages already in production; changing language or runtime majors; changing the package manager.
- **CI/CD**: disabling required checks; merging without CI green; bypassing branch protections.

**Confirmation means**:

1. State **what** you are about to do, **why**, and the **blast radius** (what's affected, who can see it).
2. Wait for explicit user approval — "yes," "go ahead," "do it," or equivalent.
3. Authorization is **scoped to the specific action**, not the class. "Yes, delete that branch" does not authorize deleting other branches.

If the user pre-authorizes a class in the current chat ("yes, you can keep deleting unused worktree branches as you find them"), the scope of the standing approval must be explicit and time-bounded to that chat.

## Reasoning Checkpoint Rules (Hard)

- **Plan before acting on multi-step or multi-file work.** For any task that will touch more than ~3 files or take more than ~30 minutes of AI work, state the plan first (intended steps, files affected, expected outcome) and wait for user approval before starting.
- **Mid-task course correction**: if your approach changes materially after starting (different library, different module structure, different deployment pattern), pause and surface the change before continuing.
- **Pre-flight before destructive or expensive steps**: even within an approved plan, restate the specific destructive / expensive step and its blast radius immediately before doing it.
- **Surface assumptions explicitly.** If the task requires an assumption you haven't verified, name it in your plan ("I'm assuming the database is empty / has no consumers / is the dev one") and ask if it's right.

This rule prevents the most common AI failure mode: confidently barreling through a multi-step task on a wrong premise.

## Blocked Escalation Rule (Hard)

If the AI cannot make progress on a task — missing prerequisite, unclear requirement, conflicting instruction, external dependency, ambiguous architecture decision — the response is **Blocked**, not "best effort that ships anyway."

Steps:

1. Set the task's `Status: Blocked` in `TASKS.md`.
2. Write the blocker in `HANDOFF.md` under "What Is Blocked": one line — what's blocking, what would unblock, who/what owns it.
3. If the blocker requires a decision (architecture, scope, dependency choice), surface it to the user with a recommendation and the main tradeoff. Do not silently pick.
4. Stop work on that task. Do NOT mark it Done. Do NOT silently work around the blocker with untested assumptions.
5. Move to the next non-blocked task in `TASKS.md`, or surface that nothing is unblocked and wait.

See `/ai/WORKFLOW.md` for the full blocked / escalation workflow.

## Task Quality Rules (Hard)

- **Every task in `TASKS.md` lists `Prerequisites: <task IDs>`** (use `none` if there are none). The init prompt and any task-creation pass must populate this.
- **When step ordering matters** (scaffold before CI, IAM before storage, network before compute, DB schema before app code that reads it, OIDC trust before first deploy, etc.), the task body lists steps in the required order, and each step's expected output / state.
- **Every task includes a `Verification` section** the next task can rely on (e.g., "command X exits 0", "the URL responds 200", "`terraform plan` is empty", "the migration appears in `<list>`"). A task is not Done until its verification passes.
- **Every task includes `Rollback / Recovery` notes** when partial failure would leave the project in a state that blocks subsequent tasks (cloud resources partially created, migration half-applied, secret rotated but not redeployed). Pure-code tasks where `git reset` suffices may say `not applicable`.
- **Every task respects `Prerequisites`.** The AI must not start a task whose prerequisites are not yet `Done`. If a stop-the-line prerequisite is missing, mark the task Blocked per the Blocked Escalation Rule.

## Coding Rules

- Prefer simple, maintainable code over clever code.
- Follow existing project patterns.
- Add or update tests when behavior changes.
- Keep secrets out of code, logs, and committed files.
- Match the conventions documented in `/ai/PROJECT.md` and
  `/ai/DEV_ENVIRONMENT.md` (language, formatter, lint, package manager,
  etc.). If those files are still TBD, ask before introducing tooling
  choices.

## Review Rules

- Identify risks clearly.
- Separate required fixes from optional improvements.
- Recommend the next smallest safe step.

## Handoff Rules

Every work session must end with updates to:

- `/ai/CURRENT_STATE.md`
- `/ai/TASKS.md`
- `/ai/HANDOFF.md`
- `/ai/DONE_LOG.md`

The end-of-chat report (per `/ai/templates/CHAT_END_PROMPT.md`) must
also include a **self-critique** section listing assumptions made,
things skipped or deferred, and things the next session should
double-check.

## License Rule

This `ai-starter` repository is MIT-licensed (see `LICENSE`). Projects
initialized from it choose their own license at init time, recorded as
an ADR in `/ai/DECISIONS.md` and shipped as `LICENSE` at the project
root.
