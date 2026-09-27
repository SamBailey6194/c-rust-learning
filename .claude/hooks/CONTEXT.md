# .claude/hooks/ — Session-Continuity Hooks

**Last Updated**: 27/09/2026

Two shell hooks that guard one rule — continuity by handoff, not by silent compaction (`.claude/CLAUDE.md`
Section 2.5) — at two moments. `context-threshold-handoff.sh` runs on every prompt and warns as
the context window fills; `pre-compact-handoff.sh` runs when compaction is about to happen and
blocks the automatic kind. Neither hook can invoke a skill or stop a turn — only the model can —
so both measure or intercept and then remind, and the rule in the manual carries the behaviour.
They are registered in `.claude/settings.json`.

## Directory Tree

```text
.claude/hooks/
├── CONTEXT.md                     ← this file
├── CLAUDE.md                      ← operating rules for changing a hook
├── context-threshold-handoff.sh   ← UserPromptSubmit — advise at 50% of the window, insist at 75%
└── pre-compact-handoff.sh         ← PreCompact — exit 2 blocks auto-compaction; manual /compact passes
```

## Files

| File | Event | What it does | Exit codes |
| --- | --- | --- | --- |
| `context-threshold-handoff.sh` | `UserPromptSubmit` | Reads the transcript named in the hook payload, takes the last main-chain assistant turn's token usage as the context size, and prints a notice that Claude Code adds to the model's context | 0 in every case |
| `pre-compact-handoff.sh` | `PreCompact` (matchers `auto` and `manual`) | Prints the handoff reminder to stderr; blocks an automatic compaction, lets a manual `/compact` through | 2 on `auto`, 0 on `manual` |

## How the threshold hook measures

The last assistant record in the transcript that is not a sidechain carries a `usage` object;
its input, cache-creation, cache-read and output token counts summed together are the size of
the conversation the next prompt joins. Sidechain records belong to subagents, whose windows are
separate, so they are skipped. The two tiers behave differently on purpose:

- **50% — advise, once per session.** A notice repeated on every prompt would spend the context
  it exists to protect. A marker file in `$TMPDIR` (per session ID) records that it fired.
- **75% — insist, on every prompt.** Past this point being ignored costs more than the tokens.

**Window size is a constant, not a reading** — nothing in the transcript reports it. The default
assumes a 1M-token window; `CLAUDE_CONTEXT_WINDOW`, `CLAUDE_CONTEXT_ADVISE_PCT` and
`CLAUDE_CONTEXT_INSIST_PCT` override it. On a 200k window the first override matters: with the
default left in place, usage cannot pass 20% of the assumed size and neither tier fires.

## Why the compaction hook is only a backstop

Auto-compaction is already switched off in `.claude/settings.json`, so in normal use the
threshold hook is the one that speaks. `pre-compact-handoff.sh` covers the case where compaction
is reached anyway — a re-enabled setting, or a session that ignored both tiers. Per the Claude
Code hooks reference (checked 27/09/2026): exit 2 on `PreCompact` blocks the compaction; if the
compaction was a recovery from a context-limit error the API had already returned, blocking it
lets that error surface and the request fails, which is still preferable to a silent summary.
On a manual `/compact` the script exits 0, and Claude Code sends a hook's stderr on exit 0 to its
debug log only — so a deliberate `/compact` goes through quietly.

## Dependencies

- `bash` and `jq` (present on the host; see `how-to/docs/TOOLCHAIN.md`). Without `jq` the
  threshold hook exits 0 silently rather than guessing.
- `settings.json` names each script through `$CLAUDE_PROJECT_DIR`, the project root where the
  session started. Hooks run in the session's current directory, which follows every `cd`; a
  path found from there (for example with `git rev-parse --show-toplevel`) would run another
  repository's hook of the same name after a `cd` into it, such as a kernel tree at P4.

## Cross-references

- `.claude/CLAUDE.md` Section 2.5 — the rule both hooks serve
- `.claude/skills/handoff/SKILL.md` — what the model does when a hook fires
- `handoffs/CONTEXT.md` — where the handoff lands
- `.claude/settings.json` — the hook registrations
- Claude Code hooks reference — <https://code.claude.com/docs/en/hooks>
