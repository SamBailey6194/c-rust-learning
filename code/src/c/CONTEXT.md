# code/src/c/ — The C Track

**Last Updated**: 27/09/2026

Every C exercise in the repository, and the one build system they share. The build is plain GNU make,
the language is ISO C17, the style is the Linux kernel's, and the tests use a header-only harness —
four decisions recorded as ADRs in `project-management/src/08-DECISIONS/`. The build rules are written
once, in `mk/`; an exercise's own `Makefile` only names its program, its sources and its tests. That
keeps each exercise small enough to read in one sitting, and it means every exercise is held to the
same warnings, sanitisers, valgrind run and static analysis without restating a single flag.

## Directory Tree

```text
code/src/c/
├── CONTEXT.md · CLAUDE.md   ← this file · how to work on the C track
├── Makefile                 ← runs one target in every ms###-*/ folder with a Makefile, stopping at the first failure
├── mk/                      ← shared make includes (covered by this pair)
│   ├── flags.mk             ← CC, CSTD, WARN, DBG, SAN, SAN_HALT, ANALYZE, DEPFLAGS, VALGRIND_FLAGS
│   └── exercise.mk          ← the six targets and every build rule; each exercise includes it
├── include/                 ← headers shared by every exercise (covered by this pair)
│   └── check.h              ← CHECK, CHECK_EQ_INT, CHECK_STR_EQ and check_summary()
└── ms001-hello/             ← MS001 — greet() into a caller's buffer with snprintf, and its tests
```

## Targets

The same six targets work at two levels: `make -C code/src/c <target>` runs the target in every
exercise, in name order; `make -C code/src/c/ms001-hello <target>` runs it in one.

| Target | What it does | Output |
| --- | --- | --- |
| `all` (default) | Builds the program and every test binary with `-std=c17`, the full warning set and `-Werror` | `build/` |
| `test` | Builds, then runs each `build/test_*`; the first failure stops the run | `build/` |
| `san` | Rebuilds with AddressSanitizer + UBSan (recovery off, so a report fails the run) and runs the tests | `build/san/` |
| `memcheck` | Runs the plain `build/test_*` binaries under valgrind; any error or leak of any kind fails | `build/` |
| `lint` | Compiles every source and test with `-fanalyzer`, gcc's static analyser | `build/lint/` |
| `clean` | Deletes the exercise's `build/` | — |

`san` and `memcheck` use separate builds on purpose: AddressSanitizer and valgrind both take over memory
allocation, and a sanitised binary does not run cleanly under valgrind. Why each flag is set is written
beside it in `mk/flags.mk`; the full reasoning is `code/docs/BUILD.md`.

## Exercises

| Exercise | Milestone | Practises |
| --- | --- | --- |
| `ms001-hello/` | MS001 — Toolchain ready | a header/source split, a caller-owned buffer, `snprintf` truncation, `argc`/`argv`, `check.h` tests |

An exercise's number is its milestone's (`code/src/CLAUDE.md` → Output & naming), so several exercises
can share one; existing folders keep their numbers.

## Anatomy of an exercise

An exercise is a flat folder — no `src/` or `tests/` sub-folders — holding its pair, a `Makefile` that
sets three variables, and its sources:

| File | Role |
| --- | --- |
| `Makefile` | Sets `PROG`, `SRCS` and `TEST_SRCS`, then `include ../mk/exercise.mk` |
| `<name>.h` / `<name>.c` | The code under test: declarations, then the implementation |
| `main.c` | The program's `main()`; the file named by `MAIN` (default `main.c`) |
| `test_<name>.c` | A test program: one `build/test_<name>` binary, linked against every `SRCS` file except `MAIN` |

Header dependencies are tracked automatically (`-MMD -MP`), so editing a header rebuilds every object
that includes it, and editing `mk/flags.mk` rebuilds everything.

## Cross-references

- `code/docs/BUILD.md` — every flag and target, and the reasoning behind them
- `code/docs/C-CODING-PRINCIPLES.md` — the Linux kernel coding style as applied here
- `code/docs/TESTING.md` — how to write tests with `check.h`
- `code/docs/MEMORY-SAFETY.md` and `code/docs/DEBUGGING.md` — reading sanitiser, valgrind and gdb output
- `code/workflows/01-c-exercise/` — the procedure that adds an exercise here
- `code/src/scripts/c/` — the gate scripts wrapping each target (`code/src/scripts/CONTEXT.md`)
- `project-management/src/08-DECISIONS/ADR-MS001-C-STANDARD-C17-27-09-2026.md`,
  `ADR-MS001-C-CODING-STYLE-LINUX-KERNEL-27-09-2026.md`, `ADR-MS001-BUILD-SYSTEM-GNU-MAKE-27-09-2026.md`,
  `ADR-MS001-C-TEST-HARNESS-CHECK-H-27-09-2026.md` — the four decisions this track is built on
