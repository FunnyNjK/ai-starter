# Roadmap

Last Updated: 2026-05-02

## Phase 0: Project Initialization
Status: Ready

Goals:
- Convert starter files into project-specific planning files.
- Define application scope.
- Confirm or override default architecture.
- Create first implementation tasks.

Deliverables:
- `PROJECT.md` filled in (name, description, goals, non-goals).
- `CURRENT_STATE.md` reflects "scaffold not yet built."
- Project-specific ADRs added if defaults are overridden.
- First implementation tasks queued in `TASKS.md`.

## Phase 1: Foundation
Status: Backlog

Goals:
- Scaffold the Astro 5 + React 19 + Tailwind 4 + TypeScript project.
- Add Vitest, ESLint 9 flat config, Prettier (or formatting via ESLint).
- Add `.env.example`, `.gitignore`, `README.md` (project-level).
- First passing CI run on a placeholder homepage.

Deliverables:
- `pnpm dev` runs the homepage in WSL.
- `pnpm lint && pnpm typecheck && pnpm test && pnpm build` all pass.
- GitHub Actions `ci.yml` passes on push.

## Phase 2: Core Feature Buildout
Status: Backlog

Goals:
- Build the actual pages and content.
- Implement the contact form (frontend + Azure Function).
- Wire Postmark and Turnstile.
- Add rate limiting.

Deliverables:
- Each page rendered.
- Contact form successfully sends test email via Postmark.
- Turnstile blocks unverified submissions.
- Rate limiter enforces per-IP limits.

## Phase 3: Hardening and Testing
Status: Backlog

Goals:
- Test coverage targets met.
- Error handling reviewed.
- Accessibility pass (WCAG AA where applicable).
- Lighthouse audit and fixes.

## Phase 4: Deployment and Operations
Status: Backlog

Goals:
- Configure Azure SWA resource.
- Set up OIDC federation in Azure AD.
- First production deploy.
- Custom domain configured with SSL.
- Document release process.

Deliverables:
- Live site at custom domain.
- Postmark + Turnstile configured against production keys.
- Rollback plan tested at least once.

## Phase 5: Enhancements
Status: Backlog

Goals:
- Per-project optional improvements after the core app is stable.
