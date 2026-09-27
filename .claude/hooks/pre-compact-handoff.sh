#!/usr/bin/env bash
# pre-compact-handoff.sh — intercept context compaction; steer the session to the handoff skill.
#
# Registered as a PreCompact hook in .claude/settings.json, under both the "auto" and the
# "manual" matchers. A hook runs a shell command — it CANNOT invoke a skill or stop the
# session; only the model can. So this script's job is narrow: stop silent auto-compaction
# and surface a loud, actionable reminder to hand off instead, as .claude/CLAUDE.md
# Section 2.5 requires. Auto-compaction is also switched off in settings.json
# (autoCompactEnabled: false); this hook is the backstop if it is ever switched back on.
#
#   $1 = auto    → auto-compaction fired: BLOCK it (exit 2) and remind. Never compact silently.
#   $1 = manual  → Sam ran /compact deliberately: WARN only (exit 0); do not block a choice.
#                  Claude Code sends a hook's stderr on exit 0 to its debug log only, so this
#                  branch lets the compaction through quietly (checked against the hooks
#                  reference, 27/09/2026).
#
# With no argument, the mode is read from the payload's "trigger" field on stdin (the same
# value the matcher filters on), and defaults to auto — the blocking, safer branch.
#
# Usage (Claude Code runs it; to test by hand):
#   bash .claude/hooks/pre-compact-handoff.sh auto   </dev/null; echo "exit=$?"   # exit=2
#   bash .claude/hooks/pre-compact-handoff.sh manual </dev/null; echo "exit=$?"   # exit=0
#
# stderr = the reminder (shown on a block). Exit codes: 0 = allow  2 = block compaction.
set -uo pipefail

mode="${1:-}"
if [[ -z "${mode}" && ! -t 0 ]] && command -v jq >/dev/null 2>&1; then
  mode=$(jq -r '.trigger // empty' 2>/dev/null || true)
fi
[[ "${mode}" == "manual" ]] || mode="auto"

remind() {
  cat >&2 <<'MSG'
⛔ Compaction intercepted — do NOT compact this session.

House rule (.claude/CLAUDE.md Section 2.5): replace compaction with a handoff.
  1. Invoke the `handoff` skill → write handoffs/HANDOFF-<DESCRIPTOR>-DD-MM-YYYY.md
  2. Stop the turn and print the handoff path for Sam.
  3. Sam runs /clear and resumes from the handoff file in a fresh context window.
MSG
}

remind

if [[ "${mode}" == "manual" ]]; then
  printf '\n(Manual /compact allowed — but /handoff gives a cleaner cross-session boundary.)\n' >&2
  exit 0
fi

# Auto-compaction: block so nothing is silently summarised.
exit 2
