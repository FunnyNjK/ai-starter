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

> Building a web app and not sure which *kind* you're building?
> See [docs/CHOOSING_WEBAPP_PATH.md](docs/CHOOSING_WEBAPP_PATH.md) —
> a decision tree (with Mermaid diagram) covering static sites, SPAs,
> CRUD apps, SaaS, e-commerce, AI apps, realtime / collaboration,
> internal dashboards, public/private/sensitive surfaces, payments,
> external API + AI cost, and deployment shape. It's the map behind
> the questions the kickoff interview asks.

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
     supported AI CLI) — they require `scripts/run-phase-lib.sh`
   - `scripts/lint-planning.py` + `.github/workflows/lint.yml` if you
     want the planning-file linter (and CI) to come along
   - `docs/CHOOSING_WEBAPP_PATH.md` if you want the web-app decision
     tree alongside the starter
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
- **Templates** for tasks, chat end / handoff, README, SECURITY,
  CONTRIBUTING, INCIDENT post-mortems, CI security, CURRENT_STATE, HANDOFF.
- **Worked example** (`/ai/EXAMPLE_PROJECT.md`) — what a fully-initialized
  project looks like, for reference.
- **Tool-native memory hooks** for Claude Code, Codex, Cursor, Copilot,
  and Gemini.
- **Phase harnesses** (`run-phase*.sh`) — autonomous N-task runners,
  one per supported AI CLI. They share safety/session mechanics via
  `scripts/run-phase-lib.sh` (safe staging that refuses secrets / keys /
  local DBs, push-on-failure stop) while keeping each adapter's
  tool-specific CLI invocation separate.
- **Planning linter** (`scripts/lint-planning.py`) — checks that every
  task in `TASKS.md` and every ADR in `DECISIONS.md` has the required
  sections per `/ai/AI_RULES.md` Task Quality and Hygiene Rules, and
  that `CURRENT_STATE.md` / `HANDOFF.md` stay under their line caps.
- **Task completion helper** (`scripts/mark-task-done.py`) — reliably moves
  completed tasks from `TASKS.md` to `DONE_LOG.md` to prevent markdown
  parsing issues during autonomous runs.
  Run from repo root:

  ```bash
  python3 scripts/lint-planning.py
  ```

  Also runs in CI (`.github/workflows/lint.yml`) alongside shellcheck
  on the phase scripts.

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
