@./CONTEXT.md

# CLAUDE.md — code/src/c/ms001-hello/

Read order: `.claude/CLAUDE.md` → `.claude/MEMORY.md` → `code/src/c/CONTEXT.md` → this folder's
`CONTEXT.md` (the objective, the `greet()` contract and the concepts practised, imported above) → this
file.

## Purpose (one line)

The first C exercise: a worked example of a small C function contract, built and tested under every
gate, that the learner reads, runs, breaks on purpose and extends.

## How to work here

- **Routing:** this folder ships solved, as the toolchain proof for MS001. The learner's work here is
  reading, running and extending it; a new exercise gets its own folder through
  `code/workflows/01-c-exercise/`.
- **Tutor mode:** before any explanation, ask what the learner expects to happen — for example, what
  `greet(buf, 13, "world")` returns and what `buf` then holds — and let them check the answer by running
  the tests. Point at `code/docs/` sections instead of re-explaining in full; do not write the extension
  tasks below for the learner unless they explicitly ask.
- **Commands — the raw ones first:**

  ```bash
  make -C code/src/c/ms001-hello             # build build/hello and build/test_greet
  ./code/src/c/ms001-hello/build/hello       # Hello, world!
  ./code/src/c/ms001-hello/build/hello Sam   # Hello, Sam!
  make -C code/src/c/ms001-hello test        # run the tests
  make -C code/src/c/ms001-hello san         # the tests under AddressSanitizer + UBSan
  make -C code/src/c/ms001-hello memcheck    # the tests under valgrind
  make -C code/src/c/ms001-hello lint        # gcc -fanalyzer over every file
  gdb -q code/src/c/ms001-hello/build/hello  # step through main() and greet()
  ```

  Verification uses the wrappers: `bash code/src/scripts/c/test.sh --path ms001-hello` (and `san.sh`,
  `memcheck.sh`, `lint.sh`).
- **Break it on purpose:** each gate is easier to trust once it has been seen to fail. Suggested, one
  at a time and reverted afterwards: change `>= len` to `> len` in `greet.c` (which test catches it?);
  add a `malloc` with no `free` (what do `san` and `memcheck` say?); assign an `int` to a `char` in
  `main.c` (what does `-Wconversion` report?).
- **Extension tasks for the learner:** test what `greet()` does with an empty name; make `main.c` greet
  every argument, not only the first; give `hello` a name longer than its 64-byte buffer and decide
  what the program ought to do.
- **Concrete steps for a change:** learner writes the failing test in `test_greet.c` → learner changes
  the code → `make test` → `make san` → `make memcheck` → `make lint` → update this folder's
  `CONTEXT.md` if the contract or the check count changed.
- **Definition of done:** all four gates exit 0 with no warnings; `CONTEXT.md` still describes the
  contract the tests check; the Rust twin is updated too if the behaviour both share has changed.

## Guardrails

- **Keep the contract and its tests in step.** `greet.h`'s comment, the `CONTEXT.md` table and
  `test_greet.c` describe one behaviour; a change to any of them is a change to all three.
- **Revert every deliberate breakage.** A "break it on purpose" experiment ends with the gates green
  again before anything is committed.
- **Keep this exercise small.** It exists to prove the toolchain and introduce the build; a larger idea
  becomes a new exercise folder, not a growth of this one.

## Output & naming

- **Hand-written:** `Makefile`, `greet.h`, `greet.c`, `main.c`, `test_greet.c` and this pair.
- **Generated (never hand-edit):** `build/` — `hello`, `test_greet`, objects, `.d` files, `san/`, `lint/`.
- A new test file is `test_<name>.c` and joins `TEST_SRCS`; a new source joins `SRCS`.
