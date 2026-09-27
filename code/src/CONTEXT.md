# code/src/ — Source Root

**Last Updated**: 27/09/2026 | **Version**: 0.1.0 | **Maintained By**: Sam Bailey
**Language**: British English (en_GB) | **Timezone**: Europe/London

Everything in this repository that is compiled, run or executed as a gate lives here, one folder per
track. `c/` holds the C exercises and the plain-make build they share; `rust/` is one Cargo workspace
whose crates include a Rust twin of each C exercise worth comparing; `scripts/` wraps every toolchain
command in the same exit-code contract, so a local run, Claude's verification and CI all report the
same way. The kernel and distro tracks join as their phases start, so the tree grows with the
roadmap (`project-management/src/01-ROADMAP/ROADMAP.md`) rather than ahead of it.

## Directory Tree

```text
code/src/
├── CONTEXT.md · CLAUDE.md       ← this map · operating rules for the source root
├── c/                           ← C track: gcc + GNU make, one folder per exercise
│   ├── CONTEXT.md · CLAUDE.md   ← the build system, the targets, the exercise list
│   ├── Makefile                 ← `make -C code/src/c <target>` runs it in every ms###-*/ folder
│   ├── mk/                      ← flags.mk (every flag, explained) · exercise.mk (every rule)
│   ├── include/                 ← check.h — the header-only test harness
│   └── ms001-hello/             ← MS001: greet() into a caller's buffer, with its tests
├── rust/                        ← Rust track: one Cargo workspace, compiler pinned by rust-toolchain.toml
│   ├── CONTEXT.md · CLAUDE.md   ← the workspace, the lint policy, the crate list
│   ├── Cargo.toml · Cargo.lock  ← workspace manifest and lint policy · committed lock file
│   ├── rust-toolchain.toml      ← the pinned compiler rustup reads inside this folder
│   ├── clippy.toml · rustfmt.toml · deny.toml   ← lint tuning · formatter edition · supply-chain policy
│   └── crates/ms001_hello/      ← the Rust twin of c/ms001-hello/
├── scripts/                     ← the gates: raw commands wrapped in the 0/1/2 exit contract
│   ├── CONTEXT.md · CLAUDE.md   ← every script, what it wraps, what its exit codes mean
│   └── _lib/ c/ rust/ audits/ toolchain/ gates/   ← shared helpers · one folder per concern
├── kernel/                      ← KERNEL-ONLY — planned, added at P4 (not created yet)
└── distro/                      ← DISTRO-ONLY — planned, added at P6 (not created yet)
```

## Sub-layers

| Directory | Contents | Read first |
| --- | --- | --- |
| `c/` | The C exercises (`ms###-kebab/`), the shared make rules in `mk/`, and `include/check.h` | `c/CONTEXT.md` |
| `rust/` | The Cargo workspace: one crate per exercise (`crates/ms###_snake/`), lint and supply-chain policy | `rust/CONTEXT.md` |
| `scripts/` | Every gate as a script: C, Rust, docs audits, the toolchain table, and `gates/all.sh` | `scripts/CONTEXT.md` |

## Tracks

A _track_ is one strand of the syllabus with its own toolchain and its own gates. Each has exactly one
home under `code/src/`, and each is present only from the phase that needs it.

| Track | Lives in | Toolchain | Present |
| --- | --- | --- | --- |
| **C** | `c/` | gcc, GNU make, gdb, valgrind | Now — P1 onwards |
| **Rust** | `rust/` | rustc and cargo (pinned), rustfmt, clippy, cargo-deny | Now — the MS001 twin; in depth from P3 |
| **FFI** | `rust/crates/` — one crate per bridge, its C half inside the crate | both of the above | From P3 |
| **Kernel** | `kernel/` | gcc, make, qemu-system-x86_64; clang/LLVM for Rust-for-Linux | Added at P4 |
| **Distro** | `distro/` | decided at P6, recorded as an ADR | Added at P6 |

The exact versions in use are recorded in `how-to/docs/TOOLCHAIN.md`; `scripts/toolchain/check.sh`
prints the versions actually installed.

## Why one folder per track

- **Each track has its own toolchain and its own gates.** `c/` answers to make and valgrind, `rust/` to
  cargo and clippy. Keeping them apart means a gate reads one folder and one set of flags, and a
  failure names the track it belongs to.
- **The C and Rust twins sit side by side.** `c/ms001-hello/` and `rust/crates/ms001_hello/` solve the
  same problem; the difference between them — a caller's buffer against an owned `String` — is the
  lesson, and it is easiest to see when both are one folder apart.
- **Later tracks arrive without disturbing earlier ones.** `kernel/` at P4 and `distro/` at P6 add a
  folder and a row above; nothing in `c/` or `rust/` moves.

Kernel builds and custom modules run in QEMU only, not on the host; that rule and its reasons are
owned by `.claude/CLAUDE.md`.

## Cross-references

- `code/CONTEXT.md` — the code layer: guides (`code/docs/`), workflows (`code/workflows/`) and this tree
- `code/docs/BUILD.md` — the C build: every flag and target, and why
- `code/docs/TESTING.md` — `check.h`, `cargo test`, and what a good test asserts
- `code/docs/DOCUMENTATION-PAIRING.md` — which directories carry the `CONTEXT.md` + `CLAUDE.md` pair
- `code/workflows/01-c-exercise/` and `code/workflows/03-rust-exercise/` — the procedures that add to this tree
- `how-to/workflows/03-quality-gates/` — running every gate and reading the results
- `project-management/src/01-ROADMAP/ROADMAP.md` — the phases that add `kernel/` and `distro/`
