---
workflow: 02-tdd-cycle
phase: build
skills: [teach]
---

# TDD Cycle — Checklist

**Last Updated**: 27/09/2026 | **Version**: 0.1.0 | **Maintained By**: Sam Bailey
**Language**: British English (en_GB) | **Timezone**: Europe/London

---

> **See** `code/docs/TESTING.md` (test discipline, harnesses) · `code/src/c/include/check.h` ·
> `code/REFERENCES.md` for supporting references.

## Pre-Conditions

- [ ] The behaviour to build is written down (an `EX-MS###` spec, a bug report, or an agreed change)
- [ ] The existing suite is green before this cycle starts

---

## Execution Checklist

### Step 1 — Agree the cases and where each answer comes from

- [ ] Normal, boundary and error cases listed by the learner
- [ ] Every expected value has a named independent source (spec, man page, standard, hand calculation)

### Step 2 — Red: write the tests and a wrong-value stub

- [ ] Tests call only the public interface (the exercise header, or `pub` items)
- [ ] The stub returns a value no test expects — not a crash, `todo!()` or a missing symbol
- [ ] No expected value is computed with the same logic the code uses

### Step 3 — Run the suite and confirm red for the right reason

- [ ] Every new test ran and failed on its assertion, or is noted as green by coincidence
- [ ] Each failure matched the reason predicted in Step 1

### Step 4 — Green: write the minimum implementation

- [ ] The learner wrote the implementation
- [ ] All tests pass; the build prints no warnings (`-Werror` in C, clippy clean in Rust)
- [ ] Edge cases found while building got a test before the code

### Step 5 — Refactor with the suite green

- [ ] Tests re-run after each tidy-up; no test edited
- [ ] `make lint` (C) or `cargo fmt --check` plus `cargo clippy --all-targets -- -D warnings` (Rust) clean

### Step 6 — Prove the tests can fail

- [ ] A deliberate mutation turned at least one test red
- [ ] The mutation was undone and `git diff` shows none of it

---

## Context

- [ ] Directory trees in the relevant `CONTEXT.md` files show every new test file
- [ ] `code/REFERENCES.md` lists any new external source
- [ ] `**Last Updated**` is refreshed in every `CONTEXT.md` modified
- [ ] If the session ended mid-work, a handoff exists in `handoffs/`

---

## Definition of Done

- [ ] Every new test was seen red before it was seen green
- [ ] All tests green through the real implementation — no stubs left
- [ ] Test names read as sentences; failures state expected versus actual
- [ ] Control returned to the calling workflow (`01`, `03`, `04` or `07`) at its next step
