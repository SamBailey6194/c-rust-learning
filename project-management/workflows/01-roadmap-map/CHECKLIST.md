---
workflow: 01-roadmap-map
phase: plan
skills: [research]
---

# Roadmap Map — Checklist

**Last Updated**: 27/09/2026 | **Version**: 0.1.0 | **Maintained By**: Sam Bailey
**Language**: British English (en_GB) | **Timezone**: Europe/London

---

> **See** `project-management/REFERENCES.md` (planning and decision sources) ·
> `project-management/src/01-ROADMAP/CLAUDE.md` (naming and map rules) ·
> `project-management/src/01-ROADMAP/MAP-000-TEMPLATE.md` (the sections and columns) for supporting
> references. Tick the CHART and CLOSE groups for a new map, RESOLVE once per resolving session, and
> MOVE when a milestone completes.

## Execution Checklist

### Step 1 — Explain-first on the whole track

- [ ] The learner said what they already know, what they expect to be hardest, and what the exit gate
      requires, before any drafting
- [ ] The answers are in the map's Notes in the learner's own words

### Step 2 — Load the ground truth

- [ ] The phase row and section in `ROADMAP.md`, neighbouring maps and every ADR were read
- [ ] Every open `GAPS.md` and `DEFERRED.md` entry carries one verdict: closes, blocks or unrelated
- [ ] Neither register was edited

### Step 3 — Pin the destination and the bounds

- [ ] The destination cites the phase exit gate rather than copying it
- [ ] Out of scope is written with a reason for each item, and the learner agreed both

### Step 4 — Map the frontier breadth-first

- [ ] Every knowable decision is a node; nothing in scope but vague was forced into one
- [ ] No branch was followed to the bottom at the expense of the others

### Step 5 — Wire the edges and write the map

- [ ] Every node has an `N-###` ID, a type, its blockers (or "none") and a blocking flag
- [ ] At least one node is unblocked
- [ ] The map was copied from `MAP-000-TEMPLATE.md` and its row added to the Map index in the same change

### Step 6 — Fire the research nodes, then stop

- [ ] Every research node has a note under way in `research/`
- [ ] No explain-first, spike or build node was settled while charting

### Step 7 — Settle a node and graduate it (each RESOLVE session)

- [ ] The map's claims the node leans on were re-checked before settling
- [ ] The node was settled by its type, and the learner made any explain-first decision
- [ ] The outcome graduated to an ADR, research note, `GAPS.md` entry or `DEFERRED.md` row, and the
      resolved row links to it
- [ ] The frontier was redrawn and the session logged

### Step 8 — Cut the slices

- [ ] Every slice names its nodes, what must be true, and its flag manifest
- [ ] Every open node belongs to a slice
- [ ] No slice is bigger than about 8 points, and none reserves an `MS###`

### Step 9 — Close out the map

- [ ] No node marked as blocking a milestone is open
- [ ] The map's Status, index row and _Gate to milestones_ list are current
- [ ] `ROADMAP.md` agrees with the map; any changed scope or gate keeps its old wording in a comment

### Step 10 — Commit by explicit path

- [ ] Work is on a `pm/<desc>` branch, files staged by name (no `git add -A`, no `git add .`)
- [ ] The commit message follows Conventional Commits with scope `pm`

### Step 11 — Move the roadmap marker (when a milestone completes)

- [ ] The "You are here" table names the next milestone and cites the verification record
- [ ] The change rides in the final commit that sets the milestone `Completed`

---

## Context

- [ ] Directory trees in the relevant `CONTEXT.md` files show every file or folder this workflow created
- [ ] `project-management/REFERENCES.md` lists any new artefact type or external source
- [ ] `**Last Updated**` is refreshed in every `CONTEXT.md` modified
- [ ] If the session ended mid-work, a handoff exists in `handoffs/`

---

## Definition of Done

- [ ] Destination and out-of-scope bounds are agreed with the learner
- [ ] No blocking node is open, and every resolved node links to the artefact it became
- [ ] Every slice is ready for `project-management/workflows/02-milestone-creation/`
- [ ] Instructional files touched stay within the length cap
      (`bash code/src/scripts/audits/docs-length.sh`)
- [ ] British English throughout; dates DD/MM/YYYY
