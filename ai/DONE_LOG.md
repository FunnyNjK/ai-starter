# Done Log

Last Updated: 2026-05-10

## 2026-05-10

### Starter v0.5.2 — audit cleanup
Full-repo audit found five low-severity drift issues; all fixed:
- Deleted orphan `ai/templates/CHAT_START_PROMPT.md` (zero inbound
  references; stale conditional-context list).
- Updated `INIT_PROMPT.md` sister-documents list to include ADOPT
  (was a v0.5.0 oversight).
- Removed stale `DEVELOPER-NOTES.md` reminder from `ADOPT_PROMPT.md`
  (file deleted in v0.2.0).
- Added consistent "sister documents" intro to `REFRESH_PROMPT.md`.
- Replaced specific Postmark/Cloudflare free-tier examples in
  `AI_RULES.md` Cost Rules with generic ones.

### Starter v0.5.1 — close the first-mile UX gap
- Updated `/ai/START_HERE.md` Section 4: when an uninitialized
  starter is detected, the AI now recommends the friendly
  `KICKOFF_*` interview prompts by default instead of going straight
  to `INIT_PROMPT.md`. Direct paths remain available for users who
  explicitly opt out. Ensures the foolproof flow is reached even when
  users skip the README and rely on tool-native memory hooks.

### Starter v0.5.0 — first-mile UX
- Added `/ai/templates/KICKOFF_NEW_PROJECT.md` — interview prompt for
  greenfield projects. One question at a time, sensible defaults at
  every step, generates a customized `INIT_PROMPT.md` invocation.
- Added `/ai/templates/KICKOFF_EXISTING_PROJECT.md` — interview prompt
  for adopting the kit into an existing app. Inspects first, asks only
  what can't be inferred, routes to ADOPT (catch up) or INIT (start
  fresh).
- Added `/ai/templates/ADOPT_PROMPT.md` — third sibling actor (with
  INIT and REFRESH). Reverse-engineers planning files from existing
  code, backfills retroactive ADRs, queues catch-up tasks for gaps
  against Hard rules. Does not modify application code.
- Updated `README.md` with a "First time? Pick your starting point"
  fork at the top — `KICKOFF_*` prompts are now the foolproof entry
  point.

### Starter v0.4.0 — gap-fill hardening
- Added `LICENSE` (MIT) at repo root.
- Added tool-native memory hooks at the repo root all pointing at
  `/ai/START_HERE.md`: `CLAUDE.md`, `AGENTS.md`, `.cursorrules`,
  `GEMINI.md`, and `.github/copilot-instructions.md`.
- Added `.github/pull_request_template.md` with verification, security,
  cost, and rollback checklists.
- Added `/ai/WORKFLOW.md` defining branching strategy, PR workflow,
  hotfix workflow, blocked / escalation pattern, and conflict
  resolution.
- Added `/ai/SPEC.md` placeholder for concrete behavior — user flows,
  edge cases, performance budgets, accessibility, compliance.
- Added `/ai/BUDGET.md` placeholder for monthly cost cap, alert
  thresholds, free-tier limits, cost-impacting change log.
- Added `/ai/EXAMPLE_PROJECT.md` — worked reference example showing
  what a fully-initialized project looks like.
- Added templates `/ai/templates/README.template.md`,
  `SECURITY.template.md`, `CONTRIBUTING.template.md`, and
  `INCIDENT_TEMPLATE.md`.
- Added four new (Hard) rule blocks to `/ai/AI_RULES.md`: Cost Rules,
  Destructive Operations Rules, Reasoning Checkpoint Rules, Blocked
  Escalation Rule. Strengthened Task Quality Rules.
- Restructured `/ai/templates/INIT_PROMPT.md` into 13 steps; added
  budget, license, SPEC, root-doc generation, and tool-native memory
  hook verification.
- Updated `/ai/templates/CHAT_END_PROMPT.md` to require a self-critique
  section.
- Expanded `/ai/templates/TASK_TEMPLATE.md` with Cost Considerations
  and Known Blockers.
- Updated `/ai/templates/REFRESH_PROMPT.md` from 7 to 10 checks.
- Updated `/ai/START_HERE.md`, `/ai/PROJECT.md`, `/ai/ARCHITECTURE.md`,
  and `README.md` to reference the new files and license.

### Starter v0.3.0 — versioning, security, infra, task quality (Hard)
- Added Versioning Rules, Security Rules, Infrastructure & Hosting
  Rules, Task Quality Rules to `/ai/AI_RULES.md`.
- Restructured INIT_PROMPT.md with version verification, infrastructure
  choices, and security baseline steps.
- Expanded TASK_TEMPLATE, ARCHITECTURE, PROJECT to support the new
  rules.

### Starter v0.2.0 — stack-agnostic
- Removed all opinionated defaults (Tommy's Edition WSL/Astro/Azure
  stack). Generalized planning files, templates, prompts.
- Replaced pre-populated stack-specific ADRs with a single ADR template.
- Harmonized the four phase-run harnesses (Claude, Cursor, Codex,
  Copilot) and added pre-flight CLI checks, optional model env vars,
  tagged log directories.

### Starter v0.1.0 — initial
- Created the generic AI project starter (`/ai` workflow only).
- Added `/ai/START_HERE.md` as the single AI entry point.
- Added cross-project rules in `/ai/AI_RULES.md`.
- Added project planning, architecture, task, testing, deployment,
  decision, and handoff files as TBD placeholders.
- Added templates for chat start/end, init, refresh, task, current
  state, and handoff under `/ai/templates`.
