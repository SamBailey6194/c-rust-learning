# Workflow: Milestone Plans

**Last Updated**: 27/09/2026

Without a plan, a milestone gets studied in whatever order the first search result suggests, and its
verification commands get invented at the end to fit whatever was built. The plan fixes the reading, the
exercise order and the proof before the first line of code, so study becomes following a route rather
than choosing one every session.

## Directory Tree

```text
project-management/workflows/09-milestone-plans/
├── CONTEXT.md · CLAUDE.md   ← orientation (this file) · operating rules for the workflow
├── STEPS.md                 ← ordered steps, each closing on a "Done when" line
└── CHECKLIST.md             ← the gate ticked before the workflow counts as complete
```

## When to use this

- Once per milestone, straight after `08-decisions` has settled its ADR set and before the first
  study session. One milestone runs the whole loop before the next starts; the cadence lives in
  `project-management/docs/planning/CADENCE.md`.
- When the roadmap order changes, to renumber the affected plans in the same change.
- When a finding from `12-review-and-reflect` is carried into the next milestone, to fold it into that
  milestone's risks before study starts.

## Key concepts

- **One plan per milestone, and it is the master.** `10-study-and-build` works from the plan; a question
  the plan does not answer is a gap in the plan, fixed there rather than improvised at the keyboard.
- **The filename carries the build order.** `<exec-order>-PLAN-MS###-<DESC>.md`, copied from
  `00-PLAN-MS000-TEMPLATE.md`. `<exec-order>` is the two-digit position of the milestone in the whole
  roadmap's build order, counted from `01`; `00-` belongs to the template. When the order changes, the
  plans and every citation of them are renumbered in the same commit. MS001's plan, for example, is due
  as `01-PLAN-MS001-TOOLCHAIN-READY.md` (planned, written when this workflow first runs for MS001).
- **Six parts.** Resources and chapters (cited and linked rather than pasted), exercise order, verification
  commands, risks, deferred items, and an As-Built summary.
- **Verification commands are written before the code.** Each mastery criterion in the milestone becomes
  a raw command plus the script that wraps it; `11-verification` runs exactly those.
- **The As-Built summary closes the plan.** It stays a stub here and is filled at `11-verification`,
  recording what was actually built against what was planned.
- **Risks and deferrals route to the registers.** A risk that blocks progress is also a `GAPS.md` entry;
  a topic parked for later is a `DEFERRED.md` entry with a `DEFERRED (MS###)` marker.

## Cross-references

### Governing documents

- `project-management/src/09-MILESTONE-PLANS/CLAUDE.md` — naming and the exec-order rule
- `project-management/src/09-MILESTONE-PLANS/00-PLAN-MS000-TEMPLATE.md` — the plan scaffold
- `project-management/docs/planning/CADENCE.md` — when plans are written in the running order

### Related reading

- `project-management/src/02-MILESTONES/` — the milestone and its mastery criteria
- `project-management/src/03-STUDY-SPRINTS/` — the sprint the milestone sits in
- `project-management/src/04-EXERCISES/` · `05-PROJECTS/` · `06-KERNEL/` · `07-OS-PROFILES/` — the
  specs the plan sequences
- `project-management/src/08-DECISIONS/` — the ADRs the plan works under
- `code/docs/BUILD.md` — the make targets and flags the verification commands call
- `how-to/workflows/03-quality-gates/` — the gate scripts behind each raw command
- `project-management/workflows/10-study-and-build/` — downstream: the workflow that follows the plan
