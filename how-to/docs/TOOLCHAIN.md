---
type: guide
---

# Toolchain — c-rust-learning

**Last Updated**: 27/09/2026 | **Version**: 0.1.0 | **Maintained By**: Sam Bailey
**Language**: British English (en_GB) | **Timezone**: Europe/London

> **Owner.** This guide owns the recorded toolchain versions. Every other file cites it instead of
> restating a version, and a version changes here only through `how-to/workflows/04-toolchain-updates/`.

---

## Overview

Recorded on 27/09/2026 on Ubuntu 24.04.5 LTS (x86_64), from each tool's own `--version` output.

| Tool | Version | Purpose |
| --- | --- | --- |
| gcc | 13.3.0 (Ubuntu 13.3.0-6ubuntu2~24.04.1) | C17 compiler, `-fanalyzer` static analysis, ASan and UBSan runtimes |
| GNU make | 4.3 | Builds every C exercise under `code/src/c/` |
| gdb | 15.1 | Debugger for C, and for Rust through the `rust-gdb` wrapper |
| valgrind | 3.22.0 | Memcheck: leaks and invalid memory access in the plain (non-sanitised) build |
| rustup | 1.28.2 | Installs and selects Rust toolchains; reads `rust-toolchain.toml` |
| rustc / cargo | 1.92.0 | The pinned Rust compiler and build tool (`code/src/rust/rust-toolchain.toml`) |
| clippy | 0.1.92 | Rust lints (`cargo clippy`) |
| rustfmt | 1.8.0 | Rust formatting (`cargo fmt`) |
| cargo-deny | 0.19.0 | Licence, advisory, ban and source checks on Rust dependencies |
| qemu-system-x86_64 | 8.2.2 | The virtual machine every P4 kernel boots in |
| cloc | 1.98 | Counts Markdown code lines for the docs-length audit |
| git | 2.43.0 | Version control |
| Node.js / npx | 24.13.0 / 11.11.0 | Runs markdownlint-cli2 on demand through `npx` (optional locally) |
| BusyBox (static) | 1.36.1 | Userland for the P4 initramfs (`busybox-static` package) |

`code/src/scripts/toolchain/check.sh` prints the same kind of table. It treats gcc, make, gdb, valgrind,
cargo, rustc, rustfmt and clippy-driver as **required** (exit 2 if any is missing) and
qemu-system-x86_64, cloc and cargo-deny as **optional**.

### Not installed, and why

| Tool | Why it is absent |
| --- | --- |
| clang, lld, libclang-dev, bindgen | Arrive with P4 Rust-for-Linux (see P4 prerequisites below) |
| clang-format, clang-tidy | Not in use: C follows the Linux kernel coding style, checked in review |
| cmake, bear | Not used: the build is plain GNU make (ADR in `project-management/src/08-DECISIONS/`) |
| shellcheck | Runs in CI (0.9.0 on `ubuntu-24.04`); optional locally |
| markdownlint-cli2 | Not installed globally; `npx --yes markdownlint-cli2` fetches it on demand |
| lefthook, lcov, gcovr | Not in use: no git hooks manager and no coverage gate yet |

---

## Prerequisites

### Ubuntu 24.04 packages

| Package | Provides | State on 27/09/2026 |
| --- | --- | --- |
| `build-essential` | gcc, g++, make, libc headers | installed (12.10ubuntu1) |
| `gdb` | gdb | installed (15.1-1ubuntu1~24.04.1) |
| `valgrind` | valgrind | installed (1:3.22.0-0ubuntu3) |
| `qemu-system-x86` | qemu-system-x86_64 | installed (1:8.2.2+ds-0ubuntu1.18) |
| `cloc` | cloc | installed (1.98-1) |
| `git`, `curl` | git; curl for the rustup installer | installed |

The state column comes from `apt-cache policy <package>`. The learner installs anything missing:

```bash
sudo apt install build-essential gdb valgrind qemu-system-x86 cloc git curl
```

### Rust

rustup manages the Rust toolchains. The repository pins its own in `code/src/rust/rust-toolchain.toml`:
`channel = "1.92.0"`, `profile = "minimal"`, `components = ["rustfmt", "clippy"]`.

```bash
# rustup itself (skip if `rustup --version` already works)
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh

# Components for the host default toolchain
rustup component add rustfmt clippy

# cargo-deny, built from source (a few minutes), at the version CI pins
cargo install --locked --version 0.19.0 cargo-deny
```

rustup 1.28.1 and later install a missing pinned toolchain automatically the first time `cargo` runs
inside `code/src/rust/` (1.28.0 did not, and `RUSTUP_AUTO_INSTALL=0` switches it off). To install it
explicitly, run `rustup toolchain install` from inside that directory.

---

## Getting Started

```bash
# 1. Install the apt packages (the learner runs this; it needs sudo)
sudo apt install build-essential gdb valgrind qemu-system-x86 cloc git curl

# 2. Install rustup (skip if `rustup --version` works), then load it into this shell
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
. "$HOME/.cargo/env"

# 3. Add the Rust components and cargo-deny (the version CI pins)
rustup component add rustfmt clippy
cargo install --locked --version 0.19.0 cargo-deny

# 4. Install the pinned toolchain from inside the workspace
cd code/src/rust
rustup show active-toolchain || rustup toolchain install
cd ../../..

# 5. Print the version table and compare it with the Overview above
bash code/src/scripts/toolchain/check.sh
```

The full walk-through, ending in a green ms001 build, is `how-to/workflows/01-toolchain-setup/`; the
long-form runbook is `how-to/src/MACHINE-SETUP.md`.

---

## Which script needs which tool

A script whose tool is missing exits 2 ("could not run"), never 0.

| Script (under `code/src/scripts/`) | Needs |
| --- | --- |
| `c/build.sh`, `c/test.sh`, `c/san.sh`, `c/lint.sh` | gcc, make |
| `c/memcheck.sh` | gcc, make, valgrind |
| `rust/build.sh`, `rust/test.sh` | cargo, rustc |
| `rust/lint.sh` | cargo, rustfmt, clippy |
| `rust/audit.sh` | cargo-deny |
| `audits/docs-length.sh` | cloc |
| `toolchain/check.sh` | only bash and the standard shell utilities; it reports on everything else |

---

## P4 prerequisites — not yet installed

P4 (kernel internals, `project-management/src/01-ROADMAP/ROADMAP.md`) needs more packages. They are
recorded here now so the gap is visible, and installed when P4 opens. Minimum versions are listed in the
kernel's own `Documentation/process/changes.rst` (see `how-to/REFERENCES.md`).

### Kernel build

| Package | Needed for | State on 27/09/2026 | apt candidate |
| --- | --- | --- | --- |
| `flex` | Kconfig and dtc lexers | **not installed** | 2.6.4 |
| `bison` | Kconfig and dtc parsers | **not installed** | 3.8.2 |
| `libelf-dev` | objtool and module tooling | **not installed** | 0.190 |
| `dwarves` | `pahole`, for BTF (`CONFIG_DEBUG_INFO_BTF`) | **not installed** | 1.25 |
| `bc` | build-time constants | installed (1.07.1) | — |
| `cpio` | packing the initramfs | installed (2.15) | — |
| `libssl-dev` | module signing and certificates | installed (3.0.13) | — |
| `libncurses-dev` | `make menuconfig` | installed (6.4) | — |
| `busybox-static` | initramfs userland | installed (1.36.1) | — |

`pahole` needs a check at P4: the minimal-requirements table in `changes.rst` currently lists 1.26 while its
BTF paragraph says 1.22, and Ubuntu 24.04's `dwarves` is 1.25. Compare against the kernel version pinned
at P4, or build without BTF. The open question is tracked in `GAPS.md` ("pahole minimum for P4 is unclear").

### Rust-for-Linux (blocked until LLVM is installed)

| Component | Needed for | State on 27/09/2026 |
| --- | --- | --- |
| `clang`, `lld` | building the kernel with `LLVM=1` | **not installed** (candidate 18) |
| `llvm` | LLVM tools | installed (18) |
| `libclang-dev` | libclang, which bindgen loads | **not installed** (candidate 18) |
| bindgen | generating Rust bindings to kernel C | **not installed** (`bindgen-0.71` in apt, or `cargo install --locked bindgen-cli`) |
| `rust-src` component | the kernel build compiles `core` itself | not in the pinned 1.92.0 toolchain |

The kernel's Rust quick start lists rustc 1.85.0 as the current minimum, which 1.92.0 meets. On Ubuntu
24.04 the versioned `bindgen-0.71` package installs a `bindgen-0.71` binary rather than `bindgen`; the
quick start shows how to select it. Once installed, `make LLVM=1 rustavailable` in the kernel tree reports
whether everything is found. The learner installs these at P4:

```bash
sudo apt install flex bison libelf-dev dwarves
sudo apt install clang lld libclang-dev bindgen-0.71
```

---

## Troubleshooting

### `check.sh` exits 2

A required tool is missing and the table names it. Install it from Prerequisites above, then re-run the
check. The full diagnosis path is `how-to/workflows/05-debugging-environment/`.

### `check.sh` exits 1

Every tool is present, but the `rustc` found inside `code/src/rust/` is not the pinned 1.92.0, typically a
distribution `rustc` with no rustup in front of it on `PATH`. Install rustup (Prerequisites → Rust) and check
that `command -v rustc` points into `~/.cargo/bin`.

### `error: toolchain '1.92.0-x86_64-unknown-linux-gnu' is not installed`

The pinned toolchain is absent and automatic installation is off (rustup 1.28.0, or
`RUSTUP_AUTO_INSTALL=0`). rustup prints the fix beneath it,
``help: run `rustup toolchain install` to install it``; run that from inside `code/src/rust/`.

### `rustc --version` does not print 1.92.0

You are outside `code/src/rust/`, so rustup is using your host default toolchain. That is expected: the pin
applies only inside the workspace. It also means `cargo --manifest-path code/src/rust/Cargo.toml …` run
from the repository root builds with the host default, not the pin. Run cargo from inside the workspace.

### ``error: no such command: `deny` ``

cargo-deny is not installed. Run `cargo install --locked --version 0.19.0 cargo-deny`; `rust/audit.sh` reports exit 2 until
you do.

### `Enable debuginfod for this session? (y or [n])`

gdb 15 on Ubuntu offers to download debug symbols for system libraries. Answer `n` for local work, or make
it permanent by adding `set debuginfod enabled off` to `~/.gdbinit`. Non-interactive runs (`gdb -batch`)
answer `N` by themselves.

### A version in `check.sh` differs from the Overview table

The host moved on, usually through an `apt upgrade`. Do not edit the table by hand; run
`how-to/workflows/04-toolchain-updates/`, which re-runs the gates and re-records the table.

_Part of the `how-to/docs/` documentation family._
