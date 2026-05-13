# Tasks

Last Updated: 2026-05-13

## Active Task
None

---

## Ready

### P0-T1: Initialize project-specific AI files
Status: Ready
Owner: AI Assistant
Priority: High

#### Goal
Use the user's application description to convert this starter system
into a project-specific planning and tracking system. Choose and record
the project's tech stack, infrastructure, security baseline, budget,
and license as ADRs.

#### Prerequisites
- none

#### Scope Included
- Update `/ai/PROJECT.md` (name, description, goals, non-goals, target
  users, tech stack)
- Update `/ai/CURRENT_STATE.md`
- Update `/ai/ARCHITECTURE.md` with the project's intended design
- Update `/ai/SPEC.md` with concrete user flows, edge cases,
  performance budgets, accessibility, compliance
- Update `/ai/ROADMAP.md` with project-specific milestones
- Create initial implementation tasks in `/ai/TASKS.md` (every task
  follows `/ai/templates/TASK_TEMPLATE.md` — Prerequisites,
  Verification, Rollback / Recovery, etc.)
- Update `/ai/TESTING.md` with the chosen test strategy
- Update `/ai/DEPLOYMENT.md` with the chosen hosting / CI approach
- Update `/ai/DEV_ENVIRONMENT.md` with the chosen dev setup
- Update `/ai/BUDGET.md` with the monthly cap and alert thresholds
- Add project-specific ADRs to `/ai/DECISIONS.md` for each major choice
  (language, framework, package manager, test runner, cloud, IaC,
  managed services, license, etc.) per the Versioning Rules in
  `/ai/AI_RULES.md`
- Create `LICENSE`, `README.md`, `SECURITY.md`, `CONTRIBUTING.md` at
  the project root from the templates in `/ai/templates/`
- Confirm tool-native memory hooks at the project root (`CLAUDE.md`,
  `AGENTS.md`, `.cursorrules`, `GEMINI.md`,
  `.github/copilot-instructions.md`)
- Update `/ai/HANDOFF.md`

#### Scope Excluded
- Do not create application code yet (P1-T1).
- Do not install dependencies yet (P1-T1).
- Do not configure hosting resources yet (later Phase-1 task).
- Do not create production secrets ever during init.

#### Step-by-Step Instructions
Follow `/ai/templates/INIT_PROMPT.md` end-to-end. The 13 steps in that
prompt enforce the right ordering: read AI files first, then choose
stack with version verification, then infra, then security baseline,
then budget, then license, then (if migrating) old-repo inspection,
then design direction, then SPEC, then planning files + tasks, then
tool-native memory hook check, then migration inventory, then env vars.

For the friendliest path, use the kickoff interview prompt that
generates a customized version of `INIT_PROMPT.md`:
- New project: `/ai/templates/KICKOFF_NEW_PROJECT.md`
- Existing app: `/ai/templates/KICKOFF_EXISTING_PROJECT.md` (which
  may route to `ADOPT_PROMPT.md` instead for the catch-up path)

#### Acceptance Criteria
- All TBD sections in `PROJECT.md` are replaced with project-specific
  content or intentionally marked as open questions.
- A project-appropriate set of Phase-1 tasks is queued, each meeting
  the Task Quality Rules in `/ai/AI_RULES.md`.
- Project boundaries and non-goals are documented.
- Each major architecture, security, infrastructure, and license
  choice has a corresponding ADR with the version (where applicable),
  date verified, and canonical source URL.
- `LICENSE`, `README.md`, `SECURITY.md`, `CONTRIBUTING.md` exist at
  the project root.
- All five tool-native memory hooks exist at the project root.
- `CURRENT_STATE.md` ≤ 80 lines; `HANDOFF.md` ≤ 50 lines.

#### Verification
- `git ls-files | grep -E '^(LICENSE|README\.md|SECURITY\.md|CONTRIBUTING\.md|CLAUDE\.md|AGENTS\.md|\.cursorrules|GEMINI\.md|\.github/copilot-instructions\.md)$' | wc -l` returns `9`.
- Every section in `/ai/PROJECT.md` has been edited (no `TBD` remaining
  except where flagged as an open question).
- `/ai/DECISIONS.md` has at least one ADR per major stack / infra /
  security / license choice.
- The first task in `/ai/TASKS.md` after P0-T1 has all sections from
  `/ai/templates/TASK_TEMPLATE.md` populated.
- `wc -l /ai/CURRENT_STATE.md /ai/HANDOFF.md` reports both under their
  caps.

#### Test Requirements
Not applicable — planning-only task.

#### Security Considerations
- Use placeholders, never real secrets, in any committed file.
- Do not record actual API keys or passwords during init.
- Honor the Security Rules in `/ai/AI_RULES.md` when choosing the
  security baseline (auth, hashing, schema validation, logging
  redaction, OIDC, etc.).

#### Cost Considerations
- This task creates no cloud resources, so no direct cost impact. But
  the choices made here (cloud target, managed-service tier picks,
  free-tier reliance) determine future cost trajectory. Honor the
  Cost Rules in `/ai/AI_RULES.md` when filling in `/ai/BUDGET.md`.

#### Rollback / Recovery
- All changes in this task are documentation-only (no code, no
  infrastructure). If init goes wrong, `git reset --hard <pre-init
  commit>` restores the starter to its uninitialized state. Then re-run
  the kickoff interview with corrected answers.

#### Known Blockers
- Application description not provided by the user → mark task
  `Blocked` per the Blocked Escalation Rule and ask for it.
- User wants a stack, cloud, or service that violates a (Hard) rule
  without a written ADR override → mark `Blocked` and surface the
  conflict.

#### Dev Environment Constraints
- None for the planning step. P1-T1 (scaffold) will set this up.

#### Handoff Notes
- After P0-T1 closes, the next session reads `HANDOFF.md` and starts
  on P1-T1 (scaffold) per the queued Phase-1 task list.

---

## Backlog
None — Phase-1 tasks are added during P0-T1.

---

## Blocked
None

## Review
None

## Done
None
