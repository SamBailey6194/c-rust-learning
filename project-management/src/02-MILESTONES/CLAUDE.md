@./CONTEXT.md

# CLAUDE.md — project-management/src/02-MILESTONES/

Read order: `.claude/CLAUDE.md` → `.claude/MEMORY.md` → this folder's `CONTEXT.md` (what a milestone
records and how it connects — imported above) → this file →
`project-management/docs/planning/MILESTONES.md`.

## Purpose (one line)

The milestone store — one `MS###-<TITLE>.md` per provable learning concept, each with flags, a
learning story and Gherkin mastery criteria, plus the `MS000-TEMPLATE.md` scaffold.

## How to work here

- **Routing:** start from `project-management/workflows/02-milestone-creation/` (`STEPS.md` +
  `CHECKLIST.md`), which cuts a milestone from a resolved map slice. Admission to a sprint belongs
  to `project-management/workflows/03-sprint-planning/`; `project-management/workflows/11-verification/`
  sets `Verifying` and writes the `10-PROGRESS` record; `Completed` is set in the final branch commit
  of `project-management/workflows/13-pr-and-merge/` (Step 6), because it means merged with that
  record (`project-management/docs/planning/MILESTONES.md` → _Statuses_).
- **Concrete steps:** explain-first interview on the concept → copy `MS000-TEMPLATE.md` to the next
  free `MS###-<TITLE>.md` → fill Track, Phase and `Status: Open` → fill every FLAGS row (value or
  `N/A` with a reason) → write the learning story and mastery criteria with exact commands → set
  MoSCoW and points → cite dependencies and ADRs by full path → delete sections whose flag is
  `N/A` → back-fill the map slice's Milestone column → add the row to this folder's `CONTEXT.md`.
- **Definition of done:** named to the pattern below; all eleven flags filled; at least one
  scenario per running gate and one explain-back scenario; every command copy-pasteable from the
  repository root (or stating its directory); dependencies and ADRs cited by full path; British
  English; DD/MM/YYYY.

## Guardrails

- **Make every mastery criterion testable by an observer.** Name the command and the result; "I
  understand pointers" is not a criterion, "`make -C ... san` prints no `runtime error:` line" is.
- **Leave no FLAGS row blank.** `N/A` is a decision with a reason; a blank row skips a gate without
  anyone choosing to.
- **Never renumber or reuse an `MS###`.** The number is in branch names, commits, exercise
  directories and citations; a retired milestone keeps its number and its gap.
- **Change status only through the owning vocabulary.** The words and their transitions are owned
  by `project-management/docs/planning/MILESTONES.md`; `Completed` needs a verification record.
- **Keep solutions out.** A milestone says what must become true, never how the code does it; the
  code is the learner's, in `code/src/`.
- **Split rather than stretch.** 8 points is the largest milestone; 13 or more is an epic of several
  concepts and goes back to the map.
- **Keep changed wording visible.** When a mastery criterion is corrected after the milestone
  opens, leave the old wording in an HTML comment with the date and the reason.

## Output & naming

- **Hand-written:** every `MS###-<TITLE>.md`, and the milestone table in this folder's
  `CONTEXT.md`.
- **Template:** `MS000-TEMPLATE.md` — the copy source; keep it, do not repurpose it.
- **Generated:** none.
- Milestones are named `MS###-<SCREAMING-KEBAB-TITLE>.md`: three-digit zero-padded number, then a
  short title (`MS001-TOOLCHAIN-READY.md`). Numbers are allocated next-free in creation order; gaps
  stay gaps.
- Inside a milestone: dates DD/MM/YYYY; other artefacts cited by full repo-relative path in
  backticks.
