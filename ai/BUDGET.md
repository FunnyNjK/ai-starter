# Budget

Last Updated: 2026-05-10

## Status
TBD until the project is initialized.

Cloud costs sneak up. This file tracks the project's monthly budget,
alert thresholds, and the resources contributing to it. The Cost Rules
(Hard) in `/ai/AI_RULES.md` reference this file.

---

## Monthly budget cap

TBD — record the agreed monthly cap in USD and which environments it
covers (dev, QA, prod combined or separately).

| Environment | Monthly cap (USD) | Owner |
| ----------- | ----------------- | ----- |
| dev         | TBD               | TBD   |
| QA          | TBD               | TBD   |
| prod        | TBD               | TBD   |

---

## Alert thresholds

TBD — at what spend level do we get notified, and where:

- 50% of cap → notification channel (Slack / email / PagerDuty)
- 80% of cap → notification channel
- 100% of cap → notification channel + escalation
- Forecasted-overage alert (anomaly detection, if available)

Each cloud has a native budgets feature:
- AWS: AWS Budgets + SNS
- Azure: Cost Management + Action Groups
- Google Cloud: Cloud Billing budgets + Pub/Sub

The chosen mechanism is recorded as an ADR.

---

## Major cost contributors

TBD — list the resources that materially affect monthly spend, with
estimated cost. Update when a new significant resource is added.

| Resource | Service / SKU | Estimated $/month | Notes |
| -------- | ------------- | ----------------- | ----- |
| TBD      | TBD           | TBD               | TBD   |

---

## Free-tier and tier choices

TBD — for each managed service, record:

- Which tier is in use (free / shared / dedicated / scale-to-zero / etc.)
- The free-tier limits we're relying on, if any
- The pre-agreed escalation path when those limits are exceeded

---

## Cost-impacting changes log

TBD — whenever a change materially shifts monthly cost (new service,
scale-up, region duplication, paid third-party integration), log it
here with the date, the change, and the new estimate. Each such change
also needs an ADR.

| Date | Change | Δ $/month | ADR |
| ---- | ------ | --------- | --- |
| TBD  | TBD    | TBD       | TBD |

---

## Review cadence

TBD — when does this file get re-checked against actual spend? A
monthly review is a sensible default; quarterly is the floor.

Last actual-vs-budget review: TBD.
