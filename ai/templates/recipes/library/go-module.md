# Recipe: Go Module (Library)

Last Updated: 2026-05-22
Applies to: Library / package platform + Go language.

## What this template gives you

A Go module ready for consumption via `go get`. No build step or
bundler — Go modules ship source; consumers compile against it.
Versioned via git tags (semver); discoverable via pkg.go.dev.

## Design philosophy

- **Module path matches the repo URL.** `module
  github.com/<owner>/<repo>` so `go get` works without
  configuration. If the library lives under `projects/<name>/`
  in a multi-project solution, the module path is
  `github.com/<owner>/<repo>/projects/<name>`.
- **Idiomatic Go layout.** Public API at the top level; internal
  helpers under `internal/`. Avoid `pkg/` unless you're
  intentionally organizing multiple unrelated public packages.
- **No semver-major in import path until v2.** Versions 0.x and
  1.x use the unadorned import path. v2+ adds `/v2` to the
  module path per Go's semver-major-in-path convention.
- **Examples as runnable tests.** Use `func Example*` test
  functions; pkg.go.dev renders them as Examples in the docs.
- **Zero or near-zero deps.** Consumers inherit your deps;
  minimize the surface.

## Bundled stack (verified versions at init time)

| Component | Choice | Canonical source |
|-----------|--------|------------------|
| Language / runtime | Go `<X.Y>` (lowest supported) | https://go.dev/dl/ |
| Test | stdlib `testing` (no extra framework needed) | https://pkg.go.dev/testing |
| Lint | staticcheck `<X.Y.Z>` + go vet | https://staticcheck.io/ |
| Docs | pkg.go.dev (auto-generated from godoc comments) | https://pkg.go.dev/about |
| Distribution | git tags + Go module proxy (proxy.golang.org) | https://proxy.golang.org/ |

Pin verified versions at init.

## Folder layout

```
projects/<name>/
├── <package>.go            # public API
├── <package>_test.go       # tests
├── doc.go                  # package-level godoc
├── example_test.go         # runnable examples (pkg.go.dev renders)
├── internal/               # private packages (not importable externally)
│   └── ...
├── go.mod
├── go.sum
├── README.md
└── CHANGELOG.md
```

`go.mod` essentials:

```
module github.com/<owner>/<repo>

go <X.Y>

// require lines added as deps grow — keep minimal
```

## Local dev story (P1-T1 scaffold target)

1. `go mod tidy`
2. `go vet ./... && staticcheck ./... && go test ./...` —
   all exit 0.
3. `go doc <package>` — godoc renders the public API.

No docker-compose. No DB. No bundler. Pure Go source.

## Free-tier ceilings to record at init

- pkg.go.dev hosting: free, no quotas.
- Go module proxy (proxy.golang.org): free, no quotas.
- GitHub Releases (if used for non-source release notes): free,
  unlimited.

## Production handoff (deferred to P3-T0)

For Go libraries, "production" = git tags pushed. No build step;
no PyPI / npm equivalent. P3-T0 records:

- Versioning policy: semver. `git tag v0.1.0` then `git push
  origin v0.1.0` is the release.
- For v2+: rename the module path to add `/v2`; document the
  major-version upgrade path in CHANGELOG.
- pkg.go.dev indexing: happens automatically when proxy.golang.org
  sees the new tag. No action needed.
- Optional GitHub Release: extract CHANGELOG section as the
  release body for human-readable release notes.

## When to pick this

- You're shipping reusable Go code for `go get` consumption.
- Static-typed, compiled, zero-runtime-dep distribution is a
  feature.
- pkg.go.dev's auto-generated docs are sufficient (no separate
  docs site needed).

## When NOT to pick this

- You're shipping a CLI rather than a library — pick the Go
  Cobra recipe (which produces binaries via goreleaser).
- You need TypeScript / JS interop — Go libraries don't
  trivially compile to WASM-friendly forms; pick a TS library
  recipe instead.
- You need C-compatible ABI for non-Go consumers — Go's `cgo`
  is its own world; this recipe doesn't cover it. Pick Custom.
