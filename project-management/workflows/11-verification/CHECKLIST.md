---
workflow: 11-verification
phase: record
skills: []
---

# Verification — Checklist

**Last Updated**: 27/09/2026 | **Version**: 0.1.0 | **Maintained By**: Sam Bailey
**Language**: British English (en_GB) | **Timezone**: Europe/London

---

> **See** `project-management/docs/VERIFICATION-GUIDE.md` (what clean output looks like) ·
> `project-management/docs/planning/MILESTONES.md` (statuses, FLAGS) · `how-to/workflows/03-quality-gates/`
> (the gate suite) · `project-management/REFERENCES.md` for supporting references.

## Execution Checklist

### Step 1 — Explain first, then move the milestone to `Verifying`

- [ ] The learner's prediction of the weakest criterion is noted
- [ ] The milestone's Status reads `Verifying`, and it and the `ROADMAP.md` row are committed
- [ ] Every mastery criterion, plan command and non-`N/A` flag is on the list of checks

### Step 2 — Record the toolchain

- [ ] `bash code/src/scripts/toolchain/check.sh` exited 0 and its table is captured
- [ ] A missing tool (exit 2) was entered in `GAPS.md` and the milestone set to `Blocked`

### Step 3 — Start from a clean, committed tree

- [ ] `git status --short` printed nothing before any check ran
- [ ] `make -C code/src/c clean` ran first

### Step 4 — Run the Tests checks

- [ ] For a milestone whose Tests flag is not `N/A`: `make -C code/src/c test` and `cargo test` (run from
      `code/src/rust/`) exited 0, then their scripts did too
- [ ] Pass counts are captured

### Step 5 — Run the Memory checks

- [ ] For a milestone whose Memory flag is not `N/A`: `make san` exited 0 with no sanitiser report and no
      `runtime error:` line
- [ ] For a milestone whose Memory flag is not `N/A`: `make memcheck` exited 0 and each `ERROR SUMMARY`
      line is captured
- [ ] The sanitised and valgrind runs used separate builds (`build/san/` and `build/`)

### Step 6 — Run the Lint checks

- [ ] For a milestone whose Lint flag is not `N/A`: `make lint`, `cargo fmt --check` and
      `cargo clippy --all-targets -- -D warnings` exited 0

### Step 7 — Run the Debugger and QEMU checks

- [ ] For a milestone whose Debugger flag is not `N/A`: the gdb walkthrough is recorded with its commands
      and a transcript excerpt
- [ ] For a milestone whose QEMU flag is not `N/A`: the boot ran in QEMU and the proving console line is
      captured
- [ ] For a milestone whose Budget flag is not `N/A`: the measurement ran and its value against budget is
      recorded in section 2.7 (a value over budget fails the milestone)

### Step 8 — Run the explain-back scenario, then the full gate suite

- [ ] The learner explained the concept with no notes open, and the result is recorded against the
      scenario's `Then` clause
- [ ] `bash code/src/scripts/gates/all.sh` exited 0, or every non-zero row is explained in the record
- [ ] No exit 2 is recorded as a pass

### Step 9 — Write the verification record

- [ ] The record is `project-management/src/10-PROGRESS/MS###-VERIFICATION.md`, copied from the template
- [ ] What was verified: milestone, short commit hash, date and the tool table
- [ ] Results: every non-`N/A` flag has its exact command, exit code and pasted summary lines; `N/A`
      flags are listed as skipped with the reason; the explain-back answer is recorded
- [ ] How to reproduce: the ordered commands from a clean checkout
- [ ] Outstanding gaps: each is also in `GAPS.md` or, if deferred, in `DEFERRED.md` with a marker
- [ ] The Status line is filled as the template defines it

### Step 10 — Fill the As-Built summary and settle the outcome

- [ ] The plan's As-Built summary records what was built against what was planned
- [ ] The milestone's Status matches the outcome: `Verifying`, `In Progress` or `Blocked`
- [ ] Nothing was set to `Completed` in this workflow
- [ ] On a pass: the `KERNEL-IMPL` record is `Verified`, the cited `EX-` (and last-milestone `PROJ-`) spec
      is `Done`, and at P6 each passing profile is `Verified`

### Step 11 — Commit by explicit path

- [ ] Record, plan, milestone and every record whose status moved staged by name and committed with
      scope `pm`

---

## Context

- [ ] Directory trees in the relevant `CONTEXT.md` files show every file or folder this workflow created
- [ ] `project-management/REFERENCES.md` lists any new artefact type or external source
- [ ] `**Last Updated**` is refreshed in every `CONTEXT.md` modified
- [ ] If the session ended mid-work, a handoff exists in `handoffs/`

---

## Definition of Done

- [ ] Every mastery criterion has a recorded result that someone else could reproduce from the record
- [ ] Every gap is visible in the record and in the right register
- [ ] The milestone's Status follows `project-management/docs/planning/MILESTONES.md` → _Statuses_
- [ ] A passing milestone is committed and ready for `project-management/workflows/12-review-and-reflect/`
