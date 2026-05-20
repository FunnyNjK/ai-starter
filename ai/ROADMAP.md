# Roadmap

Last Updated: 2026-05-20

Phase ordering is fixed by the Local-First Development Rule in
`/ai/AI_RULES.md`. A working local app comes before CI; a working
local app + working CI comes before deploy planning; deploy planning
comes before any cloud-resource provisioning. Phase-3 has a hard
gate (P3-T0 must complete before any Phase-4 task starts).

## Phase 0: Project Initialization
Status: Ready

Goals:
- Convert starter files into project-specific planning files.
- Define application scope (components, tier, feature loop).
- Choose and record the **local-development** tech stack as ADRs in
  `/ai/DECISIONS.md` (language, framework, DB engine family, ORM,
  auth library, schema validation, test runner, lint/format, package
  manager, local container runtime, license).
- Capture **free-tier ceilings** in `/ai/BUDGET.md` for any third-
  party services chosen at init.
- Queue first implementation tasks (Phase 1) plus the P3-T0 deploy-
  planning task (Backlog).

Deliverables:
- `PROJECT.md` filled in (name, description, goals, non-goals,
  components, tier, rules-in-force, local-stack).
- `CURRENT_STATE.md` reflects "scaffold not yet built."
- Project-specific ADRs for each major LOCAL choice. NO cloud /
  IaC / managed-service / OIDC / budget-cap ADRs yet — those are
  P3-T0's job.
- Phase-1 task block queued in `TASKS.md` (scaffold, verify local
  green, CI mirrors local, Dependabot, root docs).
- P3-T0 task block queued in `TASKS.md` Backlog with
  `Prerequisites: Phase-2 done`.

## Phase 1: Foundation
Status: Backlog

Goals (in order — enforced by the Local-First Development Rule):
1. Scaffold the project per the chosen stack.
2. **Local `dev` / `run` / `start` command works** on the
   developer's machine.
3. **Local lint, type-check (if applicable), test, and build all
   pass** on the developer's machine.
4. Configure lint/format/test/build tooling files committed.
5. CI workflow that mirrors steps 2-3 passes on push.

Deliverables (in order):
- The project's standard "run locally" command works **first**.
- The project's lint, type-check, test, and build commands all pass
  locally **second**.
- CI passes on push **last**, mirroring what step 2-3 already proved
  locally. The first CI run is expected to pass on the first try.

Phase-1 explicitly does NOT include:
- Cloud / IaC bootstrap.
- OIDC trust to a cloud.
- First production deploy.
- Cloud budget + alert wiring.

All of the above are P3-T0 → Phase-4 work, not Phase 1.

## Phase 2: Core Feature Buildout
Status: Backlog

Goals:
- Build the primary features described in `PROJECT.md` / `SPEC.md`.
- Every feature ships with passing local tests (per the Local-First
  Development Rule, local-green-before-CI applies throughout
  development, not just at scaffold time).

Deliverables:
- TBD per project, but each feature lands with: local run still
  works, local tests still pass, CI green.

## Phase 3: Hardening, Testing, and Deploy Planning
Status: Backlog

Goals:
- Test coverage targets met.
- Error handling reviewed.
- Accessibility / performance / security passes as appropriate.
- **Deploy Planning (P3-T0)**: write the cloud / IaC / managed-
  service / OIDC / runtime-secret-store / network-defaults /
  budget-cap ADRs that were deferred at init. Queue Phase-4
  implementation tasks.

### Deploy Planning sub-section (P3-T0)

Per the Local-First Development Rule, deploy ADRs are written
here, not at init. P3-T0 produces:

- Cloud target ADR (AWS / Azure / Google Cloud).
- IaC tool + state backend ADRs.
- Managed-service instance ADRs (one per stateful dep — engine
  major versions match what was pinned locally at Phase 1).
- Runtime secret store ADR.
- OIDC federation ADR for CI → cloud auth.
- Network defaults ADR (subnets, security groups, ingress).
- Environment-parity policy ADR.
- BUDGET.md Cost-Rules-compliant cap + alert thresholds + Major
  cost contributors table (live pricing lookups) + Cost-impacting
  changes log scaffolding.
- Phase-4 implementation task queue (P4-T1..P4-T5+).

**Hard gate**: no Phase-4 task may move to `Ready` until P3-T0 is
`Done`.

## Phase 4: Deployment and Operations
Status: Backlog

Prerequisites: P3-T0 (Deploy Planning) is Done.

Goals:
- Execute the Phase-4 task queue produced by P3-T0:
  - P4-T1: Terraform state backend bootstrap.
  - P4-T2: OIDC trust between CI and cloud.
  - P4-T3: First IaC apply (minimal account / project scaffold —
    networking, secret store, log destination, IAM baseline).
  - P4-T4: First production deploy of the app.
  - P4-T5: Cloud budget + alert wiring per BUDGET.md.
  - Plus any production-tier additions (on-call rotation, SLO/SLI
    targets, DR runbook, multi-region/replica plan).
- Document release process and rollback plan.

Deliverables:
- Live deployment.
- Production credentials in the chosen secret store.
- Rollback plan tested at least once.
- Cloud budget alerts firing correctly at thresholds.

## Phase 5: Enhancements
Status: Backlog

Goals:
- Per-project optional improvements after the core app is stable
  and deployed.
