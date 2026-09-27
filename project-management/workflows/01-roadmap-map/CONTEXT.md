# Workflow: Roadmap Map

**Last Updated**: 27/09/2026

A phase is too big to plan in one sitting, and its questions have an order: which C standard, which
allocator strategy, which kernel base. Charting that decision frontier once, before any milestone is
cut, means every milestone afterwards inherits answers instead of reopening them and settling them
slightly differently each time.

## Directory Tree

```text
project-management/workflows/01-roadmap-map/
├── CONTEXT.md · CLAUDE.md   ← orientation (this file) · operating rules for the workflow
├── STEPS.md                 ← ordered steps, each closing on a "Done when" line
└── CHECKLIST.md             ← the gate ticked before the workflow counts as complete
```

## When to use this

- **Before the first milestone of a phase or track**, once `ROADMAP.md` names the phase and its exit
  gate. The P1 C foundations track is the first to chart; `MS001` was seeded before any map.
- **In later sessions, to resolve the map's open nodes** one at a time until no blocking node remains.
- **When a track is materially reshaped**: a research note overturns an assumption, or a phase's scope
  or exit gate changes in `ROADMAP.md`.
- **When a milestone completes**, to move the roadmap's "You are here" marker, a mechanical touch backed
  by that milestone's verification record.

A single milestone that fits an existing map goes straight to `02-milestone-creation/`; a single
hard-to-reverse choice with no wider frontier goes to `08-decisions/`.

## Key concepts

- **Runs once per phase or track, outside the per-milestone loop.** Everything from `02` to `13` runs
  per milestone; this sits upstream of it (`project-management/docs/planning/CADENCE.md` → _Chart the
  track first_).
- **The destination is the phase exit gate.** The map cites the gate in
  `project-management/src/01-ROADMAP/ROADMAP.md` and adds only what this track contributes to it.
- **Chart, then resolve, in separate sessions.** Charting draws the frontier and settles nothing except
  research nodes; resolving settles one node per later session. Mixing the two produces a map shaped by
  whatever was easiest to answer first.
- **Four node types.** An **explain-first** node is settled with the learner; a **research** node by a
  primary-source note (`.claude/skills/research/SKILL.md`); a **spike** node by a small throwaway
  experiment; a **build** node is specified onto a slice and left for its milestone to do.
- **The map is an index, not a vault.** Each resolved node links to the ADR, milestone or research note
  it became; the reasoning lives there.
- **Slices are milestones waiting to be cut.** Once every blocking node is resolved, the map's Slices
  table lists each milestone-sized concept with its nodes, what has to be true, and its flag manifest.
  `02-milestone-creation` cuts the milestone and allocates the `MS###`.
- **The registers are inputs.** Every open `GAPS.md` and `DEFERRED.md` entry is triaged against the
  track (closes, blocks or unrelated). The map claims the entries its track will retire; closing them
  happens later, against verified work.

## Cross-references

### Governing documents

- `project-management/src/01-ROADMAP/CLAUDE.md` — naming, node and slice IDs, map rules
- `project-management/src/01-ROADMAP/MAP-000-TEMPLATE.md` — the map scaffold
- `project-management/src/01-ROADMAP/ROADMAP.md` — the phases, exit gates and "You are here" marker
- `project-management/docs/planning/CADENCE.md` — where charting sits in the loop

### Related reading

- `project-management/workflows/CONTEXT.md` — Explain-first and the running order
- `project-management/workflows/02-milestone-creation/` — the next workflow; milestones cut from slices
- `project-management/workflows/08-decisions/` — where hard-to-reverse node outcomes graduate
- `research/CONTEXT.md` — how a research node's note is written and named
- `GAPS.md` · `DEFERRED.md` — the registers the map triages
