---
workflow: 01-toolchain-setup
phase: set-up
skills: []
---

# Toolchain Setup — Steps

**Last Updated**: 27/09/2026 | **Version**: 0.1.0 | **Maintained By**: Sam Bailey
**Language**: British English (en_GB) | **Timezone**: Europe/London

---

## Key references

Consult `how-to/REFERENCES.md` as you work through these steps:

| Step | Section |
| --- | --- |
| 1 | **Internal → Reference guides** → `how-to/docs/TOOLCHAIN.md` (Prerequisites) |
| 2 | **Internal → Operator guides** → `how-to/src/MACHINE-SETUP.md` (the long-form runbook) |
| 3 | **External — Toolchain and build** → rustup book, cargo-deny book |
| 4 | **Internal → Cross-layer** → `code/src/scripts/CONTEXT.md` (exit codes) |
| 5 | **Internal → Cross-layer** → `code/docs/BUILD.md` · **Internal → Reference guides** → `how-to/docs/CLI-TOOLING.md` |
| 6 | **External — Toolchain and build** → Cargo book, Clippy documentation |
| 7 | **Internal → Reference guides** → `how-to/docs/TOOLCHAIN.md` (Overview table) |

---

## Steps

### Step 1 — Install the apt packages

They come first because a fresh Ubuntu 24.04 desktop ships without `git` or `curl`, which the next
two steps use. These need `sudo`, so the learner runs them. Claude prints them and waits:

```bash
sudo apt update
sudo apt install build-essential gdb valgrind qemu-system-x86 cloc git curl
```

Confirm each package installed:

```bash
apt-cache policy build-essential gdb valgrind qemu-system-x86 cloc | grep -E '^[a-z]|Installed'
```

Every package shows a version on its `Installed:` line. `Installed: (none)` means that package did not
install; read the apt output for the reason, or go to `how-to/src/MACHINE-SETUP.md` → Failure modes.

Node.js (for the Markdown lint) and shellcheck are optional here, because CI runs both lints:
`how-to/src/MACHINE-SETUP.md` Part A, steps 8 and 9, installs them for running the lints locally.
Routine host upgrades (`apt upgrade`) are not part of setup. They belong to the reboot-purge repository
(`how-to/src/HOST-MAINTENANCE.md`).

_Done when all five packages report an installed version, and `git --version` prints one._

### Step 2 — Clone the repository

```bash
git clone https://github.com/SamBailey6194/c-rust-learning.git
cd c-rust-learning
git status
```

`git status` prints `On branch main` and `nothing to commit, working tree clean`. Every later command in
this workflow runs from the root of this clone.

_Done when the clone exists and `git status` reports a clean `main`._

### Step 3 — Install rustup, the pinned toolchain and cargo-deny

Skip the first two lines if `rustup --version` already prints a version:

```bash
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
. "$HOME/.cargo/env"
rustup component add rustfmt clippy
cd code/src/rust
rustup show active-toolchain || rustup toolchain install
cd ../../..
cargo install --locked --version 0.19.0 cargo-deny
```

Inside `code/src/rust/`, `rustup show active-toolchain` prints the pinned toolchain and the file that
pins it (the path in brackets is wherever you cloned):

```text
1.92.0-x86_64-unknown-linux-gnu (overridden by '.../code/src/rust/rust-toolchain.toml')
```

The first `rustup component add` covers your host default toolchain; the pinned toolchain gets `rustfmt`
and `clippy` from the `components` line in `rust-toolchain.toml`. `cargo install` builds cargo-deny from
source, which takes a few minutes. The version is the one `how-to/docs/TOOLCHAIN.md` records and CI
pins (`CARGO_DENY_VERSION` in `.github/workflows/syntax-rust.yml`), so the supply-chain gate asks the
same question here as there; `how-to/workflows/04-toolchain-updates/` moves all three together.

_Done when the active toolchain inside `code/src/rust/` is 1.92.0 and `cargo deny --version` prints
`cargo-deny 0.19.0`._

### Step 4 — Run the toolchain check

```bash
bash code/src/scripts/toolchain/check.sh
echo "exit=$?"
```

The script prints a `| Tool | Version |` table, then
`PASS: every required tool is present; rustc matches the pin (1.92.0).` and `exit=0`.

- **Exit 2:** a required tool (gcc, make, gdb, valgrind, cargo, rustc, rustfmt, clippy-driver) is missing;
  return to Step 1 or 3 for that tool.
- **Exit 1:** the `rustc` found inside `code/src/rust/` is not the pinned 1.92.0, typically a distribution
  `rustc` with no rustup in front of it; return to Step 3.
- Optional tools (qemu-system-x86_64, cloc, cargo-deny) are reported without failing the check.

_Done when `check.sh` exits 0._

### Step 5 — Build and test ms001 in C

Run the raw targets first; the make command is the lesson:

```bash
make -C code/src/c/ms001-hello
make -C code/src/c/ms001-hello test
make -C code/src/c/ms001-hello san
make -C code/src/c/ms001-hello memcheck
```

- The build compiles with `-Werror`, so any warning stops it.
- `test` runs `build/test_greet`, whose `check_summary()` prints `check: 12 passed, 0 failed`.
- `san` rebuilds under AddressSanitizer and UndefinedBehaviorSanitizer in `build/san/` and reruns the
  tests, which print the same summary. A finding prints an `ERROR: AddressSanitizer` (or
  `ERROR: LeakSanitizer`) report or a UBSan `runtime error:` line, and fails the run: the `san` build turns
  UBSan recovery off (`code/docs/BUILD.md`).
- `memcheck` runs valgrind on the non-sanitised test binaries. A clean run ends with
  `All heap blocks were freed -- no leaks are possible` and `ERROR SUMMARY: 0 errors from 0 contexts`.

Then run the same through the scripts that wrap them, which is how CI runs it:

```bash
bash code/src/scripts/c/build.sh --path code/src/c/ms001-hello
bash code/src/scripts/c/test.sh
bash code/src/scripts/c/san.sh
bash code/src/scripts/c/memcheck.sh
```

_Done when all four make targets and all four scripts exit 0._

### Step 6 — Build and test ms001 in Rust

Run cargo from inside the workspace so the pin applies:

```bash
cd code/src/rust
cargo build
cargo test
cargo run -p ms001_hello -- Sam
cargo fmt --check
cargo clippy --all-targets -- -D warnings
cd ../../..
```

`cargo run` prints `Hello, Sam!`. `cargo fmt --check` prints nothing when the code is formatted; a
`Diff in …` block means it is not. Clippy prints nothing beyond its `Checking`/`Finished` lines when clean.

Then the wrapping scripts:

```bash
bash code/src/scripts/rust/test.sh
bash code/src/scripts/rust/lint.sh
bash code/src/scripts/rust/audit.sh
```

`rust/audit.sh` runs cargo-deny; it exits 2 if cargo-deny is not installed (Step 3).

_Done when every cargo command and all three scripts exit 0._

### Step 7 — Compare the versions with the record

Put the table from Step 4 beside the Overview table in `how-to/docs/TOOLCHAIN.md`.

- **They match:** nothing to record.
- **A tool is newer or older:** do not edit the table by hand here. Note the difference and run
  `how-to/workflows/04-toolchain-updates/`, which re-records it deliberately.
- **A tool cannot be installed today:** add a `GAPS.md` entry with **Type:** Toolchain gap.

_Done when every version either matches the record or has a follow-up recorded._

---

## Update context files

If this workflow created files or folders, or settled a new convention:

1. Add every new file or folder to the directory tree in the nearest `CONTEXT.md`; a new directory also
   gets its own `CONTEXT.md` and `CLAUDE.md`.
2. Add any new guide, workflow or external source to `how-to/REFERENCES.md`.
3. Refresh `**Last Updated**` in every `CONTEXT.md` you modified.
4. If the session ends before Completion, run `/handoff` to write
   `handoffs/HANDOFF-<SCREAMING-KEBAB-DESCRIPTOR>-DD-MM-YYYY.md`.

---

## Completion

Run through `CHECKLIST.md` before marking this workflow complete.
