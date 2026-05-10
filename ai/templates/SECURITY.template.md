# Security Policy

## Reporting a vulnerability

If you discover a security vulnerability in this project, please report
it privately. **Do not open a public GitHub issue.**

Preferred channels (in order):

1. **GitHub Security Advisories** — go to the [Security tab](../../security/advisories/new)
   of this repo and file a private advisory.
2. **Email** — {security-contact-email, e.g. security@example.com}.
3. **{Other secure channel, if applicable, e.g. Signal / Keybase}**.

When reporting, please include:

- A description of the vulnerability and its potential impact.
- Steps to reproduce, or a proof-of-concept.
- Affected versions, if known.
- Your contact info (so we can follow up; anonymous reports are
  accepted but harder to triage).

We aim to acknowledge reports within **{N} business days** and to issue
a fix or mitigation within **{N} days** for critical issues. We
coordinate disclosure with the reporter.

## Supported versions

Only the latest released version receives security updates by default.

| Version | Supported |
| ------- | --------- |
| {1.x}   | ✅ |
| {0.x}   | ❌ |

## Security baseline

This project follows the Security Rules (Hard) defined in
`/ai/AI_RULES.md`. Highlights:

- Secrets live only in the cloud-managed secret store; never in source,
  lockfiles, logs, or commit history.
- TLS for all network endpoints.
- Battle-tested authentication libraries / managed services; never
  rolled in-house.
- argon2id (default) or bcrypt for password hashing.
- Deny-by-default authorization with principle of least privilege.
- Schema validation at trust boundaries.
- Dependency scanning + SAST in CI from day one.
- OIDC federation for CI → cloud (no long-lived static cloud keys).
- Container images pinned by digest, scanned for CVEs, run as
  non-root.

The project-specific implementation of each is recorded as ADRs in
`/ai/DECISIONS.md` and indexed in `/ai/PROJECT.md` "Security
Baseline".

## Out of scope

- Issues that require a sophisticated insider attacker with full
  filesystem / database access to a machine the project is running on.
- Denial-of-service via unauthenticated traffic at the rate limiter
  (the limiter exists; tuning is a separate non-security issue).
- Vulnerabilities in unsupported (older) versions.

## Attribution

We credit reporters in release notes and / or the GitHub Security
Advisory unless they request anonymity.
