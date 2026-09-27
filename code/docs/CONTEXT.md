# code/docs/ — Coding Reference Guides

**Last Updated**: 27/09/2026 | **Version**: 0.1.0 | **Maintained By**: Sam Bailey
**Language**: British English (en_GB) | **Timezone**: Europe/London

These guides are where the standards for `code/src/` are decided, so that no rule has to be re-derived at
the point of use and no two files can disagree about it. Each guide owns one subject — the build, C
style, Rust style, testing, memory safety, debugging, the C and Rust boundary, and the two rules that
shape the documentation itself — and every other file in the repository cites the owner instead of
repeating it. A guide stays a single file while it fits in 300 code lines; past that it becomes a thin
index with a `kebab-case/` sub-folder beside it, because an instructional file stops being readable long
before it stops being writable. Every guide fits today, so there are no sub-folders yet. Each guide
teaches the raw command first — gcc, make, gdb, valgrind, cargo — and then names the script that wraps
it, because in a learning repository the command is the lesson.

## Directory Tree

```text
code/docs/
├── CONTEXT.md · CLAUDE.md       ← this file (the guide catalogue) · how to edit a guide
│
│   ── Principles ──
├── CODING-PRINCIPLES.md         ← Pike's five rules, Torvalds' good taste, Beck's four rules
├── C-CODING-PRINCIPLES.md       ← kernel coding style, headers and linkage, error handling, C17
├── RUST-CODING-PRINCIPLES.md    ← rustfmt, the workspace lint policy, errors as values, unsafe
│
│   ── Build, test, verify ──
├── BUILD.md                     ← every gcc flag and make target, the cargo commands, the scripts
├── TESTING.md                   ← check.h, cargo test, test discipline, coverage as information
├── MEMORY-SAFETY.md             ← undefined behaviour, ownership, ASan + UBSan, valgrind, -fanalyzer
├── DEBUGGING.md                 ← gdb, core files, reading reports, rust-gdb, QEMU + gdb (P4)
├── FFI.md                       ← P3 — the C and Rust boundary, and its two test suites
│
│   ── Documentation ──
├── DOCUMENTATION-PAIRING.md     ← the CONTEXT.md / CLAUDE.md split and the exemption classes
└── DOCUMENTATION-LENGTH.md      ← the 300-line instructional limit and how a guide splits
```

## Guides

| Guide | Owns | When to read | From |
| --- | --- | --- | --- |
| `CODING-PRINCIPLES.md` | The principles every language guide applies | Before writing code in either language | P1 |
| `C-CODING-PRINCIPLES.md` | C style (the kernel's), headers and linkage, error conventions, the C17 dialect | Before writing or reviewing C | P1 |
| `RUST-CODING-PRINCIPLES.md` | The Rust lint policy and the `unsafe` rules | Before writing or reviewing Rust | P1 |
| `BUILD.md` | Build flags and make targets; the cargo commands | Before touching a Makefile, a flag or a cargo command | P1 |
| `TESTING.md` | The `check.h` API, the test discipline, coverage's status | Before writing any test | P1 |
| `MEMORY-SAFETY.md` | The bug classes, allocation ownership, the three memory tools | Before `make san`, `make memcheck` or `make lint`, and when one fails | P1 |
| `DEBUGGING.md` | gdb, core files, reading every tool's report | When a program crashes or gives the wrong answer | P1 (kernel section P4) |
| `FFI.md` | The shape of the C and Rust boundary; the FFI crate layout | Before the first FFI crate | P3 |
| `DOCUMENTATION-PAIRING.md` | What goes in `CONTEXT.md` and what in `CLAUDE.md` | Before writing or reshaping any pair | every phase |
| `DOCUMENTATION-LENGTH.md` | The 300-line limit and the split | When an instructional file nears 270 lines | every phase |

The guides for kernel C, modules and Kconfig join this catalogue when P4 starts; the phases themselves
are set in `project-management/src/01-ROADMAP/ROADMAP.md`.

## Do not use for

- Step-by-step procedures that apply these rules → `code/workflows/CONTEXT.md`
- Installing, checking or updating the toolchain → `how-to/CONTEXT.md`
- Why a rule was chosen — the decision records → `project-management/src/08-DECISIONS/`
- Concept notes from study sessions → `learning/CONTEXT.md`

## Cross-references

- `code/CONTEXT.md` — the layer these guides belong to
- `code/REFERENCES.md` — the external sources behind every guide
- `code/workflows/CONTEXT.md` — the workflows that cite these guides at each step
- `code/src/CONTEXT.md` — the source tree the guides govern
- `how-to/docs/GUIDE-CRAFT.md` — writing style for guides
