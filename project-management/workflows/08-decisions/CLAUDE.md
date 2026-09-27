@./CONTEXT.md

# CLAUDE.md — project-management/workflows/08-decisions/

Read order: `.claude/CLAUDE.md` → `.claude/MEMORY.md` → this folder's `CONTEXT.md` (when to use, key
concepts, governing documents — imported above) → this file → `STEPS.md` then `CHECKLIST.md`.

## Purpose (one line)

Record each hard-to-reverse choice as an immutable five-section ADR when it surfaces, and act as the
per-milestone coherence gate that confirms the ADR set still holds and does not clash.

## How to work here

- **Routing:** run `STEPS.md` in order against `CHECKLIST.md`. Read
  `project-management/src/08-DECISIONS/CLAUDE.md` and `ADR-MS000-TEMPLATE.md` before Step 1. Load
  `.claude/skills/research/SKILL.md` (`/research <question>`) when an option rests on a claim that a
  primary source could settle.
- **Concrete steps:** the learner states the decision question → list the milestone's ADRs → check each
  still holds → check no two clash → confirm each gap is ADR-worthy → research the contested options →
  copy the template → write Context, Options, Decision, Consequences → supersede with two-way links →
  learner signs off, Status to `Accepted` → cross-link → commit by explicit path.
- **Definition of done:** every hard-to-reverse choice the milestone made is recorded; every record has
  all five sections; no two Accepted ADRs contradict each other; every supersession is linked both ways
  by full filename; `CHECKLIST.md` is fully ticked.

## Guardrails

- **Edit an Accepted ADR only to mark it superseded.** The Status flip and the "Superseded by" link are
  the whole of the permitted change; anything else hides that the reasoning moved.
- **Resolve a clash forward.** When two ADRs disagree, write a new record that supersedes the loser;
  never reconcile them by editing either.
- **Write the ADR when the decision surfaces.** Reasoning reconstructed at the end of a milestone is
  reasoning half-remembered.
- **Let the learner make the call.** Claude lays out options and trade-offs and asks which way the
  learner leans and why; the Decision section records the learner's deciding factor, not Claude's.
- **Keep enforcement out of the ADR.** The Follow-on consequence names where the rule will be enforced
  (a flag, a lint, a guide); the change itself happens in that file, in its own commit.
- **Cite a primary source for every contested claim.** Link the research note or the upstream
  documentation; do not paste copyrighted text.

## Output & naming

- **Writes:** `project-management/src/08-DECISIONS/ADR-MS###-<DECISION>-DD-MM-YYYY.md`, flat, one decision
  per file; plus the "Superseded by" edit on any record it replaces.
- `MS###` is the driving milestone; `<DECISION>` is SCREAMING-KEBAB-CASE; the date is the day the
  decision was made, DD-MM-YYYY in the filename and DD/MM/YYYY in prose.
- The folder's `CLAUDE.md` → Output & naming owns the pattern; this file only repeats it.
- Commit scope `pm`, per `project-management/docs/git/COMMITS.md`.
