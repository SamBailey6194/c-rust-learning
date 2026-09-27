@./CONTEXT.md

# CLAUDE.md — project-management/src/11-REVIEWS/

Read order: `.claude/CLAUDE.md` → `.claude/MEMORY.md` → this folder's `CONTEXT.md` (what a record holds
and where it sits — imported above) → this file → `code/workflows/05-review/STEPS.md`.

## Purpose (one line)

The review store — one `REVIEW-MS###-<DESCRIPTOR>.md` per milestone's code review, recording the spec
axis, the findings against `code/docs/`, the required actions and the verdict.

## How to work here

- **Routing:** reviews are carried out by `code/workflows/05-review/` and run as part of
  `project-management/workflows/12-review-and-reflect/`. Fixes route onwards: behaviour to
  `code/workflows/07-debug/`, structure to `code/workflows/08-refactor/`.
- **Concrete steps:** confirm the baseline is green → ask the learner which part they are least sure of
  → copy `REVIEW-MS000-TEMPLATE.md` to the name below → fill the scope → work the spec axis case by case
  → work the five dimensions in order → write each finding as file:line, dimension, guide section,
  severity and a question → list the required actions with routes → set the verdict → after fixes,
  re-review the changed lines and record it.
- **Definition of done:** every spec case marked covered, covered-untested or missing; all five
  checklists worked, with `N/A` items explained; every finding names its guide section (or is marked a
  suggestion) and has a resolution; every Blocking finding resolved and re-checked before merge; the
  verdict matches the findings; British English; dates DD/MM/YYYY.

## Guardrails

- **Point at the guide; never rewrite the learner's code.** A finding names the `code/docs/` section and
  asks the question that leads to the fix. A reviewer's rewrite teaches the reviewer; tutor mode applies
  here as it does in `code/`.
- **Cite a written standard, or call it a suggestion.** A rule that no guide states is not enforced by a
  review; if it ought to exist, raise a `GAPS.md` entry.
- **Start from green.** A review runs on code whose gates already pass; a red gate goes back to the
  building or debugging workflow first.
- **Keep the two axes separate.** Passing the spec does not excuse a standards failure, and clean style
  does not excuse a missing spec case.
- **Let Changes requested block the merge.** No pull request merges while a Blocking action is open; any
  code change sends the milestone back through `project-management/workflows/11-verification/`.
- **Record only; fix elsewhere.** This folder holds the findings. The code changes land in `code/src/`,
  bugs in `project-management/src/13-BUGS/`, lessons in `project-management/src/12-FINDINGS/`.

## Output & naming

- **Hand-written:** every `REVIEW-*.md`, copied from the template.
- **Template:** `REVIEW-MS000-TEMPLATE.md` — the copy source; keep it, never fill it in or rename it.
- **Generated:** none.
- Milestone reviews `REVIEW-MS###-<DESCRIPTOR>.md`: the milestone number, three digits, then a
  SCREAMING-KEBAB-CASE descriptor, normally the milestone's title; no date, as a later re-review updates
  the same record.
- Reviews not tied to one milestone (a sweep across several exercises): `REVIEW-<DESCRIPTOR>-DD-MM-YYYY.md`,
  with the milestone rows of the header marked `N/A — cross-cutting`.
- Findings inside a record: `R-001`, `R-002`, ... never reused within the record.
- **Verdict words** (this folder owns them; a review's own lifecycle, never a milestone status):
  `Approve` · `Approve with follow-ups` · `Changes requested`.
