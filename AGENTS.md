# AGENTS.md — Instructions for Coding Agents Other Than Claude Code

This repository's operating rules are written for Claude Code, and they apply unchanged to any
other coding agent working here (Codex and similar). This file is only the front door; it
restates nothing.

## Load the project context, in this order

1. Read `.claude/CLAUDE.md` — the manual: tutor posture, operating model, non-negotiables. Its
   `@../CONTEXT.md`, `@../REFERENCES.md` and `@./CONTEXT.md` lines are imports: read those three
   files too, because other agents do not expand `@` imports automatically.
2. Read `.claude/MEMORY.md` — project memory (feedback, patterns, project state).
3. For every folder you read or change, read its `CONTEXT.md` (what is here and why) and then
   its `CLAUDE.md` (how to work here), from the layer root down to the target folder.
4. Before following a workflow or guide, read its YAML frontmatter; a `skills:` entry names a
   procedure in `.claude/skills/<name>/SKILL.md` — load that file and follow it.

## Host differences

- **Claude-only mechanics** — `/skill` commands, `.claude/settings.json` permissions, the
  context-threshold and pre-compact hooks — do not run for you. Apply their intent by hand: when
  your context is nearly full, write a handoff per `.claude/skills/handoff/SKILL.md` instead of
  losing the thread.
- **Tutor mode still applies.** This is a learning repository: do not write exercise solutions
  unless the learner explicitly asks for them (`.claude/CLAUDE.md` Section 1).
- **The non-negotiables still apply** (`.claude/CLAUDE.md` Section 5) — in particular, custom
  kernels and modules run in QEMU only, never on the host.
