---
workflow: 04-ffi-bridge
phase: build
skills: [teach, research]
---

# FFI Bridge — Checklist

**Last Updated**: 27/09/2026 | **Version**: 0.1.0 | **Maintained By**: Sam Bailey
**Language**: British English (en_GB) | **Timezone**: Europe/London

---

> **See** `code/docs/FFI.md` (ABI, ownership, panics) · `code/docs/RUST-CODING-PRINCIPLES.md` (`unsafe`,
> lints) · `code/REFERENCES.md` for supporting references.

## Pre-Conditions

- [ ] The roadmap has reached P3, or this is deliberate early practice recorded as such
- [ ] `bash code/src/scripts/toolchain/check.sh` exits 0 (gcc, valgrind, cargo, clippy present)

---

## Execution Checklist

### Step 1 — Answer the gate question

- [ ] The learner named what crossing buys; the answer opens the crate's `CONTEXT.md`
- [ ] A work item with no real answer was routed to `code/workflows/03-rust-exercise/`

### Step 2 — Design the boundary on paper

- [ ] Each crossing function has a direction, C types, ownership per parameter and an error convention
- [ ] Every allocation has a named owner and a named free function
- [ ] Exported names carry the crate's `msNNN_` prefix

### Step 3 — Write the plain code first

- [ ] The logic is tested and green with no raw pointers, `extern` or FFI types in it

### Step 4 — Add the thin boundary

- [ ] Each boundary function validates, delegates and maps — no logic of its own
- [ ] Only C-compatible types cross; any shared struct is `#[repr(C)]`
- [ ] `src/lib.rs` opens with the crate-level `#![deny(clippy::panic, clippy::indexing_slicing, ...)]` line
- [ ] No `unwrap`, `expect`, `panic!` or slice indexing on a boundary path
- [ ] Every `unsafe extern` block, `#[unsafe(no_mangle)]` function and `unsafe` block is covered by an
      `#[allow(unsafe_code)]` on the smallest enclosing item, and every `unsafe` block has its own
      `// SAFETY:` comment naming the invariant
- [ ] Public `unsafe fn`s document their contract in a `# Safety` section
- [ ] Imported C prototypes match the C header exactly (types, pointer constness, return type)

### Step 5 — Write both test suites

- [ ] Rust tests cover the logic and each boundary function's null, invalid and valid calls
- [ ] The C driver in `ctest/` uses `check.h` and tests each function's failure path
- [ ] The C driver builds with the repository's full warning set and `-Werror`

### Step 6 — Run the memory tools and the gates

- [ ] The C driver passes under ASan + UBSan with `-fno-sanitize-recover=all`
- [ ] valgrind reports `ERROR SUMMARY: 0 errors` for the plain C driver
- [ ] `cargo fmt --check`, `cargo clippy --all-targets -- -D warnings` and `cargo test` exit 0
- [ ] If a dependency was added: `cargo deny check` exits 0

### Step 7 — Record the learning note and hand back

- [ ] A note in the learner's words exists under `learning/rust-NN-<topic>/NOTES/`, logged in `PROGRESS.md`
- [ ] Committed with scope `rust`: crate folder and `Cargo.lock` staged by name, `target/` absent

---

## Context

- [ ] `code/src/rust/CONTEXT.md` and the crate's `CONTEXT.md` trees show the new crate and its folders
- [ ] `code/REFERENCES.md` lists any new external source
- [ ] `**Last Updated**` is refreshed in every `CONTEXT.md` modified
- [ ] If the session ended mid-work, a handoff exists in `handoffs/`

---

## Definition of Done

- [ ] The gate answer, boundary design and ownership rules are written in the crate's `CONTEXT.md`
- [ ] Both suites are green, and the C suite is clean under ASan + UBSan and valgrind
- [ ] `bash code/src/scripts/rust/lint.sh` and `bash code/src/scripts/rust/test.sh` exit 0
- [ ] No panic path reaches an `extern "C"` function, and no `unsafe` lacks its `SAFETY:` comment
