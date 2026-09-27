---
workflow: 02-tdd-cycle
phase: build
skills: [teach]
---

# TDD Cycle — Steps

**Last Updated**: 27/09/2026 | **Version**: 0.1.0 | **Maintained By**: Sam Bailey
**Language**: British English (en_GB) | **Timezone**: Europe/London

---

## Key references

Consult `code/REFERENCES.md` for the external sources (GCC, GNU make, the Rust Book's testing chapter) as
you work through these steps:

| Step | Section |
| --- | --- |
| All | `code/docs/TESTING.md` — test discipline, `check.h`, `cargo test` |
| 1 | The exercise's `EX-MS###-<TOPIC>.md` spec in `project-management/src/04-EXERCISES/` — the oracle |
| 2–3 | `code/src/c/include/check.h` and `code/src/c/ms001-hello/test_greet.c` — the C pattern |
| 2–3 | `code/src/rust/crates/ms001_hello/` — the Rust pattern (unit tests plus `tests/greet.rs`) |
| 4 | `code/docs/BUILD.md` — `make test` and the flags test binaries build with |
| 5 | `code/docs/CODING-PRINCIPLES.md` — what tidying aims at |

---

## Steps

### Step 1 — Agree the cases and where each answer comes from

Ask the learner to list the behaviours to pin before any test is written, in three groups: normal inputs,
boundaries (empty, zero, maximum, exactly-fits), and errors (NULL, too small, invalid). For each case, ask
where the expected value comes from — the spec's worked example, a man page, the C standard, a hand
calculation. A case whose answer can only be found by running the code is not ready to be a test.

_Done when every case has an input, an expected result and a named source for that result._

---

### Step 2 — Red: write the tests and a wrong-value stub

**C.** Declare the function in the exercise header (the contract), write `test_<name>.c` that includes
it and `check.h`, and give the implementation a stub that returns a value no test expects (`0` here):

```c
#include "check.h"
#include "greet.h"

int main(void)
{
	char buf[32] = { 0 };

	CHECK_EQ_INT(greet(buf, sizeof(buf), "Sam"), 11);
	CHECK_STR_EQ(buf, "Hello, Sam!");
	CHECK_EQ_INT(greet(NULL, sizeof(buf), "Sam"), -1);
	return check_summary();
}
```

The example shows the shape using `ms001-hello`'s contract; the learner's cases come from Step 1.
`check.h` macros take `(actual, expected)` in that order. The buffer starts zeroed, so checking it after a
stub that wrote nothing reads a defined empty string rather than uninitialised memory. The stub casts
each unused parameter to `(void)`, because `-Wextra -Werror` rejects unused parameters and the stub would
not even compile. A case whose expected value the stub happens to return stays green now; note it, and
let Step 6 prove it.

**Rust.** Unit tests go in a `#[cfg(test)] mod tests` beside the code, integration tests in the crate's
`tests/` folder using only `pub` items; the stub returns a wrong value (an empty `String`, `None`), not
`todo!()`, so the failure prints expected versus actual.

_Done when every case from Step 1 has an assertion and the code compiles against the stub._

---

### Step 3 — Run the suite and confirm red for the right reason

```bash
make -C code/src/c/msNNN-<kebab> test            # C: expect "failed: got ..." lines; make exits 2
(cd code/src/rust && cargo test -p msNNN_<snake>)   # Rust: failed tests with left/right values; exit 101
```

The raw tools use their own exit codes: the C test binary exits 1 and make, stopping on it, exits 2;
`cargo test` exits 101. The scripts `bash code/src/scripts/c/test.sh --path msNNN-<kebab>` and
`bash code/src/scripts/rust/test.sh --crate msNNN_<snake>` wrap the same runs and map a failure to 1,
keeping 2 for "could not run".
Read each failure: it names the assertion and shows the wrong value the stub returned. A test that is
green now, other than a noted coincidence, is testing the wrong thing or nothing — fix the test before
going on.

Do not proceed to Step 4 until every new test is red for the reason Step 1 predicted, apart from any
case noted as green by coincidence.

_Done when every new test fails on its assertion (not on a compile or link error), or is noted as green by
coincidence._

---

### Step 4 — Green: write the minimum implementation

The learner replaces the stub with the smallest code that satisfies the tests — no extra options, no
speculative generality. Under `-Werror` a compiler warning already stops the build, so a clean build is
part of green. Re-run the Step 3 commands until everything passes.

An edge case discovered while building gets a new test first (back to Step 2 for that case), then code.

_Done when every test passes and the build prints no warnings._

---

### Step 5 — Refactor with the suite green

Tidy names, remove duplication, shorten long functions and flatten deep nesting — one change at a time,
re-running the tests after each. Then run the linters:

```bash
make -C code/src/c/msNNN-<kebab> lint                                     # C: gcc -fanalyzer
(cd code/src/rust && cargo fmt --check && cargo clippy --all-targets -- -D warnings)
```

Scripts: `bash code/src/scripts/c/lint.sh --path msNNN-<kebab>`, `bash code/src/scripts/rust/lint.sh`. For a larger
restructure, switch to `code/workflows/08-refactor/`.

_Done when the tests are unchanged, still green, and the linters are clean._

---

### Step 6 — Prove the tests can fail

Make one deliberate mutation in the implementation — flip a comparison, change a bound by one, return
early on the error path — and re-run the tests. At least one must go red. Undo the mutation and re-run;
`git diff` confirms none of it remains. If nothing went red, a case is missing: go back to Step 1.

_Done when a mutation was caught and the code is back to its green state._

---

## Update context files

If this cycle created files or folders:

1. Add each new test file to the directory tree in the exercise's or crate's `CONTEXT.md`.
2. Add any new test source cited by the spec to `code/REFERENCES.md`.
3. Refresh `**Last Updated**` in every `CONTEXT.md` you modified.
4. If the session ends before Completion, run `/handoff` to write
   `handoffs/HANDOFF-<SCREAMING-KEBAB-DESCRIPTOR>-DD-MM-YYYY.md`.

---

## Completion

Run through `CHECKLIST.md` before marking this workflow complete, then return to the workflow that
called this one.
