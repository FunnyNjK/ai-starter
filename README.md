# AI Project Starter (Tommy's Edition)

A customized AI workflow / project memory system for static-leaning websites
built with Astro 5 + React 19 + Tailwind 4, deployed to Azure Static Web Apps,
developed natively in WSL Ubuntu.

## Repository status

This repository is the reusable starter/template itself. It is not an
initialized application repo yet: the real project name, purpose, content, and
business logic are intentionally left as TBD until the `/ai` folder is copied
into a concrete project and initialized with an application description.

## How to use

1. Copy the `/ai` folder into the root of any new project repo.
2. In your AI assistant of choice (Claude Code, Codex, Cursor, Copilot CLI),
   start a session with:

   ```text
   Read /ai/START_HERE.md and initialize this project.

   Application description:
   <plain-English description of what this site is>
   ```

3. The assistant will read the supporting files, ask clarifying questions only
   when something would materially change the architecture, and then update
   the project-specific TBD sections.

## What's baked in

- **Dev environment:** WSL Ubuntu, native (no Docker for development).
- **Default stack:** Astro 5 + React 19 islands + Tailwind 4 + TypeScript strict + Vitest + pnpm.
- **Deployment:** Azure Static Web Apps (free SSL) with managed Azure Functions API.
- **External services:** Postmark (email) + Cloudflare Turnstile (bot mitigation).
- **CI:** GitHub Actions with OIDC federated auth (no static secrets).
- **Database (when needed):** Docker container on host, local dev connects via `localhost`.

These are defaults; per-project ADRs can override.

## What's NOT baked in

- The application's actual purpose, content, or business logic.
- Whether a given project needs auth, a database, or anything beyond the
  contact-form pattern. Projects opt in via their own `PROJECT.md` and ADRs.

## Single rule

Tell your AI assistant to read **`/ai/START_HERE.md`** first. That's the entry point.

## Refreshing an older project

If you have an older project that was started from a previous version of this
starter (different conventions, stale Node version, bloated `CURRENT_STATE.md`,
etc.), point an AI assistant at **`/ai/templates/REFRESH_PROMPT.md`**. It's a
one-shot housekeeping pass that:

- Cross-checks dependency / runtime versions in the docs against
  `package.json` reality (and flags major bumps for separate ADRs).
- Compacts `CURRENT_STATE.md` (≤ 80 lines) and `HANDOFF.md` (≤ 50 lines).
- Archives Done tasks from `TASKS.md` into `DONE_LOG.md`.
- Creates a `README.md` if missing.
- Confirms `AI_RULES.md` carries the current hard rules.
- Verifies `origin/main` matches local `main`.

Run it once per existing repo. New projects don't need it — the conventions
are already baked in.
