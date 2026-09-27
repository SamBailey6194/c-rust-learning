@./CONTEXT.md

# CLAUDE.md — project-management/workflows/03-sprint-planning/

Read order: `.claude/CLAUDE.md` → `.claude/MEMORY.md` → this folder's `CONTEXT.md` (when to use, key
concepts, governing documents — imported above) → this file → `STEPS.md` then `CHECKLIST.md`.

## Purpose (one line)

Open a two-week study sprint, admit each new milestone against the 13-point capacity, keep its flags
union and backlog register current, and close it on time-out with a Retrospective.

## How to work here

- **Routing:** run `STEPS.md` against `CHECKLIST.md`: OPEN when no sprint is live, ADMIT after every
  `02-milestone-creation`, ROLL OVER when the two weeks end with work unfinished. **Hard gate:** read
  `project-management/docs/planning/SPRINTS.md` and the figures in
  `project-management/docs/planning/CADENCE.md` before writing.
- **Concrete steps:** Explain-first on the fortnight → find the live sprint (or open one from the
  template with goal, dates and capacity) → add the milestone's points → admit it, use grace, or mark the
  sprint `Full` and open the next → recompute the flags union → update the backlog register → commit on
  the milestone branch.
- **Definition of done:** exactly one sprint is live; it records `used / total` points within capacity
  (or grace, with the reason); its flags equal the union of its members'; its register lists every
  sprint so far; any sprint closed here has all five Retrospective answers.

## Guardrails

- **Treat capacity as a trigger, not a target.** Do not pad a sprint to 13 or stretch it to 16 by habit;
  grace is for a milestone that would split badly, and the reason is written down.
- **Compute the flags; never author them.** Every sprint row is the union of the members' rows.
- **Do not close a sprint without its Retrospective**, and do not drop an unfinished member: carry it
  over with the points it still needs, and say so in both records.
- **Keep one sprint live.** Opening a second while one is `Open` or `Full` breaks the cadence.
- **Leave milestone statuses alone.** This workflow records membership; statuses move in the workflows
  that own them (`project-management/docs/planning/MILESTONES.md` → _Statuses_).
- **Keep the record a ledger.** Do not copy plans, specs or mastery criteria into it; cite them.

## Output & naming

- **Writes:** `project-management/src/03-STUDY-SPRINTS/SPRINT-##.md` from `SPRINT-00-TEMPLATE.md`, and
  edits to the live sprint record.
- The folder's `CLAUDE.md` → Output & naming owns the filename pattern (`SPRINT-##.md`, two digits, from
  `SPRINT-01`).
- Commits ride on the milestone branch that is open; a close with no milestone branch open goes on a
  `pm/<desc>` branch (`project-management/docs/git/BRANCHES.md`). Commit scope `pm`; dates DD/MM/YYYY.
