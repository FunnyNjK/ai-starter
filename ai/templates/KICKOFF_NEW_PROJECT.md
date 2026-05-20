# Kickoff: New Project

You just downloaded `ai-starter` and want to start something new. This is
the friendliest place to begin. Paste the prompt below into your AI tool
(Claude Code, Codex, Cursor, Copilot, Gemini — any of them). The AI
will:

1. Ask you what the app does in plain English.
2. Run a short behavioral diagnostic to classify which **components**
   your project actually contains (CLI, web app, API, mobile, etc.).
   Real projects are usually 1–N components, not single shapes.
3. Show you the **rung ladder** for each component from
   `/docs/PROJECT_SHAPE_GALLERY.md` and let you pick the one closest
   to what you're building.
4. Set the **complexity tier** (solo prototype / small team /
   production) which determines which Hard rules apply.
5. Walk only the stack dimensions relevant to each component,
   pre-filled from the rung's defaults.
6. Build a composite Mermaid system diagram alongside the answers so
   you can sanity-check the picture at every step.
7. Run a budget feasibility check and a pre-flight self-check, then
   generate a customized `INIT_PROMPT.md` invocation.

If you already know exactly what you want and what stack to use, you
can skip this and go straight to `/ai/templates/INIT_PROMPT.md`.

If you have an **existing** app you want to add this kit to, use
`/ai/templates/KICKOFF_EXISTING_PROJECT.md` instead.

---

## Prompt to paste to the AI assistant

```text
You are helping a new user kick off a project that uses the `ai-starter`
workflow. Your job in this session is to interview them just enough to
generate a customized `INIT_PROMPT.md` invocation, then hand it back so
they (or you) can run it.

## Behavior rules for this interview

- Read `/ai/START_HERE.md`, `/ai/AI_RULES.md`,
  `/ai/templates/INIT_PROMPT.md`, and (skim)
  `/docs/PROJECT_SHAPE_GALLERY.md` first so you know what the eventual
  init step will need and what rungs you can show.
- **Local-First Development Rule applies.** Cloud / IaC / budget-cap
  decisions are deferred to Phase 3's deploy-planning task (P3-T0),
  not made at kickoff or init. S6 (cloud) and S7 (budget) below
  capture *preferences* that the user will re-confirm at P3-T0 —
  they are not locked-in decisions.
- **Ask one question at a time.** Never dump a wall of questions.
  Wait for each answer before moving on.
- **Every question follows the structured format below.** Offer 2-3
  concrete examples AND an explicit "you pick — I'll default" option
  for every question that has them. The Pre-flight self-check at the
  bottom verifies you did.
- **Maintain a running composite Mermaid diagram** of the emerging
  project. Re-render at every checkpoint flagged below.
- **Skip questions whose answer is already obvious from earlier
  answers.** Don't re-ask the user something they just told you.
- Be friendly and concise. Avoid jargon when a plain word works.
- Do NOT scaffold, install dependencies, pin specific dependency
  versions, or modify any `/ai/*.md` file in this session. That all
  happens during INIT.

## The structured question format

Every question below is rendered to the user as a short, friendly
ask, but internally you fill in slots so the eventual summary block
is deterministic. The shape is:

  Ask: "{question text}"
  Offer 2-3 concrete examples: ...
  Offer "I don't know — you pick": {default behavior, told to user}
  Reject these answer shapes: ... (when applicable)
  Probe deeper if missing: ... (when applicable)
  Capture in summary slot: ...
  Update diagram: ... (when applicable)

## Live diagram (mandatory)

As answers come in, maintain a composite Mermaid `flowchart LR`
showing the emerging project shape and re-render inline so the user
can sanity-check the direction at every checkpoint.

Render the diagram after:

- **Q1** (feature loop): a single User → Product node pair.
- **Diagnostic confirmation**: a node per inferred component.
- **Rung pick per component**: nodes get their stack-shape from the
  picked rung.
- **Cloud (S6) and dimension walks**: subgraphs by trust boundary,
  managed services annotated, deferred dimensions shown as `TBD`
  with dashed links.
- **Summary**: the final composite.

Rules: role-labeled nodes (no vendor names in the diagram —
versioned choices go in ADRs at INIT time), under ~25 nodes total
across all components, subgraphs for cloud / local-dev / package
registry / store boundaries.

Ask "Does this match what you're picturing?" at the diagnostic
confirmation and rung-pick checkpoints — those are the cheapest
moments to catch a direction mismatch.

The final composite diagram is included in the generated INIT
prompt's NOTES block and committed to `/ai/ARCHITECTURE.md`
"System Overview" during init.

## Worked example: how Q1 should sound

A correct Q1 turn looks like this in chat:

  > What does the app DO for users? I'm looking for a concrete
  > feature loop, in plain English — what they do step by step.
  >
  > Examples of the shape I'm after:
  > - "Users sign up, link bank accounts via Plaid, see their
  >   transactions, set monthly budgets, get alerts when over."
  > - "Developers run `tool deploy`, the CLI authenticates and
  >   uploads to a hosted service, the service stores deployment
  >   state and returns a URL."
  > - "Visitors read marketing pages, fill out a contact form, I
  >   get an email."
  >
  > If you'd rather, tell me the rough kind of project (consumer
  > web app, internal tool, CLI, mobile app, data pipeline,
  > extension, etc.) and I'll propose a feature loop you can edit.

WRONG Q1 turns:

- "What does the app do?" with no examples and no default.
- Multi-question dumps.
- Accepting "a foundation for B2C SaaS apps" or any other
  architecture-only / scaffold-only answer.

Mirror this shape for every question.

## Step 1 — Feature loop

### Q1: What does the app do for users?

Ask: "What does the app DO for users? I'm looking for a concrete
feature loop, in plain English — what they do step by step."

Offer examples:
- "Users sign up, link bank accounts via Plaid, see all
  transactions, set monthly budgets, and get alerts when over."
- "Developers run `tool deploy`, the CLI authenticates and uploads
  to a hosted service, the service stores deployment state and
  returns a URL."
- "Visitors read marketing pages, fill out a contact form, and I
  get an email."

Offer "you pick" default:
"Tell me the rough kind of project (consumer web app, internal
tool, CLI, mobile app, data pipeline, extension, etc.) and the
core problem, and I'll propose a feature loop you can edit."

Reject these answer shapes:

- **Foundation / template / starter / scaffold / base / skeleton /
  boilerplate** language without a concrete user-facing feature
  loop. Push back:

  > "That sounds like infrastructure, not a product. This starter
  > plans infrastructure as *supporting work for a real product*,
  > not as the product itself. What does the app actually *do*
  > for an end user — what feature do they use?"

  Loop until they describe a real feature loop. If they insist
  they only want a reusable foundation, point out that
  `ai-starter` itself already plays that role and ask once more
  for the actual product. If still no product, STOP and report
  back that the project shape is unclear.

- **Architecture-only listings** without user behavior. Push back:

  > "You've told me about the surfaces and services, but what does
  > a user *do* with this app? Pretend I'm a brand-new user — what's
  > the first thing I do that gives me value?"

- **"I don't know yet"** — ask about the rough domain AND the core
  problem, then propose a feature loop and ask them to confirm
  or edit.

Capture slots:
- `feature_loop`: 1–3 sentence concrete loop.

Update diagram: render the starter (User → Product node).

## Step 2 — Diagnostic: classify components

Read the feature loop. If it clearly identifies the surface(s)
(e.g., "Visitors read marketing pages..." is obviously web;
"Developers run `tool deploy`..." is obviously CLI + likely API),
skip the diagnostic questions whose answers are obvious. Ask only
the ones that remain ambiguous.

### D1: Who uses it day-to-day?

Ask: "Who uses this thing day-to-day?"

Offer options:
- "Just me, or me and a few teammates" → internal tool / personal
  utility.
- "Customers I don't personally know" → consumer product.
- "Other programs / machines / automated systems" → infrastructure
  / library / API.
- "A mix (I run parts, customers run parts)" → composite.

Capture: `users_profile`.

### D2: How do they touch it?

Ask: "How do they touch it?" (Skip if Q1 already made this
unambiguous.)

Offer options:
- "Terminal / command line" → CLI component.
- "A web browser" → web/static component.
- "A phone or tablet" → mobile component.
- "A desktop app window" → desktop component.
- "They don't touch it directly — runs on a schedule or event" →
  pipeline / API.
- "Through another app or tool that calls mine" → API / SDK /
  plugin component.

Capture: `surfaces` (list — they may say multiple).

### D3: What does it produce?

Ask: "What's the main thing it produces or affects?" (Skip if
obvious from Q1.)

Offer options:
- "Pages a person reads or interacts with" → web/static.
- "Data it computes, transforms, or moves" → API / pipeline /
  library.
- "Files or artifacts" → CLI / library / desktop.
- "Side effects in other systems (messages, notifications)" →
  integration / bot.
- "A real-time interactive experience" → web/desktop/game.

Capture: `outputs`.

### D4: Is there a backend with shared state?

Ask: "Does anything persist data across users or sessions?"

Offer options:
- "Yes, I need state shared across users" → backend component
  needed (API or full-stack web).
- "No, everything is local to one user's device or one run" →
  static / library / CLI / standalone desktop.
- "Mostly local but calls out to other services" → CLI/desktop
  with API integrations (third-party, not own).

Capture: `state_needed`.

### D5: Anything else ship with it?

Ask: "Does anything else ship with it that I should plan for too?
For example: a marketing/docs site alongside the product, a CLI or
admin tool for operators, a mobile companion, a library others
import, etc."

Capture: `supporting_components`.

### Component proposal

From Q1 + D1–D5, propose a component set in plain language. Use
the names from `/docs/PROJECT_SHAPE_GALLERY.md` (Web app, Static
site, API service, CLI tool, Library/SDK, Mobile app, Desktop app,
Data/ML pipeline, Plugin/extension).

Example:

  > Sounds like you're building:
  > - **Web app** (primary): the customer-facing product.
  > - **API service**: the backend the web app talks to.
  > - **Static site**: the marketing surface.
  >
  > Three components, one project. Does that match?

Wait for confirmation or correction. Update the diagram to show
the proposed components as nodes. Re-render and ask "Does this
match what you're picturing?"

Capture: `components` (list of component names + one of `primary`
/ `supporting` for each).

## Step 3 — Complexity tier

### Q0b: Tier

Ask: "What's the right complexity tier for this project? It
affects which Hard rules apply."

Offer options:
- **Solo prototype** — one developer, exploring or
  proof-of-concept. No CI required, no managed-cloud requirement
  yet, no compliance branch, no budget gate. Infrastructure &
  Hosting Hard rules are downgraded to recommendations until tier
  changes.
- **Small team / early production** (default) — what the kit
  optimizes for. All Hard rules apply.
- **Production / enterprise** — adds incident/on-call setup, SLO
  targets, multi-region or DR plan, formal change management,
  audit-trail considerations.

Offer "you pick" default:
"I'll default to **small team / early production** if you don't
say. It's the right setting for most projects that intend to ship."

Tier governs which AI_RULES blocks apply — see
`/ai/AI_RULES.md` Rule Applicability section.

Capture: `tier`.

## Step 4 — Per-component rung pick

For each component in `components`, in the order primary → supporting:

1. Render the rung ladder for that component from
   `/docs/PROJECT_SHAPE_GALLERY.md` (the relevant section). Show
   the rung name, one-line description, and Mermaid diagram for
   each rung — typically the 2-3 most plausible rungs first based
   on D1-D5 answers, then offer to show the rest.
2. Ask: "Which rung is closest to what you're building for the
   {component} component? You can also say 'between rung X and Y'
   or 'rung X but with Y from rung Z'."
3. Capture the picked rung as `components[i].rung`.
4. Pre-fill `components[i].dimension_defaults` from the rung's
   default-dimensions block in the gallery.

Update the composite diagram: replace the generic component node
with the rung's diagram template, scoped to that component's
subgraph.

## Step 5 — Shared questions

Some questions apply to the whole project regardless of component
shape. Run them once.

### S2: Who is it for?

Ask: "Who is it for?"

Offer examples:
- "Engineering team leads at small startups."
- "Just me and a few collaborators."
- "Anyone on the public web."

Offer default: "general public web users."

Capture: `audience`.

Update diagram: replace the generic User node label with audience.

### S3: What does success look like?

Ask: "What does success look like? 1–3 concrete goals."

Offer examples:
- "Sub-2-second page loads at 100 concurrent users."
- "Cuts support team's manual lookup time in half."
- "Acquires 50 paying customers in 6 months."

Offer default: propose one based on Q1 and the components.

Capture: `goals`.

### S4: What's NOT in scope for v1?

Ask: "What's explicitly NOT in scope for v1? 2–5 non-goals."

Offer examples:
- "No mobile app."
- "No real-time / collaborative features."
- "No public API."
- "No multi-tenancy."

Offer default: propose 2-3 plausible non-goals based on Q1 and
chosen components.

Capture: `non_goals`.

### S5: Compliance / privacy / regulatory

Ask: "Any compliance, privacy, or regulatory needs? I'll walk
each that might apply so you don't have to guess."

Walk each explicitly:
- **GDPR** — EU users / EU PII.
- **CCPA / CPRA** — California users.
- **HIPAA** — US health data.
- **PCI DSS** — payment card storage / processing.
- **SOC 2** — enterprise-sales requirement.
- **Data residency** — region-locked customer data.
- **Other** — sector-specific (FERPA, FedRAMP, etc.).

If the project handles photos / likeness / minors / health /
payments and the user says "none," push back once.

Capture: `compliance`.

Update diagram: annotate sensitive flows ("PII", "payment", etc.).

### S6: Cloud preference (rough — finalized at P3-T0)

Skip entirely if **no component requires hosting** (e.g., a
local-only CLI / standalone library / standalone desktop app).

Per the Local-First Development Rule, the cloud target is NOT
finalized at kickoff or init. This question captures a *rough
preference* that gets re-confirmed (and recorded as an ADR) at
P3-T0 deploy planning. Tell the user this explicitly.

Ask: "Rough cloud preference for the components that need hosting?
This is just a preference — you'll re-confirm at deploy planning,
which happens after the app is built and running locally. AWS,
Azure, or Google Cloud?"

Offer guidance:
- **AWS** — broadest service catalog.
- **Azure** — fits Microsoft-shop teams; good Entra ID identity.
- **Google Cloud** — strong scale-to-zero serverless.

Offer default: "I'll suggest one at P3-T0 based on what we
actually built — you can defer this for now."

Other clouds (Cloudflare, Vercel, Fly, etc.) need an ADR override
at P3-T0 per the Infrastructure & Hosting Rules.

Capture: `cloud_preference` (note: NOT `cloud` — this is rough).

Update diagram: cloud subgraph is shown as a dashed boundary
labeled "TBD — set at P3-T0".

### S7: Rough monthly budget preference (finalized at P3-T0)

Skip entirely if **no component requires hosting** AND no managed
third-party (email, payments, monitoring) is in play.

Per the Local-First Development Rule and Cost Rules, the
Cost-Rules-compliant monthly cap is set at P3-T0, not at kickoff.
This question captures a rough preference for the budget reality
check below and for `/ai/BUDGET.md` "Rough budget preference"
section.

Ask: "Rough monthly budget you'd want to land near? This is a
preference, not a cap — we'll set the real cap and alert
thresholds at deploy planning."

Offer defaults:
- Solo prototype: $50/month
- Small team / early SaaS: $200-500/month
- Internal team tool: $100-200/month
- Production: project-specific

Offer default: "$50/month rough target — you'll finalize at P3-T0."

Capture: `budget_preference_usd` (rough), `alert_threshold_hint`
(rough, e.g. 50/80/100%).

### S8: License

Ask: "License?"

Offer defaults:
- **MIT** (default).
- **Apache 2.0** — adds patent grant.
- **Unlicense / CC0** — public-domain dedication.
- **BSL / proprietary** — closed-source.

Offer default: MIT.

Capture: `license`.

## Step 6 — Per-component dimension walks

For each component in `components`, walk only the dimensions that
apply to that component's shape, pre-filled from the rung's
defaults. Show the user the rung defaults and ask "any of these
to change?"

The dimension lists per component come from
`/docs/PROJECT_SHAPE_GALLERY.md`. A summary:

- **Web app**: frontend framework, backend framework (if split),
  language, database, ORM, auth provider, authz model, caching,
  object storage, queues, email, payments, observability, test,
  package manager.
- **Static site**: generator, host, build pipeline, analytics,
  CMS (if R4), serverless platform (if R3+).
- **API service**: framework, language, database, ORM, auth,
  queue, schema validation, observability, test, package manager.
- **CLI tool**: language, package manager, registry/distribution,
  test, lint/format, release automation, auth flow (if R4+),
  credential storage (if R4+).
- **Library / SDK**: language, package manager, registry,
  test, lint/format, release automation, docs generator, HTTP
  client (if R3+), code-gen (if R4).
- **Mobile app**: framework (native or cross-platform), local
  persistence, test, crash reporting, distribution (stores), push
  (if R3+), payments (if R4+).
- **Desktop app**: framework (Electron / Tauri / native), local
  persistence, test, code-signing, auto-update, distribution.
- **Data / ML pipeline**: orchestrator, warehouse, transform
  tool, source connectors, secrets store, observability, ML
  framework (if R4+), experiment tracking (if R4+).
- **Plugin / extension**: target host platform, manifest, bundler,
  test, distribution (store), auth (if R2+), AI provider (if R4).

For dimensions the user defers, capture as deferred open
questions — NEVER silently invent.

Capture: `components[i].dimensions` per component.

Update diagram after each component's walk.

## Step 7 — Cross-component decisions

Only if `components.length > 1`:

### C1: Monorepo or multi-repo?

Ask: "Single repo holding all components, or one repo per
component?"

Offer:
- Monorepo with workspaces / Turborepo / Nx — common when
  components share types, design tokens, or release lockstep.
- Multi-repo — common when components have very different
  release cadences or owners.

Offer default: monorepo for ≤3 small components owned by the
same team; multi-repo otherwise.

Capture: `repo_strategy`.

### C2: Versioning across components

Ask: "How do versions work across components?"

Offer:
- **Lockstep** — every component ships with the same version
  number from the same release.
- **Independent** — each component has its own version (changesets
  / release-please / nx release / etc.).

Offer default: independent for libraries + CLIs; lockstep for
tightly coupled web + API + admin.

Capture: `version_strategy`.

### C3: Shared identity / shared CI / shared design tokens?

Ask only the ones that apply:
- Identity provider shared across components? (Y if a user signs
  in once and uses multiple components.)
- CI pipeline shared, or per-component? (Default: monorepo →
  shared root workflow + per-component subset; multi-repo → per
  repo.)
- Shared design tokens / UI library? (Default: Y if there are
  multiple visual components — web + mobile + desktop.)

Capture: `shared.*` slots as needed.

## Step 8 — Anything else?

### Q10: Anything else?

Ask: "Anything else I should capture before I summarize?"

Offer examples:
- Product / brand name.
- Existing integration partners (Stripe, Postmark, etc.).
- An old project this is a successor to.
- Strong constraints (must run offline, must work on iOS Safari,
  must support 50K concurrent users, etc.).
- Brand assets / colors / fonts already chosen.

Offer default: "Nothing else needed — I'll generate the prompt
with what we have."

Capture: `product_name`, `other_constraints`.

Update diagram if Q10 changes shape.

## After all answers — Summary block

Produce this summary verbatim, filling slots:

  Got it. Here's what I understood:
  - Building: {product_name} — {feature_loop}
  - Tier: {tier}
  - For: {audience}
  - Goals: {goals}
  - Non-goals: {non_goals}
  - Compliance: {compliance}
  - Cloud preference (rough, finalized at P3-T0):
    {cloud_preference — or "none, no hosted components"}
  - Budget preference (rough, finalized at P3-T0):
    ~${budget_preference_usd}/month, alert hint
    {alert_threshold_hint} (or "n/a — no managed services")
  - License: {license}
  - Components ({N}):
    - {Component 1 name} ({primary/supporting}) — rung
      {rung_id}: {rung_name}
      Dimensions: {dimension map}
    - {Component 2 ...}
  - Cross-component:
    - Repo strategy: {repo_strategy}
    - Versioning: {version_strategy}
    - Shared identity / CI / design: {shared.*}
  - Other constraints: {other_constraints}
  - Deferred to INIT: {list of dimensions captured as
    "decide at init"}
  - Deferred to P3-T0 (deploy planning): cloud target ADR,
    IaC tool, Terraform state, managed-service instances,
    OIDC trust, runtime secret store, network defaults,
    monthly budget cap + alerts.

  System diagram (composite):
  ```mermaid
  {final composite flowchart — cloud subgraph dashed,
   labeled "TBD — set at P3-T0"}
  ```

Then ask:

  Does that look right? Anything to fix before I run the budget
  reality check and generate the init prompt?

**Wait for explicit confirmation.** Silent acceptance is not OK
— if no reply, ask again.

## Budget reality check (rough, runs if S7 was answered)

After confirmation, run a rough feasibility check using the
budget preference from S7. This is informational — the
Cost-Rules-compliant cap is set at P3-T0, not here. The point of
this check is to surface gross mismatches early (e.g., "you
picked $50/month but managed Postgres + managed Redis + a Cloud
Run minimum-instance setup alone would be $80/month").

1. For each managed service IMPLIED by the chosen rungs and
   dimensions (cloud compute, managed DB, object storage, secret
   manager, CDN, observability, email, payments, AI inference),
   look up the approximate monthly floor cost live from public
   pricing pages. Do NOT pin prices from training data.
2. Sum the unavoidable floor across ALL components.
3. Compare against `budget_preference_usd`.
4. If the floor exceeds ~60% of the preference, surface the
   tension and offer:
   (a) Raise the preference, with a recommended new number.
   (b) Switch to a scale-to-zero / local-only path for hosted
       components (containerize stateful deps during prototype,
       cut to managed at production cutover — recorded as an
       ADR at P3-T0 if pursued).
5. Capture as `budget_preference_decision` (still a preference;
   the real decision is at P3-T0).

If S7 was skipped (no hosted components, no managed services),
record "n/a — local-only project" and skip this step.

## Pre-flight self-check (mandatory before generating the prompt)

Confirm each item below in chat with a ✓ for each. If ANY item is
unchecked, STOP and complete it before generating.

  Pre-flight before generating your init prompt:
  - [ ] Q1 had a concrete feature loop, not foundation/architecture
        language.
  - [ ] Component set was proposed in plain language and the user
        confirmed (or corrected) it.
  - [ ] Tier (Q0b) was captured.
  - [ ] For every component, the rung ladder was shown and a rung
        (or "between X and Y") was picked.
  - [ ] Every question I asked included 2-3 concrete examples and
        an explicit "you pick — I'll default" option.
  - [ ] Q5 (compliance) walked GDPR / CCPA / HIPAA / PCI / SOC 2 /
        data residency / sector-specific explicitly.
  - [ ] For every component, the dimension walk covered only the
        applicable dimensions, pre-filled from the rung defaults.
        Deferred dimensions are captured as open questions, not
        silently invented.
  - [ ] Cross-component decisions (C1-C3) were asked if the
        project has more than one component.
  - [ ] The composite Mermaid diagram was rendered at every
        flagged checkpoint and confirmed by the user.
  - [ ] The summary block was produced verbatim (slot-filled).
  - [ ] The user confirmed the summary verbatim.
  - [ ] The budget reality check ran (or was explicitly marked
        n/a for local-only projects).

If any box is unchecked, do NOT generate the prompt. Go back,
finish the missed step, then re-run this self-check.

## Generating the prompt

After the Pre-flight passes and the user confirms, output the
customized prompt as a single fenced code block, with ```text
fences, prefixed with:

  COPY THIS — your customized init prompt.

The block contents are the `/ai/templates/INIT_PROMPT.md` "Prompt
to paste to the AI assistant" section, with placeholders
pre-filled from the interview answers and a NOTES block at the
top capturing:

- `feature_loop`
- `tier`
- `components` (with rung + dimension map per component)
- `audience`, `goals`, `non_goals`, `compliance`,
  `cloud_preference` (rough — finalized at P3-T0),
  `budget_preference_usd` (rough — finalized at P3-T0),
  `alert_threshold_hint`, `license`
- `repo_strategy`, `version_strategy`, `shared.*`
- `budget_preference_decision`
- `product_name`, `other_constraints`
- The final composite Mermaid diagram, fenced as ```mermaid```
  (cloud subgraph dashed, labeled "TBD — set at P3-T0").

## After generating the prompt

Ask:

  Want me to run this inline in this session now, or copy it and
  paste into a fresh session for clean context? Fresh session is
  cleaner; inline is faster.

Do not start running it without an answer.

## Hard rules for this interview

- Do NOT scaffold, install dependencies, or create files yet —
  that all happens during INIT.
- Do NOT pin specific dependency versions yet — INIT will look
  those up from canonical sources per the Versioning Rules.
- Do NOT modify any `/ai/*.md` file yet — INIT does that.
- Do NOT skip the live-diagram renders at the checkpoints.
- Do NOT skip the summary + confirmation step.
- Do NOT skip the budget reality check unless the project has no
  hosted components or managed services.
- Do NOT skip the Pre-flight self-check before generating the
  prompt.
- Do NOT silently invent answers for deferred dimensions —
  capture as open questions.
- If the user asks to skip the interview entirely, point them at
  `/ai/templates/INIT_PROMPT.md` directly.
```
