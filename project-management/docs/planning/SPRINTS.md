---
type: guide
---

# Study Sprints

**Last Updated**: 27/09/2026 | **Version**: 0.1.0 | **Maintained By**: Sam Bailey
**Language**: British English (en_GB) | **Timezone**: Europe/London

Opening, filling and closing a `SPRINT-##` record in `project-management/src/03-STUDY-SPRINTS/`, and
the Retrospective every sprint ends with. Index:
[`project-management/docs/PLANNING-GUIDE.md`](../PLANNING-GUIDE.md).

---

## What a study sprint is

A two-week time-box that milestones are admitted to, one after another, until it is full. It is a
ledger and a rhythm, not a second plan: the milestones carry their own mastery criteria and their own
plans in `project-management/src/09-MILESTONE-PLANS/`, and the sprint record only says which of them
this fortnight is for, how many points that is, and what the fortnight taught.

The length, the capacity and the grace ceiling are stated once, in
`project-management/docs/planning/CADENCE.md` → _Sprint capacity — the trigger_. This file points
there rather than repeating them.

---

## The sprint record

Every record is a copy of `project-management/src/03-STUDY-SPRINTS/SPRINT-00-TEMPLATE.md` and holds:

| Section | What it holds |
| --- | --- |
| **Goal** | One sentence: what this fortnight proves, in terms of the phase exit gate |
| **Status** | `Open` · `Full` · `Closed` (next section) |
| **Timeline · Capacity** | Start and end dates (DD/MM/YYYY); capacity as `used / total` points |
| **FLAGS** | The union of the member milestones' flags, computed, never authored |
| **Milestone Summary** | One row per member: `ID · Title · MoSCoW · Points`, in the order admitted |
| **Dependencies** | Which member waits on which, and which later milestone this sprint unblocks |
| **Backlog register** | The identical cross-sprint table (below) |
| **Retrospective** | Mandatory at close (below) |
| **Definition of Done** | The checkbox list the sprint closes against |

---

## Sprint statuses

These describe the sprint record, not its milestones (milestone statuses are owned by
`project-management/docs/planning/MILESTONES.md` → _Statuses_).

| Status | Meaning |
| --- | --- |
| `Open` | Admitting milestones; points used are below capacity |
| `Full` | Points used equal capacity, or grace was used, or the next milestone did not fit; no further admissions, study continues |
| `Closed` | Closed by the rule below; Retrospective written |

**Only one sprint is live (`Open` or `Full`) at a time.** A second live sprint would mean two
fortnights running at once, which the one-at-a-time cadence rules out.

**When a sprint closes — this file owns the rule; the workflows cite it:**

1. **It is `Full` and its last member has merged.** Velocity counts `Completed` points, so the
   Retrospective is finished after `13-pr-and-merge` merges that member, on a `pm/<desc>` branch
   (`12-review-and-reflect` Step 8 drafts it; `13-pr-and-merge` Step 10 finishes it).
2. **The next milestone does not fit.** The sprint is marked `Full` at admission; by the cadence its
   members are all `Completed`, so it closes at once, on the new milestone's branch
   (`03-sprint-planning` Step 3).
3. **Its two weeks end with a member unfinished.** A member still `Open`, `In Progress`, `Blocked` or
   `Parked` is carried over and the sprint closes now (`03-sprint-planning` Step 7). A member already
   `Verifying` is not carried over: the sprint waits for its merge and closes by rule 1.

An `Open` sprint whose members are all `Completed` before its end date stays open for the next
admission. Capacity is a trigger, so a sprint that fills in nine days closes in nine days.

---

## The flags are a union

A sprint's FLAGS table has the same eleven rows as a milestone's, and each value is the **union of
its members' values**, computed from the Milestone Summary. A sprint whose `QEMU` row reads `N/A`
while a member's reads a boot test is a mistake in one of the two. The union is what tells you, at a
glance, which tools the fortnight needs working before it starts: no point admitting a `QEMU`
milestone while `GAPS.md` still says the kernel build dependencies are missing.

---

## Admission

`03-sprint-planning` admits each milestone as it is written, in cadence order. `MS001` is no exception:
it is admitted like any other, and its admission opens `SPRINT-01`.

1. Add the milestone's points to the open sprint's points used.
2. If the total stays within capacity, it is admitted: add its row (ID, title, MoSCoW, points) to the
   Milestone Summary; if points used now equal capacity, the sprint is marked `Full`. If it would pass
   capacity, grace applies only under the conditions `CADENCE.md` sets, and a sprint admitted on grace
   is marked `Full`; otherwise the milestone is not admitted, and the sprint is marked `Full` and closes
   (rule 2 above). The next `SPRINT-##` then opens with this milestone as its first member.
3. Recompute the FLAGS union and update the live record's backlog register.

A member still short of `Completed` when its sprint closes is **carried over**: it moves to the next
sprint's Milestone Summary with the points it still needs, and both records say so in their
Dependencies. It is never silently dropped.

---

## The backlog register

**The live record carries the whole register**: every sprint record so far, its members in the order
admitted, and its capacity. It is how the current fortnight sees the history it is measured against:

| Sprint | Members, in admission order | Points |
| --- | --- | --- |
| `SPRINT-04` | MS009 (`Must`, 5) then MS010 (`Must`, 3) then MS011 (`Should`, 3) | 11 / 13 — closed |

One row per record. (The example row shows the shape only; it is not a real sprint.)

- **It is copied forward.** A new sprint opens with the previous record's register plus its own row.
- **A `Closed` record's copy is a snapshot.** It stays exactly as it stood at close and is never edited
  afterwards, so every closed record is a true picture of the backlog on the day it closed.
- **Say which record is current in the prose above the table, never inside a cell**, so the table can
  be compared line for line with the previous record's copy: every row but the last matches.

---

## The Retrospective

**Mandatory. A sprint is not `Closed` until its Retrospective is written**, because the Retrospective
is where the capacity figure gets measured and where a misconception turns into next sprint's plan.
It answers five things:

1. **What stuck** — concepts you could now explain without notes, with the milestone that proved each.
2. **What did not** — concepts that passed their gates but still feel borrowed; each becomes an
   Explain-first question for the next related milestone, or a `12-FINDINGS` record if it is a real
   misconception.
3. **Velocity** — points `Completed` this sprint against the capacity figure. After two sprints this
   is the evidence `CADENCE.md` asks for before the figures change.
4. **Carried over** — each member not `Completed`, why, and the points it still needs.
5. **One change** — a single adjustment to how the next sprint runs (a study time, a tool, a smaller
   milestone). One, so that its effect can be seen.

---

## Numbering

`SPRINT-##`, two digits, zero-padded, from `SPRINT-01`. `SPRINT-00` is the template. Numbers are
allocated when a sprint opens and are never reused.

---

## Related

- [`project-management/docs/planning/CADENCE.md`](CADENCE.md) — length, capacity, grace, and when to
  revisit them
- [`project-management/docs/planning/MILESTONES.md`](MILESTONES.md) — the milestones a sprint admits,
  MoSCoW and points
- `project-management/src/03-STUDY-SPRINTS/SPRINT-00-TEMPLATE.md` — the scaffold
- `project-management/workflows/03-sprint-planning/` — the procedure that opens, fills and closes a
  sprint
