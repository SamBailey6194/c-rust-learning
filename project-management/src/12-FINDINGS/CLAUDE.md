@./CONTEXT.md

# CLAUDE.md — project-management/src/12-FINDINGS/

Read order: `.claude/CLAUDE.md` → `.claude/MEMORY.md` → this folder's `CONTEXT.md` (what a record holds,
how it differs from reviews and bugs — imported above) → this file →
`project-management/workflows/12-review-and-reflect/STEPS.md`.

## Purpose (one line)

The findings store — one `FINDING-MS###-<DESCRIPTOR>-DD-MM-YYYY.md` per milestone: misconceptions
corrected, the ones expensive to relearn, and what the next milestone carries forward.

## How to work here

- **Routing:** records are written by `project-management/workflows/12-review-and-reflect/`, after the
  milestone's review exists in `project-management/src/11-REVIEWS/`. A finding that reopens a decision
  goes to `project-management/workflows/08-decisions/`; one that is a defect goes to
  `code/workflows/07-debug/`.
- **Concrete steps:** gather candidates from the learning notes, bug records, review and predictions →
  for each, write the learner's belief, the truth and the source that settles it → mark the relearn
  cost → copy `FINDING-MS000-TEMPLATE.md` to the name below and fill it → repeat the Expensive rows with
  re-drill dates → restate carried rows as work for the next plan → route each disposition to its one
  home → add the re-drill entries to the topic's `PROGRESS.md`.
- **Definition of done:** named with the real date the reflection closed; every finding has a belief, a
  correction, a source, a relearn cost and a disposition; every Expensive row has a re-drill date; every
  carried row names its target; a `Nothing corrected` outcome is stated with its evidence; British
  English; dates DD/MM/YYYY.

## Guardrails

- **Record the learner's understanding, not Claude's.** "What I believed" is in the learner's own
  words; a finding written for them has proved nothing.
- **Settle every correction with a source.** A man page section, a guide, a standard draft, or
  reproducible output from gdb, valgrind or a sanitiser. Anything inferred rather than observed is
  marked `TODO(verify)`.
- **Record; never fix.** The fix for a defect lands in `code/src/` through `code/workflows/07-debug/`;
  a changed decision is a new ADR. This record points at them.
- **Separate expensive from cheap.** A wrong model that later work builds on is surfaced on its own and
  scheduled for re-drill; that split is what makes the record actionable.
- **Route each item to exactly one register.** Blockers → `GAPS.md`; parked topics → `DEFERRED.md`
  with a `DEFERRED (MS###)` marker; durable tutoring patterns → `.claude/MEMORY.md`. Never copy one item
  into two.
- **Never rename or back-date a filed record.** The date is when the reflection closed; a later
  correction is a new record that cites the old one.

## Output & naming

- **Hand-written:** every `FINDING-*.md`, copied from the template.
- **Template:** `FINDING-MS000-TEMPLATE.md` — the copy source; keep it, never fill it in or rename it.
- **Generated:** none.
- Milestone records `FINDING-MS###-<DESCRIPTOR>-DD-MM-YYYY.md`: the milestone number, three digits; a
  SCREAMING-KEBAB-CASE descriptor, normally the milestone's title; the date the reflection closed.
- Findings not tied to one milestone (a sprint Retrospective, a cross-milestone pattern):
  `FINDING-<DESCRIPTOR>-DD-MM-YYYY.md`, with the milestone rows of the header marked
  `N/A — cross-cutting`.
- Findings inside a record: `F-001`, `F-002`, ... never reused within the record.
