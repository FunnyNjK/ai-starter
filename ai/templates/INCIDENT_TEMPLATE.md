# Incident Post-Mortem Template

Use this template for any production incident that required a hotfix
(see `/ai/WORKFLOW.md` Hotfix workflow). File the completed
post-mortem in `/ai/incidents/YYYY-MM-DD-<short-slug>.md` and link it
from the relevant `DONE_LOG.md` entry.

The goal is **learning**, not blame. Write what happened, why,
and what changes prevent the same root cause next time.

---

## Incident: {short title}

- **Date / time**: {start UTC} → {resolved UTC}
- **Duration**: {hh:mm}
- **Severity**: {SEV-1 / SEV-2 / SEV-3 — define what each means in
  `/ai/DEPLOYMENT.md` Operational Notes}
- **Detected by**: {alert / user report / monitoring / etc.}
- **Resolved by**: {hotfix PR link, commit hash, person who shipped}

## Summary

One paragraph. What broke, who was affected, and how it was fixed.

## Impact

- Users affected: {count or %}
- Functionality affected: {feature / endpoint / page}
- Data affected: {none / loss / corruption — be specific}
- Revenue / SLO impact: {if measurable}

## Timeline (UTC)

- **{HH:MM}** — change deployed / first symptom appeared
- **{HH:MM}** — alert fired / user report received
- **{HH:MM}** — engineer engaged
- **{HH:MM}** — root cause identified
- **{HH:MM}** — hotfix shipped
- **{HH:MM}** — confirmed resolved

## Root cause

What technically caused the failure. Specific. "A null `coupon_id`
caused the checkout handler to dereference a missing field," not "the
checkout had a bug."

## Contributing factors

What made this incident more likely or harder to detect:

- Missing test coverage for the failing code path?
- Monitoring gap?
- Recent change in adjacent code that masked the symptom?
- Manual deployment step that was skipped?
- Rollback was hard?

## What went well

- Detection time
- Response coordination
- Anything the team did right (recognize good responses publicly)

## What went poorly

- Detection delay
- Coordination friction
- Tooling that fought the responder

## Action items

For each item, a `TASKS.md` entry must exist. Hotfixes defer real
fixes; the post-mortem is where they get scheduled.

| ID | Action | Owner | Priority | TASKS.md ID |
| -- | ------ | ----- | -------- | ----------- |
| 1  | Add regression test for {root cause} | TBD | High | TBD |
| 2  | Add monitoring for {symptom} | TBD | High | TBD |
| 3  | Document {runbook gap} | TBD | Medium | TBD |
| 4  | Refactor {brittle area} | TBD | Medium | TBD |

## Lessons

What did we learn that's worth remembering across future projects, not
just this one? Capture it here so the next incident isn't a repeat.
