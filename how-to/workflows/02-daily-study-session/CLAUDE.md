@./CONTEXT.md

# CLAUDE.md — how-to/workflows/02-daily-study-session/

Read order: `.claude/CLAUDE.md` → `.claude/MEMORY.md` → this folder's `CONTEXT.md` (when to use, key
concepts — imported above) → this file → `STEPS.md` then `CHECKLIST.md`.

## Purpose (one line)

The start-to-finish routine for one study session: pull, read the open handoff, pick one unit, be on the
milestone's branch, check the toolchain, study and exercise, run the gates, log progress, commit, and hand
off if unfinished.

## How to work here

- **Routing:** run `STEPS.md` in order and verify against `CHECKLIST.md`. The unit itself follows
  `project-management/workflows/10-study-and-build/` and the code workflows it names
  (`code/workflows/01-c-exercise/` to `04-ffi-bridge/`).
- **Learn before you build:** an unfamiliar concept → `/teach` (`.claude/skills/teach/SKILL.md`), which
  keeps its notes in the `learning/` sandbox; Claude writes no exercise code, and Sam's example lands
  under `code/src/` through the code workflow.
- **Session handoff:** the session ends before the unit does → `/handoff`
  (`.claude/skills/handoff/SKILL.md`) writes a committed note in `handoffs/`.
- **Concrete steps:** `git pull` and switch to the milestone branch in flight → open handoff → today's
  unit from the sprint or milestone plan → the milestone's branch → `toolchain/check.sh` → study and
  exercise → gates and Markdown lint → PROGRESS entry → commit → handoff if unfinished.
- **Definition of done:** the unit advanced; the gates for the touched code exit 0; a dated PROGRESS
  entry exists; the work is committed on the milestone's branch and pushed; a handoff exists if the
  unit is unfinished.

## Guardrails

- **Hard gate: settle the branch name before the first commit.** Use the pattern in
  `project-management/docs/git/BRANCHES.md`; renaming after commits exist is avoidable churn.
- **Tutor rather than solve.** During Step 6 the tutor-mode rules in `code/CLAUDE.md` and
  `learning/CLAUDE.md` apply: ask how the learner plans to approach the problem before helping, and do
  not write exercise solutions unless explicitly asked.
- **Stage by explicit path.** Never `git add -A` or `git add .`; name each file.
- **Keep kernels in QEMU.** From P4 onwards the kernel safety rule in `.claude/CLAUDE.md` applies to
  every session: nothing built here is installed or `insmod`-ed on the host.
- **Log the session even when it went badly.** A PROGRESS entry that records a dead end is still the
  record the next session needs.

## Output & naming

- **Hand-written:** `STEPS.md`, `CHECKLIST.md`, `CONTEXT.md`; nothing generated.
- **Produced by following it:** commits on an `ms###/<short-kebab>` branch, a dated entry in
  `learning/<track>-NN-<topic>/PROGRESS.md`, and, for an unfinished unit,
  `handoffs/HANDOFF-<SCREAMING-KEBAB-DESCRIPTOR>-DD-MM-YYYY.md`.
- Commit messages are Conventional Commits with a scope such as `c`, `rust` or `learning`, per
  `project-management/docs/git/COMMITS.md`.
