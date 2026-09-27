# Workflow: Toolchain Updates

**Last Updated**: 27/09/2026

A toolchain that moves without a record turns yesterday's green build into today's mystery. This
workflow moves the pinned Rust toolchain through an ADR, routes host package upgrades through the
reboot-purge repository, and re-records every version in the one table that owns them.

## Directory Tree

```text
how-to/workflows/04-toolchain-updates/
├── CONTEXT.md · CLAUDE.md   ← when to use, key concepts (this file) · operating rules
├── STEPS.md                 ← ordered steps, each closing on a "Done when" line
└── CHECKLIST.md             ← verification before the update counts as complete
```

## When to use this

- A new stable Rust release carries something wanted: a language feature, a lint, a fix, or the minimum
  version the kernel's Rust support asks for at P4.
- A host `apt upgrade` has moved gcc, gdb, valgrind, QEMU or cloc.
- `how-to/workflows/01-toolchain-setup/` Step 7 found a version that differs from
  `how-to/docs/TOOLCHAIN.md`.
- cargo-deny needs updating, for instance because the advisory database format moved on.

## Key concepts

- **Two kinds of update.** The Rust toolchain is pinned and moves only by decision. The apt toolchain
  follows Ubuntu 24.04 and moves when the host is upgraded; the job here is to notice and record it.
- **The pin moves by ADR.** The seed decision
  `project-management/src/08-DECISIONS/ADR-MS001-RUST-EDITION-2024-TOOLCHAIN-PIN-27-09-2026.md` is
  superseded by a new ADR through `project-management/workflows/08-decisions/`; the Accepted record itself
  stays as written.
- **Pins are a matched set.** `channel` in `code/src/rust/rust-toolchain.toml`, `rust-version` in
  `code/src/rust/Cargo.toml` and the Rust rows of `how-to/docs/TOOLCHAIN.md` move together, in one pull
  request, or the repository contradicts itself.
- **`rustup update` leaves the pin alone.** It updates channel toolchains such as `stable`; a toolchain
  named by exact version (1.92.0) stays exactly that until `rust-toolchain.toml` changes.
- **Host upgrades belong to reboot-purge.** The sibling repository
  (`https://github.com/SamBailey6194/reboot-purge`, not yet published; `how-to/src/HOST-MAINTENANCE.md`
  points to it) is meant to own host maintenance; until it is published, Step 4 runs the upgrade by hand.
- **Every update ends with the gates.** A newer clippy brings new lints and a newer gcc new warnings; the
  gates in `how-to/workflows/03-quality-gates/` are what show it.

## Cross-references

### Governing documents

- `how-to/docs/TOOLCHAIN.md` — owns the recorded versions this workflow re-records
- `project-management/workflows/08-decisions/` — how the pin-moving ADR is written and accepted

### Related reading

- `how-to/src/HOST-MAINTENANCE.md` — pointer to reboot-purge, which owns host upgrades
- `how-to/workflows/03-quality-gates/` — the gate run that proves the update
- `code/docs/RUST-CODING-PRINCIPLES.md` — lint policy, when a new clippy lint fires
- `project-management/docs/git/BRANCHES.md` — the branch the update travels on
- `GAPS.md` — where an update that cannot land yet is recorded
