@./CONTEXT.md

# CLAUDE.md — code/workflows/02-tdd-cycle/

Read order: `.claude/CLAUDE.md` → `.claude/MEMORY.md` → this folder's `CONTEXT.md` (red → green → refactor,
the harnesses, what makes a test honest — imported above) → this file → `STEPS.md` then `CHECKLIST.md`.

## Purpose (one line)

The test-driven loop every build workflow uses: write a failing contract-level test, write the minimum
code to pass it, then tidy with the suite green throughout.

## How to work here

- **Routing:** run `STEPS.md` in order against `CHECKLIST.md`, usually from inside `01-c-exercise`,
  `03-rust-exercise`, `04-ffi-bridge` or `07-debug`. Harness details live in `code/docs/TESTING.md`.
- **Tutor mode:** ask the learner to list the cases first — normal, boundary, error — and where each
  expected value comes from. Explain `check.h` or `#[test]` mechanics when asked; the learner writes the
  tests and the implementation. When a test looks tautological, ask where its expected value came from
  rather than rewriting it.
- **Concrete steps:** agree the cases and their oracle → write the tests and a wrong-value stub → run
  and see every new test red for the expected reason → write the minimum code → run and see green →
  refactor with a run after each change → break the code on purpose to prove a test catches it → revert.
- **Definition of done:** every new test was seen red before green; all tests green; `make lint` or
  `cargo clippy` clean; the mutation check turned at least one test red; no stubs left.

## Guardrails

- **See red before writing the implementation.** A test that passes before the code exists is testing the
  wrong thing or nothing.
- **Take expected values from an independent source.** A literal, the spec, a man page or a hand
  calculation — never the code's own formula.
- **Assert through the public interface.** Include the exercise header in C; use only `pub` items from
  `tests/` in Rust.
- **Change no test in the refactor phase** unless the public contract itself changed — and then it was not
  a refactor.
- **Keep the learner's hands on the keyboard.** Claude does not write the tests or the implementation for
  an exercise unless explicitly asked.

## Output & naming

- **Produced by following it:** C tests as `test_<name>.c` in the exercise folder, listed in the Makefile's
  `TEST_SRCS`; Rust unit tests in `#[cfg(test)] mod tests` and integration tests as
  `code/src/rust/crates/msNNN_<snake>/tests/<name>.rs`.
- Test names read as sentences (`rejects_null_name`, `truncates_when_buffer_too_small`); a failure states
  expected versus actual.
- Workflow files `SCREAMING-SNAKE-CASE.md`, frontmatter `workflow: 02-tdd-cycle`, `phase: build`.
