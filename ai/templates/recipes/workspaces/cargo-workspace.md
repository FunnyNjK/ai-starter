# Workspace Recipe: Cargo Workspace

Last Updated: 2026-05-22
Applies to: solutions with two or more Rust projects under
`projects/` that share a `target/` directory, deps, or
internal crates.

## When to wire this up

Add a Cargo workspace at solution root when ANY of the
following is true:

- Two or more Rust projects need to **share an internal crate**
  (e.g., a `common` crate consumed by `api` and `worker`).
- You want **one `cargo build`** / `cargo test` at solution
  root to build all crates.
- You want **shared `target/`** to avoid re-compiling deps per
  project (workspaces share `target/` by default — significant
  build-time win).

Skip only if you have a single Rust project AND don't anticipate
adding another. The cost of wiring up a workspace is trivial;
the benefit grows with each crate added.

(Note: this recipe ships even though Rust isn't in the v1.3.0
8-recipe set — it's included because multi-Rust solutions are
common in practice, and once a user picks "Custom" for a Rust
project, they'll need this.)

## What to create

At the **solution root**:

### `Cargo.toml`

```toml
[workspace]
resolver = "2"
members = [
    "projects/*",
]

# Optional: shared dependency versions
[workspace.dependencies]
serde = { version = "<X.Y.Z>", features = ["derive"] }
tokio = { version = "<X.Y.Z>", features = ["full"] }
anyhow = "<X.Y.Z>"
# add others as the solution grows

# Optional: shared lint config across all crates
[workspace.lints.rust]
unsafe_code = "forbid"

[workspace.lints.clippy]
all = "warn"
pedantic = "warn"
```

### Per-project `Cargo.toml`

Inside each project, the project's `Cargo.toml` references
workspace-level deps via `workspace = true`:

```toml
[package]
name = "<project-name>"
version = "0.1.0"
edition = "2021"

[dependencies]
serde.workspace = true
tokio.workspace = true
# project-specific deps go here without .workspace
clap = "<X.Y.Z>"

[lints]
workspace = true
```

## Sharing code across projects

Create an internal crate:

```bash
cargo new --lib projects/common
```

In another project's `Cargo.toml`:

```toml
[dependencies]
common = { path = "../common" }
```

The path is relative to the consuming project's `Cargo.toml`,
not the workspace root. Workspaces ensure both projects build
with the same versions of shared deps.

## Common pitfalls

- **`resolver = "2"`**: workspaces created on Rust 2021+ should
  use the v2 dependency resolver. The default in workspace
  inheritance is still v1 — set it explicitly.
- **`Cargo.lock` lives at workspace root**, not per-crate. Don't
  commit per-crate `Cargo.lock` files for library crates;
  binary crates DO commit one (at workspace root).
- **Shared `target/` can grow large** — gitignored by default,
  but watch disk space during heavy refactors.
- **`cargo workspaces` (the tool)** is separate from Cargo's
  built-in workspace support. The built-in is enough for most
  cases; the external tool adds release automation (similar to
  changesets for JS).

## What this DOESN'T solve

- Cross-language solutions: Cargo workspaces only know about
  Rust crates. TS / Python / Go projects need their own
  workspace setup.
- Cross-architecture builds: cargo workspace + `cross` works,
  but `cross` config is per-binary-crate, not workspace-wide.

## When the kit suggests this

`ADD_PROJECT_PROMPT.md` will queue a Phase-1 task pointing at
this recipe when adding a second (or later) Rust project (any
project with a `Cargo.toml`) to a solution that doesn't already
have a workspace `Cargo.toml` at root.
