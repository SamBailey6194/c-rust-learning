# project-management/src/09-MILESTONE-PLANS/ — Milestone Plans

**Last Updated**: 27/09/2026

Milestone plans — one per milestone, written after its specs and decisions and before any study
starts. A plan is the page the learner works from: which primary sources to read and in what order,
which exercises to build and where, which command proves each mastery criterion, what is likely to go
wrong, and what is deliberately left for later. It turns the milestone's "what has to become true" into
a route, without writing any of the code; the code is the learner's, in `code/src/`.

## Directory Tree

```text
project-management/src/09-MILESTONE-PLANS/
├── CONTEXT.md · CLAUDE.md            ← orientation · operating rules for this folder
├── 00-PLAN-MS000-TEMPLATE.md         ← copy source for every plan; 00- belongs to it alone
└── <exec-order>-PLAN-MS###-<DESC>.md ← one plan per milestone, prefixed by its place in the build order
```

No plan exists yet: the first, for `project-management/src/02-MILESTONES/MS001-TOOLCHAIN-READY.md`,
is written by `project-management/workflows/09-milestone-plans/`.

## Why the filename carries a build-order prefix

`<exec-order>` is the milestone's two-digit position in the build order of the **whole roadmap** —
phases in `project-management/src/01-ROADMAP/ROADMAP.md` order, and within a phase the order the
sprint records schedule the milestones. A plain `ls` of this folder therefore reads in the order the
work happens, which a list sorted by `MS###` cannot show, because milestone numbers are allocated in
creation order. When the build order changes, the prefixes are renumbered to match; the milestone
number, by contrast, stays fixed. `CLAUDE.md` → Output & naming owns the rule.

## What each plan records

| Section | Holds |
| --- | --- |
| **Header table** | Milestone, phase and track, sprint, exec-order, branch, date, status mirrored from the milestone |
| **Goal and scope** | What the learner can do afterwards, what it unlocks, what is in and out of scope |
| **Starting point** | The learner's Explain-first answers: what they know, what they expect to be hard |
| **Inputs** | The milestone, sprint, flagged specs, ADRs and register entries the plan rests on |
| **Resources and chapters** | One primary source per concept, with the exact chapter or section |
| **Exercise order** | Each exercise: spec, code location, code workflow, the concept it needs first |
| **Verification commands** | Each mastery criterion as a raw command and the script that wraps it |
| **Risks and Deferred items** | Trigger and response per risk; each deferral mirrored in `DEFERRED.md` |
| **As-Built summary** | A stub until `11-verification` fills it: what was built against what was planned |

## Where it sits

```text
04–07 specs ─┐
08 ADRs ─────┼→ 09 plan (this folder) → 10-study-and-build → 11-verification → 12 review and findings
02 milestone ┘
```

The plan points back to its milestone, specs and decisions; the verification record in
`project-management/src/10-PROGRESS/` points back to the plan, and closes it by filling the As-Built
summary.

## Cross-references

- `project-management/workflows/09-milestone-plans/` — the procedure that writes plans
- `project-management/workflows/10-study-and-build/` — the procedure that follows a plan
- `project-management/src/02-MILESTONES/` — the milestones plans serve
- `project-management/src/08-DECISIONS/` — the ADRs a plan rests on
- `project-management/src/10-PROGRESS/` — the verification record that fills the As-Built summary
- `code/docs/BUILD.md` · `how-to/workflows/03-quality-gates/` — the targets and scripts a plan names
- `project-management/docs/planning/MILESTONES.md` — the status vocabulary a plan mirrors
