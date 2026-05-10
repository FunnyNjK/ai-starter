# Changelog

Starter Version: 0.2.0
Last Updated: 2026-05-10

This changelog tracks the `ai-starter` template itself. Copied application
projects should maintain their own project changelog or release notes after
initialization.

## 0.2.0 - 2026-05-10

- Removed all opinionated defaults (tech stack, OS, hosting provider, CI
  system, third-party services, package manager). The starter is now stack-
  and platform-agnostic.
- Generalized planning files, templates, and prompts to apply to any
  software development project.
- Replaced pre-populated stack-specific ADRs with a single ADR template;
  project-specific ADRs are added during initialization.

## 0.1.0 - 2026-05-04

- Documented the starter/template status in `README.md`.
- Added root ignore rules for generated `ai/logs/` phase-run output.
- Added the first starter changelog/version marker.
- Added a bootstrap checklist to the project initialization prompt.
- Changed startup context loading to a Fast Context core plus Conditional
  Context docs.
