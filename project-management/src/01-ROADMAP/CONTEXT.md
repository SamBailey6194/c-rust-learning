# project-management/src/01-ROADMAP/ — Roadmap and Track Maps

**Last Updated**: 28/09/2026

The top of the planning chain. `ROADMAP.md` defines the eighteen phases in six tracks — Foundation
(P1 to P3), Kernel (P4 to P5), OS (P6), UI (U1 to U3), LLM (L1 to L6) and Security (S1 to S3) — with
each phase's goal, topics, candidate milestones, exit gate and primary resources, and marks where the
learner is now. It is the single owner of the phases: every other file that names a phase cites it.
Beside it sit the track maps, one `MAP-<TRACK>.md` per track, charted before that track's milestones
are cut. A map asks the cross-cutting questions of a track once — which C standard, which kernel base,
which init system — so that each milestone does not rediscover them and answer them slightly
differently.

## Directory Tree

```text
project-management/src/01-ROADMAP/
├── CONTEXT.md · CLAUDE.md   ← this pair: what lives here and the map index · how to work here
├── ROADMAP.md               ← eighteen phases in six tracks: goal, topics, candidates, exit gate, resources, "you are here"
├── MAP-000-TEMPLATE.md      ← map template — copied to chart a track
├── MAP-KERNEL.md            ← Kernel track (P4–P5) — Charting draft
├── MAP-SYNTEK-OS.md         ← OS track (P6) — Charting draft
├── MAP-UI.md                ← UI track (U1–U3) — Charting draft
├── MAP-LLM.md               ← LLM track (L1–L6) — Charting draft
├── MAP-SECURITY.md          ← Security track (S1–S3) — Charting draft
└── MAP-<TRACK>.md           ← further decision maps (the P1–P3 Foundation map is not charted yet)
```

## What the roadmap holds

| Section | Holds |
| --- | --- |
| **You are here** | The current phase, milestone and status, and the next step |
| **Phase overview** | One row per phase: name, what it covers, exit gate summary |
| **Per-phase sections** | Goal, topic list and its `learning/` topic folders, candidate milestones, exit gate (command-checkable where possible), primary resources |
| **Changing the roadmap** | How a phase's scope or gate changes, and when that change needs an ADR |

Only `MS001` has a number. Every other milestone in the roadmap is a **candidate**: a named slice of
work that receives a number when `project-management/workflows/02-milestone-creation/` cuts it from
a map.

## What a map holds

| Section | Holds |
| --- | --- |
| **Destination** | One or two lines: what "done" looks like for the track, anchored to the phase exit gate |
| **Notes** | What the learner already knows, skills to load, standing preferences, umbrella ADRs, register triage |
| **Resolved decisions** | Settled nodes, each linking to the ADR, milestone or research note it became |
| **Slices** | The milestone cut list — each slice becomes one milestone |
| **Frontier** | Open decisions in dependency order, with blocking edges |
| **Fog of war** | In scope, not yet sharp enough to state as a decision |
| **Out of scope** | Consciously ruled out, and why |
| **Session log** | One row per resolving session |
| **Gate to milestones** | The checklist that clears the map for milestone creation |

**The map is an index, not a vault.** Detail lives in the artefact each node graduates to.

## Map index

| Map | Track or phase | Status | Frontier open | Slices | Charted |
| --- | --- | --- | --- | --- | --- |
| `MAP-KERNEL.md` | Kernel (P4–P5) | Charting | 3 | 0 | 27/09/2026 |
| `MAP-SYNTEK-OS.md` | OS (P6) | Charting | 6 | 0 | 27/09/2026 |
| `MAP-UI.md` | UI (U1–U3) | Charting | 1 | 0 | 27/09/2026 |
| `MAP-LLM.md` | LLM (L1–L6) | Charting | 5 | 0 | 27/09/2026 |
| `MAP-SECURITY.md` | Security (S1–S3) | Charting | 4 | 0 | 27/09/2026 |

A map in this folder with no row here is an index that has drifted: the row arrives in the same
change as the map. **P1 C foundations is still the first map to take through to milestones; the
later-track maps are Charting drafts** that record the decisions Sam settled in the planning
conversation of 27/09/2026 and leave the rest as frontier and fog until each track's own charting
session. `MS001` was seeded with the repository, before any map.

## Cross-references

- `project-management/workflows/01-roadmap-map/` — the procedure that writes here
- `project-management/src/02-MILESTONES/` — milestones cut from a map's slices
- `project-management/src/08-DECISIONS/` — where hard-to-reverse node resolutions graduate
- `project-management/docs/planning/CADENCE.md` — when a map is charted relative to milestones
- `GAPS.md`, `DEFERRED.md` — the registers a map triages (it claims entries, it does not close them)
- `research/` — where `research` nodes graduate as notes
