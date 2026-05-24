# Recipe: Python Library (Poetry)

Last Updated: 2026-05-22
Applies to: Library / package platform + Python language.

## What this template gives you

A Python library packaged for distribution via PyPI using Poetry.
pytest for tests, ruff for lint+format, mypy for type checking,
publish via PyPI Trusted Publishers (OIDC; no long-lived tokens
in CI).

## Design philosophy

- **`src/<package>/` layout, not flat.** The `src/` layout makes
  `import <package>` fail if the package isn't installed,
  catching missing-install mistakes during testing.
- **Type hints throughout.** mypy in `--strict` mode. Users
  inherit the type info via PEP 561 (`py.typed` marker file).
- **Poetry for deps + publish.** `pyproject.toml` is the single
  source of truth; `poetry.lock` pins everything; `poetry
  publish` ships to PyPI.
- **PyPI Trusted Publishers for releases.** GitHub Actions
  authenticates to PyPI via OIDC — no API token stored in repo
  secrets.
- **Public API is `__init__.py` exports.** Anything not in
  `__init__.py` is private even if technically importable.
- **Zero runtime deps if possible.** Library deps become consumer
  deps; minimize the blast radius.

## Bundled stack (verified versions at init time)

| Component | Choice | Canonical source |
|-----------|--------|------------------|
| Language / runtime | Python `<X.Y>` (lowest supported = lowest LTS in scope) | https://www.python.org/downloads/ |
| Package manager | Poetry `<X.Y.Z>` | https://pypi.org/project/poetry/ |
| Test runner | pytest `<X.Y.Z>` | https://pypi.org/project/pytest/ |
| Type checker | mypy `<X.Y.Z>` | https://pypi.org/project/mypy/ |
| Lint / format | ruff `<X.Y.Z>` | https://pypi.org/project/ruff/ |
| Distribution | PyPI via Trusted Publishers (OIDC) | https://docs.pypi.org/trusted-publishers/ |
| Docs (optional) | Sphinx `<X.Y.Z>` OR mkdocs `<X.Y.Z>` | https://pypi.org/project/sphinx/ |

Pin verified versions at init.

## Folder layout

```
projects/<name>/
├── src/
│   └── <package_name>/
│       ├── __init__.py     # public API
│       ├── py.typed        # PEP 561 marker (empty file)
│       └── ...             # internal modules
├── tests/
│   ├── conftest.py
│   └── test_*.py
├── docs/                   # optional
├── pyproject.toml          # Poetry + tool config
├── poetry.lock
├── README.md
└── CHANGELOG.md
```

`pyproject.toml` essentials:

```toml
[tool.poetry]
name = "<package_name>"
version = "0.1.0"
packages = [{ include = "<package_name>", from = "src" }]

[tool.poetry.dependencies]
python = "^<X.Y>"
# library runtime deps go here — keep minimal

[tool.poetry.group.dev.dependencies]
pytest = "<X.Y.Z>"
mypy = "<X.Y.Z>"
ruff = "<X.Y.Z>"

[tool.mypy]
strict = true

[tool.ruff]
target-version = "py<XY>"
```

## Local dev story (P1-T1 scaffold target)

1. `poetry install`
2. `poetry run pytest`
3. `poetry run ruff check && poetry run ruff format --check`
4. `poetry run mypy src`
5. `poetry build` — produces `dist/<package>-*.whl` and
   `dist/<package>-*.tar.gz`.

No docker-compose. No DB. Library deps only.

## Free-tier ceilings to record at init

- PyPI: unlimited public packages. Private packages require a
  private index (private PyPI, GitHub Packages, etc.) —
  capture in BUDGET.md if needed.

## Production handoff (deferred to P3-T0)

For libraries, "production" = published to PyPI. P3-T0 records:

- PyPI Trusted Publisher setup (one-time PyPI-side config
  linking the GitHub repo + workflow + environment to PyPI).
- GitHub Actions release workflow: triggered on git tag push
  matching `v*`, runs tests + `poetry build` + `poetry publish`
  (via `pypa/gh-action-pypi-publish`).
- Versioning policy: semver. `version` in pyproject.toml is the
  source of truth; tag must match.
- Changelog policy: `CHANGELOG.md` updated per release; the
  release workflow extracts the relevant section as the GitHub
  Release body.

## When to pick this

- You're shipping reusable Python code for other developers to
  install via `pip install`.
- Type hints are a feature, not a chore.
- PyPI is the right distribution channel.

## When NOT to pick this

- You're shipping a CLI rather than a library — use the Python
  Typer recipe (which also publishes to PyPI but ships an entry
  point).
- You're internal-only — consider git-installable via
  `pip install git+...` and skip PyPI; document the deviation
  as an ADR.
