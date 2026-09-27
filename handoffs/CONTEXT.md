# handoffs/ — Session Handoff Documents

**Last Updated**: 27/09/2026 | **Version**: 0.1.0 | **Maintained By**: Sam Bailey
**Language**: British English (en_GB) | **Timezone**: Europe/London

The committed home for `/handoff` documents. Each file compacts one session that ended before its
work did, so a fresh session, or Sam on another device, resumes the work without re-deriving it. A
handoff is a transient bridge, not a memory store: durable knowledge lives in
`learning/<topic>/PROGRESS.md`, `.claude/MEMORY.md`, `GAPS.md` and `DEFERRED.md`. In this repo a
handoff also replaces auto-compaction: when the context window nears full, the session writes one
and stops.

## Directory Tree

```text
handoffs/
├── CONTEXT.md · CLAUDE.md                     ← this orientation · the format, pruning and public-repo rules
├── HANDOFF-<SCREAMING-KEBAB>-DD-MM-YYYY.md    ← one per session that ended mid-work, created by /handoff (none yet)
└── HANDOFF-TEACH-<TOPIC>-DD-MM-YYYY.md        ← a teaching detour: /wait-what found a gap; the next session runs /teach
```

## Anatomy of a handoff

The H1 states the whole situation in one line (`# HANDOFF — ...`). A bold metadata line follows:
**Written**, **Branch**, **HEAD at writing**, **Milestone**, **Topic** and **Blocked on**. Then six
sections separated by `---`: **Goal**, **Done**, **In-flight** (a table of `path:line` anchors and
their state), **Next** (one action), **Next session loads** (the skill to invoke, then the files to
read, in order) and **Artefacts** (by path). An **Open questions** section appears only when a
decision is genuinely unresolved. The full format is owned by `.claude/skills/handoff/SKILL.md`.

## Lifecycle

A handoff is written at the end of a session, committed so it syncs, read first by the next
session, and deleted once its **Next** action has landed; git history keeps the text. The folder
is a live set, not an archive: at any moment it holds only the handoffs whose work is still waiting
to resume, usually none or one.

## Why committed, and what that costs

Tracked, not ignored, so a handoff written on one device is there on another. Because the
repository is public, every handoff is public too, which is why the format carries repo-relative
paths and commit hashes only, and no absolute paths, session IDs or email addresses
(`handoffs/CLAUDE.md`).

## When to read this

- At the start of every session: the newest handoff here comes before anything else.
- When `/wait-what` offers a teaching detour, and the next session opens on a `HANDOFF-TEACH-` file.

## Do not use for

- What Sam now knows, and recall results → `learning/CONTEXT.md`
- Feedback, patterns and project-state facts → `.claude/MEMORY.md`
- Active gaps and blockers → `GAPS.md`
- Topics parked for a later phase → `DEFERRED.md`
- Decisions → `project-management/src/08-DECISIONS/`

## Key docs

| Guide | When to read |
| --- | --- |
| `.claude/skills/handoff/SKILL.md` | Writing a handoff: the seven steps, the format, what stays out |
| `.claude/skills/wait-what/SKILL.md` | Writing a teaching detour |
| `.claude/hooks/CONTEXT.md` | Why a hook suggested a handoff mid-session |
| `how-to/workflows/02-daily-study-session/` | Where reading a handoff sits in a session |

## Cross-references

- `handoffs/CLAUDE.md`: how to work here.
- `.claude/CLAUDE.md`: session continuity and the registers a handoff routes durable knowledge to.
- `project-management/docs/git/COMMITS.md`: how a handoff and its pruning are committed.
