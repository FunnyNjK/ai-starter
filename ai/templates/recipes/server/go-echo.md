# Recipe: Go API (Echo)

Last Updated: 2026-05-22
Applies to: Server / cloud platform + Go language.

## What this template gives you

A small, idiomatic Go HTTP API on Echo with PostgreSQL via sqlc
(type-safe, generated query code — no runtime ORM), JWT auth, and
structured logging via `log/slog`. Compiled binary; fast startup;
no garbage-collected ORM in the hot path.

## Design philosophy

- **Standard Go layout.** `cmd/<app>/main.go` for the entry point,
  `internal/` for non-exportable packages. No `pkg/` unless the
  project genuinely publishes a library alongside the API.
- **sqlc, not an ORM.** Write `.sql` files for queries and schema;
  sqlc generates type-safe Go bindings. Easier to reason about
  than an ORM and the generated code is plain `database/sql`.
- **Migrations via `migrate/v4` or `goose`.** Migration files live
  in `db/migrations/`; the API owns the schema. Run migrations as
  a separate binary or a one-shot init container — NOT on startup.
- **JWT at the edge, secret via env.** Echo's `echojwt` middleware
  validates Bearer tokens. The signing key comes from
  `JWT_SECRET`; never compiled in.
- **slog for logs.** Structured logging via the stdlib
  `log/slog`. JSON output in production, text in local dev.
- **`Air` for dev hot reload.** Production binary is plain
  `go build`; no runtime tool needed.

## Bundled stack (verified versions at init time)

| Component | Choice | Canonical source |
|-----------|--------|------------------|
| Language / runtime | Go `<X.Y>` | https://go.dev/dl/ |
| HTTP framework | Echo `<X.Y.Z>` | https://pkg.go.dev/github.com/labstack/echo/v4 |
| JWT middleware | echojwt `<X.Y.Z>` | https://pkg.go.dev/github.com/labstack/echo-jwt/v4 |
| DB driver | pgx `<X.Y.Z>` (via stdlib `database/sql`) | https://pkg.go.dev/github.com/jackc/pgx/v5 |
| Query gen | sqlc `<X.Y.Z>` | https://github.com/sqlc-dev/sqlc/releases |
| Migrations | golang-migrate `<X.Y.Z>` | https://github.com/golang-migrate/migrate/releases |
| Database (local) | PostgreSQL `<X.Y>` (Docker image) | https://hub.docker.com/_/postgres |
| Logging | log/slog (stdlib in Go 1.21+) | https://pkg.go.dev/log/slog |
| Password hashing | golang.org/x/crypto/argon2 | https://pkg.go.dev/golang.org/x/crypto/argon2 |
| Schema validation | go-playground/validator `<X.Y.Z>` | https://pkg.go.dev/github.com/go-playground/validator/v10 |
| Test | stdlib `testing` + testify `<X.Y.Z>` | https://pkg.go.dev/github.com/stretchr/testify |
| Lint | staticcheck `<X.Y.Z>` + go vet | https://staticcheck.io/ |
| Hot reload (dev) | Air `<X.Y.Z>` | https://github.com/cosmtrek/air |

Pin verified versions at init per the Versioning Rules.

## Folder layout

```
projects/<name>/
├── cmd/
│   └── <app>/
│       └── main.go         # entry point
├── internal/
│   ├── api/                # Echo handlers
│   ├── auth/               # JWT helpers, password hashing
│   ├── db/                 # sqlc-generated code (read-only)
│   │   ├── querier.go
│   │   └── ...
│   └── config/             # env-var loading
├── db/
│   ├── migrations/         # .sql migrations (golang-migrate format)
│   └── queries/            # .sql files (sqlc input)
├── sqlc.yaml               # sqlc config
├── .air.toml               # Air hot-reload config (dev)
├── docker-compose.yml      # local Postgres
├── .env.example
├── go.mod
├── go.sum
└── README.md
```

## Local dev story (P1-T1 scaffold target)

1. `docker compose up -d` — Postgres comes up.
2. `cp .env.example .env` — fill in `DATABASE_URL`, `JWT_SECRET`.
3. `migrate -path db/migrations -database "$DATABASE_URL" up`
4. `sqlc generate` — regenerates `internal/db/`.
5. `go run ./cmd/<app>` (or `air` for hot reload) — serves on
   `http://localhost:8080`.
6. `go vet ./... && staticcheck ./... && go test ./...` — all
   exit 0.

## Free-tier ceilings to record at init

- None by default for this stack.

## Production handoff (deferred to P3-T0)

Local Postgres → managed Postgres at P3-T0 (RDS / Cloud SQL /
Azure Database for PostgreSQL). Versions of pgx + migrate stay
the same; only the connection string changes.

`JWT_SECRET` → runtime secret store at deploy. Container image:
multi-stage build (alpine or distroless final stage) for small
production images.

## When to pick this

- You want a compiled, fast-starting backend without a JVM-style
  runtime.
- sqlc's "SQL is the source of truth, not an ORM" model fits how
  the team thinks.
- Static binaries + small Docker images are a feature.

## When NOT to pick this

- Team is TypeScript-first → pick NestJS.
- Team is Python-first → pick FastAPI.
- You want a heavyweight ORM (GORM) instead of sqlc — fine to
  swap; document the override as an ADR. The recipe assumes sqlc.
