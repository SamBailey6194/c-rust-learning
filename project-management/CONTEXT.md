# project-management/ — Curriculum Planning & Mastery Gates

**Last Updated**: 27/09/2026 | **Version**: 0.1.0 | **Maintained By**: Sam Bailey
**Language**: British English (en_GB) | **Timezone**: Europe/London

This layer plans the curriculum and holds the gates that decide when something has been learned;
`code/` is where the learning is built and `learning/` is where it is written down. Keeping the plan
apart from the practice is what lets a milestone be argued with before a fortnight goes into it, and
what stops "I think I understand pointers" standing in for a test run, a clean valgrind report and an
explanation given without notes. The `src/` folders run in four tiers: **Plan** (01–03) → **Specify**
(04–07) → **Decide & plan** (08–09) → **Record** (10–13). The workflows follow the same families with
one more between the last two: **Build** (10), then **Record** (11–13).

## Directory Tree

```text
project-management/
├── CONTEXT.md · CLAUDE.md        ← layer orientation (this file) · operating rules for the layer
├── REFERENCES.md                 ← index of guides, artefact folders, workflows + external sources
├── docs/                         ← reference guides: what "done" means (own pair inside)
│   ├── PLANNING-GUIDE.md         ← thin index over planning/
│   ├── planning/                 ← CADENCE.md · MILESTONES.md · SPRINTS.md
│   ├── GIT-GUIDE.md              ← thin index over git/
│   ├── git/                      ← BRANCHES.md · COMMITS.md · PR-AND-CHECKS.md
│   ├── VERIFICATION-GUIDE.md     ← how mastery is proved and recorded
│   └── SAFETY-GUIDE.md           ← UB and memory bugs, Rust unsafe, kernels in QEMU only
├── src/                          ← live artefacts, in four tiers (own pair inside)
│   │   ── Plan (01–03) ──
│   ├── 01-ROADMAP/               ← ROADMAP.md (owns the phases P1–P6) + track decision maps
│   ├── 02-MILESTONES/            ← one MS### file per milestone; MS001 seeded
│   ├── 03-STUDY-SPRINTS/         ← one SPRINT-## record per two-week study sprint
│   │   ── Specify (04–07) ──
│   ├── 04-EXERCISES/             ← exercise-set specs per milestone (no solutions)
│   ├── 05-PROJECTS/              ← capstone project specs: own malloc, a shell, a Rust port
│   ├── 06-KERNEL/                ← kernel plans before a build, implementation records after
│   ├── 07-DISTRO-TIERS/          ← TIER-MATRIX.md + beginner, intermediate, experienced specs
│   │   ── Decide & plan (08–09) ──
│   ├── 08-DECISIONS/             ← ADRs; five seeded at MS001
│   ├── 09-MILESTONE-PLANS/       ← the plan a milestone is studied from, prefixed by build order
│   │   ── Record (10–13) ──
│   ├── 10-PROGRESS/              ← verification records: the mastery evidence
│   ├── 11-REVIEWS/               ← review records
│   ├── 12-FINDINGS/              ← misconceptions corrected, lessons carried forward
│   └── 13-BUGS/                  ← defects with reproduction, root cause and regression test
└── workflows/                    ← thirteen procedures in running order (own pair inside)
    │   ── Plan (01–03) ──
    ├── 01-roadmap-map/           ← chart a phase's decisions once, cut it into milestone slices
    ├── 02-milestone-creation/    ← write one MS### with Gherkin mastery criteria and flags
    ├── 03-sprint-planning/       ← admit the milestone to the open two-week study sprint
    │   ── Specify (04–07) ──
    ├── 04-exercise-design/       ← specify the exercise set (Exercises flag)
    ├── 05-project-spec/          ← specify a capstone project (Project flag)
    ├── 06-kernel-spec/           ← plan a kernel build or module, QEMU only (Kernel flag)
    ├── 07-distro-tier-spec/      ← specify a distro tier against the matrix (Distro flag)
    │   ── Decide & plan (08–09) ──
    ├── 08-decisions/             ← record hard-to-reverse choices; check the ADR set holds
    ├── 09-milestone-plans/       ← write the plan the milestone is studied from
    │   ── Build (10) ──
    ├── 10-study-and-build/       ← learn with /teach, then build the exercises test-first
    │   ── Record (11–13) ──
    ├── 11-verification/          ← run the mastery commands, write the 10-PROGRESS record
    ├── 12-review-and-reflect/    ← review the code, record findings, close the sprint
    └── 13-pr-and-merge/          ← pull request, every check green, merge, milestone Completed
```

Every folder under `docs/`, `src/` and `workflows/` carries its own `CONTEXT.md` · `CLAUDE.md` pair; each
workflow folder also holds `STEPS.md` and `CHECKLIST.md`.

## When to read this

- Starting the next milestone, or wondering what the next milestone is
- Writing or updating a map, milestone, sprint, spec, decision record or plan
- Proving a milestone is done, reviewing it, or taking it through a pull request
- Deciding what status a milestone is in, or what a flag means

## The four tiers

| Tier | `src/` folders | Workflows | What happens |
| --- | --- | --- | --- |
| **Plan** | 01–03 | 01–03 | Chart a phase once, cut one milestone from it, admit it to the study sprint |
| **Specify** | 04–07 | 04–07 | Say what gets built, as the milestone's flags require |
| **Decide & plan** | 08–09 | 08–09 | Record hard-to-reverse choices, then write the plan studied from |
| **Build** | — | 10 | Study the concept and build the exercises; writes to `learning/` and `code/src/` |
| **Record** | 10–13 | 11–13 | Prove, review, reflect and merge |

Workflow numbers follow `src/` numbers through 09 and then diverge; the note that explains how is in
`project-management/REFERENCES.md`, and the full workflow ↔ folder table in the root `REFERENCES.md`.

## Gates

- A milestone is studied only after its plan exists, and its plan only after its specs and decisions
  (`project-management/docs/planning/CADENCE.md` → _When a milestone is ready to study_).
- One milestone runs all the way through verification and merge before the next one starts.
- A milestone is `Completed` only when it is merged with a verification record in
  `project-management/src/10-PROGRESS/`
  (`project-management/docs/planning/MILESTONES.md` → _Statuses_).
- Kernel work is specified, built and booted in QEMU only (`project-management/docs/SAFETY-GUIDE.md`).

The first milestone is `project-management/src/02-MILESTONES/MS001-TOOLCHAIN-READY.md`, and the current
position is the "You are here" table in `project-management/src/01-ROADMAP/ROADMAP.md`.

## Do not use for

- Writing, building or testing code → `code/CONTEXT.md`
- Installing tools, running the quality gates, host setup → `how-to/CONTEXT.md`
- Concept notes and spaced-review progress from a study session → `learning/CONTEXT.md`
- A primary-source answer to one research question → `research/CONTEXT.md`
- Carrying work between sessions → `handoffs/CONTEXT.md`
- Blockers and parked topics → `GAPS.md` · `DEFERRED.md`

## Key docs

| Guide | When to read |
| --- | --- |
| `project-management/docs/PLANNING-GUIDE.md` | Before any planning workflow; for the status vocabulary |
| `project-management/docs/GIT-GUIDE.md` | Before a branch, a commit or a pull request |
| `project-management/docs/VERIFICATION-GUIDE.md` | Before `11-verification`, or when unsure what counts as proof |
| `project-management/docs/SAFETY-GUIDE.md` | Before specifying a milestone that allocates, uses `unsafe` or touches a kernel |
| `project-management/workflows/CONTEXT.md` | Before running any workflow: Explain-first and the running order |

## Glossary

The planning words the workflows use, in plain terms; the owning guide has the detail.

| Term | Meaning here |
| --- | --- |
| **Learning story (Connextra form)** | One line: "As a learner, I want to [skill], so that [what it unlocks]" |
| **Gherkin** | The `Given / When / Then` shape each mastery criterion is written in, so a command and its expected result can be checked by anyone |
| **MoSCoW** | Must, Should, Could, Won't: a milestone's priority within its study sprint |
| **Points (Fibonacci)** | Relative effort on the scale 1, 2, 3, 5, 8, 13, 21; 8 is the largest milestone (`project-management/docs/planning/MILESTONES.md` → _Estimation_) |
| **Epic** | Work estimated at 13 or more points: several concepts under one title, sent back to the map to be split |
| **Capacity · grace** | The points a two-week sprint admits, and the higher ceiling used only when a milestone would split badly; both figures are set in `project-management/docs/planning/CADENCE.md` |
| **Velocity** | Points `Completed` in a sprint, compared with capacity in its Retrospective |
| **Frontier node** | An open decision on a track map that has to be settled before the milestones behind it can be cut |
| **Spike** | A small throwaway experiment that settles a node by trying it, rather than by reading |
| **Fog of war** | The part of a map not charted yet: known to exist, deliberately left for later |
| **Slice** | A group of resolved nodes on a map that becomes exactly one milestone |
| **kernel-doc** | The Linux kernel's comment format for documenting a function's parameters and return value |

## Cross-references

- `project-management/REFERENCES.md` — every guide, artefact folder and workflow in this layer, and the
  external sources behind them
- `project-management/src/CONTEXT.md` — the artefact store in full: tiers, frozen numbering, templates
- `project-management/workflows/CONTEXT.md` — the thirteen procedures, Explain-first and the cadence
- `REFERENCES.md` — the root index; owns the PM workflow ↔ folder ↔ pairing table
- `.claude/CLAUDE.md` — the repository's non-negotiables, including the kernel QEMU-only rule
