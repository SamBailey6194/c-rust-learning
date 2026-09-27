@./CONTEXT.md
@./REFERENCES.md

# CLAUDE.md — code/

Read order: `.claude/CLAUDE.md` → `.claude/MEMORY.md` → this folder's `CONTEXT.md` (the tree, the
sub-layers and the key docs, imported above) → this file → the target sub-layer's `CONTEXT.md` /
`CLAUDE.md`.

## Purpose (one line)

The code layer — every C exercise, Rust crate and gate script (`src/`), the standards that govern them
(`docs/`), and the workflows that sequence the work (`workflows/`).

## How to work here

- **Routing:** start any coding task from the matching `workflows/NN-name/` folder — `CONTEXT.md` first,
  `STEPS.md` when the work begins — and it will point at the governing `docs/` guide. A concept with no
  exercise yet starts in a `/teach` session (`.claude/skills/teach/SKILL.md`), not here. The exercise
  spec comes from `project-management/src/04-EXERCISES/`.
- **Tutor mode:** before helping with an exercise, ask Sam how he plans to approach it. Explain and ask
  guiding questions; do not write exercise solutions unless he explicitly asks. In a review, point at
  the `code/docs/` section that applies instead of rewriting his code. The posture is owned by
  `.claude/CLAUDE.md`.
- **Raw command first:** when teaching, show the raw command — gcc, make, gdb, valgrind, cargo — and let
  Sam run it; then name the script in `code/src/scripts/` that wraps it (`docs/BUILD.md`). Claude's own
  verification runs through the scripts, as CI does.
- **Concrete steps:** read the governing `docs/` guide → write the failing test (`docs/TESTING.md`) →
  implement under `src/c/ms###-*/` or `src/rust/crates/ms###_*/` → `make test` / `cargo test` →
  `make san`, `make memcheck`, `make lint` (`docs/MEMORY-SAFETY.md`) → `cargo fmt --check` and clippy
  for Rust → update the touched `CONTEXT.md` → `bash code/src/scripts/gates/all.sh`.
- **Definition of done:** the gates in `how-to/workflows/03-quality-gates/` pass (none reported as
  COULD NOT RUN); every C exercise is clean under `san`, `memcheck` and `lint`; the style guides are
  met (`docs/C-CODING-PRINCIPLES.md`, `docs/RUST-CODING-PRINCIPLES.md`); every touched directory's
  `CONTEXT.md` and `CLAUDE.md` are current; British English throughout.

## Guardrails

- **Fix the code, never the gate.** Do not loosen `src/c/mk/flags.mk`, the workspace lints or a script
  to get a pass. A change to the build or lint policy is an ADR in
  `project-management/src/08-DECISIONS/` first (`docs/BUILD.md` Section 7).
- **Report "could not run" as exactly that.** A missing tool is exit 2, COULD NOT RUN, never a pass
  (`docs/BUILD.md` Section 6).
- **Keep kernels and modules inside QEMU.** Nothing from `src/kernel/` (planned, P4) is installed or
  loaded on the host; kernel trees, build output and disk images are never committed
  (`.claude/CLAUDE.md`).
- **Justify every `unsafe`.** An `unsafe` block without a `// SAFETY:` comment naming its invariant is a
  review failure (`docs/RUST-CODING-PRINCIPLES.md` Section 4).
- **Pair every new directory, and keep files in their limits.** A new directory gets its `CONTEXT.md`
  and `CLAUDE.md` (`docs/DOCUMENTATION-PAIRING.md`); instructional Markdown stays within 300 cloc code
  lines and source files within 750 lines (`docs/DOCUMENTATION-LENGTH.md`).
- **Do not read or commit build output.** `build/`, `target/`, core files and coverage data are
  generated; searching them wastes context and committing them leaks noise into history.

## Output & naming

- **Hand-written:** source under `src/`, guides under `docs/`, workflow files under `workflows/`, and
  this layer's `REFERENCES.md`.
- **Generated (never hand-edited, never committed):** each exercise's `build/`, the workspace's
  `target/`, `*.gcda` / `*.gcno` coverage data. `Cargo.lock` is generated but committed.
- **Names:** C exercises `ms###-kebab-name/`; Rust crates `ms###_snake_name/`; guides
  `SCREAMING-SNAKE-CASE.md` with any sub-folder in `kebab-case/`; workflows `NN-kebab-name/`, appended and
  never renumbered; scripts `kebab-case.sh`.
