---
workflow: 01-toolchain-setup
phase: set-up
skills: []
---

# Toolchain Setup — Checklist

**Last Updated**: 27/09/2026 | **Version**: 0.1.0 | **Maintained By**: Sam Bailey
**Language**: British English (en_GB) | **Timezone**: Europe/London

---

> **See** `how-to/REFERENCES.md` → **Internal → Reference guides** (`how-to/docs/TOOLCHAIN.md`,
> `how-to/docs/CLI-TOOLING.md`) · **Internal → Operator guides** (`how-to/src/MACHINE-SETUP.md`) ·
> **External — Toolchain and build** for supporting references.

## Execution Checklist

### Step 1 — Install the apt packages

- [ ] `build-essential`, `gdb`, `valgrind`, `qemu-system-x86` and `cloc` each report an `Installed:` version
- [ ] `git --version` prints a version
- [ ] The learner ran the `sudo` commands; Claude ran none

### Step 2 — Clone the repository

- [ ] Repository cloned; `git status` reports a clean `main`

### Step 3 — Install rustup, the pinned toolchain and cargo-deny

- [ ] `rustup show active-toolchain` inside `code/src/rust/` reports `1.92.0-x86_64-unknown-linux-gnu`
- [ ] `cargo deny --version` prints `cargo-deny 0.19.0`, the version CI pins

### Step 4 — Run the toolchain check

- [ ] `toolchain/check.sh` exits 0 and prints the `| Tool | Version |` table

### Step 5 — Build and test ms001 in C

- [ ] `make -C code/src/c/ms001-hello` builds with no warnings
- [ ] The `test`, `san` and `memcheck` targets each exit 0
- [ ] valgrind reports `All heap blocks were freed -- no leaks are possible`
- [ ] `c/build.sh`, `c/test.sh`, `c/san.sh` and `c/memcheck.sh` each exit 0

### Step 6 — Build and test ms001 in Rust

- [ ] Cargo was run from inside `code/src/rust/`, not with `--manifest-path` from the root
- [ ] `cargo test`, `cargo fmt --check` and `cargo clippy --all-targets -- -D warnings` each exit 0
- [ ] `cargo run -p ms001_hello -- Sam` prints `Hello, Sam!`
- [ ] `rust/test.sh`, `rust/lint.sh` and `rust/audit.sh` each exit 0

### Step 7 — Compare the versions with the record

- [ ] Every version matches `how-to/docs/TOOLCHAIN.md`, or the drift is queued for workflow 04
- [ ] Any tool that could not be installed is recorded in `GAPS.md` as a Toolchain gap

---

## Context

- [ ] Directory trees in the relevant `CONTEXT.md` files show every file or folder this workflow created
- [ ] `how-to/REFERENCES.md` lists any new guide, workflow or external source
- [ ] `**Last Updated**` is refreshed in every `CONTEXT.md` modified
- [ ] If the session ended mid-work, a handoff exists in `handoffs/`

---

## Definition of Done

- [ ] `toolchain/check.sh` exits 0 on this machine
- [ ] ms001 passes every C target (build, test, san, memcheck) and every Rust gate (test, fmt, clippy, audit)
- [ ] No exit 2 was recorded as a pass
- [ ] The machine is ready for `how-to/workflows/02-daily-study-session/`
