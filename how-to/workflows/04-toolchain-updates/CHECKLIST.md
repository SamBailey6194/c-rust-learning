---
workflow: 04-toolchain-updates
phase: maintain
skills: [research]
---

# Toolchain Updates — Checklist

**Last Updated**: 27/09/2026 | **Version**: 0.1.0 | **Maintained By**: Sam Bailey
**Language**: British English (en_GB) | **Timezone**: Europe/London

---

> **See** `how-to/REFERENCES.md` → **Internal → Reference guides** (`how-to/docs/TOOLCHAIN.md`) ·
> **Internal → Operator guides** (`how-to/src/HOST-MAINTENANCE.md`) · **External — Toolchain and build**
> (rustup book) for supporting references.

## Execution Checklist

### Step 1 — See what would change

- [ ] `rustup check` and `apt list --upgradable` read and compared with `how-to/docs/TOOLCHAIN.md`

### Step 2 — Decide on the Rust pin, and record it

- [ ] A moved pin has a new Accepted ADR that supersedes the previous pin ADR, with the learner's reason
- [ ] The previous ADR changed only its Status and "Superseded by" line

### Step 3 — Move the pin as a matched set

- [ ] `rust-toolchain.toml` `channel` and `Cargo.toml` `rust-version` name the same release
- [ ] `rustc --version` inside `code/src/rust/` prints the new version
- [ ] New clippy lints fixed, or a scoped `#[allow(…)]` argued in the ADR
- [ ] cargo-deny is the same version locally and in `CARGO_DENY_VERSION` (`.github/workflows/syntax-rust.yml`),
      or was left where it is on purpose

### Step 4 — Upgrade the host packages through reboot-purge

- [ ] The learner ran the upgrade (or deferred it deliberately); Claude ran no `sudo`

### Step 5 — Run every gate on the new toolchain

- [ ] `gates/all.sh` exited 0 after the update

### Step 6 — Re-record the versions

- [ ] `how-to/docs/TOOLCHAIN.md` Overview table matches `toolchain/check.sh` output, row for row
- [ ] Any `GAPS.md` entry the update resolved is marked `✅ CLOSED <date>`

### Step 7 — Commit by explicit path

- [ ] Pin and lockfile committed as `build(rust)`, a moved cargo-deny as `ci(rust)`, the table as
      `docs(how-to)`, each staged by explicit path
- [ ] Pin, ADR and table travel in the same pull request

---

## Context

- [ ] Directory trees in the relevant `CONTEXT.md` files show every file or folder this workflow created
- [ ] `how-to/REFERENCES.md` lists any new guide, workflow or external source
- [ ] `**Last Updated**` is refreshed in every `CONTEXT.md` modified
- [ ] If the session ended mid-work, a handoff exists in `handoffs/`

---

## Definition of Done

- [ ] The toolchain the repository records is the toolchain the machine runs
- [ ] Every moved Rust pin is backed by an Accepted, superseding ADR
- [ ] All gates green on the new toolchain, with nothing silenced to get there
- [ ] The update is committed and ready for `project-management/workflows/13-pr-and-merge/`
