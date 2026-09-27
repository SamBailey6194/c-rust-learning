# project-management/docs/planning/ — Planning Sub-Documents

**Last Updated**: 27/09/2026

The planning standard, split into three sub-documents behind the thin index
`project-management/docs/PLANNING-GUIDE.md`. Together they say how a phase becomes milestones, how a
milestone is written and sized, how milestones fill a two-week study sprint, and what the sprint
teaches when it closes. The workflows in `project-management/workflows/` sequence that work; these
files define what "done" means for it.

## Directory Tree

```text
project-management/docs/planning/
├── CONTEXT.md · CLAUDE.md   ← orientation (this file) · rules for editing these guides
├── CADENCE.md               ← the loop, one milestone at a time, sprint length, capacity and grace
├── MILESTONES.md            ← milestone format, mastery criteria, FLAGS, MoSCoW, points, statuses
└── SPRINTS.md               ← the sprint record, admission, backlog register, the Retrospective
```

## Which file owns what

| File | Owns | Serves |
| --- | --- | --- |
| `CADENCE.md` | The running order, the compounding rationale, sprint length / capacity / grace figures | Every PM workflow `01`–`13` |
| `MILESTONES.md` | The milestone format, Gherkin mastery criteria, the FLAGS table, MoSCoW, Fibonacci estimation, **the milestone status vocabulary** | `project-management/src/02-MILESTONES/` |
| `SPRINTS.md` | The sprint record shape, sprint statuses, the flags union, admission, the backlog register, the Retrospective | `project-management/src/03-STUDY-SPRINTS/` |

**The capacity figures appear once**, in `CADENCE.md`. `SPRINTS.md` and the workflows point at them,
because two copies of a tunable number drift apart the first time one is tuned.

**The milestone status vocabulary appears once**, in `MILESTONES.md`, which every other file in the
repository cites for it.

## Why the split

One planning guide covering cadence, milestones and sprints would pass the 300-line cap on
instructional Markdown (`code/docs/DOCUMENTATION-LENGTH.md`) and would serve three different moments:
charting a track, writing a milestone, and opening or closing a sprint. Three files, each read at its
own moment, keep each one short enough to be read in full.

## Cross-references

- `project-management/docs/PLANNING-GUIDE.md` — the thin index over this folder
- `project-management/workflows/CONTEXT.md` — the workflow index, Explain-first and the cadence diagram
- `project-management/src/02-MILESTONES/MS000-TEMPLATE.md` — the milestone scaffold these rules shape
- `project-management/src/03-STUDY-SPRINTS/SPRINT-00-TEMPLATE.md` — the sprint scaffold
