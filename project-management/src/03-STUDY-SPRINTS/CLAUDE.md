@./CONTEXT.md

# CLAUDE.md — project-management/src/03-STUDY-SPRINTS/

Read order: `.claude/CLAUDE.md` → `.claude/MEMORY.md` → this folder's `CONTEXT.md` (what a sprint
record holds and why the Retrospective is mandatory — imported above) → this file →
`project-management/docs/planning/SPRINTS.md`.

## Purpose (one line)

The study sprint records — one `SPRINT-##.md` per two-week time-box, holding its goal, capacity,
member milestones, FLAGS union, backlog register and Retrospective.

## How to work here

- **Routing:** start from `project-management/workflows/03-sprint-planning/` (`STEPS.md` +
  `CHECKLIST.md`), governed by `project-management/docs/PLANNING-GUIDE.md`. Milestone status
  changes belong to their own workflows; this folder records sprint membership and the
  Retrospective.
- **Concrete steps:** to open — copy `SPRINT-00-TEMPLATE.md` to the next `SPRINT-##.md` → write the
  goal and dates → admit milestones in cadence order, adding each to the Milestone Summary → stop at
  the capacity in `project-management/docs/planning/CADENCE.md` → recompute the FLAGS union →
  update the backlog register in the live record (a new sprint copies it forward from the last
  record). To close — write the Retrospective → carry over anything not `Completed` → set the
  sprint status.
- **Definition of done:** named to the pattern below; capacity recorded as `used / total`; every
  member cited by `MS###`; FLAGS equal to the union of the members' flags; the live record's
  backlog register matches the previous record's copy row for row, plus its own row; Retrospective
  written before close; British English; DD/MM/YYYY.

## Guardrails

- **Compute the FLAGS; never author them.** Each row is the union of the member milestones' rows. A
  sprint row reading `N/A` while a member's reads a value is a mistake in one of the two.
- **Edit only the live record's register; never a `Closed` one.** Only the single `Open` or `Full`
  sprint's backlog register is live. A `Closed` record's copy is a frozen snapshot of the day it
  closed (`project-management/docs/planning/SPRINTS.md` → _The backlog register_). When membership
  or capacity moves, update the live copy and check it against its own capacity line; nothing
  checks it for you.
- **Treat capacity as a trigger, not a target.** A sprint closes admission when the next
  milestone would pass capacity; grace is for one situation only, stated in
  `project-management/docs/planning/CADENCE.md`.
- **Never close a sprint without its Retrospective.** Velocity measured there is the only evidence
  for changing the capacity figures.
- **Carry over; never drop.** A member not `Completed` at close moves to the next sprint with the
  points it still needs, and both records say so.
- **Keep it a ledger.** Plans live in `project-management/src/09-MILESTONE-PLANS/`; do not copy
  them in here.
- **Keep one sprint live.** Only one record is open or full at a time.

## Output & naming

- **Hand-written:** every `SPRINT-##.md`.
- **Template:** `SPRINT-00-TEMPLATE.md` — the copy source; keep it, do not repurpose it.
- **Generated:** none.
- Records are named `SPRINT-##.md`: two digits, zero-padded, from `SPRINT-01`, allocated when a
  sprint opens and never reused. Members are cited as `MS###`; dates DD/MM/YYYY.
