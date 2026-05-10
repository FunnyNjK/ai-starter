# Roadmap

Last Updated: 2026-05-10

## Phase 0: Project Initialization
Status: Ready

Goals:
- Convert starter files into project-specific planning files.
- Define application scope.
- Choose and record the tech stack as ADRs in `/ai/DECISIONS.md`.
- Create first implementation tasks.

Deliverables:
- `PROJECT.md` filled in (name, description, goals, non-goals, stack).
- `CURRENT_STATE.md` reflects "scaffold not yet built."
- Project-specific ADRs added for each major architecture choice.
- First implementation tasks queued in `TASKS.md`.

## Phase 1: Foundation
Status: Backlog

Goals:
- Scaffold the project per the chosen stack.
- Configure lint, format, type-check (if applicable), and test tooling.
- Add `.gitignore`, project-level `README.md`, and any required env-var
  example file.
- First passing CI run on a placeholder entry point.

Deliverables:
- The project's standard "run locally" command works.
- The project's lint, type-check, test, and build commands all pass.
- CI passes on push.

## Phase 2: Core Feature Buildout
Status: Backlog

Goals:
- Build the primary features described in `PROJECT.md`.

Deliverables:
- TBD per project.

## Phase 3: Hardening and Testing
Status: Backlog

Goals:
- Test coverage targets met.
- Error handling reviewed.
- Accessibility / performance / security passes as appropriate.

## Phase 4: Deployment and Operations
Status: Backlog

Goals:
- Configure target hosting environment.
- First production deploy.
- Document release process and rollback plan.

Deliverables:
- Live deployment.
- Production credentials configured.
- Rollback plan tested at least once.

## Phase 5: Enhancements
Status: Backlog

Goals:
- Per-project optional improvements after the core app is stable.
