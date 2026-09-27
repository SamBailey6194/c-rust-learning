@./CONTEXT.md

# CLAUDE.md — code/workflows/05-review/

Read order: `.claude/CLAUDE.md` → `.claude/MEMORY.md` → this folder's `CONTEXT.md` (the two axes, the five
dimensions, point-don't-rewrite — imported above) → this file → `STEPS.md` then `CHECKLIST.md`.

## Purpose (one line)

Review finished C or Rust code against its spec and `code/docs/` on five dimensions, and record the
findings as a `REVIEW-MS###-<DESC>.md` the learner acts on.

## How to work here

- **Routing:** run `STEPS.md` in order against `CHECKLIST.md`. A finding that is a bug goes to
  `code/workflows/07-debug/`; one that is structure goes to `code/workflows/08-refactor/`; a memory-tool
  failure goes back to `code/workflows/06-memory-check/`.
- **Tutor mode:** ask the learner first what they think the weakest part of the code is. Each finding
  cites the `code/docs/` section that decides it and asks a question that leads to the fix; do not rewrite
  the learner's code in the review, and give a corrected snippet only when explicitly asked.
- **Concrete steps:** confirm the baseline is green → fix the scope and read the spec → review the Spec
  axis → review the five Standards dimensions in order → write the findings → write the REVIEW record →
  hand the findings to the learner and re-review what changed.
- **Definition of done:** both axes reviewed; every finding has a location, dimension, doc reference and
  severity; the REVIEW record exists; every blocking finding is resolved and re-checked, or explicitly
  accepted with a reason.

## Guardrails

- **Review only against a green baseline.** A review of code that fails its own tests or memory tools
  reviews the wrong thing; send it back first.
- **Point at the doc, not at a rewrite.** Findings cite `code/docs/` by path and section; the learner
  makes the change.
- **Report the axes separately.** A clean Standards pass never hides a Spec failure, or the reverse.
- **Judge against written standards.** A preference with no `code/docs/` section behind it is a
  suggestion, labelled as one — or a gap in the docs, raised as such.
- **Verify through the scripts.** Claude's baseline check runs `code/src/scripts/`, and a gate that could
  not run is reported as COULD NOT RUN, never as clean.

## Output & naming

- **Writes:** `project-management/src/11-REVIEWS/REVIEW-MS###-<DESC>.md`, copied from
  `REVIEW-MS000-TEMPLATE.md`; `MS###` is the milestone the code belongs to and `<DESC>` a
  SCREAMING-KEBAB-CASE name for what was reviewed (a review spanning several milestones uses
  `REVIEW-<DESC>-DD-MM-YYYY.md`). That folder's `CONTEXT.md` owns the pattern.
- Review notes never go into `code/src/`; the code changes are the learner's, made in the fixing workflow.
- Commit the record with scope `pm` (`project-management/docs/git/COMMITS.md`).
- Workflow files `SCREAMING-SNAKE-CASE.md`, frontmatter `workflow: 05-review`, `phase: verify`.
