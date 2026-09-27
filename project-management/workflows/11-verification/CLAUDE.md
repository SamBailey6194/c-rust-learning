@./CONTEXT.md

# CLAUDE.md — project-management/workflows/11-verification/

Read order: `.claude/CLAUDE.md` → `.claude/MEMORY.md` → this folder's `CONTEXT.md` (when to use, the
contract, the record — imported above) → this file → `STEPS.md` then `CHECKLIST.md` →
`project-management/docs/VERIFICATION-GUIDE.md`.

## Purpose (one line)

Run the milestone's mastery-criteria commands against the committed code and write
`project-management/src/10-PROGRESS/MS###-VERIFICATION.md` with the results, how to reproduce them, the
gaps, and the status that follows.

## How to work here

- **Routing:** run `STEPS.md` in order against `CHECKLIST.md`. Read
  `project-management/docs/VERIFICATION-GUIDE.md` and `project-management/src/10-PROGRESS/CLAUDE.md`
  before Step 1. Memory checks follow `code/workflows/06-memory-check/`; the gate suite follows
  `how-to/workflows/03-quality-gates/`.
- **Concrete steps:** the learner predicts the weakest criterion, status to `Verifying`, committed →
  record the toolchain → confirm a clean, committed tree → run each flagged check raw, then through its script →
  run the explain-back scenario → run `gates/all.sh` → write the record → fill the plan's As-Built
  summary → settle the outcome (stay `Verifying`, or back to `In Progress`) and, on a pass, move each
  checked record's own status → commit.
- **Definition of done:** every mastery criterion has a recorded result with the exact command and its
  evidence; every flagged check ran; the record states how to reproduce each result and every gap; the
  milestone's Status matches `project-management/docs/planning/MILESTONES.md` → _Statuses_.

## Guardrails

- **Verify committed code, not the working copy.** Run from a tree where `git status --short` prints
  nothing, so the record describes something another checkout can reproduce.
- **Record the command with the result.** A pass without its exact command line is an opinion; paste the
  command and the line of output that proves it.
- **Treat exit 2 as a gap, never as a pass.** A tool that could not run proves nothing; record it in
  Outstanding gaps and in `GAPS.md`.
- **Fix nothing inside this workflow.** A failure sends the milestone back to `In Progress` and
  `10-study-and-build` (or `code/workflows/07-debug/`); verification then starts again from Step 1.
- **Leave `Completed` to `13-pr-and-merge`.** `Completed` needs the merge to `main` as well as this
  record; this workflow ends at `Verifying` at the latest.
- **Boot kernels in QEMU only.** A QEMU-flagged check never touches the host's own kernel or modules
  (`.claude/CLAUDE.md` owns the rule).

## Output & naming

- **Writes:** `project-management/src/10-PROGRESS/MS###-VERIFICATION.md` from
  `MS000-VERIFICATION-TEMPLATE.md`; the As-Built summary of the milestone's plan in
  `project-management/src/09-MILESTONE-PLANS/`; the Status line of the milestone file; on a pass, the
  status of the `KERNEL-IMPL` record, the `EX-`/`PROJ-` spec and, at P6, the profile file it checked.
- The folder's `CLAUDE.md` → Output & naming owns the filename pattern; dates DD/MM/YYYY in prose.
- Gaps go to `GAPS.md`; deferrals go to `DEFERRED.md` with a `DEFERRED (MS###)` marker.
- Commit scope `pm`, per `project-management/docs/git/COMMITS.md`.
