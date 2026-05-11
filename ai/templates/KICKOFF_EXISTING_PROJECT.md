# Kickoff: Existing Project

You have an app that already exists — partly built, mostly built, or
shipping in production — and you want to add the `ai-starter` workflow
to it. Paste the prompt below into your AI tool. The AI will inspect
the project, ask only what it can't infer, and then generate one of two
prompts depending on what you want:

- **Catch up** — keep the existing code, retrofit `/ai/` to match the
  current state, and queue catch-up tasks for any gaps against the
  starter's Hard rules. Recommended in most cases.
- **Start fresh** — use the existing code as reference, replace it with
  a clean rebuild using `INIT_PROMPT.md`. Use this when the existing
  app is a prototype or a hard rewrite is already on the roadmap.

If you're starting something brand new (no existing code), use
`/ai/templates/KICKOFF_NEW_PROJECT.md` instead.

If you have an existing project that's already on an older `ai-starter`
version (i.e., it has an `/ai/` folder already), use
`/ai/templates/REFRESH_PROMPT.md` instead.

---

## Prompt to paste to the AI assistant

```text
You are helping a user adopt the `ai-starter` workflow into an EXISTING
application. Your job in this session is to inspect their project,
interview them about what only they can know, decide with them whether
to "catch up" or "start fresh," and then generate a customized prompt
they (or you) can run to do the actual work.

## Behavior rules for this interview

- Read `/ai/START_HERE.md`, `/ai/AI_RULES.md`,
  `/ai/templates/INIT_PROMPT.md`, and `/ai/templates/ADOPT_PROMPT.md`
  first so you know the two paths and what each will need.
- **Inspect before you ask.** Don't ask the user things you can read
  from their files.
- **Ask one question at a time.** Never dump a wall of questions.
- For each question, give 2-3 concrete example answers and explicitly
  offer a "I don't know — pick a sensible default" option.
- Be friendly and concise. Avoid jargon when a plain word works.
- Honor the Destructive Operations and Reasoning Checkpoint rules in
  `/ai/AI_RULES.md`. Do NOT modify the user's code or planning files
  in this session — the only output is the customized prompt.

## Step 1 — Inspect the project (read-only)

Survey the repo. Focus on signals, not exhaustive detail. Look at:

- File tree (top two levels), to gauge size and shape.
- Package manifests + lockfiles (`package.json` + `pnpm-lock.yaml` /
  `package-lock.json` / `yarn.lock`; `pyproject.toml` + `poetry.lock` /
  `requirements.txt`; `go.mod`; `Cargo.toml`; `*.csproj`; `Gemfile`;
  etc.) — to identify language(s), framework(s), runtime version(s),
  and direct dependencies.
- `.nvmrc` / `.python-version` / runtime version files.
- `.github/workflows/`, `.gitlab-ci.yml`, `azure-pipelines.yml`, etc.
  — to identify the CI system and what it runs.
- Existing `Dockerfile`, `docker-compose.yml`, `Procfile`, `terraform/`,
  `infra/`, `cdk.json`, `serverless.yml`, etc. — to identify the
  hosting target and IaC approach (or lack of).
- `README.md` — for stated purpose, quick-start, and links.
- `LICENSE`, `SECURITY.md`, `CONTRIBUTING.md`, `CHANGELOG.md` — for
  what already exists at the project root.
- `tests/`, `__tests__/`, `*.test.*`, `*.spec.*` — for test framework
  and rough coverage shape.
- Any existing `/ai/` folder or files like `CLAUDE.md`, `AGENTS.md`,
  `.cursorrules` — if these exist, the project may already be on an
  older `ai-starter`; recommend `REFRESH_PROMPT.md` instead.

If `/ai/` already exists, STOP and tell the user:

  This project already has /ai/ — it looks like an older ai-starter
  version. Use /ai/templates/REFRESH_PROMPT.md instead of this kickoff.

Otherwise, produce a "what I see" summary like:

  Here's what I see in this project:
  - Language: TypeScript 5.4.x (per package.json)
  - Framework: Next.js 14.2.5 (App Router, per file tree)
  - Database: Postgres (postgres / pg in package.json; docker-compose
    has a postgres:16 service)
  - Tests: Vitest (vitest in devDependencies; ~30 spec files)
  - CI: GitHub Actions (.github/workflows/ci.yml runs lint + test +
    build on push and PR)
  - Hosting: Vercel (vercel.json present; no Terraform / IaC found)
  - License: MIT (LICENSE present)
  - SECURITY.md: missing
  - CONTRIBUTING.md: missing
  - Tool-native memory hooks (CLAUDE.md / AGENTS.md / etc.): missing
  - Dependabot / Renovate: not configured
  - SAST in CI: not configured
  - Estimated project size: 124 source files, 8 routes, 12 components

Be specific. Use the actual values you see. Use "missing" or "not
configured" honestly when something isn't there.

## Step 2 — Confirm and fill gaps

Show the summary. Ask:

  Does that match how you understand the project? Anything I missed,
  got wrong, or that lives outside the repo (e.g., a hosted database,
  an auth provider, a third-party service)?

Update your mental model with their corrections.

## Step 3 — Path question (catch up vs. start fresh)

Explain the two paths in plain language:

  There are two ways to add ai-starter to an existing project:

  **CATCH UP** (recommended) — Keep your code as-is. I'll generate
  the planning files (PROJECT, ARCHITECTURE, DECISIONS, SPEC,
  DEPLOYMENT, etc.) by reverse-engineering them from what's already
  here. I'll backfill ADRs for every major choice you've already made.
  I'll flag gaps where the project doesn't yet match the starter's
  hard rules (e.g., no SECURITY.md, no SAST in CI, no Terraform yet)
  and queue them as Phase-1 catch-up tasks for you to prioritize.
  Nothing in your existing code changes during catch-up.

  **START FRESH** — Treat your existing code as reference only. I'll
  use it for context (brand, content, integrations) but plan a new
  build from scratch using INIT_PROMPT. This is heavier and only
  makes sense if you were already planning a rewrite.

  Which path do you want?

If they're unsure, recommend **catch up** — it's lower-risk and
preserves their work. Only suggest "start fresh" if they say they were
already planning a rewrite.

## Step 4 — Ask only what can't be inferred

Whichever path they chose, you still need a few things you can't read
from their files:

1. **Project purpose / users / goals / non-goals** — only ask the bits
   the existing README doesn't already cover. Read README first.

   **Validate the purpose answer.** Whether you read it from the README
   or get it from the user, the answer must describe what end users
   *do* with the product — a concrete feature loop, not infrastructure
   or architecture.

   If the README (or user) describes the project as a "foundation",
   "template", "starter", "scaffold", "base", "skeleton", or
   "boilerplate" — or as a list of services and surfaces ("a SaaS with
   marketing site, web app, API, worker") without saying what users
   *do* — push back:

   > "Got it on the architecture, but I need to understand what the
   > app actually *does* for an end user. What feature do they use?
   > What's the core loop — sign up, then what?"

   Loop until you have a concrete feature loop. The existing
   architecture becomes supporting infrastructure under feature work,
   not the product itself. If the existing project genuinely has no
   user-facing feature yet (it really is just chassis), recommend
   stopping the adopt session and re-running this kickoff after the
   user has decided what the actual product does.
2. **Compliance / regulatory** — same as the new-project interview.
3. **Cloud preference** — for catch-up, this should usually match what
   the project already deploys to (e.g., Vercel → ask if they want to
   migrate to AWS / Azure / GCP per the Hard rules, or document the
   override as an ADR). For start-fresh, ask normally.
4. **Monthly budget cap** — same as new-project interview.
5. **License** — only if `LICENSE` is missing or unclear. Default MIT.
6. **Anything else** — known constraints, must-keep behaviors, an
   intended migration target.

If catch-up: also ask:

  Anything in your existing code that you already know is brittle,
  weird, or that I should flag as a known issue when I write
  CURRENT_STATE.md? "Nothing comes to mind" is fine.

## Step 5 — For catch-up: pre-summarize the gaps

Before generating the prompt, list the gaps you noticed against the
starter's Hard rules. Examples (use the ones that actually apply):

  Gaps I noticed against the starter's hard rules — these will become
  Phase-1 catch-up tasks:
  - SECURITY.md missing → add from /ai/templates/SECURITY.template.md
  - CONTRIBUTING.md missing → add from /ai/templates/CONTRIBUTING.template.md
  - Tool-native memory hooks (CLAUDE.md, AGENTS.md, .cursorrules,
    .github/copilot-instructions.md, GEMINI.md) missing → add stubs
    pointing at /ai/START_HERE.md
  - Dependabot / Renovate not configured → add Dependabot config
  - SAST not running in CI → add CodeQL or equivalent
  - No Terraform / IaC found → flag for evaluation; existing Vercel
    deploy may need an ADR overriding the AWS/Azure/GCP default
  - No rate limiting on public API routes → flag for review
  - Postgres self-hosted in production → flag; default is managed
    (RDS / Cloud SQL); user can write an ADR to keep self-hosted
  - No /ai/BUDGET.md tracking → set budget cap and alerts

The user might say "ignore the Vercel one, we're staying" — that's
fine, document it as an ADR override at adopt time.

## Step 6 — Confirm and generate

Summarize the answers + the chosen path + the gap list. Ask:

  Does that all look right? I'll generate the {ADOPT_PROMPT /
  INIT_PROMPT} input next.

After confirmation, generate the customized prompt as a fenced code
block (```text fences) prefixed with "COPY THIS — your customized
{adopt / init} prompt."

- For **catch up**, the block is the contents of
  `/ai/templates/ADOPT_PROMPT.md` "Prompt to paste to the AI
  assistant" section, with the inspection summary, user-supplied
  answers, and gap list pre-filled.
- For **start fresh**, the block is the contents of
  `/ai/templates/INIT_PROMPT.md` "Prompt to paste to the AI
  assistant" section, with the existing project's path filled in as
  the OLD REPO and the user-supplied answers pre-filled.

Then ask:

  Want me to run this inline in this session now, or would you rather
  copy it and paste into a fresh session for clean context? Fresh
  session is cleaner; inline is faster.

## Hard rules for this interview

- This session is INSPECTION + INTERVIEW only. Do NOT modify any code
  or planning files. The output is the customized prompt.
- Do NOT pin specific dependency versions in any ADR yet — the
  downstream actor (ADOPT or INIT) will look those up from canonical
  sources.
- If the user wants to skip the interview, point them at
  `/ai/templates/ADOPT_PROMPT.md` (catch up) or
  `/ai/templates/INIT_PROMPT.md` (start fresh) directly.
- If you discover an existing `/ai/` folder, route to
  `/ai/templates/REFRESH_PROMPT.md` instead — this kickoff isn't for
  refreshes.
```
