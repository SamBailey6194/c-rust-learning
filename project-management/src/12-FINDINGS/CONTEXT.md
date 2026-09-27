# project-management/src/12-FINDINGS/ — Findings

**Last Updated**: 27/09/2026

Findings records — one per milestone, written as it closes, recording what the milestone corrected in
the learner's understanding. Each finding sets what was believed beside what is true and the source or
evidence that settles it, marks whether the wrong model would be expensive to relearn, and says what the
next milestone carries forward. A review asks whether one milestone's code is fit to merge and closes with
the pull request; a finding outlives the milestone, because it shapes the next plan and the spaced review
that keeps the correction from slipping back.

## Directory Tree

```text
project-management/src/12-FINDINGS/
├── CONTEXT.md · CLAUDE.md                ← orientation · operating rules for this folder
├── FINDING-MS000-TEMPLATE.md             ← copy source for every findings record
├── FINDING-MS###-<DESC>-DD-MM-YYYY.md    ← one record per milestone, dated the day it closed
└── FINDING-<DESC>-DD-MM-YYYY.md          ← findings not tied to one milestone (a sprint Retrospective)
```

No findings record exists yet; the first is written when MS001 closes.

## How it differs from its neighbours

| Folder | Answers |
| --- | --- |
| `project-management/src/11-REVIEWS/` | Is this milestone's code fit to merge? |
| `project-management/src/12-FINDINGS/` | What did this milestone correct in my understanding, and what carries forward? |
| `project-management/src/13-BUGS/` | What was broken, why, and which test keeps it fixed? |

## What each record holds

| Section | Holds |
| --- | --- |
| **Header table** | Milestone, plan, verification record, review, date recorded, outcome |
| **1. Scope** | Where the findings were gathered: learning notes, bugs, the review, predictions against outcomes |
| **2. Findings** | `F-0NN` rows: what was believed, what is true, the source that settles it, relearn cost, disposition |
| **3. Expensive to relearn** | The wrong models later work would build on, each with a re-drill date |
| **4. Carried into the next milestone** | Each finding restated as work for the next plan |
| **5. Notes** | The learner's prediction against the outcome; models confirmed rather than corrected |

A record is written even when little went wrong, saying so and naming the evidence, because a missing
file cannot be told apart from a skipped step.

## Where it sits

Written by `project-management/workflows/12-review-and-reflect/`, after the review in
`project-management/src/11-REVIEWS/` and before the pull request. Its dispositions route each finding to
exactly one home: the next plan in `project-management/src/09-MILESTONE-PLANS/`, a re-drill in
`learning/`, `DEFERRED.md`, `GAPS.md`, `.claude/MEMORY.md`, a bug record, or a new ADR. A real
misconception raised in a sprint Retrospective (`project-management/src/03-STUDY-SPRINTS/`) is recorded
here too.

## Cross-references

- `project-management/workflows/12-review-and-reflect/` — the procedure that writes these records
- `project-management/src/11-REVIEWS/` — the review a record draws on
- `project-management/src/13-BUGS/` — defects whose root cause was a misconception
- `project-management/src/09-MILESTONE-PLANS/` — where Section 4 is picked up
- `project-management/docs/SAFETY-GUIDE.md` — the undefined-behaviour and memory-bug classes findings name
- `learning/` — topic notes, misconception logs and re-drill dates
