# project-management/src/11-REVIEWS/ — Review Records

**Last Updated**: 27/09/2026

Review records — one per milestone, capturing what a code review found in the code the milestone built.
A green test run says the code does what the tests ask; a review asks what the tests did not: the case
nobody wrote a test for, the error path that leaks, the style that will not survive the kernel phase.
Each record reads the code on two axes — against its spec, and against the written standards in
`code/docs/` — and writes the findings down so the lesson outlives the session and can be distilled into
findings when the milestone closes.

## Directory Tree

```text
project-management/src/11-REVIEWS/
├── CONTEXT.md · CLAUDE.md          ← orientation · operating rules for this folder
├── REVIEW-MS000-TEMPLATE.md        ← copy source for every review record
├── REVIEW-MS###-<DESC>.md          ← one record per milestone's code review
└── REVIEW-<DESC>-DD-MM-YYYY.md     ← a review not tied to one milestone (a sweep of several exercises)
```

No review exists yet; the first is written when MS001's code is reviewed.

## What each record holds

| Section | Holds |
| --- | --- |
| **Header table** | Milestone, plan, spec, branch and PR, reviewer, date, verdict |
| **1. Scope** | The green baseline, the learner's own concern, the files reviewed |
| **2. Spec axis** | Each spec case with the test that pins it and the code that satisfies it |
| **3. Findings** | `R-0NN` rows: severity, `file:line`, dimension, the `code/docs/` section, a leading question, resolution |
| **4. Standards checklists** | Memory safety and UB, error handling, idiomatic style, test quality, readability |
| **5. Required actions** | Each blocking action with its route: debug, refactor or a later milestone |
| **6. Verdict** | Approve, approve with follow-ups, or changes requested — and any re-review |
| **7. Notes** | The learner's concern set against the findings: where misconceptions show up |

The five dimensions and the order they are read in come from `code/workflows/05-review/`; each dimension's
rules live in the `code/docs/` guide the checklist names.

## Where it sits

A review is written by `code/workflows/05-review/`, run inside
`project-management/workflows/12-review-and-reflect/` after the milestone's verification record exists in
`project-management/src/10-PROGRESS/`, and before the pull request at
`project-management/workflows/13-pr-and-merge/`. Its findings travel on: behaviour defects to
`code/workflows/07-debug/` and `project-management/src/13-BUGS/`, restructuring to
`code/workflows/08-refactor/`, and the misconceptions behind them to `project-management/src/12-FINDINGS/`.

## Cross-references

- `code/workflows/05-review/` — the procedure that writes these records
- `project-management/workflows/12-review-and-reflect/` — the milestone step that runs the review
- `code/docs/MEMORY-SAFETY.md` · `code/docs/TESTING.md` · `code/docs/CODING-PRINCIPLES.md` — the standards
  checked, with `code/docs/C-CODING-PRINCIPLES.md` and `code/docs/RUST-CODING-PRINCIPLES.md`
- `project-management/src/10-PROGRESS/` — the baseline a review starts from
- `project-management/src/12-FINDINGS/` — where patterns from reviews are distilled
- `project-management/src/13-BUGS/` — where a blocking defect is recorded
