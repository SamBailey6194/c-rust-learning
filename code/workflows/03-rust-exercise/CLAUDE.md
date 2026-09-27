@./CONTEXT.md

# CLAUDE.md — code/workflows/03-rust-exercise/

Read order: `.claude/CLAUDE.md` → `.claude/MEMORY.md` → this folder's `CONTEXT.md` (workspace policy,
naming, the port oracle, the three gates — imported above) → this file → `STEPS.md` then `CHECKLIST.md`.

## Purpose (one line)

Build one crate in the Cargo workspace test-first — a new exercise or a port of a C one — and finish with
`cargo fmt`, `cargo clippy` and `cargo test` all clean, the learner writing the code.

## How to work here

- **Routing:** run `STEPS.md` in order against `CHECKLIST.md`. Steps 3–4 run
  `code/workflows/02-tdd-cycle/`; a crate that needs C code or is called from C belongs to
  `code/workflows/04-ffi-bridge/`. The `teach` skill owns the learning note in Step 7.
- **Tutor mode:** ask the learner to sketch the public signatures and error type before any help; explain
  ownership and borrowing questions with small examples unrelated to the exercise; point at
  `code/docs/RUST-CODING-PRINCIPLES.md`. Do not write the exercise's functions or tests unless explicitly
  asked; explain a compiler or clippy message rather than supplying the fix.
- **Concrete steps:** choose new or port and read the oracle → `cargo new --lib` the crate and write its
  pair → tests first → implement → fmt, clippy, test → compare with the C version (ports) → note, commit,
  hand back.
- **Definition of done:** `cargo fmt --check`, `cargo clippy --all-targets -- -D warnings` and
  `cargo test -p msNNN_<snake>` all exit 0 from `code/src/rust/`; `bash code/src/scripts/rust/lint.sh` and
  `test.sh` agree; the crate has its `CONTEXT.md` + `CLAUDE.md`; a learning note exists.

## Guardrails

- **Run cargo from `code/src/rust/`.** rustup applies `rust-toolchain.toml` from the current directory, so
  a command run elsewhere may use a different toolchain than the pinned one.
- **Keep the crate's `[lints] workspace = true`.** Do not add a per-crate lint table or a crate-root
  `#![allow(...)]` to get a build through; silencing one finding uses `#[expect]` (preferred) or
  `#[allow]` on the single item, with a comment saying why.
- **Keep every C test case in a port.** A dropped case is either ported or listed, with its reason, in the
  crate's `CONTEXT.md`.
- **Add no dependency without an audit.** Exercises use `std` unless the spec says otherwise; any
  dependency goes through `bash code/src/scripts/rust/audit.sh` (cargo-deny) before it is committed.
- **Never commit `target/`.** Build output stays out of git; `Cargo.lock` is committed.

## Output & naming

- **Produced by following it:** `code/src/rust/crates/msNNN_<snake>/` with `Cargo.toml`, `src/lib.rs`,
  `src/main.rs` if the spec asks for a program, `tests/<name>.rs`, `CONTEXT.md` and `CLAUDE.md`; an updated
  `code/src/rust/Cargo.lock`; a note under `learning/`.
- Folder name equals package name, snake_case, `ms` prefix (Cargo rejects package names that start with a
  digit).
- Commits use scope `rust` (`project-management/docs/git/COMMITS.md`).
- Workflow files `SCREAMING-SNAKE-CASE.md`, frontmatter `workflow: 03-rust-exercise`, `phase: build`.
