@./CONTEXT.md

# CLAUDE.md — code/workflows/08-refactor/

Read order: `.claude/CLAUDE.md` → `.claude/MEMORY.md` → this folder's `CONTEXT.md` (behaviour held
identical, tests as the fixed point, one move at a time — imported above) → this file → `STEPS.md` then
`CHECKLIST.md`.

## Purpose (one line)

Restructure working, tested C or Rust code one behaviour-preserving move at a time, with every gate green
before and after each move and no test changed.

## How to work here

- **Routing:** run `STEPS.md` in order against `CHECKLIST.md`. A red baseline or a behaviour change goes to
  `code/workflows/07-debug/` first; a larger design question that needs a decision goes to
  `project-management/workflows/08-decisions/`.
- **Tutor mode:** ask the learner what makes the code hard to read or change, and which move they would
  try first. Name the smell and point at the `code/docs/CODING-PRINCIPLES.md` section; let the learner make
  each move. Do not restructure the code for them unless explicitly asked.
- **Concrete steps:** record a green baseline (tests and memory tools) → name the target and list the
  moves → apply one move → build and test → commit at green → repeat → re-run every gate → confirm no test
  file changed.
- **Definition of done:** every gate exits 0, as at the baseline; the diff touches no test assertion;
  every touched source file stays within 750 lines; each move is its own small commit or a small group of
  them.

## Guardrails

- **Never mix a refactor with a behaviour change.** Fix bugs first through `07-debug`, in their own commit,
  then refactor.
- **Start only from a green baseline.** If anything is red before the first move, stop and fix it
  elsewhere.
- **Undo a move that turns anything red.** Revert that one move and try a smaller one; do not debug forward.
- **Change no test assertion.** If a test has to change, the public contract changed and this is no longer
  a refactor.
- **Keep the memory tools clean.** A C refactor re-runs `san`, `memcheck` and `lint`, not just `test`.

## Output & naming

- **Produced by following it:** restructured source in place under `code/src/`; the exercise's or crate's
  `CONTEXT.md` tree updated if files were split or renamed.
- Commit type `refactor` with scope `c` or `rust` (`project-management/docs/git/COMMITS.md`), one move or a
  few small moves per commit.
- Workflow files `SCREAMING-SNAKE-CASE.md`, frontmatter `workflow: 08-refactor`,
  `phase: diagnose-and-improve`.
