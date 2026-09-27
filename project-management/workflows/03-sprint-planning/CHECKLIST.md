---
workflow: 03-sprint-planning
phase: plan
skills: []
---

# Sprint Planning — Checklist

**Last Updated**: 27/09/2026 | **Version**: 0.1.0 | **Maintained By**: Sam Bailey
**Language**: British English (en_GB) | **Timezone**: Europe/London

---

> **See** `project-management/REFERENCES.md` (MoSCoW, Fibonacci, Definition of Done) ·
> `project-management/docs/planning/SPRINTS.md` (record, admission, register, Retrospective) ·
> `project-management/docs/planning/CADENCE.md` (the figures) for supporting references.

## Execution Checklist

### Step 1 — Explain-first on the fortnight

- [ ] The learner stated the study time available and the reason this milestone belongs in this fortnight
- [ ] The last Retrospective's "one change" was checked

### Step 2 — Find the live sprint, or open one

- [ ] Exactly one sprint is `Open` or `Full`
- [ ] A newly opened sprint has a goal, two-week dates, `Status: Open`, the capacity total from
      `CADENCE.md`, and the register copied forward

### Step 3 — Admit the milestone, or mark the sprint full

- [ ] The milestone was admitted within capacity, or within grace with a one-line reason, or the sprint
      was marked `Full` and closed with its Retrospective
- [ ] The Milestone Summary and the `used / total` capacity line agree

### Step 4 — Recompute the flags union

- [ ] Every sprint flag equals the union of its members' flags
- [ ] Any flagged tool recorded as missing in `GAPS.md` was raised with the learner

### Step 5 — Update dependencies and the backlog register

- [ ] Dependencies between members, and what this sprint unblocks, are written
- [ ] The register's own row matches the Milestone Summary; every other row matches the previous record

### Step 6 — Commit by explicit path

- [ ] Admission committed on the milestone branch, files staged by name, scope `pm`

### Step 7 — Write the Retrospective and carry over (time-out only)

- [ ] All five Retrospective answers are written; the learner's own words for what stuck, what did not
      and the one change
- [ ] Every unfinished member is carried into the next sprint with the points it still needs
- [ ] The sprint is `Closed`, committed on the open milestone branch or a `pm/<desc>` branch, and its
      register is left as a snapshot
- [ ] After the second Retrospective, velocity was compared with capacity in `CADENCE.md`

---

## Context

- [ ] Directory trees in the relevant `CONTEXT.md` files show every file or folder this workflow created
- [ ] `project-management/REFERENCES.md` lists any new artefact type or external source
- [ ] `**Last Updated**` is refreshed in every `CONTEXT.md` modified
- [ ] If the session ended mid-work, a handoff exists in `handoffs/`

---

## Definition of Done

- [ ] Exactly one sprint is live, within capacity or a justified grace
- [ ] Its flags, capacity line, Milestone Summary and register all agree
- [ ] No sprint closed without its Retrospective, and no member was dropped
- [ ] British English throughout; dates DD/MM/YYYY
