---
workflow: 03-rust-exercise
phase: build
skills: [teach, handoff]
---

# Rust Exercise — Steps

**Last Updated**: 27/09/2026 | **Version**: 0.1.0 | **Maintained By**: Sam Bailey
**Language**: British English (en_GB) | **Timezone**: Europe/London

---

## Key references

Consult `code/REFERENCES.md` for the external sources (the Rust Book, the Rust Reference, the standard
library docs, the clippy lint list) as you work through these steps:

| Step | Section |
| --- | --- |
| 1 | `project-management/src/04-EXERCISES/` — the spec; or the C exercise's `test_*.c` for a port |
| 2 | `code/src/rust/Cargo.toml` and `code/src/rust/crates/ms001_hello/` — the workspace and the model crate |
| 3–4 | `code/workflows/02-tdd-cycle/` and `code/docs/TESTING.md` |
| 4 | `code/docs/RUST-CODING-PRINCIPLES.md` — ownership, `Result`, the lint table |
| 5 | `code/docs/BUILD.md` — what `code/src/scripts/rust/*.sh` wrap |
| 6 | `code/docs/MEMORY-SAFETY.md` — C bug classes and the Rust rules that prevent them |

---

## Steps

### Step 1 — Choose new or port, and read the oracle

**New exercise:** read the `EX-MS###-<TOPIC>.md` spec and ask the learner to restate the objective, the
public signatures and the error type. **Port:** open the C exercise's header and `test_*.c`, and list
every test case with its input and expected value. For each case, ask the learner whether it survives in
Rust or whether the type system removes it (a NULL pointer cannot be a `&str`; a truncating caller buffer
disappears when the function returns a `String`). Ask how they plan to approach it before anything else.

_Done when the learner has written the public signatures and, for a port, the case list marked "ported" or
"removed — reason"._

---

### Step 2 — Create the crate and its pair

```bash
cd code/src/rust
cargo new --lib crates/msNNN_<snake>
```

Inside the repository `cargo new` does not start a second git repository, and the generated `Cargo.toml`
already inherits the workspace fields and `[lints] workspace = true`. A spec that asks for a program gets
a `src/main.rs` beside `src/lib.rs`, calling into the library. Add `CONTEXT.md` (objective, concepts,
tree and, for a port, the removed-case list) and `CLAUDE.md` (tutor rules and cargo commands), modelled on
`code/src/rust/crates/ms001_hello/`.

```bash
cargo build -p msNNN_<snake>      # the empty crate builds under the workspace lint table
```

_Done when the crate builds, its manifest shows `[lints] workspace = true`, and its pair exists._

---

### Step 3 — Write the tests first

Run `code/workflows/02-tdd-cycle/` Steps 1–3. Unit tests go in a `#[cfg(test)] mod tests` beside the code;
integration tests go in `tests/<name>.rs` and use only `pub` items. For a port, each surviving C case
becomes one Rust test with the same input and the same literal expected value, and its name says which C
test it came from.

```bash
cargo test -p msNNN_<snake>       # expect failures showing left and right values
```

_Done when every case is a test and every new test fails on its assertion against a wrong-value stub._

---

### Step 4 — Implement until green

The learner writes the implementation (`code/workflows/02-tdd-cycle/` Steps 4–6). Errors are `Result`
values with a small error type, not panics; `unwrap` and `expect` stay out of library code. When the
compiler or clippy objects, Claude explains the message and the rule behind it rather than supplying the
edit.

_Done when `cargo test -p msNNN_<snake>` passes with the real implementation._

---

### Step 5 — Run the three gates

```bash
cargo fmt --check
cargo clippy --all-targets -- -D warnings
cargo test -p msNNN_<snake>
```

The scripts `bash code/src/scripts/rust/lint.sh` (fmt plus clippy, across the workspace) and
`bash code/src/scripts/rust/test.sh --crate msNNN_<snake>` run the same checks. With `-D warnings`,
pedantic lints such as `must_use_candidate` or `missing_errors_doc` fail the gate; each names a habit
worth learning, so read the lint's entry in the clippy lint list before reaching for `#[expect]`.
`cargo fmt` (without `--check`) rewrites the layout; `bash code/src/scripts/rust/lint.sh --fix` does the
same before checking.

If the crate gained a dependency, run the supply-chain gate as well:

```bash
cargo deny check                  # wrapped by bash code/src/scripts/rust/audit.sh
```

Do not proceed to Step 6 until all three gates exit 0.

_Done when fmt, clippy and test all exit 0, and the audit does too if a dependency was added._

---

### Step 6 — Compare with the C version (ports only)

Run both on the same inputs — the C program from `code/src/c/msNNN-<kebab>/build/`, the Rust one with
`cargo run -p msNNN_<snake> -- <args>` — and ask the learner to name what changed: which C checks became
types, which `-1` returns became `Err` variants, which memory bugs the tools had to hunt for in C and the
compiler now rejects. Skip this step for a new exercise.

_Done when the learner can name at least one C bug class this port makes impossible, and one it does not._

---

### Step 7 — Record the learning note and hand back

Run the `teach` skill's closing steps: the learner writes a note in the matching
`learning/rust-NN-<topic>/NOTES/` folder and the skill logs it in that topic's `PROGRESS.md`. Commit with
scope `rust` (`project-management/docs/git/COMMITS.md`), staging each path by name — the crate folder and
`code/src/rust/Cargo.lock` — and return to `project-management/workflows/10-study-and-build/`.

_Done when the note exists, the work is committed without `target/`, and the PM step has the result._

---

## Update context files

1. Add the crate to the tree in `code/src/rust/CONTEXT.md`.
2. Add any new external source to `code/REFERENCES.md`.
3. Refresh `**Last Updated**` in every `CONTEXT.md` you modified, including the crate's own.
4. If the session ends before Completion, run `/handoff` to write
   `handoffs/HANDOFF-<SCREAMING-KEBAB-DESCRIPTOR>-DD-MM-YYYY.md`.

---

## Completion

Run through `CHECKLIST.md` before marking this workflow complete.
