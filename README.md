# AI Project Starter

A reusable AI workflow and project memory system for software development. Drop
the `/ai` folder into any project to give AI assistants a consistent way to
track project state, decisions, tasks, and handoffs across sessions.

## Repository status

This repository is the reusable starter/template itself. It is not an
initialized application repo: the project name, purpose, content, tech stack,
and tooling are intentionally left as TBD until the `/ai` folder is copied
into a concrete project and initialized with an application description.

## How to use

1. Copy the `/ai` folder into the root of any new project repo.
2. In your AI assistant of choice, start a session with:

   ```text
   Read /ai/START_HERE.md and initialize this project.

   Application description:
   <plain-English description of what you're building>
   ```

3. The assistant will read the supporting files, ask clarifying questions only
   when something would materially change the architecture, and then update
   the project-specific TBD sections.

## What's included

- A consistent entry point (`/ai/START_HERE.md`) for AI sessions.
- Planning files for project identity, current state, tasks, decisions,
  architecture, testing, deployment, and handoffs.
- Templates for new tasks, ADRs, and chat start/end rituals.
- Rules that keep AI sessions scoped, traceable, and low-drift across many
  conversations.

## What's NOT included

- Any opinion about the language, framework, package manager, OS, hosting
  provider, CI/CD system, database, or third-party services your project uses.
- Application code, dependencies, or build configuration.
- Project-specific decisions — those are recorded as ADRs after initialization.

## Single rule

Tell your AI assistant to read **`/ai/START_HERE.md`** first. That's the entry point.

## Refreshing an older project

If you have an older project that was started from a previous version of this
starter, point an AI assistant at **`/ai/templates/REFRESH_PROMPT.md`**. It's a
one-shot housekeeping pass that compacts long-running planning files, archives
completed tasks, ensures the rule set is current, and verifies that the local
branch matches the remote.
