# Recipe: Go CLI (Cobra)

Last Updated: 2026-05-22
Applies to: CLI / terminal platform + Go language.

## What this template gives you

A self-contained, statically-linked Go CLI built on Cobra
(subcommands, flag parsing) with Viper for config, distributed
as platform-specific binaries via goreleaser + GitHub Releases.
No runtime dependency on Go being installed on the user's
machine.

## Design philosophy

- **Subcommands compose.** `mytool foo bar` and `mytool baz qux`
  are separate Cobra commands wired into a root.
- **Viper for config + env vars.** Config file at
  `~/.config/<name>/config.yaml`; env vars override; flags
  override env vars. Standard precedence.
- **Stdout is data, stderr is logs.** Pipeable output goes to
  stdout; status / progress / errors go to stderr.
- **Exit codes documented.** 0 = success; 1 = generic failure;
  2 = usage error; 3+ = domain-specific (documented in README).
- **goreleaser for distribution.** Tag a release → goreleaser
  builds binaries for darwin/amd64, darwin/arm64, linux/amd64,
  linux/arm64, windows/amd64 + sha256sums + Homebrew tap
  formula + GitHub Release.

## Bundled stack (verified versions at init time)

| Component | Choice | Canonical source |
|-----------|--------|------------------|
| CLI framework | spf13/cobra `<X.Y.Z>` | https://pkg.go.dev/github.com/spf13/cobra |
| Config | spf13/viper `<X.Y.Z>` | https://pkg.go.dev/github.com/spf13/viper |
| Language / runtime | Go `<X.Y>` | https://go.dev/dl/ |
| Logging | log/slog (stdlib in Go 1.21+) | https://pkg.go.dev/log/slog |
| Test | stdlib `testing` + testify `<X.Y.Z>` | https://pkg.go.dev/github.com/stretchr/testify |
| Lint | staticcheck `<X.Y.Z>` + go vet | https://staticcheck.io/ |
| Release | goreleaser `<X.Y.Z>` | https://github.com/goreleaser/goreleaser/releases |
| Distribution | GitHub Releases + optional Homebrew tap | https://docs.github.com/en/repositories/releasing-projects-on-github |

Pin verified versions at init.

## Folder layout

```
projects/<name>/
├── cmd/
│   └── <cli_name>/
│       └── main.go         # thin entry: calls cmd.Execute()
├── internal/
│   ├── cmd/                # Cobra commands
│   │   ├── root.go
│   │   ├── foo.go
│   │   └── ...
│   ├── config/             # Viper setup
│   └── version/            # ldflags-injected version string
├── .goreleaser.yaml
├── .github/
│   └── workflows/
│       └── release.yml     # triggers goreleaser on tag push
├── go.mod
├── go.sum
├── README.md
└── CHANGELOG.md
```

## Local dev story (P1-T1 scaffold target)

1. `go mod download`
2. `go build -o ./bin/<cli_name> ./cmd/<cli_name>`
3. `./bin/<cli_name> --help` — Cobra renders help.
4. `go vet ./... && staticcheck ./... && go test ./...` —
   all exit 0.

No docker-compose; no DB. If the CLI calls a hosted API in the
same solution, the API URL is config (Viper key or `--api-url`
flag).

## Free-tier ceilings to record at init

- GitHub Releases: unlimited public releases. Captured for
  reference; not a blocker.
- Homebrew tap: if you publish to homebrew-core directly (not
  your own tap), there's a review process; tap-only is unlimited.

## Production handoff (deferred to P3-T0)

For CLIs, "production" = published releases. P3-T0 records:

- goreleaser config + GitHub Actions release workflow.
- Code signing: macOS notarization (Apple Developer Program
  cert) and Windows Authenticode (cert from a CA). Optional but
  reduces user friction. Document as ADR if pursued.
- Distribution channels: GitHub Releases (always), Homebrew tap
  (most common for dev tools), scoop / chocolatey (Windows),
  apt / dnf repos (advanced).

If the CLI calls a hosted API in the solution, that API's
deploy planning at P3-T0 also covers the CLI's `--api-url`
default.

## When to pick this

- You want a single binary users can download and run without
  installing Go.
- Cobra's subcommand model fits the tool's command structure.
- Cross-platform distribution (mac / Linux / Windows) matters.

## When NOT to pick this

- Users will all have Python and you'd rather ship via PyPI →
  pick the Python Typer recipe.
- You want a simpler one-command CLI without subcommands —
  Cobra is overkill; a few `flag.String()` calls in plain Go
  would suffice. Pick Custom for minimal Go CLI.
- You need TUI elements (forms, layouts) — add Bubble Tea to
  the dep list as a deviation.
