---
workflow: 08-refactor
phase: diagnose-and-improve
skills: []
---

# Refactor — Checklist

**Last Updated**: 27/09/2026 | **Version**: 0.1.0 | **Maintained By**: Sam Bailey
**Language**: British English (en_GB) | **Timezone**: Europe/London

---

> **See** `code/docs/CODING-PRINCIPLES.md` (smells and moves) · `code/docs/TESTING.md` ·
> `code/REFERENCES.md` for supporting references.

## Pre-Conditions

- [ ] The code works and has tests that pin its behaviour through the public interface
- [ ] No behaviour change is bundled in; bugs go through `code/workflows/07-debug/` first

---

## Execution Checklist

### Step 1 — Record a green baseline

- [ ] Working tree clean before the first move
- [ ] C: `test`, `san`, `memcheck`, `lint` exit 0; Rust: fmt, clippy and test exit 0
- [ ] Baseline commit hash noted

### Step 2 — Name the target and list the moves

- [ ] The learner named what makes the code hard to read or change
- [ ] The matching `code/docs/CODING-PRINCIPLES.md` section identified
- [ ] Moves listed in order, each small enough to build and test alone

### Step 3 — Apply one move, then build and test

- [ ] Exactly one move per step, made by the learner
- [ ] Tests run after every move; a move that turned anything red was undone, not debugged forward

### Step 4 — Commit at green, then repeat

- [ ] Each green point committed, type `refactor`, scope `c` or `rust`, staged by explicit path

### Step 5 — Re-run every gate

- [ ] C: `test`, `san`, `memcheck` and `lint` exit 0 together
- [ ] Rust: `cargo fmt --check`, `cargo clippy --all-targets -- -D warnings`, `cargo test` exit 0
- [ ] No new warning, sanitiser report or valgrind error compared with the baseline

### Step 6 — Confirm behaviour and tests are unchanged

- [ ] `git diff` against the baseline shows no change to any test assertion
- [ ] Every touched source file is within 750 lines
- [ ] The program's output on the spec's examples matches the baseline

---

## Context

- [ ] Directory trees in the relevant `CONTEXT.md` files reflect any split, added or renamed file
- [ ] `code/REFERENCES.md` lists any new external source
- [ ] `**Last Updated**` is refreshed in every `CONTEXT.md` modified
- [ ] If the session ended mid-work, a handoff exists in `handoffs/` with the baseline commit and the
      remaining moves

---

## Definition of Done

- [ ] Behaviour identical to the baseline, verified by unchanged, passing tests and clean memory tools
- [ ] The target named in Step 2 is resolved
- [ ] Every move is committed separately from any behaviour change
