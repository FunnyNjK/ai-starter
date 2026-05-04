# Architecture Decision Records

Last Updated: 2026-05-02

This file records decisions that affect architecture, dependencies, security,
deployment, testing, or scope. The first block of ADRs (ADR-001 through
ADR-010) are pre-populated cross-project defaults baked into this starter.
Project-specific decisions begin at ADR-011.

To override a baked-in default for a specific project, write a new ADR with
status "Accepted" that supersedes the original. Do NOT edit the baked-in
ADRs except to mark them "Superseded" and add a pointer to the new one.

---

## ADR-001: WSL-native development, no Docker for dev
Date: 2026-05-02
Status: Accepted

### Decision
All development (dev server, tests, build, lint, type-check) runs as native
processes inside WSL Ubuntu. Docker is reserved exclusively for hosting
external dependencies the app talks to (databases, queues, cache).

### Reason
Mixed dev environments (host Windows + WSL + Docker containers) create
ambiguous file paths and confuse AI agents into editing the wrong copy of a
file. WSL2 native filesystem is fast (5-20x faster than `/mnt/c`), and
modern editor tooling (VS Code/Cursor WSL Remote) handles the host/guest
boundary cleanly without containers.

### Tradeoffs
- Slightly different from prod if prod runs in containers — mitigated by
  keeping app code framework-aware but environment-agnostic.
- Onboarding requires a working WSL setup. Documented in `/ai/DEV_ENVIRONMENT.md`.

---

## ADR-002: Static-first frontend with Astro 5 + React 19 islands
Date: 2026-05-02
Status: Accepted

### Decision
Use Astro 5 as the page framework. Static content lives in `.astro` files;
interactive components are React 19 mounted as islands.

### Reason
Marketing/static sites benefit from pre-rendered HTML for SEO, fast first
paint, and minimal JS shipped to the client. Astro is purpose-built for this
shape, supports React for the parts that need interactivity, and outputs
real static files that drop into Azure SWA's static hosting at the free tier.

Considered and rejected:
- **Next.js with `output: 'export'`** — works, but adds framework complexity
  for capabilities (SSR, ISR, middleware) we don't need.
- **Next.js with `output: 'standalone'`** — requires a Node host, not a
  static-hosting fit; doesn't deploy cleanly to SWA's free static tier.
- **Vite + React SPA** — works but ships an empty HTML shell, hurts SEO
  and first paint, no SSR.

### Tradeoffs
- Astro is less ubiquitous than Next.js; some Next-specific features
  (middleware, ISR, server actions) don't exist. Acceptable for this class
  of project.
- Mental model: pages are `.astro`, components are React. Mild context shift,
  documented in `/ai/PROJECT.md`.

---

## ADR-003: Tailwind 4 via the official Vite plugin
Date: 2026-05-02
Status: Accepted

### Decision
Use Tailwind 4 with the `@tailwindcss/vite` plugin (Astro 5 supports Vite
plugins natively).

### Reason
Tailwind 4 is the current major version. The Vite plugin avoids PostCSS
configuration entirely. Aligns with where the rest of the JS ecosystem is
heading.

### Tradeoffs
None significant. Tailwind 4 has minor breaking changes from v3
(documented in their migration guide); new projects start clean.

---

## ADR-004: pnpm as the only package manager
Date: 2026-05-02
Status: Accepted

### Decision
Use pnpm exclusively. Never commit `package-lock.json` or `yarn.lock`. The
`packageManager` field in `package.json` pins the pnpm version.

### Reason
- Faster, disk-efficient (content-addressed store, hard-linked).
- Strict by default — no phantom hoisted dependencies.
- A previous project in the user's portfolio shipped both `pnpm-lock.yaml`
  AND `package-lock.json`; the lockfiles drifted between local and CI builds.
  Choosing one and enforcing it eliminates that class of bug.

### Tradeoffs
- Some npm-only tooling occasionally has pnpm-incompatibility quirks.
  Resolved case-by-case.

---

## ADR-005: Azure Static Web Apps with managed Functions API
Date: 2026-05-02
Status: Accepted

### Decision
Deploy frontend as static files to Azure Static Web Apps. Deploy the contact
endpoint as the SWA managed API (Azure Functions v4, Node 24 LTS ESM).
Dev / CI / Functions runtime all on the same Node major.

### Reason
- Free SSL on custom domains.
- Free tier covers small marketing sites.
- Single deploy artifact (one repo, one workflow, one URL).
- The user has existing comfort with Azure deployments.

### Tradeoffs
- Vendor lock to Azure. Acceptable for the marketing-site class of project.
- Free tier has bandwidth/request limits; standard tier upgrade is a
  one-line change in the SWA resource.

---

## ADR-006: GitHub Actions deployment with OIDC federated auth
Date: 2026-05-02
Status: Accepted

### Decision
GitHub Actions deploys to Azure SWA using OIDC federated credentials. No
static service principal client secrets in repo or repo secrets.

### Reason
OIDC federation is the modern Azure auth pattern: no secret to rotate, no
secret to leak. The user's existing `devildog` project already uses this
pattern.

### Tradeoffs
- Requires a one-time federated credential setup in Azure AD (5-minute task
  per project). Documented in `/ai/DEPLOYMENT.md`.

---

## ADR-007: Postmark + Cloudflare Turnstile + honeypot + rate limiting
Date: 2026-05-02
Status: Accepted

### Decision
Contact form uses Postmark for delivery, Cloudflare Turnstile for bot
mitigation, an unrendered honeypot field as a second layer, and per-IP
rate limiting on the function.

### Reason
- Postmark: reliable transactional delivery, simple API.
- Turnstile: invisible-by-default, no Google dependency (vs reCAPTCHA),
  privacy-respecting.
- Honeypot + rate limit: cheap defense in depth against the bots that
  bypass Turnstile.

### Tradeoffs
- Two third-party services to maintain accounts for.
- Postmark is paid above small volume — free tier covers ~100 emails/month
  per server. For higher volume, switch to a paid plan or different ESP and
  add an ADR.

---

## ADR-008: TypeScript strict, ESM only, ES2022 target
Date: 2026-05-02
Status: Accepted

### Decision
All new code is TypeScript with strict mode. ESM only — no CommonJS
`require()`. Compilation target ES2022.

### Reason
Strict TS catches real bugs cheaply. ESM is the JS standard; CJS is
legacy. ES2022 covers Node 24+ and modern browsers without polyfill noise.

### Tradeoffs
- Some older npm packages still ship CJS-only. Resolved per-package; if
  truly stuck, document in an ADR.

---

## ADR-009: Vitest 3+ for unit and component tests
Date: 2026-05-02
Status: Accepted

### Decision
Use Vitest 3+ as the only test runner. No Jest, no Mocha. Component tests
use `@testing-library/react` + `@testing-library/jest-dom`.

### Reason
- Native ESM support (matches the rest of the toolchain).
- Vite-based, shares Astro's underlying build.
- Faster than Jest for small projects.
- One runner = one config = less drift.

### Tradeoffs
- Some Jest-only ecosystem packages need adapters. Rare in practice.

---

## ADR-010: CI runs on push and pull_request, not workflow_dispatch
Date: 2026-05-02
Status: Accepted

### Decision
The CI workflow (`ci.yml`) is `on: [push, pull_request]`. It is NOT
`workflow_dispatch`-only. Quality gates fire on every PR and merge to main.

### Reason
A previous project had `ci.yml` set to `workflow_dispatch` only, which meant
test failures only surfaced during deploys — past the point where they
should have blocked the merge. Standard CI hygiene says gates run on PRs.

### Tradeoffs
- Slightly more Actions minutes consumed. Negligible at this scale.

---

## ADR Template

## ADR-XXX: Title
Date: YYYY-MM-DD
Status: Proposed | Accepted | Rejected | Superseded

### Decision
TBD

### Reason
TBD

### Tradeoffs
TBD

### Related Tasks
TBD
