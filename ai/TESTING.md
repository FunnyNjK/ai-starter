# Testing Strategy

Last Updated: 2026-05-02

## Testing Status
Default pattern documented.

---

## Required Test Types

### Unit tests (required)
- All `src/lib/` utilities (validation, formatting, types).
- All `api/contact/lib/` business logic (Turnstile verify, Postmark send,
  rate limiting, IP extraction).

### Component tests (required for interactive components)
- Contact form component: validation, submit success path, submit error
  path, Turnstile token handling.
- Other React island components when they have meaningful behavior.

### Integration tests (recommended)
- The contact endpoint as an HTTP integration test, with Postmark and
  Turnstile mocked at the network boundary.

### End-to-end (optional)
- Skipped by default for marketing sites unless project requires it.
- If added, use Playwright; place specs in `tests/e2e/`.

### CI checks (required)
- lint
- typecheck
- test (Vitest --run)
- build

---

## Testing Rules

- Every implementation task must include test expectations.
- Bug fixes should include regression tests.
- Refactors must preserve behavior unless explicitly approved.
- Do not delete or weaken tests just to make a build pass.
- Tests run as native Node processes in WSL — no Docker, no test runners
  in containers.

---

## Test Commands (default `package.json` scripts)

```bash
pnpm test                  # vitest --run
pnpm test:watch            # vitest
pnpm lint                  # eslint .
pnpm typecheck             # tsc -b --noEmit
pnpm build                 # astro build
```

API workspace (when contact endpoint exists):

```bash
pnpm --filter api test
pnpm --filter api typecheck
```

---

## Mock Strategy

- **Postmark:** mock the `postmark` client at module boundary (Vitest
  `vi.mock`). Don't hit the real Postmark API in tests.
- **Turnstile:** mock `fetch` calls to `https://challenges.cloudflare.com/turnstile/v0/siteverify`.
- **Rate limiter:** use an in-memory store with deterministic time control
  via `vi.useFakeTimers()`.

---

## Coverage Expectations

- `src/lib/` and `api/contact/lib/`: target ≥ 80% line coverage.
- Components: behavior coverage > line coverage. One test per meaningful
  user flow, not one test per component file.

---

## Known Testing Gaps
- TBD per-project (fill in during initialization)
