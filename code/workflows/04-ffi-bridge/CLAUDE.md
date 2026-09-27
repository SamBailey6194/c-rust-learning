@./CONTEXT.md

# CLAUDE.md — code/workflows/04-ffi-bridge/

Read order: `.claude/CLAUDE.md` → `.claude/MEMORY.md` → this folder's `CONTEXT.md` (the gate question, the
thin boundary, the no-panic and ownership rules — imported above) → this file → `STEPS.md` then
`CHECKLIST.md`.

## Purpose (one line)

Build a boundary between C and Rust (P3) the safe way round: answer the gate question, write the plain code first,
wrap it in a thin `extern "C"` layer that never panics, and prove it with a Rust suite and a C suite.

## How to work here

- **Routing:** run `STEPS.md` in order against `CHECKLIST.md`. Crate creation and the cargo gates come
  from `code/workflows/03-rust-exercise/`; both suites are built through `code/workflows/02-tdd-cycle/`;
  the C driver's memory runs follow `code/workflows/06-memory-check/`. Hard gates before Step 1:
  `code/docs/FFI.md` and `code/docs/RUST-CODING-PRINCIPLES.md`.
- **Tutor mode:** Step 1 is a question to the learner, not an answer from Claude — ask what crossing buys
  and accept "practice with the ABI" as a real answer. Ask the learner to write each boundary signature
  and its ownership on paper before any code. Explain ABI, `CStr`/`CString` and `SAFETY:` reasoning with
  examples outside the exercise; do not write the exercise's boundary or logic unless explicitly asked.
- **Concrete steps:** gate question → boundary design (direction, ownership, error codes) → plain code
  test-first → thin boundary with `SAFETY:` comments → both suites → sanitisers and valgrind over the C
  driver → gates, note, commit.
- **Definition of done:** `cargo fmt --check`, `cargo clippy --all-targets -- -D warnings` and
  `cargo test -p msNNN_<snake>` exit 0; the C driver passes plain, under ASan + UBSan and under valgrind;
  `cargo deny check` exits 0 if a dependency was added; `CHECKLIST.md` is fully ticked.

## Guardrails

- **Let no panic reach an `extern "C"` function.** The crate denies `clippy::panic`,
  `clippy::indexing_slicing`, `clippy::unwrap_used` and `clippy::expect_used` at its root; failures
  become return codes. `std::panic::catch_unwind` is a last-resort net, not a
  design.
- **Cover every `unsafe` with an `#[allow(unsafe_code)]` on the smallest enclosing item, and give every
  `unsafe` block its own `// SAFETY:` comment.** Never widen the allow to the crate root or weaken the
  workspace lint table to get a build through.
- **Free memory on the side that allocated it.** Rust allocations return through an exported `_free`
  function; C never calls `free()` on them, even though it may appear to work.
- **Run both suites, every time.** A green `cargo test` says nothing about the boundary as C calls it.
- **Pass every new dependency through the audit.** The `cc` build-dependency, or any other crate, goes
  through `bash code/src/scripts/rust/audit.sh` before it is committed.
- **Never commit `target/`** or any built archive, object or test binary.

## Output & naming

- **Produced by following it:** an ordinary workspace crate `code/src/rust/crates/msNNN_<snake>/` with its
  pair, laid out as `code/docs/FFI.md` Section 7 owns it: `csrc/` and `build.rs` for a C half, `include/`
  for the hand-written header, `ctest/` for the C driver, `msNNN_`-prefixed exports and a matching
  `msNNN_<noun>_free` for anything Rust allocates.
- Commits use scope `rust` (`project-management/docs/git/COMMITS.md`); the C half travels in the same
  commit as the Rust half.
- Workflow files `SCREAMING-SNAKE-CASE.md`, frontmatter `workflow: 04-ffi-bridge`, `phase: build`.
