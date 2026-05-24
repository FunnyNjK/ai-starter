# Add Project Prompt

Use this prompt to add a new project to an existing `ai-starter`
solution (one that already has a project-specific `/ai/SOLUTION.md`).
This is the actor invoked after `KICKOFF_ADD_PROJECT.md` finishes
its wizard.

This is one of the actor prompts in the v1.2.0+ family:

- **INIT_PROMPT.md** — first-run: creates solution + first project.
- **ADD_PROJECT_PROMPT.md** (this file) — subsequent runs: adds a
  project to an existing solution.
- **ADOPT_PROMPT.md** — retrofit `/ai/` onto an in-place existing
  app that doesn't have a planning folder yet.
- **REFRESH_PROMPT.md** — housekeeping pass on a project that has
  `/ai/` from an older starter version.

The friendly entry point that generates a customized version of
this prompt is `/ai/templates/KICKOFF_ADD_PROJECT.md`.

---

## Prompt to paste to the AI assistant

```text
You are adding a new project to an existing `ai-starter` solution.

The NOTES block below carries the answers from
KICKOFF_ADD_PROJECT.md. If no NOTES block is present, surface that
and recommend the user run KICKOFF_ADD_PROJECT.md first.

## Bootstrap checklist

Before editing files, confirm:

- `/ai/SOLUTION.md` exists and is project-specific. If TBD, STOP —
  use INIT_PROMPT.md (this is a first-run, not an add-project).
- `/ai/PROJECT.md` does NOT exist (would indicate a pre-1.2.0
  starter). If it does, STOP — run REFRESH_PROMPT.md first.
- The NOTES block lists a `project_name` that does NOT collide
  with any project in `/ai/SOLUTION.md` "Projects" table. If it
  collides, STOP and ask the user for a different name.
- The NOTES block lists a `template_recipe` path that exists under
  `/ai/templates/recipes/`. If it doesn't, STOP — the wizard
  produced a bad recipe path.
- No real secrets are in your context. Placeholders only.

## Step 1 — Read AI files

Read `/ai/START_HERE.md`, `/ai/AI_RULES.md`, `/ai/SOLUTION.md`,
`/ai/ARCHITECTURE.md`, `/ai/DECISIONS.md`, and the template recipe
file referenced in the NOTES block (`{template_recipe}`).

Honor all (Hard) rule blocks — particularly Local-First Development
Rule (no cloud / IaC / OIDC ADRs in this step), Versioning Rules
(verify every dep version live from canonical source), and Task
Quality Rules (every new task lists `Project: {project_name}`).

## Step 2 — Validate the feature loop (under-scope + over-scope)

Apply the same dual validation as INIT_PROMPT.md Step 2:

- **Under-scope refusal**: foundation/architecture-shaped
  answers get pushed back (same rules as INIT).
- **Over-scope check**: if the NOTES block carries
  `feature_loop_scope_check: required` (every v1.3.1+ wizard
  sets this), check whether the feature_loop describes
  capabilities the chosen template can deliver. If not,
  clarify with the user — they may be describing the broader
  product rather than just THIS project. See INIT Step 2's
  over-scope section for the prompt shape and the three
  resolution options (narrow / rewrite / pause-and-add-project).

## Step 3 — Read the template recipe

The recipe file lists the opinionated stack + design philosophy
for this template (dep list, folder layout, auth handoff,
migration ownership, etc.). Use it as the canonical source for:

- Required dependencies + their canonical-source URLs for version
  lookup.
- Folder structure for `projects/{project_name}/`.
- README content for `projects/{project_name}/README.md`.
- Inter-layer auth pattern (if applicable for the template).
- DB / cache / queue runtime versions to pin in the local
  container runtime (matches what the solution already uses where
  possible — read `/ai/DEV_ENVIRONMENT.md` or `/ai/SOLUTION.md`).

Do NOT silently substitute deps. If the recipe says Postgres but
the existing solution already pins MySQL, surface the conflict
and ask which to use.

## Step 4 — Verify dependency versions live

Per the Versioning Rules in `/ai/AI_RULES.md`, look up the current
stable version of every dep in the recipe from its canonical
source (npm registry / PyPI / NuGet / Maven Central / pkg.go.dev /
Docker Hub for DB images / etc.) AS OF TODAY. Do NOT pin from
training-data knowledge.

For each dep, capture: name, verified version, canonical source
URL, date verified.

## Step 5 — Create `projects/{project_name}/`

Create the project folder with the recipe's scaffold (folder
layout per recipe + a `README.md` with stack + local-dev story +
links to the relevant solution-level files).

Do NOT install dependencies yet. That happens in the new project's
first Phase-1 task (P{phase}-T{n}: Scaffold {project_name}). This
prompt only creates the planning shape.

The project README MUST include:

- Project name + template + verified dep versions + canonical
  source URLs + date verified.
- Local-dev story: how to run, how to test, how to build.
- Inter-project communication: links to projects in `talks_to`
  with the wire-protocol (HTTP / gRPC / shared package / etc.).
- Links to the solution-level files for everything cross-project
  (security baseline, deploy planning, tier, license).

## Step 6 — Update `/ai/SOLUTION.md`

Add a new row to the "Projects" table:

  | {project_name} | {platform} | {language} | {template name} | Phase 1 |

If the new project introduces a stateful dep the solution didn't
have before (e.g., first project to need Postgres), add it to the
Infrastructure section under "Per-project local container
versions" with the verified version.

Update the `Last Updated` line.

## Step 7 — Update `/ai/ARCHITECTURE.md` Mermaid diagram

The "System Overview" Mermaid `flowchart LR` has one node per
existing project. Add a node for `{project_name}` and add edges
to each project in `talks_to` (one edge per dependency).

Annotate the new node with its rough role (e.g., "Web app" or
"API service"). Do NOT add vendor names to the diagram —
versioned product names live in ADRs, not the diagram.

If the solution already has a cloud subgraph for hosted projects
(written at P3-T0), add `{project_name}` to it if the project
requires hosting. Otherwise leave the subgraph unchanged.

Update the `Last Updated` line.

## Step 8 — Add ADRs to `/ai/DECISIONS.md`

For each major stack choice in the recipe (language version,
framework version, ORM, auth library, schema validator, test
runner, lint/format, package manager, container image versions
for stateful deps), append an ADR to `/ai/DECISIONS.md` numbered
sequentially after the existing ADRs.

ADR shape (one per choice):

  ## ADR-NNN: {Decision title}
  Date: {today}
  Status: Accepted
  Project: {project_name}

  ### Decision
  Use {dep} {verified version} for {project_name}. Verified on
  {today} from {canonical source URL}.

  ### Reason
  {Rationale from the recipe, not invented.}

  ### Tradeoffs
  {Honest tradeoffs from the recipe.}

  ### Related Tasks
  {Phase-1 task IDs for {project_name}.}

The `Project: {project_name}` line is mandatory per the Task
Quality Rules (extended to ADRs by convention — this lets future
sessions filter ADRs by project).

## Step 9 — Queue Phase-1 tasks for the new project

Append to `/ai/TASKS.md`. Use the next available task IDs
(continue the solution-wide P{phase}-T{n} sequence). Each task
includes `Project: {project_name}` per Task Quality Rules.

Always (in order, per Local-First Development Rule):

1. P1-T{n}: Scaffold `{project_name}` per the recipe.
2. P1-T{n+1}: Verify local development loop is green for
   `{project_name}` (gates the next task).
3. P1-T{n+2}: Configure CI that mirrors the local loop for
   `{project_name}`.
4. P1-T{n+3}: Add the new project to the solution's
   Dependabot / Renovate config.

### Workspace detection (conditional)

Check whether the new project shares a language ecosystem with
any existing project in the solution's Projects table:

| Ecosystem | Trigger | Workspace recipe | Workspace file |
|-----------|---------|------------------|----------------|
| TypeScript / JavaScript | New project's language is TS or JS AND another TS/JS project exists | `/ai/templates/recipes/workspaces/pnpm-workspace.md` | `pnpm-workspace.yaml` at solution root |
| C# / .NET | New project's language is C# AND another C# project exists | `/ai/templates/recipes/workspaces/dotnet-solution.md` | `*.sln` at solution root |
| Go | New project is Go AND another Go project exists AND they may import each other | `/ai/templates/recipes/workspaces/go-work.md` | `go.work` at solution root |
| Rust | New project is Rust AND another Rust project exists | `/ai/templates/recipes/workspaces/cargo-workspace.md` | `[workspace]` block in root `Cargo.toml` |
| Python | n/a — Python has no workspace concept | (none) | (none) |

If an ecosystem trigger matches AND the corresponding workspace
file does NOT already exist at solution root, queue an
additional task:

5. P1-T{n+4}: Set up `<ecosystem>` workspace at solution root.
   Project: `solution`. Linked to the matching workspace
   recipe. **Tier-aware behavior**:
   - **Solo prototype**: queue with `Status: Deferred` and a
     note ("workspace not strictly needed for one developer;
     promote when a second project starts sharing code with
     this one"). The user can manually promote to Ready.
   - **Small team / early production / production**:
     `Status: Ready`. The user should land this before the new
     project's Phase-2 work.

Multiple ecosystems can match — queue one workspace task per
matching ecosystem (e.g., a solution adding both a TS project
and a Go project simultaneously would get both pnpm-workspace
and go-work tasks).

Skip the workspace task entirely if:

- This is the FIRST project of its ecosystem in the solution
  (no overlap → no workspace needed yet).
- The workspace file already exists at solution root.
- The user has an explicit ADR override declining workspace
  setup for this ecosystem.

### Deploy work (still deferred to P3-T0)

Per the Local-First Development Rule, do NOT queue Phase-1
hosting / OIDC / IaC / first-deploy / cloud-budget tasks for the
new project. Those belong to:

- P3-T0 if not yet done (solution-level deploy planning).
- Phase 4 implementation tasks (queued by P3-T0).

If the new project introduces a new managed-service requirement
that P3-T0 already covered for other projects (e.g., the solution
already deploys to Cloud Run and the new project will too), add a
note to P3-T0's task body that this project also needs covering
when P3-T0 runs.

Each task follows `/ai/templates/TASK_TEMPLATE.md` — Prerequisites,
Step-by-Step (in order), Acceptance Criteria, Verification,
Rollback / Recovery, Project line.

## Step 10 — Update `/ai/CURRENT_STATE.md` and `/ai/HANDOFF.md`

CURRENT_STATE.md "What Exists Now" gets a new bullet:
- `{project_name}` planning shape added (Phase 0 done for this
  project). Scaffold not yet built.

HANDOFF.md "Last Completed Task" gets an entry for this
add-project session. "Next Recommended Task" points at the new
P1-T{n} scaffold task for `{project_name}`.

Keep both files within their line caps (CURRENT_STATE ≤ 80,
HANDOFF ≤ 50). Move displaced detail to `/ai/DONE_LOG.md`.

## Step 11 — Update `/ai/DONE_LOG.md`

Add an entry under today's date:
- Added project `{project_name}` ({template name}) to the
  solution via ADD_PROJECT_PROMPT. Recipe:
  {template_recipe}.

## Pre-flight self-check (mandatory before declaring this add-project done)

Confirm each item below. If ANY is unchecked, STOP and complete
it.

  Pre-flight before closing the add-project session:
  - [ ] `/ai/SOLUTION.md` Projects table has a row for
        `{project_name}`.
  - [ ] `/ai/ARCHITECTURE.md` Mermaid diagram has a node for
        `{project_name}` and edges to every project in
        `talks_to`.
  - [ ] `/ai/DECISIONS.md` has one ADR per major stack choice
        in the recipe, each tagged with `Project: {project_name}`
        and a verified version + canonical source URL + date.
  - [ ] `/ai/TASKS.md` has Phase-1 tasks for `{project_name}` in
        the Local-First order (scaffold → verify local green →
        CI mirrors → Dependabot).
  - [ ] **Workspace check**: if the new project shares an
        ecosystem with an existing project (TS/JS, .NET, Go,
        Rust) AND the workspace file doesn't already exist at
        solution root AND the user didn't ADR-decline it, a
        workspace-setup task is queued linking to the matching
        recipe under `/ai/templates/recipes/workspaces/`.
        Status is `Deferred` for solo prototype tier, `Ready`
        otherwise.
  - [ ] No Phase-1 hosting / OIDC / IaC / first-deploy / cloud-
        budget tasks were queued for `{project_name}`.
  - [ ] If P3-T0 was already Done (solution already deployed),
        Phase-4 implementation tasks for `{project_name}` are
        queued. If P3-T0 was not yet Done, a note was added to
        P3-T0's body to include `{project_name}` when run.
  - [ ] `projects/{project_name}/README.md` exists with the
        recipe's content + verified versions.
  - [ ] `/ai/CURRENT_STATE.md` ≤ 80 lines, `/ai/HANDOFF.md` ≤ 50
        lines.
  - [ ] Every touched planning file has a fresh
        `Last Updated: YYYY-MM-DD`.
  - [ ] `python3 scripts/lint-planning.py` passes with 0 errors
        and 0 warnings.

## Hard rules

- Do NOT scaffold the new project's code yet (P1-T{n} task).
- Do NOT install dependencies yet (P1-T{n} task).
- Do NOT create cloud resources or write deploy ADRs (P3-T0 /
  Phase 4 territory).
- Do NOT re-interview the user on solution-level settings.
- Use placeholders only, never real secrets.
- Look up versions from canonical sources — never assume from
  training-data knowledge.
- Push after every commit (Git Rules in AI_RULES.md).
- Confirm before any destructive operation (Destructive Operations
  Rules).
- Mark Blocked, do not silently work around (Blocked Escalation
  Rule).
- Run the Pre-flight self-check above before closing.

Begin with a Start-of-Chat summary (START_HERE.md section 5).
End with the End-of-Chat report (START_HERE.md section 6) —
including the self-critique section.
```
