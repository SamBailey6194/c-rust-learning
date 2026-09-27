# Workflow: Toolchain Setup

**Last Updated**: 27/09/2026

A missing package found on day one costs a minute; the same gap found halfway through the first pointer
exercise costs the session. This workflow takes a fresh Ubuntu 24.04 machine to a clone that builds,
tests, sanitises and memchecks the first exercise in both C and Rust.

## Directory Tree

```text
how-to/workflows/01-toolchain-setup/
├── CONTEXT.md · CLAUDE.md   ← when to use, key concepts (this file) · operating rules
├── STEPS.md                 ← ordered steps, each closing on a "Done when" line
└── CHECKLIST.md             ← verification before the workflow counts as complete
```

## When to use this

- The first time the repository is cloned onto a machine.
- After a reinstall, or on a second machine, before the first study session there.
- When several tools are missing at once. A single missing or misbehaving tool is quicker through
  `how-to/workflows/05-debugging-environment/`.

This workflow is also the practical half of milestone MS001 (Toolchain ready): the version table and the
green ms001 runs it produces are that milestone's exit evidence
(`project-management/src/02-MILESTONES/MS001-TOOLCHAIN-READY.md`).

## Key concepts

- **Two toolchains, one of them pinned.** The apt toolchain (gcc, make, gdb, valgrind, QEMU) follows
  Ubuntu 24.04. The Rust toolchain is pinned to 1.92.0 by `code/src/rust/rust-toolchain.toml`, and rustup
  installs it the first time `cargo` runs inside `code/src/rust/`.
- **The pin follows the working directory.** rustup picks the toolchain from the directory `cargo` is
  started in, so `cd code/src/rust` first; `--manifest-path` from the repository root falls back to the
  host default toolchain.
- **The version table is the evidence.** `code/src/scripts/toolchain/check.sh` prints a
  `| Tool | Version |` table. The recorded versions live in `how-to/docs/TOOLCHAIN.md`, which owns them.
- **Exit 2 is "could not run".** `check.sh` exits 2 when a required tool is missing. That is a distinct
  state from 1 (failures) and is not a pass.
- **P4 packages wait for P4.** Kernel-build packages (flex, bison, libelf-dev, dwarves) and the
  Rust-for-Linux set (clang, LLVM, bindgen) are listed in `how-to/docs/TOOLCHAIN.md` as not yet
  installed; they arrive with the planned kernel workflows.
- **ms001 is the smoke test.** The hello exercise exists so that setup ends with a real build, test,
  sanitiser run and memcheck, rather than with version strings alone.

## Cross-references

### Governing documents

- `how-to/docs/TOOLCHAIN.md` — owns the versions this workflow installs and records
- `.claude/CLAUDE.md` — the non-negotiables, including the kernel safety rule that applies from P4

### Related reading

- `how-to/src/MACHINE-SETUP.md` — the same ground as a full runbook, with failure modes and rollback
- `how-to/docs/CLI-TOOLING.md` — every command used in Steps 5 and 6, grouped by intent
- `code/docs/BUILD.md` — the make targets and compiler flags behind Step 5
- `code/src/scripts/CONTEXT.md` — what each script wraps, and its exit codes
- `how-to/workflows/05-debugging-environment/` — when one step fails and the cause is the machine
- `how-to/src/HOST-MAINTENANCE.md` — routine host upgrades, which live in the reboot-purge repository
