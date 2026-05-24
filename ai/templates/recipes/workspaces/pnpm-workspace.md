# Workspace Recipe: pnpm

Last Updated: 2026-05-22
Applies to: solutions with two or more TypeScript / JavaScript
projects under `projects/` that benefit from sharing code,
sharing dev deps, or coordinated builds.

## When to wire this up

Add a pnpm workspace at solution root when ANY of the following
is true:

- Two or more TS/JS projects need to **share types or runtime
  code** (e.g., a shared `packages/types/` consumed by web +
  api).
- You want **one `pnpm install`** at solution root to install
  deps for all projects.
- You want **coordinated builds** via Turborepo / Nx / pnpm's
  built-in topology (`pnpm -r run build`).

Skip if all your TS/JS projects are independent (no code
sharing) AND you're fine running `pnpm install` separately in
each. The workspace machinery isn't free — it adds one layer of
configuration to debug when things go wrong.

## What to create

At the **solution root** (not inside any single project):

### `pnpm-workspace.yaml`

```yaml
packages:
  - "projects/*"
  - "packages/*"      # for shared internal libs (optional)
```

### Root `package.json`

```json
{
  "name": "<solution-name>",
  "private": true,
  "scripts": {
    "build": "pnpm -r run build",
    "lint": "pnpm -r run lint",
    "typecheck": "pnpm -r run typecheck",
    "test": "pnpm -r run test"
  },
  "devDependencies": {
    "typescript": "<X.Y.Z>"
  },
  "packageManager": "pnpm@<X.Y.Z>"
}
```

The root is `private: true` — never published. Per-project
`package.json` files declare each project's own deps + scripts.

### `.npmrc` at solution root (optional)

```
# Strict peer-dep resolution catches version mismatches early.
strict-peer-dependencies=true
# Auto-install peer deps when adding a package.
auto-install-peers=true
```

## Sharing code across projects

If two projects need to share types (very common for web + api):

1. Create `packages/types/` (or whatever name fits).
2. In `packages/types/package.json`:
   ```json
   {
     "name": "@<solution>/types",
     "version": "0.0.0",
     "private": true,
     "main": "./src/index.ts",
     "types": "./src/index.ts"
   }
   ```
3. In each consuming project's `package.json`:
   ```json
   {
     "dependencies": {
       "@<solution>/types": "workspace:*"
     }
   }
   ```
4. Run `pnpm install` at solution root to wire up the symlink.

## Common pitfalls

- **TypeScript `paths` vs workspace deps**: prefer workspace
  deps over `tsconfig.json` `paths`. Workspace deps are
  understood by the bundler, the type checker, AND the editor;
  `paths` only works for the type checker. Mixing them produces
  hard-to-debug "works in editor, breaks at build" issues.
- **Lockfile lives at root only**: `pnpm-lock.yaml` is generated
  at solution root and tracks every project's deps. Per-project
  `pnpm-lock.yaml` files should NOT exist; if you have one,
  delete it before wiring up the workspace.
- **Single TypeScript version**: pin TypeScript at solution
  root (as a devDependency) and reference it from each project
  via `workspace:*` or by NOT redeclaring it per-project. Two
  TypeScript versions across the workspace causes silent type
  drift.
- **CI: run `pnpm install --frozen-lockfile` at solution root**,
  not in each project subdirectory.

## What this DOESN'T solve

- Different package managers across projects (e.g., one project
  using yarn, another pnpm): you have to pick one.
- Mixed-language solutions (TS + Python + Go): each ecosystem
  needs its own workspace setup. Run separate workspace
  recipes per language; the solution root holds multiple
  workspace config files side by side.

## When the kit suggests this

`ADD_PROJECT_PROMPT.md` will queue a Phase-1 task pointing at
this recipe when adding a second (or later) TS/JS project to a
solution that doesn't already have a pnpm workspace configured.
Solo prototypes can defer; small-team and production tiers
should wire it before the second project's Phase-2 work.
