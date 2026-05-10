# Architecture

Last Updated: 2026-05-10

## Architecture Status
TBD until the project is initialized. Once initialized, this file should
describe the system at a level a new contributor (human or AI) can use to
get oriented quickly.

---

## System Overview
TBD - high-level diagram or description of the major pieces and how they
talk to each other.

---

## Major Components
TBD - one short subsection per component, describing what it does and where
its code lives.

---

## Data Flow
TBD - describe the end-to-end flow for the project's most important
operations.

---

## Security Model
TBD - where secrets live, how authentication and authorization work, what
the trust boundaries are.

---

## External Services
TBD - any third-party services the project depends on, what each is used
for, and where credentials are configured.

---

## Repository Structure
See `/ai/PROJECT.md` for the canonical project structure once defined.

---

## Architecture Rules

- Document new dependencies in `/ai/DECISIONS.md`.
- Document architecture changes via ADR before or during implementation.
- One canonical implementation per concern. If the same logic is needed in
  two places, extract to a shared module rather than duplicating.

---

## Open Architecture Questions
- TBD per-project (filled in during initialization)
