---
workflow: 01-roadmap-map
phase: plan
skills: [research]
---

# Roadmap Map — Steps

**Last Updated**: 27/09/2026 | **Version**: 0.1.0 | **Maintained By**: Sam Bailey
**Language**: British English (en_GB) | **Timezone**: Europe/London

---

## Key references

Consult `project-management/REFERENCES.md` as you work through these steps; the map's own words (frontier
node, spike, fog of war, slice, epic) are defined in `project-management/CONTEXT.md` → _Glossary_:

| Step | Section |
| --- | --- |
| 1–3 | `project-management/src/01-ROADMAP/ROADMAP.md` — the phase row, its exit gate and primary resources |
| 2 | `GAPS.md` · `DEFERRED.md` — the registers every open entry of which is triaged |
| 5, 7, 8 | `project-management/src/01-ROADMAP/MAP-000-TEMPLATE.md` — the map sections and table columns |
| 5, 8 | `project-management/src/01-ROADMAP/CLAUDE.md` — map naming, `N-###` and `S-##` IDs |
| 6, 7 | `.claude/skills/research/SKILL.md` — one question per note, a citation per claim |
| 7 | `project-management/workflows/08-decisions/` — where a hard-to-reverse outcome goes |
| 8 | `project-management/docs/planning/MILESTONES.md` → _The FLAGS table_ and _Estimation_ |
| 10 | `project-management/docs/git/COMMITS.md` — scope `pm`, staging by explicit path |

---

## CHART — one session

### Step 1 — Explain-first on the whole track

Before opening a file, ask the learner three things and write the answers down: what they can already
do in this track (and where they learned it), what they expect to be hardest, and, in their own words,
what the phase exit gate in `ROADMAP.md` will require of them. These answers become the map's _Already
known_ and _Expected to be hard_ rows, and the second is checked against reality later in
`project-management/src/12-FINDINGS/`.

_Done when the learner's three answers are recorded in their own words._

### Step 2 — Load the ground truth

Read, in this order, each narrowing the next:

1. The phase row and section in `ROADMAP.md`: goal, topics, candidate milestones, exit gate, resources.
2. Every open entry in `GAPS.md` and every `DEFERRED.md` row, with the record behind each.
3. Any existing map for a neighbouring track, and every ADR in `project-management/src/08-DECISIONS/`.
4. The `project-management/src/` records of milestones already completed in earlier phases, so the map
   reflects what was actually learned rather than what was once planned.

Give every open register entry one verdict: **closes** (the track will retire it; it goes under the map's
register notes), **blocks** (it stands in the track's way; it becomes a frontier node), or **unrelated**
(counted, so the triage is provably complete). Do not edit either register here.

_Done when every open register entry carries a verdict._

### Step 3 — Pin the destination and the bounds

With the learner, write the destination in one or two lines, anchored to the phase exit gate (cite it;
do not copy it), and list what is consciously **out of scope** and why. A kernel track that rules out
Rust-for-Linux until clang/LLVM is installed says so here.

_Done when the destination and out-of-scope bounds are written and the learner agrees with both._

### Step 4 — Map the frontier breadth-first

List every open question that is currently knowable, across the whole track, before following any one
to the bottom. Typical P1 and P2 questions: which C standard, how strictly the kernel coding style
applies to tests, which allocator strategy the malloc project starts from, which POSIX interfaces the
shell project covers. Anything in scope but not yet sharp enough to state as a question goes to **fog of
war**, honestly, rather than being forced into a node.

_Done when every knowable decision is a node or is parked in fog of war._

### Step 5 — Wire the edges and write the map

Give each node an `N-###` ID, a type (**explain-first**, **research**, **spike** or **build**), the nodes
that block it (or "none"), and whether it blocks a milestone. Copy `MAP-000-TEMPLATE.md` to
`MAP-<TRACK>.md`, fill the header, Destination, Notes, Frontier, Fog of war and Out of scope, and add the
map's row to `project-management/src/01-ROADMAP/CONTEXT.md` → Map index in the same change.

_Done when the map exists, is indexed, and at least one frontier node is unblocked._

### Step 6 — Fire the research nodes, then stop

Dispatch the research nodes now: `/research <question>` for each, one note per question in
`research/<SCREAMING-KEBAB-TOPIC>.md`. They need no decision from the learner. **Settle nothing else in
this session**; charting ends with the frontier drawn and unresolved.

_Done when every research node has a note under way and no other node has been settled._

---

## RESOLVE — one node per later session

### Step 7 — Settle a node and graduate it

Per session:

1. **Re-read the map** and re-check any claim the node leans on (a register entry, a tool's presence, a
   citation); claims drift while a map waits.
2. **Take one unblocked node**, the learner's pick or the most blocking one.
3. **Settle it by type.** An explain-first node: run Explain-first on that question and let the learner
   decide, with Claude laying out the options and their costs. A research node: read its note. A spike
   node: a small throwaway experiment in the relevant `learning/` topic's `NOTES/`, never in `code/src/`.
   A build node is not performed: write what it has to deliver into the slice that will carry it.
4. **Graduate the outcome** to its real home: an ADR through `08-decisions` if it is hard to reverse, a
   research note, a `GAPS.md` entry for a new blocker, or a `DEFERRED.md` row for a parked topic. Move
   the node to _Resolved decisions_ with a link to what it became.
5. **Redraw the frontier**: re-wire the edges, promote any fog the outcome sharpened, and log the
   session in the map's Session log.

_Repeat until no node marked as blocking a milestone is open._

### Step 8 — Cut the slices

Fill the map's Slices table, one row per milestone-sized concept, in the template's columns: Slice,
Milestone, Title, Nodes, Mastery (what must be true), Flags.

- **Nodes:** every node the slice carries. A slice is cuttable only when all of them are resolved, and
  no open node belongs to no slice.
- **Mastery:** what must be true when the slice is done, as observable results, not steps.
- **Flags:** the gates the milestone will need, with first-pass values (the eleven flags are defined in
  `project-management/docs/planning/MILESTONES.md` → _The FLAGS table_).
- **Size check:** 8 points is the largest slice; one that feels like 13 or more is several slices
  (`project-management/docs/planning/MILESTONES.md` → _Estimation_).

Leave the Milestone column `—`; `02-milestone-creation` allocates the number and back-fills it.

_Done when every slice names its nodes, mastery and flags, and no slice has a reserved `MS###`._

---

## CLOSE — once the blockers are clear

### Step 9 — Close out the map

Set the map's Status to _Blockers clear — milestones may be cut_, update the index row, and tick the map's
_Gate to milestones_ list. If charting changed a phase's scope or exit gate, edit `ROADMAP.md` as its
_Changing the roadmap_ section says, with the old wording kept in an HTML comment; reordering, adding or
dropping a phase goes through `08-decisions` first.

_Done when the map's gate list is ticked and `ROADMAP.md` agrees with the map._

### Step 10 — Commit by explicit path

On a `pm/<desc>` branch (`project-management/docs/git/BRANCHES.md`):

```bash
git add project-management/src/01-ROADMAP/MAP-C-FOUNDATIONS.md \
        project-management/src/01-ROADMAP/CONTEXT.md
git commit -m "docs(pm): chart the P1 C foundations map"
```

Research notes written in Step 6 are committed in the same change, each named by path.

_Done when `git status` shows nothing from this workflow left uncommitted._

---

## MOVE — when a milestone completes

### Step 11 — Move the roadmap marker

When a milestone is being set to `Completed` in `13-pr-and-merge`, update the "You are here" table in
`ROADMAP.md` to the next milestone, citing the verification record in
`project-management/src/10-PROGRESS/` that justifies the move. The edit rides in the same final commit
as the `Completed` status, so `main` never shows a marker ahead of, or behind, its evidence. When a
phase's exit gate passes, set that phase's State in the phase overview and name the evidence. This is a
mechanical touch with no Explain-first; a marker found stale later is corrected on a `pm/<desc>` branch.

_Done when the marker names the milestone now in progress and cites the evidence for the move._

---

## Update context files

If this workflow created files or folders, or settled a new convention:

1. Add every new file or folder to the directory tree in the nearest `CONTEXT.md` (a new map is also a
   row in `project-management/src/01-ROADMAP/CONTEXT.md` → Map index).
2. Add any new artefact type or external source to `project-management/REFERENCES.md`.
3. Refresh `**Last Updated**` in every `CONTEXT.md` you modified.
4. If the session ends before Completion, run `/handoff` to write
   `handoffs/HANDOFF-<SCREAMING-KEBAB-DESCRIPTOR>-DD-MM-YYYY.md`.

---

## Completion

Run through `CHECKLIST.md` before marking this workflow complete.
