# Workflow: Debug

**Last Updated**: 27/09/2026

A fix without a failing test first is a guess that happens to pass today. This workflow owns the path from
"it's wrong" to a proven fix — reproduce, shrink, pin with a test, then change as little as possible — and
leaves a BUG record so the lesson is not lost with the session.

## Directory Tree

```text
code/workflows/07-debug/
├── CONTEXT.md · CLAUDE.md   ← orientation (this file) · operating rules for the workflow
├── STEPS.md                 ← ordered steps, each closing on a "Done when" line
└── CHECKLIST.md             ← the gate ticked before the workflow counts as complete
```

## When to use this

- A C or Rust program under `code/src/` gives a wrong result, crashes (segmentation fault, abort, a Rust
  panic) or hangs.
- A sanitiser, valgrind or analyzer finding from `code/workflows/06-memory-check/` needs fixing.
- A test fails, or fails only sometimes.
- When the tool itself misbehaves — gdb cannot attach, valgrind will not start, no core dump appears —
  the route is `how-to/workflows/05-debugging-environment/` first; this workflow picks up once the tools
  work.

## Key concepts

- **Reproduce first.** One command that shows the bug every time, fast. Without it, every later step is
  guesswork and "fixed" cannot be checked.
- **Shrink to the smallest failing case.** Halve the input until the failure stops, then step back; if
  the code used to work, `git bisect run` finds the commit that broke it by binary search over history.
  The smaller the case, the fewer places the cause can hide.
- **The failing test comes before the fix.** It pins the bug, proves the fix and becomes the regression
  test that stops the bug returning. It is `code/workflows/02-tdd-cycle/`'s red phase.
- **Observation over guesswork.** gdb shows what the program is really doing — breakpoints, backtraces,
  variables, watchpoints on a value that changes when it should not. Two or three written hypotheses,
  tested one at a time, beat a dozen edits made at random.
- **Minimal fix.** The smallest change that turns the test green. Tidying the surrounding code waits for
  its own commit, so the fix can be read and reverted on its own.
- **Design problems go to `08-refactor`.** A fix that reveals a deeper structural problem lands first as
  it is; the restructuring follows through `code/workflows/08-refactor/`.
- **The BUG record.** Symptom, reproduction, environment (compiler version, flags, optimisation level),
  root cause with the gdb, valgrind or sanitiser evidence, and the fix — in
  `project-management/src/13-BUGS/`, from `BUG-MS000-TEMPLATE.md`.

## Cross-references

### Governing documents

None — debugging is reactive, so there is no mandatory pre-read before investigating a bug.

### Related reading

- `code/docs/DEBUGGING.md` — gdb, valgrind and core dumps, and `rust-gdb` for Rust
- `code/docs/MEMORY-SAFETY.md` — the bug classes behind most C crashes
- `code/workflows/06-memory-check/` — reading sanitiser, valgrind and analyzer reports
- `code/workflows/02-tdd-cycle/` — the failing test and the green that follows
- `how-to/workflows/05-debugging-environment/` — when the debugging tools themselves need fixing
- `project-management/src/13-BUGS/CONTEXT.md` — sections of the BUG record; its `CLAUDE.md` owns the name
- `code/REFERENCES.md` — the GDB manual, the Valgrind user manual and git-bisect(1)
