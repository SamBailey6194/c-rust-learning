---
workflow: 10-study-and-build
phase: build
skills: [teach, handoff]
---

# Study and Build — Steps

**Last Updated**: 27/09/2026 | **Version**: 0.1.0 | **Maintained By**: Sam Bailey
**Language**: British English (en_GB) | **Timezone**: Europe/London

---

## Key references

Consult the root `REFERENCES.md` (external C, Rust and kernel sources) and `code/REFERENCES.md` (GCC,
GNU make, GDB, Valgrind, Rust) as you work through these steps:

| Step | Section |
| --- | --- |
| 1, 3, 7, 10 | `.claude/skills/teach/SKILL.md` — the lesson loop, `PROGRESS.md` format, the review curve |
| 2 | `project-management/src/09-MILESTONE-PLANS/` — the milestone's plan and its exercise order |
| 5 | `code/workflows/02-tdd-cycle/` — red, green, refactor with the `check.h` harness or `cargo test` |
| 6 | `code/workflows/01-c-exercise/` · `03-rust-exercise/` · `04-ffi-bridge/` — the build procedures |
| 6 | `code/docs/BUILD.md` — make targets and flags; `code/docs/TESTING.md` — the test harnesses |
| 6 | `project-management/workflows/06-kernel-spec/STEPS.md` — RECORD (Steps 9–10), the kernel build record |
| 8 | `code/workflows/07-debug/` — gdb and valgrind; `project-management/src/13-BUGS/` — the bug record |
| 9 | `project-management/docs/git/COMMITS.md` — scopes and staging by explicit path |

---

## Steps

### Step 1 — Open on the due reviews

Before any new material, read the review queue in each `learning/*/PROGRESS.md` and list every row whose
next review is today or earlier. Ask each recall question without the notes open, let the learner
answer, then confirm or correct. Record the result and move the row along the curve the teach skill
sets: a pass moves to the next interval (+1, +3, +7 days), a partial or a miss goes back to +1, and a
pass at +7 marks the lesson consolidated.

_Done when every due review has been answered unaided and its queue row carries a new date or reads
consolidated._

### Step 2 — Pick the next item from the plan

Open the milestone's plan in `project-management/src/09-MILESTONE-PLANS/` and take the next unfinished
item in its exercise order: one exercise and the one concept it depends on. If that concept is already
consolidated in a topic's `PROGRESS.md`, skip to Step 4.

On the milestone's first session, and on the first session after `11-verification` sent it back, set the
milestone's `**Status:**` to `In Progress` and the Status cell of the "You are here" row in
`project-management/src/01-ROADMAP/ROADMAP.md` to match
(`project-management/docs/planning/MILESTONES.md` → _Statuses_); Step 9 commits both.

_Done when the session's one exercise and its one prerequisite concept are named, and the milestone reads
`In Progress` in both places._

### Step 3 — Teach the concept with `/teach`

Run `/teach <topic>`. The skill opens or creates `learning/<track>-NN-<topic>/`, confirms the mission,
pitches the lesson at the edge of what the learner can already do, adds a primary source to
`RESOURCES.md`, teaches the concept briefly, and asks a recall question (predict the output, explain it
back, spot the bug), interleaving one question from an earlier lesson. The lesson's build-to-learn half
is the plan's exercise, taken through Steps 4 to 6: runnable code goes under `code/src/` through the code
workflows, where CI builds it, and the `NOTES/` concept note of Step 7 links to it by path
(`.claude/skills/teach/SKILL.md`). One concept per lesson.

If an explanation does not land, the learner can type `/wait-what` for a plainer re-pitch.

_Done when the learner has answered the recall question unaided, or the miss is noted for Step 7._

### Step 4 — Explain it back and state the approach

Tutor mode throughout. Ask the learner to explain the concept in their own words, then ask how they plan
to approach the exercise: which function comes first, what the test will check, where it could go
wrong. Correct a misunderstanding with a question or a pointer to `code/docs/`, not with code.

_Done when the learner has explained the concept and stated an approach Claude has not supplied._

### Step 5 — Write the failing test first

Following `code/workflows/02-tdd-cycle/`, the learner writes the test before the code: a `test_*.c` file
using the `check.h` harness for C, a unit test or a `tests/*.rs` file for Rust. Run it and watch it fail
for the predicted reason:

```bash
make -C code/src/c/ms###-<kebab> test              # C: one exercise
(cd code/src/rust && cargo test -p ms###_<snake>)  # Rust: one crate, on the pinned toolchain
```

Running cargo from inside `code/src/rust/` is what makes rustup honour `rust-toolchain.toml`. A red test
may be committed on its own, as `project-management/docs/git/COMMITS.md` allows.

_Done when the new test fails, and the failure is the one the learner predicted._

### Step 6 — Build the exercise until it is clean

Work through the code workflow the plan names: `code/workflows/01-c-exercise/` for C,
`03-rust-exercise/` for Rust, `04-ffi-bridge/` for C called from Rust. The learner writes the code;
Claude answers questions, gives hints in increasing order of detail, and names the `code/docs/` section
that applies. When the tests pass, a C exercise also has to be clean under the sanitisers and valgrind:

```bash
make -C code/src/c/ms###-<kebab> test
make -C code/src/c/ms###-<kebab> san        # ASan + UBSan build in build/san/, tests run there
make -C code/src/c/ms###-<kebab> memcheck   # valgrind on the plain build/ binaries
```

`code/workflows/06-memory-check/` explains how to read each report when one is not clean.

For a milestone whose Kernel flag is not `N/A`, the build and the QEMU boot follow the milestone's
`KERNEL-PLAN` in `project-management/src/06-KERNEL/`, and once the build has run the learner writes its
`KERNEL-IMPL` record through `project-management/workflows/06-kernel-spec/` → RECORD (Steps 9–10), for
`11-verification` to check.

_Done when the tests pass and, for C, `san` and `memcheck` both exit 0; for a kernel milestone, when the
`KERNEL-IMPL` record holds the pasted build and boot evidence._

### Step 7 — Write the note and log the lesson

The learner writes `NOTES/NN-<concept>.md` in their own words, linking the exercise by path; Claude checks
it against the source and flags errors rather than rewriting it. Then append the dated journal entry to
`PROGRESS.md` (the recall question and result, the note, the next review) and add the lesson's row to
the review queue with its first review a day later, as `.claude/skills/teach/SKILL.md` lays out.

_Done when the note exists and `PROGRESS.md` holds today's entry and a matching queue row._

### Step 8 — Log bugs and misconceptions as they happen

A bug that took real investigation goes through `code/workflows/07-debug/` and is written up in
`project-management/src/13-BUGS/` with its gdb or valgrind evidence. A misconception the session
corrected goes into the topic's `PROGRESS.md` journal, where `12-review-and-reflect` collects it into
the milestone's findings.

_Done when every bug investigated has a record and every corrected misconception is in the journal._

### Step 9 — Commit by explicit path

Commit on the milestone branch (`ms###/<short-kebab>`, per `project-management/docs/git/BRANCHES.md`),
staging each path by name:

```bash
git status --short
git add code/src/c/ms###-<kebab>/
git commit -m "feat(c): <what the exercise now does>"
git add learning/<track>-NN-<topic>/
git commit -m "docs(learning): <concept> lesson and review schedule"
git add project-management/src/02-MILESTONES/MS###-<TITLE>.md \
        project-management/src/01-ROADMAP/ROADMAP.md    # only when Step 2 changed the status
git commit -m "docs(pm): start MS###"
```

Naming a folder counts as explicit when every file in it is the learner's
(`project-management/docs/git/COMMITS.md`); `.gitignore` keeps `build/` and `target/` out.

_Done when `git status --short` shows nothing from the session left uncommitted._

### Step 10 — Close the session

Set **Next session opens on** in the topic's `PROGRESS.md`, and tick the finished item in the plan's
exercise order. If the work is mid-way, run `/handoff` instead of carrying on. When every exercise in the
plan is built, the milestone moves to `project-management/workflows/11-verification/`.

_Done when a fresh session could resume from the files alone._

---

## Update context files

If this workflow created files or folders, or settled a new convention:

1. Add every new file or folder to the directory tree in the nearest `CONTEXT.md` (a new exercise to
   `code/src/c/CONTEXT.md` or `code/src/rust/CONTEXT.md`); a new exercise folder carries its own
   `CONTEXT.md` and `CLAUDE.md`, as `code/src/c/ms001-hello/` does.
2. Add any new artefact type or external source to `project-management/REFERENCES.md`.
3. Refresh `**Last Updated**` in every `CONTEXT.md` you modified.
4. If the session ends before Completion, run `/handoff` to write
   `handoffs/HANDOFF-<SCREAMING-KEBAB-DESCRIPTOR>-DD-MM-YYYY.md`.

---

## Completion

Run through `CHECKLIST.md` before marking this workflow complete.
