# Recipe: Next.js Web App (TypeScript)

Last Updated: 2026-05-21
Applies to: Web platform + TypeScript language.

## What this template gives you

A single-deployable, server-rendered web app with auth, a Postgres
database via Drizzle ORM, and Tailwind for styling. Suitable for
SaaS dashboards, internal tools, content-driven sites with auth,
and any app where SSR / RSC matters more than pure client-side.

## Design philosophy

- **Single deployable, no separate API.** API logic lives in
  Next.js Route Handlers (`app/api/*/route.ts`). If/when the API
  grows beyond what fits cleanly inside the web app, you add a
  *separate* API project via add-project mode (NestJS recipe).
- **DB schema is owned by this project.** Drizzle migrations live
  in `db/migrations/`. If you later add an API project that
  reads the same DB, schema ownership stays here unless you
  explicitly move it.
- **Auth handoff: Auth.js sessions all the way down.** No JWTs
  at the edge — `auth()` server helper reads the session cookie
  on every server component / route handler. Client components
  use `useSession()` from `next-auth/react`.
- **Credentials never reach the client.** Server-only env vars
  use `process.env`; client-side vars are prefixed
  `NEXT_PUBLIC_*` (explicit + scanned by Next.js at build).

## Bundled stack (verified versions at init time)

| Component | Choice | Canonical source |
|-----------|--------|------------------|
| Framework | Next.js `<X.Y.Z>` (App Router) | https://www.npmjs.com/package/next |
| Language | TypeScript `<X.Y.Z>` | https://www.npmjs.com/package/typescript |
| Runtime | Node.js `<X.Y.Z>` LTS | https://nodejs.org/en/about/previous-releases |
| Package manager | pnpm `<X.Y.Z>` | https://www.npmjs.com/package/pnpm |
| Styling | Tailwind CSS `<X.Y.Z>` | https://www.npmjs.com/package/tailwindcss |
| ORM | Drizzle ORM `<X.Y.Z>` + drizzle-kit | https://www.npmjs.com/package/drizzle-orm |
| Database (local) | PostgreSQL `<X.Y>` (Docker image) | https://hub.docker.com/_/postgres |
| Auth | Auth.js `<X.Y.Z>` (next-auth v5) | https://www.npmjs.com/package/next-auth |
| Schema validation | Zod `<X.Y.Z>` | https://www.npmjs.com/package/zod |
| Email | Resend `<X.Y.Z>` (free tier 100/day) | https://www.npmjs.com/package/resend |
| Test runner | Vitest `<X.Y.Z>` | https://www.npmjs.com/package/vitest |
| Lint | ESLint `<X.Y.Z>` (flat config) | https://www.npmjs.com/package/eslint |
| Format | Prettier `<X.Y.Z>` | https://www.npmjs.com/package/prettier |

Pin verified versions at init per the Versioning Rules in
`/ai/AI_RULES.md`. Do NOT copy the `<X.Y.Z>` placeholders into a
real lockfile.

## Folder layout

```
projects/<name>/
├── app/                    # Next.js App Router
│   ├── (auth)/             # auth route group (sign-in, etc.)
│   ├── (app)/              # authenticated app routes
│   ├── api/                # Route Handlers
│   ├── layout.tsx
│   └── page.tsx
├── components/             # React components
├── lib/                    # server + client utilities
├── db/                     # Drizzle schema + migrations
│   ├── schema.ts
│   └── migrations/
├── public/                 # static assets
├── tests/                  # Vitest tests
├── docker-compose.yml      # local Postgres
├── .env.example
├── package.json
├── pnpm-lock.yaml
├── tsconfig.json
├── next.config.ts
└── README.md
```

## Local dev story (P1-T1 scaffold target)

1. `docker compose up -d` — Postgres comes up.
2. `pnpm install` — deps installed.
3. `cp .env.example .env.local` — fill in dev secrets.
4. `pnpm drizzle-kit migrate` — schema applied.
5. `pnpm dev` — Next.js serves on `http://localhost:3000`.
6. `pnpm lint && pnpm typecheck && pnpm test && pnpm build` —
   all four exit 0.

## Free-tier ceilings to record at init

- Resend free tier: 100 emails/day, 3,000/month. Captured in
  `/ai/BUDGET.md` "Free-tier and tier choices".

## Production handoff (deferred to P3-T0)

This recipe pins the **local** Postgres container version. At
P3-T0 deploy planning, that engine major version gets mirrored
in a managed service ADR (RDS Postgres / Cloud SQL / Azure
Database for PostgreSQL — whichever cloud is chosen).

Auth.js sessions are stateless (JWT cookies); no session-store
migration needed at deploy. Email handoff to Resend works
identically locally and in production.

## When to pick this

- You want a single repo for your web UI + your own API logic.
- Server components / RSC / streaming matter.
- TypeScript everywhere is a feature, not a nuisance.

## When NOT to pick this

- You need a separate API to serve mobile + web + third-party
  clients. Pick the NestJS or FastAPI recipe for the API and
  Next.js *or* Astro for the web frontend.
- You want a no-DB marketing site. Pick the Astro Static recipe.
- You want zero JS runtime on the client (most pages). Pick
  Astro Static.
