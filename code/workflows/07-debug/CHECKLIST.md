---
workflow: 07-debug
phase: diagnose-and-improve
skills: [handoff]
---

# Debug — Checklist

**Last Updated**: 27/09/2026 | **Version**: 0.1.0 | **Maintained By**: Sam Bailey
**Language**: British English (en_GB) | **Timezone**: Europe/London

---

> **See** `code/docs/DEBUGGING.md` (gdb, valgrind) · `code/REFERENCES.md` (git-bisect(1)) · `code/workflows/06-memory-check/` ·
> `code/REFERENCES.md` for supporting references.

## Pre-Conditions

- [ ] The debugging tools work (`bash code/src/scripts/toolchain/check.sh` exits 0); otherwise
      `how-to/workflows/05-debugging-environment/` first
- [ ] The learner has written down the command, the expected result and the actual result

---

## Execution Checklist

### Step 1 — Reproduce the bug with one command

- [ ] One command shows the bug on every run, in seconds
- [ ] An intermittent bug was looped until its failing condition was found

### Step 2 — Shrink to the smallest failing case

- [ ] The input was halved until nothing more could be removed
- [ ] For a regression: `git bisect run` found the first bad commit, and `git bisect reset` was run

### Step 3 — Pin the bug with a failing test

- [ ] The test uses the shrunk case and an independently sourced expected value
- [ ] The test was seen red before any fix; every other test still passed

### Step 4 — Find the cause by observing

- [ ] Hypotheses were written down and tested one at a time
- [ ] The root cause is stated in one sentence with gdb, valgrind or sanitiser evidence
- [ ] The learner did the investigating; Claude suggested observations, not answers

### Step 5 — Apply the minimal fix

- [ ] The change is the smallest that turns the test green; no unrelated edits
- [ ] Every tagged debug line removed (`grep -rn` for the marker finds nothing)

### Step 6 — Re-run the memory tools and linters

- [ ] C: `test`, `san`, `memcheck` and `lint` exit 0 together
- [ ] Rust: `cargo fmt --check`, `cargo clippy --all-targets -- -D warnings` and `cargo test` exit 0

### Step 7 — Write the BUG record and commit

- [ ] BUG record created from `BUG-MS000-TEMPLATE.md` in `project-management/src/13-BUGS/`, every section
      filled
- [ ] Fix and regression test committed together, type `fix`, scope `c` or `rust`, staged by name
- [ ] The record's **Fix state** reads `Fixed`
- [ ] Any design problem noted for `code/workflows/08-refactor/`

---

## Context

- [ ] Directory trees in the relevant `CONTEXT.md` files show any new test file
- [ ] `code/REFERENCES.md` lists any new external source
- [ ] `**Last Updated**` is refreshed in every `CONTEXT.md` modified
- [ ] If the session ended mid-work, a handoff exists in `handoffs/` recording hypotheses and bisect state

---

## Definition of Done

- [ ] The regression test failed before the fix and passes after it
- [ ] The full suite and the memory tools are green
- [ ] The BUG record names the root cause and its evidence
- [ ] No refactoring rode along with the fix
