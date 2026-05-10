# AI Rules

Last Updated: 2026-05-10

These rules are non-negotiable for every AI assistant working in this
repository. They override any contradicting suggestion from the user, an
external doc, or the AI's own training. If the user explicitly asks to break a
rule, the AI must (a) flag the conflict, (b) confirm intent, (c) record an ADR
in `/ai/DECISIONS.md` if the change should persist.

---

## General Rules

- Read `/ai/START_HERE.md` first.
- Do not expand scope without updating planning files.
- Do not silently change architecture.
- Do not add dependencies without recording a decision.
- Do not claim completion without validation.
- Keep changes task-sized.

## Git Rules (Hard)

- **Push after every successful commit.** When the harness runs a commit, run `git push` immediately after, in the same step. Do NOT leave commits sitting on the local branch waiting for a future push.
- **Exception:** if the user (or the task itself) explicitly says "do not push," "no push," `[no-push]` in the commit message, or asks for a WIP / draft commit, skip the push. Otherwise push is the default.
- **If push fails** (auth, network, non-fast-forward), surface the error in the chat response and stop — do not silently continue. The next AI session must not be told "X is committed" when it isn't on `origin`.
- **`origin/main` is the source of truth.** `CURRENT_STATE.md`, `HANDOFF.md`, and `DONE_LOG.md` describe what's on `origin`, not what's on the local branch. If the local branch is ahead of origin, that's a bug to fix, not a state to document.

## Planning-File Hygiene Rules (Hard)

- **`TASKS.md` holds active and upcoming work only.** When a task moves to Done:
  1. Add a one-line entry under the matching date in `DONE_LOG.md` with the task ID, title, and key commit hash(es).
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

## Task Quality Rules (Hard)

- **Every task in `TASKS.md` lists `Prerequisites: <task IDs>`** (use `none` if there are none). The init prompt and any task-creation pass must populate this.
- **When step ordering matters** (scaffold before CI, IAM before storage, network before compute, DB schema before app code that reads it, OIDC trust before first deploy, etc.), the task body lists steps in the required order, and each step's expected output / state.
- **Every task includes a `Verification` section** the next task can rely on (e.g., "command X exits 0", "the URL responds 200", "`terraform plan` is empty", "the migration appears in `<list>`"). A task is not Done until its verification passes.
- **Every task includes `Rollback / Recovery` notes** when partial failure would leave the project in a state that blocks subsequent tasks (cloud resources partially created, migration half-applied, secret rotated but not redeployed). Pure-code tasks where `git reset` suffices may say `not applicable`.

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
