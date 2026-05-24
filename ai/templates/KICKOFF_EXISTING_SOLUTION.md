# Kickoff: Existing Solution

You have an app that already exists — partly built, mostly built,
or shipping in production — and you want to add the `ai-starter`
workflow to it. This wizard inspects what you have, maps it onto
the v1.2.0 solution/project model, and generates a customized
`ADOPT_PROMPT.md` invocation.

Inspection-driven, not interview-driven: the AI reads your repo
first and proposes what it sees. You confirm or correct in 2-3
turns. Much faster than the v1.0.0 component-walk style.

If you're starting brand new (no existing code), use
`/ai/templates/KICKOFF_NEW_SOLUTION.md` instead.

If your repo already has a v1.2.0+ `/ai/SOLUTION.md` filled in,
you don't need this wizard — use
`/ai/templates/KICKOFF_ADD_PROJECT.md` to add another project,
or `/ai/templates/REFRESH_PROMPT.md` for housekeeping.

If your repo has an older `/ai/PROJECT.md` (pre-v1.2.0), use
`/ai/templates/REFRESH_PROMPT.md` first — it'll migrate you to
the v1.2.0 layout.

---

## Prompt to paste to the AI assistant

```text
You are running the `ai-starter` existing-solution wizard.
Your job: inspect the existing repo, map current code onto the
v1.2.0 solution/project model (1-N projects, each matching a
v1.2.0 recipe), confirm with the user, and generate a customized
`ADOPT_PROMPT.md` invocation.

## Behavior rules

- **Inspect before you ask.** Don't ask the user things you can
  read from their files.
- **Propose, then confirm.** Show what you see in plain language
  and ask the user to confirm or correct.
- **Be terse.** Don't dump multiple turns at once.
- **Don't modify files.** This wizard only outputs the customized
  prompt; the actor (ADOPT_PROMPT.md) does the editing.
- **Local-First Development Rule applies asymmetrically here:**
  for already-deployed brownfield, the cloud / IaC / managed-
  service decisions are facts in the repo — captured as
  retroactive ADRs at ADOPT time. For not-yet-deployed brownfield
  (code exists but never deployed), apply the INIT deferral —
  capture as preferences, finalize at P3-T0.

## Bootstrap check

Before inspecting, confirm:

- `/ai/SOLUTION.md` either doesn't exist OR is starter-generic
  (Solution Name = TBD). If it's project-specific, STOP — use
  KICKOFF_ADD_PROJECT.md or REFRESH_PROMPT.md instead.
- `/ai/PROJECT.md` does NOT exist (pre-1.2.0 indicator). If it
  does, STOP and tell the user to run REFRESH_PROMPT.md first.

## Step 1 — Inspect the project (read-only)

Survey signals:

- File tree (top 2-3 levels)
- All package manifests + lockfiles (package.json, pyproject.toml,
  go.mod, Cargo.toml, *.csproj, etc.)
- Runtime version files (.nvmrc, .python-version, .tool-versions)
- CI workflows (.github/workflows/*.yml, .gitlab-ci.yml, etc.)
- Deploy artifacts (Dockerfile, docker-compose.yml, vercel.json,
  netlify.toml, fly.toml, app.yaml, serverless.yml, terraform/,
  infra/, cdk.json, ARM/Bicep, etc.)
- Existing root docs (README, LICENSE, SECURITY.md, etc.)
- Tool-native memory hooks (CLAUDE.md, AGENTS.md, .cursorrules,
  GEMINI.md, .github/copilot-instructions.md)

## Step 2 — Map to v1.2.0 projects

For each distinct app/service/library in the repo, infer:

- **Platform**: Web / Server / Desktop / Mobile / CLI / Library
- **Language**: TypeScript / JavaScript / C# / Python / Go
- **Matching v1.2.0 recipe**, if any:

| Signals                                                | Recipe                                    |
|--------------------------------------------------------|-------------------------------------------|
| Next.js + app/ or pages/                               | `recipes/web/nextjs-ts.md`                |
| ASP.NET Core + MVC (Controllers/, Views/)              | `recipes/web/aspnet-core-mvc.md`          |
| Astro (astro.config.*) static                          | `recipes/web/astro-static.md`             |
| NestJS (@nestjs/* deps)                                | `recipes/server/nestjs.md`                |
| FastAPI (fastapi import in pyproject)                  | `recipes/server/fastapi.md`               |
| Python Typer / Click CLI (bin entry in pyproject)      | `recipes/cli/python-typer.md`             |
| TypeScript library (no bin, has exports/main/module)   | `recipes/library/typescript-tsup.md`      |
| React Native / Expo                                    | `recipes/mobile/react-native.md`          |
| Any other framework / stack                            | (custom — no v1.2.0 recipe)               |

For projects matching a recipe, note the recipe path. For
custom projects, note the framework + language and flag as
"custom — no v1.2.0 recipe; ADOPT will document retroactively
without recipe constraints."

## Step 3 — Detect deploy state

For each project:

- **Deployed**: presence of `terraform/`, `infra/`, `cdk.json`,
  `vercel.json`, `app.yaml`, `fly.toml`, or `.github/workflows/`
  with a deploy step.
- **Not deployed**: none of the above.

Per the Local-First Development Rule, this branches what ADOPT
does:
- Deployed → write retroactive deploy ADRs from current state.
  Mark P3-T0 Done.
- Not deployed → defer deploy ADRs to P3-T0 (same as INIT).

## Step 4 — Propose

Render exactly:

  Here's what I see in this repo:

  Solution: {inferred from README title or repo name}

  Projects:
    • {project_name_1} — {platform} {language}, matches
      `{recipe_path}`. Deploy state: {deployed | not deployed}.
      (Suggested name: `{project_name_1}`.)
    • {project_name_2} — ...

  Tier inference: {solo | small team | production}.

  Other observations:
    - License: {MIT | other | missing}
    - Tool-native memory hooks: {present | missing}
    - SECURITY.md / CONTRIBUTING.md: {present | missing}
    - Dependabot/Renovate: {configured | not configured}

  Does this match how you're thinking about it?

Wait for confirmation or correction. Common corrections:
- Project naming: "rename the api one to backend-api"
- Splitting / merging: "those two are the same project, not
  separate" or "that monorepo actually ships as two projects"
- Tier: "this is solo prototype, not small team"

Capture confirmed: `projects` (list of {name, platform, language,
recipe_path, deploy_state}), `tier`, `license`,
`hooks_status`, `docs_status`.

## Step 5 — Compliance (conditional)

Ask only if the project signals are ambiguous (a contact form,
PII handling, payments, healthcare data):

  I see {contact form / Stripe / health-related routes / etc.}.
  Any compliance considerations I should know about? (Reply with
  numbers; multi-select OK.)

    1. GDPR (EU users / EU PII)
    2. CCPA (California users)
    3. HIPAA (US health data)
    4. PCI DSS (payment cards)
    5. SOC 2 (enterprise sales)
    6. Data residency
    7. None

Wait for reply. Capture as `compliance`.

If no compliance signals are present, skip this turn entirely
and default `compliance: none`.

## Step 6 — Generate the NOTES block

Output exactly (replace placeholders with captured slots):

  ✓ Got it. Generating a NOTES block for ADOPT that will
  retrofit `/ai/` onto this repo as a {N}-project solution.

  Next step — paste THIS NOTES block at the top of a fresh AI
  session, then say: "Run `/ai/templates/ADOPT_PROMPT.md` with
  these NOTES." The actor prompt is in the repo; no need to
  re-emit it here.

  ```text
  NOTES (from KICKOFF_EXISTING_SOLUTION wizard, v1.3.1+):
    mode: adopt-existing-into-solution
    solution_name: {inferred from README/repo or asked}
    projects:
      - name: {project_name_1}
        platform: {platform}
        language: {language}
        template_recipe: {recipe_path or "custom — no recipe"}
        deploy_state: {deployed | not_deployed}
      - name: {project_name_2}
        ...
    tier: {tier}
    license: {license}
    compliance: {compliance}
    hooks_status: {present | missing}
    docs_status: {present | missing}
  ```

Why a NOTES block instead of the full ADOPT prompt:
`ADOPT_PROMPT.md` already lives at `/ai/templates/ADOPT_PROMPT.md`
in the repo. Re-emitting its body floods the chat without
adding information.

## After generating

Render exactly:

  Want me to run this inline now, or copy into a fresh session?
  Fresh is cleaner; inline is faster.

Wait for an answer.

## Hard rules

- Do NOT modify any planning files or app code in this session.
- Do NOT ask compliance / budget / cloud questions for
  not-deployed brownfield (those defer to P3-T0); only ask if
  the repo already deployed (the cap+threshold are real, not
  preferences).
- Do NOT invent project boundaries that aren't supported by
  repo signals.
- Keep it tight — typically 2 confirmations from the user
  (project list + tier) + optional compliance ask. If you find
  yourself in turn 5+, something went off-script.
- If signals are ambiguous (you can't tell whether `cli/` is an
  internal admin script or a shipped CLI), ASK rather than
  guess.
```
