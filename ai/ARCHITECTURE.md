# Architecture

Last Updated: 2026-05-02

## Architecture Status
Default pattern documented; project-specific details TBD until initialization.

---

## System Overview (Default Pattern)

```
   Browser
      |
      | HTTPS (free SSL via SWA)
      v
   Azure Static Web Apps
   ├── Static hosting (Astro-built HTML/JS/CSS)
   |     ├── Pre-rendered Astro pages
   |     └── Hydrated React islands (contact form, etc.)
   |
   └── Managed API (Azure Functions)
         └── POST /api/contact
               ├── verify Turnstile token
               ├── check honeypot field
               ├── apply rate limit (per-IP sliding window)
               ├── send transactional email via Postmark
               └── return JSON status
```

External services:

- **Postmark** — transactional email API.
- **Cloudflare Turnstile** — CAPTCHA replacement, server-verified.
- **GitHub** — source control, CI/CD via Actions.
- **Azure** — hosting (SWA static + managed Functions).

---

## Major Components

### `src/pages/` — Astro pages
Static HTML pages, pre-rendered at build time. Content lives in `.astro`
files; dynamic interactive components are imported as React islands.

### `src/components/` — React components
Interactive UI: contact form, carousels, anything that needs client-side
state. Each is a standard React component, mounted via Astro's
`client:load` / `client:visible` directives.

### `src/lib/` — Shared frontend utilities
Types, schema validation (zod), formatting helpers. No framework code.

### `api/contact/` — Contact form endpoint
Azure Function HTTP trigger. Receives form POST, validates Turnstile,
sends Postmark email, returns status. Business logic in `api/contact/lib/`
for unit-testability without function-runtime dependencies.

### `tests/` — Test suite
Vitest specs. Mirrors `src/` structure. Unit tests for `lib/`, component
tests for interactive React components, integration tests for the contact
endpoint (mock Postmark + Turnstile, real HTTP).

---

## Data Flow

### Contact form submission

1. User fills form on a static Astro page (form is a hydrated React island).
2. Turnstile widget produces a token client-side.
3. React component POSTs `{ name, email, message, token, honeypot? }` to
   `/api/contact`.
4. Azure Function:
   - rejects if honeypot is non-empty
   - rejects if rate limit exceeded for source IP
   - calls Cloudflare Turnstile verify endpoint with the token + secret
   - if verified, calls Postmark send endpoint with templated email
   - returns `{ ok: true }` or `{ ok: false, reason: '...' }`
5. React component shows success or error UI.

---

## Security Model

- **Secrets** live in environment variables, never in source.
  - Local: `.env.local` (gitignored)
  - SWA: configured via Azure Portal or `swa-cli` env-var management
  - GitHub Actions: federated OIDC + Azure secrets (no static client secrets)
- **CORS** is implicit — same-origin from the SWA-served frontend.
- **Rate limiting** is enforced server-side; client-side is advisory only.
- **PII** in form submissions is forwarded to Postmark; not persisted on
  Azure unless a project specifically adds storage (and an ADR for it).
- **Turnstile keys** — site key is public; secret key is server-only.

---

## External Services

| Service              | Purpose                            | Where keys live                     |
| -------------------- | ---------------------------------- | ----------------------------------- |
| Postmark             | Transactional email                | env: `POSTMARK_API_TOKEN`           |
| Cloudflare Turnstile | Bot mitigation                     | env: `TURNSTILE_SECRET_KEY` (server) |
| Azure SWA            | Static hosting + managed API       | Azure portal config                 |
| GitHub Actions       | CI/CD                              | Repo secrets / OIDC federation      |

---

## Repository Structure
See `/ai/PROJECT.md` for the canonical default structure.

---

## Architecture Rules

- Keep business logic out of UI components. UI components consume hooks
  and utilities from `src/lib/`.
- Keep secrets out of source control.
- Document new dependencies in `/ai/DECISIONS.md`.
- Document architecture changes via ADR before or during implementation.
- The contact endpoint logic must be unit-testable in isolation from the
  Azure Functions runtime (extract into `api/contact/lib/`).
- One canonical implementation per concern. If the contact form logic is
  needed in two places, extract to a shared package, do not duplicate.

---

## Open Architecture Questions
- TBD per-project (filled in during P0-T1 initialization)
