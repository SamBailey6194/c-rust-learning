@./CONTEXT.md

# CLAUDE.md — code/src/c/

Read order: `.claude/CLAUDE.md` → `.claude/MEMORY.md` → `code/src/CONTEXT.md` → this folder's
`CONTEXT.md` (the targets, the exercise list and an exercise's anatomy, imported above) → this file →
the exercise's own `CONTEXT.md` and `CLAUDE.md`.

## Purpose (one line)

The C track: every C exercise, and the shared make build (`mk/`) and test harness (`include/check.h`)
that hold them all to the same gates.

## How to work here

- **Routing:** a new exercise → `code/workflows/01-c-exercise/`; writing its tests →
  `code/workflows/02-tdd-cycle/`; reading a sanitiser or valgrind report → `code/workflows/06-memory-check/`;
  a result nobody can explain → `code/workflows/07-debug/`. Flag and target questions →
  `code/docs/BUILD.md`; style questions → `code/docs/C-CODING-PRINCIPLES.md`.
- **Tutor mode:** ask how the learner plans to approach the exercise before offering anything. Explain
  the concept, ask the guiding question, and point at the `code/docs/` section that answers it; do not
  write the exercise's functions or tests unless the learner explicitly asks. A review names the rule
  and the doc section — it does not rewrite the learner's code.
- **Raw command first, then the script:**

  ```bash
  make -C code/src/c                 # build every exercise (warnings are errors)
  make -C code/src/c test            # ... and run every test binary
  make -C code/src/c san             # tests under AddressSanitizer + UBSan (build/san/)
  make -C code/src/c memcheck        # tests under valgrind (the plain build/)
  make -C code/src/c lint            # gcc -fanalyzer over every source (build/lint/)
  make -C code/src/c/ms001-hello test   # any target, one exercise
  ```

  The same targets through the gate scripts, which Claude uses to verify:
  `bash code/src/scripts/c/{build,test,san,memcheck,lint}.sh [--path ms001-hello]`.
- **Concrete steps:** read the exercise's `CONTEXT.md` → learner writes failing tests in
  `test_<name>.c` → learner implements → `make test` → `make san` → `make memcheck` → `make lint` →
  update this `CONTEXT.md`'s exercise table if an exercise was added.
- **Definition of done:** all five gate scripts exit 0 for the exercise; the build prints no warning
  (there is no such thing as a tolerated one — `-Werror` stops the build); the exercise has its pair;
  the exercise table above lists it.

## Guardrails

- **Change a flag in `mk/flags.mk` or a rule in `mk/exercise.mk`, never in an exercise.** An exercise
  `Makefile` sets `PROG`, `SRCS`, `TEST_SRCS` (and optionally `MAIN`) and includes the shared rules —
  nothing else, so every exercise stays under the same gates.
- **Keep ASan and valgrind apart.** `make san` builds into `build/san/`; `make memcheck` runs the plain
  `build/` binaries. Never run a sanitised binary under valgrind.
- **Write C in the Linux kernel coding style.** Tabs 8 wide, the function's opening brace on its own
  line, `/* */` comments (`code/docs/C-CODING-PRINCIPLES.md`). The first line is the licence tag, in the
  kernel's form: `// SPDX-License-Identifier: GPL-2.0-only` in a `.c` file, `/* ... */` in a header.
- **Treat a warning as a question to answer, not noise to hide.** No `#pragma GCC diagnostic`, no flag
  dropped for one exercise, no cast added only to quieten `-Wconversion`.
- **Keep `check.h` header-only and dependency-free.** A change to it is a change to every exercise's
  tests: run `make -C code/src/c test` across the whole track afterwards.
- **Never commit `build/`.** It is gitignored; `make clean` removes it.

## Output & naming

- **Hand-written:** `Makefile`, `mk/*.mk`, `include/*.h`, and each exercise's pair, `Makefile`, headers,
  sources and `test_*.c`.
- **Generated (never hand-edit):** every exercise's `build/` — objects, `.d` dependency files, binaries,
  and the `san/` and `lint/` sub-builds.
- Exercise folders `msNNN-kebab-name/`, where `NNN` is the milestone number (`code/src/CLAUDE.md` →
  Output & naming owns the rule); never renumber. Test files `test_<name>.c`, one test binary each; C
  files and identifiers `snake_case`.
