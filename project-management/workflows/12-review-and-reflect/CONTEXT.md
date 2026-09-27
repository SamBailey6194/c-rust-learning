# Workflow: Review and Reflect

**Last Updated**: 27/09/2026

Code that passes every gate can still carry the wrong lesson: an unchecked return value that happened to
work, a borrow-checker fight settled with `.clone()`, a pointer rule half-remembered. This workflow
reviews the milestone's code, writes down the misconceptions it corrected, and carries the expensive ones
into the next milestone, so they are learned once instead of relearned the hard way.

## Directory Tree

```text
project-management/workflows/12-review-and-reflect/
├── CONTEXT.md · CLAUDE.md   ← orientation (this file) · operating rules for the workflow
├── STEPS.md                 ← ordered steps, each closing on a "Done when" line
└── CHECKLIST.md             ← the gate ticked before the workflow counts as complete
```

## When to use this

- At milestone close, after `11-verification` has left the milestone at `Verifying`, and before
  `13-pr-and-merge`.
- At the end of a study sprint as well, for the sprint's Retrospective, once the sprint is `Full` and its
  last milestone has been reflected on, or the two weeks have run out.

## Key concepts

- **Content review, then reflection.** `code/workflows/05-review/` reads the milestone's code against
  `code/docs/` and writes the review record into `project-management/src/11-REVIEWS/`. This workflow
  runs it at milestone scope, acts on its required actions, and then distils what the milestone taught
  into a finding.
- **The finding record.** One per milestone in `project-management/src/12-FINDINGS/`, copied from
  `FINDING-MS000-TEMPLATE.md`, written even when little went wrong. It records the misconceptions
  corrected (what was believed, what is true, the evidence), what is **expensive to relearn**, and what is
  **carried into the next milestone**.
- **Expensive to relearn.** Some misunderstandings compound: a wrong model of object lifetimes or of
  undefined behaviour poisons every later exercise that relies on it. Those are flagged separately from
  one-off slips, so the next plan budgets time for them.
- **Carried forward.** Rows marked for the next milestone become risks in its plan
  (`09-milestone-plans`) and Explain-first questions when it opens.
- **Three registers, kept apart.** A blocker goes to `GAPS.md`; a topic parked for a later phase goes
  to `DEFERRED.md`; a durable working pattern or piece of feedback about how sessions run goes to
  `.claude/MEMORY.md`.
- **The sprint Retrospective.** Owned by `project-management/docs/planning/SPRINTS.md` → _The
  Retrospective_: what stuck, what did not, velocity, carried over, one change. A sprint is not `Closed`
  without it.
- **Reviews point rather than rewrite.** A review names the `code/docs/` section that applies and leaves
  the change to the learner (tutor mode).

## Cross-references

### Governing documents

- `project-management/src/11-REVIEWS/CLAUDE.md` — naming and authoring rules for review records
- `project-management/src/12-FINDINGS/CLAUDE.md` — naming and authoring rules for finding records
- `project-management/docs/planning/SPRINTS.md` — the Retrospective and closing a sprint
- `code/workflows/05-review/` — the content review this workflow runs

### Related reading

- `project-management/src/11-REVIEWS/REVIEW-MS000-TEMPLATE.md` — the review scaffold
- `project-management/src/12-FINDINGS/FINDING-MS000-TEMPLATE.md` — the finding scaffold
- `project-management/src/03-STUDY-SPRINTS/` — the sprint record the Retrospective is written into
- `code/workflows/07-debug/` · `code/workflows/08-refactor/` — where a review's required actions go
- `project-management/docs/SAFETY-GUIDE.md` — undefined behaviour and memory-bug classes a finding cites
- `project-management/workflows/13-pr-and-merge/` — downstream: the merge that completes the milestone
