# Project

Last Updated: 2026-05-13

## Project Name
TBD

## Application Description
TBD - Replace this with a plain-English description of what this project
does and who it's for.

## Problem Being Solved
TBD

## Target Users
TBD

## Primary Goals
- TBD

## Explicit Non-Goals
- TBD

---

## Components

TBD — filled in during P0-T1 from the kickoff component proposal.
Real projects are usually 1–N components. See
`/docs/PROJECT_SHAPE_GALLERY.md` for the catalog and rung ladders.

Format per component:

- **{Component name}** ({primary | supporting}) — rung
  {rung_id}: {short rung description}.
  - Why this rung: {one sentence}.
  - Key dimensions: see ADRs.

Examples (delete after filling in):

- **Web app** (primary) — rung Web R5: web + API split + storage +
  payments + email + admin.
- **API service** (supporting) — rung API R3: REST + DB + auth +
  queue. Owned by this project; called by the web app.
- **Static site** (supporting) — rung Static R2: SSG marketing site.

## Tier

TBD — one of:

- **Solo prototype** — one developer, exploring. Infrastructure &
  Hosting Hard rules downgraded to recommendations until tier
  changes. Trigger to flip to small team: {first paid user,
  first non-local environment, etc.}
- **Small team / early production** (default) — all applicable
  Hard rules apply.
- **Production / enterprise** — adds on-call rotation, SLO/SLI
  targets, DR runbook, multi-region/replica plan, formal change
  management.

## Rules in force

Which `/ai/AI_RULES.md` (Hard) rule blocks apply to this project,
resolved per Rule Applicability section + tier + component set.

Always applicable:
- Git Rules, Planning-File Hygiene Rules, Versioning Rules,
  Security Rules, Destructive Operations Rules, Reasoning
  Checkpoint Rules, Blocked Escalation Rule, Task Quality Rules.

Conditionally applicable:
- **Infrastructure & Hosting Rules**: {apply | downgraded to
  recommendations (solo) | skip (no hosted components)}.
- **Cost Rules**: {apply | skip (no managed services)}.

ADR overrides (if any): {list ADR numbers and what each overrides}.

---

## Tech Stack

TBD - record once chosen. Each major choice should also be captured as an
ADR in `/ai/DECISIONS.md` recording the version, the date verified, the
canonical source URL, rationale, and trade-offs (per the Versioning
Rules in `/ai/AI_RULES.md`).

Sections to fill in (delete the ones that don't apply):

- Language(s) and runtime version(s)
- Frontend framework / UI toolkit
- Backend framework / runtime
- Database(s) and cache(s)
- Authentication
- External services
- Testing framework
- Lint / format tooling
- Package management
- Containerization (local dev)
- IaC tool (default: Terraform / OpenTofu)
- CI/CD

---

## Security Baseline

Project-specific security choices (link to the ADRs that record each).
Honor the Security Rules (Hard) in `/ai/AI_RULES.md` as the floor.

- Authentication library / service: TBD (ADR-???)
- Password hashing algorithm + library: TBD (ADR-???)
- Schema-validation library: TBD (ADR-???)
- CORS / CSP defaults: TBD (ADR-???)
- Rate-limiting strategy: TBD (ADR-???)
- Dependency-update automation: TBD (ADR-???)
- SAST tooling: TBD (ADR-???)
- SCA tooling: TBD (ADR-???)
- Logging library + PII redaction strategy: TBD (ADR-???)
- Container base image (if applicable) + CVE scanner: TBD (ADR-???)

---

## Infrastructure

Project-specific infrastructure choices (link to the ADRs that record
each). Honor the Infrastructure & Hosting Rules (Hard) in
`/ai/AI_RULES.md` as the floor.

- Cloud provider (AWS / Azure / Google Cloud): TBD (ADR-???)
- Account / project / subscription topology (dev / QA / prod isolation):
  TBD (ADR-???)
- IaC tool + version: TBD (ADR-???)
- Terraform state backend: TBD (ADR-???)
- Compute target (managed containers / serverless / VMs): TBD (ADR-???)
- Managed stateful services (per DB / cache / queue / search / object
  store): TBD — one ADR per service with engine + version
- Cloud-managed secret store: TBD (ADR-???)
- CI/CD service + OIDC federation pattern: TBD (ADR-???)
- Local dev container runtime: TBD (ADR-???) — also recorded in
  `/ai/DEV_ENVIRONMENT.md`

---

## Behavior Specification

Concrete user flows, edge cases, performance budgets, accessibility
targets, and compliance requirements live in `/ai/SPEC.md`. That file
is the source of truth for Phase-2 task acceptance criteria.

---

## Budget

Monthly cap, alert thresholds, free-tier limits, and cost-impacting
changes live in `/ai/BUDGET.md`. Each cost-impacting infra change also
gets an ADR per the Cost Rules in `/ai/AI_RULES.md`.

---

## License

TBD - chosen at init (recorded as an ADR). The license text lives in
`LICENSE` at the project root.

---

## Repository Structure

TBD once the project is scaffolded. Document the canonical layout here so
the AI and any new contributors know where each kind of file lives.

---

## Non-Negotiables

- Keep scope controlled.
- Update `/ai` project files after every meaningful change.
- Do not add dependencies without documenting the decision in
  `/ai/DECISIONS.md`, including the looked-up version and source URL.
- Tests or validation steps are required before marking tasks complete.
- Honor `/ai/AI_RULES.md` — every (Hard) block applies.

---

## AI Instructions

When this file is still generic (Project Name = TBD), use the user's
application description to replace the TBD sections with project-specific
details. Follow the steps in `/ai/templates/INIT_PROMPT.md` to verify
versions from canonical sources, choose the security baseline, and
choose the infrastructure baseline — each captured as ADRs in
`/ai/DECISIONS.md`.
