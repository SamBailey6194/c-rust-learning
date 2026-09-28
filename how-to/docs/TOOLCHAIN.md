---
type: guide
---

# Toolchain — c-rust-learning

**Last Updated**: 28/09/2026 | **Version**: 0.1.0 | **Maintained By**: Sam Bailey
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

### Later-track tools already installed — recorded 27/09/2026

Present on the host before their tracks open; `check.sh` does not report them yet.

| Tool | Version | Purpose |
| --- | --- | --- |
| perf | 7.0.14 (`linux-tools-common`) | CPU performance counters — locked for unprivileged users (`GAPS.md`) |
| python3 | 3.12.3 (Ubuntu's default `/usr/bin/python3`) | The LLM track's Python, from L1; `python3.13` 3.13.15 and `python3.14` 3.14.6 are also installed from the deadsnakes PPA |
| uv | 0.12.5 | Per-project Python environments and interpreter pins (L1) |
| ruff | 0.14.11 | Python linting and formatting (L1) |
| ollama | 0.34.0 | Runs an open coding model locally — the LLM track's first baseline |
| NVIDIA driver | 580.178.04 | The RTX 2080 Ti (11264 MiB, compute capability 7.5); `nvidia-smi` reports CUDA Version 13.0. GPU counters are admin-only (`GAPS.md`) |
| Xvfb | 2:21.1.12-1ubuntu1.8 (`xvfb`) | The scripted recorder's private X display (`c-05-scripted-screen-recorder`, P2) |
| ffmpeg | 6.1.1 | Encodes the recorder's frames, fed to it through a pipe (`c-05`) |
| setxkbmap | `x11-xkb-utils` 7.7+8build2 | Pins the recorder's keyboard layout inside Xvfb |
| libx11-dev, libxext-dev | 1.8.7, 1.3.4 | Xlib and the MIT-SHM extension headers for `c-05` (the XTest headers are missing — below) |
| bwrap | 0.9.0 (`bubblewrap`) | Namespaced sandboxes; `sec-04`'s launcher and the recorder's later fixed-name fixture |

### Not installed, and why

| Tool | Why it is absent |
| --- | --- |
| clang, lld, libclang-dev, bindgen | Arrive with P4 Rust-for-Linux (see P4 prerequisites below) |
| clang-format, clang-tidy | Not in use: C follows the Linux kernel coding style, checked in review |
| cmake, bear | Not used: the build is plain GNU make (ADR in `project-management/src/08-DECISIONS/`) |
| shellcheck | Runs in CI (0.9.0 on `ubuntu-24.04`); optional locally |
| markdownlint-cli2 | Not installed globally; `npx --yes markdownlint-cli2` fetches it on demand |
| lefthook, lcov, gcovr | Not in use: no git hooks manager and no coverage gate yet |
| reuse, an SBOM generator and validator | Arrive with `tooling-05` lessons 03 and 08; the generator and validator are chosen by the SBOM research note (`GAPS.md` → No SBOM generator or REUSE linter installed) |
| libxtst-dev | The XTest headers for `c-05` lesson 04; `libxtst6` (the runtime library) is installed (`GAPS.md` → Scripted recorder build dependencies not installed) |
| vhs, ttyd | The route for terminal-only videos before the recorder exists is decided before first use; nothing is installed on the host until then |
| Hyprland, GNOME and KDE Wayland sessions | Guest only, for `ui-12` and `ui-13`: images are fetched outside git and never run as Sam's desktop session |

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

## P6 prerequisites

P6 (Syntek OS, `project-management/src/01-ROADMAP/ROADMAP.md`) builds Linux From Scratch **inside a
VM**, never on the host's disks, so the LFS 13.1-systemd book's host requirements (its Section 2.2)
apply to the VM's own system, not to this machine — `bison` and `texinfo`, absent here, are
installed in the VM. On the host, P6 needs the VM tooling and the tools of its own listed below.

| Package or tool | Needed for | State on 27/09/2026 |
| --- | --- | --- |
| `qemu-system-x86`, `qemu-utils` | the build VM and every profile image; `qemu-img` disk images and snapshots | installed (8.2.2) |
| `ovmf` | UEFI firmware for QEMU, for the ESP and UEFI boot lessons | installed (2024.02) |
| `util-linux`, `e2fsprogs` | `sfdisk`, `losetup`, `mkfs.ext4` on disk images | installed (2.39.3, 1.47.0) |
| `diffoscope` | comparing two builds for reproducibility | **not installed** (candidate 259) |
| `minisign` | signing a package repository | **not installed** (candidate 0.11) |
| `wireguard-tools` | `wg` and `wg-quick` for the router and `os-18`'s tunnels, in the namespace lab | installed (1.0.20210914) |
| `dnsmasq-base` | `os-09` lesson 07's lab-only DHCP and DNS server, and `os-18`'s lab LAN | installed (2.91) |
| `prometheus`, `prometheus-node-exporter` | `os-18` lesson 07's monitoring of Sam's own machines | **not installed** (candidates 2.45.3 and 1.7.0; upstream v3.15.0 and v1.12.1 — the route is chosen when the lesson opens; `GAPS.md`) |
| `tmux` | `os-18` lesson 10's shared, consent-first help session | **not installed** (candidate 3.4; `GAPS.md`) |

The build VM itself, with disk room for LFS, is tracked in `GAPS.md`.

---

## L1–L2 prerequisites — not yet installed

The LLM track (L1–L2 first) needs more than the tools recorded above.

| Package or tool | Needed for | State on 27/09/2026 |
| --- | --- | --- |
| PyTorch | L1 onwards; installed per project through uv, never system-wide | **not installed** — which build suits compute capability 7.5 is a planned research note (`research/CONTEXT.md`) |
| pytest | Python tests (the planned Python CI gate) | **not installed**; per project through uv |
| CUDA toolkit (`nvcc`) | CUDA kernels (L2) and llm.c's CUDA path | **not installed**; Ubuntu 24.04's `nvidia-cuda-toolkit` is 12.0.140 — the choice is a planned research note |
| Nsight Systems, Nsight Compute | GPU profiling (L2) | **not installed**; counters are admin-only (`GAPS.md`) |
| `hyperfine` | repeated, warmed-up command timing | **not installed** (candidate 1.18.0) |
| `heaptrack` | heap profiling | **not installed** (candidate 1.5.0) |
| llama.cpp | local inference, reading ggml | **not installed**; the release build (b11221: CPU, and CUDA 12.8 x64 for driver 580) needs no cmake; a source build with `-DCMAKE_CUDA_ARCHITECTURES=75` needs cmake and the CUDA toolkit |
| `cmake` | building llama.cpp from source (its build docs use CMake), not its release build | **not installed** (candidate 3.28.3) |
| `clang` | also needed by Rust-for-Linux (P4) and libFuzzer (security track) | **not installed** (candidate 18) |
| `git-lfs` | fetching large model and dataset files outside this repository | **not installed** (candidate 3.4.1) |

`perf` and the GPU counters need a restriction relaxed; a lesson shows Sam how, for one session, and
teaches the unprivileged fallback (`valgrind --tool=cachegrind`, `torch.profiler`). Claude never
runs `sudo`.

---

## Security track prerequisites

S1–S3 (`project-management/src/01-ROADMAP/ROADMAP.md`). Attack tooling runs in VMs on an isolated
lab network, never on the host (`.claude/CLAUDE.md` Section 5); only tools for Sam's own code and
systems (fuzzing, reading his own binaries, his private CA) belong here.

| Package or tool | Needed for | State on 27/09/2026 |
| --- | --- | --- |
| `libvirt-daemon-system`, `libvirt-clients` | the isolated lab network and its VMs; `kernel-11`'s libvirt lesson | installed (10.0.0) |
| `nmap`, `tcpdump` | scanning and packet capture — run from the attacker VM, not the host | installed (7.94SVN, 4.99.4) |
| `wireshark` | reading captures | **not installed** (candidate 4.2.2) |
| clang with libFuzzer, `afl++` | fuzzing Sam's own C | **not installed** (candidates 18, 4.09c) |
| Ghidra | reverse engineering Sam's own binaries | **not installed**; not packaged in Ubuntu 24.04 |
| pwntools | exploit practice on lab targets — inside the attacker VM | **not installed** (`python3-pwntools` candidate 4.12.0) |
| `openssl` | the private CA made by hand (`sec-05-applied-cryptography` lessons 08–12); run as a program, never linked | installed (3.0.13) |
| `libnss3-tools`, `p11-kit`, `ca-certificates` | per-user and system trust stores (`certutil`, `trust`, `update-ca-certificates`) for `sec-05` lesson 12 | installed (3.98, 0.25.3, 20260601~24.04.1) |
| an ACME issuer | renewing short-lived leaves from the private CA (`sec-05` lesson 13) | **not chosen** — a research note, then an ADR (`GAPS.md` → "No ACME issuer chosen for the private CA") |

The attacker VM image is tracked in `GAPS.md`.

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
