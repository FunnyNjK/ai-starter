# Changelog

Starter Version: 0.3.0
Last Updated: 2026-05-10

This changelog tracks the `ai-starter` template itself. Copied application
projects should maintain their own project changelog or release notes after
initialization.

## 0.3.0 - 2026-05-10

- Added four new (Hard) rule blocks to `ai/AI_RULES.md`:
  - **Versioning Rules** — pin from canonical sources, no pre-releases,
    each major choice gets an ADR with version + verification date.
  - **Security Rules** — secrets only in env / secret managers, TLS only,
    battle-tested auth, argon2id passwords, deny-by-default authz, schema
    validation, redacted logging, dep scanning + SAST in CI, OIDC
    federation for cloud principals.
  - **Infrastructure & Hosting Rules** — AWS / Azure / Google Cloud only,
    Terraform (or OpenTofu) for all cloud resources, encrypted remote
    state, cloud-managed stateful services in QA + Production, container
    runtime for local dev only.
  - **Task Quality Rules** — every task has explicit Prerequisites,
    ordered steps when sequence matters, a Verification section, and
    Rollback / Recovery notes.
- Expanded `ai/templates/TASK_TEMPLATE.md` with Prerequisites,
  Step-by-Step Instructions, Verification, and Rollback / Recovery
  sections.
- Expanded `ai/templates/INIT_PROMPT.md` to nine steps, adding explicit
  version verification, infrastructure choices (cloud, IaC, state
  backend, managed services), the security baseline, and detailed
  ordered Phase-1 tasks.
- Expanded `ai/ARCHITECTURE.md` Security Model section with concrete
  prompts and added a new Infrastructure & Hosting section.
- Expanded `ai/PROJECT.md` with Security Baseline and Infrastructure
  sections that point at the corresponding ADRs.

## 0.2.0 - 2026-05-10

- Removed all opinionated defaults (tech stack, OS, hosting provider, CI
  system, third-party services, package manager). The starter is now stack-
  and platform-agnostic.
- Generalized planning files, templates, and prompts to apply to any
  software development project.
- Replaced pre-populated stack-specific ADRs with a single ADR template;
  project-specific ADRs are added during initialization.

## 0.1.0 - 2026-05-04

- Documented the starter/template status in `README.md`.
- Added root ignore rules for generated `ai/logs/` phase-run output.
- Added the first starter changelog/version marker.
- Added a bootstrap checklist to the project initialization prompt.
- Changed startup context loading to a Fast Context core plus Conditional
  Context docs.
