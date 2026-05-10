# Developer Notes

> **AI Notice — Do not modify this file.**
> AI assistants must NOT edit, update, change, alter, or delete this file
> unless the developer explicitly asks for changes by name. This file is
> developer-maintained reference material, not part of the project planning
> system. If you think something here is wrong or outdated, flag it in chat
> rather than editing it.

---

## Context limits — how to think about them

AI assistants — whether running in an IDE plugin, a CLI, or a chat interface —
have a finite context window. The `/ai` workflow files are designed to handle
this: you don't have to fight the limits, you just have to respect the
workflow.

### Typical limits

- Modern AI assistants typically have context windows in the 100K–200K token
  range (roughly 75K–150K words of effective working memory).
- Some assistants auto-compact older context as the limit approaches; some
  simply truncate. Behavior varies by tool.
- Most assistants offer some form of manual reset, summary, or resume command.
  Check your tool's documentation.

## How to use the `/ai` workflow with context limits

Treat each task in `/ai/TASKS.md` as a fresh AI session.

1. Open a new AI session (or clear the existing one).
2. Have the AI read `/ai/START_HERE.md` first (which loads the rest of the
   `/ai` files in the documented order).
3. Work on one task at a time.
4. End the session by running the end-of-chat prompt in
   `/ai/templates/CHAT_END_PROMPT.md` — this updates
   `CURRENT_STATE.md`, `TASKS.md`, `HANDOFF.md`, and `DONE_LOG.md`.
5. The next session reads `HANDOFF.md` to pick up where the last left off.

The `/ai` files are the persistent memory across sessions. Auto-compact (if
your tool offers it) is a safety net; the task-bounded workflow is the real
solution.

## Quick reference

| Situation                              | Right move                                      |
| -------------------------------------- | ----------------------------------------------- |
| Finished a task                        | Run CHAT_END_PROMPT, then start a fresh session |
| Mid-task and approaching context limit | Use your tool's compact/summarize feature       |
| Starting a new task tomorrow           | Open fresh session, read `/ai/START_HERE.md`    |
| New major topic / phase shift          | Fresh session                                   |
| Returning to interrupted work          | Resume command or read HANDOFF.md               |
