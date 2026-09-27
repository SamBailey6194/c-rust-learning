@./CONTEXT.md

# CLAUDE.md — project-management/workflows/02-milestone-creation/

Read order: `.claude/CLAUDE.md` → `.claude/MEMORY.md` → this folder's `CONTEXT.md` (when to use, key
concepts, governing documents — imported above) → this file → `STEPS.md` then `CHECKLIST.md`.

## Purpose (one line)

Cut one milestone from a resolved map slice: a learning story, eleven filled flags, Gherkin mastery
criteria naming real commands, a MoSCoW priority and a Fibonacci estimate, on its own branch.

## How to work here

- **Routing:** run `STEPS.md` in order against `CHECKLIST.md`. Read
  `project-management/docs/planning/MILESTONES.md` and `project-management/src/02-MILESTONES/CLAUDE.md`
  before Step 2; `MS001-TOOLCHAIN-READY.md` is the worked example.
- **Concrete steps:** Explain-first on the concept → load the slice row and parked topics → open the
  `ms###/` branch and copy the template to the next free number → header, why this matters, learning
  story → all eleven flags → mastery criteria with exact commands and an explain-back → MoSCoW and
  points → dependencies and decisions → back-fill the map and the folder's milestone table → commit.
- **Definition of done:** the milestone is named to the folder's pattern with `Status: Open`; every flag
  holds a value or `N/A` with a reason; every running gate has a scenario with a command, plus one
  explain-back; points are 8 or fewer, or the split is recorded; the map's slice names the `MS###`.

## Guardrails

- **Ask first, draft second.** The learner explains the concept and predicts the pitfalls before any
  criterion is written; what they cannot yet explain becomes a criterion. Criteria Claude writes alone
  test Claude's understanding, not the learner's.
- **Name the command and the result.** "I understand dynamic arrays" is not a criterion;
  `make -C code/src/c/ms007-dynamic-array memcheck` exiting `0` with `ERROR SUMMARY: 0 errors` is.
- **Leave no flag blank.** `N/A` is a decision with a reason; a blank row skips a gate without anyone
  choosing to.
- **Keep solutions out.** The milestone says what must become true, never how the code does it; the
  code is the learner's, written in `10-study-and-build`.
- **Split rather than stretch.** 8 points is the largest milestone; 13 or more goes back to
  `01-roadmap-map` as an epic, not forward to the sprint.
- **Never reuse or renumber an `MS###`.** Numbers are allocated next-free and gaps stay gaps.

## Output & naming

- **Writes:** one `project-management/src/02-MILESTONES/MS###-<SCREAMING-KEBAB-TITLE>.md` from
  `MS000-TEMPLATE.md`; its row in that folder's `CONTEXT.md`; the `MS###` in the map's slice row.
- The folder's `CLAUDE.md` → Output & naming owns the filename pattern; this file only repeats it.
- Branch `ms###/<short-kebab>` (`project-management/docs/git/BRANCHES.md`); commit scope `pm`; dates
  DD/MM/YYYY.
