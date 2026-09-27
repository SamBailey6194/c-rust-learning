@./CONTEXT.md

# CLAUDE.md — project-management/src/13-BUGS/

Read order: `.claude/CLAUDE.md` → `.claude/MEMORY.md` → this folder's `CONTEXT.md` (what a record holds
and when one is written — imported above) → this file → `code/workflows/07-debug/STEPS.md`.

## Purpose (one line)

The defect store — one `BUG-MS###-<DESCRIPTOR>-DD-MM-YYYY.md` per isolated defect: reproduction, root
cause with tool evidence, fix, and a regression test written first.

## How to work here

- **Routing:** records come from `code/workflows/07-debug/`, whether the defect surfaced during
  `project-management/workflows/10-study-and-build/`, in a review, or at
  `project-management/workflows/11-verification/`. Tutor mode applies: Claude asks how the learner plans
  to find the fault before helping, and the learner writes the fix.
- **Concrete steps:** reproduce it deterministically → capture the environment → collect evidence with
  gdb, valgrind or a sanitiser → copy `BUG-MS000-TEMPLATE.md` to the name below → write the failing
  regression test and watch it fail for the predicted reason → trace the root cause to its lines → the
  learner fixes it → watch the test pass → run the milestone's gates and `gates/all.sh` → set the fix
  state → name any misconception for `project-management/src/12-FINDINGS/`.
- **Definition of done:** named with the real date the defect was found; the reproduction works from a
  clean checkout; the root cause cites tool evidence; the regression test was seen red then green; the
  milestone's gates and `bash code/src/scripts/gates/all.sh` pass; the fix state is current; British
  English; dates DD/MM/YYYY.

## Guardrails

- **Write the regression test before the fix.** A test written after the fix has never been seen to
  fail, so it proves nothing about this bug.
- **Fix the cause, not the symptom.** A record whose fix only hides the symptom — a cast that silences a
  warning, a bigger buffer with the same off-by-one — is not done.
- **Cite the evidence.** The root cause quotes the gdb, valgrind or sanitiser lines that locate it;
  a guess is marked as a guess until the tool confirms it.
- **Point, do not patch.** The record describes the approach and names the commit; the fix lives in
  `code/src/` and was written by the learner.
- **Reproduce kernel defects in QEMU only.** Nothing is installed or loaded on the host
  (`.claude/CLAUDE.md` owns the rule).
- **Scrub pasted output.** Replace absolute home paths with repo-relative ones and keep secrets out; the
  repository is public.
- **One defect per record; never rename or back-date one.** The date is when it was found. A related
  defect found later is a new record that cites this one.

## Output & naming

- **Hand-written:** every `BUG-*.md`, copied from the template.
- **Template:** `BUG-MS000-TEMPLATE.md` — the copy source; keep it, never fill it in or rename it.
- **Generated:** none.
- Milestone defects `BUG-MS###-<DESCRIPTOR>-DD-MM-YYYY.md`: the milestone whose code holds the defect,
  three digits; a SCREAMING-KEBAB-CASE descriptor naming the fault (`OFF-BY-ONE-IN-COPY`, not
  `BUG-FIX`); the date it was found.
- Defects not owned by one milestone (a script, a CI workflow, the shared `code/src/c/mk/` rules):
  `BUG-<DESCRIPTOR>-DD-MM-YYYY.md`, with the milestone rows marked `N/A — cross-cutting`.
- Fix state values `Open` · `Fixed` · `Verified` belong to the record; the milestone's own status stays in
  the vocabulary owned by `project-management/docs/planning/MILESTONES.md`.
