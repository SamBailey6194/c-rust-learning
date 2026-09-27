# Workflow: TDD Cycle

**Last Updated**: 27/09/2026

Red before green is the whole point: a test written after the code tends to assert whatever the code
already does, bugs included. This workflow keeps red, green and refactor as three separate, checkable
phases, with `check.h` in C and `cargo test` in Rust.

## Directory Tree

```text
code/workflows/02-tdd-cycle/
├── CONTEXT.md · CLAUDE.md   ← orientation (this file) · operating rules for the workflow
├── STEPS.md                 ← ordered steps, each closing on a "Done when" line
└── CHECKLIST.md             ← the gate ticked before the workflow counts as complete
```

## When to use this

- Inside every build workflow: the test-and-implement steps of `code/workflows/01-c-exercise/`,
  `03-rust-exercise/` and `04-ffi-bridge/` are this cycle.
- In `code/workflows/07-debug/`, where the failing regression test is this workflow's red phase.
- In `code/workflows/08-refactor/`, where the suite this cycle produced is the fixed point.
- On its own, for any change to a function's behaviour in `code/src/`.

## Key concepts

- **Red.** A test states the contract through the public interface — the return value, the bytes written
  to an output buffer, the error return — and fails before the implementation exists. In C, a test that
  fails only because a symbol is missing has not yet run an assertion; a stub that returns a value no test
  expects lets `check.h` run and print the expected-versus-actual failure. In Rust the stub returns a
  wrong value rather than calling `todo!()`, for the same reason. An error case whose expected value the
  stub happens to return (a `-1` test against a `-1` stub) is green by coincidence, and the mutation
  check is where it proves itself.
- **Green.** The minimum implementation that turns every test green. A real edge case found while
  building earns a new test; a line that no test reaches is not a reason to write one.
- **Refactor.** Tidy names, duplication and function length with the suite green after every change.
  Tests that assert outcomes rather than internals need no edits in this phase.
- **No tautological tests.** The expected value comes from an independent source — the spec's worked
  example, a man page, the C standard, a hand calculation, a literal — rather than being recomputed the way
  the code computes it. `CHECK_STR_EQ(buf, "Hello, Sam!")` is a test; building the expected string with the
  same `snprintf` call the code uses is a tautology.
- **Assert through the public interface.** C tests include the exercise header and call what it
  declares; Rust integration tests in `tests/` see only `pub` items. Tests pinned to internals break on
  every refactor and prove little.
- **The harnesses.** `code/src/c/include/check.h` provides `CHECK(cond)`, `CHECK_EQ_INT(a, b)`,
  `CHECK_STR_EQ(a, b)` and `check_summary()`, which prints pass and fail counts and returns 0 or 1 for
  `main` to return. Rust uses `#[test]` functions with `assert!` / `assert_eq!`, unit tests in a
  `#[cfg(test)] mod tests` beside the code and integration tests in the crate's `tests/`.
- **Mutation check.** Breaking the implementation on purpose (flip a comparison, shift a bound by one) and
  watching at least one test go red is the cheapest proof that the tests test something.

## Cross-references

### Governing documents

- `code/docs/TESTING.md` — test discipline (independent oracle, public interface), `check.h` and
  `cargo test` usage
- `code/docs/BUILD.md` — the `make test` target and the flags the test binaries build with

### Related reading

- `code/src/c/ms001-hello/` — `test_greet.c` shows normal, NULL, zero-length and truncation cases
- `code/src/rust/crates/ms001_hello/` — unit tests beside the code plus `tests/greet.rs`
- `code/docs/CODING-PRINCIPLES.md` — what the refactor phase aims at
- `project-management/src/08-DECISIONS/ADR-MS001-C-TEST-HARNESS-CHECK-H-27-09-2026.md` — why a hand-rolled
  header rather than a test library
- `code/workflows/06-memory-check/` — a green test run is not yet a memory-clean one
