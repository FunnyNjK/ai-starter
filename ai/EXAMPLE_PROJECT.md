# Example: a fully-initialized project

Last Updated: 2026-05-20

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

## Components

(v1.0.0+ — captured at P0-T1 from the kickoff component proposal.)

- **Web app** (primary) — rung Web R4: server-rendered web app
  with managed DB. Single Next.js deployable owning users +
  data.
  - Why this rung: TaskTrack is one app surface, no separate
    API needed at this scale.
- **Static site** (supporting) — rung Static R2: SSG marketing
  + docs hosted alongside the web app.
  - Why this rung: a small marketing surface is cheaper to ship
    as static than mixed into the Next.js app.

## Tier

Small team / early production. CI present, deploys to managed
hosting, multiple contributors expected. Trigger to flip to
production tier: first paying customer + multi-region requirement.

## Rules in force

- Always applicable: Git, Planning-File Hygiene, Versioning,
  Security, Destructive Operations, Reasoning Checkpoint,
  **Local-First Development**, Blocked Escalation, Task Quality,
  General / Coding / Review / Handoff.
- **Infrastructure & Hosting Rules**: applicable but **deferred to
  P3-T0 deploy planning** per the Local-First Development Rule.
  Init records the local Docker Compose runtime + local Postgres
  + Redis container versions only.
- **Cost Rules**: free-tier ceilings captured now; Cost-Rules-
  compliant monthly cap deferred to P3-T0.
- ADR overrides: none.

---

## Tech Stack

(Illustrative versions — your init will pin current stable from
canonical sources on the day it runs.)

Decided at init (Phase 0 — local development):

- TypeScript <X.Y.Z> (npm)
- Node.js <X.Y.Z> LTS
- Next.js <X.Y.Z>
- PostgreSQL <X.Y> (local: Docker Compose container)
- Redis <X.Y> (local: Docker Compose container)
- Vitest <X.Y.Z>
- ESLint <X.Y.Z> + flat config
- pnpm <X.Y.Z>
- Docker Compose (local container runtime)
- GitHub Actions (CI — lint/test/build only at Phase 1; deploy
  leg added at Phase 4)

Deferred to P3-T0 (deploy planning):

- Cloud target (rough preference: Google Cloud).
- IaC tool (rough preference: Terraform).
- Managed-service instances for Postgres + Redis (rough
  preference: Cloud SQL + Memorystore, engine versions to match
  the local container versions above).
- Runtime secret store, OIDC federation, network defaults,
  monthly budget cap + alerts.

Each Phase-0 item has a corresponding ADR (ADR-001..ADR-009) at
init. The deploy ADRs (ADR-010..ADR-016) are written at P3-T0,
not at init.
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
## ADR-010: Google Cloud as cloud target — written at P3-T0
Date: <YYYY-MM-DD> (later, at end of Phase 2 / start of Phase 3)
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
P3-T0 (deploy planning, this ADR was written here),
P4-T2 (OIDC trust), P4-T3 (first IaC apply).
```

Note: in v1.0.0 this ADR was numbered ADR-006 and written at init
alongside the stack ADRs. v1.1.0's Local-First Development Rule
defers it to P3-T0, so it shows up later in the numbering and
later in the timeline.

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
### P1-T2: Verify local development loop is green
Status: Ready
Owner: AI Assistant
Priority: High

#### Goal
Per the Local-First Development Rule, verify the project's standard
"run locally" command works and lint/typecheck/test/build all pass
locally BEFORE configuring CI. This task gates P1-T3 (CI workflow).

#### Prerequisites
- P1-T1 (Scaffold)

#### Step-by-Step Instructions
1. Start the local container runtime: `docker compose up -d` —
   Postgres + Redis containers come up healthy.
2. Run `pnpm dev` — the app serves on `http://localhost:3000`.
3. Confirm the placeholder homepage renders in a browser.
4. Stop the dev server. Run `pnpm lint`, then `pnpm typecheck`,
   then `pnpm test`, then `pnpm build` — each exits 0.
5. Document any environment-specific quirks (Node version
   mismatch, port conflicts, missing system deps) in
   DEV_ENVIRONMENT.md.

#### Acceptance Criteria
- All four pnpm commands exit 0 from a clean clone after
  `pnpm install`.
- Postgres + Redis are reachable from the dev process.
- A fresh contributor can run `git clone && pnpm install &&
  docker compose up -d && pnpm dev` and see the homepage.

#### Verification
- `pnpm lint && pnpm typecheck && pnpm test && pnpm build` exits 0
  on the developer's machine.
- `curl -sf http://localhost:3000 | grep -q TaskTrack` returns 0.

#### Rollback / Recovery
- Pure-code task. `git reset --hard` if scaffold needs to be
  redone.
```

```markdown
### P3-T0: Deploy Planning (cloud, IaC, budget ADRs)
Status: Backlog
Owner: AI Assistant
Priority: High

#### Goal
Make and record the deploy decisions deferred from init: cloud
target, IaC tool + state backend, managed-service instances for
Postgres + Redis (engine major versions match what was pinned
locally at P1-T1), runtime secret store, OIDC trust, network
defaults, monthly budget cap + alert thresholds. Updates BUDGET.md
from "rough preference" to a Cost-Rules-compliant cap. Queues
Phase-4 implementation tasks (P4-T1..P4-T5+).

#### Prerequisites
- Phase 2 complete (TaskTrack's signup → board → task feature loop
  works locally and in CI).

#### Step-by-Step Instructions
1. Confirm the kickoff's rough cloud preference still holds, or
   revisit with the user. Write ADR-010 (cloud target).
2. Write ADR-011 (IaC tool + state backend). Verified versions
   from the Terraform registry.
3. Per stateful dep, write one ADR locking the managed-service
   instance: ADR-012 (Cloud SQL Postgres <X.Y>, matches local
   Postgres <X.Y>), ADR-013 (Memorystore Redis <X.Y>, matches
   local Redis <X.Y>). Versions verified from cloud console docs.
4. Write ADR-014 (Secret Manager), ADR-015 (Workload Identity
   Federation), ADR-016 (network defaults).
5. Update BUDGET.md: replace "Rough budget preference" with
   Cost-Rules-compliant cap + 50/80/100% thresholds + Major cost
   contributors table (live pricing lookups).
6. Update ARCHITECTURE.md: fill in Infrastructure & Hosting
   section; update the Mermaid diagram with the cloud subgraph
   (replacing the "TBD — set at P3-T0" placeholder).
7. Queue P4-T1 (Terraform state bootstrap), P4-T2 (OIDC trust),
   P4-T3 (first IaC apply), P4-T4 (first production deploy),
   P4-T5 (cloud budget + alerts wiring). Each with
   `Prerequisites: P3-T0`.

#### Acceptance Criteria
- ADR-010..ADR-016 all written, dated, with verified versions and
  canonical source URLs.
- BUDGET.md has a Cost-Rules-compliant cap and Major cost
  contributors filled in.
- P4-T1..P4-T5 are queued in Backlog with correct prerequisites.
- ARCHITECTURE.md Mermaid diagram shows the cloud subgraph (no
  TBD placeholder remaining).

#### Verification
- `grep "Rough budget preference" ai/BUDGET.md` returns nothing.
- `grep "TBD — set at P3-T0" ai/ARCHITECTURE.md` returns nothing.
- `python3 scripts/lint-planning.py` passes.

#### Rollback / Recovery
- Documentation-only. `git reset` if planning goes wrong.
```

---

## `CURRENT_STATE.md` mid-Phase-1 (excerpt)

```markdown
# Current State

Last Updated: <YYYY-MM-DD>

## Current Phase
Phase 1: Foundation — In Progress.

## Current Task
`P1-T3: Configure CI workflow that mirrors local loop` — In Progress.

## What Exists Now
- Next.js + TS + Tailwind + Vitest scaffold (P1-T1).
- Local dev loop verified green: `pnpm dev` runs, `pnpm lint &&
  pnpm typecheck && pnpm test && pnpm build` all green locally
  (P1-T2 closed yesterday).

## What Works
- `pnpm dev` serves the placeholder homepage on localhost:3000.
- Local dev loop (`pnpm lint && pnpm typecheck && pnpm test &&
  pnpm build`) all green.
- Postgres + Redis come up healthy via `docker compose up -d`.

## What Is Not Built Yet
- CI workflow mirroring the local loop (P1-T3, in progress).
- Dependency-update bot + SAST in CI (P1-T4).
- SECURITY.md + CONTRIBUTING.md (P1-T5).
- Auth flows, project boards, tasks, Slack — all of Phase 2.
- Deploy planning (P3-T0, Backlog — runs at end of Phase 2).
- First production deploy (P4-T4, Backlog — gated on P3-T0).

## Known Problems
- None.

## Next Recommended Action
Complete P1-T3 (CI mirrors local). First CI run should pass on
first try because what it checks already passed locally.
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
