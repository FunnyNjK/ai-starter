# Project

Last Updated: 2026-05-02

## Project Name
TBD

## Application Description
TBD - Replace this with a plain-English description of what this site does
and who it's for.

## Problem Being Solved
TBD

## Target Users
TBD

## Primary Goals
- TBD

## Explicit Non-Goals
- TBD

---

## Default Tech Stack (override per-project via ADR if needed)

### Frontend
- **Astro 5** as the page framework (static-first, fast).
- **React 19** for interactive components, mounted as Astro islands via
  `@astrojs/react`. Static content stays as `.astro` files.
- **Tailwind 4** via the `@tailwindcss/vite` plugin (Astro 5's Vite-native
  Tailwind integration).
- **TypeScript strict mode**, ES2022 target, ESM only.

### Backend (contact form / dynamic pieces only)
- **Azure Functions v4** (Node 24 LTS, ESM) deployed as the Azure SWA managed API.
- All business logic (Postmark send, Turnstile verify, IP extraction,
  rate-limit check) extracted into a `lib/` folder for testability.
- No database in this default. Add one only if the project requires it (and
  add an ADR documenting why).

### Database
- **None by default.** When a project needs persistence, default to:
  - **Postgres 16** for relational data
  - **MongoDB 8** for document data
- Database runs as a Docker container locally; production database is the
  cloud equivalent (Azure Database for PostgreSQL, Azure Cosmos DB for
  MongoDB API, etc.) — selected per-project.

### Authentication
- None by default. Marketing/static sites typically don't need auth.
- If needed, default choice is documented in a project ADR.

### Email
- **Postmark** (transactional). Templates managed in Postmark dashboard;
  template IDs referenced via env vars.

### Bot mitigation
- **Cloudflare Turnstile** (server-side verification in the Azure Function).
- Honeypot field as a second layer.
- Rate limiting on the function (per IP, sliding window).

### Testing
- **Vitest 3+** for unit and component tests.
- **@testing-library/react + @testing-library/jest-dom** for component tests.
- **ESLint 9 flat config** + **typescript-eslint** for lint.
- All tests run as native Node processes in WSL — no Docker, no test runners
  in containers.

### Package management
- **pnpm 10+** (corepack-managed, version pinned in `packageManager` field).
- Single lockfile (`pnpm-lock.yaml`). Never commit a second lockfile.

### Deployment
- **Azure Static Web Apps** (free tier when applicable; standard tier when
  more bandwidth/staging environments are needed).
- Deployment via **GitHub Actions with OIDC federated auth** — no static
  service principal secrets in repo.
- Custom domain + free SSL provided by SWA.

### CI
- GitHub Actions workflow runs on every PR and push to `main`:
  - lint
  - typecheck
  - test
  - build
- Workflow is `on: [push, pull_request]`, NOT `workflow_dispatch`-only.

---

## Repository Structure (default)

```
.
├── ai/                        # this folder; AI workflow files
├── public/                    # static assets (favicons, robots.txt, etc.)
├── src/
│   ├── components/            # React components (interactive islands)
│   ├── layouts/               # Astro layouts
│   ├── lib/                   # shared utilities, types, validation
│   ├── pages/                 # Astro pages (.astro files)
│   └── styles/
├── api/                       # Azure Functions (managed API)
│   ├── contact/
│   │   ├── function.json
│   │   ├── index.ts
│   │   └── lib/               # business logic, unit-testable
│   └── package.json           # API has its own deps (kept minimal)
├── tests/                     # Vitest specs (mirrors src/ structure)
├── .github/workflows/
│   ├── ci.yml
│   └── deploy.yml
├── .vscode/                   # workspace settings (optional)
├── astro.config.ts
├── package.json               # pnpm-managed
├── pnpm-lock.yaml
├── tsconfig.json
├── tailwind.config.ts         # if needed; Tailwind 4 prefers minimal config
├── eslint.config.js           # flat config
├── vitest.config.ts
├── .env.example               # checked in
├── .env.local                 # gitignored
└── README.md
```

---

## Non-Negotiables

- Keep scope controlled.
- Update `/ai` project files after every meaningful change.
- Do not add dependencies without documenting the decision in
  `/ai/DECISIONS.md`.
- Tests or validation steps are required before marking tasks complete.
- Honor `/ai/AI_RULES.md` and `/ai/DEV_ENVIRONMENT.md` (WSL-native, no Docker
  for dev, no `/mnt/c` paths).

## AI Instructions

When this file is still generic (Project Name = TBD), use the user's
application description to replace the TBD sections with project-specific
details. Do NOT change the Default Tech Stack section unless the user
explicitly asks for a different stack — in which case, write an ADR in
`/ai/DECISIONS.md` documenting the override before changing this file.
