# ADR-MS001: C test harness — a hand-rolled, header-only `check.h`

| Field | Value |
| --- | --- |
| **ID** | ADR-MS001-C-TEST-HARNESS-CHECK-H |
| **Status** | Accepted |
| **Date** | 27/09/2026 |
| **Milestone** | MS001 — Toolchain ready · `project-management/src/02-MILESTONES/MS001-TOOLCHAIN-READY.md` |
| **Deciders** | Sam Bailey |
| **Supersedes** | — |
| **Superseded by** | — |
| **Research** | — (primary sources cited below) |
| **Enforced in** | `code/src/c/include/check.h` · documented in `code/docs/TESTING.md` |

---

## Context

This is one of five scaffold defaults accepted on 27/09/2026 together with the repository skeleton,
before the first exercise was written. It records the choice and the evidence available that day.
Like every Accepted ADR it is immutable: adopting a test library later means a new ADR that
supersedes this one, and this record stays as written.

Every C exercise is test-first (`code/workflows/02-tdd-cycle/`). Its `test_*.c` files link against
the exercise's own code, run a set of checks, and exit non-zero on any failure, so `make test`
fails. The same test binaries are then run under AddressSanitizer and UndefinedBehaviorSanitizer
(`make san`) and under valgrind (`make memcheck`), so the harness is part of what those tools
observe. The build is strict ISO C17 with `-Wpedantic -Werror`
(`project-management/src/08-DECISIONS/ADR-MS001-C-STANDARD-C17-27-09-2026.md`).

Facts checked on 27/09/2026:

- **No C test framework is installed.** Check, cmocka and Criterion are all absent; Ubuntu 24.04
  packages them (`check` 0.15.2, `libcmocka-dev` 1.1.7, `libcriterion-dev` 2.4.1). Unity
  (ThrowTheSwitch) is not an Ubuntu package at all — it is used by copying its source into a project.
  (The Ubuntu package named `libunity-dev` is an unrelated desktop library.)
- **Licences, against this repository's GPL-2.0-only:** Unity and Criterion are MIT; Check is
  LGPL-2.1; cmocka is Apache-2.0. The Apache Software Foundation's own compatibility page records that
  the FSF has never considered Apache 2.0 compatible with GPL version 2, so cmocka's source cannot be
  vendored into this repository.
- **Process isolation changes how the memory tools are used.** Check forks each test into its own
  process by default; its manual recommends `CK_FORK=no` when running under valgrind or a debugger.
  Criterion runs tests in separate worker processes and its documentation requires
  `valgrind --trace-children=yes`. A single-process test binary needs neither.
- **Kernel testing, later:** the kernel has its own in-kernel framework, KUnit, which runs tests under
  User Mode Linux or QEMU through `tools/testing/kunit/kunit.py`. Nothing chosen here carries into
  kernel code directly; the habits (small checks, clear failure messages, one command to run them) do.

## Options considered

### Option A — A hand-rolled, header-only harness

- **Summary:** `code/src/c/include/check.h` provides `CHECK(cond)`, `CHECK_EQ_INT(a, b)`,
  `CHECK_STR_EQ(a, b)` and `check_summary()`, which prints the pass and fail counts and returns 0 or 1
  for `main` to return. A test file includes it, calls its test functions from `main`, and returns
  `check_summary()`.
- **Pros:** Zero dependencies on the host, in CI and for anyone cloning the repository. Short enough
  to read in one sitting, and reading it is a P1 lesson in its own right: macros, the `#` stringising
  operator, `__FILE__` and `__LINE__`, `static inline` functions in a header. One process, so ASan,
  UBSan, valgrind and gdb see the test code directly with no fork to follow. Compiles under the
  strict C17 build like any other file. GPL-2.0-only by being part of the repository.
- **Cons:** No automatic test discovery (every test function is called by hand from `main`), no
  fixtures, no mocking, no per-test isolation (a crash ends the whole test binary), no TAP or JUnit
  output. Being header-only, its counters live in the translation unit that includes it, so each test
  binary keeps its checks in one test source file. The learner maintains it.

### Option B — Check (libcheck)

- **Summary:** Link every test binary against the Check library; suites, test cases and a runner.
- **Pros:** Mature. Forks each test so one crash does not stop the suite. Timeouts, and TAP/XML
  output. LGPL-2.1, so linking is compatible.
- **Cons:** Not installed; a library dependency for every exercise, locally and in CI. The fork
  default has to be switched off (`CK_FORK=no`) for valgrind and debugging. Suite/runner boilerplate
  is heavy for exercises with a handful of checks.

### Option C — cmocka

- **Summary:** A small framework with built-in mocking (`will_return`, `mock()`).
- **Pros:** Mocking of dependencies, which matters for code that calls the system. Single process.
- **Cons:** Not installed. Apache-2.0, which cannot be vendored into a GPL-2.0-only repository, so it
  would stay a system dependency. Mocking is not needed until P2, if at all.

### Option D — Criterion

- **Summary:** Tests declared with a `Test(suite, name)` macro, registered automatically; Criterion
  supplies `main`.
- **Pros:** The least boilerplate. Parameterised tests. Per-test isolation. MIT.
- **Cons:** Not installed. Automatic registration and a supplied `main` hide how a test runner works —
  the opposite of what P1 teaches. Worker processes mean `--trace-children=yes` for every valgrind run.

### Option E — Unity (ThrowTheSwitch), vendored

- **Summary:** Copy Unity's single `.c` file and its headers into the repository.
- **Pros:** MIT, so vendoring is compatible. No system package. A rich set of assertion macros;
  single process.
- **Cons:** Third-party code in the tree with its own notices and update burden. Its optional test
  runner generator is a Ruby script, a new tool. Far more API than an exercise with five checks
  needs.

## Decision

**We will take Option A: a hand-rolled, header-only `check.h`.** The deciding factor is that the
harness costs nothing to install and is itself something the learner can read and explain, while
keeping each test a single process that the sanitisers, valgrind and gdb observe without special
flags. Options B and D solve problems these exercises do not have yet (isolation, discovery) and
complicate the memory tools that every milestone relies on. Option C cannot be vendored under the
repository's licence. Option E is the closest alternative, and the one to reach for first if the
harness is outgrown.

This answer changes when an exercise genuinely needs what the harness lacks — mocking of system calls
in P2, per-test isolation for code that is expected to crash, or machine-readable output for CI.
That need is argued in a new ADR that supersedes this one.

## Consequences

- **Positive:** `make test`, `make san` and `make memcheck` run the same simple binaries with no extra
  configuration. Nothing to install beyond gcc, make and valgrind. A failure prints a compiler-style
  `file:line:` message that an editor can jump to.
- **Negative:** Each test function is called explicitly from `main`, so a forgotten call is a test that
  never runs; `code/workflows/05-review/` checks for it. No mocking: P2 code that calls the system is
  tested through its real behaviour or through small seams the learner designs.
- **Follow-on:** `code/docs/TESTING.md` owns how tests are written and named. Growing `check.h` (a new
  `CHECK_*` macro) is ordinary work, not a new decision. At P4, kernel-side tests use KUnit inside
  QEMU, decided when kernel work starts.

## Sources

- **Check manual, No Fork Mode and environment variables** —
  <https://libcheck.github.io/check/doc/check_html/check_4.html> — fork-per-test default, `CK_FORK=no`
  for valgrind; licence LGPL-2.1 per <https://github.com/libcheck/check>, checked 27/09/2026
- **cmocka** — <https://cmocka.org/> — mocking support; "License: Apache License 2.0", checked
  27/09/2026
- **Apache Software Foundation, GPL compatibility** — <https://www.apache.org/licenses/GPL-compatibility.html>
  — the FSF does not consider Apache 2.0 compatible with GPLv2, checked 27/09/2026
- **Criterion** — <https://github.com/Snaipe/Criterion> — automatic registration, default entry point,
  per-test processes, `--trace-children=yes` for valgrind (its `doc/debug.rst`); licence MIT, checked
  27/09/2026
- **Unity (ThrowTheSwitch)** — <https://github.com/ThrowTheSwitch/Unity> — one C file and a pair of
  headers, optional Ruby runner generator; licence MIT, checked 27/09/2026
- **KUnit** — <https://docs.kernel.org/dev-tools/kunit/index.html> — the kernel's unit-test framework,
  run under UML or QEMU, checked 27/09/2026
