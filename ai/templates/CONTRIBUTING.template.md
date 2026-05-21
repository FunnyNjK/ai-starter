# Contributing

Thanks for considering a contribution! This guide gets you from
"freshly cloned" to "first PR open" with the conventions this project
uses.

## TL;DR

1. Read [README.md](README.md) for what the project is.
2. Read [`/ai/START_HERE.md`](ai/START_HERE.md) for how the AI workflow
   is structured (relevant even if you're a human — `/ai/` is the
   shared project memory).
3. Read [`/ai/WORKFLOW.md`](ai/WORKFLOW.md) for branching, PRs,
   hotfixes, and how blockers are escalated.
4. Run the dev environment per the Quick Start in `README.md`.
5. Open a PR using the template — verify the checklist before asking
   for review.

## Dev environment setup

See `/ai/DEV_ENVIRONMENT.md` for the canonical setup. The README has
the day-one quick start; `DEV_ENVIRONMENT.md` covers the toolchain in
detail (versions, common pitfalls, troubleshooting).

## Adding a new project to the solution

This repo follows the `ai-starter` solution/project model: the repo
is the **solution**, and each app/service/library lives under
`projects/<name>/`. To add another project, paste
`/ai/templates/KICKOFF_ADD_PROJECT.md` into your AI tool — the wizard
collects the platform / language / template / name and generates an
`ADD_PROJECT_PROMPT.md` invocation that creates
`projects/<new-name>/` and updates the solution-level planning files.

## Project conventions

- **Branch naming**: `feat/<slug>`, `fix/<slug>`, `chore/<slug>`,
  `hotfix/<slug>`. AI-driven branches use `claude/<slug>`,
  `cursor/<slug>`, `codex/<slug>`, or `copilot/<slug>` (matching the
  phase harness in use). See `/ai/WORKFLOW.md`.
- **Task naming**: tasks in `/ai/TASKS.md` include a
  `Project: <name>` line identifying which project they touch
  (`Project: solution` for solution-level tasks).
- **Commit messages**: short imperative, ~70 chars max. Match the
  existing style in `git log`.
- **Code style**: enforced via the project's linter and formatter.
  Run `{lint command}` and `{format command}` before opening a PR.
- **Tests**: every behavior change ships with a test. Bug fixes ship
  with a regression test. See `/ai/TESTING.md`.
- **Architecture changes**: any change that affects architecture,
  dependencies, security, deployment, data model, or scope needs an
  ADR in `/ai/DECISIONS.md` (use the template at the bottom of that
  file).

## Pull request workflow

1. Create a branch off `main` with the correct prefix.
2. Make your change. Keep the change focused; one PR per logical
   concern.
3. Run the project's verification commands locally:
   - `{lint command}`
   - `{typecheck command}` (if applicable)
   - `{test command}`
   - `{build command}`
4. Update `/ai/CURRENT_STATE.md`, `/ai/HANDOFF.md`, `/ai/DONE_LOG.md`
   for any meaningful change. Add or update an ADR if an architecture
   decision was made.
5. Push your branch and open a PR. The PR template will auto-populate.
   Fill in every section honestly (untested boxes stay unchecked).
6. CI must be green before merge.
7. Address review comments. For style-only nits, the reviewer should
   leave non-blocking comments.
8. Squash-merge for `feat/`/`fix/`/`chore/` branches; merge-commit for
   `hotfix/`.

## Reporting bugs

Open a GitHub issue with:

- A clear title.
- Steps to reproduce.
- Expected vs. actual behavior.
- Environment info (OS, runtime version, anything else relevant).
- Logs or screenshots if helpful.

For security-sensitive bugs, see [SECURITY.md](SECURITY.md) — do
**not** report security issues in public issues.

## Suggesting features

Open a GitHub issue with:

- The problem you're trying to solve (not just the solution).
- Why the current state is insufficient.
- Optional: a proposed approach. We'll usually want to discuss before
  you spend significant time implementing.

Significant features may warrant an ADR in `/ai/DECISIONS.md` before
implementation.

## Code of conduct

Be kind. Assume good faith. Disagree about ideas, not people.

If applicable, this project follows the [Contributor Covenant Code of
Conduct](https://www.contributor-covenant.org/). Report violations to
{conduct-contact}.

## License

By contributing, you agree that your contributions will be licensed
under the same license as the project (see [LICENSE](LICENSE)).
