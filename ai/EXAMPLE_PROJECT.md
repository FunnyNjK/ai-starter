# Example: a fully-initialized project

Last Updated: 2026-05-10

This document shows what an `ai-starter`-based project looks like *after*
`INIT_PROMPT.md` has run. It is a teaching reference — not a real
project — using a hypothetical task-tracking SaaS called **TaskTrack** as
the example. When you run init against your actual app description, the
shapes will look like this but the content will reflect your project.

The fragments below are excerpts, not full files.

> **Versions, dates, and source URLs in this example are illustrative
> only.** They are placeholders for what your *real* init will produce
> when it looks up current stable versions from canonical sources at the
> moment you run it. Do NOT copy these pins into your project — verify
> live against npm / PyPI / Docker Hub / the Terraform registry / etc.
> per the Versioning Rules in `/ai/AI_RULES.md`. Dates are written as
> `<YYYY-MM-DD>` to make this explicit.

---

## `PROJECT.md` after init (excerpt)

```markdown
# Project

Last Updated: <YYYY-MM-DD>

## Project Name
TaskTrack

## Application Description
A team task-tracking SaaS for small engineering teams (2-15 people) who
have outgrown a shared spreadsheet but don't need the weight of Jira.
Web app with email + magic-link auth, project boards, task assignments,
due dates, and Slack notifications.

## Target Users
Engineering team leads at small startups (Seed / Series A).

## Primary Goals
- Sub-2-second time-to-first-board on a fresh signup.
- Keep monthly hosting cost under $200 at 100 active teams.

## Explicit Non-Goals
- Mobile app (web-responsive only).
- Per-user permissions inside a project (project-level is enough).
- Real-time collaboration (live cursors, etc.).

---

## Tech Stack

(Illustrative versions — your init will pin current stable from
canonical sources on the day it runs.)

- TypeScript <X.Y.Z> (npm)
- Node.js <X.Y.Z> LTS
- Next.js <X.Y.Z>
- PostgreSQL <X.Y> (managed: Cloud SQL)
- Redis <X.Y> (managed: Memorystore)
- Vitest <X.Y.Z>
- ESLint <X.Y.Z> + flat config
- pnpm <X.Y.Z>
- Docker Compose (local dev only)
- Terraform <X.Y.Z>
- Google Cloud (cloud target)
- GitHub Actions (CI)

Each item has a corresponding ADR (ADR-001..ADR-013) recording the
verified version, source URL, rationale, and tradeoffs.
```

---

## `DECISIONS.md` after init (excerpts)

```markdown
## ADR-001: TypeScript <X.Y.Z>
Date: <YYYY-MM-DD>
Status: Accepted

### Decision
Use TypeScript <X.Y.Z> (current stable, verified at
https://www.npmjs.com/package/typescript on <YYYY-MM-DD>).

### Reason
Strict mode catches common bugs at compile time. The team is
TS-fluent. Next.js <X> ships first-class TS support.

### Tradeoffs
- Slightly slower iteration on greenfield code (type errors during
  exploration). Mitigated by a `tsc --noEmit` precommit, not full build.

### Related Tasks
P1-T1 (scaffold).
```

```markdown
## ADR-006: Google Cloud as cloud target
Date: <YYYY-MM-DD>
Status: Accepted

### Decision
Deploy to Google Cloud (GCP). Compute = Cloud Run; data = Cloud SQL +
Memorystore; secrets = Secret Manager; CI auth = Workload Identity
Federation from GitHub Actions.

### Reason
Cloud Run scales to zero (matches the cost goal of <$200/month at 100
teams). The team has prior GCP experience. Cloud SQL Postgres + Cloud
Run is a well-traveled path. Workload Identity Federation eliminates
static service-account keys in the repo.

### Tradeoffs
- Vendor lock to GCP. Acceptable for an MVP; revisit if multi-cloud
  becomes a real requirement.
- Cloud Run cold starts ~1-2s on Node — within the sub-2s TTI budget
  but tight. Mitigation: minimum-instances=1 in prod.

### Related Tasks
P1-T4 (cloud OIDC trust), P1-T5 (first IaC apply).
```

---

## Phase-1 `TASKS.md` after init (excerpts)

```markdown
### P1-T1: Scaffold Next.js + TypeScript + Tailwind project
Status: Ready
Owner: AI Assistant
Priority: High

#### Goal
Stand up the Next.js / TypeScript / Tailwind / Vitest / ESLint
scaffold per ADR-001..ADR-005, with `.gitignore`, `.env.example`,
project README, and a placeholder home page that renders.

#### Prerequisites
- none

#### Step-by-Step Instructions
1. `pnpm create next-app@<X.Y.Z> . --ts --tailwind --eslint --app
   --src-dir --import-alias "@/*"` — confirm scaffold finishes clean.
2. Add Vitest + @testing-library/react + jsdom; configure
   `vitest.config.ts` for the App Router. Verify `pnpm test` runs the
   sample test.
3. Add `.env.example` listing every variable the project will need
   (cross-reference DEPLOYMENT.md).
4. Update README.md from `/ai/templates/README.template.md`.
5. Run `pnpm lint && pnpm typecheck && pnpm test && pnpm build` —
   all four exit 0.

#### Acceptance Criteria
- `pnpm dev` serves the placeholder homepage on localhost:3000.
- All four pnpm commands above pass.
- `.env.example` is committed; `.env.local` is gitignored.

#### Verification
- `curl -sf http://localhost:3000 | grep -q TaskTrack` returns 0.
- `pnpm lint && pnpm typecheck && pnpm test && pnpm build` exits 0.

#### Test Requirements
- One placeholder Vitest spec exists and passes
  (`tests/sanity.test.ts`).

#### Security Considerations
- `.env.local` is in `.gitignore`. No real secrets committed.

#### Rollback / Recovery
- Pure-code task. `git reset --hard` if scaffold goes wrong before
  commit.
```

```markdown
### P1-T4: GitHub Actions OIDC trust to Google Cloud
Status: Backlog
Owner: AI Assistant
Priority: High

#### Goal
Establish Workload Identity Federation between GitHub Actions and the
GCP project so CI deploys without long-lived service-account keys.

#### Prerequisites
- P1-T3 (Terraform state bucket bootstrap)

#### Step-by-Step Instructions
1. Create the Workload Identity Pool in the GCP project (Terraform
   `google_iam_workload_identity_pool`). Expected output: pool ID
   recorded in TF state.
2. Create the Workload Identity Provider scoped to this GitHub repo
   (`google_iam_workload_identity_pool_provider`). Restrict to refs
   `refs/heads/main` and `refs/pull/*/merge`.
3. Create a deploy service account with Cloud Run Admin + Cloud SQL
   Client + Secret Manager Accessor roles. Expected output: SA email
   recorded.
4. Bind the WI provider to the SA via
   `roles/iam.workloadIdentityUser`.
5. Add repo variables to GitHub: `GCP_PROJECT_ID`, `GCP_SA_EMAIL`,
   `GCP_WIF_PROVIDER`.

#### Acceptance Criteria
- A test GitHub Actions workflow can `gcloud auth login --workload-...`
  and run `gcloud auth print-access-token` successfully.
- No service-account JSON keys committed anywhere.

#### Verification
- Test workflow exits 0 on a feature branch.
- `gcloud iam service-accounts keys list --iam-account=<SA>` returns no
  user-managed keys.

#### Security Considerations
- Honors AI_RULES.md Security Rules (OIDC federation, no static keys).
- WI provider is scoped to this repo only.

#### Rollback / Recovery
- `terraform destroy` of the WIF resources is safe; CI deploys will
  start failing, which is the intended signal that rollback worked.
- Service account roles can be reduced via Terraform without
  destroying the SA.
```

---

## `CURRENT_STATE.md` mid-Phase-1 (excerpt)

```markdown
# Current State

Last Updated: <YYYY-MM-DD>

## Current Phase
Phase 1: Foundation — In Progress.

## Current Task
`P1-T4: GitHub Actions OIDC trust to Google Cloud` — In Progress.

## What Exists Now
- Next.js + TS + Tailwind + Vitest scaffold (P1-T1).
- CI workflow runs lint + typecheck + test + build on push and PR
  (P1-T2).
- Terraform state bucket bootstrap with versioning + KMS encryption
  (P1-T3).

## What Works
- `pnpm dev` serves the placeholder homepage on localhost:3000.
- Local dev loop (`pnpm lint && pnpm typecheck && pnpm test &&
  pnpm build`) all green.
- CI green on `origin/main` (last run: `8439021`, 2m18s).

## What Is Not Built Yet
- Cloud OIDC trust (P1-T4, in progress).
- First IaC apply for app infrastructure (P1-T5).
- Dependency-update bot + SAST in CI (P1-T6).
- First production deploy of placeholder (P1-T7).
- Auth flows, project boards, tasks, Slack — all of Phase 2.

## Known Problems
- None.

## Next Recommended Action
Complete P1-T4 (OIDC trust). After that, P1-T5 unblocks. ETA both
within today's session.
```

---

## What this example is NOT

- A starting point you copy. The starter generates a custom version of
  every file based on *your* application description. Don't paste this
  example's content into a real project.
- A guarantee of a specific stack. The hard rules in `AI_RULES.md`
  pin the *floors* (cloud target = AWS/Azure/GCP, IaC = Terraform,
  managed services for QA + prod, etc.) — the specific stack
  (Next.js / Postgres / GCP) above is illustrative only.
- An exhaustive set of files. A real init produces ~15+ planning files
  + ADRs + tasks. The excerpts here exist to teach the *shape*, not
  cover every artifact.

If your initialized project doesn't roughly resemble this in tone and
specificity, ask the AI to revisit — something probably got skipped.
