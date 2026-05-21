# Recipe: FastAPI (Python)

Last Updated: 2026-05-21
Applies to: Server / cloud platform + Python language.

## What this template gives you

A modern Python HTTP API on FastAPI with async support, Pydantic
for schema validation, SQLAlchemy + Alembic for DB, JWT auth.
Suitable for REST APIs that need Python's data / ML ecosystem or
where the team is Python-fluent.

## Design philosophy

- **Async by default.** Endpoint handlers are `async def`. Sync
  is allowed where the dep doesn't support async, but explicitly.
- **Pydantic at trust boundaries.** Request bodies, query params,
  and response models are typed Pydantic models — automatic
  validation + OpenAPI schema generation.
- **SQLAlchemy owns the schema.** Alembic migrations live in
  `alembic/versions/`. Frontend projects don't apply migrations.
- **JWT auth at the edge.** PyJWT for tokens; `python-jose` is an
  acceptable alternative if you need additional algorithm support.
- **Dependency injection via FastAPI's `Depends`.** Database
  sessions, current user, settings — all injected, all easy to
  override in tests.

## Bundled stack (verified versions at init time)

| Component | Choice | Canonical source |
|-----------|--------|------------------|
| Framework | FastAPI `<X.Y.Z>` | https://pypi.org/project/fastapi/ |
| ASGI server | uvicorn `<X.Y.Z>` (with `[standard]` extras) | https://pypi.org/project/uvicorn/ |
| Language / runtime | Python `<X.Y>` | https://www.python.org/downloads/ |
| Package manager | Poetry `<X.Y.Z>` | https://pypi.org/project/poetry/ |
| ORM | SQLAlchemy `<X.Y.Z>` (2.x style) | https://pypi.org/project/SQLAlchemy/ |
| Migrations | Alembic `<X.Y.Z>` | https://pypi.org/project/alembic/ |
| DB driver | psycopg `<X.Y.Z>` (3.x) | https://pypi.org/project/psycopg/ |
| Database (local) | PostgreSQL `<X.Y>` (Docker image) | https://hub.docker.com/_/postgres |
| Schema validation | Pydantic `<X.Y.Z>` (bundled with FastAPI) | https://pypi.org/project/pydantic/ |
| Auth | PyJWT `<X.Y.Z>` | https://pypi.org/project/PyJWT/ |
| Password hashing | argon2-cffi `<X.Y.Z>` | https://pypi.org/project/argon2-cffi/ |
| Test runner | pytest `<X.Y.Z>` + httpx for client | https://pypi.org/project/pytest/ |
| Lint / format | ruff `<X.Y.Z>` (lint + format in one) | https://pypi.org/project/ruff/ |

Pin verified versions at init.

## Folder layout

```
projects/<name>/
├── src/
│   └── <app_name>/
│       ├── routers/        # endpoint modules
│       ├── models/         # SQLAlchemy ORM models
│       ├── schemas/        # Pydantic models
│       ├── services/       # business logic
│       ├── auth/           # JWT helpers
│       ├── db.py           # SQLAlchemy session factory
│       ├── settings.py     # Pydantic Settings
│       └── main.py         # FastAPI app instance
├── alembic/
│   ├── versions/
│   ├── env.py
│   └── alembic.ini
├── tests/
├── docker-compose.yml      # local Postgres
├── .env.example
├── pyproject.toml
├── poetry.lock
└── README.md
```

## Local dev story (P1-T1 scaffold target)

1. `docker compose up -d` — Postgres comes up.
2. `poetry install`
3. `cp .env.example .env` — fill in dev secrets.
4. `poetry run alembic upgrade head`
5. `poetry run uvicorn src.<app_name>.main:app --reload --port 8000`
   — serves on `http://localhost:8000`.
6. `poetry run ruff check && poetry run ruff format --check && poetry run pytest`
   — all green.
7. OpenAPI docs at `http://localhost:8000/docs` work.

## Free-tier ceilings to record at init

- None by default for this stack.

## Production handoff (deferred to P3-T0)

Local Postgres → managed Postgres at P3-T0. Local uvicorn dev
server → production ASGI deployment (uvicorn-gunicorn-fastapi
Docker image, or Cloud Run-style autoscaling). JWT signing key →
runtime secret store.

## When to pick this

- Your team is Python-first.
- You need Python's data / ML / scientific computing ecosystem in
  the same process.
- Async I/O + automatic OpenAPI docs are a feature.

## When NOT to pick this

- Your team is TypeScript-first → pick NestJS.
- You need a synchronous-only stack (sync-only ORM, sync clients)
  — FastAPI works but loses its async advantage; consider Flask
  + Pydantic instead (Custom recipe).
