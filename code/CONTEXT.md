# code/ — Coding Standards, Build and Practice

**Last Updated**: 27/09/2026 | **Version**: 0.1.0 | **Maintained By**: Sam Bailey
**Language**: British English (en_GB) | **Timezone**: Europe/London

This layer holds everything that is compiled or executed, together with the standards and procedures
that govern it. The three sub-layers are deliberately not interchangeable: `docs/` decides a rule once,
`workflows/` sequences the work that applies it, and `src/` is the only place source lives — the C
exercises, the Rust workspace and the scripts that wrap every toolchain command. Keeping the C track, the
Rust track and, later, the kernel under one `docs/` tree is what stops them drifting into separate
doctrines, and it is why an FFI crate and a first C exercise cite the same memory-safety guide. This is
where practice graduates into code that builds, passes its tests and runs clean under the memory tools,
at the pace the roadmap sets (`project-management/src/01-ROADMAP/ROADMAP.md`).

## Directory Tree

```text
code/
├── CONTEXT.md · CLAUDE.md           ← this file · operating rules for the layer (tutor mode)
├── REFERENCES.md                    ← internal index and external sources for the whole layer
├── docs/                            ← the coding standards: each rule decided once
│   ├── CONTEXT.md · CLAUDE.md       ← the guide catalogue · how to change a guide
│   ├── CODING-PRINCIPLES.md         ← Pike, Torvalds, Beck — applied to C and Rust
│   ├── C-CODING-PRINCIPLES.md       ← kernel style, headers and linkage, errors, C17
│   ├── RUST-CODING-PRINCIPLES.md    ← rustfmt, the lint policy, errors as values, unsafe
│   ├── BUILD.md                     ← every gcc flag and make target, the cargo commands
│   ├── TESTING.md                   ← check.h, cargo test, test discipline, coverage
│   ├── MEMORY-SAFETY.md             ← undefined behaviour, ownership, ASan + UBSan, valgrind
│   ├── DEBUGGING.md                 ← gdb, core files, reading reports, QEMU + gdb (P4)
│   ├── FFI.md                       ← P3 — the C and Rust boundary
│   ├── DOCUMENTATION-PAIRING.md     ← the CONTEXT.md / CLAUDE.md split
│   └── DOCUMENTATION-LENGTH.md      ← the 300-line instructional limit
├── src/                             ← all source, one folder per track
│   ├── CONTEXT.md · CLAUDE.md       ← the tracks table · source-root rules
│   ├── c/                           ← C track: gcc + GNU make, one folder per exercise (ms###-kebab/)
│   ├── rust/                        ← Rust track: one Cargo workspace (crates/ms###_snake/)
│   ├── scripts/                     ← every gate as a script, in the 0/1/2 exit contract
│   ├── kernel/                      ← KERNEL-ONLY — planned, added at P4
│   └── distro/                      ← planned, added at P6
└── workflows/                       ← step-by-step coding workflows, by family below
    ├── CONTEXT.md · CLAUDE.md       ← the workflow catalogue · how to run one
    │   ── Build (01–04) ──
    ├── 01-c-exercise/               ← one C exercise, from its spec to a clean analyser run
    ├── 02-tdd-cycle/                ← red → green → refactor with check.h and cargo test
    ├── 03-rust-exercise/            ← a new crate, or a Rust port of a finished C exercise
    ├── 04-ffi-bridge/               ← P3 — C and Rust across a thin extern "C" boundary
    │   ── Verify (05–06) ──
    ├── 05-review/                   ← read finished code against code/docs/
    ├── 06-memory-check/             ← ASan + UBSan, valgrind memcheck, -fanalyzer
    │   ── Diagnose & improve (07–08) ──
    ├── 07-debug/                    ← fix it: reproduce, shrink, failing test first, minimal fix
    └── 08-refactor/                 ← improve it: behaviour-preserving steps, tests green throughout

Each workflow folder holds CONTEXT.md · CLAUDE.md · STEPS.md · CHECKLIST.md.
```

## Sub-layers

| Sub-layer | Its job | What it holds |
| --- | --- | --- |
| `docs/` | Decides each rule once, with the reasons | Ten guides, each the single owner of its subject |
| `workflows/` | Sequences the work that applies the rules | Eight workflows in three families; numbers are identifiers, not a running order |
| `src/` | Holds the source | C exercises, the Rust workspace, and the scripts that CI and Claude's verification run |

## When to read this

- Starting a C exercise, a Rust crate or, from P3, an FFI crate
- Choosing a compiler flag, a make target or a cargo command
- Writing tests, or chasing a crash, a wrong answer or a memory error
- Reviewing code before a pull request
- Writing or reshaping a `CONTEXT.md` / `CLAUDE.md` pair, or a guide that is growing past 300 lines

## Do not use for

- Installing, checking or updating the toolchain; the daily study session → `how-to/CONTEXT.md`
- The roadmap, milestones, sprints, exercise specs and decisions → `project-management/CONTEXT.md`
- Concept notes and `/teach` sessions → `learning/CONTEXT.md`
- Background reading notes → `research/CONTEXT.md`

## Key docs

| Guide | When to read |
| --- | --- |
| `docs/CODING-PRINCIPLES.md` | Before writing any code |
| `docs/C-CODING-PRINCIPLES.md` | Before writing or reviewing C — the kernel style, headers, error handling |
| `docs/RUST-CODING-PRINCIPLES.md` | Before writing or reviewing Rust — the lint policy and `unsafe` |
| `docs/BUILD.md` | Before touching a Makefile, a flag or a cargo command |
| `docs/TESTING.md` | Before writing any test |
| `docs/MEMORY-SAFETY.md` | Before running the memory tools, and whenever one fails |
| `docs/DEBUGGING.md` | When a program crashes or gives the wrong answer |
| `docs/FFI.md` | **P3.** Before the first crate that crosses between C and Rust |
| `docs/DOCUMENTATION-PAIRING.md` | Before writing or restructuring any `CONTEXT.md` / `CLAUDE.md` pair |
| `docs/DOCUMENTATION-LENGTH.md` | When an instructional file nears 300 lines |

## Cross-references

- `code/CLAUDE.md` — the operating rules for this layer, tutor mode included
- `code/REFERENCES.md` — every internal path and external source the layer cites
- `code/src/CONTEXT.md` — the tracks: where each kind of source lives, and from which phase
- `code/workflows/CONTEXT.md` — the workflow families, and when to use each
- `project-management/src/01-ROADMAP/ROADMAP.md` — the phases this layer's exercises serve
- `how-to/workflows/03-quality-gates/` — the gates every change here passes
