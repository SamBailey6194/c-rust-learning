# project-management/src/05-PROJECTS/ — Capstone Project Specs

**Last Updated**: 27/09/2026

Capstone project specs — one `PROJ-MS###-<NAME>.md` per project, written for the milestone whose
Project flag runs. A project is bigger than an exercise set: it combines a phase's skills into one
working program — a multi-file tool at the end of P1, a memory allocator, a Unix shell and a small
libc subset in P2, a Rust port of a C project in P3. The spec fixes scope, behaviour, acceptance and
stretch goals before any code exists, so "finished" is decided in advance rather than when enthusiasm
runs out. Like an exercise spec, it holds no solution.

## Directory Tree

```text
project-management/src/05-PROJECTS/
├── CONTEXT.md · CLAUDE.md    ← this pair: what a project spec is · how to write one
├── PROJ-MS000-TEMPLATE.md    ← project template — copied for each capstone
└── PROJ-MS###-<NAME>.md      ← one spec per capstone (none written yet)
```

## What each spec records

| Section | Holds |
| --- | --- |
| **Header table** | The driving milestone, phase, code location, status, date |
| **Summary** | What the program does and which phase skills it combines |
| **Scope** | In scope, out of scope, and the interface or command-line behaviour |
| **Milestones** | How a large project is cut into milestones, each provable on its own |
| **Acceptance** | Gherkin scenarios with exact commands; the project is done when all pass |
| **Test strategy** | Test levels, reference behaviour to compare against, memory gates |
| **Stretch goals** | Extensions that are explicitly not required |
| **Risks** | What is likely to go wrong, and the fallback |

## Candidate projects

The roadmap names the candidates per phase in `project-management/src/01-ROADMAP/ROADMAP.md`; a
candidate becomes a spec here only when its milestone is cut and its Project flag is set.

## Cross-references

- `project-management/workflows/05-project-spec/` — the procedure that writes here
- `project-management/src/01-ROADMAP/ROADMAP.md` — the phase each project closes, and its exit gate
- `project-management/src/02-MILESTONES/` — the milestones a project is cut into
- `project-management/src/04-EXERCISES/` — the smaller specs a project builds on
- `code/workflows/01-c-exercise/`, `code/workflows/03-rust-exercise/`, `code/workflows/04-ffi-bridge/` — the build side
