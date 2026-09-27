---
name: handoff
description: >-
  Compact the current session into one committed handoff document so a fresh session resumes the
  work without re-deriving it, then stop. Invoke by typing /handoff, or when a session must end
  before the work does: the context window nearing full (this is the repo's replacement for
  auto-compaction), the day ending, or other work taking over. Also writes the
  HANDOFF-TEACH-<TOPIC> teaching detour that wait-what offers.
---

# Skill: Handoff (c-rust-learning)

Handoff **compacts the current session** into a single document so a **fresh session** can resume
the work cleanly across a session boundary: a context window filling up, a day ending, other work
taking over. It captures the live thread of _this_ session only: where the work sits, what is
half-done, and the next move. Durable knowledge has other homes (below); a handoff is a transient
bridge, not a memory store.

Locale: en_GB · Europe/London · dates DD/MM/YYYY.

## The auto-compaction replacement

Compaction swaps the conversation for a summary nobody reviewed; a handoff is a file Sam can read,
correct and commit. So when the context window nears full, **do not let the session compact**: run
this skill, write the handoff, **stop**, and let Sam `/clear` and resume from the file.
Auto-compaction is switched off in `.claude/settings.json` (`autoCompactEnabled: false`), and the
two hooks in `.claude/hooks/` (`context-threshold-handoff.sh` and `pre-compact-handoff.sh`,
described in `.claude/hooks/CONTEXT.md`) prompt for a handoff as the window fills; writing the
handoff and stopping is the model's job, not a hook's. Only a top-level session writes a handoff; a subagent returns its result to its parent.

## Where the handoff lives

`handoffs/HANDOFF-<SCREAMING-KEBAB-DESCRIPTOR>-DD-MM-YYYY.md`, committed so it syncs across Sam's
devices, and therefore **public**, because the repo is. The descriptor names the work, for
example `HANDOFF-MS001-TOOLCHAIN-GATES-27-09-2026.md`. A teaching detour from `wait-what` is
`HANDOFF-TEACH-<TOPIC>-DD-MM-YYYY.md`, with the topic slug in capitals, for example
`HANDOFF-TEACH-C-02-POINTERS-AND-MEMORY-27-09-2026.md`. Prune a handoff once its work has resumed
(`handoffs/CLAUDE.md`).

## How to write a handoff

1. **State the goal.** Open with one or two sentences naming what the work is trying to achieve,
   so the fresh session orients before any detail. Look facts up (`git status`, `git log`, the
   milestone file, the topic's `PROGRESS.md`) rather than recalling them.
   _Done when the goal sits in one or two sentences at the top and names the milestone (`MS###`)
   or the learning topic it serves._
2. **Record what is DONE.** List the work landed this session: files changed, lessons logged,
   checks run with their exit codes, commits by short hash.
   _Done when every finished item is a one-liner carrying its repo path or commit hash._
3. **Pin what is IN-FLIGHT.** For each open thread, give the exact `path:line` anchor and its
   mid-change state: the failing test's name, the last command and what it printed, the half-made
   decision. This is the load-bearing section; the fresh session resumes here.
   _Done when every in-flight item carries a `path:line` anchor and a one-line status, or the
   section says "Nothing is mid-edit" and why._
4. **Name the immediate NEXT action.** State the single next step, concrete enough to start
   without re-deriving it.
   _Done when the next action is one imperative sentence._
5. **Name what the next session loads.** In order: the skill to invoke (`/teach <topic>`,
   `/research`), the learning topic's `MISSION.md` and `PROGRESS.md`, the research note, the code
   path, and the workflow `STEPS.md` the work is part of.
   _Done when the handoff lists, in reading order, what the next session opens and which skill it
   invokes first._
6. **Reference artefacts by path, never paste them.** Point at milestones
   (`project-management/src/02-MILESTONES/`), ADRs (`project-management/src/08-DECISIONS/`),
   `learning/<topic>/PROGRESS.md`, research notes, and commits by short hash; the fresh session
   opens them itself. Because the repo is public, a handoff holds **no absolute path, no session
   ID, no email address and no secret**: name a local-only thing by what it is, not where it sits.
   Scratch and crash paths under `/tmp` and `/var` count too, and so does a path encoded into a
   directory name, as Claude Code's scratch folders encode the home path (`-home-<user>-…`).
   Check before writing:

   ```bash
   grep -nE '/(home|mnt|root|Users|tmp|var)/|-home-[[:alnum:]_-]+-|(^|[[:space:]`(])~/|[0-9a-f]{8}-([0-9a-f]{4}-){3}[0-9a-f]{12}|[[:alnum:]._-]+@[[:alnum:]-]+\.[a-z]{2,}' \
     handoffs/HANDOFF-*.md
   ```

   _Done when every artefact is a repo-relative path or a commit hash, and the grep above prints
   nothing._
7. **Write the file, print the path, then stop.** Write the assembled handoff to `handoffs/`,
   print its path for Sam, and **end the turn**; do not carry on working, so Sam can `/clear` and
   resume from the file in a fresh context window. Committing it is Sam's call
   (`project-management/docs/git/COMMITS.md`).
   _Done when the file exists under `handoffs/`, its path is printed, and the turn has stopped._

## The document

```markdown
# HANDOFF — {one line stating the whole situation: what landed, what is open, what blocks}

**Written**: {DD/MM/YYYY} · **Branch**: `{branch}` · **HEAD at writing**: `{short-hash}`
**Milestone**: {MS### — title} · **Topic**: `learning/{track}-{NN}-{topic}/` · **Blocked on**: {nothing | what}

---

## Goal

{One or two sentences.}

---

## Done

- {What landed} — `{path}` or `{short-hash}`

---

## In-flight

| Anchor | State |
| --- | --- |
| `{path}:{line}` | {mid-change state, in one line} |

---

## Next

{One imperative sentence.}

---

## Next session loads

1. {The skill to invoke first, e.g. `/teach {topic}`}
2. `learning/{track}-{NN}-{topic}/MISSION.md` · `PROGRESS.md`
3. `{code path}` · `{workflow}/STEPS.md`

---

## Artefacts

- `{path}` — {why the next session opens it}
```

Leave out the **Topic** field when no learning topic is involved. A teaching detour adds one line
beneath the metadata: `**Teaching detour**: {topic slug} · missed: {concept} · opening lesson:
{lesson}` (`.claude/skills/wait-what/SKILL.md`).

## What the handoff carries

A complete handoff names all six, top to bottom; treat this as the final checklist:

- **Goal**: what the work achieves, in one or two sentences.
- **Done**: landed work, each by path or commit hash.
- **In-flight**: open threads with `path:line` anchors and status.
- **Next**: the single immediate action.
- **Next session loads**: the skill to invoke, then the files to read, in order.
- **Artefacts**: milestones, ADRs, `PROGRESS.md` files, research notes, commits, all by path.

Add `## Open questions — asked DD/MM/YYYY, unanswered` only when the session left a decision
genuinely unresolved; name it for the fresh session rather than pre-empting it.

## What stays out

Durable knowledge does not belong in a transient handoff; route it to its home instead:

- What Sam now knows, and recall results → `learning/<topic>/PROGRESS.md`.
- Feedback, patterns and project-state facts → `.claude/MEMORY.md`.
- Active gaps and blockers (a missing tool, a blocked milestone) → `GAPS.md`.
- Topics parked for a later phase → `DEFERRED.md`.
- A decision → an ADR in `project-management/src/08-DECISIONS/`; the evidence for it → `research/`.
- Milestone status → the milestone file (vocabulary: `project-management/docs/planning/MILESTONES.md`).

The handoff carries only live continuity: the thread of this session, not the repo's memory,
registers or backlog.

## Governing procedures (route here — do not restate at length)

**No governing workflow.** This skill is a session mechanic, not a step in a delivery chain. It is
the "handoff written if the session ends mid-work" item in every workflow `CHECKLIST.md`
`## Context` section, and the close of `how-to/workflows/02-daily-study-session/` when a session
ends mid-task.

## Cross-references

- `.claude/CLAUDE.md`: session continuity, the registers and the rule that they never cross.
- `.claude/hooks/CONTEXT.md`: the two hooks that prompt this skill as the context window fills.
- `.claude/skills/wait-what/SKILL.md` · `.claude/skills/teach/SKILL.md`: the teaching detour, a
  `HANDOFF-TEACH-<TOPIC>` handoff whose next session runs `/teach` before resuming the work.
- `.claude/skills/CONTEXT.md`: the roster the next session's skill is drawn from.
- `handoffs/CONTEXT.md` · `handoffs/CLAUDE.md`: the folder, its pruning rule and its public-repo rules.
- `.claude/MEMORY.md` · `GAPS.md` · `DEFERRED.md`: the homes for durable knowledge kept out.
- `project-management/src/02-MILESTONES/` · `project-management/src/08-DECISIONS/`: artefacts
  referenced by path.
- `project-management/docs/git/COMMITS.md`: how the handoff, and the work it describes, is committed.
