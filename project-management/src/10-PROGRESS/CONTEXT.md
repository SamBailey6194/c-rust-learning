# project-management/src/10-PROGRESS/ — Verification Records

**Last Updated**: 27/09/2026

Verification records — one per milestone, holding the evidence that its gates passed: the toolchain
that ran, every command with its exit code and pasted summary lines, the debugger or QEMU evidence where
the milestone asks for it, and the learner's explain-back. A passing test on a laptop is a claim; the
same result written down with the command that produced it is evidence that anyone can rerun. A
milestone reaches `Completed` only when one of these records exists and the work is merged.

## Directory Tree

```text
project-management/src/10-PROGRESS/
├── CONTEXT.md · CLAUDE.md          ← orientation · operating rules for this folder
├── MS000-VERIFICATION-TEMPLATE.md  ← copy source for every verification record
└── MS###-VERIFICATION.md           ← one record per milestone, the latest full run
```

No record exists yet; the first is MS001's, written when `project-management/workflows/11-verification/`
runs for `project-management/src/02-MILESTONES/MS001-TOOLCHAIN-READY.md`.

## What each record holds

| Section | Holds |
| --- | --- |
| **Header table** | Milestone, plan, branch, commit, date, and the milestone status the record supports |
| **1. What was verified** | The scope (exercises, crates, running flags) and the toolchain table from `toolchain/check.sh` |
| **2. Results** | Per gate: command, exit code, pasted evidence; skipped flags with reasons; per-binary memory evidence; gdb and QEMU evidence; the explain-back |
| **3. How to reproduce** | The commands, in order, from a clean checkout of the recorded commit |
| **4. Outstanding gaps** | Anything that failed, could not run or passed with a caveat, with its `GAPS.md` or `DEFERRED.md` entry |
| **5. Status line** | `Verifying`, `In Progress` or `Blocked`, in the words owned by the milestone status vocabulary |

What counts as proof, and what clean output looks like for each flag, is set out in
`project-management/docs/VERIFICATION-GUIDE.md`; the template points there rather than repeating it.

## Where it sits

This is the first record-tier folder. It is written by `project-management/workflows/11-verification/`
— the workflow and folder numbers differ from here on, as `project-management/REFERENCES.md` explains —
after `10-study-and-build` and before `12-review-and-reflect`. Writing the record also fills the
As-Built summary of the milestone's plan in `project-management/src/09-MILESTONE-PLANS/`. A failed gate
sends the milestone back to `In Progress`, often with a bug record in
`project-management/src/13-BUGS/`, and the whole verification runs again afterwards.

## Cross-references

- `project-management/workflows/11-verification/` — the procedure that writes these records
- `project-management/docs/VERIFICATION-GUIDE.md` — the three kinds of proof and clean output by flag
- `project-management/docs/planning/MILESTONES.md` — the status a record supports, and why `Completed`
  needs one
- `how-to/workflows/03-quality-gates/` — `gates/all.sh`, its order and its exit codes
- `code/workflows/06-memory-check/` — the sanitiser and valgrind procedure behind the Memory rows
- `project-management/src/09-MILESTONE-PLANS/` — the plan whose As-Built summary a record fills
- `project-management/src/11-REVIEWS/` · `project-management/src/12-FINDINGS/` — the records that follow
