#!/usr/bin/env bash
# context-threshold-handoff.sh — warn the session before the context window runs out.
#
# Registered as a UserPromptSubmit hook in .claude/settings.json.
#
# A hook cannot invoke a skill or stop a turn, so this script measures and reminds while
# the session-continuity rule in .claude/CLAUDE.md Section 2.5 carries the behaviour. The
# PreCompact hook (pre-compact-handoff.sh) makes the same split, later: PreCompact alone is
# too late — by the time compaction fires the window is already spent, and a handoff written
# under that pressure is the worst one of the session.
#
#   >=50%  advise  — once per session; steer toward a stopping point.
#   >=75%  insist  — every prompt; write the handoff now.
#
# Usage (Claude Code runs it; to test by hand, pipe a payload in):
#   printf '{"session_id":"t","transcript_path":"/path/to/t.jsonl"}' \
#     | CLAUDE_CONTEXT_WINDOW=200000 bash .claude/hooks/context-threshold-handoff.sh
#
# Environment overrides:
#   CLAUDE_CONTEXT_WINDOW       window size in tokens (default 1000000)
#   CLAUDE_CONTEXT_ADVISE_PCT   advise threshold, percent (default 50)
#   CLAUDE_CONTEXT_INSIST_PCT   insist threshold, percent (default 75)
#
# stdin  = the UserPromptSubmit JSON payload (session_id, transcript_path, ...).
# stdout = added to the model's context (on exit 0).
# Always exits 0: a miscounted token must never block Sam's prompt, and exit 2 on this
# event would erase the prompt he just typed.
set -uo pipefail

# Nothing in the transcript reports the window size, so it is a constant here. The default
# assumes a 1M-token window. On a 200k window set CLAUDE_CONTEXT_WINDOW=200000 — otherwise
# usage can never pass 20% of the assumed size and neither tier ever fires.
WINDOW="${CLAUDE_CONTEXT_WINDOW:-1000000}"
ADVISE_PCT="${CLAUDE_CONTEXT_ADVISE_PCT:-50}"
INSIST_PCT="${CLAUDE_CONTEXT_INSIST_PCT:-75}"

command -v jq >/dev/null 2>&1 || exit 0

payload=$(cat)
transcript=$(printf '%s' "${payload}" | jq -r '.transcript_path // empty' 2>/dev/null)
session=$(printf '%s' "${payload}" | jq -r '.session_id // "unknown"' 2>/dev/null)
session="${session//[^A-Za-z0-9-]/}"
[[ -n "${transcript}" && -f "${transcript}" ]] || exit 0

# The last main-chain assistant turn's usage IS the context size: the three input fields
# already cover the whole conversation, and its output becomes the next prompt's tail.
# Sidechain records are subagent windows — counting one reads a context that is not ours.
# fromjson? rather than a plain parse, so one half-written line cannot abort the scan.
used=$(jq -Rr '
  fromjson?
  | select(.type == "assistant")
  | select(.isSidechain != true)
  | .message?.usage? // empty
  | ((.input_tokens // 0) + (.cache_creation_input_tokens // 0)
     + (.cache_read_input_tokens // 0) + (.output_tokens // 0))
' "${transcript}" 2>/dev/null | tail -1)

[[ "${used}" =~ ^[0-9]+$ ]] || exit 0
[[ "${WINDOW}" =~ ^[0-9]+$ && "${ADVISE_PCT}" =~ ^[0-9]+$ && "${INSIST_PCT}" =~ ^[0-9]+$ ]] || exit 0
# 10# forces base 10, so an override such as 0200000 is not read as octal.
window=$((10#${WINDOW}))
advise=$((10#${ADVISE_PCT}))
insist=$((10#${INSIST_PCT}))
(( window > 0 )) || exit 0
pct=$((10#${used} * 100 / window))

if (( pct >= insist )); then
  cat <<MSG
⛔ Context at ~${pct}% (${used} / ${window} tokens) — past the insist threshold.

House rule (.claude/CLAUDE.md Section 2.5): hand off NOW, before the window forces it.
  1. Invoke the \`handoff\` skill → handoffs/HANDOFF-<DESCRIPTOR>-DD-MM-YYYY.md
  2. Stop the turn and print the path.
  3. Sam runs /clear and resumes from the handoff in a fresh context window.

Start no new lesson, exercise or milestone step. Finish only what cannot safely be left mid-flight.
MSG
  exit 0
fi

(( pct >= advise )) || exit 0

# Advisory fires once per session: a notice repeated every prompt spends the very context
# it exists to protect. The insist tier above repeats deliberately — there, being ignored
# costs more than the tokens do.
state="${TMPDIR:-/tmp}/claude-context-advise-${session}"
[[ -f "${state}" ]] && exit 0
: >"${state}" 2>/dev/null || true

cat <<MSG
⚠️  Context at ~${pct}% (${used} / ${window} tokens) — half the window is gone.

House rule (.claude/CLAUDE.md Section 2.5): steer toward a handoff.
  - Finish the step in flight; open no new lesson or exercise that will not fit.
  - Name the natural stopping point to Sam and offer \`/handoff\`.
  - At ${insist}% this becomes an instruction, not a suggestion.
MSG
exit 0
