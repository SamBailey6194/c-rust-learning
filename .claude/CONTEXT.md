# .claude/ — Claude Code Configuration

**Last Updated**: 27/09/2026 | **Version**: 0.1.0 | **Maintained By**: Sam Bailey
**Language**: British English (en_GB) | **Timezone**: Europe/London

Claude Code's configuration for c-rust-learning: the one manual every session reads first, the
project memory it reads second, the shared settings, the session-continuity hooks and the four
skills that drive tutoring, handoffs and research. It exists so that Claude behaves the same way
in every session and on every machine the repository is cloned to — the rules live in the
repository, not in anyone's personal configuration.

## Directory Tree

```text
.claude/
├── CLAUDE.md                ← the manual — tutor posture, operating model, non-negotiables
├── CONTEXT.md               ← this file
├── MEMORY.md                ← project memory (feedback, patterns, project state)
├── settings.json            ← shared settings: read-only allowlist, .env denies, hooks, no auto-compaction
├── settings.local.json      ← per-machine permission approvals (gitignored)
├── hooks/                   ← session-continuity hooks
│   ├── CONTEXT.md · CLAUDE.md                ← orientation + operating rules
│   ├── context-threshold-handoff.sh          ← UserPromptSubmit — advise at 50%, insist at 75%
│   └── pre-compact-handoff.sh                ← PreCompact — blocks auto-compaction
├── skills/                  ← the skill roster (index: skills/CONTEXT.md)
│   ├── CONTEXT.md · CLAUDE.md                ← roster + authoring rules
│   ├── teach/SKILL.md                        ← /teach — lessons, retrieval practice, spaced review
│   ├── handoff/SKILL.md                      ← /handoff — the auto-compaction replacement
│   ├── research/SKILL.md                     ← /research — one question, primary sources
│   └── wait-what/SKILL.md                    ← /wait-what — re-pitch a reply that did not land
└── worktrees/               ← git worktree checkouts, when used (gitignored)
```

## Key files

| File | Role |
| --- | --- |
| `CLAUDE.md` | The authoritative manual. Its `@` imports load the root `CONTEXT.md`, root `REFERENCES.md` and this file |
| `MEMORY.md` | Durable project memory in three sections — Feedback, Project Patterns, Project State — read second every session |
| `settings.json` | Project-scope Claude Code settings, committed so every clone gets the same permissions and hooks |

## Sub-directories

| Directory | CONTEXT.md | Purpose |
| --- | --- | --- |
| `hooks/` | `hooks/CONTEXT.md` | Measure context use and intercept compaction, steering to `/handoff` |
| `skills/` | `skills/CONTEXT.md` | The skill roster and the only when-to-load table |
| `worktrees/` | _(gitignored — no tracked content)_ | Parallel checkouts for isolated work |

## Why the settings look the way they do

- **A read-only allowlist.** Commands that only look (`ls`, `grep`, `git status`, `gcc --version`)
  run without a prompt; anything that builds, writes or runs code still asks. In a learning
  repository the prompt is part of the lesson: Sam sees each command before it runs. `rg`, `man`
  and `make -n` are left off on purpose: each looks read-only but can run a program (`rg --pre`,
  `man -P`, and the `$(shell …)` calls `make -n` still evaluates), so each still prompts. `tree`,
  `find` and `git diff`/`log`/`show`/`blame` are left off for the same reason in a different
  form: `tree -o`, `find -fprint` and git's `--output=<file>` write a file. Claude Code's own
  built-in read-only set already runs plain `find` and the read-only forms of `git` without a
  prompt (Claude Code permissions reference, checked 27/09/2026), so nothing is lost.
- **`.env` reads are denied**, although nothing here needs one — a public repository is the wrong
  place to find out that a secret was read into a transcript.
- **`AskUserQuestion` is denied** so that clarifying questions stay in the transcript as prose,
  in the format `.claude/CLAUDE.md` Section 8 fixes.
- **Auto-compaction is off** (`autoCompactEnabled: false`) and backed by two hooks, because a
  silent summary loses exactly the in-flight detail a handoff preserves (`.claude/CLAUDE.md`
  Section 2.5).

## Cross-references

- `.claude/CLAUDE.md` — the manual
- `.claude/hooks/CONTEXT.md` — how the two hooks measure and intercept
- `.claude/skills/CONTEXT.md` — the skill roster
- `handoffs/CONTEXT.md` — where `/handoff` writes
- `CONTEXT.md` — the root map
