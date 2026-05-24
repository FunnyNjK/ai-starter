# Workspace Recipe: .NET Solution (.sln)

Last Updated: 2026-05-22
Applies to: solutions with two or more .NET projects under
`projects/` that benefit from a shared `.sln` file at solution
root.

## When to wire this up

Add a `.sln` file at solution root when ANY of the following is
true:

- Two or more .NET projects need to **share a class library**
  (e.g., `Common` referenced by `Api` and `Web`).
- You want **one `dotnet build`** / `dotnet test` at solution
  root to operate on all projects.
- You want Visual Studio / Rider to open the whole solution at
  once.

Skip if your only .NET project is fully isolated AND you'd
rather operate on its `.csproj` directly. Single-project
solutions can use a `.sln` too (Visual Studio creates one by
default), but it's optional.

## Naming note

The kit's "solution" (the repo) and .NET's "solution" (`.sln`
file) share the name but are different concepts. The `.sln`
file at the repo root represents the .NET-side view of the
solution. Other-language projects in the same kit-solution
(e.g., a TS web project) are NOT in the `.sln`.

## What to create

At the **solution root**:

### `<solution-name>.sln`

Don't write this by hand. Use the .NET CLI:

```bash
dotnet new sln --name <solution-name>

# Add each .NET project to the solution
dotnet sln add projects/<project-1>/src/<project-1>.csproj
dotnet sln add projects/<project-1>/tests/<project-1>.Tests.csproj
dotnet sln add projects/<project-2>/src/<project-2>.csproj
# ... etc per project
```

This creates a `.sln` that references each `.csproj`. The `.sln`
is committed; running `dotnet build` at solution root builds
all referenced projects.

### Optional: `Directory.Build.props` at solution root

For settings that should apply to ALL .NET projects in the
solution (target framework, language version, common analyzers):

```xml
<Project>
  <PropertyGroup>
    <TargetFramework>net<X.Y></TargetFramework>
    <LangVersion>latest</LangVersion>
    <Nullable>enable</Nullable>
    <ImplicitUsings>enable</ImplicitUsings>
    <TreatWarningsAsErrors>true</TreatWarningsAsErrors>
  </PropertyGroup>
</Project>
```

Per-project `.csproj` files inherit from this; they only
override settings that differ.

## Sharing code across projects

The .NET way: create a class library project and reference it
from consumers.

1. Create the library: `dotnet new classlib --output projects/common/src --name Common`
2. Add to solution: `dotnet sln add projects/common/src/Common.csproj`
3. Reference from a consumer: `dotnet add projects/<api>/src/Api.csproj reference projects/common/src/Common.csproj`

The consumer's `.csproj` gains a `<ProjectReference>` to the
library. `dotnet build` resolves and builds in topological
order.

## Common pitfalls

- **Don't put `.sln` inside a project directory.** It lives at
  the repo root; all `.csproj` paths in the `.sln` are relative
  to that root.
- **NuGet cache lives globally**, not per-solution. If you need
  per-solution package cache isolation (CI), set
  `NUGET_PACKAGES=$PWD/.nuget-cache` in CI env.
- **`Directory.Build.props` is auto-discovered upward** from
  each `.csproj`. Don't put one inside a project unless you
  intend it to override.
- **`global.json` pins the .NET SDK version** for the whole
  repo. Commit it at solution root so everyone (and CI) uses
  the same SDK.

## What this DOESN'T solve

- Cross-language projects (.NET + TS in the same kit-solution):
  the `.sln` only sees .NET projects; the TS projects need
  their own workspace setup (see pnpm-workspace recipe).
- Non-Microsoft IDEs: VS Code's C# extension and Rider both
  understand `.sln`, but other editors may need a workspace
  file or `.csproj` opened directly.

## When the kit suggests this

`ADD_PROJECT_PROMPT.md` will queue a Phase-1 task pointing at
this recipe when adding a second (or later) .NET project to a
solution that doesn't already have a `.sln` file. The recipe
applies whenever multiple `.csproj` files exist under
`projects/`.
