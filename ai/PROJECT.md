# Project

Last Updated: 2026-05-10

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
