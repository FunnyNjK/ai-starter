# Recipe: Python CLI (Typer)

Last Updated: 2026-05-21
Applies to: CLI / terminal platform + Python language.

## What this template gives you

A Python command-line tool built with Typer (a Click wrapper that
uses type hints for argument parsing). Pydantic for config, pytest
for testing, Poetry for packaging, ruff for lint/format.
Distributed via PyPI.

## Design philosophy

- **Type hints define the CLI.** Function signatures with
  annotations become CLI commands and options.
- **Subcommands compose.** `mytool foo bar` and `mytool baz qux`
  live in separate Typer apps that register into a root app.
- **Pydantic settings for config.** A `~/.config/<name>/config.toml`
  file holds non-secret config; secrets come from env vars.
- **Stdout is data, stderr is logs.** CLI output that another tool
  might pipe goes to stdout; status messages go to stderr.
  Always.
- **Exit codes matter.** 0 = success, non-zero = failure. Document
  the contract in README.

## Bundled stack (verified versions at init time)

| Component | Choice | Canonical source |
|-----------|--------|------------------|
| CLI framework | Typer `<X.Y.Z>` | https://pypi.org/project/typer/ |
| Language / runtime | Python `<X.Y>` | https://www.python.org/downloads/ |
| Package manager | Poetry `<X.Y.Z>` | https://pypi.org/project/poetry/ |
| Config validation | Pydantic `<X.Y.Z>` + pydantic-settings | https://pypi.org/project/pydantic-settings/ |
| TOML parser | tomli (stdlib in Python 3.11+) | https://docs.python.org/3/library/tomllib.html |
| Rich output | Rich `<X.Y.Z>` (bundled with Typer) | https://pypi.org/project/rich/ |
| Test runner | pytest `<X.Y.Z>` | https://pypi.org/project/pytest/ |
| Lint / format | ruff `<X.Y.Z>` | https://pypi.org/project/ruff/ |
| Distribution | PyPI (via Poetry's `poetry publish`) | https://pypi.org/ |

Pin verified versions at init.

## Folder layout

```
projects/<name>/
├── src/
│   └── <cli_name>/
│       ├── commands/       # one file per top-level subcommand
│       ├── config.py       # Pydantic Settings
│       ├── main.py         # root Typer app, entry point
│       └── __init__.py
├── tests/
├── pyproject.toml          # entry point declared here
├── poetry.lock
├── README.md
└── CHANGELOG.md
```

`pyproject.toml` declares the CLI entry point:

```toml
[tool.poetry.scripts]
<cli_name> = "<cli_name>.main:app"
```

So `pip install <cli_name>` makes `<cli_name>` available on PATH.

## Local dev story (P1-T1 scaffold target)

1. `poetry install`
2. `poetry run <cli_name> --help` — Typer renders the help.
3. `poetry run ruff check && poetry run ruff format --check && poetry run pytest`
   — all green.
4. `poetry build` — produces `dist/<cli_name>-*.whl` and
   `dist/<cli_name>-*.tar.gz`.

No docker-compose. No DB by default. If the CLI needs to talk to
an API in the same solution, add an HTTP client (httpx) to deps.

## Free-tier ceilings to record at init

- None by default.

## Production handoff (deferred to P3-T0)

Distribution: PyPI is the canonical channel. P3-T0 (or earlier
for libraries that ship before deploy) records the PyPI publish
process — `poetry publish` with API token in CI, signed releases,
GitHub Actions OIDC trust to PyPI (`pypa/gh-action-pypi-publish`).

If the CLI calls a hosted API in the same solution, the API's URL
becomes config (env var or `--api-url` flag).

## When to pick this

- Your tool runs in a terminal.
- Python ecosystem (requests, pandas, anything-PyPI) is a feature.
- Users install via `pip install` or `pipx install`.

## When NOT to pick this

- You need a self-contained binary that doesn't require Python
  installed → use Go (cobra) or Rust (clap). Not in v1.2.0 — pick
  Custom.
- You need GUI elements → this is a CLI, not a TUI. If you want
  a TUI, add Textual to deps (Rich's TUI cousin) — note it as a
  deviation.
