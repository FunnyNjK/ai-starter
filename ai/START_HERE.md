# START HERE - AI Project Control File

Last Updated: 2026-05-10

This is the only file an AI assistant needs to read first.

After reading this file, the AI must follow the instructions below and
reference the supporting files in `/ai` as needed.

> **Tool-native memory hooks** at the project root (`CLAUDE.md`,
> `AGENTS.md`, `.cursorrules`, `.github/copilot-instructions.md`,
> `GEMINI.md`) all point here. If your AI tool auto-loaded one of those,
> you're in the right place.

---

## 1. Purpose

This repository uses an AI-assisted development workflow. The `/ai` folder is
the project memory: planning, architecture, tasks, testing, deployment,
decisions, and handoff.

The goal is to let any capable AI assistant quickly understand:

- What the project is
- What has already been built
- What is currently being worked on
- What still needs to be done
- What architectural decisions have been made (and which are non-negotiable)
- What tests and validation are required
- What the next task should be

---

## 2. Required AI Behavior

Every AI assistant working in this project must:

1. Read this file first.
2. Then read the Fast Context files listed in the Context Loading Strategy.
   Load Conditional Context files only when the current task needs them.
3. Summarize the current project state before making changes.
4. Work only on the assigned task unless explicitly told otherwise.
5. Avoid project creep.
6. Update the relevant `/ai` files before ending the chat or task.
7. Never claim work is complete unless tests, checks, or validation steps are
   clearly documented.
8. If a decision changes architecture, scope, data model, security, deployment,
   or dependencies, update `/ai/DECISIONS.md`.
9. Honor the hard rules in `/ai/AI_RULES.md`. If `/ai/DEV_ENVIRONMENT.md` has
   been filled in for this project, load it before changing tooling, package
   management, dev setup, CI, deployment, or environment assumptions.

---

## 3. Context Loading Strategy

Use fast context by default. The goal is to give the AI enough project state
to start safely without spending the whole context window on reference docs.

### Fast Context - read every session

After this file, read these files in order:

1. `/ai/CURRENT_STATE.md`
2. `/ai/HANDOFF.md`
3. `/ai/TASKS.md`
4. `/ai/AI_RULES.md`

These files should stay compact enough to orient a new session quickly.

### Conditional Context - read only when needed

Load these files when the current task touches their area:

- `/ai/PROJECT.md` - project identity, target users, goals, non-goals,
  first-time initialization, README/project-description work.
- `/ai/ARCHITECTURE.md` - system design, data flow, API boundaries,
  component structure, security model, or architecture changes.
- `/ai/SPEC.md` - concrete behavior, user flows, edge cases, performance
  budgets, accessibility targets, compliance. Load for any feature task.
- `/ai/ROADMAP.md` - phase planning, prioritization, new task creation, or
  scope beyond the current task.
- `/ai/TESTING.md` - test strategy, acceptance validation, coverage, CI test
  failures, or behavior changes that need tests.
- `/ai/DEPLOYMENT.md` - hosting, CI/CD, environment variables, secrets,
  domains, release, or rollback work.
- `/ai/BUDGET.md` - cost ceilings, alert thresholds, free-tier limits.
  Load before adding cloud resources or scaling existing ones.
- `/ai/WORKFLOW.md` - branching, PRs, hotfixes, blocked-escalation. Load
  for any process or workflow question.
- `/ai/DECISIONS.md` - dependency, architecture, security, deployment,
  data-model, or scope decisions. Prefer reading the relevant ADR section
  instead of the whole history when the task is narrow.
- `/ai/DEV_ENVIRONMENT.md` - tooling, package management, shell, editor
  setup, or environment troubleshooting.
- `/ai/DONE_LOG.md` - historical implementation details when needed to
  understand why completed work happened. Do not load it by default.
- `/ai/EXAMPLE_PROJECT.md` - reference example of a fully-initialized
  project. Load only for orientation; never copy its content into a
  real project.
- `/ai/reference/*` - inactive reference material. Load only when the user
  explicitly asks about it.

### Full Context

Read all planning files only for first-time project initialization, refresh
passes, broad audits, architecture reviews, or when the user explicitly asks
for a whole-project review.

If any required Fast Context file is missing, create it from the matching
template in `/ai/templates`. If a needed Conditional Context file is missing
and no template exists, ask before inventing a new permanent planning file.

---

## 4. First-Time Project Initialization

If the project is still a starter project (PROJECT.md still has TBD
sections or "Project Name: TBD"), the AI must STOP and recommend the
friendly entry point instead of starting work directly:

> "This looks like a fresh `ai-starter` project that hasn't been
> initialized yet. The friendliest path is to run one of the kickoff
> interviews — they'll ask you the right questions one at a time and
> generate a customized setup prompt for you:
>
> - **New project (greenfield)** → `/ai/templates/KICKOFF_NEW_PROJECT.md`
> - **Adopting into an existing app** → `/ai/templates/KICKOFF_EXISTING_PROJECT.md`
>
> Want me to run one of those now? If you already know exactly what you
> want and would rather skip the interview, I can run
> `/ai/templates/INIT_PROMPT.md` (greenfield) or
> `/ai/templates/ADOPT_PROMPT.md` (brownfield retrofit) directly."

Only proceed with `INIT_PROMPT.md` / `ADOPT_PROMPT.md` directly if the
user explicitly opts out of the interview. Defaulting to the interview
is the foolproof path; the direct prompts are for confident users who
know what they want.

Whichever path is taken, the initialization process must update:

- `/ai/PROJECT.md`
- `/ai/CURRENT_STATE.md`
- `/ai/ARCHITECTURE.md`
- `/ai/SPEC.md`
- `/ai/ROADMAP.md`
- `/ai/TASKS.md`
- `/ai/TESTING.md`
- `/ai/DEPLOYMENT.md`
- `/ai/BUDGET.md`
- `/ai/DECISIONS.md` (add project-specific ADRs for each major choice)
- `/ai/DEV_ENVIRONMENT.md` (document the chosen environment)
- `/ai/HANDOFF.md`

It must also create at the project root:

- `LICENSE` (chosen during init; recorded as an ADR).
- `README.md`, `SECURITY.md`, `CONTRIBUTING.md` (from
  `/ai/templates/*.template.md`).

The AI must preserve `/ai/START_HERE.md`, `/ai/AI_RULES.md`, and
`/ai/WORKFLOW.md` as stable cross-project files unless explicitly told
to modify them.

---

## 5. Standard Start-of-Chat Response

After reading the Fast Context files and any needed Conditional Context files,
the AI must respond with:

```text
Current project summary:
- Context loaded:
- Project:
- Current phase:
- Current task:
- What appears complete:
- What appears incomplete:
- Hard rules I must respect (from AI_RULES.md):
- Next recommended action:
- Additional files I need to inspect or modify:
```

The AI should not begin coding until it has provided this summary, unless the
user explicitly asks it to proceed immediately.

---

## 6. Standard End-of-Chat Requirements

Before stopping work, the AI must update or provide patches for:

1. `/ai/CURRENT_STATE.md`
2. `/ai/TASKS.md`
3. `/ai/HANDOFF.md`
4. `/ai/DONE_LOG.md`

The AI must also update these when relevant:

- `/ai/ARCHITECTURE.md`
- `/ai/ROADMAP.md`
- `/ai/TESTING.md`
- `/ai/DEPLOYMENT.md`
- `/ai/DECISIONS.md`

The final response must include:

```text
Work completed:
Files changed:
Tests/checks run:
Known issues:
Project files updated:
Next recommended task:
```

---

## 7. Scope Control Rules

The AI must follow these rules:

- Do not add features not listed in `/ai/TASKS.md` or `/ai/ROADMAP.md`.
- Do not add dependencies without recording the reason in `/ai/DECISIONS.md`.
- Do not change architecture silently.
- Do not remove tests to make a build pass.
- Do not mark a task complete unless acceptance criteria are met.
- Do not work across multiple tasks unless the user explicitly asks.

---

## 8. Status Values

Use these task statuses:

- `Backlog`
- `Ready`
- `In Progress`
- `Blocked`
- `Review`
- `Done`
- `Deferred`

---

## 9. Completion Standard

A task is only complete when:

1. Scope was followed.
2. Acceptance criteria were met.
3. Tests/checks were run or a clear reason is documented.
4. `/ai/TASKS.md` was updated.
5. `/ai/CURRENT_STATE.md` was updated.
6. `/ai/HANDOFF.md` was updated.
7. `/ai/DONE_LOG.md` was updated.
