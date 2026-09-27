# Workflow: Verification

**Last Updated**: 27/09/2026

"It worked when I tried it" is not mastery, and a result nobody wrote down cannot be checked later. This
workflow runs the milestone's mastery-criteria commands against the committed code and records exactly
what passed, how to reproduce it, and what is still missing, so a `Completed` milestone means something
another person could confirm from the repo alone.

## Directory Tree

```text
project-management/workflows/11-verification/
├── CONTEXT.md · CLAUDE.md   ← orientation (this file) · operating rules for the workflow
├── STEPS.md                 ← ordered steps, each closing on a "Done when" line
└── CHECKLIST.md             ← the gate ticked before the workflow counts as complete
```

## When to use this

- Every exercise in the milestone's plan is built (`10-study-and-build`), and the milestone is ready to
  move from `In Progress` to `Verifying`.
- Again after a failed run, once the fix is committed; a failure sends the milestone back to
  `In Progress` and this workflow starts over.
- It runs before `12-review-and-reflect` and `13-pr-and-merge`; the merge in `13` is what finally makes
  the milestone `Completed`.

## Key concepts

- **The mastery criteria are the contract.** Each Gherkin scenario in the milestone names a command and
  a result; this workflow runs exactly those, plus the commands the plan listed, and nothing
  improvised.
- **The FLAGS table decides which checks run.** Tests, Memory, Debugger, Lint and QEMU each run when the
  milestone's flag is not `N/A` (`project-management/docs/planning/MILESTONES.md` → _The FLAGS table_).
- **Raw command first, then the script.** The `make`, `cargo`, `valgrind`, `gdb` or `qemu-system-x86_64`
  invocation is the lesson; the matching script under `code/src/scripts/` is the repeatable form, and
  `code/src/scripts/gates/all.sh` runs them all and exits with the worst code.
- **Exit 2 is "could not run", not "clean".** A gate script that finds a tool missing exits 2; that result
  is a gap to record rather than a pass.
- **Sanitisers and valgrind stay apart.** `make san` builds an AddressSanitizer + UBSan tree in
  `build/san/`; `make memcheck` runs valgrind on the plain binaries in `build/`. `code/docs/BUILD.md`
  explains why each keeps its own binaries.
- **The verification record.** `project-management/src/10-PROGRESS/MS###-VERIFICATION.md`, copied from
  `MS000-VERIFICATION-TEMPLATE.md`: Results, How to reproduce, Outstanding gaps, and a Status line.
  `Completed` requires it to exist.
- **What a clean result looks like** for each tool is owned by
  `project-management/docs/VERIFICATION-GUIDE.md`; this workflow sequences the runs.

## Cross-references

### Governing documents

- `project-management/docs/VERIFICATION-GUIDE.md` — how mastery is proved and what clean output is
- `project-management/docs/planning/MILESTONES.md` — the status vocabulary and the FLAGS table
- `project-management/src/10-PROGRESS/CLAUDE.md` — naming and authoring rules for verification records
- `how-to/workflows/03-quality-gates/` — the gate scripts, their order and their exit codes

### Related reading

- `project-management/src/10-PROGRESS/MS000-VERIFICATION-TEMPLATE.md` — the record scaffold
- `code/workflows/06-memory-check/` — the sanitiser and valgrind procedure this workflow calls
- `code/docs/BUILD.md` · `code/docs/MEMORY-SAFETY.md` · `code/docs/DEBUGGING.md` — targets, bug classes,
  gdb
- `how-to/docs/TOOLCHAIN.md` — the tool versions the record states
- `project-management/src/09-MILESTONE-PLANS/` — the plan whose verification commands run here and whose
  As-Built summary is filled here
- `project-management/workflows/12-review-and-reflect/` — downstream: review and findings
