# Tasks

Last Updated: 2026-05-03

## Active Task
None

---

## Ready

### P0-T1: Initialize project-specific AI files
Status: Ready
Owner: Claude Code
Priority: High

#### Goal
Use the user's application description to convert this starter system into a
project-specific planning and tracking system. Confirm or override the default
tech stack from `/ai/PROJECT.md`.

#### Scope Included
- Update `/ai/PROJECT.md` (name, description, goals, non-goals, target users)
- Update `/ai/CURRENT_STATE.md`
- Update `/ai/ARCHITECTURE.md` if the project differs from the default pattern
- Update `/ai/ROADMAP.md` with project-specific milestones
- Create initial implementation tasks in `/ai/TASKS.md`
- Update `/ai/TESTING.md` if testing strategy diverges from defaults
- Update `/ai/DEPLOYMENT.md` with project-specific Azure resource names
- Add project-specific ADRs to `/ai/DECISIONS.md` (only for overrides of
  ADR-001 through ADR-010)
- Update `/ai/HANDOFF.md`

#### Scope Excluded
- Do not create application code yet.
- Do not run `pnpm install` or `npm install` yet.
- Do not configure Azure resources yet.
- Do not create production secrets.

#### Acceptance Criteria
- All TBD sections in `PROJECT.md` are replaced with project-specific content
  or intentionally marked as open questions.
- First three Phase-1 tasks are queued.
- Project boundaries and non-goals are documented.
- Any deviation from the default stack has a corresponding ADR.

#### Test Requirements
Not applicable for planning-only task.

---

## Backlog

### P1-T1: Scaffold Astro 5 + React 19 + Tailwind 4 project
Status: Backlog
Owner: Claude Code
Priority: High

#### Goal
Create the initial scaffold of the project per `/ai/PROJECT.md` defaults,
running natively in WSL.

#### Scope Included
- `pnpm create astro@latest` (or equivalent), select TypeScript strict
- Add `@astrojs/react`, `react`, `react-dom`
- Add `@tailwindcss/vite`, configure in `astro.config.ts`
- Add `vitest`, `@testing-library/react`, `@testing-library/jest-dom`
- Add `eslint`, `typescript-eslint`, flat config
- Add `.env.example` with all variables from `/ai/DEPLOYMENT.md`
- Add `.gitignore` covering `.env.local`, `dist/`, `node_modules/`,
  `.vscode/settings.json`
- Add `package.json` scripts: `dev`, `build`, `preview`, `test`, `test:watch`,
  `lint`, `typecheck`
- Pin pnpm via `packageManager` field
- Verify `pnpm dev`, `pnpm build`, `pnpm test` all run cleanly
- Commit and push first branch

#### Scope Excluded
- Do not build the contact form yet (P2-T1).
- Do not configure Azure resources yet (P4-T1).
- Do not write content yet (P2 tasks).

#### Acceptance Criteria
- `pnpm dev` serves a placeholder homepage at `localhost:4321`.
- `pnpm build` produces a `dist/` directory with static assets.
- `pnpm lint && pnpm typecheck && pnpm test && pnpm build` all exit 0.
- All work happened in `~/repos/<project>` inside WSL — no `/mnt/c` paths
  appear in any file.

#### Test Requirements
- One placeholder Vitest spec (`tests/sanity.test.ts`) exists and passes.

---

### P1-T2: Add GitHub Actions CI workflow
Status: Backlog
Owner: Claude Code
Priority: High

#### Goal
Add `.github/workflows/ci.yml` per `/ai/DEPLOYMENT.md`. Wired to run on
`push` and `pull_request`, NOT `workflow_dispatch`-only.

#### Acceptance Criteria
- CI runs lint, typecheck, test, build on PR and push to `main`.
- pnpm cache restored from lockfile.
- First PR shows green check.

---

### P1-T3: Create project `README.md`
Status: Backlog
Owner: Claude Code
Priority: Medium

#### Goal
Create a project-level `README.md` at the repo root so the GitHub landing
page is not empty and so any human (or AI) cloning the repo immediately
sees how to get oriented.

#### Scope Included
- One-paragraph project description (lifted from `/ai/PROJECT.md`).
- Tech stack summary (Astro 5 + React 19 + Tailwind 4 + Azure SWA).
- Quick-start: `pnpm install`, `pnpm dev`, expected URL.
- Pointer to `/ai/START_HERE.md` for the AI workflow.
- License or "All rights reserved" line as appropriate.

#### Scope Excluded
- Do not duplicate `/ai/PROJECT.md` content in full — link to it.
- Do not document the deploy process here — link to `/ai/DEPLOYMENT.md`.
- Do not defer this past Phase 1. An empty repo landing page is a quality
  smell that compounds the longer it sits.

#### Acceptance Criteria
- `README.md` renders cleanly on GitHub.
- Links to `/ai/START_HERE.md`, `/ai/PROJECT.md`, and `/ai/DEPLOYMENT.md`
  resolve.
- Quick-start commands actually work in WSL on a fresh clone.

---

## Blocked
None

## Review
None

## Done
None
