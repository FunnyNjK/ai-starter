# Deployment

Last Updated: 2026-05-02

## Deployment Status
Default pattern documented; project-specific resource names TBD until
initialization.

---

## Target Environments

- **Local development:** WSL Ubuntu, native processes (`pnpm dev`).
  No Docker for the app itself.
- **Staging:** Azure SWA preview environment (auto-created per PR).
- **Production:** Azure SWA production environment, custom domain.

---

## CI/CD

GitHub Actions, two workflows:

### `.github/workflows/ci.yml`
Triggers: `push`, `pull_request`. Runs:
- pnpm install (with cache)
- lint (ESLint 9 flat config)
- typecheck (tsc --noEmit)
- test (Vitest, --run)
- build (Astro)

Fails the PR if any step fails.

### `.github/workflows/deploy.yml`
Triggers: `push` to `main`. Runs:
- All CI steps (or depends on ci.yml succeeding)
- Authenticates to Azure via OIDC (federated credentials)
- Deploys via `Azure/static-web-apps-deploy@v1` action

PR builds use the SWA preview environment automatically (managed by the
SWA action).

---

## Secrets and Configuration

- Do not commit secrets.
- Local secrets live in `.env.local` (gitignored).
- Azure-side secrets configured via the SWA resource's "Configuration"
  blade.
- GitHub Actions auth uses OIDC federation — no static service principal
  client secrets in repo secrets.

### Required Environment Variables

| Name                       | Where used                | Notes                                  |
| -------------------------- | ------------------------- | -------------------------------------- |
| `POSTMARK_API_TOKEN`       | Azure Function (server)   | From Postmark "Servers" → API tokens.  |
| `POSTMARK_FROM_EMAIL`      | Azure Function (server)   | Verified sender domain in Postmark.    |
| `POSTMARK_TEMPLATE_ID`     | Azure Function (server)   | Postmark template numeric ID.          |
| `TURNSTILE_SECRET_KEY`     | Azure Function (server)   | Cloudflare Turnstile dashboard.        |
| `PUBLIC_TURNSTILE_SITE_KEY`| Frontend build            | `PUBLIC_` prefix exposes it to client. |
| `CONTACT_RATE_LIMIT_MAX`   | Azure Function (server)   | Default: 5 (requests per window).      |
| `CONTACT_RATE_LIMIT_WINDOW_MS` | Azure Function (server) | Default: 600000 (10 min).            |

---

## Deployment Commands (local dry-run)

These run inside WSL, never in Docker:

```bash
pnpm install
pnpm lint
pnpm typecheck
pnpm test
pnpm build
swa start dist --api-location api      # local SWA emulator (optional)
```

---

## Initial Azure Setup (one-time per project)

Done outside the AI workflow, but documented here for completeness:

1. Create the SWA resource in Azure portal.
2. Create an Azure AD app registration for the GitHub deploy.
3. Configure federated credential on the app registration:
   - Issuer: `https://token.actions.githubusercontent.com`
   - Subject: `repo:<owner>/<repo>:ref:refs/heads/main`
   - Audience: `api://AzureADTokenExchange`
4. Grant the app registration "Static Web App Contributor" on the SWA resource.
5. Add repo variables in GitHub:
   - `AZURE_CLIENT_ID`
   - `AZURE_TENANT_ID`
   - `AZURE_SUBSCRIPTION_ID`
6. Configure runtime environment variables in the SWA resource.

---

## Rollback Plan

- SWA deployments are immutable per-commit. Roll back by reverting the
  offending commit on `main` and letting CI/CD redeploy.
- For emergency manual rollback, use the SWA resource's "Environments"
  blade in Azure portal to swap to a previous deployment.

---

## Operational Notes

- SWA free tier: 100 GB bandwidth/month, 0.5 GB storage, 2 staging envs.
  Sufficient for marketing sites at low traffic.
- Custom domain requires CNAME to the `*.azurestaticapps.net` host plus a
  TXT record for verification. SSL is automatic.
- Function logs visible in the SWA resource's "Functions" blade or via
  Application Insights if enabled.
