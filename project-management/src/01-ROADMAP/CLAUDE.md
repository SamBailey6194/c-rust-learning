@./CONTEXT.md

# CLAUDE.md — project-management/src/01-ROADMAP/

Read order: `.claude/CLAUDE.md` → `.claude/MEMORY.md` → this folder's `CONTEXT.md` (what the
roadmap and a map hold, and the map index — imported above) → this file → `ROADMAP.md`.

## Purpose (one line)

The phase roadmap and the track decision maps — `ROADMAP.md` owns the eighteen phases across six
tracks and their exit gates; each `MAP-<TRACK>.md` charts one track's decisions and cuts it into
milestone slices.

## How to work here

- **Routing:** start from `project-management/workflows/01-roadmap-map/` (`STEPS.md` +
  `CHECKLIST.md`). It charts a map, resolves one node per session, and edits `ROADMAP.md`. Slices
  leave this folder through `project-management/workflows/02-milestone-creation/`; a node whose
  answer is hard to reverse leaves through `project-management/workflows/08-decisions/`.
- **Concrete steps:** to chart — interview the learner (what they know, what they expect to be
  hard) → copy `MAP-000-TEMPLATE.md` to `MAP-<TRACK>.md` → fill destination, notes, frontier,
  fog of war and out of scope → add the index row in `CONTEXT.md`. To resolve — settle one node →
  move it to Resolved decisions with a link to what it became → redraw the frontier → log the
  session → update the index row. To move the roadmap — change the "You are here" table only when
  a verification record in `project-management/src/10-PROGRESS/` backs the change.
- **Definition of done:** destination and out-of-scope bounds agreed with the learner; every node
  typed and blocker-wired; every resolved node links to its artefact; the index row current;
  `ROADMAP.md` position matches the latest verification evidence; British English; DD/MM/YYYY.

## Guardrails

- **Keep the phases in one place.** `ROADMAP.md` owns them. Anywhere else a phase appears — including
  a track letter such as U2, L4 or S1 — it is a citation
  (`project-management/src/01-ROADMAP/ROADMAP.md` → P3), never a second definition.
- **Move the position marker only on evidence.** A milestone is closed by its verification record
  and a phase by its exit gate passing, not by the topics feeling familiar.
- **Keep changed wording visible.** When a phase's scope or exit gate changes, leave the previous
  wording in an HTML comment (`<!-- CHANGED DD/MM/YYYY: previously read "..." — why -->`). Reordering,
  adding or dropping a phase is hard to reverse: raise an ADR first.
- **Keep the map an index, not a vault.** A node's reasoning lives in the ADR, milestone or
  research note it graduates to; a map that grows the detail becomes the document nobody reads.
- **Graduate every resolved node.** An answer left only in a map dies with the map.
- **Claim register entries; do not close them.** A map records which `GAPS.md` / `DEFERRED.md`
  entries its track will retire. Marking one closed happens against verified work, not here.
- **Chart and resolve in separate sessions.** Settling nodes while charting biases the map towards
  whatever was easiest to answer in the moment.
- **Leave fog honest.** Do not promote a vague idea to a node to make the map look complete.
- **Do not reserve milestone numbers in a map.** The slice's Milestone column is back-filled by
  `02-milestone-creation`, which allocates the next free `MS###`; a dropped slice then burns
  nothing.
- **Let blocking nodes gate milestones, and only those.** Waiting for a fully resolved map before
  cutting a milestone means never cutting one.
- **Keep it documentation.** No code, no kernel config dumps, no secrets.

## Output & naming

- **Hand-written:** `ROADMAP.md` (one file, not split per phase), every `MAP-<TRACK>.md`, and the
  map index in this folder's `CONTEXT.md`.
- **Template:** `MAP-000-TEMPLATE.md` — the copy source; keep it, do not repurpose it.
- **Generated:** none.
- Maps are named `MAP-<TRACK>.md`, with `<TRACK>` in `SCREAMING-KEBAB-CASE` naming a track or
  phase (for example `MAP-C-FOUNDATIONS.md` or `MAP-KERNEL-INTERNALS.md`).
- **Map status words** (this folder owns them; a map's own lifecycle, never a milestone status):
  `Charting` · `Resolving` · `Blockers clear — milestones may be cut` · `Complete`.
- Node IDs `N-###` are scoped per map; a cross-map dependency is written with the map name
  (`N-004 on MAP-<TRACK>`). Slice IDs are `S-##`; milestones `MS###`; dates DD/MM/YYYY.
