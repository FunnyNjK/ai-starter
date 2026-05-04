# START HERE - AI Project Control File

Last Updated: 2026-05-03

This is the only file an AI assistant needs to read first.

After reading this file, the AI must follow the instructions below and
reference the supporting files in `/ai` as needed.

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
2. Then read the referenced files listed in the Context Loading Order.
3. Summarize the current project state before making changes.
4. Work only on the assigned task unless explicitly told otherwise.
5. Avoid project creep.
6. Update the relevant `/ai` files before ending the chat or task.
7. Never claim work is complete unless tests, checks, or validation steps are
   clearly documented.
8. If a decision changes architecture, scope, data model, security, deployment,
   or dependencies, update `/ai/DECISIONS.md`.
9. Honor the hard rules in `/ai/AI_RULES.md` and `/ai/DEV_ENVIRONMENT.md`.
   These are non-negotiable.

---

## 3. Context Loading Order

When beginning work, read these files in order:

1. `/ai/PROJECT.md`
2. `/ai/DEV_ENVIRONMENT.md`         <-- WSL-native, no Docker for dev
3. `/ai/AI_RULES.md`                <-- hard rules
4. `/ai/CURRENT_STATE.md`
5. `/ai/ARCHITECTURE.md`
6. `/ai/ROADMAP.md`
7. `/ai/TASKS.md`
8. `/ai/TESTING.md`
9. `/ai/DEPLOYMENT.md`
10. `/ai/DECISIONS.md`
11. `/ai/HANDOFF.md`

If any file is missing, create it from the matching template in `/ai/templates`.

---

## 4. First-Time Project Initialization

If the project is still a starter project (PROJECT.md still has TBD sections
or "Project Name: TBD"), the AI should ask for or use the provided application
description and then update the starter files into project-specific files.

The initialization process must update:

- `/ai/PROJECT.md`
- `/ai/CURRENT_STATE.md`
- `/ai/ARCHITECTURE.md`
- `/ai/ROADMAP.md`
- `/ai/TASKS.md`
- `/ai/TESTING.md`
- `/ai/DEPLOYMENT.md`
- `/ai/DECISIONS.md` (add any project-specific ADRs that override the baked-in defaults)
- `/ai/HANDOFF.md`

The AI must preserve `/ai/START_HERE.md`, `/ai/AI_RULES.md`, and
`/ai/DEV_ENVIRONMENT.md` as stable cross-project files unless explicitly
told to modify them.

---

## 5. Standard Start-of-Chat Response

After reading the required files, the AI must respond with:

```text
Current project summary:
- Project:
- Current phase:
- Current task:
- What appears complete:
- What appears incomplete:
- Hard rules I must respect (from AI_RULES.md):
- Next recommended action:
- Files I need to inspect or modify:
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
