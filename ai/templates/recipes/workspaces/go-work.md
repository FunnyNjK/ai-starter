# Workspace Recipe: Go Workspace (go.work)

Last Updated: 2026-05-22
Applies to: solutions with two or more Go modules under
`projects/` that benefit from coordinated local development —
typically when one project consumes a library or shared
internal package from another.

## When to wire this up

Add a `go.work` file at solution root when:

- Two or more Go projects need to **import each other** during
  local development without publishing intermediate versions.
- You're developing a library (`projects/lib/`) alongside a
  consumer (`projects/cli/` or `projects/api/`) and want
  changes to flow without `replace` directives in every
  consumer's `go.mod`.

Skip if all your Go projects are independent (no inter-project
imports) AND you'd rather operate on each module's `go.mod`
directly. `go.work` is a developer-convenience feature; it
doesn't ship with releases.

## Important: `go.work` is for development, NOT releases

`go.work` does NOT affect what gets published when you tag a
release. Each module is independently versioned and published
via git tags + the Go module proxy. When a consumer outside
your workspace `go get`s your module, they use the tagged
version (via proxy.golang.org), not the workspace.

For that reason: **commit `go.work`** for team-shared
development, but consumers outside the solution see only the
individual modules.

## What to create

At the **solution root**:

### `go.work`

Don't write this by hand. Use the Go CLI:

```bash
go work init
go work use ./projects/<project-1>
go work use ./projects/<project-2>
# ... etc per Go module
```

This creates:

```
go <X.Y>

use (
    ./projects/<project-1>
    ./projects/<project-2>
)
```

Whenever a new Go project is added: `go work use ./projects/<new>`.

### Optional: `go.work.sum`

Created automatically by `go work sync`. Commit it alongside
`go.work`. It locks transitive dep versions across the
workspace.

## Sharing code across projects

Once `go work` is configured, one Go project can import another
via its module path:

```go
import "github.com/<owner>/<repo>/projects/common"
```

Go resolves this through the workspace (no published version
needed during development). Outside the workspace (e.g., when a
CI run builds without `go.work`), Go falls back to the
published module via the proxy.

Tip: in CI, you may want `GOWORK=off` to verify each module
builds standalone (catches missing `require` directives that
`go.work` was silently papering over).

## Common pitfalls

- **`go.work` overrides `go.mod` `replace` directives.** If you
  had `replace` directives for local development before
  workspaces existed, prefer migrating to `go.work` — cleaner
  and per-developer.
- **`go install` and the workspace**: `go install
  ./projects/<cli>` uses the workspace's view; releases come
  from tags + the proxy.
- **`go.sum` lives per-module**, not workspace-wide. Each
  module's `go.sum` still tracks its own deps. `go work sync`
  reconciles them.
- **CI build matrix**: if you run per-module CI jobs (one per
  project), set `GOWORK=off` in each job so the build matches
  what external consumers see.

## What this DOESN'T solve

- Cross-language solutions: `go.work` only knows about Go.
- Coordinated releases: each Go module is independently
  versioned and tagged. If you want lockstep releases across
  multiple Go modules, that's release-tooling territory
  (goreleaser per module, or a wrapper script).

## When the kit suggests this

`ADD_PROJECT_PROMPT.md` will queue a Phase-1 task pointing at
this recipe when adding a second (or later) Go project that
has reason to import an existing Go project in the same
solution. If the two Go projects are independent (no
inter-imports), skip this and operate on each module
separately.
