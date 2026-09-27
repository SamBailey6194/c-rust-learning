---
workflow: 12-review-and-reflect
phase: record
skills: []
---

# Review and Reflect — Steps

**Last Updated**: 27/09/2026 | **Version**: 0.1.0 | **Maintained By**: Sam Bailey
**Language**: British English (en_GB) | **Timezone**: Europe/London

---

## Key references

Consult `project-management/REFERENCES.md` → **External — Verification & Safety** (undefined behaviour in C,
the Rustonomicon) as you work through these steps:

| Step | Section |
| --- | --- |
| 2, 3 | `code/workflows/05-review/` — the content review; `project-management/src/11-REVIEWS/CLAUDE.md` — the record |
| 4 | `code/workflows/07-debug/` · `code/workflows/08-refactor/` — where required actions go |
| 5 | `project-management/docs/SAFETY-GUIDE.md` — undefined behaviour and memory-bug classes to name |
| 6 | `project-management/src/12-FINDINGS/FINDING-MS000-TEMPLATE.md` — the finding scaffold |
| 7 | `GAPS.md` · `DEFERRED.md` · `.claude/MEMORY.md` — the three registers |
| 8 | `project-management/docs/planning/SPRINTS.md` — _The Retrospective_ and _Sprint statuses_ |

---

## Steps

### Step 1 — Explain first: the learner reviews their own code

Explain-first (`project-management/workflows/CONTEXT.md` → _Explain-first_): before any review runs, ask
the learner to name the three places in the milestone's code they are least sure of, and why. Note the
list; Step 3 compares it with what the review finds.

_Done when the learner's list of three is recorded._

### Step 2 — Run the content review

Run `code/workflows/05-review/` over everything the milestone changed:

```bash
git log --oneline main..HEAD          # the milestone's commits
git diff --stat main...HEAD           # every file changed since the branch left main
git diff main...HEAD -- code/src/     # the code itself, for the review
```

The review reads the code against `code/docs/` and writes its record into
`project-management/src/11-REVIEWS/`, copied from `REVIEW-MS000-TEMPLATE.md`.

_Done when the review has covered every changed file under `code/src/` and its record exists._

### Step 3 — Confirm the review record

Read the record through. Every dimension the template lists is filled; every finding names the
`code/docs/` section that applies; every required action has a destination. Compare the review's findings
with the learner's list from Step 1: a problem the review found that the learner did not suspect is a
candidate misconception for Step 5.

_Done when the record is complete and the comparison with the learner's list is noted._

### Step 4 — Resolve or route the required actions

Each required action goes one way:

1. a change in behaviour (a wrong result, a leak, UB) → `code/workflows/07-debug/`, with a record in
   `project-management/src/13-BUGS/` where the bug earns one
2. a behaviour-preserving improvement → `code/workflows/08-refactor/`
3. a topic that belongs to a later phase → `DEFERRED.md` with a `DEFERRED (MS###)` marker

The learner makes the changes. Any change to code sends the milestone back through
`project-management/workflows/11-verification/` from its first step, because a partial rerun proves only
the part that was rerun; the verification record is updated to match.

_Done when every required action is resolved or routed, and anything re-verified is recorded as such._

### Step 5 — Gather the misconceptions

Collect what the milestone corrected, from:

- the misconceptions logged in the journal of each `learning/<track>-NN-<topic>/PROGRESS.md` the
  milestone touched
- the bug records the milestone produced in `project-management/src/13-BUGS/`
- the review's findings, and the gap noted at Step 3
- the learner's prediction at `11-verification` Step 1 against what actually failed

For each one, write what was believed, what is true, and the source that settles it.

_Done when every candidate misconception has a belief, a correction and a source._

### Step 6 — Write the finding record

Copy `FINDING-MS000-TEMPLATE.md` into `project-management/src/12-FINDINGS/`, named as that folder's
`CLAUDE.md` → Output & naming sets out, and fill it:

1. **Misconceptions corrected** — from Step 5.
2. **Expensive to relearn** — the misconceptions that compound: a wrong model that later exercises would
   build on (object lifetimes, aliasing, ownership, what "undefined" permits the compiler to do).
3. **Carried into the next milestone** — what the next plan has to account for, as a risk or an
   Explain-first question.

Write it even when little went wrong; say so, and say what the evidence was.

_Done when the finding record is complete, links its milestone, plan, review and verification record,
and no `{PLACEHOLDER}` remains._

### Step 7 — Route to the registers and schedule re-drills

- A blocker the milestone exposed → `GAPS.md`, newest first, with its Type and Action.
- A topic deliberately parked → `DEFERRED.md` with a `DEFERRED (MS###)` marker.
- A durable pattern about how sessions work best, or feedback on how Claude should tutor →
  `.claude/MEMORY.md`, one short paragraph.
- Every expensive-to-relearn item → a review-queue row in its topic's `PROGRESS.md`, due in a day
  (`.claude/skills/teach/SKILL.md` sets the curve), so spaced review keeps testing it.

_Done when each item sits in exactly one register and every expensive item has a re-drill date._

### Step 8 — Write the Retrospective when the sprint closes

When a sprint closes is owned by `project-management/docs/planning/SPRINTS.md` → _Sprint statuses_. If
this milestone is the last member of a `Full` sprint, or the two weeks are up while it is `Verifying`, the
sprint closes after its merge: draft What stuck, What did not and One change now, while they are fresh. Velocity and
Carried over count `Completed` points, so they are filled after `13-pr-and-merge` has merged the milestone, on
a `pm/<desc>` branch (`project-management/docs/git/BRANCHES.md`); the sprint is then set to `Closed`. After
the second Retrospective, compare velocity with the capacity figure in
`project-management/docs/planning/CADENCE.md`.

_Done when a closing sprint has all five Retrospective answers, or the draft is in place awaiting the
merge._

### Step 9 — Commit by explicit path

```bash
git add project-management/src/11-REVIEWS/REVIEW-MS###-<DESCRIPTOR>.md \
        project-management/src/12-FINDINGS/FINDING-MS###-<DESCRIPTOR>-DD-MM-YYYY.md \
        GAPS.md DEFERRED.md
git commit -m "docs(pm): review and findings for MS###"
```

Stage only the files this workflow changed; the sprint record joins the commit when Step 8 touched it.

_Done when `git status` shows nothing from this workflow left uncommitted._

---

## Update context files

If this workflow created files or folders, or settled a new convention:

1. Add every new file or folder to the directory tree in the nearest `CONTEXT.md`.
2. Add any new artefact type or external source to `project-management/REFERENCES.md`.
3. Refresh `**Last Updated**` in every `CONTEXT.md` you modified.
4. If the session ends before Completion, run `/handoff` to write
   `handoffs/HANDOFF-<SCREAMING-KEBAB-DESCRIPTOR>-DD-MM-YYYY.md`.

---

## Completion

Run through `CHECKLIST.md` before marking this workflow complete.
