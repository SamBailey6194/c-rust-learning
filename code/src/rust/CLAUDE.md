@./CONTEXT.md

# CLAUDE.md — code/src/rust/

Read order: `.claude/CLAUDE.md` → `.claude/MEMORY.md` → `code/src/CONTEXT.md` → this folder's
`CONTEXT.md` (the workspace, the lint policy and the crate list, imported above) → this file → the
crate's own `CONTEXT.md` and `CLAUDE.md`.

## Purpose (one line)

The Rust track: one Cargo workspace whose crates are the Rust exercises, held to one pinned compiler,
one lint policy and one supply-chain policy.

## How to work here

- **Routing:** a new crate or a Rust port of a C exercise → `code/workflows/03-rust-exercise/`; its
  tests → `code/workflows/02-tdd-cycle/`; C and Rust together (P3) → `code/workflows/04-ffi-bridge/`.
  Style and idiom questions → `code/docs/RUST-CODING-PRINCIPLES.md`.
- **Tutor mode:** ask how the learner plans to approach the problem before helping. Explain what the
  compiler or clippy is saying and why, ask the guiding question, point at the doc section; do not write
  the crate's code unless the learner explicitly asks. Reading a borrow-checker error together is the
  lesson — do not skip past it with a `.clone()`.
- **Raw commands first, from inside this folder** (so rustup applies the pin):

  ```bash
  cd code/src/rust
  cargo build                                  # every crate
  cargo test                                   # unit, integration and doc tests
  cargo fmt --check                            # formatting
  cargo clippy --all-targets -- -D warnings    # lints, warnings as errors
  cargo deny check                             # advisories, licences, bans, sources
  cargo run -p ms001_hello -- Sam              # run one crate's binary
  ```

  Verification uses the wrappers: `bash code/src/scripts/rust/{build,test,lint,audit}.sh`.
- **Adding a crate:** `cargo new --lib crates/msNNN_name` from inside this folder (add `src/main.rs`
  if it needs a binary; cargo 1.92 already writes the `*.workspace = true` fields and `[lints]
  workspace = true`, so check the manifest matches `crates/ms001_hello/Cargo.toml` rather than
  editing it) → give the folder its `CONTEXT.md` + `CLAUDE.md` → add a row to this `CONTEXT.md`'s
  crate table.
- **Concrete steps:** learner writes the failing test → learner implements → `cargo fmt` → `cargo clippy
  --all-targets -- -D warnings` → `cargo test` → `cargo deny check` if a dependency changed.
- **Definition of done:** the four rust scripts exit 0; `Cargo.lock` is committed alongside any
  dependency change; the crate has its pair and its row in the crate table.

## Guardrails

- **Never loosen a lint per crate.** Lint levels change in `[workspace.lints]` — one policy, one place;
  a crate that needs an exception writes a narrow `#[allow(...)]` with a comment saying why. The one
  per-crate addition is the stricter FFI `#![deny(...)]` line (`code/docs/RUST-CODING-PRINCIPLES.md`
  Section 2).
- **Justify every `unsafe` block.** It needs `#[allow(unsafe_code)]` on the smallest item possible and
  a `// SAFETY:` comment naming the invariant it relies on; one without is a review failure.
- **Treat every dependency as a supply-chain decision.** `cargo add` only edits `Cargo.toml` and
  `Cargo.lock`; the next build, check, test or clippy (or rust-analyzer) runs the new crate's build
  script on this machine. So `cargo deny check` runs straight after `cargo add`, before anything builds,
  and a licence exception is a deliberate `[[licenses.exceptions]]` entry with a reason, never a line
  added to `allow`.
- **Move the toolchain pin only on purpose.** `rust-toolchain.toml` changes in its own commit, through
  `how-to/workflows/04-toolchain-updates/`, with `rust-version` in `Cargo.toml` considered alongside it.
- **Never hand-edit `Cargo.lock` or commit `target/`.** cargo writes the lock file; `target/` is
  gitignored build output.

## Output & naming

- **Hand-written:** `Cargo.toml`, `rust-toolchain.toml`, `clippy.toml`, `rustfmt.toml`, `deny.toml`,
  every crate's `Cargo.toml`, `src/**/*.rs`, `tests/*.rs` and each pair.
- **Generated (never hand-edit):** `Cargo.lock` (committed), `target/` (gitignored).
- Crate folders `crates/msNNN_snake_name/`, identical to the package name; modules and functions
  `snake_case`, types `PascalCase`; integration tests `tests/<topic>.rs`.
