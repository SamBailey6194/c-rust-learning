---
type: guide
---

# Planning Cadence

**Last Updated**: 27/09/2026 | **Version**: 0.1.0 | **Maintained By**: Sam Bailey
**Language**: British English (en_GB) | **Timezone**: Europe/London

The order planning runs in, why it runs one milestone at a time, and the figures that close a study
sprint. Index: [`project-management/docs/PLANNING-GUIDE.md`](../PLANNING-GUIDE.md).

---

## Why the learner plans first

Every gate in this layer exists so that by the time a study session starts, the only open question
is the concept being learned. A milestone that arrives with its mastery criteria written, its
exercises specified and its decisions recorded turns a session into practice. One that arrives as
"learn pointers" turns the first hour into deciding what to do.

Planning is also the first act of learning. Every PM workflow opens with **Explain-first**
(`project-management/workflows/CONTEXT.md` → _Explain-first_): say what you already know, predict
where it will go wrong, and explain it back. The gaps that exposes become mastery criteria, and a
pitfall predicted in writing is one the tests can be built to catch.

---

## Chart the track first

`01-roadmap-map` charts a phase's decision frontier once, against the exit gate that
`project-management/src/01-ROADMAP/ROADMAP.md` sets for that phase. The resolved map is what
milestones are cut from, and it stops every later Explain-first pass re-asking the same
cross-cutting questions ("which C standard?", "which allocator strategy?").

Milestones may start once every node marked **blocking** is resolved. Fog of war may remain open.

---

## Then one milestone at a time, through verification

A single milestone runs the whole loop before the next one starts: written (`02`), admitted to a
sprint (`03`), specified as its flags require (`04`–`07`), decided (`08`), planned (`09`), studied
and built (`10`), verified (`11`), reviewed and reflected on (`12`), and merged (`13`).

**The reason is compounding.** `MS008` is planned with everything `MS007` proved already in hand: its
passing tests, the misconceptions its findings record corrected, the decisions it forced. A pointer
bug found and understood in one milestone becomes a pitfall predicted in the next. Batching (ten
milestones written, then ten exercise specs, then ten builds) plans every milestone against the same
earlier and weaker understanding, and relearns the same lesson ten times.

```text
01 chart track (once)
 │
 ↓
02 → 03 → [04 → 05 → 06 → 07 as flagged] → 08 → 09 plans
                                                    │
 ┌──────────────────────────────────────────────────┘
 ↓
10 study & build → 11 verify → 12 review/reflect → 13 PR → next milestone
                                                              │
 back to 02 ←─────────────────────────────────────────────────┘
```

**Verification is part of the milestone, not a later phase.** A milestone that is built but not
verified is still `In Progress` or `Verifying` (status vocabulary:
`project-management/docs/planning/MILESTONES.md` → _Statuses_). Starting the next one on top of it
leaves a half-proved concept underneath the new one, which is exactly the foundation this repo is
trying not to build on.

**The one exception is a stopped milestone.** A milestone that goes `Blocked` (a `GAPS.md` entry
names what it waits for) or `Parked` (a `DEFERRED.md` marker says when it returns) releases its slot,
and the next milestone may start. The stop is recorded before the switch, never after.

---

## The flags decide which specs run

The loop above is the running order. The milestone's FLAGS table
(`project-management/docs/planning/MILESTONES.md` → _The FLAGS table_) decides which of its gates the
milestone actually enters: a flag reading `N/A` skips that gate, any other value runs it. That is why
`04`–`07` read "as flagged" in the diagram, and why `11-verification` runs only the checks whose
flags are set.

---

## Sprint capacity — the trigger

| Figure | Value | Meaning |
| --- | --- | --- |
| **Sprint length** | 2 weeks | The time-box a study sprint runs for |
| **Capacity** | 13 points | The sprint is full: no further milestone is admitted to it |
| **Grace** | 16 points | Hard ceiling, used only when the next milestone would split badly |

**This table is the canonical statement of all three figures.** `SPRINTS.md`, the workflows and the
sprint template point here rather than repeating them, because two copies of a tunable number drift
apart the first time one is tuned.

**Reading the ceiling:**

- **Capacity is a trigger, not a target.** A sprint that closes admission at 10 points because the
  next milestone is a 5 is a correct sprint, not an under-filled one. The next milestone opens the
  next sprint.
- **Grace exists for one situation:** the next milestone would take the sprint past 13, and splitting
  it would produce two halves that teach nothing on their own. Grace is not a routine allowance; a
  sprint that habitually runs to 16 means the capacity figure is wrong.
- **Never split a milestone badly to hit the number.** A concept cut along an artificial seam costs
  more in relearning than an oversized sprint costs in calendar time.
- **Revisit all three figures after two sprints** against measured velocity: the points `Completed`
  per sprint, which each sprint's Retrospective records. The starting figures are a deliberately
  modest guess, not a measurement.

---

## When a milestone is ready to study

`10-study-and-build` starts on a milestone only when all of these hold:

- It cleared `02-milestone-creation`: mastery criteria written, every flag filled or `N/A`
- It is admitted to the open sprint (`03-sprint-planning`)
- Every spec its flags call for exists under `project-management/src/04-EXERCISES/` to
  `project-management/src/07-DISTRO-TIERS/`
- `08-decisions` confirmed that the ADRs it relies on still hold
- Its plan exists in `project-management/src/09-MILESTONE-PLANS/`
- Every milestone it depends on is `Completed`

A milestone that cannot satisfy these goes back a step, or to `Blocked`, rather than being studied
around the gap.

---

## Why not two at once

There is one learner, so there is one milestone in flight and one branch
(`project-management/docs/git/BRANCHES.md`). Worktrees and parallel milestones solve a team's
throughput problem; for a learner they split attention, and split attention is the thing the cadence
exists to prevent.

---

## Related

- [`project-management/docs/planning/MILESTONES.md`](MILESTONES.md) — milestone format, flags,
  estimation and statuses
- [`project-management/docs/planning/SPRINTS.md`](SPRINTS.md) — the sprint record and its
  Retrospective
- `project-management/workflows/CONTEXT.md` — the workflow index, Explain-first and the running order
- `project-management/src/01-ROADMAP/ROADMAP.md` — the phases and their exit gates
