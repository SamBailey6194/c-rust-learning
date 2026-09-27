# Workflow: Rust Exercise

**Last Updated**: 27/09/2026

The borrow checker removes whole classes of C bugs, but not a wrong answer, a panic on bad input or an
error swallowed by `unwrap`. This workflow builds one crate in the Cargo workspace test-first, and when the
crate is a port it keeps the C exercise's test cases as the oracle, so the two implementations answer the
same questions.

## Directory Tree

```text
code/workflows/03-rust-exercise/
├── CONTEXT.md · CLAUDE.md   ← orientation (this file) · operating rules for the workflow
├── STEPS.md                 ← ordered steps, each closing on a "Done when" line
└── CHECKLIST.md             ← the gate ticked before the workflow counts as complete
```

## When to use this

- To build a new Rust exercise specified by an `EX-MS###-<TOPIC>.md` spec in
  `project-management/src/04-EXERCISES/` — from P3 in `project-management/src/01-ROADMAP/ROADMAP.md`,
  though a small crate beside a C exercise is welcome earlier, as `ms001_hello` shows.
- To port a finished, clean C exercise from `code/src/c/` to Rust for side-by-side comparison, including
  the P3 exit-gate port of a P2 project.
- For code that crosses between C and Rust, `code/workflows/04-ffi-bridge/` applies instead.

## Key concepts

- **One workspace, one policy.** Every crate is a member of `code/src/rust/Cargo.toml`
  (`members = ["crates/*"]`). Running `cargo new --lib crates/msNNN_<snake>` inside `code/src/rust/`
  writes a manifest that inherits `edition`, `rust-version`, `license` and `publish` from
  `[workspace.package]` and sets `[lints] workspace = true` (checked with cargo 1.92.0), so the crate
  starts under the shared lint table with no edits.
- **Names.** The folder and the package share one snake_case name, `msNNN_<snake>`. A port keeps the C
  exercise's number and name (`ms001-hello` → `ms001_hello`), so the pair is obvious at a glance; a new
  Rust-only exercise takes its spec's milestone number (`code/src/CLAUDE.md` → Output & naming owns
  the rule).
- **The C tests are the oracle for a port.** Each C test case either becomes a Rust test with the same
  input and the same expected value, or is recorded as a case the type system removed — a NULL `name`
  cannot exist as a `&str`, and a caller-sized buffer that might truncate disappears when the function
  returns a `String`. The removed cases are the lesson.
- **Errors are values.** `Result` and `Option` replace `-1` and `errno`. The workspace lint table warns on
  `unwrap` and `expect`, and the lint gate runs clippy with `-D warnings`, so each one fails the gate.
- **Three gates.** `cargo fmt --check` (layout), `cargo clippy --all-targets -- -D warnings` (the lint
  table, including the pedantic group, as errors) and `cargo test` (unit, integration and doc tests).
- **The pinned toolchain.** `code/src/rust/rust-toolchain.toml` pins 1.92.0. rustup reads that file from
  the current directory upwards, so cargo commands run from inside `code/src/rust/`.

## Cross-references

### Governing documents

- `code/docs/RUST-CODING-PRINCIPLES.md` — ownership, error handling, the lint table and rustfmt
- `code/docs/TESTING.md` — unit, integration and doc tests; the test discipline
- `code/docs/BUILD.md` — the workspace commands and what the scripts wrap

### Related reading

- `code/src/rust/crates/ms001_hello/` — the reference crate and the Rust twin of `code/src/c/ms001-hello/`
- `code/src/rust/CONTEXT.md` — the workspace tree, where each new crate is listed
- `code/workflows/02-tdd-cycle/` — the red → green → refactor loop used in Steps 3–4
- `code/docs/MEMORY-SAFETY.md` — which C bug classes the Rust rules rule out, and which they leave open
- `project-management/src/08-DECISIONS/ADR-MS001-RUST-EDITION-2024-TOOLCHAIN-PIN-27-09-2026.md` — why
  edition 2024 and a pinned toolchain
- `learning/CONTEXT.md` — where the learning note goes
