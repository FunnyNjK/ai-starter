# Deployment

Last Updated: 2026-05-10

## Deployment Status
TBD until the project is initialized.

---

## Target Environments

TBD - typical environments to define:

- **Local development**
- **Staging / Preview**
- **Production**

---

## CI/CD

TBD - describe the CI workflows, what they run, and what triggers them
(push, pull request, scheduled, manual).

---

## Secrets and Configuration

- Do not commit secrets.
- Document where each environment variable is used and where its value lives
  (local config files, host-side secret manager, CI secrets, etc.).

### Required Environment Variables

| Name | Where used | Notes |
| ---- | ---------- | ----- |
| TBD  | TBD        | TBD   |

---

## Deployment Commands

TBD - the commands needed to build, deploy, and verify a release.

---

## Initial Setup (one-time per project)

TBD - the one-time configuration needed to make a new environment ready
for deployments (cloud resources, DNS, certificates, service accounts,
etc.).

---

## Rollback Plan

TBD - how to roll back a bad release.

---

## Operational Notes

TBD - capacity limits, monitoring, log locations, on-call expectations.
