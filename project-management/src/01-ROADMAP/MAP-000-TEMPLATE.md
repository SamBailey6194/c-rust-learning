# MAP-[TRACK] — [Title]

**Charted**: DD/MM/YYYY | **Charted by**: Sam Bailey | **Workflow**: `01-roadmap-map`
**Phase**: [P#] — `project-management/src/01-ROADMAP/ROADMAP.md`
**Status**: [Charting | Resolving | Blockers clear — milestones may be cut | Complete]
**Frontier open**: [n] | **Blocking open**: [n]

> Copy to `MAP-<TRACK>.md`, replace every `[PLACEHOLDER]`, delete the `[EXAMPLE]` rows, and add a
> row to this folder's `CONTEXT.md` → Map index in the same change. **The map is an index, not a
> vault**: every resolved node links to the artefact it became, and the reasoning lives there.

---

## Destination

[One or two lines: what "done" looks like for this track. Anchor it to the phase exit gate in
`ROADMAP.md` — cite it, do not copy it — and add only what this track contributes.]

[EXAMPLE] P1 exit gate met: I can write, test, sanitise and memcheck a multi-file C program
unaided, and explain every warning the build raises.

---

## Notes

| Field | Value |
| --- | --- |
| Phase exit gate | [P#] — `project-management/src/01-ROADMAP/ROADMAP.md` → P# |
| Already known | [PLACEHOLDER — what the learner can already do, from the explain-first interview] |
| Expected to be hard | [PLACEHOLDER — the learner's own prediction, checked later in `12-FINDINGS/`] |
| Skills to load | [PLACEHOLDER — from `.claude/skills/`: teach, research, handoff, wait-what] |
| Standing preferences | [PLACEHOLDER — decisions already made that bound this track] |
| Umbrella ADRs | [EXAMPLE] `project-management/src/08-DECISIONS/ADR-MS001-C-STANDARD-C17-27-09-2026.md` |
| Primary resources | [PLACEHOLDER — the chapters and docs this track follows; start from the phase list in `ROADMAP.md`] |
| Register entries triaged | [n] closes, [n] blocks, [n] unrelated — from `GAPS.md` and `DEFERRED.md` |

**Register triage is a claim, not a close.** Every open `GAPS.md` / `DEFERRED.md` entry gets a
verdict here — `closes` (this track retires it), `blocks` (it stands in the way, so it becomes a
frontier node) or `unrelated`. Nothing in this map edits either register.

---

## Resolved decisions

Each row links to the artefact it became. **An answer that lives only here has not graduated.**

| Node | Decision | Type | Settled | Became |
| --- | --- | --- | --- | --- |
| N-001 | [EXAMPLE] Which C standard the track targets | explain-first | DD/MM/YYYY | [EXAMPLE] `project-management/src/08-DECISIONS/ADR-MS001-C-STANDARD-C17-27-09-2026.md` |
| N-002 | [PLACEHOLDER] | | | |

---

## Slices

The milestone cut list — **each slice becomes one milestone**. A slice is a manifest, not a
design: it names what must become true and which gates run. The gate owns the design and may add
to a value; the milestone is updated to match when the gate closes. Flags are written inline with
`N/A` omitted; the full flag roster and each flag's gate are in
`project-management/src/02-MILESTONES/MS000-TEMPLATE.md`.

| Slice | Milestone | Title | Nodes | Mastery (what must be true) | Flags |
| --- | --- | --- | --- | --- | --- |
| S-01 | `MS###` | [EXAMPLE] Pointers | [EXAMPLE] N-003 resolved | [EXAMPLE] can explain array decay and pointer arithmetic; exercise set green under `san` and `memcheck` | [EXAMPLE] Exercises: pointer drills; Tests; Memory; Debugger: gdb walk of a pointer bug |
| S-02 | — | [PLACEHOLDER] | [PLACEHOLDER] | [PLACEHOLDER] | [PLACEHOLDER] |

**Node state** is written as `resolved`, `open` or `BLOCKING`. A slice is cuttable only when every
node it names is resolved, and every open node belongs to some slice or to fog of war — an
unlisted node is work with no route to a milestone.

**Mastery says what must be TRUE; Flags say which gates RUN.** Neither restates the other.

**The Milestone column is back-filled by `02-milestone-creation`**, which allocates the next free
`MS###` when it writes the milestone. A slice with no milestone yet reads `—`; this map never
reserves a number, so a slice that is later merged or dropped burns nothing.

---

## Frontier

Open decisions in dependency order. **Blocked by** names other nodes, so the next takeable node is
visible at a glance; at least one node is unblocked, or the wiring is wrong.

| Node | Decision | Type | Blocked by | Blocking a milestone? |
| --- | --- | --- | --- | --- |
| N-003 | [PLACEHOLDER] | explain-first | none | yes |
| N-004 | [PLACEHOLDER] | research | N-003 | no |
| N-005 | [PLACEHOLDER] | spike | none | no |
| N-006 | [PLACEHOLDER] | build | N-003 | no |

**Types:**

- `research` — looked up, not decided by interview; graduates to a note in `research/` via the
  `research` skill.
- `explain-first` — a question the learner reasons through with Claude asking, not telling; a
  hard-to-reverse outcome graduates to an ADR.
- `spike` — a small throwaway experiment in `learning/` that raises confidence before deciding.
- `build` — the work a slice's milestone carries; named here, done in the milestone. A `build`
  node never blocks a milestone, because it _is_ the milestone's work.

**Manual unblocking work is not a node.** Installing a package or fixing the host is a `GAPS.md`
entry.

**Blocking a milestone?** `yes` means no milestone in this track is cut until the node is settled.
Only these gate `02-milestone-creation`; the rest may stay open.

---

## Fog of war

In scope, but not yet sharp enough to state as a decision. **Leaving something here is honest;
forcing it into a node is not.** Promote an item to the frontier when a result sharpens it.

- [PLACEHOLDER]

---

## Out of scope

Consciously ruled out, with the reason, so it is not silently reopened later. A topic parked for a
later phase goes to `DEFERRED.md` as well.

| Ruled out | Why |
| --- | --- |
| [PLACEHOLDER] | [PLACEHOLDER] |

---

## Session log

One row per resolving session, so the map's history is legible without git archaeology.

| Date | Node settled | Outcome | Frontier redrawn |
| --- | --- | --- | --- |
| DD/MM/YYYY | N-00# | [PLACEHOLDER] | [ ] |

---

## Gate to milestones

- [ ] Destination and out-of-scope bounds agreed with the learner
- [ ] Every open `GAPS.md` / `DEFERRED.md` entry triaged — closes, blocks or unrelated
- [ ] Every claimed entry names what will retire it; **neither register edited here**
- [ ] Every knowable decision is a node or sits in fog of war
- [ ] Every node typed and blocker-wired
- [ ] **Every node marked "blocking a milestone" is resolved**
- [ ] Every resolved node links to the artefact it became
- [ ] **Every slice has a mastery line and a flag manifest**
- [ ] Index row in `project-management/src/01-ROADMAP/CONTEXT.md` current

**Milestones may be cut in `project-management/workflows/02-milestone-creation/` once every box
above is ticked.**
