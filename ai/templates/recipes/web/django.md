# Recipe: Django (Python)

Last Updated: 2026-05-22
Applies to: Web platform + Python language.

## What this template gives you

A batteries-included Python web app on Django with PostgreSQL,
Django's built-in auth (extended with django-allauth for social
logins), Django templates (server-rendered, can layer HTMX or
Alpine.js for interactivity), pytest-django for testing.

## Design philosophy

- **Single deployable, server-rendered.** Django templates render
  HTML on the server. Add HTMX (via `django-htmx`) for sprinkles
  of interactivity without committing to a SPA frontend.
- **Django ORM owns the schema.** Models in each app's `models.py`;
  migrations auto-generated via `makemigrations`. Frontend / API
  projects in the same solution don't apply migrations.
- **Built-in auth + django-allauth for OAuth.** Django ships
  with a solid auth backend. `django-allauth` adds social logins
  (Google, GitHub, etc.) without reinventing OAuth flows.
- **App-per-domain.** Inside the Django project, split features
  into Django "apps" (`apps/users/`, `apps/projects/`, ...).
  Avoids the monolithic `myapp/views.py` anti-pattern.
- **Settings split.** `config/settings/base.py`,
  `config/settings/development.py`, `config/settings/production.py`.
  Secrets via env vars only; never in committed files.

## Bundled stack (verified versions at init time)

| Component | Choice | Canonical source |
|-----------|--------|------------------|
| Framework | Django `<X.Y.Z>` LTS | https://pypi.org/project/Django/ |
| Language / runtime | Python `<X.Y>` | https://www.python.org/downloads/ |
| Package manager | Poetry `<X.Y.Z>` | https://pypi.org/project/poetry/ |
| DB driver | psycopg `<X.Y.Z>` (3.x) | https://pypi.org/project/psycopg/ |
| Database (local) | PostgreSQL `<X.Y>` (Docker image) | https://hub.docker.com/_/postgres |
| Auth (social) | django-allauth `<X.Y.Z>` | https://pypi.org/project/django-allauth/ |
| Interactivity | django-htmx `<X.Y.Z>` (optional) | https://pypi.org/project/django-htmx/ |
| Forms | django-crispy-forms `<X.Y.Z>` | https://pypi.org/project/django-crispy-forms/ |
| Static assets | django + whitenoise `<X.Y.Z>` (no separate CDN needed for small sites) | https://pypi.org/project/whitenoise/ |
| Email | django.core.mail + smtp backend (or anymail for transactional providers) | https://pypi.org/project/django-anymail/ |
| Test runner | pytest `<X.Y.Z>` + pytest-django `<X.Y.Z>` | https://pypi.org/project/pytest-django/ |
| Lint / format | ruff `<X.Y.Z>` | https://pypi.org/project/ruff/ |
| Production server | gunicorn `<X.Y.Z>` | https://pypi.org/project/gunicorn/ |

Pin verified versions at init.

## Folder layout

```
projects/<name>/
├── config/
│   ├── settings/
│   │   ├── base.py
│   │   ├── development.py
│   │   └── production.py
│   ├── urls.py
│   └── wsgi.py
├── apps/
│   ├── users/
│   │   ├── models.py
│   │   ├── views.py
│   │   ├── urls.py
│   │   └── tests/
│   └── <other_app>/
├── templates/
│   ├── base.html
│   └── <per-app>/
├── static/                 # CSS, JS, images (committed source)
├── staticfiles/            # collected for prod (gitignored)
├── tests/                  # cross-app integration tests
├── docker-compose.yml      # local Postgres
├── .env.example
├── manage.py
├── pyproject.toml
├── poetry.lock
└── README.md
```

## Local dev story (P1-T1 scaffold target)

1. `docker compose up -d` — Postgres comes up.
2. `poetry install`
3. `cp .env.example .env` — fill in `DATABASE_URL`, `SECRET_KEY`
   (`python -c 'from django.core.management.utils import get_random_secret_key; print(get_random_secret_key())'`).
4. `poetry run python manage.py migrate`
5. `poetry run python manage.py createsuperuser` (optional, for
   admin access).
6. `poetry run python manage.py runserver` — serves on
   `http://localhost:8000`; admin at `/admin/`.
7. `poetry run ruff check && poetry run ruff format --check && poetry run pytest`
   — all exit 0.

## Free-tier ceilings to record at init

- django-allauth itself is free. The OAuth providers it integrates
  with may have free-tier limits (GitHub apps unlimited;
  Google OAuth has per-project quotas). Document any used.
- Email: if using a transactional provider (Postmark, SendGrid,
  Mailgun, Resend) via django-anymail, capture the free tier
  in BUDGET.md.

## Production handoff (deferred to P3-T0)

Local Postgres → managed Postgres at P3-T0. `SECRET_KEY` →
runtime secret store. `DEBUG=False` in production settings.
`ALLOWED_HOSTS` configured per environment.

Static files: `collectstatic` runs at build time; whitenoise
serves them from gunicorn in production (no separate CDN needed
for small/medium sites). For high-traffic sites, P3-T0 may decide
to add CloudFront / Cloud CDN / etc. as an ADR.

## When to pick this

- Team is Python-first.
- You want batteries-included (auth, admin, ORM, forms) without
  picking each library separately.
- Server-rendered with optional interactivity fits the app's
  interaction style.

## When NOT to pick this

- You want a rich SPA frontend → pick a TS Web recipe (Next.js).
  Django CAN serve a SPA via DRF + an SPA project in the same
  solution, but at that point the SPA is its own project.
- You want async-first → Django has async views but the ORM is
  still sync-leaning. Consider FastAPI for an async API.
- The app is just an API serving non-browser clients → pick
  FastAPI; Django's surface area is overkill for that case.
