# {Project Name}

> One-paragraph description of what this project is and who it's for.
> Lift this from `/ai/SOLUTION.md` "Application Description" — keep it
> short.

## Tech stack

- {Language and runtime, e.g. "TypeScript 5.x on Node 22 LTS"}
- {Frontend framework / UI toolkit, if any}
- {Backend framework / runtime, if any}
- {Database(s), if any — note: managed in QA/prod, containerized for
  local dev}
- {Test framework}
- {Package manager}
- {Cloud target}
- {IaC: Terraform / OpenTofu}
- {CI: GitHub Actions / GitLab CI / etc.}

See `/ai/SOLUTION.md` for the full stack and `/ai/DECISIONS.md` for the
rationale behind each choice.

## Repository layout

This repo is a **solution** (per the `ai-starter` model) that holds
one or more **projects** under `projects/<name>/`. Solution-level
planning lives under `/ai/`; project-specific stack details live in
each project's `projects/<name>/README.md`.

```
.
├── ai/                       solution-level planning
├── projects/
│   ├── {project-1}/          one folder per project
│   │   └── README.md         project-specific stack + dev story
│   └── {project-2}/
├── LICENSE
├── README.md                 (this file)
└── ...
```

To add another project to the solution, paste
`/ai/templates/KICKOFF_ADD_PROJECT.md` into your AI tool — the wizard
walks you through the picks and produces the customized prompt that
adds the project.

## Quick start

```bash
# 1. Install dependencies (replace with the project's actual command)
{install command, e.g. pnpm install}

# 2. Set up local secrets
cp .env.example .env.local
# edit .env.local — see /ai/DEPLOYMENT.md for what each variable does

# 3. Start local stateful dependencies (DB, cache, etc.)
{e.g. docker compose up -d}

# 4. Run the dev server
{e.g. pnpm dev}
```

The app should be live at {expected local URL, e.g. http://localhost:3000}.

## Common commands

| Command | Purpose |
| ------- | ------- |
| `{lint command}` | Run linter |
| `{typecheck command}` | Type-check (if applicable) |
| `{test command}` | Run tests |
| `{build command}` | Production build |
| `{format command}` | Format code |

## AI workflow

This project uses an AI-assisted development workflow. The `/ai/`
folder is the project memory — planning, architecture, tasks,
decisions, deployment, handoff.

If you're an AI assistant: **read `/ai/START_HERE.md` first**.

If you're a human: see [CONTRIBUTING.md](CONTRIBUTING.md) for dev-env
setup, and `/ai/SOLUTION.md` for what the project is.

## Deployment

See `/ai/DEPLOYMENT.md`.

## Security

See [SECURITY.md](SECURITY.md) for vulnerability reporting and
supported versions. The project's security baseline is documented in
`/ai/SOLUTION.md` "Security Baseline" and `/ai/AI_RULES.md` Security
Rules.

## License

{License name, e.g. MIT — see [LICENSE](LICENSE)}.
