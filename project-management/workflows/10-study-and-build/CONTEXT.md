# Workflow: Study and Build

**Last Updated**: 27/09/2026

Reading about pointers is not the same as being able to use them, and a concept left unrecalled fades
within days. This workflow joins the two halves of learning: a concept is taught and recalled through
`/teach`, proved in a real, tested exercise under `code/src/`, written up in the learner's own words, and
scheduled for spaced review so it is still there next month.

## Directory Tree

```text
project-management/workflows/10-study-and-build/
├── CONTEXT.md · CLAUDE.md   ← orientation (this file) · operating rules, including tutor mode
├── STEPS.md                 ← ordered steps, each closing on a "Done when" line
└── CHECKLIST.md             ← the gate ticked before the workflow counts as complete
```

## When to use this

- Every study session inside a milestone, once `09-milestone-plans` has written the milestone's plan.
- The operational side of a session (opening the terminal, checking the toolchain, time-boxing) is
  `how-to/workflows/02-daily-study-session/`; this workflow is what the session produces for the
  milestone.
- It repeats until every exercise in the plan is built; then `11-verification` runs.

## Key concepts

- **Concept, then exercise, then note.** `/teach <topic>` opens or creates
  `learning/<track>-NN-<topic>/` (for example `c-01-foundations/`, created by the first C lesson) with
  `MISSION.md`, `RESOURCES.md`, `PROGRESS.md` (the review queue and a dated journal) and `NOTES/`. The
  lesson's build-to-learn half is the plan's next exercise, built through code workflows `01` to `04`
  into `code/src/c/ms###-<kebab>/` or `code/src/rust/crates/ms###_<snake>/`. The lesson closes with a
  note, `NOTES/NN-<concept>.md`, in the learner's own words and linking the code by path.
- **Tracks.** The tracks `learning/CLAUDE.md` names — `c`, `tooling`, `rust`, `kernel`, `os`, `ui`,
  `llm` and `sec`; Syntek OS study sits in the `os` track. `NN` is a two-digit running number within
  the track.
- **Tutor mode.** Claude asks how the learner plans to approach a problem before helping, explains and
  asks guiding questions, and leaves exercise solutions to the learner unless they explicitly ask for
  one. A review points at the relevant `code/docs/` section instead of rewriting the code.
- **Retrieval, then spacing.** Each lesson includes a recall question answered unaided, and a
  `PROGRESS.md` entry that schedules the next review: +1 day, then +3, then +7, with a partial or a miss
  sending it back to +1 and a pass at +7 marking it consolidated (`.claude/skills/teach/SKILL.md` owns
  the curve). Due reviews open the next session, before any new material.
- **Notes in `learning/`, runnable code in `code/src/`.** Every line that compiles lives where the gates
  and CI check it; `learning/` holds the words, the review queue and the journal. That split is what
  lets `11-verification` prove the milestone from `code/src/` alone.
- **When an explanation does not land.** The learner types `/wait-what` and Claude re-pitches it in
  plain words; a gap that turns out to be missing knowledge becomes a new `/teach` topic.
- **Bugs are records.** A bug chased with gdb or valgrind runs through `code/workflows/07-debug/` and
  is written up in `project-management/src/13-BUGS/`.

## Cross-references

### Governing documents

- `project-management/src/09-MILESTONE-PLANS/` — the milestone's plan; the exercise order comes from it
- `.claude/skills/teach/SKILL.md` — the teaching loop and the `learning/` layout
- `code/workflows/CONTEXT.md` — the code workflows `01` to `08` and when each applies
- `project-management/workflows/06-kernel-spec/` — its RECORD part, entered from here once a kernel
  milestone's build has run, writes the `KERNEL-IMPL` record

### Related reading

- `learning/CONTEXT.md` — how topic folders are named and what each file holds
- `code/workflows/01-c-exercise/` · `02-tdd-cycle/` · `03-rust-exercise/` · `04-ffi-bridge/` — the
  build workflows
- `code/workflows/06-memory-check/` · `07-debug/` — sanitiser and valgrind runs; bug chasing
- `code/docs/BUILD.md` · `code/docs/TESTING.md` — make targets, flags and the `check.h` harness
- `.claude/skills/wait-what/SKILL.md` — the re-pitch the learner can call at any point
- `how-to/workflows/02-daily-study-session/` — the operational session routine
- `project-management/workflows/11-verification/` — downstream: proving the milestone
