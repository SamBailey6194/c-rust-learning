# Workflow: Memory Check

**Last Updated**: 27/09/2026

Memory bugs in C are quiet until they are not: an out-of-bounds write can pass every test and corrupt
something three calls later. Three tools look in three different ways — an instrumented build, an emulated
run and a static analysis — and each catches bugs the other two miss, so code counts as clean only when all
three agree.

## Directory Tree

```text
code/workflows/06-memory-check/
├── CONTEXT.md · CLAUDE.md   ← orientation (this file) · operating rules for the workflow
├── STEPS.md                 ← ordered steps, each closing on a "Done when" line
└── CHECKLIST.md             ← the gate ticked before the workflow counts as complete
```

## When to use this

- Steps 6–8 of `code/workflows/01-c-exercise/`, and the C driver in `code/workflows/04-ffi-bridge/`.
- After any change to C code made through `code/workflows/07-debug/` or `code/workflows/08-refactor/`.
- Before `code/workflows/05-review/`, which expects a memory-clean baseline.
- Whenever a sanitiser, valgrind or analyzer report appears and needs reading.
- When `project-management/workflows/11-verification/` records a milestone's results.

## Key concepts

- **AddressSanitizer + UBSan — `make san`.** gcc instruments every load and store in a separate build under
  `build/san/`. ASan catches heap, stack and global buffer overflows, use after free and double free; its
  LeakSanitizer half reports memory still allocated at exit. UBSan catches undefined behaviour as it
  happens: signed overflow, oversized shifts, out-of-bounds array indexes, null or misaligned pointer use.
- **UBSan carries on by default.** GCC's UBSan runtime prints `runtime error:` and keeps going, so a
  program can exit 0 after a report. The repository builds with `-fno-sanitize-recover=all`
  (`code/src/c/mk/flags.mk`) so the first report is fatal; a binary built by hand needs that flag, or
  `UBSAN_OPTIONS=halt_on_error=1`, to fail the same way.
- **valgrind memcheck — `make memcheck`.** Runs the unmodified plain test binaries on a synthetic CPU. It
  catches invalid reads and writes on the heap, invalid frees, leaks, and the use of uninitialised values,
  which ASan does not detect. It does not bounds-check stack or global arrays — that is ASan's territory.
  The repository counts every leak kind as an error, including blocks still reachable at exit.
- **Separate builds for ASan and valgrind.** The two tools both take over memory allocation, so `san` builds
  into `build/san/` and `memcheck` runs the plain build in `build/`.
- **`-fanalyzer` — `make lint`.** gcc's static analyzer follows paths through the code without running
  it and reports `-Wanalyzer-*` warnings — double free, use after free, leaks, possible NULL arguments —
  each with a CWE number and the numbered chain of events that leads there. It finds paths no test took,
  and it can be wrong; under `-Werror` every warning fails the build either way.
- **Different blind spots, observed.** In a check with gcc 13.3 and valgrind 3.22, a program whose
  `main` still held a pointer to a 40-byte block when it called `exit(0)` passed under LeakSanitizer,
  which ignores a block still reachable at exit. valgrind listed the same block as still reachable, and
  this repository's `--errors-for-leak-kinds=all` made that an error. Neither tool is the whole answer.
- **Clean means all three.** No ASan, LeakSanitizer or UBSan report; valgrind ending
  `ERROR SUMMARY: 0 errors from 0 contexts` with every heap block freed; no analyzer warning.

## Cross-references

### Governing documents

- `code/docs/MEMORY-SAFETY.md` — ownership, bounds and lifetimes in C: what the tools are checking for
- `code/docs/BUILD.md` — the `san`, `memcheck` and `lint` targets and their flags

### Related reading

- `code/docs/DEBUGGING.md` — gdb, valgrind and core dumps when a report needs a closer look
- `code/src/c/mk/flags.mk` — every sanitiser, valgrind and analyzer flag with the reason it is set
- `code/workflows/07-debug/` — where each finding is pinned by a test and fixed
- `how-to/workflows/03-quality-gates/` — the full gate run across the repository
- `how-to/workflows/05-debugging-environment/` — when valgrind or a sanitiser runtime will not start
- `code/REFERENCES.md` — the GCC Instrumentation Options and Static Analyzer Options pages and the
  Valgrind user manual
