# Task Template

### [PHASE]-T[NUMBER]: [Task Title]
Status: Backlog
Owner: TBD
Priority: Medium

## Goal
TBD - one or two sentences. What this task achieves and why.

## Prerequisites
- TBD - list of task IDs that must be `Done` before this task can start.
  Use `none` if this task has no prerequisites. The next AI session will
  refuse to start a task whose prerequisites are not yet `Done`.

## Scope Included
- TBD

## Scope Excluded
- TBD

## Files Likely Involved
- TBD

## Step-by-Step Instructions
Required when ordering matters (scaffold → CI → security baseline →
first deploy; IAM before storage; network before compute; DB schema
before app code that reads it; OIDC trust before first deploy; etc.).
For tasks where the order is obvious or trivial, this can be a single
bullet pointing back to the scope above.

1. TBD - first step. Expected outcome / state after this step.
2. TBD - next step. Expected outcome.
3. ...

## Acceptance Criteria
- TBD - measurable outcomes that mark the task as Done.

## Verification
At least one verification step is required. The next task relies on it.
- TBD - exact checks: commands and expected exit codes, URLs and
  expected status codes, `terraform plan` is empty, migrations appear in
  a specific list, etc.

## Test Requirements
- TBD

## Security Considerations
- TBD - call out anything from `/ai/AI_RULES.md` Security Rules that
  applies (secrets handling, TLS, authz, rate limiting, dependency
  scanning, OIDC, secret store, network defaults, etc.).

## Rollback / Recovery
- TBD - what to do if this task fails partway, especially if partial
  state would block subsequent tasks (cloud resources partially created,
  migration half-applied, secret rotated but not redeployed). Use
  `not applicable` for pure-code tasks where `git reset` is sufficient.

## Dev Environment Constraints
- TBD - any constraints from `/ai/DEV_ENVIRONMENT.md` that apply.

## Handoff Notes
- TBD
