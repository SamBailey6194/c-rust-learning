@./CONTEXT.md

# CLAUDE.md — how-to/workflows/01-toolchain-setup/

Read order: `.claude/CLAUDE.md` → `.claude/MEMORY.md` → this folder's `CONTEXT.md` (when to use, key
concepts — imported above) → this file → `STEPS.md` then `CHECKLIST.md`.

## Purpose (one line)

Take a fresh Ubuntu 24.04 machine to a clone whose toolchain check exits 0 and whose ms001 exercise
builds, tests, sanitises and memchecks cleanly in C and passes its tests in Rust.

## How to work here

- **Routing:** run `STEPS.md` in order (setup is sequential; there is no hard gate), then tick
  `CHECKLIST.md`. Command detail lives in `how-to/docs/CLI-TOOLING.md`, versions in
  `how-to/docs/TOOLCHAIN.md`, and the long-form runbook with failure modes in
  `how-to/src/MACHINE-SETUP.md`.
- **Concrete steps:** apt packages → clone → rustup, pinned toolchain and cargo-deny →
  `code/src/scripts/toolchain/check.sh` → ms001 in C (build, test, san, memcheck) → ms001 in Rust
  (build, test, fmt, clippy) → compare the version table with `how-to/docs/TOOLCHAIN.md`.
- **Definition of done:** `check.sh` exits 0; every ms001 target in Steps 5 and 6 exits 0; the printed
  versions match `how-to/docs/TOOLCHAIN.md` or a drift has been routed to
  `how-to/workflows/04-toolchain-updates/`; `CHECKLIST.md` is fully ticked.

## Guardrails

- **Leave `sudo` to the learner.** Print the `apt` command, explain what it installs, and wait for the
  learner to run it; Claude does not run privileged commands.
- **Treat exit 2 as not done.** A script that exits 2 could not run; record it as a gap, never as green.
- **Keep P4 packages out of this workflow.** Kernel-build and Rust-for-Linux packages are installed when
  P4 opens; `how-to/docs/TOOLCHAIN.md` lists them as not yet installed.
- **Change recorded versions only through workflow 04.** A version that differs from
  `how-to/docs/TOOLCHAIN.md` goes through `how-to/workflows/04-toolchain-updates/`, not an inline edit.
- **Run cargo from inside `code/src/rust/`.** The toolchain pin applies to the working directory, so a
  `--manifest-path` run from the root silently uses the host default toolchain.

## Output & naming

- **Hand-written:** `STEPS.md`, `CHECKLIST.md`, `CONTEXT.md`; nothing generated.
- **Produced by following it:** a working clone plus build output in `code/src/c/ms001-hello/build/` and
  `code/src/rust/target/`, both gitignored and never committed.
- A missing tool that cannot be installed today is recorded in `GAPS.md` with **Type:** Toolchain gap.
