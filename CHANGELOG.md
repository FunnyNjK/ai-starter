# Changelog

Starter Version: 0.4.0
Last Updated: 2026-05-10

This changelog tracks the `ai-starter` template itself. Copied application
projects should maintain their own project changelog or release notes after
initialization.

## 0.4.0 - 2026-05-10

Big "fill the gaps" pass: license + tool-native memory hooks + workflow
+ behavior spec + budget + worked example + four more (Hard) rule blocks.

- Added `LICENSE` (MIT). The starter itself is now MIT-licensed; downstream
  projects choose their own license at init time (recorded as an ADR).
- Added tool-native memory hook files at the repo root that all point at
  `/ai/START_HERE.md`, so modern AI tools auto-load the workflow:
  `CLAUDE.md`, `AGENTS.md`, `.cursorrules`, `GEMINI.md`, and
  `.github/copilot-instructions.md`.
- Added `.github/pull_request_template.md` covering verification, security,
  cost, and rollback checklists.
- Added `/ai/WORKFLOW.md` defining branching, PR workflow, hotfix flow,
  conflict resolution, and the blocked-escalation pattern.
- Added `/ai/SPEC.md` for concrete behavior — user flows, edge cases,
  performance budgets, accessibility targets, compliance.
- Added `/ai/BUDGET.md` for monthly cost cap, alert thresholds, free-tier
  tracking, and cost-impacting change log.
- Added `/ai/EXAMPLE_PROJECT.md` — worked reference example showing what
  a fully-initialized project looks like.
- Added templates `/ai/templates/README.template.md`,
  `SECURITY.template.md`, `CONTRIBUTING.template.md`, and
  `INCIDENT_TEMPLATE.md` for project root docs and post-mortems.
- Added four new (Hard) rule blocks to `/ai/AI_RULES.md`:
  - **Cost Rules** — monthly cap + alerts at init, ADRs for cost-impacting
    changes, monthly review, never trade security for cost.
  - **Destructive Operations Rules** — confirm before deleting >50 lines,
    force-push, dropping tables, terminating cloud resources, rotating
    secrets, removing deps, etc.
  - **Reasoning Checkpoint Rules** — plan-first for multi-step / multi-file
    work, surface mid-task changes, pre-flight before destructive steps.
  - **Blocked Escalation Rule** — formal Blocked status with explicit
    blocker writeup; never silently work around.
- Updated `/ai/AI_RULES.md` Task Quality Rules to require Cost
  Considerations, Known Blockers, and prerequisite-respect.
- Restructured `/ai/templates/INIT_PROMPT.md` into 13 steps (was 9) —
  added budget setup, license selection, SPEC population, file
  generation for README / SECURITY / CONTRIBUTING, and tool-native
  memory hook verification.
- Updated `/ai/templates/CHAT_END_PROMPT.md` to require a **self-critique**
  section: assumptions made, things skipped/deferred, next-session
  double-checks, unresolved risks.
- Updated `/ai/templates/TASK_TEMPLATE.md` with `Cost Considerations`
  and `Known Blockers` sections.
- Updated `/ai/templates/REFRESH_PROMPT.md` from 7 to 10 checks: now
  also verifies tool-native memory hooks, root-level docs (LICENSE /
  SECURITY / CONTRIBUTING), `/ai/WORKFLOW.md` / `SPEC.md` / `BUDGET.md`
  presence, and per-task Task Quality compliance.
- Updated `/ai/START_HERE.md` to surface tool-native memory hooks in the
  header, list the new conditional-context files (`SPEC.md`, `BUDGET.md`,
  `WORKFLOW.md`, `EXAMPLE_PROJECT.md`), and reference `INIT_PROMPT.md`
  for the full init flow.
- Updated `/ai/PROJECT.md` and `/ai/ARCHITECTURE.md` to reference
  `SPEC.md`, `BUDGET.md`, the new (Hard) rule blocks, and the License
  section.
- Updated `README.md` to document all new files, the MIT license, and
  the tool-native memory hooks.

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
