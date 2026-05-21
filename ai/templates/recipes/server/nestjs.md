# Recipe: NestJS API (TypeScript)

Last Updated: 2026-05-21
Applies to: Server / cloud platform + TypeScript language.

## What this template gives you

A modular HTTP API on NestJS with TypeScript decorators, dependency
injection, and built-in module structure. Postgres via Drizzle,
Zod for schema validation, JWT auth. Suitable for REST or GraphQL
APIs serving web + mobile clients.

## Design philosophy

- **One API, many clients.** This API is the source of truth for
  business logic. Web / mobile / CLI clients call it over HTTP.
- **Modules organize the code.** Each domain concept (users,
  projects, billing, etc.) lives in its own NestJS module with
  controller + service + repository.
- **API owns the schema.** Drizzle migrations live HERE.
  Frontend projects in the same solution NEVER apply migrations
  — they only call the API.
- **JWT auth at the edge, HMAC inter-layer auth if paired with a
  Next.js web frontend in the same solution.** The web layer
  signs server-to-server requests with an HMAC secret that lives
  in env vars only; never reaches the browser.
- **Schema validation at trust boundaries.** Every incoming
  request body / query / params validated with Zod before
  reaching the service layer.

## Bundled stack (verified versions at init time)

| Component | Choice | Canonical source |
|-----------|--------|------------------|
| Framework | NestJS `<X.Y.Z>` | https://www.npmjs.com/package/@nestjs/core |
| Language | TypeScript `<X.Y.Z>` | https://www.npmjs.com/package/typescript |
| Runtime | Node.js `<X.Y.Z>` LTS | https://nodejs.org/en/about/previous-releases |
| Package manager | pnpm `<X.Y.Z>` | https://www.npmjs.com/package/pnpm |
| ORM | Drizzle ORM `<X.Y.Z>` + drizzle-kit | https://www.npmjs.com/package/drizzle-orm |
| Database (local) | PostgreSQL `<X.Y>` (Docker image) | https://hub.docker.com/_/postgres |
| Schema validation | Zod `<X.Y.Z>` (via nestjs-zod) | https://www.npmjs.com/package/zod |
| Auth | @nestjs/jwt `<X.Y.Z>` + @nestjs/passport | https://www.npmjs.com/package/@nestjs/jwt |
| Password hashing | argon2 `<X.Y.Z>` | https://www.npmjs.com/package/argon2 |
| Test runner | Vitest `<X.Y.Z>` (via @nestjs/testing) | https://www.npmjs.com/package/vitest |
| Lint | ESLint `<X.Y.Z>` | https://www.npmjs.com/package/eslint |
| Format | Prettier `<X.Y.Z>` | https://www.npmjs.com/package/prettier |

Pin verified versions at init.

## Folder layout

```
projects/<name>/
├── src/
│   ├── modules/
│   │   ├── users/
│   │   │   ├── users.controller.ts
│   │   │   ├── users.service.ts
│   │   │   ├── users.module.ts
│   │   │   └── dto/        # Zod schemas
│   │   └── auth/
│   ├── db/
│   │   ├── schema.ts
│   │   ├── migrations/
│   │   └── client.ts
│   ├── common/             # guards, interceptors, filters
│   ├── app.module.ts
│   └── main.ts
├── tests/
│   ├── unit/
│   └── e2e/
├── docker-compose.yml      # local Postgres
├── .env.example
├── package.json
├── pnpm-lock.yaml
├── nest-cli.json
└── README.md
```

## Local dev story (P1-T1 scaffold target)

1. `docker compose up -d` — Postgres comes up.
2. `pnpm install`
3. `cp .env.example .env` — fill in dev secrets including
   `JWT_SECRET`, `DB_URL`, and (if paired with a web project)
   `HMAC_SECRET`.
4. `pnpm drizzle-kit migrate`
5. `pnpm start:dev` — Nest watches and reloads on
   `http://localhost:3001`.
6. `pnpm lint && pnpm typecheck && pnpm test && pnpm test:e2e &&
   pnpm build` — all exit 0.

## Free-tier ceilings to record at init

- None by default. If you add an email provider, OAuth provider,
  or AI inference later, capture those.

## Production handoff (deferred to P3-T0)

Local Postgres → managed Postgres at P3-T0 (RDS / Cloud SQL /
Azure Database for PostgreSQL). The JWT signing key currently in
local env var → runtime secret store at deploy (Secrets Manager /
Key Vault / Secret Manager).

If paired with a Next.js Web App in the same solution, the
HMAC inter-layer secret is rotated per the runtime secret store's
rotation policy. Document the rotation cadence in
`/ai/DEPLOYMENT.md` "Required Environment Variables".

## When to pick this

- You need an API that serves multiple clients (web + mobile +
  partners).
- TypeScript on the server is a feature.
- Modular structure (controllers / services / DTOs) fits the
  team's pattern.

## When NOT to pick this

- You only need API logic for one web frontend → embed the API
  in Next.js Route Handlers instead (Next.js Web App recipe).
- Your team is Python-first → pick FastAPI.
- You need GraphQL specifically — NestJS supports it but the
  default recipe is REST. Pick Custom and add `@nestjs/graphql`.
