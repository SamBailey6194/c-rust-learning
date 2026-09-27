# project-management/src/03-STUDY-SPRINTS/ — Study Sprint Records

**Last Updated**: 27/09/2026

Study sprint records — one `SPRINT-##.md` per two-week time-box that milestones are admitted to,
one after another, until it is full. A record is a ledger and a rhythm, not a second plan: each
member milestone keeps its own mastery criteria and its own plan, and the sprint only says which
milestones this fortnight is for, how many points that is, which gates the fortnight needs working
(the FLAGS union) and — at close — what the fortnight taught, in a mandatory Retrospective. No
sprint has been opened yet; `SPRINT-01` opens when `MS001` is admitted
(`project-management/docs/planning/SPRINTS.md` → _Admission_).

## Directory Tree

```text
project-management/src/03-STUDY-SPRINTS/
├── CONTEXT.md · CLAUDE.md    ← this pair: what a sprint record holds · how to write one
├── SPRINT-00-TEMPLATE.md     ← sprint template — copied when a sprint opens
└── SPRINT-##.md              ← one record per sprint, from SPRINT-01 (none opened yet)
```

## What each sprint record holds

| Section | Holds |
| --- | --- |
| **Goal** | One sentence: what this fortnight proves, in terms of the phase exit gate |
| **Status** | One sprint status word (the sprint vocabulary, separate from the milestone one) |
| **Timeline, Capacity** | Start and end dates; capacity as `used / total` points |
| **FLAGS** | The union of the member milestones' flags — computed, not authored |
| **Milestone Summary** | One row per member (ID, Title, MoSCoW, Points), in admission order |
| **Dependencies** | Which member waits on which; what this sprint unblocks; anything carried over |
| **Backlog register** | The cross-sprint table, copied forward; live only in the `Open` or `Full` record, a frozen snapshot in a `Closed` one |
| **Retrospective** | What stuck, what did not, velocity, carried over, one change |
| **Definition of Done** | The list the sprint closes against |

Sprint length, capacity and the grace ceiling are stated once, in
`project-management/docs/planning/CADENCE.md`; the sprint statuses, admission and the backlog
register rule are in `project-management/docs/planning/SPRINTS.md`. The template points to both
rather than carrying the numbers.

## Why the Retrospective is mandatory

It is where the capacity figure is measured against real velocity, and where a concept that passed
its gates but still feels borrowed becomes the next sprint's explain-first question. A sprint that
closes without one leaves the next sprint planned on a guess.

## Cross-references

- `project-management/workflows/03-sprint-planning/` — the procedure that opens, fills and closes a sprint
- `project-management/docs/planning/SPRINTS.md` — sprint statuses, admission, the backlog register, the Retrospective
- `project-management/docs/planning/CADENCE.md` — sprint length, capacity and grace
- `project-management/src/02-MILESTONES/` — the milestones a sprint admits
- `project-management/src/12-FINDINGS/` — where a real misconception from a Retrospective is recorded
