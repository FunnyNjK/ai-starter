# Changelog

Starter Version: 0.6.1
Last Updated: 2026-05-13

This changelog tracks the `ai-starter` template itself. Copied application
projects should maintain their own project changelog or release notes after
initialization.

## 0.6.1 - 2026-05-13

- **Task-completion automation** (`scripts/mark-task-done.py`). Helper script that reliably finds a task block in `TASKS.md`, removes it, and appends the title to `DONE_LOG.md` under the current date. Prevents markdown-parsing errors during autonomous task completion.
- **Configurable git push behavior** (`SYNC_MODE=batch`). The shared phase harness now respects `SYNC_MODE=batch` or `RUN_PHASE_NO_PUSH=1` to skip pushing after every commit. Useful for rapid, autonomous iterations without network latency or CI clutter. Documented the override in `AI_RULES.md`.
- **Default security CI workflow**. Added `ai/templates/ci-security.template.yml` for Day-1 Dependabot and SAST scanning, and wired `INIT_PROMPT.md` to scaffold it automatically.

## 0.6.0 - 2026-05-13

Tighten the harness, give the kit a real lint surface, and make web-app
path choice an explicit step.

- **Shared phase-script library** (`scripts/run-phase-lib.sh`). The four
  AI-CLI adapters (`run-phase.sh`, `run-phase-codex.sh`,
  `run-phase-cursor.sh`, `run-phase-copilot.sh`) stay separate — each
  CLI has its own flag set and version churn — but now share
  log-dir setup, prompt strings, commit-subject extraction, and safe
  staging. The intent is documented in the library header so future
  refactors don't collapse the adapters.

- **Safe staging (no more `git add -A`).** The shared library
  enumerates exactly the paths git considers changed this session and
  refuses, fail-closed, to stage anything that looks like a secret,
  credential, key, certificate, local DB, or backup. Optional
  `RUN_PHASE_ALLOWLIST_REGEX` further restricts staging to a subtree.
  `RUN_PHASE_FORCE_UNSAFE=1` is the (loudly-warning) override.
  Unattended mode is preserved — push-after-commit and stop-on-push-
  failure semantics from the AI_RULES.md Git Rules are unchanged.

- **Planning linter** (`scripts/lint-planning.py`, Python stdlib only).
  Machine-readable check of the Task Quality and Planning-File Hygiene
  Hard Rules: every task in `TASKS.md` has the required H4 subsections
  (Goal, Prerequisites, Scope Included/Excluded, Acceptance Criteria,
  Verification, Test Requirements, Security / Cost Considerations,
  Rollback / Recovery, Known Blockers, Dev Environment Constraints,
  Handoff Notes) plus the metadata header (Status, Owner, Priority);
  every ADR in `DECISIONS.md` has Date, Status, Decision, Reason,
  Tradeoffs, Related Tasks; every planning file has a `Last Updated`
  line; `CURRENT_STATE.md` ≤ 80 lines and `HANDOFF.md` ≤ 50 lines.

- **CI workflow** (`.github/workflows/lint.yml`) — runs `shellcheck`
  on all four phase scripts plus the shared library, and runs the
  planning linter on every push and pull request.

- **Web-app decision tree** (`docs/CHOOSING_WEBAPP_PATH.md`). Mermaid
  diagram + checklist covering static marketing, docs, SPAs, CRUD,
  SaaS, AI apps, e-commerce / marketplace, realtime / collaboration,
  internal dashboards, public / private / internal / sensitive
  surfaces, auth / payments / user data / external APIs / AI cost /
  realtime / admin / deployment shape. Linked from README. The
  kickoff interview already asks these questions; this is the map
  behind them.

- **Docs**: README now lists the lint command, the shared library, and
  the new decision-tree doc as part of the kit. README's "manual
  setup" file list calls out the new artifacts.

## 0.5.5 - 2026-05-10

Make the kit actually build the app the user describes — not just
infrastructure that *could* host one.

**Problem this fixes**: the first real init (`secure-app-template`)
ended up planning ~14 Phase-2 tasks that were all foundation work
(auth, API skeleton, worker skeleton, GDPR controls, observability,
billing-flagged-off) and zero product features. The user's
description ("a B2C consumer SaaS foundation") was infrastructure-
shaped — and the AI took it literally. After Phase 2, there was no
actual product to ship; just a chassis ready to host one.

The fix: the kickoff interview and INIT/ADOPT actors now refuse
foundation-shaped and architecture-only application descriptions, and
loop with the user until they describe what end users actually *do*
with the app.

- **`ai/templates/KICKOFF_NEW_PROJECT.md` Question 1**: now strict.
  Asks "What does the app DO for users?" and gives concrete
  feature-loop examples. REJECTS:
  - Foundation / template / starter / scaffold / base / skeleton /
    boilerplate language without a concrete user-facing product.
  - Architecture-only listings (lists of surfaces, services,
    technologies) without saying what users *do*.

  Loops with a clarifying question until the answer is product-shaped
  ("users sign up, [verb] [object], and get [outcome]"). If the user
  insists they only want a foundation, the interview stops and reports
  back — `ai-starter` itself already plays that role.

- **`ai/templates/KICKOFF_EXISTING_PROJECT.md` Step 4 purpose
  question**: same logic applied when reading the existing README or
  asking the user. Existing architecture becomes supporting
  infrastructure under feature work, not the product itself.

- **`ai/templates/INIT_PROMPT.md` Step 2** (new) — application-
  description validation gate. Refuses to proceed past Step 2 if the
  description is foundation- or architecture-shaped. Loops with the
  user, or marks the task `Blocked` if no product can be articulated.
  Subsequent steps renumbered (Step 3 = tech stack ... Step 15 = env
  vars; total 15 steps, was 14).

- **`ai/templates/ADOPT_PROMPT.md` Step 3 `/ai/PROJECT.md` section**:
  validates the inferred application description before populating
  `PROJECT.md`. If the existing README is foundation/architecture-
  shaped AND the user can't articulate a real feature loop, the adopt
  stops and surfaces the gap rather than inventing features.

## 0.5.4 - 2026-05-10

Downstream-init hygiene pass — fixes patterns that caused
starter-template residue to leak into the first real project initialized
from this kit (`secure-app-template`).

- **`ai/DONE_LOG.md` ships empty.** Previously held the starter's own
  release notes, which downstream projects inherited verbatim. Now
  contains only a placeholder + a note explaining that the starter's
  own release history lives in `CHANGELOG.md` and git tags. Init seeds
  the first entry (P0-T1) per project.
- **INIT_PROMPT and ADOPT_PROMPT gain a new "replace starter-history
  files and remove starter-setup files" step** (INIT Step 12, ADOPT
  Step 6). It instructs the AI to:
  - Replace `CHANGELOG.md` (currently the starter's release log) with
    a fresh project changelog scaffolding. ADOPT detects existing
    project-specific content and leaves it alone.
  - Delete `ai/templates/KICKOFF_NEW_PROJECT.md`,
    `KICKOFF_EXISTING_PROJECT.md`, `INIT_PROMPT.md`, `ADOPT_PROMPT.md`,
    `README.template.md`, `SECURITY.template.md`,
    `CONTRIBUTING.template.md`, `ai/EXAMPLE_PROJECT.md`, and
    `ai/reference/PROMPT_LIBRARY.md` after their job is done.
  - Keep `REFRESH_PROMPT.md`, `TASK_TEMPLATE.md`, `INCIDENT_TEMPLATE.md`,
    `CHAT_END_PROMPT.md`, `CURRENT_STATE.template.md`, and
    `HANDOFF.template.md` (all useful post-init).
- **AI_RULES.md Planning-File Hygiene Rule: commit SHA is now optional
  in `DONE_LOG.md` entries.** Previously the rule said entries must
  include "key commit hash(es)", but the end-of-chat ritual writes
  entries *before* the commit, so the SHA isn't known yet — producing
  `commit: pending` placeholders that go stale. New rule: task ID and
  title are required; commit hash is recommended when already known but
  `git log --grep=<task-id>` recovers it. Never write
  `commit: pending`.
- **`ai/templates/TASK_TEMPLATE.md` heading levels fixed.** Subsections
  were `##` (H2), which jumped *above* the task title (`###`, H3) when
  rendered inside `TASKS.md`. Now `####` (H4), correctly nested.
- **`ai/templates/CONTRIBUTING.template.md` branching section** now
  explicitly lists all four AI-harness branch prefixes (`claude/`,
  `cursor/`, `codex/`, `copilot/`). Previously the AI improvised when
  generating downstream CONTRIBUTING.md.

## 0.5.3 - 2026-05-10

Team-review fixes — seven issues across P1/P2/P3 priorities resolved.

P1:
- **`run-phase-codex.sh`**: split shared `CODEX_FLAGS` into separate
  `CODEX_EXEC_FLAGS` (for `codex exec`) and `CODEX_RESUME_FLAGS` (for
  `codex exec resume --last`) since the two commands accept different
  flag sets. Dropped the hardcoded `--ask-for-approval never` (flag
  name varies by Codex version); replaced with an opt-in
  `RUN_PHASE_CODEX_APPROVAL_FLAG` env var so users can supply whatever
  their installed CLI accepts. Default flags are now just
  `--sandbox workspace-write`, the most universally supported.
- **`run-phase.sh`**: dropped hardcoded `--max-turns 100` (not
  supported in all Claude Code versions). Made it opt-in via
  `RUN_PHASE_CLAUDE_MAX_TURNS` env var; default is no turn cap.
- **`ai/TASKS.md` P0-T1**: expanded the live starter task to match
  `TASK_TEMPLATE.md` — added Prerequisites, Step-by-Step Instructions,
  concrete Verification, Security / Cost Considerations, Rollback /
  Recovery, Known Blockers, Handoff Notes. Resolves the embarrassment
  of the starter's own first task violating its own Hard rules.

P2:
- **`ai/EXAMPLE_PROJECT.md`**: replaced concrete future-dated versions
  (e.g. "TypeScript 5.7.2 verified 2026-05-12") with placeholder
  patterns (`<X.Y.Z>`, `<YYYY-MM-DD>`) and added a banner clarifying
  that all versions and dates are illustrative; real init verifies live
  from canonical sources. Stops users from copy-pasting stale pins.
- **`.gitattributes`** added: `* text=auto eol=lf` plus explicit
  `*.sh text eol=lf` and `*.md text eol=lf`. Prevents `core.autocrlf=true`
  on Windows from corrupting bash scripts.

P3:
- **`ai/HANDOFF.md`**: trimmed from 51 to 43 lines (under the ≤50
  target) and updated "Important Instructions for Next AI" to prefer
  the KICKOFF interview over direct `INIT_PROMPT.md`.
- **Release tags**: tagging `v0.5.2` retroactively at commit `f700530`
  and `v0.5.3` at this commit. Pushed alongside.

## 0.5.2 - 2026-05-10

Audit pass — drift cleanup found in a complete review:

- Deleted `ai/templates/CHAT_START_PROMPT.md`. Orphan file with zero
  inbound references and a stale conditional-context list (missing
  `SPEC.md`, `BUDGET.md`, `WORKFLOW.md`, `EXAMPLE_PROJECT.md`).
  Redundant with `/ai/START_HERE.md` plus the tool-native memory
  hooks.
- Updated `ai/templates/INIT_PROMPT.md` "sister documents" intro to
  list all three siblings (INIT, ADOPT, REFRESH); previously only
  mentioned INIT and REFRESH because it predated ADOPT.
- Removed stale `Do NOT modify /DEVELOPER-NOTES.md` line from
  `ai/templates/ADOPT_PROMPT.md`. `DEVELOPER-NOTES.md` was deleted
  back in v0.2.0; the reminder was harmless but obsolete.
- Added a "sister documents" intro to `ai/templates/REFRESH_PROMPT.md`
  matching the shape of INIT and ADOPT; routes users to ADOPT for
  in-place existing apps without `/ai/` and to INIT/KICKOFF for new
  projects.
- De-Tommyfied the free-tier examples in `ai/AI_RULES.md` Cost Rules
  (was "Postmark's 100/month, Cloudflare's free SSL"; now generic
  examples like email-API send caps, CDN bandwidth, DB row limits).

## 0.5.1 - 2026-05-10

- Closed first-mile UX gap: `/ai/START_HERE.md` Section 4 now routes
  users to the friendly `KICKOFF_*` interview prompts by default
  instead of `INIT_PROMPT.md` directly. The direct prompts are still
  available for users who explicitly opt out of the interview. This
  ensures users who never read the README still land in the foolproof
  entry path when an AI tool auto-loads `START_HERE.md` via a
  tool-native memory hook.

## 0.5.0 - 2026-05-10

First-mile UX: friendly interview prompts for new users plus a third
sibling actor for the brownfield retrofit case.

- Added `/ai/templates/KICKOFF_NEW_PROJECT.md` — paste-and-go interview
  prompt for greenfield projects. Asks one question at a time with
  examples and "I don't know — pick a sensible default" at every step,
  then generates a customized `INIT_PROMPT.md` invocation.
- Added `/ai/templates/KICKOFF_EXISTING_PROJECT.md` — interview prompt
  for adopting the kit into an existing app. Inspects the project
  first, then asks only what can't be inferred, then routes to either
  `ADOPT_PROMPT.md` (catch up) or `INIT_PROMPT.md` (start fresh).
- Added `/ai/templates/ADOPT_PROMPT.md` — third sibling alongside INIT
  and REFRESH. Reverse-engineers `/ai/` planning files from an
  existing project's manifests / lockfiles / configs / framework
  conventions. Backfills retroactive ADRs. Identifies gaps against
  the Hard rules and queues them as Phase-1 catch-up tasks. Does not
  modify application code.
- Updated `README.md` with a "First time? Pick your starting point"
  fork at the top — the `KICKOFF_*` prompts are now the foolproof
  entry point, with direct paths for confident users who want to skip
  the interview.

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
