# Kickoff: New Solution

You're starting a new repo with `ai-starter`. This is a **wizard** —
3 picks + 1 free-text. The wizard creates a *solution* (the repo)
with your *first project* in it. Subsequent projects get added via
`/ai/templates/KICKOFF_ADD_PROJECT.md`.

Paste the prompt below into your AI tool (Claude Code, Codex,
Cursor, Copilot, Gemini — any of them). The AI will:

1. Ask which platform your first project runs on (web, server,
   desktop, mobile, CLI, library).
2. Ask which language.
3. Ask which template.
4. Ask what users actually DO with this project (1-3 sentences).
5. Generate a customized `INIT_PROMPT.md` invocation.

**This wizard does not ask about cloud, budget, compliance, or
auth.** Templates carry sensible defaults for those. The
Local-First Development Rule defers cloud / budget to Phase 3.
Compliance walks fire later only if the user explicitly opts in.

If you have an existing app you want to add this kit to, use
`/ai/templates/KICKOFF_EXISTING_PROJECT.md` instead. If your repo
already has `/ai/SOLUTION.md` filled in, use
`/ai/templates/KICKOFF_ADD_PROJECT.md` to add another project.

---

## Prompt to paste to the AI assistant

```text
You are running the `ai-starter` new-solution wizard. Your job is to
ask 4 questions (3 picks + 1 free-text), build a NOTES block, and
generate a customized `INIT_PROMPT.md` invocation. Nothing else —
no scaffolding, no file edits, no version lookups. INIT does those.

## Behavior rules

- **One question per turn.** Wait for a reply before the next.
- **Filter each menu by the previous answer.** Languages narrow by
  platform; templates narrow by (platform, language).
- **No dumping.** Never show multiple turns or questions at once.
- **Be terse.** No essays. Match the menu shape below verbatim.
- If user types `?` instead of a number, show 2-3 clarifying
  examples for that specific menu, then re-ask.
- If a (platform, language) combo has no v1.2.0 template, the
  template menu offers a single "Custom — rung defaults" option
  routed to `/docs/PROJECT_SHAPE_GALLERY.md`.
- Do NOT ask compliance / budget / cloud / auth questions. Those
  are either bundled into the template or deferred to Phase 3.

## Turn 1 — Platform

Render exactly:

  New solution setup — 3 picks + 1 free-text.

  What's the platform for your first project? You'll add more
  projects later via add-project mode.

    1. Web              — runs in a browser
    2. Server / cloud   — runs on a server or cloud, no UI
    3. Desktop          — Windows / macOS / Linux GUI
    4. Mobile           — iOS / Android (cross-platform only)
    5. CLI / terminal   — runs in a terminal
    6. Library / package— code others import from a registry

Wait for one number. Capture as `platform`.

## Turn 2 — Language

Filter by `platform`. Render the matching language list:

| platform        | languages shown                                    |
|-----------------|----------------------------------------------------|
| Web             | TypeScript, JavaScript, C#, Python, Go             |
| Server          | TypeScript, JavaScript, C#, Python, Go             |
| Desktop         | TypeScript (Electron/Tauri), C#                    |
| Mobile          | TypeScript (React Native), C# (.NET MAUI)          |
| CLI             | TypeScript (Node), Python, Go                      |
| Library         | TypeScript, JavaScript, C#, Python, Go             |

Render exactly (substitute the menu shown):

  {Platform name}. Pick a language:

    1. TypeScript       — {one-line context}
    2. ...

Wait for one number. Capture as `language`.

## Turn 3 — Template

Filter by (`platform`, `language`). Render the matching template
menu. v1.2.0 ships these 8 templates:

| platform + language          | templates                                                            |
|------------------------------|----------------------------------------------------------------------|
| Web + TypeScript             | Next.js Web App / Astro Static                                       |
| Web + C#                     | ASP.NET Core MVC                                                     |
| Server + TypeScript          | NestJS API                                                           |
| Server + Python              | FastAPI                                                              |
| CLI + Python                 | Python Typer                                                         |
| Library + TypeScript         | TS Library (tsup + changesets)                                       |
| Mobile + TypeScript          | React Native (Expo)                                                  |
| (anything else)              | Custom — rung defaults from `/docs/PROJECT_SHAPE_GALLERY.md`         |

Render exactly:

  {Language} on {platform}. Pick a template:

    1. Next.js Web App  — opinions: Postgres + Drizzle + Auth.js + Tailwind
    2. Astro Static     — opinions: marketing/docs site, no DB, Tailwind
    3. Custom           — use the rung default for this combo

Each numbered option includes a one-line "opinions:" tag naming the
template's bundled DB / auth / styling / etc. choices, sourced from
the recipe file `/ai/templates/recipes/<path>.md`.

Wait for one number. Capture as `template` (name) and
`template_recipe_path` (the `/ai/templates/recipes/<path>.md` file).

## Turn 4 — Feature loop

Render exactly:

  Last open question. What does this project DO for users?
  1-3 sentences.

  Examples:
    • "Users sign up, link bank accounts via Plaid, categorize
      transactions, set monthly budgets, get alerts when over."
    • "Team leads create projects, add tasks, assign teammates,
      drag across a kanban board."
    • "Visitors read marketing pages about my consulting service,
      fill a contact form, I get an email."

  I'll reject foundation- or architecture-shaped answers
  ("a B2C SaaS foundation", "a Next.js app with Postgres") —
  those describe the chassis, not the product. Reply `?` for a
  walkthrough.

Capture the user's reply as `feature_loop`. Apply a light refusal
loop ONCE if the answer is foundation/architecture-shaped:

  > "That sounds like infrastructure, not a product. What does an
  > end user actually DO with this project — concrete feature
  > loop?"

Deeper validation is INIT's job (Step 2 of INIT_PROMPT.md).

## Turn 5 — Generate the INIT prompt

Output exactly:

  ✓ Got it. Creating a solution with {template name} as the first
  project ({project_name_default}).

  Copy this prompt into a fresh AI session — cleanest context.

  ```text
  {INIT_PROMPT.md content, with a NOTES block at the top}
  ```

The NOTES block shape (fill from captured slots):

  NOTES (from KICKOFF_NEW_SOLUTION wizard, v1.2.0):
    mode: new-solution-with-first-project
    platform: {platform}
    language: {language}
    template: {template}
    template_recipe: {template_recipe_path}
    project_name: {sensible default — see below}
    feature_loop: |
      {verbatim from user}
    tier: small team / early production
      (default; user can change in /ai/SOLUTION.md after init)
    license: MIT (default)
    cloud_preference: deferred to P3-T0
    budget_preference: deferred to P3-T0
    compliance: none (default; user adds via SOLUTION.md edit)

Default `project_name` mapping:

| platform                | default project_name |
|-------------------------|----------------------|
| Web                     | web                  |
| Server / cloud          | api                  |
| Desktop                 | desktop              |
| Mobile                  | mobile               |
| CLI / terminal          | cli                  |
| Library / package       | lib                  |

The user can override during INIT by editing the NOTES block before
pasting it into the fresh session.

## After generating

Render exactly:

  Want me to run this inline now, or do you prefer to copy it into
  a fresh AI session for clean context? Fresh session is cleaner;
  inline is faster.

Wait for an answer. If "inline", proceed to run INIT_PROMPT.md in
this session. If "fresh" or no answer, stop and let the user copy.

## Hard rules

- No scaffolding, no dependency installs, no file edits in this
  session. The customized INIT prompt is the only output.
- No version lookups. INIT verifies versions from canonical sources
  per the Versioning Rules.
- No compliance / budget / cloud / auth questions in the wizard.
- Keep it tight — 4 turns + generate. If you ask a 5th question,
  you've drifted.
- If the user types something unexpected (free text instead of a
  number), re-render the menu and ask again.
```
