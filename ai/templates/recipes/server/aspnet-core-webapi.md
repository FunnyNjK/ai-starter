# Recipe: ASP.NET Core Web API (C#)

Last Updated: 2026-05-22
Applies to: Server / cloud platform + C# language.

## What this template gives you

An API-only ASP.NET Core service: Minimal API endpoints or
Controllers, Entity Framework Core against Postgres, JWT bearer
auth via `Microsoft.AspNetCore.Authentication.JwtBearer`,
structured logging via Serilog, xUnit + WebApplicationFactory for
integration tests. No Razor views (use the ASP.NET Core MVC
recipe if you want server-rendered pages too).

## Design philosophy

- **API-first, not full-stack.** This is a backend for one or more
  client projects (SPA, mobile, CLI). No views, no static assets
  ship from this project.
- **EF Core owns the schema.** Migrations live in
  `src/Data/Migrations/`. Frontend / client projects in the same
  solution don't apply migrations.
- **JWT bearer auth.** Token issuance + validation via
  `Microsoft.AspNetCore.Authentication.JwtBearer`. Signing key
  via User Secrets locally, runtime secret store in production.
- **Minimal API by default; Controllers if the project grows.**
  Endpoint groups (`MapGroup`) keep route organization clean.
  Switch to `[ApiController]` controllers when endpoint count
  outgrows minimal-API style.
- **OpenAPI / Swagger always on in dev, configurable in prod.**
  Spec generated via `Microsoft.AspNetCore.OpenApi` (built into
  .NET 9) or Swashbuckle (.NET 8 and earlier).

## Bundled stack (verified versions at init time)

| Component | Choice | Canonical source |
|-----------|--------|------------------|
| Runtime | .NET `<X.Y>` LTS | https://dotnet.microsoft.com/en-us/download/dotnet |
| Framework | ASP.NET Core `<X.Y>` (bundled) | https://learn.microsoft.com/en-us/aspnet/core/release-notes |
| Language | C# `<X.Y>` (bundled) | https://learn.microsoft.com/en-us/dotnet/csharp/whats-new |
| ORM | Entity Framework Core `<X.Y.Z>` | https://www.nuget.org/packages/Microsoft.EntityFrameworkCore |
| DB driver | Npgsql.EntityFrameworkCore.PostgreSQL `<X.Y.Z>` | https://www.nuget.org/packages/Npgsql.EntityFrameworkCore.PostgreSQL |
| Database (local) | PostgreSQL `<X.Y>` (Docker image) | https://hub.docker.com/_/postgres |
| Auth | Microsoft.AspNetCore.Authentication.JwtBearer `<X.Y.Z>` | https://www.nuget.org/packages/Microsoft.AspNetCore.Authentication.JwtBearer |
| Password hashing | Microsoft.AspNetCore.Identity built-in (PBKDF2) OR Konscious.Security.Cryptography.Argon2 `<X.Y.Z>` for argon2id | https://www.nuget.org/packages/Konscious.Security.Cryptography.Argon2 |
| OpenAPI | Microsoft.AspNetCore.OpenApi (.NET 9+) OR Swashbuckle.AspNetCore `<X.Y.Z>` (earlier) | https://www.nuget.org/packages/Swashbuckle.AspNetCore |
| Logging | Serilog.AspNetCore `<X.Y.Z>` | https://www.nuget.org/packages/Serilog.AspNetCore |
| Test framework | xUnit `<X.Y.Z>` + Microsoft.AspNetCore.Mvc.Testing | https://www.nuget.org/packages/Microsoft.AspNetCore.Mvc.Testing |
| Validation | FluentValidation.AspNetCore `<X.Y.Z>` | https://www.nuget.org/packages/FluentValidation.AspNetCore |

Pin verified versions at init.

## Folder layout

```
projects/<name>/
├── src/
│   ├── Api/                # ASP.NET Core Web API project
│   │   ├── Endpoints/      # Minimal API endpoint groups
│   │   ├── Auth/           # JWT helpers, token issuance
│   │   ├── Program.cs
│   │   ├── appsettings.json
│   │   ├── appsettings.Development.json
│   │   └── Api.csproj
│   └── Data/               # EF Core context + migrations
│       ├── AppDbContext.cs
│       ├── Models/
│       ├── Migrations/
│       └── Data.csproj
├── tests/
│   ├── Api.Tests/          # xUnit unit + integration tests
│   └── Api.IntegrationTests/
├── docker-compose.yml      # local Postgres
└── README.md
```

## Local dev story (P1-T1 scaffold target)

1. `docker compose up -d` — Postgres comes up.
2. `dotnet restore`
3. `dotnet user-secrets set "ConnectionStrings:Default" "..." --project src/Api`
4. `dotnet user-secrets set "Jwt:SigningKey" "$(openssl rand -base64 32)" --project src/Api`
5. `dotnet ef database update --project src/Data`
6. `dotnet run --project src/Api` — serves on `http://localhost:5000`;
   OpenAPI UI at `/swagger`.
7. `dotnet format && dotnet build && dotnet test` — all exit 0.

## Free-tier ceilings to record at init

- None by default for this stack.

## Production handoff (deferred to P3-T0)

Local Postgres → managed Postgres at P3-T0. JWT signing key →
runtime secret store. Production OpenAPI exposure (often
restricted) is documented in `/ai/DEPLOYMENT.md` at P3-T0.

Note that ASP.NET Identity's default data-protection key ring
needs persistence in production (Azure Key Vault / AWS KMS / a
shared filesystem). The ASP.NET Core MVC recipe covers this;
since this Web API recipe doesn't use cookie auth, key-ring
persistence is only relevant if you add antiforgery tokens or
session state later.

## When to pick this

- You need a separate API serving multiple clients (SPA + mobile
  + partner integrations).
- Team is .NET-fluent.
- Minimal API's terse syntax fits the endpoint count.

## When NOT to pick this

- You also need server-rendered Razor views → pick the
  `aspnet-core-mvc` recipe (it can host API endpoints alongside
  views).
- Team is TypeScript-first → pick NestJS.
- You want GraphQL specifically — ASP.NET Core supports HotChocolate
  but the default recipe is REST. Pick Custom and add HotChocolate.
