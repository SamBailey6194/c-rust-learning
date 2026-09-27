---
workflow: 11-verification
phase: record
skills: []
---

# Verification — Steps

**Last Updated**: 27/09/2026 | **Version**: 0.1.0 | **Maintained By**: Sam Bailey
**Language**: British English (en_GB) | **Timezone**: Europe/London

---

## Key references

Consult `project-management/REFERENCES.md` → **External — Verification & Safety** (GCC sanitiser and
analyser options, the Valgrind manual, QEMU invocation) as you work through these steps:

| Step | Section |
| --- | --- |
| 1, 10 | `project-management/docs/planning/MILESTONES.md` — _Statuses_ and _The FLAGS table_ |
| 2 | `how-to/docs/TOOLCHAIN.md` — the expected tool versions |
| 4 to 7 | `code/docs/BUILD.md` — targets, flags; `project-management/docs/VERIFICATION-GUIDE.md` — clean output |
| 5 | `code/workflows/06-memory-check/` — the sanitiser and valgrind procedure |
| 7 | `code/docs/DEBUGGING.md` — gdb; the QEMU command comes from the mastery criterion itself |
| 8 | `how-to/workflows/03-quality-gates/` — `gates/all.sh`, its order and exit codes |
| 9 | `project-management/src/10-PROGRESS/MS000-VERIFICATION-TEMPLATE.md` — the record scaffold |

---

## Steps

### Step 1 — Explain first, then move the milestone to `Verifying`

Explain-first (`project-management/workflows/CONTEXT.md` → _Explain-first_): ask the learner which mastery
criterion is most likely to fail and why, and note the answer. Set the milestone's `**Status:**` to
`Verifying`, and the Status cell of the "You are here" row in
`project-management/src/01-ROADMAP/ROADMAP.md` to match, and commit the two by path, so that Step 3
starts from a clean tree:

```bash
git add project-management/src/02-MILESTONES/MS###-<TITLE>.md project-management/src/01-ROADMAP/ROADMAP.md
git commit -m "docs(pm): move MS### to verifying"
```

Then list what will run: every mastery criterion in the milestone, the verification commands in its
plan, and the FLAGS rows that are not `N/A`.

_Done when the prediction is noted, the Status reads `Verifying` in a commit, and the list of checks is
written down._

### Step 2 — Record the toolchain

```bash
bash code/src/scripts/toolchain/check.sh
```

Paste the `| Tool | Version |` table it prints into the record's reproduction section. Exit 2 means a
required tool is missing: stop, add a `GAPS.md` entry, set the milestone to `Blocked`, and install the
tool through `how-to/workflows/01-toolchain-setup/` before starting again.

_Done when the tool table is captured and the script exited 0._

### Step 3 — Start from a clean, committed tree

```bash
git status --short          # prints nothing: everything being verified is committed
make -C code/src/c clean    # no stale objects from an earlier flag set
```

_Done when `git status --short` is empty and the C build folders are gone._

### Step 4 — Run the Tests checks

For a milestone whose Tests flag is not `N/A` (nearly all of them), run the raw commands first, then the
scripts that wrap them, and keep the last lines of output:

```bash
make -C code/src/c test          # every exercise, so earlier milestones are re-proved too
(cd code/src/rust && cargo test)
bash code/src/scripts/c/test.sh
bash code/src/scripts/rust/test.sh
```

Running cargo from inside `code/src/rust/` makes rustup honour the pinned `rust-toolchain.toml`.

_Done when every test binary and `cargo test` exit 0, and the pass counts are captured._

### Step 5 — Run the Memory checks

For a milestone whose Memory flag is not `N/A`, follow `code/workflows/06-memory-check/`:

```bash
make -C code/src/c san        # AddressSanitizer + UBSan build in build/san/, tests run there
make -C code/src/c memcheck   # valgrind on the plain build/ binaries, --error-exitcode=1
bash code/src/scripts/c/san.sh
bash code/src/scripts/c/memcheck.sh
```

Capture valgrind's `ERROR SUMMARY` line for each test binary, and confirm no sanitiser report and no
`runtime error:` line appeared. An FFI crate runs both suites, C and Rust.

_Done when both runs exit 0 and their evidence lines are captured._

### Step 6 — Run the Lint checks

For a milestone whose Lint flag is not `N/A`:

```bash
make -C code/src/c lint     # every source compiled with -fanalyzer into build/lint/
(cd code/src/rust && cargo fmt --check && cargo clippy --all-targets -- -D warnings)
bash code/src/scripts/c/lint.sh
bash code/src/scripts/rust/lint.sh
```

_Done when every lint run exits 0 with no warnings._

### Step 7 — Run the Debugger and QEMU checks

For a milestone whose Debugger flag is not `N/A`, the learner repeats the walkthrough the flag names,
for example `gdb -q code/src/c/ms###-<kebab>/build/test_<unit>` with the breakpoint or watchpoint it
describes. Record the gdb commands typed and a transcript excerpt showing what the milestone predicted.

For a milestone whose QEMU flag is not `N/A`, run the exact `qemu-system-x86_64` command the mastery
criterion names and capture the serial-console line that proves the boot. The kernel and any module stay
inside the guest.

_Done when each flagged walkthrough or boot is recorded with its commands and its evidence line._

### Step 8 — Run the explain-back scenario, then the full gate suite

With no notes or code open, the learner explains the concept the milestone's explain-back scenario
names; check the explanation against that scenario's `Then` clause and record the result. Then run the
whole suite as `how-to/workflows/03-quality-gates/` describes:

```bash
bash code/src/scripts/gates/all.sh
```

It prints a summary table and exits with the worst code: 0 pass, 1 failures, 2 could not run.

_Done when the explanation is recorded and `gates/all.sh` exited 0, or every non-zero row is explained._

### Step 9 — Write the verification record

Copy `MS000-VERIFICATION-TEMPLATE.md` to `project-management/src/10-PROGRESS/MS###-VERIFICATION.md` and
fill it as `project-management/docs/VERIFICATION-GUIDE.md` → _The verification record_ describes:

1. **What was verified** — the milestone, the commit (`git rev-parse --short HEAD`) and the date, with the
   tool table from Step 2.
2. **Results** — for each flag that is not `N/A`: the exact command, its exit code and the summary lines,
   pasted rather than paraphrased; `N/A` flags listed as skipped, with the milestone's reason. The
   explain-back question and the learner's answer go here too.
3. **How to reproduce** — the commands, in order, from a clean checkout.
4. **Outstanding gaps** — anything that failed, could not run or passed with a caveat, each with its
   `GAPS.md` entry, or its `DEFERRED.md` entry and `DEFERRED (MS###)` marker if it was left for later.
5. **Status** — the milestone status this record supports.

_Done when every row has a command and evidence, and no `{PLACEHOLDER}` remains._

### Step 10 — Fill the As-Built summary and settle the outcome

Fill the As-Built summary in the milestone's plan: what was built against what was planned, and why any
difference arose. Then settle the milestone's Status against
`project-management/docs/planning/MILESTONES.md` → _Statuses_:

- every check passed → the milestone stays `Verifying` and moves on to `12-review-and-reflect`; it
  becomes `Completed` only when `13-pr-and-merge` has merged it
- the gates passed but the explain-back did not → stays `Verifying`; the concept goes back through
  `/teach` (`10-study-and-build` Step 3) and the explain-back is asked again before moving on
- any gate failed → back to `In Progress`, a `project-management/src/13-BUGS/` record where the defect
  earns one, then `10-study-and-build`; afterwards verification runs again from Step 1, because a partial
  rerun proves only the part that was rerun
- a check could not run for a reason outside the milestone → `Blocked`, with the `GAPS.md` entry named

Keep the "You are here" row in `ROADMAP.md` on the same status as the milestone.

When every check passed, move the records this verification checked along their own lifecycles, each
owned by its folder's `CLAUDE.md` (`project-management/docs/planning/MILESTONES.md` → _Statuses_):

- the milestone's `KERNEL-IMPL` record, when the Kernel flag is set → `Verified`
  (`project-management/src/06-KERNEL/CLAUDE.md`)
- its `EX-MS###` spec, and a `PROJ-` spec on the project's last milestone, once the record cites them →
  `Done` (`project-management/src/04-EXERCISES/CLAUDE.md`, `project-management/src/05-PROJECTS/CLAUDE.md`)
- at P6, each tier whose image passed its hypotheses → `Verified`
  (`project-management/src/07-DISTRO-TIERS/CLAUDE.md`)

_Done when the As-Built summary is written, the Status matches the outcome in both places, and every
record this run checked carries its new status._

### Step 11 — Commit by explicit path

```bash
git add project-management/src/10-PROGRESS/MS###-VERIFICATION.md \
        project-management/src/09-MILESTONE-PLANS/<exec-order>-PLAN-MS###-<DESC>.md \
        project-management/src/02-MILESTONES/MS###-<TITLE>.md \
        project-management/src/01-ROADMAP/ROADMAP.md
git add <each spec, kernel record or tier file whose status moved in Step 10>
git commit -m "docs(pm): verify MS###"
```

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
