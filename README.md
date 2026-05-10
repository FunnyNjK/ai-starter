# AI Project Starter

A reusable AI workflow and project memory system for software development.
Drop the `/ai` folder (plus a few root-level files) into any project to give
AI assistants a consistent way to track project state, decisions, tasks, and
handoffs across sessions — and to keep them honest about versions, security,
infrastructure, and cost.

**License**: MIT — see [LICENSE](LICENSE). Free to use, modify, distribute,
and embed in commercial work; just keep the copyright notice.

## Repository status

This repository is the reusable starter/template itself. It is not an
initialized application repo: the project name, purpose, content, tech stack,
and tooling are intentionally left as TBD until the `/ai` folder is copied
into a concrete project and initialized with an application description.

## How to use

1. **Copy** the contents of this repo into your new project. At minimum:
   - `/ai/` (the workflow + planning files)
   - `CLAUDE.md`, `AGENTS.md`, `.cursorrules`, `GEMINI.md`,
     `.github/copilot-instructions.md` (tool-native memory hooks — they
     auto-load `/ai/START_HERE.md` for whatever AI tool you're using)
   - `.github/pull_request_template.md`
   - `run-phase*.sh` if you want the autonomous-phase harnesses (one per
     supported AI CLI)
2. In your AI assistant of choice, start a session with:

   ```text
   Read /ai/templates/INIT_PROMPT.md and follow it.

   Application description:
   <plain-English description of what you're building>
   ```

3. The assistant will run through the init steps: choose the tech stack
   (looking up versions from canonical sources), choose the cloud + IaC
   + managed services, choose the security baseline, set the budget,
   choose a license, fill in `SPEC.md`, and queue ordered Phase-1 tasks.

## What's included

- **Entry point**: `/ai/START_HERE.md` — single AI on-ramp.
- **Planning files**: identity (`PROJECT.md`), behavior (`SPEC.md`),
  shape (`ARCHITECTURE.md`), state (`CURRENT_STATE.md`), work (`TASKS.md`,
  `ROADMAP.md`), decisions (`DECISIONS.md`), env (`DEV_ENVIRONMENT.md`),
  testing (`TESTING.md`), deploy (`DEPLOYMENT.md`), cost (`BUDGET.md`),
  process (`WORKFLOW.md`), handoff (`HANDOFF.md`), history (`DONE_LOG.md`).
- **Hard rules** (`/ai/AI_RULES.md`): Git, planning hygiene, versioning,
  security, infrastructure, cost, destructive operations, reasoning
  checkpoints, blocked escalation, task quality.
- **Templates** for tasks, chat start/end, init, refresh, README,
  SECURITY, CONTRIBUTING, INCIDENT post-mortems, CURRENT_STATE,
  HANDOFF.
- **Worked example** (`/ai/EXAMPLE_PROJECT.md`) — what a fully-initialized
  project looks like, for reference.
- **Tool-native memory hooks** for Claude Code, Codex, Cursor, Copilot,
  and Gemini.
- **Phase harnesses** (`run-phase*.sh`) — autonomous N-task runners,
  one per supported AI CLI.

## What's NOT included

- Any opinion about the language, framework, package manager, OS, third-party
  services, or specific application code your project uses.
- The application itself — this is just the workflow.

The starter *does* take opinions on a few things to keep every project on
solid ground: cloud target is AWS / Azure / GCP, infrastructure is Terraform,
QA + Production stateful services are cloud-managed, CI auths via OIDC
federation, secrets live in cloud secret stores, every task carries
prerequisites + verification + rollback. Every one of these defaults can be
overridden per project via an ADR — see `/ai/AI_RULES.md`.

## Single rule

Tell your AI assistant to read **`/ai/START_HERE.md`** first. The tool-native
memory hook files at the project root all redirect there, so most modern AI
tools will auto-load it for you.

## Refreshing an older project

If you have an older project that was started from a previous version of
this starter, point an AI assistant at **`/ai/templates/REFRESH_PROMPT.md`**.
It's a one-shot housekeeping pass that compacts long-running planning files,
archives completed tasks, ensures the (Hard) rules and tool-native memory
hooks are current, regenerates root docs (README / SECURITY / CONTRIBUTING /
LICENSE) where missing, and verifies that the local branch matches the
remote.

## License

MIT — see [LICENSE](LICENSE). Use it however you want.
