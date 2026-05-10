# Specification

Last Updated: 2026-05-10

## Status
TBD until the project is initialized.

This file captures **concrete behavior** the project must deliver — the
"what does it do, and how do we know" layer that sits between
`PROJECT.md` (identity, scope) and `ARCHITECTURE.md` (shape).

`PROJECT.md` answers *what is this and why?*
`ARCHITECTURE.md` answers *how is it built?*
**`SPEC.md` answers *exactly how should it behave, and what would prove
it's wrong?***

For trivial CRUD-style projects, this file may stay short. For anything
non-trivial, the AI cannot write good acceptance criteria for Phase 2
tasks without it.

---

## Core user flows

TBD — for each major user-facing flow, document:

- Trigger / entry point
- Pre-conditions
- Happy-path steps and expected outputs
- Failure modes and expected error UX
- Permissions / authorization required

Example shape for each flow:

```
### Flow: Create account
- Trigger: User submits the signup form.
- Pre-conditions: Email is not already registered.
- Happy path:
  1. Server validates payload (schema).
  2. Password is hashed (argon2id, see ADR-NNN).
  3. User row inserted; verification email queued.
  4. Response: 201 with session token.
- Failure modes:
  - Email already registered → 409, error code USER_EXISTS.
  - Weak password → 422, error code WEAK_PASSWORD.
  - Email service down → 503, signup deferred to retry queue.
- Authorization: anonymous; rate-limited per IP.
```

---

## Edge cases and invariants

TBD — list invariants the project must maintain regardless of input:

- TBD: e.g. "An order's `total` always equals the sum of its line
  items' `subtotal` plus tax minus discounts."
- TBD: e.g. "A user cannot delete a project they don't own."
- TBD: e.g. "All timestamps are stored UTC; rendered in user TZ."

---

## Performance budgets

TBD — concrete numbers, not vibes:

- p50 / p95 latency for critical endpoints
- Time-to-interactive for top pages
- Cold-start budget for serverless functions
- Database query budget per request (max N+1 risk)
- Cost per 1000 requests / users / actions (cross-reference `BUDGET.md`)

---

## Accessibility targets

TBD:

- WCAG conformance level (A / AA / AAA) and which one is enforced in CI
- Keyboard-navigability requirements
- Screen-reader requirements
- Color-contrast minimums

---

## Browser / device / runtime support

TBD:

- Supported browser versions (e.g. last 2 majors of evergreen browsers)
- Mobile / tablet support
- Minimum runtime version on the server side
- Offline / poor-network behavior, if relevant

---

## Compliance / privacy / data-handling

TBD — flag if any of these apply:

- GDPR / CCPA / other privacy regimes
- HIPAA / PCI / SOC 2 / similar
- Data-residency requirements
- PII fields and their retention rules
- Right-to-erasure / data-export flows

If any apply, each gets an ADR with the implementation approach.

---

## Open questions
- TBD — questions that don't have answers yet but must before
  implementation. Each open question should have an owner.
