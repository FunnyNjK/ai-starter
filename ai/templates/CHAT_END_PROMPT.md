Stop work and prepare the project handoff.

Update or provide exact patches for:

1. `/ai/CURRENT_STATE.md`
2. `/ai/TASKS.md`
3. `/ai/HANDOFF.md`
4. `/ai/DONE_LOG.md`

Also update these if relevant:

- `/ai/ARCHITECTURE.md`
- `/ai/ROADMAP.md`
- `/ai/TESTING.md`
- `/ai/DEPLOYMENT.md`
- `/ai/DECISIONS.md`
- `/ai/SPEC.md` (if behavior expectations changed)
- `/ai/BUDGET.md` (if cost-impacting changes were made)

Final response must include:

- **Work completed** — what shipped this session.
- **Files changed** — list of paths touched.
- **Tests / checks run** — concrete commands and outcomes.
- **Known issues** — anything not working as intended.
- **Project files updated** — which `/ai/*.md` files were modified.
- **Next recommended task** — task ID + one-sentence why-this-next.
- **Self-critique** — see below. This section is required.
- Confirmation that no (Hard) rules from `/ai/AI_RULES.md` were
  violated. Specifically: Git Rules, Versioning, Security,
  Infrastructure & Hosting, Cost, Destructive Operations, Reasoning
  Checkpoint, Blocked Escalation, Task Quality.

## Self-critique (required)

Be honest. The next session is at a disadvantage if you paper over
weak spots. Cover at minimum:

- **Assumptions made** — anything I assumed without verifying. Name
  the assumption explicitly. ("I assumed the migration ran cleanly in
  staging — I did not verify against the staging DB.")
- **Things skipped or deferred** — work that the task spec mentioned
  but I didn't do, with the reason. Anything filed as a follow-up
  task should be cross-referenced by ID.
- **Things the next session should double-check** — concrete checks
  the next AI should run before building on top of this work. ("Run
  `terraform plan` — should be empty. If not, ADR-014 may need
  revisiting.")
- **Risks I'm aware of but didn't fully resolve** — known gotchas,
  brittle areas, or decisions I made under uncertainty.

A short, blunt list is more useful than a polished narrative. If
there's nothing to flag in a category, write "none" — don't omit
the section.
