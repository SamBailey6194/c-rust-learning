# SPRINT-00

**Last Updated**: DD/MM/YYYY | **Version**: 0.1.0 | **Maintained By**: Sam Bailey
**Language**: British English (en_GB) | **Timezone**: Europe/London

_Template — copy to `SPRINT-##.md` (the next number) when a sprint opens, replace every
`[PLACEHOLDER]`, delete the `[EXAMPLE]` rows._

---

**Goal:** [One sentence: what this fortnight proves, in terms of the phase exit gate in
`project-management/src/01-ROADMAP/ROADMAP.md`.]

**Status:** Open

<!-- Sprint status words are owned by project-management/docs/planning/SPRINTS.md -> Sprint
     statuses; milestone status words by project-management/docs/planning/MILESTONES.md.
     Not restated here. -->

**Timeline:** DD/MM/YYYY to DD/MM/YYYY | **Capacity:** [used] / [total] points

<!-- Sprint length, capacity and grace: project-management/docs/planning/CADENCE.md ->
     Sprint capacity — the trigger. The [total] above is copied from there when the sprint opens. -->

<!-- FLAGS — the UNION of the member milestones' flags, one row per gate, computed from the
     Milestone Summary below, never authored on its own. A row reading N/A here while a member
     reads a value is a mistake in one of the two. Row meanings:
     project-management/docs/planning/MILESTONES.md -> The FLAGS table. -->

| Flag | Value |
| --- | --- |
| Exercises | [EXAMPLE] MS002: C, 5 exercises |
| Project | [EXAMPLE] N/A |
| Kernel | [EXAMPLE] N/A |
| Distro | [EXAMPLE] N/A |
| Tests | [EXAMPLE] `make -C code/src/c/ms002-<kebab> test` |
| Memory | [EXAMPLE] `make ... san` + `make ... memcheck` |
| Debugger | [EXAMPLE] MS002: gdb walk of an off-by-one |
| Lint | [EXAMPLE] `make ... lint` |
| QEMU | [EXAMPLE] N/A |
| Notes | [EXAMPLE] `learning/c-01-foundations/` |
| Research | [EXAMPLE] N/A |

---

## Milestone Summary

In admission order.

| ID | Title | MoSCoW | Points |
| --- | --- | --- | --- |
| `MS###` | [EXAMPLE] [Milestone title] | Must | N |
| `MS###` | [EXAMPLE] [Milestone title] | Should | N |

**Total:** [N] points

## Dependencies

- [EXAMPLE] `MS###` requires `MS###` (SPRINT-##) — [reason].
- [EXAMPLE] `MS###` has no upstream dependency.
- [EXAMPLE] Carried over from SPRINT-##: `MS###`, [N] points still needed — [why].
- This sprint unblocks: [EXAMPLE] `MS###` ([brief description]).

## Backlog register

<!-- Identical in every live SPRINT-##.md; rule and shape owned by
     project-management/docs/planning/SPRINTS.md -> The backlog register. Say which record the
     reader is in here in the prose, never inside a cell. -->

This is the register as held in SPRINT-[##].

| Sprint | Members, in admission order | Points |
| --- | --- | --- |
| `SPRINT-##` | [EXAMPLE] MS### (`Must`, N) then MS### (`Should`, N) | [used] / [total] — [open, full or closed] |

---

## Mastery Criteria

[One or two sentences: what the sprint delivers as a whole. Each member's own mastery criteria stay
in its milestone file and are not copied here.]

- [ ] [EXAMPLE] Every member milestone `Completed`, each with its verification record
- [ ] [EXAMPLE] The phase exit gate is [n] milestones closer: [which part of it this sprint proves]

---

## Tasks

| Milestone | Task | Done |
| --- | --- | --- |
| `MS###` | [EXAMPLE] Plan written in `project-management/src/09-MILESTONE-PLANS/` | [ ] |
| `MS###` | [EXAMPLE] Study and build per the plan | [ ] |
| `MS###` | [EXAMPLE] Verification record in `project-management/src/10-PROGRESS/` | [ ] |

---

## Verification Checks

Before the sprint closes. The gates each member ran are in its own verification record; this list
checks the sprint, not the code.

- [ ] Every member's status reflects its verification record
- [ ] FLAGS table equals the union of the members' flags
- [ ] Backlog register matches the previous record's copy row for row; its own row matches this
      record's capacity line

---

## Retrospective

<!-- Mandatory. The sprint does not close until this section is written.
     The five questions: project-management/docs/planning/SPRINTS.md -> The Retrospective. -->

### What stuck

- [EXAMPLE] [Concept I can now explain without notes] — proved by `MS###`

### What did not

- [EXAMPLE] [Concept that passed its gates but still feels borrowed] → explain-first question for
  `MS###`, or a record in `project-management/src/12-FINDINGS/`

### Velocity

[N] points `Completed` against a capacity of [N]. [One line: what this says about the capacity
figure, with the previous sprint's figure beside it once there is one.]

### Carried over

- [EXAMPLE] `MS###` — [why], [N] points still needed, moved to SPRINT-##

### One change

[A single adjustment to how the next sprint runs, so its effect can be seen.]

---

## Definition of Done

- [ ] Every member milestone `Completed`, or carried over with its reason
- [ ] Every sprint-level task ticked
- [ ] Every verification check above ticked
- [ ] Retrospective written — all five parts
- [ ] Backlog register updated in this (the live) record; `Closed` records' copies left as snapshots
- [ ] Sprint status set to its closing value
