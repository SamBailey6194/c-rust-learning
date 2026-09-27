# c-rust-learning — Project Overview

The entry point every session starts from: what this project is, how it is laid out, and where
each kind of work belongs. It comes before the layer being worked in, because every layer file
assumes the map below.

## What this project is

> A public learning space: learn C thoroughly from the base level, then deepen Rust knowledge and
> skills, and then build a custom Linux kernel for a custom set of Linux distributions at three
> tiers — beginner, intermediate and experienced.

**Read that first, every session.** It is the only statement of what this repository is for, and
every phase exit gate, milestone and exercise is judged against it. If it ever drifts from what
the repository has become, correcting it is a task in its own right, not a side-effect of some
other change.

The learner and maintainer is **Sam Bailey** (GitHub `SamBailey6194`); Claude Code acts as a
tutor under the manual in `.claude/CLAUDE.md`. The repository is public and licensed
GPL-2.0-only, the same licence as the Linux kernel it builds towards.

## How it is built

The curriculum runs in six phases — C foundations, C systems, Rust, kernel internals, a custom
kernel, and the three distro tiers — owned by `project-management/src/01-ROADMAP/ROADMAP.md`.

- **C** is C17, compiled by gcc with warnings as errors and written in the Linux kernel coding
  style from the first exercise. Each exercise is a `msNNN-kebab/` folder built by plain GNU make
  from shared includes, tested with a header-only `check.h` harness, and checked under
  AddressSanitizer + UndefinedBehaviorSanitizer and, separately, valgrind (`code/docs/BUILD.md`).
- **Rust** is one Cargo workspace on edition 2024 with the toolchain pinned by
  `code/src/rust/rust-toolchain.toml`; rustfmt, clippy and cargo-deny gate it.
- **The kernel and distro work** (P4 onwards) is built on the host and run only inside QEMU
  (`qemu-system-x86_64`), with `code/src/kernel/` added at P4 and `code/src/distro/` at P6.
- **Gates** are bash scripts under `code/src/scripts/`, run locally and by GitHub Actions on
  `ubuntu-24.04`. The docs teach the raw command first, then name the script that wraps it.

Why each of those choices was made is recorded as an ADR in
`project-management/src/08-DECISIONS/`; the exact tool versions are in `how-to/docs/TOOLCHAIN.md`.

## Directory Tree

```text
c-rust-learning/
├── .claude/                     ← Claude Code configuration: manual, memory, settings, hooks, skills
│   ├── CLAUDE.md                ← the manual — tutor posture, operating model, non-negotiables
│   ├── CONTEXT.md               ← orientation for .claude/
│   ├── MEMORY.md                ← project memory (feedback, patterns, project state)
│   ├── settings.json            ← permissions, hooks, auto-compaction switched off
│   ├── hooks/                   ← session-continuity hooks (context threshold, pre-compact)
│   └── skills/                  ← teach · handoff · research · wait-what
├── .github/                     ← CI gates, pull-request template, issue forms
│   ├── ISSUE_TEMPLATE/          ← bug report and topic suggestion forms
│   └── workflows/               ← Syntax — C / Rust / Shell · Markdown — Lint · Audit — Docs / Secrets
├── code/                        ← where practice becomes working, tested code
│   ├── CONTEXT.md · CLAUDE.md · REFERENCES.md   ← layer entry pair + reference index
│   ├── docs/                    ← standards: C, Rust, build, testing, memory safety, debugging, FFI
│   ├── src/                     ← C exercises (make), Rust workspace (cargo), gate scripts;
│   │                              kernel/ added at P4, distro/ at P6
│   └── workflows/               ← numbered coding procedures (01–08)
├── how-to/                      ← toolchain, machine setup, the daily study routine, the gates
│   ├── CONTEXT.md · CLAUDE.md · REFERENCES.md   ← layer entry pair + reference index
│   ├── docs/                    ← toolchain versions, CLI tooling, guide craft
│   ├── src/                     ← machine setup and host maintenance
│   └── workflows/               ← numbered operational procedures (01–06)
├── project-management/          ← the curriculum: roadmap, milestones, specs, decisions, records
│   ├── CONTEXT.md · CLAUDE.md · REFERENCES.md   ← layer entry pair + reference index
│   ├── docs/                    ← planning, git, verification and safety guides
│   ├── src/                     ← live artefacts, 01-ROADMAP … 13-BUGS
│   └── workflows/               ← numbered PM procedures in running order (01–13)
├── learning/                    ← /teach sandbox — one folder per topic, spaced-review log
├── research/                    ← /research notes — one question each, cited to primary sources
├── handoffs/                    ← /handoff documents — the auto-compaction replacement
├── AGENTS.md                    ← entry shim for coding agents other than Claude Code
├── CONTEXT.md                   ← this file
├── CONTRIBUTING.md              ← how issues, corrections and pull requests are handled
├── DEFERRED.md                  ← register: topics parked for a later phase
├── GAPS.md                      ← register: active gaps, blockers and open questions
├── LICENSE                      ← the GPL-2.0 text, verbatim
├── README.md                    ← the public front door
├── REFERENCES.md                ← index of every guide and workflow, cross-layer pairing, sources
├── SECURITY.md                  ← how to report a security problem
├── .editorconfig                ← indentation: kernel-style tabs for C, 4 spaces for Rust
├── .gitattributes               ← LF everywhere, and the binary list
├── .gitignore                   ← build output, core dumps, images, local config
└── .markdownlint-cli2.jsonc     ← Markdown lint rules, each with its reason
```

## Layer Map

| Layer | Purpose |
| --- | --- |
| `project-management/` | The curriculum: phases, milestones, exercise and project specs, kernel and distro-tier specs, decisions, and the verification record |
| `learning/` | Drilling: one `/teach` folder per topic, retrieval practice, spaced review dates |
| `code/` | Working, tested C and Rust, with the standards and procedures that govern it |
| `how-to/` | The toolchain, machine setup, the daily study routine and the quality gates |
| `research/` | One-question notes cited to primary sources, feeding decisions |
| `handoffs/` | Continuity between context windows when a session ends mid-work |
| `.claude/` | The manual, project memory, hooks and skills |

**project-management/ plans the curriculum; learning/ drills it; code/ is where practice becomes
working, tested code.** The canonical map of which workflow in one layer pairs with which in
another lives in `REFERENCES.md` → _Cross-layer pairing_; no layer's `CONTEXT.md` repeats it.

## Starting Points

- **New here, or setting up a machine?** → `how-to/CONTEXT.md`
- **Starting a study session?** → `how-to/workflows/02-daily-study-session/`
- **Learning a new concept?** → `/teach <topic>`, which writes under `learning/` (`learning/CONTEXT.md`)
- **Writing, testing or debugging code?** → `code/CONTEXT.md`
- **Planning a phase, milestone or decision?** → `project-management/CONTEXT.md`
- **Where the curriculum stands?** → `project-management/src/01-ROADMAP/ROADMAP.md`
- **Operating rules for Claude?** → `.claude/CLAUDE.md`
- **Looking for a specific guide or workflow?** → `REFERENCES.md`

## How this repository documents itself

Every directory someone works in carries two files: a `CONTEXT.md` saying **what is here and why
it is here**, and a `CLAUDE.md` saying **how to work here**. This root is the main exemption: it
carries `CONTEXT.md` only, because the manual that plays its `CLAUDE.md` role is
`.claude/CLAUDE.md` (a root `/CLAUDE.md` is gitignored so a generated one cannot drift from it).
The other exempt classes — `.github/`, skill folders, build output, support folders covered by
their parent, and sandbox content under `learning/`, `research/` and `handoffs/` — are listed in
`code/docs/DOCUMENTATION-PAIRING.md`.

The split keeps each rule in exactly one place, so changing it changes it everywhere. The
decision test and the fixed shapes live in `code/docs/DOCUMENTATION-PAIRING.md`, the 300-line cap
on instructional Markdown in `code/docs/DOCUMENTATION-LENGTH.md`, and both are checked by
`code/src/scripts/audits/`.

## Repository State

**Phase P1 — C foundations. Milestone MS001 (Toolchain ready) — Open.** The milestone file is
`project-management/src/02-MILESTONES/MS001-TOOLCHAIN-READY.md`; the phase table and exit gates
are in `project-management/src/01-ROADMAP/ROADMAP.md`.

The scaffold ships one worked example per language — `code/src/c/ms001-hello/` and
`code/src/rust/crates/ms001_hello/` — so every gate has something real to run against from the
first commit. Documentation metadata is at version 0.1.0 (27/09/2026). Active blockers, including
the kernel build dependencies P4 needs, are tracked in `GAPS.md`.

## Cross-references

- `.claude/CLAUDE.md` — the manual this map is imported into
- `REFERENCES.md` — every guide and workflow by path, the cross-layer pairing, external sources
- `README.md` — the public-facing summary of the same project
- `GAPS.md` · `DEFERRED.md` · `.claude/MEMORY.md` — the three registers
