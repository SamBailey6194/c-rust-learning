# Workflow: Milestone Creation

**Last Updated**: 27/09/2026

A milestone is the unit everything downstream is traced to: the exercises, the plan, the branch, the
verification record. Written vaguely ("learn pointers"), it stays vague through all of them and ends in
a feeling rather than a result. Written as Gherkin scenarios that name real commands, it ends in a test
run, a clean valgrind report and an explanation given without notes.

## Directory Tree

```text
project-management/workflows/02-milestone-creation/
├── CONTEXT.md · CLAUDE.md   ← orientation (this file) · operating rules for the workflow
├── STEPS.md                 ← ordered steps, each closing on a "Done when" line
└── CHECKLIST.md             ← the gate ticked before the workflow counts as complete
```

## When to use this

- **The previous milestone has merged, or stopped** (`Blocked` or `Parked`), and the next slice on the
  track's map is cuttable: every node it carries is resolved.
- **A map's slice has been re-cut** (split because it was too big), and each half needs its own
  milestone.

Every milestone starts here, one at a time; the next milestone is written only when this one's loop has
finished or stopped (`project-management/docs/planning/CADENCE.md`). A slice whose nodes are still open
goes back to `01-roadmap-map/` first.

## Key concepts

- **Cut from the map, not from a conversation.** The slice row in `MAP-<TRACK>.md` supplies the title,
  what has to be true and the flag manifest; this workflow turns it into a full milestone.
- **The learning story.** `As a learner, I want to [skill or concept], so that [what it unlocks next].`
  If the "so that" cannot be written, the milestone is out of order on the roadmap.
- **Mastery criteria are the contract.** Gherkin scenarios that name the exact command and the exact
  result, plus at least one explain-back. Testable means an observer could agree it passed without
  asking the author (`project-management/docs/planning/MILESTONES.md` → _Mastery criteria_).
- **Eleven flags, none blank.** Each flag opens a gate; `N/A` skips it and carries a reason
  (`project-management/docs/planning/MILESTONES.md` → _The FLAGS table_).
- **Sized in Fibonacci points.** 8 is the largest milestone; 13 or more goes back to the map as an epic.
- **The branch opens here.** The milestone's `ms###/<short-kebab>` branch carries the whole loop, from
  this file to the verification record, into one pull request (`project-management/docs/git/BRANCHES.md`).

## Cross-references

### Governing documents

- `project-management/docs/planning/MILESTONES.md` — format, mastery criteria, flags, MoSCoW, points,
  statuses
- `project-management/src/02-MILESTONES/CLAUDE.md` — naming and the rules for writing a milestone
- `project-management/src/02-MILESTONES/MS000-TEMPLATE.md` — the scaffold

### Related reading

- `project-management/src/02-MILESTONES/MS001-TOOLCHAIN-READY.md` — a complete, real milestone
- `project-management/src/01-ROADMAP/` — the map and slice this milestone is cut from
- `project-management/docs/VERIFICATION-GUIDE.md` — what the named commands print when they pass
- `project-management/workflows/03-sprint-planning/` — the next workflow: admit the milestone to a sprint
- `DEFERRED.md` — topics parked for this phase, read before writing
