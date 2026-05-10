#!/usr/bin/env bash
# run-phase-codex.sh — run N consecutive tasks autonomously via OpenAI Codex CLI (`codex`).
# Each task: work → handoff → commit → push.
#
# Usage:
#   ./run-phase-codex.sh <num_tasks>                    # commit + push (default)
#   RUN_PHASE_NO_PUSH=1 ./run-phase-codex.sh <num_tasks> # commit, skip push
#
# Prerequisites:
#   - Codex CLI installed: npm install -g @openai/codex
#     (or use the Rust binary distribution from the project README).
#   - Authenticate once: `codex login` (or set OPENAI_API_KEY for headless / CI).
#   - Docs: https://github.com/openai/codex
#
# Optional env vars:
#   - RUN_PHASE_NO_PUSH=1            — commit but skip push.
#   - RUN_PHASE_CODEX_MODEL="..."    — pin a specific model.
#
# IMPORTANT: Codex CLI flag names evolve quickly. The flags below reflect a
# common configuration (full workspace write + auto-approve). Verify the
# current flag set against the Codex README before relying on this script
# in production.
#
# Push behavior follows the Git Rules in /ai/AI_RULES.md: push after every
# successful commit unless explicitly disabled. If a push fails (auth,
# network, non-fast-forward), the script stops — do NOT silently keep
# committing on top of an out-of-sync local branch.
#
# Run from your project root (where /ai/ lives).

set -euo pipefail

# Prefer common user-local install paths.
export PATH="${HOME}/.local/bin:${HOME}/.npm-global/bin:${PATH}"
if ! command -v codex >/dev/null 2>&1; then
  echo "error: 'codex' not found." >&2
  echo "  Install: npm install -g @openai/codex" >&2
  echo "  Docs:    https://github.com/openai/codex" >&2
  exit 127
fi

TASKS=${1:?Usage: $0 <num_tasks>   e.g.  ./run-phase-codex.sh 8}

LOG_DIR="ai/logs/run_codex_$(date +%Y%m%d_%H%M%S)"
mkdir -p "$LOG_DIR"

START_PROMPT="Please read /ai/START_HERE.md and follow it. Then pick up the next task per HANDOFF.md."
END_PROMPT="Please read /ai/templates/CHAT_END_PROMPT.md and follow it."

# Headless automation: full workspace write + auto-approve. Verify these flag
# names against the current Codex CLI README — the CLI is evolving.
CODEX_FLAGS=(
  --sandbox workspace-write
  --ask-for-approval never
)

# Optional: pin model, e.g. RUN_PHASE_CODEX_MODEL="gpt-5-codex"
if [ -n "${RUN_PHASE_CODEX_MODEL:-}" ]; then
  CODEX_FLAGS+=(--model "$RUN_PHASE_CODEX_MODEL")
fi

echo "Starting Codex phase run: $TASKS tasks. Logs -> $LOG_DIR"

for i in $(seq 1 "$TASKS"); do
  printf '\n========== Task %d of %d ==========\n' "$i" "$TASKS"

  echo "[$(date +%H:%M:%S)] Step 1/3: working on next task (codex exec)..."
  codex exec "${CODEX_FLAGS[@]}" "$START_PROMPT" \
    2>&1 | tee "$LOG_DIR/task_${i}_work.log"

  echo "[$(date +%H:%M:%S)] Step 2/3: writing handoff (codex exec resume --last)..."
  codex exec resume --last "${CODEX_FLAGS[@]}" "$END_PROMPT" \
    2>&1 | tee "$LOG_DIR/task_${i}_handoff.log"

  echo "[$(date +%H:%M:%S)] Step 3/3: staging + committing + pushing..."
  if [ -n "$(git status --porcelain)" ]; then
    # Pull a subject line from the handoff log; fall back to generic.
    SUBJECT=$(awk '
      /^[*]*Work completed:[*]*/ {
        sub(/^[*]*Work completed:[*]*[[:space:]]*/, "")
        if (length($0) > 0) { print; exit }
        inheader = 1; next
      }
      inheader && /^[[:space:]]*$/ { next }
      inheader { sub(/^[*-][[:space:]]*/, ""); print; exit }
    ' "$LOG_DIR/task_${i}_handoff.log" 2>/dev/null \
    | sed 's/`//g; s/\*\*//g' \
    | cut -c1-72 || true)
    [ -z "$SUBJECT" ] && SUBJECT="Phase task $i (auto, Codex)"

    git add -A
    git commit -m "$SUBJECT" \
               -m "Automated commit by run-phase-codex.sh. Log: $LOG_DIR/task_${i}_handoff.log"
    echo "[$(date +%H:%M:%S)] 📝 Committed: $SUBJECT"

    if [ "${RUN_PHASE_NO_PUSH:-0}" = "1" ]; then
      echo "[$(date +%H:%M:%S)] ⏭  RUN_PHASE_NO_PUSH=1 set — skipping push."
    else
      echo "[$(date +%H:%M:%S)] ⬆  Pushing to origin..."
      if ! git push; then
        echo
        echo "[$(date +%H:%M:%S)] ❌ Push failed for task $i (commit: $SUBJECT)." >&2
        echo "Stopping phase run so the local branch does not drift from origin." >&2
        echo "Resolve the push (auth / network / non-fast-forward) and re-run." >&2
        echo "Log: $LOG_DIR/task_${i}_handoff.log" >&2
        exit 1
      fi
      echo "[$(date +%H:%M:%S)] ✅ Pushed to origin."
    fi
  else
    echo "[$(date +%H:%M:%S)] ℹ️  No changes after task $i; nothing to commit or push."
  fi

  echo "[$(date +%H:%M:%S)] ✅ Task $i complete."
done

echo
echo "🎉 Codex phase complete: $TASKS tasks done."
echo "Logs: $LOG_DIR"
