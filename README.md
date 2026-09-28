# c-rust-learning

**Learning C from the ground up and Rust, then maintaining a downstream Linux kernel, building
Syntek OS from scratch with its own TUI and GUI tools, and training an efficient, secure language
model — in public, one tested milestone at a time.**

---

## What this is

> A public learning space: learn C thoroughly from the base level and deepen Rust; learn Linux kernel development and
> maintain a downstream kernel; build Syntek OS — an independent Linux distribution, built from scratch, with profiles
> for beginner, intermediate and expert desktops and laptops, servers, NAS, homelab and routers, and its own TUI and GUI
> tools; and, in parallel, build and train a language model in C, Rust and Python that uses CPU, RAM, GPU, VRAM and
> cache efficiently and securely, and works through Markdown skills, workflows and documentation.

This repository is the whole of that journey: the curriculum and its decisions, the notes and
practice from each study session, and the code that proves each skill — tested, run under the
sanitisers and valgrind, and reviewed before a milestone closes. It is a learning record rather
than a product, so expect early exercises to be simple and the mistakes along the way to be
written down rather than hidden.

The C is written in the Linux kernel coding style from the first exercise, because the kernel is
where it is heading. The repository is licensed GPL-2.0-only for the same reason.

This repository holds the lessons, the notes and the small exercises. The substantial builds —
the downstream kernel tree, the Syntek OS build system, package manager, installer and tools, and
the language model's data, training and inference code — each move to a repository of their own
when that build starts, under a name and licence chosen then.

## Roadmap

Eighteen phases in six tracks; each phase opens when the gates it depends on pass, so the tracks
run side by side — interleaved one milestone at a time, never two at once. The full table, with
every gate and dependency spelled out, is
[`project-management/src/01-ROADMAP/ROADMAP.md`](project-management/src/01-ROADMAP/ROADMAP.md).

| Track | Phases | Covers |
| --- | --- | --- |
| Foundation | P1 C foundations · P2 C systems · P3 Rust | The C language and its memory model, systems programming with POSIX, then Rust from ownership to `unsafe`, FFI with C and async |
| Kernel | P4 Kernel internals · P5 Downstream kernel | Building and booting kernels in QEMU, modules, Kconfig; then a downstream of upstream Linux — a small patch series rebased per release, per-profile configs, kernel CI and CVE triage |
| Syntek OS | P6 Syntek OS | An independent distribution built from scratch — Linux From Scratch, then an own build system, init, package manager with signed repositories, installer — with profiles for beginner, intermediate and expert desktops and laptops, servers, NAS, homelab and routers |
| UI | U1 TUI foundations · U2 Syntek OS tools · U3 GUI tools and web admin | Terminal programs and ratatui, then the file manager, package-manager, installer and system-tool TUIs, then GUI tools and a web admin dashboard |
| LLM | L1–L6 | A local-model baseline with hand-written skills, ML foundations, CPU and GPU performance, llm.c, training a small code model, efficient and secure Rust inference with a skills layer, then efficient architectures, scale and adapters |
| Security | S1–S3 | Threat modelling, memory corruption, fuzzing, the Linux security model and cryptography; an authorised, isolated pentest lab; then hardening and testing my own systems, malware defence included |

Every kernel-config, OS and LLM milestone states a resource budget — CPU time, RAM, cache, GPU
time, VRAM — and measures it; every milestone names its threat model.

**Where it stands now:** P1, milestone MS001 (Toolchain ready) — open.

## Repository layout

| Layer | What lives there |
| --- | --- |
| [`project-management/`](project-management/CONTEXT.md) | The curriculum: roadmap and maps, milestones, exercise and project specs, kernel specs and Syntek OS profiles, decisions (ADRs), verification records |
| [`learning/`](learning/CONTEXT.md) | One folder per topic: the planned lessons, the goal, the sources, and a retrieval-practice log with spaced review dates |
| [`code/`](code/CONTEXT.md) | Working, tested code — C exercises built with make, a Rust Cargo workspace, the gate scripts — plus the coding standards and step-by-step coding workflows |
| [`how-to/`](how-to/CONTEXT.md) | The toolchain, machine setup, the daily study routine and the quality gates |
| [`research/`](research/CONTEXT.md) | Notes that answer one question each from primary sources, feeding the decisions |
| [`handoffs/`](handoffs/CONTEXT.md) | Where an unfinished session leaves off, so the next one can pick it up |

**project-management/ plans the curriculum; learning/ drills it; code/ is where practice becomes
working, tested code.** Every folder carries a `CONTEXT.md` (what is here and why) and a
`CLAUDE.md` (how to work here); [`CONTEXT.md`](CONTEXT.md) is the full map and
[`REFERENCES.md`](REFERENCES.md) indexes every guide and workflow.

## Toolchain

Developed on Ubuntu 24.04 and checked in CI on GitHub's `ubuntu-24.04` runners.

| Tool | Used for |
| --- | --- |
| gcc | Compiling C17 with warnings as errors, AddressSanitizer + UBSan, and `-fanalyzer` |
| GNU make | Building and testing every C exercise |
| gdb | Debugging exercises now, and kernels under QEMU from P4 |
| valgrind | Memcheck on every C exercise's tests |
| rustup, cargo, rustfmt, clippy | The Rust workspace — the toolchain version is pinned by `code/src/rust/rust-toolchain.toml` |
| cargo-deny | Checking crate licences stay GPL-2.0-compatible |
| qemu-system-x86_64 | Booting kernels and Syntek OS images, from P4 — never the host |
| python3, uv, ruff | The LLM track's Python, from L1 — PyTorch is installed per project through uv |
| ollama | Running an open coding model locally, the LLM track's first baseline |
| NVIDIA driver | The RTX 2080 Ti the LLM track trains and measures on (the CUDA toolkit arrives at L2) |

Exact versions, what is still missing (the kernel build dependencies, clang/LLVM for
Rust-for-Linux, the CUDA toolkit and the LLM, OS and security track tools) and why each tool is
here: [`how-to/docs/TOOLCHAIN.md`](how-to/docs/TOOLCHAIN.md)
and [`GAPS.md`](GAPS.md). Setting up a fresh machine:
[`how-to/workflows/01-toolchain-setup/`](how-to/workflows/01-toolchain-setup/CONTEXT.md).

## Getting started

```bash
git clone https://github.com/SamBailey6194/c-rust-learning.git
cd c-rust-learning

# C: build and run every exercise's tests
make -C code/src/c test

# C: the same tests under AddressSanitizer + UBSan, then under valgrind
make -C code/src/c san
make -C code/src/c memcheck

# Rust: the whole workspace, from inside it so rustup applies the pin
(cd code/src/rust && cargo test)
```

rustup reads `code/src/rust/rust-toolchain.toml` from the **current directory**, so running cargo
inside the workspace uses the exact compiler that CI and the gate scripts hold the code to.
`cargo test --manifest-path code/src/rust/Cargo.toml` from the repository root runs the same tests
but with whatever toolchain is your default, so it is not the way to check the pinned build.

Each raw command above is also wrapped by a script under `code/src/scripts/`, and
`bash code/src/scripts/gates/all.sh` runs every scripted gate (C, Rust and the docs audits — gates 1
to 11) in order with a summary. CI also runs markdownlint, ShellCheck and a TruffleHog secrets scan,
which `all.sh` does not; `how-to/workflows/03-quality-gates/` lists all fourteen and how to run the
lints locally. `bash code/src/scripts/toolchain/check.sh` reports which tools are installed and at
which version.

## How I learn here

- **One milestone at a time.** Each milestone names what I should be able to do at the end, and
  closes only when the commands that prove it run clean.
- **Lessons with `/teach`.** Claude Code acts as a tutor, not a solver: it asks how I plan to
  tackle a problem before helping, explains through questions, and does not write exercise
  solutions unless I ask. Each topic gets a folder in `learning/`.
- **Retrieval practice and spaced repetition.** Every lesson ends with recall questions answered
  from memory, and schedules its own reviews at widening intervals (one day, three days, a week).
- **Practice becomes code.** What a lesson drills is then built for real under `code/src/`,
  test first, and reviewed against the standards in `code/docs/`.
- **Handoffs, not lost context.** When a session has to stop mid-work, `/handoff` writes where it
  got to into `handoffs/`, so the next session resumes from a file rather than from memory.

The rules Claude works under are in [`.claude/CLAUDE.md`](.claude/CLAUDE.md).

## Contributing

This is a personal learning repository, so most changes are mine — but corrections, bug reports
and topic suggestions are welcome. Please don't send solutions to open exercises. Details:
[`CONTRIBUTING.md`](CONTRIBUTING.md). Security problems go through private reporting, never a
public issue: [`SECURITY.md`](SECURITY.md).

## Licence

**GPL-2.0-only** — see [`LICENSE`](LICENSE). It matches the Linux kernel, which this repository
builds towards, so that kernel patches and modules written here can carry the kernel's own
licence. Rust dependencies are held to GPL-2.0-compatible licences by `code/src/rust/deny.toml`;
an Apache-2.0-only crate a lesson needs is admitted only as a documented per-crate exception, since
this repository is for learning and distributes no binaries. Licences are chosen per repository:
the product repositories choose their own when each build starts, from an approved list under
inbound rules (`project-management/src/08-DECISIONS/ADR-MS001-PRODUCT-LICENCES-INBOUND-RULES-27-09-2026.md`).

---

_Maintained by Sam Bailey · British English (en_GB) throughout_
