# project-management/workflows/ — Step-by-Step PM Procedures

**Last Updated**: 27/09/2026 | **Version**: 0.1.0 | **Maintained By**: Sam Bailey
**Language**: British English (en_GB) | **Timezone**: Europe/London

Thirteen numbered procedures, and here the numbers are the running order: `01` runs once per phase,
`02`–`09` prepare one milestone, `10` studies and builds it, and `11`–`13` prove it, reflect on it and
merge it. Each folder holds a `STEPS.md` to follow and a `CHECKLIST.md` to finish against, and each
writes one kind of artefact into `project-management/src/`.

## Why this layer exists

**The concept is thought through before the keyboard.** Every procedure before `10` exists so that when
a study session starts, the only open question is the thing being learned: what mastery looks like is
already written as commands, the exercises already exist as specs, and the decisions are already
recorded. Done properly, a session becomes practice rather than planning, and the evidence at the end is
something another person could check.

The cost is real: a milestone takes an hour or two of planning before any code. That hour is where the
misconceptions surface cheaply. A pitfall predicted in `02` is a test written in `04`; the same pitfall
met for the first time in `10` is an evening in gdb.

## Explain-first

Every workflow opens with the learner, not with a template. The repository-wide default, including
the question format, is `.claude/CLAUDE.md` → Section 8; in the PM workflows it takes three moves:

1. **Ask what is already known.** Before drafting, the learner says what they know about the concept,
   the tool or the decision, and where that knowledge came from.
2. **Predict the pitfalls.** The learner names where they expect it to go wrong; Claude adds the classic
   failures the learner missed (an off-by-one in a growth loop, a missing `free` on an error path, a
   borrow held across a call) as questions, not answers.
3. **Explain it back.** The learner explains the concept in their own words, as if to someone a phase
   behind. What they cannot yet explain becomes a mastery criterion, an exercise or a research question.

The answers go into the artefact the workflow writes. Only mechanical touches skip it: a status flip, a
date refresh, a link fix. The same questions return at `11-verification` as the explain-back scenario,
so the milestone opens and closes on the learner's own words.

## The learning cadence

**One milestone at a time, all the way through verification and merge.** The reason is compounding:
each milestone is planned with everything the last one proved already in hand. The full argument, the
sprint capacity and the readiness conditions are in `project-management/docs/planning/CADENCE.md`.

```text
01 chart track (once)
 │
 ↓
02 → 03 → [04 → 05 → 06 → 07 as flagged] → 08 → 09 plans
                                                    │
 ┌──────────────────────────────────────────────────┘
 ↓
10 study & build → 11 verify → 12 review/reflect → 13 PR → next milestone
                                                              │
 back to 02 ←─────────────────────────────────────────────────┘
```

- **`01` runs once per phase or track**, before its milestones are cut; it is re-entered only to resolve
  a node or when the track is reshaped.
- **`03` admits each milestone to the open two-week study sprint** until the sprint reaches capacity;
  the next milestone then opens the next sprint.
- **`04`–`07` run as flagged.** The milestone's FLAGS table decides which of them it enters
  (`project-management/docs/planning/MILESTONES.md` → _The FLAGS table_); a flag reading `N/A` skips the
  gate.
- **`08` runs whenever a hard-to-reverse choice surfaces**, and once per milestone as the check that the
  decision records still hold.

## Directory Tree

```text
project-management/workflows/
├── CONTEXT.md · CLAUDE.md      ← index, Explain-first, cadence (this file) · rules for running a workflow
│   ── Plan (01–03) ──
├── 01-roadmap-map/             ← chart a phase's decision frontier once; cut milestone slices
├── 02-milestone-creation/      ← write one milestone: learning story, Gherkin mastery criteria, flags
├── 03-sprint-planning/         ← open a study sprint; admit milestones against capacity
│   ── Specify (04–07) ──
├── 04-exercise-design/         ← the milestone's exercise set (Exercises flag)
├── 05-project-spec/            ← a capstone project spec (Project flag)
├── 06-kernel-spec/             ← a kernel build or module plan for QEMU, then its record (Kernel flag)
├── 07-os-profile-spec/         ← a Syntek OS profile's axis values and hypotheses (OS flag)
│   ── Decide & plan (08–09) ──
├── 08-decisions/               ← ADRs when choices surface; the per-milestone coherence check
├── 09-milestone-plans/         ← the plan the milestone is studied from
│   ── Build (10) ──
├── 10-study-and-build/         ← learn with /teach, then build test-first in code/src/
│   ── Record (11–13) ──
├── 11-verification/            ← run the mastery commands; write the verification record
├── 12-review-and-reflect/      ← review the code; record findings; close the sprint
└── 13-pr-and-merge/            ← pull request, every check green, merge; milestone Completed
```

Every workflow folder holds exactly four files: `CONTEXT.md` · `CLAUDE.md`, `STEPS.md` and
`CHECKLIST.md`.

## Workflows

| Workflow | Family (`phase:`) | Purpose |
| --- | --- | --- |
| `01-roadmap-map/` | `plan` | Chart a phase's decision frontier with the learner, resolve its blocking nodes, cut milestone slices |
| `02-milestone-creation/` | `plan` | Write one `MS###` with a learning story, Gherkin mastery criteria, flags and an estimate |
| `03-sprint-planning/` | `plan` | Open a two-week study sprint and admit milestones against capacity |
| `04-exercise-design/` | `specify` | Specify the exercise set: problems, constraints, expected I/O, tests |
| `05-project-spec/` | `specify` | Specify a capstone project and slice it across milestones |
| `06-kernel-spec/` | `specify` | Plan a kernel build or module for QEMU; afterwards, record what was built |
| `07-os-profile-spec/` | `specify` | Specify a Syntek OS profile as axis values and QEMU-testable hypotheses |
| `08-decisions/` | `decide-and-plan` | Record hard-to-reverse choices as ADRs; check the set still holds |
| `09-milestone-plans/` | `decide-and-plan` | Write the plan the milestone is studied from |
| `10-study-and-build/` | `build` | Learn the concept with `/teach`, then build the exercises test-first |
| `11-verification/` | `record` | Run the mastery commands and write the verification record |
| `12-review-and-reflect/` | `record` | Review the code, record findings, write the sprint Retrospective |
| `13-pr-and-merge/` | `record` | Take the branch through a pull request and the CI checks to `main` |

## Pairing with the other layers

These workflows are the **plan and prove** half of the loop; `code/workflows/` is the **build and
verify** half, `learning/` holds the concept notes, and `research/` the primary-source answers. The
canonical pairing (which PM workflow pairs with which code workflow, skill or layer) is the table in the
root `REFERENCES.md`, and this file leaves it there.

- **Specs hand forward; building happens later.** `04`–`07` specify; code is written only inside
  `10-study-and-build`, through `code/workflows/01-c-exercise/` to `code/workflows/04-ffi-bridge/`.
- **Bugs are recorded where they are found.** `project-management/src/13-BUGS/` is written by `code/workflows/07-debug/`
  during study, not by a PM workflow.
- **The registers are read here and written everywhere.** `GAPS.md` and `DEFERRED.md` are triaged at
  `01` and read at `02`; any workflow that finds a blocker or parks a topic writes to them.

## The numbers are the running order

Unlike `code/workflows/` and `how-to/workflows/`, which are catalogues where a number is a permanent
identifier, **these numbers are a sequence**: `02` runs before `03`, and `09` gates `10`. Inserting a
workflow mid-sequence therefore means renumbering everything after it and sweeping every reference in
the same change, including `.claude/skills/`, where a stale number is a silent routing failure.

### But `src/` numbers are frozen

This applies to workflow folders only. A workflow folder is a procedure, and renumbering it is a
reference sweep. A `project-management/src/NN-SCREAMING-SNAKE/` folder is a data store: its files are cited by full
path from milestones, commit messages, handoffs and learning notes, and git history keeps those paths.
So `src/` numbers are frozen and append-only (`project-management/src/CONTEXT.md` → _The numbers here
are frozen_), and when the mirroring between the two trees breaks, the mirroring gives way.

## Cross-references

- `project-management/docs/planning/CADENCE.md` — the cadence in full: compounding, capacity, readiness
- `project-management/docs/PLANNING-GUIDE.md` — milestones, flags, statuses and sprints
- `project-management/REFERENCES.md` — every workflow with its purpose, and where the numbers diverge
- `REFERENCES.md` — the root index; owns the workflow ↔ folder ↔ pairing table
- `.claude/skills/teach/SKILL.md` · `.claude/skills/research/SKILL.md` · `.claude/skills/handoff/SKILL.md` —
  the skills the workflows load
