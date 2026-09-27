---
type: guide
---

# Testing

**Last Updated**: 27/09/2026 | **Version**: 0.1.0 | **Maintained By**: Sam Bailey
**Language**: British English (en_GB) | **Timezone**: Europe/London

How tests are written here in both languages, and what makes a test worth having. This guide holds the
two harnesses — `check.h` for C and `cargo test` for Rust — the discipline every test follows, and where
coverage fits (it is information, not a gate). The red → green → refactor loop that uses all of this is
a procedure, `code/workflows/02-tdd-cycle/`; the commands that build and run the tests belong to
`code/docs/BUILD.md`.

---

## 1. C — the `check.h` harness

`code/src/c/include/check.h` is a header-only harness: nothing to install and nothing to link. Every
exercise build already has its folder on the include path. Why it is hand-rolled rather than a library is
recorded in `project-management/src/08-DECISIONS/ADR-MS001-C-TEST-HARNESS-CHECK-H-27-09-2026.md` — in
short, reading and writing a harness like it is itself an early lesson in macros, `#` and
`__FILE__`/`__LINE__`.

| Call | Passes when | On failure, prints to stderr |
| --- | --- | --- |
| `CHECK(cond)` | `cond` is non-zero | `file:line: CHECK(cond) failed` |
| `CHECK_EQ_INT(actual, expected)` | the two are equal, compared as `long long` | `... failed: got <actual>, expected <expected>` |
| `CHECK_STR_EQ(actual, expected)` | `strcmp` finds them equal; two `NULL`s are equal, `NULL` and a string are not | `... failed: got "<actual>", expected "<expected>"` |
| `check_summary()` | — | prints `check: N passed, M failed` to stdout and returns `0` if every check passed, `1` if any failed **or none ran** |

- **Argument order is always (actual, expected)**, so a failure reads "got what the code did, expected
  what the test wanted".
- **Each macro is an expression** that yields 1 on a pass and 0 on a failure, so a test can stop before
  a later check becomes meaningless: `if (!CHECK(p != NULL)) return;`.
- **Each argument is evaluated once** — the macros pass their arguments to functions.
- **Compare a size with `CHECK`, not `CHECK_EQ_INT`.** `CHECK_EQ_INT` converts both arguments to
  `long long`, and under `-Wconversion` a run-time `size_t` such as `strlen(buf)` fails to compile
  (`-Werror=sign-conversion`). Write `CHECK(strlen(buf) == 5)` instead; a cast to `long long` only to
  quieten the warning is the silencing `code/src/c/CLAUDE.md` rules out. The price is a failure message
  that shows the expression but not the value.
- **Failures print as `file:line:`**, the same shape as a compiler diagnostic, so an editor can jump to
  the line.

The shape of a test file — one behaviour per function, `main()` runs them all and returns the summary as
the exit status that `make test` reads:

```c
// SPDX-License-Identifier: GPL-2.0-only
#include "check.h"
#include "clamp.h"

/* A value inside the range comes back unchanged. */
static void test_clamp_inside(void)
{
	CHECK_EQ_INT(clamp(5, 0, 10), 5);
}

/* The boundaries themselves are inside the range. */
static void test_clamp_edges(void)
{
	CHECK_EQ_INT(clamp(0, 0, 10), 0);
	CHECK_EQ_INT(clamp(10, 0, 10), 10);
}

/* Below and above are pulled to the nearest edge. */
static void test_clamp_outside(void)
{
	CHECK_EQ_INT(clamp(-3, 0, 10), 0);
	CHECK_EQ_INT(clamp(42, 0, 10), 10);
}

int main(void)
{
	test_clamp_inside();
	test_clamp_edges();
	test_clamp_outside();
	return check_summary();
}
```

A test file is named `test_<unit>.c` and listed in the exercise Makefile's `TEST_SRCS`; each becomes its
own binary, `build/test_<unit>`. `code/src/c/ms001-hello/test_greet.c` is the worked example: one test
function per clause of the contract in `greet.h`.

---

## 2. Rust — `cargo test`

Cargo runs three kinds of test, and they see different things:

| Kind | Lives in | Can see | Good for |
| --- | --- | --- | --- |
| Unit | a `#[cfg(test)] mod tests` at the foot of the file it tests | private items too (`use super::*;`) | the details of one module |
| Integration | `tests/*.rs`; each file is compiled as a separate crate | only the `pub` API, as a real caller would | the contract |
| Doc | examples in `///` comments of a library crate | only the `pub` API | examples that cannot go stale |

```rust
#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn empty_name_greets_the_world() {
        assert_eq!(greet(""), "Hello, world!");
    }
}
```

Run from inside `code/src/rust/` (`code/docs/BUILD.md` Section 5 says why):

```bash
cargo test                          # every crate: unit, integration and doc tests
cargo test -p ms001_hello           # one crate
cargo test greets                   # only tests whose name contains "greets"
cargo test --test greet             # one integration file, tests/greet.rs
cargo test -- --nocapture           # show println! output from passing tests too
```

- **Assertions:** `assert!(cond)`, `assert_eq!(left, right)` and `assert_ne!`, each with an optional
  message. A test can also return `Result<(), E>` and use `?`.
- **`unwrap()` is fine inside tests** — `code/src/rust/clippy.toml` allows it there, because a panic is
  exactly how a test reports failure (`code/docs/RUST-CODING-PRINCIPLES.md` Section 2).
- **`#[should_panic(expected = "...")]`** tests that an invariant check really fires; the `expected`
  text stops the test passing on the wrong panic.
- **Logic belongs in `src/lib.rs`.** Integration tests cannot reach code in `src/main.rs`.

The script is `code/src/scripts/rust/test.sh`; `--crate ms001_hello` narrows it to one crate.

---

## 3. Test discipline

These rules decide _what_ to test and _how_ to assert. They apply to both languages.

- **Red before green.** Write the test, run it, and watch it fail **for the right reason**: the failure
  names the missing behaviour, not a compile error in the test. In C that usually means a stub that
  compiles and returns a wrong value, so a `CHECK` fails. A test you have never seen fail has never been
  shown to test anything.
- **Decide the seams first.** Before writing a test, write down what will be tested: the functions a
  header declares, or a crate's `pub` items, and each clause of their contract — the normal case, every
  error case, the boundaries. `greet.h` states four clauses and `test_greet.c` has one test function for
  each.
- **No tautological tests.** The expected value comes from an independent source — a literal worked out
  by hand, the spec, a worked example — never recomputed the way the code computes it.
  `CHECK_EQ_INT(greet(buf, 14, "world"), 13)` is independent: 13 was counted by hand. Checking the
  result against `strlen("Hello, ") + strlen(name) + 1` repeats the implementation's arithmetic, and
  passes with the same off-by-one.
- **Assert through the public interface.** Check return values, output buffers, files written and exit
  statuses — never a `static` variable or a helper reached by `#include`-ing a `.c` file. Tests written
  this way survive every refactor that keeps the behaviour (`code/workflows/08-refactor/`).
- **Test the edges C makes dangerous.** `NULL` pointers, zero lengths, a buffer exactly full, one byte
  short, `INT_MAX`, the empty string. Off-by-one errors live on the boundary, so test both sides of it.
- **Deterministic and independent.** No dependence on the clock, a random seed, the order tests run in,
  or files left behind by another test.
- **Passing includes clean.** For C, a run that passes its checks but leaks, reads uninitialised memory
  or trips UBSan has not passed. `make san` and `make memcheck` run the same test binaries under the tools
  (`code/docs/MEMORY-SAFETY.md`).

---

## 4. Coverage — information, not a gate

There is no coverage floor and no coverage gate. Coverage shows which lines never ran, which is useful
for finding an untested branch and useless as a score: a line can run under a test that checks nothing
about it. If a floor is ever introduced, it is decided and recorded here and nowhere else.

**C, with gcc and gcov** (lcov and gcovr are not installed; there is no make target for this):

```bash
cd code/src/c/ms001-hello
mkdir -p build/cov
gcc -std=c17 -g -O0 --coverage -I../include -c greet.c -o build/cov/greet.o
gcc -std=c17 -g -O0 --coverage -I../include -c test_greet.c -o build/cov/test_greet.o
gcc --coverage build/cov/greet.o build/cov/test_greet.o -o build/cov/test_greet
./build/cov/test_greet
gcov -t -b -o build/cov greet.c | less
```

- **`--coverage`** means `-fprofile-arcs -ftest-coverage` when compiling and `-lgcov` when linking (gcc
  manual). Compiling writes a `.gcno` beside each object; running the program writes the `.gcda` counts.
- **`gcov -o build/cov greet.c`** finds both by the object directory. **`-t`** prints the annotated source
  to the terminal instead of leaving a `greet.c.gcov` file in the exercise folder, and **`-b`** adds
  branch counts. Lines marked `#####` never ran.
- Everything stays inside the gitignored `build/`, and `make clean` removes it.

**Rust**: no coverage tool is configured, and cargo has no built-in coverage report.

---

## 5. Where tests run

| Where | C | Rust |
| --- | --- | --- |
| By hand, while learning | `make test` in the exercise folder | `cargo test` in `code/src/rust/` |
| The gate script | `code/src/scripts/c/test.sh` | `code/src/scripts/rust/test.sh` |
| Under the memory tools | `make san`, `make memcheck` | — |
| CI | `Syntax — C` | `Syntax — Rust` |

---

## Cross-references

- `code/workflows/02-tdd-cycle/` — the red → green → refactor procedure
- `code/docs/BUILD.md` — the targets that build and run the test binaries
- `code/docs/MEMORY-SAFETY.md` — why "passing" includes the sanitiser and valgrind runs
- `code/src/c/include/check.h` — the harness itself, with its own usage comment
- `code/src/rust/crates/ms001_hello/` — unit, integration and doc tests in one small crate
- `code/REFERENCES.md` — the Rust Book's testing chapter and the gcov manual

_Part of the `code/docs/` documentation family._
