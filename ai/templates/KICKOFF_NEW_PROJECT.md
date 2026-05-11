# Kickoff: New Project

You just downloaded `ai-starter` and want to start something new. This is
the friendliest place to begin. Paste the prompt below into your AI tool
(Claude Code, Codex, Cursor, Copilot, Gemini — any of them). The AI will
interview you one question at a time, with examples and sensible
defaults, then generate a customized initialization prompt you can run
to set the project up properly.

If you already know exactly what you want to build and what stack to
use, you can skip this and go straight to `/ai/templates/INIT_PROMPT.md`.

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

- Read `/ai/START_HERE.md`, `/ai/AI_RULES.md`, and
  `/ai/templates/INIT_PROMPT.md` first so you know what the eventual
  init step will need.
- **Ask one question at a time.** Never dump a wall of questions. Wait
  for each answer before moving on.
- For each question, give 2-3 concrete example answers and explicitly
  offer a "I don't know — pick a sensible default" option. Default
  sensibly when they choose that option, and tell them what you chose.
- Be friendly and concise. Avoid jargon when a plain word works.
- If their answer is clearly incomplete or contradictory, gently push
  back with one follow-up question.
- After all questions are answered, summarize the answers in a tight
  bullet list and ask them to confirm before you generate the prompt.
- After confirmation, output the customized init prompt as a single
  fenced code block clearly marked "COPY THIS — your customized init
  prompt." Then ask them whether to run it inline now, or paste it into
  a fresh session for clean context.

## Questions to ask, in this order

1. **What does the app DO for users?** A concrete user-facing feature
   loop, in plain English. The goal is to know what end users *do* with
   the product, not how it's built.

   Good answers (concrete user behavior):
     - "Users sign up, link their bank accounts via Plaid, see all
       transactions in one place, categorize them, set monthly budgets,
       and get alerts when they go over."
     - "Engineering team leads create projects, add tasks, assign them
       to teammates, set due dates, and move them across a kanban
       board."
     - "Visitors read marketing pages about my consulting practice,
       fill out a contact form, and I get an email."
     - "Customer-support agents search orders by email / phone /
       order-number, view order history, issue refunds, and add notes
       to a customer record."

   **REJECT these answer shapes** — keep asking until the user gives a
   real feature loop:

   - **Foundation / template / starter / scaffold / base / skeleton /
     boilerplate** language without a concrete user-facing product.
     Example triggers: "a foundation for B2C SaaS apps", "a secure
     starter template I can reuse", "a scaffold for future products".

     Follow-up to the user:

     > "That sounds like infrastructure work, not a product. This
     > starter plans infrastructure as *supporting work for a real
     > product*, not as the product itself. What does the app actually
     > *do* for an end user — what feature do they use?"

     Loop until they describe a real feature loop. **If they insist
     they only want a reusable foundation,** point out that
     `ai-starter` itself already plays that role — they can fork it for
     each new project — and ask one more time what *this specific
     project's product* is. If they still can't describe a product,
     stop the interview, do not generate an init prompt, and report
     back to the user that the project shape is unclear.

   - **Architecture-only listings** (lists of surfaces, services, or
     technologies) without user behavior. Example triggers: "a SaaS
     with a marketing site, web app, API, and worker", "an Azure app
     using Clerk, Plaid, Postmark, and Stripe", "a multi-tenant React +
     Next.js + Postgres stack".

     Follow-up:

     > "You've told me about the surfaces and services, but what does a
     > user *do* with this app? Pretend I'm a brand-new user who just
     > signed up — what's the very first thing I do that gives me value,
     > and what do I keep coming back to do?"

     Loop until they describe a real feature loop. The architecture
     they listed becomes Phase-1 supporting infrastructure under Phase-2
     feature tasks, NOT the product itself.

   - **"I don't know yet"** — ask about the rough domain (consumer
     SaaS / internal tool / marketing site / API / mobile / data
     pipeline) AND the core problem they're solving for users, then
     try the question again.

   **The interview cannot proceed past Question 1 without a concrete
   feature-loop answer.** Every later question (audience, goals,
   non-goals, compliance, cloud, budget, license, stack) assumes you
   already know what users do.

2. **Who is it for?** End users / internal team / public web visitors / etc.
   Examples:
     - "Engineering team leads at small startups."
     - "Just me and 1-2 collaborators."
     - "Anyone on the public web."
   "I don't know" → default to "general public web users" and tell them.

3. **What does success look like?** 1-3 concrete goals.
   Examples:
     - "Sub-2-second page loads; <$200/month hosting cost at 100 users."
     - "Cuts the support team's manual lookup time in half."
   "I don't know" → suggest one based on the project shape and ask if
   it sounds right.

4. **What's explicitly NOT in scope?** 2-5 non-goals.
   Examples:
     - "No mobile app. No real-time features. No public API in v1."
   "I don't know" → suggest 2-3 plausible non-goals and ask them to
   confirm or edit. This is one of the most useful answers; don't skip.

5. **Any compliance, privacy, or regulatory needs?** Examples: GDPR /
   CCPA (handling EU or California users), HIPAA (health data), PCI
   (payment cards), SOC 2 (enterprise sales), data residency, etc.
   "None I know of" is a perfectly valid answer — note it explicitly.

6. **Cloud preference?** AWS, Azure, or Google Cloud (the starter
   defaults).
   - Pick AWS if they have prior AWS experience or need the broadest
     service catalog.
   - Pick Azure if they're in a Microsoft shop or already have an
     Azure account.
   - Pick GCP if they want scale-to-zero serverless cheap and easy
     (Cloud Run + Cloud SQL is hard to beat for small SaaS).
   "You pick" → make a recommendation based on the project shape and
   their stated goals.

7. **Monthly budget cap (USD)?** What's the most you want to pay
   per month before getting alerted?
   Defaults to suggest:
     - Prototype / personal: $50/month
     - Early-stage SaaS: $200-500/month
     - Internal team tool: $100-200/month
   "You pick" → default to $50/month and tell them.

8. **License?** This affects how others can use the code.
   - **MIT** (default) — anyone can use however they want, just keep
     the copyright notice.
   - **Apache 2.0** — like MIT plus an explicit patent grant.
   - **The Unlicense / CC0** — public-domain-style, no attribution.
   - **BSL / proprietary** — closed-source.
   "You pick" → MIT.

9. **Stack preference?** Do they have a strong preference for a
   language, framework, or specific libraries? Or should you choose?
   - "You pick" → make a recommendation based on the project shape
     (e.g., Next.js + Postgres for a typical SaaS, Astro for a static
     marketing site, FastAPI + Postgres for an API). Verify versions
     from canonical sources at INIT time, not now.
   - If they specify, ask if there are specific libraries / services
     they MUST use (e.g., a particular auth provider, payment
     processor, design system).

10. **Anything else?** Brand assets / colors / fonts already chosen?
    Existing integration partners (Stripe, Postmark, etc.)? An old
    project this is a successor to? Strong constraints (must run
    offline, must work on iOS Safari, must support 50K concurrent
    users)?
    "Nothing else" is fine.

## After all answers

Summarize like this:

  Got it. Here's what I understood:
  - Building: {one-sentence}
  - For: {audience}
  - Goals: {1-3}
  - Non-goals: {2-5}
  - Compliance: {list or "none"}
  - Cloud: {AWS / Azure / GCP}
  - Budget: ${N}/month with alerts at 50% / 80% / 100%
  - License: {MIT / ...}
  - Stack: {summary or "you'll pick at INIT verifying versions"}
  - Other constraints: {bullets or "none"}

  Does that look right? Anything to fix before I generate the init
  prompt?

After confirmation, generate the customized prompt as a fenced code
block (use ```text fences) prefixed with "COPY THIS — your customized
init prompt." The block is the contents of
`/ai/templates/INIT_PROMPT.md` "Prompt to paste to the AI assistant"
section, with the {placeholders} pre-filled from the interview answers
and a NOTES block at the top capturing the user's decisions for
posterity.

Finally, ask:

  Want me to run this inline in this session now, or would you rather
  copy it and paste into a fresh session for clean context? Fresh
  session is cleaner; inline is faster.

## Hard rules for this interview

- Do NOT scaffold, install dependencies, or create files yet — that all
  happens during INIT.
- Do NOT pin specific dependency versions yet — INIT will look those up
  from canonical sources per the Versioning Rules.
- Do NOT modify any /ai/*.md file yet — INIT does that.
- Do NOT skip the summary + confirmation step.
- If the user asks to skip the interview entirely, point them at
  /ai/templates/INIT_PROMPT.md directly.
```
