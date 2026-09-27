@./CONTEXT.md

# CLAUDE.md — .claude/hooks/

Read order: `.claude/CLAUDE.md` → `.claude/MEMORY.md` → this folder's `CONTEXT.md` (what each
hook measures or intercepts, and why, imported above) → this file → `.claude/settings.json`
(where the hooks are registered).

## Purpose (one line)

Keep the two session-continuity hooks correct, quiet when they should be, and loud only when the
handoff rule (`.claude/CLAUDE.md` Section 2.5) needs them to be.

## How to work here

- **Routing:** a change to _when_ a hook fires or _what it says_ is made in the script; a change
  to _which_ event or matcher runs it is made in `.claude/settings.json`; a change to the rule
  itself is made in `.claude/CLAUDE.md` Section 2.5 first, then here.
- **Concrete steps:** edit the script → `bash -n` it → `shellcheck -x` it (clean, with no
  `disable` directives; CI's `Syntax — Shell` gate runs both over this folder,
  `.github/workflows/syntax-shell.yml`) → replay a realistic payload on stdin against a scratch
  transcript, forcing each tier with the environment overrides → confirm the exit code of every
  branch → update `CONTEXT.md` if the behaviour changed.
- **Replaying a payload** — the threshold hook, forced to the insist tier with a small window:

  ```bash
  printf '{"session_id":"t1","transcript_path":"%s"}' "$PWD/t.jsonl" \
    | CLAUDE_CONTEXT_WINDOW=1000 bash .claude/hooks/context-threshold-handoff.sh; echo "exit=$?"
  printf '{"trigger":"auto"}' | bash .claude/hooks/pre-compact-handoff.sh; echo "exit=$?"   # exit=2
  ```

  where `t.jsonl` holds lines shaped like
  `{"type":"assistant","isSidechain":false,"message":{"usage":{"input_tokens":900,"output_tokens":10}}}`.
- **Definition of done:** both scripts pass `bash -n` and `shellcheck`; every tier and both
  compaction modes were exercised by a replay and exited with the documented code; `settings.json`
  still parses (`jq -e . .claude/settings.json`); `CONTEXT.md` matches the behaviour.

## Guardrails

- **The threshold hook exits 0 on every path.** It sits on every prompt, and exit 2 on
  `UserPromptSubmit` would erase the prompt Sam just typed. A missing `jq`, a missing transcript
  or an unparseable payload exits silently rather than guessing.
- **Count the main chain only.** Usage records flagged `isSidechain` are subagent windows;
  counting one reports a context that is not the session's.
- **Keep the advise tier once-per-session and the insist tier every-prompt.** The asymmetry is
  the design, not an oversight (`CONTEXT.md` → _How the threshold hook measures_).
- **Never weaken the auto-compaction block.** `pre-compact-handoff.sh auto` exits 2; silent
  compaction is the failure it exists to prevent. A manual `/compact` stays Sam's choice and is
  not blocked.
- **Verify a threshold change by replay, not by waiting.** The tiers are unreachable in a fresh
  session, so an edit that was not replayed ships untested.
- **Hooks read and print; they never write to the repository.** The only file either touches is
  the advise marker under `$TMPDIR`.
- **Check hook behaviour against the current Claude Code hooks reference** before relying on an
  exit code or output channel — event semantics change between releases.

## Output & naming

- **Hand-written:** `context-threshold-handoff.sh`, `pre-compact-handoff.sh`. Nothing here is
  generated.
- **Naming:** `kebab-case.sh`, named for what the hook guards, with a `#!/usr/bin/env bash`
  shebang, a header comment giving the event, usage and exit codes, and `set -uo pipefail`
  (not `-e`: a hook fails soft by design).
- A new hook is registered in `.claude/settings.json` as
  `bash "$CLAUDE_PROJECT_DIR/.claude/hooks/<name>.sh"` — never a path found from the current
  directory (`CONTEXT.md` → _Dependencies_) — and added to the tree and the _Files_ table in
  `CONTEXT.md` in the same change.
