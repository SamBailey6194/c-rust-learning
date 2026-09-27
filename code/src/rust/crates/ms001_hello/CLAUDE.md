@./CONTEXT.md

# CLAUDE.md — code/src/rust/crates/ms001_hello/

Read order: `.claude/CLAUDE.md` → `.claude/MEMORY.md` → `code/src/rust/CONTEXT.md` → this folder's
`CONTEXT.md` (the objective and the C-against-Rust comparison, imported above) → this file.

## Purpose (one line)

The first Rust crate: a worked example that mirrors `code/src/c/ms001-hello/`, so the learner can see
what the type system removes from the C version and what it leaves.

## How to work here

- **Routing:** this crate ships solved, as the Rust half of the MS001 toolchain proof. A new crate
  goes through `code/workflows/03-rust-exercise/`; C and Rust side by side is the lesson here.
- **Tutor mode:** ask the learner to predict before they run — which of the C version's `-1` cases can
  happen here, and why not? Explain compiler and clippy messages rather than fixing them; do not write
  the extension tasks below unless the learner explicitly asks.
- **Commands — the raw ones first, from `code/src/rust/`:**

  ```bash
  cargo run -p ms001_hello                  # Hello, world!
  cargo run -p ms001_hello -- Sam           # Hello, Sam!
  cargo test -p ms001_hello                 # unit, integration and doc tests
  cargo clippy -p ms001_hello --all-targets -- -D warnings
  cargo doc -p ms001_hello --open           # the docs, including the tested example
  ```

  Verification uses the wrappers: `bash code/src/scripts/rust/test.sh --crate ms001_hello` and
  `bash code/src/scripts/rust/lint.sh`.
- **Extension tasks for the learner:** greet every argument, not only the first; make `greet` return
  an error for a name that is only whitespace, and decide what the binary does with it; write the
  `main.rs` change test-first in `tests/greet.rs`.
- **Concrete steps for a change:** learner writes the failing test → learner changes `lib.rs` or
  `main.rs` → `cargo fmt` → `cargo clippy --all-targets -- -D warnings` → `cargo test` → update this
  `CONTEXT.md` if the behaviour or the comparison table changed.
- **Definition of done:** `rust/test.sh` and `rust/lint.sh` exit 0 with no warnings; the comparison
  table in `CONTEXT.md` still matches both twins.

## Guardrails

- **Keep the twins comparable.** A change to the shared behaviour lands in both
  `code/src/c/ms001-hello/` and this crate, or the comparison table says where they now differ.
- **Keep `unwrap()` and `expect()` out of non-test code.** They warn in library and binary code by
  policy; the answer is handling the `None` or `Err`, as `main.rs` does with `unwrap_or_else`.
- **Keep the doc example compiling.** The `# Examples` block in `lib.rs` is a test; `cargo test` runs it.

## Output & naming

- **Hand-written:** `Cargo.toml`, `src/lib.rs`, `src/main.rs`, `tests/greet.rs` and this pair.
- **Generated (never hand-edit):** the workspace's `target/`, shared with every other crate.
- New integration tests go in `tests/<topic>.rs`; unit tests stay in a `#[cfg(test)] mod tests` beside
  the code they test.
