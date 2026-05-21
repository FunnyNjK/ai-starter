# Recipe: Astro Static (TypeScript)

Last Updated: 2026-05-21
Applies to: Web platform + TypeScript language.

## What this template gives you

A static-first website built with Astro: marketing pages, docs,
blog, portfolios. Zero JS by default on rendered pages (Astro
ships HTML); islands of interactivity only where you opt in.

## Design philosophy

- **Static-first.** Pages render to HTML at build time.
  Interactivity requires explicit `client:*` directives on islands.
- **No database, no auth.** This template assumes the site is
  read-only for visitors. If you need user state (sign in, save
  preferences, etc.), you've outgrown Astro Static — pick the
  Next.js Web App recipe instead.
- **Forms via Astro server endpoints OR a separate API.** Two
  paths when a contact form is needed:
  1. **Stay in this project**: enable an Astro adapter
     (Cloudflare, Vercel, Node) and write a form handler at
     `src/pages/api/contact.ts`. Single deployable, slightly more
     complex.
  2. **Add a separate API project**: use `add-project` mode to
     scaffold a NestJS or FastAPI project for the form handler.
     Two deployables, cleaner separation, mandatory if you need
     >1 form handler or more sophisticated server-side logic.
  3. **External form handler**: use Formspree (50/month free) or
     similar — the simplest path for "occasional contact form."
- **Content collections.** Markdown / MDX content lives in
  `src/content/` with TypeScript schemas for frontmatter
  validation.

## Bundled stack (verified versions at init time)

| Component | Choice | Canonical source |
|-----------|--------|------------------|
| Framework | Astro `<X.Y.Z>` | https://www.npmjs.com/package/astro |
| Language | TypeScript `<X.Y.Z>` | https://www.npmjs.com/package/typescript |
| Runtime (build) | Node.js `<X.Y.Z>` LTS | https://nodejs.org/en/about/previous-releases |
| Package manager | pnpm `<X.Y.Z>` | https://www.npmjs.com/package/pnpm |
| Styling | Tailwind CSS `<X.Y.Z>` (via @astrojs/tailwind) | https://www.npmjs.com/package/tailwindcss |
| Content | MDX `<X.Y.Z>` (via @astrojs/mdx) | https://www.npmjs.com/package/@astrojs/mdx |
| Form handler (default) | Formspree free tier | https://formspree.io/ |
| Test runner | Vitest `<X.Y.Z>` | https://www.npmjs.com/package/vitest |
| Lint | ESLint `<X.Y.Z>` | https://www.npmjs.com/package/eslint |
| Format | Prettier `<X.Y.Z>` + prettier-plugin-astro | https://www.npmjs.com/package/prettier |

Pin verified versions at init.

## Folder layout

```
projects/<name>/
├── src/
│   ├── pages/              # Astro routes
│   ├── components/         # .astro components + island components
│   ├── content/            # markdown / MDX content collections
│   │   └── config.ts       # collection schemas
│   ├── layouts/
│   └── styles/
├── public/                 # static assets (favicon, robots.txt, etc.)
├── tests/
├── astro.config.mjs
├── tailwind.config.ts
├── tsconfig.json
├── package.json
├── pnpm-lock.yaml
└── README.md
```

## Local dev story (P1-T1 scaffold target)

1. `pnpm install`
2. `pnpm dev` — Astro serves on `http://localhost:4321`.
3. `pnpm lint && pnpm test && pnpm build` — all exit 0.
4. `pnpm preview` — serve the built `dist/` locally to verify.

No database, no docker-compose. The only local-dev runtime is
Node.

## Free-tier ceilings to record at init

- Formspree free tier (if used for contact form): 50
  submissions/month. Captured in `/ai/BUDGET.md` "Free-tier and
  tier choices" with the escalation path ("upgrade to paid
  Formspree" or "swap to Web3Forms / a serverless function").

## Production handoff (deferred to P3-T0)

Static sites deploy to ANY static host: Cloudflare Pages, Netlify,
Vercel, GitHub Pages, S3+CloudFront, Azure Static Web Apps. The
Infrastructure & Hosting Hard rule default (AWS / Azure / Google
Cloud) is **typically overridden** for static sites — Cloudflare
Pages / GitHub Pages don't have AWS/Azure/GCP equivalents at the
free-tier price point. Override is recorded as a P3-T0 ADR.

## When to pick this

- Marketing pages, docs, blog, portfolio.
- Content updates by editing markdown, not by hitting "save" in
  a CMS.
- You want fast page loads with minimal JS.

## When NOT to pick this

- You need user accounts / sign-in / per-user data → pick
  Next.js Web App.
- You need >1 form handler or sophisticated server logic — add
  a separate API project via add-project mode.
- You need a CMS where non-coders edit content — pick a
  headless CMS recipe (not in v1.2.0; use Custom).
