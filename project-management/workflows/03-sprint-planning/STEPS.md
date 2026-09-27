---
workflow: 03-sprint-planning
phase: plan
skills: []
---

# Sprint Planning — Steps

**Last Updated**: 27/09/2026 | **Version**: 0.1.0 | **Maintained By**: Sam Bailey
**Language**: British English (en_GB) | **Timezone**: Europe/London

---

## Key references

Consult `project-management/REFERENCES.md` (MoSCoW, Fibonacci, Definition of Done) as you work through
these steps:

| Step | Section |
| --- | --- |
| 1, 3 | `project-management/docs/planning/CADENCE.md` → _Sprint capacity — the trigger_ |
| 2–5 | `project-management/docs/planning/SPRINTS.md` → _The sprint record_, _Admission_, _The backlog register_ |
| 2 | `project-management/src/03-STUDY-SPRINTS/SPRINT-00-TEMPLATE.md` — the scaffold |
| 4 | `project-management/docs/planning/MILESTONES.md` → _The FLAGS table_ |
| 7 | `project-management/docs/planning/SPRINTS.md` → _The Retrospective_ |
| 6, 7 | `project-management/docs/git/COMMITS.md` — scope `pm`, staging by explicit path |

---

## OPEN AND ADMIT — after every milestone is written

### Step 1 — Explain-first on the fortnight

Ask the learner: how much study time the next fortnight really holds, what the last Retrospective's
"one change" was and whether it is being kept, and, for the milestone being admitted, why it belongs in
this fortnight rather than a later one. Record the answers where they belong: the time available and the
reason in the sprint's goal or notes, the kept or dropped change in the Retrospective it came from.

_Done when the learner's answers are recorded and the milestone's reason for this fortnight is stated._

### Step 2 — Find the live sprint, or open one

List the records (`ls project-management/src/03-STUDY-SPRINTS/`) and find the one whose Status is `Open`
or `Full`. If there is none, open the next: copy `SPRINT-00-TEMPLATE.md` to the next free `SPRINT-##.md`,
write a one-sentence goal tied to the phase exit gate, the start and end dates (two weeks), `Status: Open`
and the capacity total from `CADENCE.md`, and copy the backlog register forward from the previous record.

_Done when exactly one sprint is live and its goal, dates and capacity total are written._

### Step 3 — Admit the milestone, or mark the sprint full

Add the milestone's points to the sprint's points used, then take exactly one of three outcomes:

1. **Within capacity (13):** admit it. Add its row to the Milestone Summary (ID, title, MoSCoW,
   points) and update the capacity line. If points used now equal 13, mark the sprint `Full`.
2. **Past capacity, within grace (16), and the milestone would split badly:** admit it, write one
   line saying why grace was used, and mark the sprint `Full`.
3. **Otherwise:** do not admit it. Mark the sprint `Full`; because of the cadence its members are all
   `Completed`, so it closes now (`project-management/docs/planning/SPRINTS.md` → _Sprint statuses_,
   rule 2), with its Retrospective written as in Step 7 and committed on the milestone branch in its own
   commit. Then return to Step 2 and open the next sprint with this milestone as its first member.

_Done when the milestone is a member of exactly one live sprint and the capacity line is current._

### Step 4 — Recompute the flags union

For each of the eleven flags, the sprint's value is the union of its members' values; `N/A` only when
every member's is `N/A`. Compare the union with `GAPS.md`: a flag whose tool is recorded as missing
(a `QEMU` or `Kernel` flag while the kernel build dependencies are not installed) is raised with the
learner now, before the fortnight starts, not discovered in `10-study-and-build`.

_Done when every sprint flag equals the union of its members' flags and any tool gap has been raised._

### Step 5 — Update dependencies and the backlog register

Note which member waits on which, and which later milestone this sprint unblocks. Update the live
record's backlog register: its own row lists the members in admission order with MoSCoW and points, and
its points as `used / total`. Every other row matches the previous record's copy line for line.

_Done when the register lists every sprint so far and its own row matches the Milestone Summary._

### Step 6 — Commit by explicit path

Admission rides on the milestone's own branch, so the sprint change and the milestone arrive on `main`
together:

```bash
git add project-management/src/03-STUDY-SPRINTS/SPRINT-05.md
git commit -m "docs(pm): admit MS007 to SPRINT-05"
```

_Done when `git status` shows nothing from this workflow left uncommitted._

---

## ROLL OVER — when the two weeks end with work unfinished

### Step 7 — Write the Retrospective and carry over

When a sprint's end date passes and a member is still `Open`, `In Progress`, `Blocked` or `Parked`,
close the sprint (`project-management/docs/planning/SPRINTS.md` → _Sprint statuses_, rule 3). A member
already `Verifying` is the exception: the sprint waits for its merge and closes then, through
`12-review-and-reflect` Step 8 and `13-pr-and-merge` Step 10. The commit rides on the branch that is open:
the unfinished milestone's own branch if one is, otherwise a `pm/<desc>` branch
(`project-management/docs/git/BRANCHES.md`).

1. Write the Retrospective's five answers (`project-management/docs/planning/SPRINTS.md` → _The
   Retrospective_): what stuck, what did not, velocity (points `Completed` against capacity), carried
   over, and one change. The learner answers the first two and the last in their own words.
2. **Carry over** each unfinished member: estimate the points it still needs, note it in this record's
   Dependencies, and admit it as the first member of the next sprint (Steps 2 and 3).
3. Set the sprint to `Closed`. Its backlog register is now a snapshot and is never edited again.
4. After the second Retrospective, compare the two velocities with the capacity figure and, if they
   disagree, change the figure in `CADENCE.md` in the same commit, with the old value kept in an HTML
   comment.

_Done when the closed sprint has all five answers, every unfinished member is admitted to the next
sprint, and exactly one sprint is live again._

---

## Update context files

If this workflow created files or folders, or settled a new convention:

1. Add every new file or folder to the directory tree in the nearest `CONTEXT.md`.
2. Add any new artefact type or external source to `project-management/REFERENCES.md`.
3. Refresh `**Last Updated**` in every `CONTEXT.md` you modified.
4. If the session ends before Completion, run `/handoff` to write
   `handoffs/HANDOFF-<SCREAMING-KEBAB-DESCRIPTOR>-DD-MM-YYYY.md`.

---

## Completion

Run through `CHECKLIST.md` before marking this workflow complete. Next, as the milestone's flags
require: `project-management/workflows/04-exercise-design/` to `07-os-profile-spec/`, then
`08-decisions/`.
