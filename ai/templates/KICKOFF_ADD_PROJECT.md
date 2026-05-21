# Kickoff: Add Project to Existing Solution

Your solution already exists (it has `/ai/SOLUTION.md` filled in
with project-specific identity). This wizard adds a **new project**
to the solution.

3 picks + name + dependencies + 1 free-text. Generates a customized
`ADD_PROJECT_PROMPT.md` invocation. The actor then updates the
solution-level files (`SOLUTION.md` Projects table,
`ARCHITECTURE.md` diagram) and creates `projects/<name>/`.

If your repo doesn't have `/ai/SOLUTION.md` yet, use
`/ai/templates/KICKOFF_NEW_SOLUTION.md` instead — that's the
first-run wizard. If your repo has an older starter version's
`/ai/PROJECT.md`, use `/ai/templates/REFRESH_PROMPT.md` first.

---

## Prompt to paste to the AI assistant

```text
You are running the `ai-starter` add-project wizard. The solution
already exists. Your job is to add a new project to it. Ask 3
picks + project name + inter-project dependencies + 1 free-text,
build a NOTES block, generate a customized `ADD_PROJECT_PROMPT.md`
invocation.

## Bootstrap check

Before asking any questions, confirm:

- `/ai/SOLUTION.md` exists and is project-specific (not TBD). If
  TBD, STOP and tell the user to run KICKOFF_NEW_SOLUTION.md
  instead.
- `/ai/PROJECT.md` does NOT exist (would indicate a pre-1.2.0
  starter). If it does, STOP and tell the user to run
  REFRESH_PROMPT.md first to migrate to the v1.2.0 layout.
- Read `/ai/SOLUTION.md` "Projects" table to know what projects
  exist already (used in Turn 5).
- Read `/ai/AI_RULES.md` (Hard) rule blocks — they all apply.

## Behavior rules

- **One question per turn.** Wait for a reply before the next.
- **Filter each menu by the previous answer** (same as
  KICKOFF_NEW_SOLUTION).
- **Be terse.** No essays. Match the menu shape verbatim.
- If user types `?` instead of a number, show 2-3 clarifying
  examples for that specific menu, then re-ask.
- Do NOT modify any planning files in this session — only output
  the customized prompt.
- Do NOT ask compliance / budget / cloud / auth questions —
  inherited from the solution's existing settings.

## Turn 1 — Confirm context

Render exactly (substitute solution-specific values from
`/ai/SOLUTION.md`):

  Detected solution: {Solution Name} (tier: {tier}).
  Existing projects ({N}):
    • {project-1} ({platform-1} {language-1} — {template-1})
    • {project-2} ({platform-2} {language-2} — {template-2})

  Adding a new project. Same 3 picks as new-solution, plus a name
  and which existing projects it talks to.

This is informational — no input needed. Proceed to Turn 2.

## Turn 2 — Platform

Render exactly (identical to KICKOFF_NEW_SOLUTION.md Turn 1):

  What's the platform for the new project?

    1. Web              — runs in a browser
    2. Server / cloud   — runs on a server or cloud, no UI
    3. Desktop          — Windows / macOS / Linux GUI
    4. Mobile           — iOS / Android (cross-platform only)
    5. CLI / terminal   — runs in a terminal
    6. Library / package— code others import from a registry

Wait for one number. Capture as `platform`.

## Turn 3 — Language

Same filter table as KICKOFF_NEW_SOLUTION.md Turn 2. Ask:

  {Platform name}. Pick a language:

    1. ...
    2. ...

Wait for one number. Capture as `language`.

## Turn 4 — Template

Same lookup table as KICKOFF_NEW_SOLUTION.md Turn 3. Ask:

  {Language} on {platform}. Pick a template:

    1. ...

Wait for one number. Capture as `template` + `template_recipe_path`.

## Turn 5 — Project name

Render exactly:

  What should this project be called? Used as the folder name
  (`projects/<name>/`) and in the architecture diagram.

  Suggested: `{default}` (matches the platform pick).

Defaults per platform (use the same mapping as new-solution Turn
5 generate step). If the default collides with an existing project
in the solution (read from SOLUTION.md), suggest `{default}-2` and
warn:

  Project `{default}` already exists in this solution. Suggesting
  `{default}-2`. Reply with that or a different name.

Validate: name is `[a-z0-9-]+`, no spaces, no uppercase. Re-ask if
invalid. Capture as `project_name`.

## Turn 6 — Inter-project dependencies

Render exactly (substitute existing project list from
SOLUTION.md):

  Does this new project talk to any existing project in the
  solution?

  Existing projects:
    1. {project-1} ({platform-1} {language-1})
    2. {project-2} ({platform-2} {language-2})

  Pick all that apply (e.g. `1, 2`), or `none`.

Wait for a list of numbers or `none`. Capture as
`talks_to` (list of project names). If the user picks themselves
by accident, drop silently.

If `none` and the solution has any existing project, ask once
more for confirmation:

  Got it — `{project_name}` will be standalone. Confirm by
  replying `yes`, or list the numbers if you change your mind.

## Turn 7 — Feature loop

Render exactly:

  What does `{project_name}` DO for users? 1-3 sentences.
  (Scope this to THIS new project only — the existing projects
  already have their own feature loops in `projects/*/README.md`.)

  Reminder: foundation- or architecture-only answers get
  rejected. Reply `?` for a walkthrough.

Capture as `feature_loop`. Apply the light refusal loop ONCE if
the answer is foundation-shaped (same shape as
KICKOFF_NEW_SOLUTION Turn 4).

## Turn 8 — Generate the ADD_PROJECT prompt

Output exactly:

  ✓ Got it. Adding `{project_name}` ({template name}) to your
  solution. It will talk to: {talks_to or "nothing — standalone"}.

  Copy this prompt into a fresh AI session — cleanest context.

  ```text
  {ADD_PROJECT_PROMPT.md content, with a NOTES block at the top}
  ```

NOTES block shape:

  NOTES (from KICKOFF_ADD_PROJECT wizard, v1.2.0):
    mode: add-project-to-existing-solution
    solution_name: {from SOLUTION.md}
    platform: {platform}
    language: {language}
    template: {template}
    template_recipe: {template_recipe_path}
    project_name: {project_name}
    talks_to: {comma-separated project names, or "none"}
    feature_loop: |
      {verbatim from user}
    inherited_from_solution:
      tier: {tier from SOLUTION.md}
      license: {license from SOLUTION.md}
      compliance: {compliance from SOLUTION.md}
      cloud_preference: {deferred to P3-T0 or actual cloud from SOLUTION.md}

## After generating

Render exactly:

  Want me to run this inline now, or copy into a fresh session?
  Fresh is cleaner; inline is faster.

Wait for an answer.

## Hard rules

- Do NOT scaffold, install deps, or edit planning files in this
  session.
- Do NOT re-interview the user on solution-level settings (tier,
  license, compliance, cloud) — those are inherited from
  `/ai/SOLUTION.md`.
- Do NOT ask the same picks again if the user reruns this wizard
  mid-flow — re-read the NOTES block and only re-ask what's
  missing.
- Keep it tight — 7 input turns (1 confirm + 3 picks + 1 name +
  1 deps + 1 free-text) + generate.
- If the chosen `project_name` collides, suggest `<name>-2` (not
  `<name>-new` — keep it numeric).
```
