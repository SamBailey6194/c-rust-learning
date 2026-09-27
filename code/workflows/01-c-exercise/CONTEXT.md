# Workflow: C Exercise

**Last Updated**: 27/09/2026

A C program that prints the right answer can still write past a buffer, leak on its error path or lean on
undefined behaviour, and none of that shows in the output. This workflow takes one exercise from its spec
to green tests and clean sanitiser, valgrind and analyzer runs, so "it works" means something.

## Directory Tree

```text
code/workflows/01-c-exercise/
├── CONTEXT.md · CLAUDE.md   ← orientation (this file) · operating rules for the workflow
├── STEPS.md                 ← ordered steps, each closing on a "Done when" line
└── CHECKLIST.md             ← the gate ticked before the workflow counts as complete
```

## When to use this

- To start and finish one C exercise specified by an `EX-MS###-<TOPIC>.md` spec in
  `project-management/src/04-EXERCISES/`, from creating `code/src/c/msNNN-<kebab>/` to the learning note.
- To resume an unfinished exercise at the first step whose "Done when" line is not yet true.
- For the test loop on its own, `code/workflows/02-tdd-cycle/` is the smaller tool; for a Rust port of a
  finished exercise, `code/workflows/03-rust-exercise/`.

## Key concepts

- **The spec is the oracle.** The expected results in the tests come from the spec's worked examples, man
  pages or the C standard, not from running the code.
- **One exercise, one folder.** `code/src/c/msNNN-<kebab>/` holds the header, the sources, `main.c`, the
  `test_*.c` files, a three-variable `Makefile` and the folder's own `CONTEXT.md` + `CLAUDE.md`. `NNN` is
  the milestone number from the spec's ID and the kebab part names the exercise, so one milestone can hold
  several exercises. `make -C code/src/c <target>` finds every `ms###-*/` folder without an edit.
- **The Makefile sets three names and includes the shared rules.** `PROG`, `SRCS` (every program source,
  `main.c` included) and `TEST_SRCS`, then `include ../mk/exercise.mk`. Each test binary links the
  program's sources minus `main.c`, which is how a test calls the functions without the program's own
  `main()`. Flags live in `code/src/c/mk/flags.mk`; `code/docs/BUILD.md` explains them.
- **Four gates, four different questions.** `make test` — does it do what the spec says? `make san` —
  does any test run trip AddressSanitizer or UBSan? `make memcheck` — does valgrind see an invalid access,
  an uninitialised read or any unfreed block? `make lint` — does gcc's `-fanalyzer` find a bad path no
  test took? A pass on one says nothing about the others.
- **Warnings are errors.** The warning set ends in `-Werror`, so a warning stops the build as surely as a
  syntax error.
- **Kernel coding style from the first line.** Tabs of width 8, K&R braces with a function's opening
  brace on its own line, `/* */` comments, 80 columns preferred.
- **The learner writes the code.** Claude runs in tutor mode: it asks how the learner will approach the
  problem, explains, and points at `code/docs/`; it writes no exercise solution unless explicitly asked.
- **A learning note closes the loop.** What was hard, what the tools caught and what was misunderstood go
  into `learning/`, where the next review session finds them.

## Cross-references

### Governing documents

- `code/docs/C-CODING-PRINCIPLES.md` — kernel coding style, error handling and C17 conventions
- `code/docs/BUILD.md` — the six make targets and every flag behind them
- `code/docs/TESTING.md` — `check.h` and the test discipline
- `code/docs/MEMORY-SAFETY.md` — who allocates, who frees, bounds and strings

### Related reading

- `code/src/c/ms001-hello/` — the reference exercise whose layout a new one copies
- `code/src/c/CONTEXT.md` — the C track's tree, where each new exercise is listed
- `code/workflows/02-tdd-cycle/` — the red → green → refactor loop used in Steps 3–4
- `code/workflows/06-memory-check/` — how to read what `san`, `memcheck` and `lint` report
- `project-management/workflows/04-exercise-design/` — writes the spec this workflow consumes
- `project-management/workflows/10-study-and-build/` — the planning-side step that enters this workflow
- `project-management/src/08-DECISIONS/ADR-MS001-C-STANDARD-C17-27-09-2026.md` — why C17
- `project-management/src/08-DECISIONS/ADR-MS001-C-CODING-STYLE-LINUX-KERNEL-27-09-2026.md` — why kernel
  style from day one
- `learning/CONTEXT.md` — where the learning note goes and its layout
