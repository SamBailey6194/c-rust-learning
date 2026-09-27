---
workflow: 03-rust-exercise
phase: build
skills: [teach, handoff]
---

# Rust Exercise — Checklist

**Last Updated**: 27/09/2026 | **Version**: 0.1.0 | **Maintained By**: Sam Bailey
**Language**: British English (en_GB) | **Timezone**: Europe/London

---

> **See** `code/docs/RUST-CODING-PRINCIPLES.md` (ownership, errors, lints) · `code/docs/TESTING.md` ·
> `code/REFERENCES.md` for supporting references.

## Pre-Conditions

- [ ] An `EX-MS###-<TOPIC>.md` spec exists, or the C exercise being ported is finished and memory-clean
- [ ] `bash code/src/scripts/toolchain/check.sh` exits 0 (cargo, rustc, rustfmt, clippy present)

---

## Execution Checklist

### Step 1 — Choose new or port, and read the oracle

- [ ] The learner wrote the public signatures and the error type before any help
- [ ] Port: every C test case listed as "ported" or "removed — reason"

### Step 2 — Create the crate and its pair

- [ ] Created with `cargo new --lib crates/msNNN_<snake>` from inside `code/src/rust/`
- [ ] Folder name equals package name; manifest has `[lints] workspace = true` and no lint table of its own
- [ ] `CONTEXT.md` and `CLAUDE.md` written (a port's removed-case list included)

### Step 3 — Write the tests first

- [ ] Unit tests beside the code; integration tests in `tests/` using only `pub` items
- [ ] Port: every surviving C case is a Rust test with the same input and literal expected value
- [ ] Every new test was seen red on its assertion

### Step 4 — Implement until green

- [ ] The learner wrote the implementation; Claude explained diagnostics rather than supplying fixes
- [ ] Failures are `Result` or `Option` values; no `unwrap`, `expect` or `panic!` in library code

### Step 5 — Run the three gates

- [ ] `cargo fmt --check` exits 0
- [ ] `cargo clippy --all-targets -- -D warnings` exits 0; any `#[expect]` or `#[allow]` sits on one item
      with a comment saying why
- [ ] `cargo test -p msNNN_<snake>` exits 0
- [ ] If a dependency was added: `cargo deny check` (`bash code/src/scripts/rust/audit.sh`) exits 0

### Step 6 — Compare with the C version (ports only)

- [ ] Both versions run on the same inputs and agree where the behaviour survives
- [ ] The learner named a C bug class the port rules out, and one it does not

### Step 7 — Record the learning note and hand back

- [ ] A note in the learner's words exists under `learning/rust-NN-<topic>/NOTES/`, logged in `PROGRESS.md`
- [ ] Committed with scope `rust`: crate folder and `Cargo.lock` staged by name, `target/` absent

---

## Context

- [ ] `code/src/rust/CONTEXT.md` lists the new crate in its directory tree
- [ ] `code/REFERENCES.md` lists any new external source
- [ ] `**Last Updated**` is refreshed in every `CONTEXT.md` modified
- [ ] If the session ended mid-work, a handoff exists in `handoffs/`

---

## Definition of Done

- [ ] `bash code/src/scripts/rust/lint.sh` and `bash code/src/scripts/rust/test.sh` both exit 0
- [ ] The crate has its `CONTEXT.md` + `CLAUDE.md` pair and appears in the workspace tree
- [ ] A port accounts for every C test case, ported or removed with a reason
- [ ] The learning note exists and `project-management/workflows/10-study-and-build/` has the result
