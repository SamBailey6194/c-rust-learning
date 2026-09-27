@./CONTEXT.md

# CLAUDE.md — how-to/workflows/03-quality-gates/

Read order: `.claude/CLAUDE.md` → `.claude/MEMORY.md` → this folder's `CONTEXT.md` (when to use, the gate
list, key concepts — imported above) → this file → `STEPS.md` then `CHECKLIST.md`.

## Purpose (one line)

Run every quality gate locally — C build, tests, sanitisers, memcheck and analysis; Rust build, tests,
format, lints and dependency audit; the docs audits — so a clean local run predicts a clean CI run.

## How to work here

- **Routing:** run `STEPS.md` in order and tick `CHECKLIST.md`. A red C memory gate → the deeper
  `code/workflows/06-memory-check/`; a logic bug a test exposed → `code/workflows/07-debug/`; a gate that
  exits 2 → `how-to/workflows/05-debugging-environment/`; content review → `code/workflows/05-review/`.
- **Concrete steps:** `toolchain/check.sh` → C gates raw, then scripted → Rust gates raw, then scripted →
  docs audits → optional local runs of the CI-only lints → `gates/all.sh` → record the result.
- **Definition of done:** `gates/all.sh` exits 0 with every gate listed as passed in its summary; no gate
  was skipped, suppressed or read as green on exit 2; the result is recorded where the session or
  milestone needs it.
- **Owner of the list:** the gate table in `CONTEXT.md` is the one home of the gate list. Other files cite
  `how-to/workflows/03-quality-gates/` instead of copying it.

## Guardrails

- **Never suppress a gate to make it pass.** A `-Wno-…` flag, an `#[allow(…)]`, a valgrind suppression
  or a skipped test changes what the repository guarantees; it needs an ADR or, at minimum, a stated
  reason beside it that the learner has agreed.
- **Treat exit 2 as not run.** A missing tool is an environment problem, not a pass; say so in the summary.
- **Fix the mirror, not the symptom.** When local and CI disagree, change the script or the workflow so
  they agree; do not push repeatedly to find out what CI wants.
- **Keep sanitised and valgrind builds apart.** Never run valgrind on a `build/san/` binary.
- **Explain, do not fix, the learner's failing code.** In tutor mode a red gate is a teaching moment: point
  at the report line and the relevant `code/docs/` section, and let the learner make the change.

## Output & naming

- **Hand-written:** `STEPS.md`, `CHECKLIST.md`, `CONTEXT.md`; nothing generated.
- **Produced by running it:** build output in each exercise's `build/` and in `code/src/rust/target/`
  (gitignored), and a gate summary quoted into the session's PROGRESS entry or the milestone's
  verification record under `project-management/src/10-PROGRESS/`.
- Adding or removing a gate is a change to this folder, `code/src/scripts/gates/all.sh` and the CI
  workflow together, in one commit.
