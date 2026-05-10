# Workflow

Last Updated: 2026-05-10

How code, branches, PRs, hotfixes, and blockers move through this project.
This is the cross-project default. Per-project overrides go in
`/ai/DECISIONS.md` as ADRs.

---

## Branching strategy

Default: **trunk-based with short-lived feature branches**.

- `main` is always deployable. CI green is the gate.
- All work happens on a branch named with one of these prefixes:
  - `feat/<slug>` — new feature work
  - `fix/<slug>` — bug fix
  - `chore/<slug>` — refactor, docs, dep bump, infra-only changes
  - `hotfix/<slug>` — urgent production fix (see Hotfix workflow below)
  - `claude/<slug>`, `cursor/<slug>`, `codex/<slug>`, `copilot/<slug>` —
    AI-driven branches (the harness scripts use these)
- Slugs are short, kebab-case, ~3-6 words: `feat/user-export-csv`,
  `fix/csrf-cookie-flag`.
- Feature branches stay alive for hours-to-days, not weeks. If a branch
  goes stale, rebase on `main` or close it.

---

## Pull request workflow

1. Open a PR as soon as the work is meaningfully shaped, even if not
   complete — mark it Draft.
2. PR title: short imperative, ~70 chars max. Match the commit-message
   style of the project.
3. PR body uses `.github/pull_request_template.md` (auto-filled). Don't
   skip the Verification, Security, Cost, and Rollback sections — they
   exist because they catch real bugs.
4. CI must be green before merge.
5. **Merge strategy**:
   - Default: **squash merge** for `feat/`, `fix/`, `chore/` branches —
     keeps `main` history linear and one commit per logical change.
   - **Merge commit** for `hotfix/` branches — preserves the
     hotfix-specific commits for the post-incident audit trail.
   - **Rebase** is acceptable for small chains; `--force-with-lease` only
     (never plain `--force`).
6. After merge, delete the remote branch (GitHub's "Delete branch"
   button, or `gh pr merge --delete-branch`).

---

## Direct-to-main exceptions

Direct commits to `main` are allowed for **trivial, low-risk, single-file
changes** that don't merit a PR:

- Typo fixes in docs.
- One-line README / link updates.
- Updating `Last Updated:` dates on planning files.
- Adding a new ADR that only documents an already-applied decision.

When in doubt, open a PR. The bar for direct-to-main is "this would be
embarrassing to ask someone to review."

---

## Hotfix workflow

Production is broken and the normal task-bounded workflow is too slow.

1. Branch from `main`: `hotfix/<short-incident-slug>` (e.g.
   `hotfix/checkout-500-on-null-coupon`).
2. Make the **smallest possible** change that restores service. Resist
   the urge to refactor or expand scope.
3. Open a PR. Title prefixed `hotfix:`. Body links the incident, names
   the symptom, and notes the root cause if known.
4. CI must still pass. Hotfix is not an excuse to skip tests.
5. Merge with a **merge commit** (not squash) so the hotfix-specific
   commits stay visible in history.
6. Deploy.
7. **Within 24 hours**, write a post-incident entry using
   `/ai/templates/INCIDENT_TEMPLATE.md` and file follow-up tasks in
   `TASKS.md` for any deeper fixes the hotfix deferred (proper
   refactor, missing test coverage, monitoring gap, runbook update).

---

## Blocked / escalation pattern

If the AI (or a human contributor) cannot make progress on a task for
any reason — missing prerequisite, unclear requirement, conflicting
instruction, external dependency, ambiguous architecture decision —
the response is **Blocked**, not "best effort that ships anyway."

Steps:

1. Set the task's `Status: Blocked` in `TASKS.md`.
2. Write the blocker in `HANDOFF.md` under "What Is Blocked", one line:
   what's blocking, what would unblock, who/what owns it.
3. If the blocker requires a decision (architecture, scope, dependency
   choice), surface it to the user with a recommendation and the main
   tradeoff — do not silently pick.
4. Stop work on that task. Do NOT mark it Done. Do NOT silently work
   around the blocker with untested assumptions.
5. Move to the next non-blocked task in `TASKS.md`, or surface that
   nothing is unblocked and wait.

This is a Hard rule (see `/ai/AI_RULES.md` Task Quality Rules and
Blocked Escalation Rule).

---

## Conflict resolution

When a PR has merge conflicts on `main`:

- Rebase the feature branch on the latest `main`, resolve conflicts
  locally, force-push with `--force-with-lease`.
- Do NOT use `git merge main` into the feature branch — it pollutes the
  history with merge commits that the squash merge will collapse anyway,
  and obscures the actual diff.
- For non-trivial conflicts (especially in planning files like
  `CURRENT_STATE.md`, `TASKS.md`, `HANDOFF.md`), surface the conflict to
  the user — these files capture truth and should not be auto-resolved.

---

## Code review (when there's a reviewer)

- Reviewer runs the PR's verification checklist before approving.
- Required review for: anything touching `/ai/AI_RULES.md`, `/ai/DECISIONS.md`,
  Terraform, security-sensitive code, dependency additions/removals.
- Optional review for: typo fixes, planning-file housekeeping, AI-generated
  task work that's already passed CI + verification.
- Reviewer leaves blocking comments only for things that would actually
  break production or violate a Hard rule. Style nits go in non-blocking
  comments.

---

## What this workflow assumes

- Solo or small team. Larger teams (>5 contributors) may want
  pre-commit hooks, CODEOWNERS, branch protection rules, required
  reviewers — those are layered on top, not replacements.
- A real CI pipeline (lint / type-check / test / build) configured in
  Phase 1.
- Git remote on a host that supports PR semantics (GitHub, GitLab,
  Bitbucket, Azure DevOps).
