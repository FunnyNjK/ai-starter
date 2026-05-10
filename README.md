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

## First time? Pick your starting point

| Your situation | Paste this prompt into your AI tool |
| --- | --- |
| 🌱 **Starting something brand new** | `/ai/templates/KICKOFF_NEW_PROJECT.md` |
| 🔧 **Adding this kit to an existing app** | `/ai/templates/KICKOFF_EXISTING_PROJECT.md` |
| 🔄 **Already on an older version of this starter** | `/ai/templates/REFRESH_PROMPT.md` |

The two `KICKOFF_*` prompts interview you one question at a time (with
sensible defaults at every step) and then generate the customized prompt
that does the actual setup. **They're the foolproof entry point — start
there if you're not sure what to type.**

If you already know exactly what you want, you can skip the interview:

| Path | Direct prompt (skips the interview) |
| --- | --- |
| Greenfield init | `/ai/templates/INIT_PROMPT.md` |
| Brownfield retrofit (catch up) | `/ai/templates/ADOPT_PROMPT.md` |
| Existing project housekeeping | `/ai/templates/REFRESH_PROMPT.md` |

## How to use (manual setup)

1. **Copy** the contents of this repo into your new project. At minimum:
   - `/ai/` (the workflow + planning files)
   - `CLAUDE.md`, `AGENTS.md`, `.cursorrules`, `GEMINI.md`,
     `.github/copilot-instructions.md` (tool-native memory hooks — they
     auto-load `/ai/START_HERE.md` for whatever AI tool you're using)
   - `.github/pull_request_template.md`
   - `run-phase*.sh` if you want the autonomous-phase harnesses (one per
     supported AI CLI)
2. In your AI assistant of choice, paste one of the `KICKOFF_*` prompts
   above. The AI will guide you the rest of the way.

## What's included

- **Friendly entry points**: `KICKOFF_NEW_PROJECT.md` and
  `KICKOFF_EXISTING_PROJECT.md` interview you and generate the right
  customized setup prompt.
- **Setup actors**: `INIT_PROMPT.md` (greenfield), `ADOPT_PROMPT.md`
  (brownfield retrofit), `REFRESH_PROMPT.md` (older-project housekeeping).
- **AI on-ramp**: `/ai/START_HERE.md` — the single entry point every AI
  session reads first.
- **Planning files**: identity (`PROJECT.md`), behavior (`SPEC.md`),
  shape (`ARCHITECTURE.md`), state (`CURRENT_STATE.md`), work (`TASKS.md`,
  `ROADMAP.md`), decisions (`DECISIONS.md`), env (`DEV_ENVIRONMENT.md`),
  testing (`TESTING.md`), deploy (`DEPLOYMENT.md`), cost (`BUDGET.md`),
  process (`WORKFLOW.md`), handoff (`HANDOFF.md`), history (`DONE_LOG.md`).
- **Hard rules** (`/ai/AI_RULES.md`): Git, planning hygiene, versioning,
  security, infrastructure, cost, destructive operations, reasoning
  checkpoints, blocked escalation, task quality.
- **Templates** for tasks, chat start/end, README, SECURITY,
  CONTRIBUTING, INCIDENT post-mortems, CURRENT_STATE, HANDOFF.
- **Worked example** (`/ai/EXAMPLE_PROJECT.md`) — what a fully-initialized
  project looks like, for reference.
- **Tool-native memory hooks** for Claude Code, Codex, Cursor, Copilot,
  and Gemini.
- **Phase harnesses** (`run-phase*.sh`) — autonomous N-task runners,
  one per supported AI CLI.

## What's NOT included

- Any opinion about the language, framework, package manager, OS,
  third-party services, or specific application code your project uses.
- The application itself — this is just the workflow.

The starter *does* take opinions on a few things to keep every project
on solid ground: cloud target is AWS / Azure / GCP, infrastructure is
Terraform, QA + Production stateful services are cloud-managed, CI
auths via OIDC federation, secrets live in cloud secret stores, every
task carries prerequisites + verification + rollback. Every one of
these defaults can be overridden per project via an ADR — see
`/ai/AI_RULES.md`.

## Single rule

Tell your AI assistant to read **`/ai/START_HERE.md`** first. The
tool-native memory hook files at the project root all redirect there, so
most modern AI tools will auto-load it for you.

## License

MIT — see [LICENSE](LICENSE). Use it however you want.
