---
workflow: 02-milestone-creation
phase: plan
skills: []
---

# Milestone Creation — Steps

**Last Updated**: 27/09/2026 | **Version**: 0.1.0 | **Maintained By**: Sam Bailey
**Language**: British English (en_GB) | **Timezone**: Europe/London

---

## Key references

Consult `project-management/REFERENCES.md` (Connextra, Gherkin, MoSCoW, Fibonacci; each defined in plain
words in `project-management/CONTEXT.md` → _Glossary_) as you work through these steps:

| Step | Section |
| --- | --- |
| 1 | `project-management/src/01-ROADMAP/` — the map and the slice row this milestone is cut from |
| 1 | `DEFERRED.md` — `DEFERRED (MS###)` topics parked for this phase |
| 2 | `project-management/src/02-MILESTONES/CLAUDE.md` — naming; `MS000-TEMPLATE.md` — the scaffold |
| 2 | `project-management/docs/git/BRANCHES.md` — the `ms###/<short-kebab>` branch |
| 4 | `project-management/docs/planning/MILESTONES.md` → _The FLAGS table_ |
| 5 | `project-management/docs/planning/MILESTONES.md` → _Mastery criteria_; `code/docs/BUILD.md` — targets |
| 5 | `project-management/docs/VERIFICATION-GUIDE.md` → _The commands, by flag_ |
| 6 | `project-management/docs/planning/MILESTONES.md` → _MoSCoW_ and _Estimation_ |
| 8 | `project-management/docs/git/COMMITS.md` — scope `pm`, staging by explicit path |

---

## Steps

### Step 1 — Explain-first, then load the slice

Before opening the template, run the three moves with the learner on this slice's concept
(`project-management/workflows/CONTEXT.md` → _Explain-first_): what they already know about it, where
they predict it will go wrong, and the concept explained back in their own words. Write the answers down;
the gaps in the explanation are the first draft of the mastery criteria.

Then open the track's map and read this slice's row: title, nodes (all resolved), what must be true, and
the flag manifest. Check `DEFERRED.md` for topics parked until this phase that belong in this milestone.

_Done when the learner's three answers are recorded and the slice row is in view with every node
resolved._

### Step 2 — Open the branch and copy the template

Find the next free number (`ls project-management/src/02-MILESTONES/`; gaps stay gaps), then open the
milestone's branch from an up-to-date `main` and copy the template:

```bash
git switch main && git pull --ff-only
git switch -c ms007/dynamic-array
cp project-management/src/02-MILESTONES/MS000-TEMPLATE.md \
   project-management/src/02-MILESTONES/MS007-DYNAMIC-ARRAY.md
```

_Done when the milestone file exists on its own `ms###/` branch under the folder's naming pattern._

### Step 3 — Write the header and the learning story

Fill **Track** (a milestone that genuinely spans two tracks, such as an FFI milestone, names both),
**Phase** (cited from `ROADMAP.md`) and `Status: Open`. Write **Why this matters** in two or three
sentences: where the milestone sits on the road to the phase exit gate, and what would fail later
without it. Then the learning story:

```text
As a learner, I want to build a growable array in C with explicit capacity management,
so that the P2 allocator and shell projects can store unbounded input safely.
```

_Done when the "so that" names something concrete a later milestone or phase depends on._

### Step 4 — Fill all eleven flags

Transcribe the slice's flag manifest into the FLAGS table, then fill every remaining row with a value or
`N/A` and a reason. The value is a first-pass manifest (which exercise, which command); the gate it
opens owns the design and may add to it. Allocating C code sets **Memory**; non-trivial control flow sets
**Lint**; anything touching a kernel sets **Kernel** and **QEMU**
(`project-management/docs/SAFETY-GUIDE.md`).

_Done when all eleven rows carry a value or a deliberate `N/A` with its reason._

### Step 5 — Write the mastery criteria

For every flag that runs a command, write a Gherkin scenario that names the exact command and the exact
result, run from the repository root:

```gherkin
Scenario: The exercise suite passes and memcheck is clean
  Given the exercise in code/src/c/ms007-dynamic-array
  When I run make -C code/src/c/ms007-dynamic-array test
  Then every test binary exits 0 and reports no failed checks
  And make -C code/src/c/ms007-dynamic-array memcheck reports 0 errors
```

Add at least one explain-back scenario built from the Step 1 gaps: the question, asked with no notes
open, and what a good answer has to name. Check each command against `code/docs/BUILD.md` and what it
prints when clean against `project-management/docs/VERIFICATION-GUIDE.md`; a criterion that names a
target that does not exist can never pass.

_Done when every running flag has a scenario with a real command and a stated result, and one scenario
is an explain-back._

### Step 6 — Set MoSCoW and points

Ask the learner for the estimate first, then compare it with the anchors in
`project-management/docs/planning/MILESTONES.md` → _Estimation_. 8 is the largest milestone: an estimate
of 13 or more is an epic of several concepts, so go back to the map's slice in `01-roadmap-map` and split
it along a concept seam. Set MoSCoW by what depends on the milestone, and avoid a run where every
milestone is **Must**.

_Done when the points are 8 or fewer (or the split is recorded on the map) and MoSCoW is set._

### Step 7 — Record dependencies and decisions

List every milestone that has to be `Completed` first, with the reason. List every ADR the milestone
rests on by full path; a hard-to-reverse choice the milestone raises goes to
`project-management/workflows/08-decisions/` now, while it is fresh. Write "None" with a reason where a
section is genuinely empty, and delete every template section whose flag is `N/A`.

_Done when dependencies and decisions are complete and no `[PLACEHOLDER]` or `[EXAMPLE]` row remains._

### Step 8 — Back-fill the map and commit by explicit path

Write the new `MS###` into the slice's Milestone column on the map, and add the milestone's row to
`project-management/src/02-MILESTONES/CONTEXT.md`. Then commit on the milestone branch:

```bash
git add project-management/src/02-MILESTONES/MS007-DYNAMIC-ARRAY.md \
        project-management/src/02-MILESTONES/CONTEXT.md \
        project-management/src/01-ROADMAP/MAP-C-SYSTEMS.md
git commit -m "docs(pm): add MS007 dynamic array milestone"
```

_Done when the map, the folder index and the milestone agree, and `git status` is clean._

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

Run through `CHECKLIST.md` before marking this workflow complete. Next:
`project-management/workflows/03-sprint-planning/`.
