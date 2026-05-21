# Architecture

Last Updated: 2026-05-10

## Architecture Status
TBD until the project is initialized. Once initialized, this file should
describe the system at a level a new contributor (human or AI) can use to
get oriented quickly.

For *what* the system does (user flows, edge cases, performance budgets,
accessibility, compliance), see `/ai/SPEC.md`. This file is about *how*
it's built.

---

## System Overview
TBD - high-level diagram or description of the major pieces and how they
talk to each other (frontend, backend, data layer, jobs, third-party
services).

---

## Major Components
TBD - one short subsection per component, describing what it does and
where its code lives.

---

## Data Flow
TBD - describe the end-to-end flow for the project's most important
operations.

---

## Security Model

Honor the Security Rules (Hard) in `/ai/AI_RULES.md` as the floor for
this section. Document the project-specific details:

- **Trust boundaries**: which surfaces are public, which are internal,
  and where requests cross the boundary.
- **Authentication**: which library or managed service is used, how
  sessions / tokens are issued and validated, where credentials live.
- **Authorization**: how access decisions are made (role-based,
  attribute-based, policy engine), and what the deny-by-default
  posture looks like in code.
- **Secrets**: which secret store is used in QA and Production, how the
  app reads them at runtime, who has rotation responsibility.
- **Cryptography**: which library provides hashing, encryption, and
  signing primitives. Record library defaults in an ADR.
- **Input / output handling**: which schema-validation library guards
  request payloads, which output-encoding strategy is used.
- **CORS / CSP**: the production allowlists.
- **Rate limiting**: per-IP and per-account thresholds for public
  endpoints.
- **Logging and PII**: which fields are redacted, and which sink the
  redacted logs go to.
- **CI security**: which SAST / SCA tools run on every PR, which
  dependency-update bot is configured.

Each major decision in this section should have a corresponding ADR.

---

## Infrastructure & Hosting

Honor the Infrastructure & Hosting Rules (Hard) in `/ai/AI_RULES.md`
as the floor for this section. Document the project-specific details:

- **Cloud provider**: AWS, Azure, or Google Cloud — link to the ADR.
- **Account / project / subscription topology**: how dev, QA, and
  production environments are isolated.
- **Networking**: VPC / VNet / VPC layout, public vs. private subnets,
  ingress paths, security groups / NSGs / firewall posture (deny by
  default).
- **Compute**: where the app runs (managed container service, serverless,
  VMs), and which runtime version is pinned.
- **Stateful services**: which managed offerings are used for each
  database, cache, queue, search, and object store. Record engine
  versions and link to ADRs.
- **IaC**: Terraform (or OpenTofu) layout — which modules / workspaces /
  workspaces-per-environment pattern is used. The state backend
  (S3+DynamoDB / Azure Storage + lease / GCS) and how it was
  bootstrapped.
- **CI/CD**: which CI service is used, and how it authenticates to the
  cloud (OIDC federation; no static cloud keys).
- **Runtime secrets**: which cloud-managed secret store is used and how
  the app reads from it.
- **Local development parity**: which container runtime hosts the
  stateful deps locally (Docker Compose / Podman / OrbStack / Lima), and
  the version-matching strategy with the production managed services.

Each major decision in this section should have a corresponding ADR.

---

## External Services
TBD - any third-party services the project depends on (email, payments,
analytics, etc.), what each is used for, and where credentials are
configured. Each integration should have an ADR.

---

## Repository Structure
See `/ai/SOLUTION.md` for the canonical project structure once defined.

---

## Architecture Rules

- Honor the (Hard) rules in `/ai/AI_RULES.md` (Versioning, Security,
  Infrastructure & Hosting, Cost, Destructive Operations, Reasoning
  Checkpoint, Blocked Escalation, Task Quality).
- Document new dependencies in `/ai/DECISIONS.md`.
- Document architecture changes via ADR before or during implementation.
- One canonical implementation per concern. If the same logic is needed
  in two places, extract to a shared module rather than duplicating.
- No click-ops in QA or production — every cloud resource is created and
  modified through Terraform.
- Cost-impacting infra changes (new managed service, scale-up, region
  duplication) get an ADR and an entry in `/ai/BUDGET.md`.

---

## Open Architecture Questions
- TBD per-project (filled in during initialization)
