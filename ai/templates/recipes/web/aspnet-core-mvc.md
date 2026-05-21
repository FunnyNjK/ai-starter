# Recipe: ASP.NET Core MVC (C#)

Last Updated: 2026-05-21
Applies to: Web platform + C# language.

## What this template gives you

A single-deployable, server-rendered web app on ASP.NET Core MVC
with Razor views, Entity Framework Core against Postgres, and
ASP.NET Identity for auth. The default Microsoft shop's web
project.

## Design philosophy

- **Razor views, server-rendered.** No SPA front-end ships by
  default. If you need richer interactivity later, add Blazor
  components inside this project (`@page` directive) or add a
  separate SPA project via add-project mode.
- **EF Core owns the schema.** Migrations live in `Data/Migrations/`.
  If you add a separate API project later, EF Core remains the
  schema owner unless explicitly migrated.
- **ASP.NET Identity for auth.** Cookie-based by default; no JWT
  unless you add a Web API project that needs token auth.
- **Configuration via `appsettings.json` + `IConfiguration`.**
  Real secrets via User Secrets locally, secret-store at deploy
  (deferred to P3-T0).

## Bundled stack (verified versions at init time)

| Component | Choice | Canonical source |
|-----------|--------|------------------|
| Runtime | .NET `<X.Y>` LTS | https://dotnet.microsoft.com/en-us/download/dotnet |
| Framework | ASP.NET Core MVC `<X.Y>` (bundled with runtime) | https://learn.microsoft.com/en-us/aspnet/core/release-notes |
| Language | C# `<X.Y>` (bundled with runtime) | https://learn.microsoft.com/en-us/dotnet/csharp/whats-new |
| ORM | Entity Framework Core `<X.Y.Z>` | https://www.nuget.org/packages/Microsoft.EntityFrameworkCore |
| DB driver | Npgsql.EntityFrameworkCore.PostgreSQL `<X.Y.Z>` | https://www.nuget.org/packages/Npgsql.EntityFrameworkCore.PostgreSQL |
| Database (local) | PostgreSQL `<X.Y>` (Docker image) | https://hub.docker.com/_/postgres |
| Auth | ASP.NET Identity `<X.Y.Z>` (bundled) | https://learn.microsoft.com/en-us/aspnet/core/security/authentication/identity |
| Test framework | xUnit `<X.Y.Z>` + FluentAssertions `<X.Y.Z>` | https://www.nuget.org/packages/xunit |
| Logging | Serilog `<X.Y.Z>` (structured logging) | https://www.nuget.org/packages/Serilog.AspNetCore |
| Lint / format | dotnet format (built-in) | https://learn.microsoft.com/en-us/dotnet/core/tools/dotnet-format |
| Package manager | NuGet (built-in) + dotnet CLI | https://learn.microsoft.com/en-us/nuget/ |

Pin verified versions at init.

## Folder layout

```
projects/<name>/
├── src/
│   ├── Web/                # ASP.NET Core MVC project
│   │   ├── Controllers/
│   │   ├── Views/          # Razor views
│   │   ├── Models/
│   │   ├── wwwroot/        # static assets
│   │   ├── Program.cs
│   │   └── Web.csproj
│   └── Data/               # EF Core context + migrations
│       ├── ApplicationDbContext.cs
│       ├── Migrations/
│       └── Data.csproj
├── tests/
│   └── Web.Tests/          # xUnit tests
├── docker-compose.yml      # local Postgres
├── appsettings.json
├── appsettings.Development.json
├── <Solution>.sln          # .NET solution file (per-project)
└── README.md
```

Note: the `.sln` here is a .NET solution file (different from the
ai-starter "solution" concept — this `.sln` is scoped to this one
project).

## Local dev story (P1-T1 scaffold target)

1. `docker compose up -d` — Postgres comes up.
2. `dotnet restore` — deps restored.
3. `dotnet user-secrets set "ConnectionStrings:Default" "..."` —
   local secrets.
4. `dotnet ef database update --project src/Data` — schema applied.
5. `dotnet run --project src/Web` — serves on `http://localhost:5000`.
6. `dotnet format && dotnet build && dotnet test` — all green.

## Free-tier ceilings to record at init

- None by default for this stack. If you add Resend, SendGrid, or
  Postmark for email later, capture their free-tier ceilings then.

## Production handoff (deferred to P3-T0)

Local Postgres → managed Postgres at P3-T0 (RDS / Cloud SQL /
Azure Database for PostgreSQL — whichever cloud is chosen).

ASP.NET Identity cookies require a data-protection key ring in
production. The default in-memory ring works for local dev but
must be persisted in production (Azure Key Vault / AWS KMS / etc.)
— that's a P3-T0 ADR.

## When to pick this

- You're a Microsoft shop and `dotnet new` is muscle memory.
- Server-rendered Razor views fit the app's interaction style.
- EF Core's first-class migrations are a feature, not a nuisance.

## When NOT to pick this

- You want a rich client-side experience by default. Consider
  Blazor Server / Blazor WebAssembly (separate recipe, not in
  v1.2.0; pick Custom and use the rung defaults).
- You don't already use C# / .NET — use a TypeScript or Python
  template instead.
