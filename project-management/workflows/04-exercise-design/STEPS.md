---
workflow: 04-exercise-design
phase: specify
skills: []
---

# Exercise Design — Steps

**Last Updated**: 27/09/2026 | **Version**: 0.1.0 | **Maintained By**: Sam Bailey
**Language**: British English (en_GB) | **Timezone**: Europe/London

---

## Key references

Consult `project-management/REFERENCES.md` (GCC, valgrind and Rust sources) as you work through these
steps:

| Step | Section |
| --- | --- |
| 1 | The milestone in `project-management/src/02-MILESTONES/`: mastery criteria and the `Exercises` flag |
| 2 | `project-management/src/04-EXERCISES/CLAUDE.md` — naming, status words; `EX-MS000-TEMPLATE.md` |
| 3 | `code/docs/BUILD.md` · `code/docs/C-CODING-PRINCIPLES.md` · `code/docs/RUST-CODING-PRINCIPLES.md` |
| 4 | `code/docs/TESTING.md` — `check.h` and the Rust test layout |
| 4 | `project-management/docs/SAFETY-GUIDE.md` → _C — undefined behaviour and memory bugs_ |
| 7 | `project-management/docs/git/COMMITS.md` — scope `pm`, staging by explicit path |

---

## Steps

### Step 1 — Explain-first on the concept and its pitfalls

Check the entry condition: the milestone's `Exercises` flag is not `N/A`. Then ask the learner what the
concept is for, how they would test that someone understood it, and where they expect to go wrong. The
predicted pitfalls are the most valuable input to this workflow: each one becomes a test case in Step 4.
Read the milestone's mastery criteria and the flag's first-pass value (for example
`C: 5 exercises, recall → extend`).

_Done when the learner's predicted pitfalls are listed and the mastery scenarios needing exercises are
identified._

### Step 2 — Copy the template and fill the header

```bash
cp project-management/src/04-EXERCISES/EX-MS000-TEMPLATE.md \
   project-management/src/04-EXERCISES/EX-MS007-DYNAMIC-ARRAY.md
```

Fill the header table: the milestone and its file, the track, the code location (for example
`code/src/c/ms007-dynamic-array/` for C, `code/src/rust/crates/ms007_<snake>/` for Rust), the build
workflow, `Status: Draft` and the date. Then _What this set teaches_: the concepts, the scenarios it
serves, the milestones it builds on, and the climb from recall to extension.

_Done when the header and section 1 are complete and the code location follows the naming in
`project-management/src/04-EXERCISES/CLAUDE.md`._

### Step 3 — Set the constraints

Fill the constraints table for the whole set: standard and flags (C17 with the project warnings as
errors, or edition 2024 with the workspace lints), allowed and banned library calls (`strcpy`, `strcat`
and `sprintf` are the usual bans, because they cannot be bounded), memory rules, style and the
test-first rule. A constraint is there to force the concept: a no-heap rule for the first exercise of a
pointer set makes the learner meet the stack first.

_Done when every row has a rule for this set, and any exception to the house rules has an ADR._

### Step 4 — Write each exercise

For each exercise, in climbing order:

1. **Problem:** two to five sentences from the caller's side.
2. **Interface:** the signature the tests call. For C, a prototype in the kernel style; for Rust, a
   `pub fn` signature. No body.
3. **Contract:** return values, ownership (who allocates, who frees), and every error case: NULL
   pointers, zero lengths, truncation, invalid input.
4. **Worked examples:** input and expected output, derived by reasoning, the man page or the C standard,
   never by running code.
5. **Test cases:** at least one normal, one boundary and one error case, as `T1`, `T2`, ... rows, plus
   one row per pitfall the learner predicted in Step 1.
6. **Hints ladder:** at least three rungs (nudge, concept with a reading pointer, approach in prose),
   none of them code.

_Done when every exercise has all six parts and every predicted pitfall appears as a test case._

### Step 5 — Map the exercises to the mastery criteria

Fill the mastery map: every scenario in the milestone that needs an exercise names the exercise and test
cases that prove it, and every exercise serves at least one scenario. An exercise that serves no
scenario is either cut or the milestone is missing a criterion; settle which with the learner. Write the
reflection questions, answered later in the learning note.

_Done when no mastery scenario is unmapped and no exercise is orphaned._

### Step 6 — Set the status and link the spec

Check the spec against the folder's definition of done, then set `Status: Ready` and link it from the
milestone by full path. Confirm the milestone's `Tests`, `Memory` and `Lint` flags name the exercise
directory the spec uses, so `11-verification` runs the right commands.

_Done when the spec is `Ready`, the milestone links it, and the flags and the code location agree._

### Step 7 — Commit by explicit path

On the milestone branch:

```bash
git add project-management/src/04-EXERCISES/EX-MS007-DYNAMIC-ARRAY.md \
        project-management/src/02-MILESTONES/MS007-DYNAMIC-ARRAY.md
git commit -m "docs(pm): specify MS007 exercise set"
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

Run through `CHECKLIST.md` before marking this workflow complete. Next, as flagged:
`project-management/workflows/05-project-spec/`, `06-kernel-spec/` or `07-os-profile-spec/`, then
`08-decisions/`.
