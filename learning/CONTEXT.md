# learning/ — Concept Notes and Recall Journal

**Last Updated**: 27/09/2026 | **Version**: 0.1.0 | **Maintained By**: Sam Bailey
**Language**: British English (en_GB) | **Timezone**: Europe/London

Sam's own record of what he is learning: one folder per topic holding the mission, the pinned
sources, a concept note per lesson written in his own words, and a dated journal of recall results
and spaced review dates. It is a notes-and-memory layer, not a code sandbox. Runnable code lives
under `code/src/`, where CI builds and tests it, and each note links to that code by path. The
`teach` skill creates and updates every topic folder; this layer is committed so lessons sync
across devices and the learning stays visible in public.

## Directory Tree

```text
learning/
├── CONTEXT.md · CLAUDE.md      ← this orientation · how to work here (tutor mode, notes not code)
└── <track>-NN-<topic>/         ← one folder per topic, created by /teach (none yet; the first lesson creates one)
    ├── MISSION.md              ← why this topic, what "can do it" looks like, family, phase, milestone
    ├── RESOURCES.md            ← pinned primary sources and house guides, one row per lesson
    ├── PROGRESS.md             ← review queue, then the dated journal: recall result and next review date
    └── NOTES/                  ← one concept note per lesson
        └── NN-<concept>.md     ← Sam's explanation, linked by path to the code that proves it
```

The formats of all four live in `.claude/skills/teach/SKILL.md`. A topic folder is `<track>`, a
two-digit running number within that track, and a kebab-case topic: `c-01-foundations/`.

## Tracks and suggested first topics

| Track | Covers | Suggested first topic folders (none created yet) | Phases |
| --- | --- | --- | --- |
| `c` | the language, its memory model, then systems programming | `c-01-foundations/` · `c-02-pointers-and-memory/` · `c-03-structs-unions-memory-model/` · `c-04-preprocessor-and-multi-file/` | P1 and P2 |
| `tooling` | gcc, make, gdb, valgrind, the sanitisers, cargo | `tooling-01-gcc-and-make/` · `tooling-02-gdb-valgrind-sanitisers/` | from P1 |
| `rust` | ownership to `unsafe` and FFI with C | `rust-01-ownership-borrowing/` · `rust-02-traits-generics/` · `rust-03-unsafe-and-ffi-with-c/` | P3 |
| `kernel` | build, boot, modules, Kconfig, initramfs, the distro tiers | `kernel-01-build-and-boot-in-qemu/` · `kernel-02-modules/` · `kernel-03-rust-for-linux/` | P4 to P6 |

The phases and their exit gates are owned by `project-management/src/01-ROADMAP/ROADMAP.md`; a
topic's `MISSION.md` names the phase it serves.

## How a lesson flows through the repo

One lesson touches three places. The concept note and the journal entry land here; the runnable
example and its tests land in `code/src/c/msNNN-<kebab>/` or `code/src/rust/crates/msNNN_<snake>/`
(`NNN` as `code/src/CLAUDE.md` → Output & naming numbers it: the milestone, except that a Rust port
keeps its C exercise's number); and the review dates in `PROGRESS.md` bring the concept back at
+1, +3 and +7 days until it is consolidated.

## When to read this

- Starting or resuming a lesson, after checking `handoffs/` for a newer handoff.
- Checking which reviews are due: each topic's `PROGRESS.md` review queue.
- Planning the next milestone: the "can do it when" lines in each `MISSION.md` show readiness
  against the roadmap's exit gates.

## Do not use for

- Runnable code, exercises and their tests → `code/CONTEXT.md`
- Evidence for a decision → `research/CONTEXT.md`
- Milestones, plans and progress records → `project-management/CONTEXT.md`
- Mid-task session continuity → `handoffs/CONTEXT.md`
- Durable repo facts and feedback for Claude → `.claude/MEMORY.md`

## Key docs

| Guide | When to read |
| --- | --- |
| `.claude/skills/teach/SKILL.md` | Before any lesson: the loop, the spacing rule and every file format |
| `project-management/workflows/10-study-and-build/` | The procedure a lesson runs inside |
| `code/docs/C-CODING-PRINCIPLES.md` · `code/docs/RUST-CODING-PRINCIPLES.md` | The house style a lesson's code follows |
| `code/docs/MEMORY-SAFETY.md` | Why a C lesson is not done until `san` and `memcheck` are clean |
| `project-management/src/01-ROADMAP/ROADMAP.md` | Which phase a topic belongs to |

## Cross-references

- `learning/CLAUDE.md`: how to work here.
- `.claude/skills/wait-what/SKILL.md`: the detour that can open a new topic mid-session.
- `code/workflows/CONTEXT.md`: the build workflows a lesson's code goes through.
- `code/src/c/ms001-hello/` · `code/src/rust/crates/ms001_hello/`: the exercise pattern.
- `REFERENCES.md`: the root index.
