# Workflow: Sprint Planning

**Last Updated**: 27/09/2026

A fortnight with no limit fills with whatever looks interesting, and one with no record cannot be
measured. The study sprint puts a capacity on the fortnight and a ledger under it, so admission is a
decision rather than a drift, and the Retrospective at the end can say whether the capacity was right.

## Directory Tree

```text
project-management/workflows/03-sprint-planning/
├── CONTEXT.md · CLAUDE.md   ← orientation (this file) · operating rules for the workflow
├── STEPS.md                 ← ordered steps, each closing on a "Done when" line
└── CHECKLIST.md             ← the gate ticked before the workflow counts as complete
```

## When to use this

- **After every `02-milestone-creation`**, to admit the new milestone to the live sprint, or to open the
  next sprint when it does not fit.
- **When no sprint is live**: the first milestone to be admitted (`MS001`, which opens `SPRINT-01`), or
  the first after the last sprint closed.
- **When a sprint's two weeks run out** with a member not yet `Verifying`: write the Retrospective, close
  the sprint and carry the member over.

A `Full` sprint whose members all finish is closed after `13-pr-and-merge` merges its last member, on a
`pm/<desc>` branch (`12-review-and-reflect` Step 8 drafts the Retrospective, `13-pr-and-merge` Step 10
finishes it). The rule is owned by `project-management/docs/planning/SPRINTS.md` → _Sprint statuses_;
this workflow handles opening, admission and the time-out.

## Key concepts

- **A study sprint is a two-week time-box with a points capacity.** The length, the capacity (13 points)
  and the grace ceiling (16) are stated once, in `project-management/docs/planning/CADENCE.md` →
  _Sprint capacity — the trigger_.
- **Capacity is a trigger, not a target.** When the next milestone would pass capacity, the sprint is
  full; the milestone opens the next sprint instead. Grace is for one situation only.
- **The record is a ledger, not a plan.** It holds the goal, the dates, `used / total` points, the
  Milestone Summary, the flags union and the backlog register; the plans live in
  `project-management/src/09-MILESTONE-PLANS/`.
- **The sprint's flags are the union of its members'**, computed rather than authored. The union says which
  tools the fortnight needs working before it starts.
- **One sprint is live at a time.** Its statuses (`Open`, `Full`, `Closed`) are owned by
  `project-management/docs/planning/SPRINTS.md` → _Sprint statuses_.
- **The Retrospective is mandatory.** A sprint does not close without it, because the velocity it
  records is the only evidence for changing the capacity figures.

## Cross-references

### Governing documents

- `project-management/docs/planning/SPRINTS.md` — the record, admission, the register, the Retrospective
- `project-management/docs/planning/CADENCE.md` — length, capacity and grace
- `project-management/src/03-STUDY-SPRINTS/CLAUDE.md` — naming and the rules for sprint records
- `project-management/src/03-STUDY-SPRINTS/SPRINT-00-TEMPLATE.md` — the scaffold

### Related reading

- `project-management/workflows/02-milestone-creation/` — upstream: the milestone being admitted
- `project-management/workflows/04-exercise-design/` — downstream: the first spec workflow, as flagged
- `project-management/workflows/12-review-and-reflect/` — where a completed sprint's Retrospective is
  written
- `GAPS.md` — blockers that decide whether a flagged tool will work this fortnight
