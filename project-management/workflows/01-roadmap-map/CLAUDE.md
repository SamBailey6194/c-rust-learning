@./CONTEXT.md

# CLAUDE.md — project-management/workflows/01-roadmap-map/

Read order: `.claude/CLAUDE.md` → `.claude/MEMORY.md` → this folder's `CONTEXT.md` (when to use, node
types, chart versus resolve — imported above) → this file → `STEPS.md` then `CHECKLIST.md`.

## Purpose (one line)

Chart a phase's decision frontier with the learner, resolve its blocking nodes one per session, and cut
it into milestone slices, producing the `MAP-<TRACK>.md` every later workflow reads instead of re-asking.

## How to work here

- **Routing:** run `STEPS.md` in order against `CHECKLIST.md`. Read
  `project-management/src/01-ROADMAP/CLAUDE.md` and `MAP-000-TEMPLATE.md` before Step 1. Research nodes
  use `.claude/skills/research/SKILL.md` (`/research <question>`); a hard-to-reverse outcome goes to
  `project-management/workflows/08-decisions/`.
- **Concrete steps:** CHART (Explain-first on the whole track → read the phase row, the registers and
  the existing artefacts → pin the destination and out-of-scope → map the frontier breadth-first → wire
  blocking edges → write the map and its index row → fire research nodes, then stop) → RESOLVE (one node
  per later session, graduated to its real home, frontier redrawn) → CUT (fill the Slices table) → close
  out and commit. When a milestone completes, MOVE updates the roadmap marker in the same final commit.
- **Definition of done:** destination and out-of-scope agreed with the learner; every knowable decision
  is a node or honestly in fog of war; no blocking node open; every resolved node links to what it
  became; every slice has nodes, mastery and flags and no reserved `MS###`; the map index row is current.

## Guardrails

- **Ask before charting.** The learner says what they already know about the track and what they
  expect to be hard; both go into the map's Notes. A frontier Claude charts alone is Claude's idea of
  what is hard, not the learner's.
- **Settle nothing but research nodes while charting.** The temptation is to answer a node while it is
  in front of you; a frontier drawn and a frontier resolved are different acts.
- **Look facts up; put only genuine choices to the learner.** A question the repository, a man page or
  the roadmap can answer is not a decision node.
- **Keep the map an index.** A node's reasoning lives in the ADR, milestone or research note it
  graduates to; do not grow it on the map.
- **Do not write milestones here.** A slice gets a row with its flag manifest, never an `MS###.md` and
  never a reserved number; `02-milestone-creation` allocates numbers.
- **Claim register entries; never close them.** The map records which `GAPS.md` and `DEFERRED.md`
  entries the track will retire; marking one closed happens against verified work.
- **Move the "You are here" marker only on evidence** — a verification record in
  `project-management/src/10-PROGRESS/` and a merged milestone, or a passed phase exit gate.
- **Change a phase's scope or exit gate the way `ROADMAP.md` → _Changing the roadmap_ says**, keeping
  the old wording in an HTML comment; reordering, adding or dropping a phase is an ADR first.

## Output & naming

- **Writes:** `project-management/src/01-ROADMAP/MAP-<TRACK>.md` from `MAP-000-TEMPLATE.md`, its row in
  `project-management/src/01-ROADMAP/CONTEXT.md` → Map index, and edits to `ROADMAP.md`.
- **Produced by following it:** research notes in `research/`, ADRs through `08-decisions`, `GAPS.md`
  and `DEFERRED.md` entries for blockers and parked topics.
- The folder's `CLAUDE.md` → Output & naming owns the map filename and the `N-###` / `S-##` ID rules.
- Commit scope `pm` on a `pm/<desc>` branch (`project-management/docs/git/BRANCHES.md`); dates
  DD/MM/YYYY.
