# project-management/src/02-MILESTONES/ — Learning Milestones

**Last Updated**: 27/09/2026

Learning milestones — one `MS###-<TITLE>.md` per concept the learner can prove they have learned,
cut from a slice of a track map in `project-management/src/01-ROADMAP/`. A milestone states what it
unlocks, the gates it has to pass (its FLAGS table), and its mastery criteria as Gherkin scenarios
that name real commands. Those criteria are the contract the rest of the store works to: exercise
tests are written from them, verification runs them, and the progress record holds their output.
`MS000-TEMPLATE.md` is the scaffold; `MS001-TOOLCHAIN-READY.md` is the first real milestone and was
seeded with the repository.

## Directory Tree

```text
project-management/src/02-MILESTONES/
├── CONTEXT.md · CLAUDE.md      ← this pair: what a milestone is · how to write one
├── MS000-TEMPLATE.md           ← milestone template — copied for every new milestone
├── MS001-TOOLCHAIN-READY.md    ← P1, C + Rust: a verified toolchain before any exercise
└── MS###-<TITLE>.md            ← one milestone per provable concept (next free number)
```

## Milestones

| ID | Title | Track | Phase |
| --- | --- | --- | --- |
| `MS001` | Toolchain ready | C + Rust | P1 |

Status lives in each milestone's own `**Status:**` line, and the current position lives in
`project-management/src/01-ROADMAP/ROADMAP.md` → You are here, so this table carries neither.

## What each milestone records

| Section | Holds |
| --- | --- |
| **Track, Phase, Status** | Which track and roadmap phase; one status word from the owned vocabulary |
| **FLAGS** | One row per learning gate; `N/A` (with a reason) skips that gate |
| **Why this matters** | Where the milestone sits on the road to the phase exit gate |
| **Learning story** | `As a learner, I want ..., so that ...` — the "so that" names what it unlocks |
| **MoSCoW, Points** | Priority within its sprint and a Fibonacci estimate |
| **Dependencies, Decisions** | Milestones it waits on; the ADRs it rests on, by full filename |
| **Mastery Criteria** | Gherkin scenarios naming exact commands and exact results |
| **Tasks, Verification Checks, Definition of Done** | The work, the commands run before `Verifying`, and the close-out list |

The format, the flag roster, estimation and the status vocabulary are all defined in
`project-management/docs/planning/MILESTONES.md`.

## How a milestone connects

A milestone is cut from a map slice, admitted to a sprint in `03-STUDY-SPRINTS/`, specified further
in `04-EXERCISES/` to `07-OS-PROFILES/` when its flags ask for it, planned in
`09-MILESTONE-PLANS/`, studied and built in `learning/` and `code/src/`, and closed by a
verification record in `10-PROGRESS/`. Its number also names its branch (`ms###/<short-kebab>`) and
its exercise directory (`code/src/c/ms###-<kebab>/` or `code/src/rust/crates/ms###_<snake>/`).

## Cross-references

- `project-management/workflows/02-milestone-creation/` — the procedure that writes here
- `project-management/docs/planning/MILESTONES.md` — format, flags, estimation and status vocabulary
- `project-management/src/01-ROADMAP/ROADMAP.md` — the phases a milestone belongs to
- `project-management/src/03-STUDY-SPRINTS/` — the sprint a milestone is admitted to
- `project-management/src/08-DECISIONS/` — ADRs cited from a milestone's Decisions section
- `project-management/src/10-PROGRESS/` — the verification record that closes a milestone
