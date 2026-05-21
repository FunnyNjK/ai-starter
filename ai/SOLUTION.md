# Solution

Last Updated: 2026-05-20

A "solution" is the whole repo. It holds 1-N **projects** (apps,
services, libraries) that share planning, hard rules, and decisions
under `/ai/`. New projects get added one at a time via
`/ai/templates/KICKOFF_ADD_PROJECT.md`. This file describes the
solution overall; per-project detail lives in
`projects/<name>/README.md`.

## Solution Name
TBD

## Application Description
TBD - Replace this with a plain-English description of what the
solution does and who it's for, taken from the first project's
feature loop. As more projects join, refine to describe the
overall product, not any single project.

## Problem Being Solved
TBD

## Target Users
TBD

## Primary Goals
- TBD

## Explicit Non-Goals
- TBD

---

## Projects

Each row is one app/service in this solution. Add a row when you
run `KICKOFF_ADD_PROJECT.md`. Each project has its own
`projects/<name>/README.md` with its specific stack, deps, and
local-dev instructions.

| Name | Platform | Language | Template | Status |
|------|----------|----------|----------|--------|
| TBD  | TBD      | TBD      | TBD      | Phase 0 |

Examples (delete after filling in):

| Name | Platform | Language | Template | Status |
|------|----------|----------|----------|--------|
| web  | Web      | TypeScript | Next.js Web App | Phase 1 |
| api  | Server   | TypeScript | NestJS API | Phase 1 |
| docs | Web      | TypeScript | Astro Static | Phase 1 |

---

## Tier

TBD — solution-level setting. One of:

- **Solo prototype** — one developer, exploring. Infrastructure &
  Hosting Hard rules downgraded to recommendations until tier
  changes. Trigger to flip to small team: {first paid user,
  first non-local environment, etc.}
- **Small team / early production** (default) — all applicable
  Hard rules apply.
- **Production / enterprise** — adds on-call rotation, SLO/SLI
  targets, DR runbook, multi-region/replica plan, formal change
  management.

Tier applies to all projects in the solution. Individual projects
don't pick their own tier.

## Rules in force

Which `/ai/AI_RULES.md` (Hard) rule blocks apply to this solution,
resolved per Rule Applicability section + tier + project set.

Always applicable:
- General Rules, Git Rules, Planning-File Hygiene Rules, Versioning
  Rules, Security Rules, Destructive Operations Rules, Reasoning
  Checkpoint Rules, Local-First Development Rule, Blocked
  Escalation Rule, Task Quality Rules.

Conditionally applicable:
- **Infrastructure & Hosting Rules**: {apply | downgraded to
  recommendations (solo) | skip (no hosted projects in solution)}.
- **Cost Rules**: {apply at P3-T0 deploy planning | skip (no
  managed services in any project)}.

ADR overrides (if any): {list ADR numbers and what each overrides}.

---

## Repository Layout

```
/
├── ai/                       solution-level planning (this folder)
│   ├── SOLUTION.md           you are here
│   ├── AI_RULES.md
│   ├── ARCHITECTURE.md       composite Mermaid of all projects
│   ├── DECISIONS.md          all ADRs (tagged with Project: line)
│   ├── TASKS.md              all tasks (tagged with Project: line)
│   └── ...
├── projects/
│   ├── <project-1>/          one folder per project
│   │   ├── README.md         project-specific stack, deps, dev story
│   │   └── ...               actual code
│   └── <project-2>/
│       └── ...
├── LICENSE
├── README.md
└── ...                       tool-native memory hooks, root docs
```

Even a solo-project solution uses `projects/<name>/` (not flat at
root) so adding a 2nd project doesn't require restructuring.

---

## Solution-Level Security Baseline

Application-layer security choices that apply to every project in
the solution (link to the ADRs that record each). Each project may
add its own additional security ADRs in `projects/<name>/README.md`
when warranted. Honor the Security Rules (Hard) in `/ai/AI_RULES.md`
as the floor.

- Default authentication library / service: TBD (ADR-???)
- Default password hashing algorithm + library: TBD (ADR-???)
- Default schema-validation library: TBD (ADR-???)
- CORS / CSP defaults: TBD (ADR-???)
- Default rate-limiting strategy: TBD (ADR-???)
- Dependency-update automation: TBD (ADR-???)
- SAST tooling per language: TBD (ADR-???)
- SCA tooling: TBD (ADR-???)
- Logging library + PII redaction strategy: TBD (ADR-???)
- Container base image policy (if applicable): TBD (ADR-???)

---

## Infrastructure

Per the Local-First Development Rule in `/ai/AI_RULES.md`, deploy
infrastructure is **deferred to Phase 3** (P3-T0). At init time
this section captures the local container runtime and other
local-development infrastructure only. Cloud target, IaC,
managed-service instances, OIDC, runtime secret store, network
defaults: written at P3-T0, not now.

Phase 0 / Phase 1 (local):
- Local container runtime: TBD (ADR-???) — Docker Compose / Podman
  / OrbStack / Lima, recorded in `/ai/DEV_ENVIRONMENT.md`.
- Per-project local container versions: TBD per stateful dep.

Phase 3 P3-T0 (deferred):
- Cloud provider: TBD at P3-T0
- IaC tool + state backend: TBD at P3-T0
- Managed-service instances: TBD at P3-T0
- Cloud-managed secret store: TBD at P3-T0
- CI/CD service + OIDC federation pattern: TBD at P3-T0

---

## Behavior Specification

Concrete user flows, edge cases, performance budgets, accessibility
targets, and compliance requirements live in `/ai/SPEC.md`. That
file is the source of truth for Phase-2 task acceptance criteria.
When the solution has multiple projects, `SPEC.md` is organized by
project (one section per project, plus any cross-project flows).

---

## Budget

Free-tier ceilings (Phase 1) and the rough budget preference live
in `/ai/BUDGET.md` "Free-tier and tier choices" and "Rough budget
preference" sections. The Cost-Rules-compliant monthly cap, alert
thresholds, and cost-impacting changes log are written at P3-T0
deploy planning, not now. See the Local-First Development Rule in
`/ai/AI_RULES.md`.

---

## License

TBD - chosen at init (recorded as an ADR). The license text lives
in `LICENSE` at the solution root. Applies to all projects unless
a specific project overrides via its own ADR.

---

## Non-Negotiables

- Keep scope controlled — one project per init run.
- Update `/ai` solution files after every meaningful change.
- Do not add dependencies without documenting the decision in
  `/ai/DECISIONS.md`, including the looked-up version and source
  URL.
- Tests or validation steps are required before marking tasks
  complete.
- Honor `/ai/AI_RULES.md` — every (Hard) block applies according
  to the Rules in force above.

---

## AI Instructions

When this file is still generic (Solution Name = TBD), use the
user's first-project answers (from `KICKOFF_NEW_SOLUTION.md`) to
replace the TBD sections with solution-specific details. Follow the
steps in `/ai/templates/INIT_PROMPT.md` to verify versions from
canonical sources, choose the application-layer security baseline,
and write Pass-1 ADRs — each captured in `/ai/DECISIONS.md`.

When a new project is added later (via `KICKOFF_ADD_PROJECT.md` +
`/ai/templates/ADD_PROJECT_PROMPT.md`), update only the Projects
table and any solution-level sections that materially change. The
new project's specific stack/deps go in
`projects/<name>/README.md`.
