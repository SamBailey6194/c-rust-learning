@./CONTEXT.md

# CLAUDE.md — project-management/workflows/10-study-and-build/

Read order: `.claude/CLAUDE.md` → `.claude/MEMORY.md` → this folder's `CONTEXT.md` (when to use, the lesson
loop, tutor mode — imported above) → this file → `STEPS.md` then `CHECKLIST.md` → the milestone's plan
in `project-management/src/09-MILESTONE-PLANS/`.

## Purpose (one line)

Run each study session of a milestone: due reviews first, then one concept through `/teach`, then the
matching exercise through the code workflows, in tutor mode throughout.

## How to work here

- **Routing:** run `STEPS.md` in order against `CHECKLIST.md`, taking the next item from the milestone's
  plan. Concepts go through `.claude/skills/teach/SKILL.md` (`/teach <topic>`); exercises go through
  `code/workflows/01-c-exercise/`, `03-rust-exercise/` or `04-ffi-bridge/`, with `02-tdd-cycle/` inside
  them; bugs go through `code/workflows/07-debug/`.
- **Concrete steps:** answer due reviews → pick the next plan item → `/teach` the concept and its recall
  question → the learner explains it back and states their approach → failing test first → build the
  exercise under `code/src/` until tests, `san` and `memcheck` are clean → the learner writes the note
  and the lesson is logged in `PROGRESS.md` → log bugs and misconceptions → commit by path → close the
  session with a starting point for the next one.
- **Definition of done:** for each session, due reviews are answered and rescheduled, `PROGRESS.md` holds
  a dated entry with a next-review date, the exercise worked on has passing tests, and the work is
  committed; for the milestone, every exercise in the plan is built.

## Guardrails

- **Ask how the learner plans to approach the problem before offering help.** Their plan shows what they
  already understand; help aimed at it lands, help aimed past it does not.
- **Leave exercise solutions to the learner unless they explicitly ask for one.** Explain, give a hint,
  ask a guiding question, or point at the failing test; the code in `code/src/` is theirs.
- **Point reviews at `code/docs/`, not at a rewrite.** Name the section (`code/docs/C-CODING-PRINCIPLES.md`,
  `code/docs/MEMORY-SAFETY.md`) and let the learner make the change.
- **Keep notes in `learning/` and runnable code in `code/src/`.** A note links the code by path; code
  pasted into `NOTES/` is code no gate or CI run ever checks.
- **Open every session on due reviews.** New material before overdue recall trades long-term retention
  for short-term progress.
- **Run custom kernels and modules in QEMU only.** From P4 onwards nothing built here is installed or
  loaded on the host (`.claude/CLAUDE.md` owns the rule).

## Output & naming

- **Writes:** `learning/<track>-NN-<topic>/{MISSION,RESOURCES,PROGRESS}.md` and
  `NOTES/NN-<concept>.md` (through `/teach`); exercises in `code/src/c/ms###-<kebab>/` (`Makefile`, `*.h`,
  `*.c`, `test_*.c`) or `code/src/rust/crates/ms###_<snake>/`; bug records in
  `project-management/src/13-BUGS/` through `code/workflows/07-debug/`; for a kernel milestone, the
  `KERNEL-IMPL` record in `project-management/src/06-KERNEL/` through
  `project-management/workflows/06-kernel-spec/` → RECORD.
- Tracks `c`, `rust`, `kernel`, `tooling` (`learning/CLAUDE.md` owns the naming); `NN` two digits;
  `<topic>` kebab-case; review dates DD/MM/YYYY.
- Commit scopes `c`, `rust` or `kernel` for code and `learning` for notes and progress, per
  `project-management/docs/git/COMMITS.md`.
