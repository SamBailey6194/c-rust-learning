@./CONTEXT.md

# CLAUDE.md — code/workflows/07-debug/

Read order: `.claude/CLAUDE.md` → `.claude/MEMORY.md` → this folder's `CONTEXT.md` (reproduce, shrink,
failing test first, minimal fix, the BUG record — imported above) → this file → `STEPS.md` then
`CHECKLIST.md`.

## Purpose (one line)

Turn a wrong result or a crash in `code/src/` into a reproduced, shrunk, test-pinned and minimally fixed
bug with a BUG record — the learner doing the investigating and the fixing.

## How to work here

- **Routing:** run `STEPS.md` in order against `CHECKLIST.md`. Tool trouble goes to
  `how-to/workflows/05-debugging-environment/`; reading a memory-tool report uses
  `code/workflows/06-memory-check/` Steps 2–4; a design problem the fix exposes goes to
  `code/workflows/08-refactor/` afterwards.
- **Tutor mode:** ask the learner what they expected, what happened instead, and what they think the cause
  is — before Claude offers anything. Suggest the next observation ("what does `bt` show?", "watch that
  variable") rather than the answer, and explain gdb or valgrind output when asked. Do not write the fix
  unless explicitly asked.
- **Concrete steps:** reproduce with one command → shrink (halve the input; `git bisect run` for a
  regression) → write the failing test → observe with gdb, one hypothesis at a time → minimal fix →
  re-run the memory tools → BUG record → commit fix and test together.
- **Definition of done:** the regression test failed before the fix and passes after it; the whole suite
  and `06-memory-check` are green; no unrelated code changed; the BUG record exists with its root cause
  and evidence.

## Guardrails

- **Write the failing test before the fix.** A fix with no test that failed first proves nothing and
  guards nothing.
- **Keep the fix minimal.** No refactoring, renaming or tidying in the same commit; note it for
  `08-refactor`.
- **Test one hypothesis at a time.** Change one thing, observe, and write down the result before the next
  change; undo a change that did not help.
- **Tag temporary debug output.** Every temporary `printf` or `eprintln!` carries one unique marker (for
  example `DEBUG-7c1e`) so a single `grep -rn` finds and removes them all before the commit.
- **Leave `git bisect` clean.** Always finish with `git bisect reset`, so the working tree returns to the
  branch it started on.

## Output & naming

- **Produced by following it:** the regression test and the fix, together, in the exercise or crate under
  `code/src/`; a BUG record in `project-management/src/13-BUGS/` copied from `BUG-MS000-TEMPLATE.md` (that
  folder's `CONTEXT.md` owns the filename pattern).
- Commit type `fix` with scope `c` or `rust` (`project-management/docs/git/COMMITS.md`); the BUG record may
  travel in the same commit or follow with scope `pm`.
- Workflow files `SCREAMING-SNAKE-CASE.md`, frontmatter `workflow: 07-debug`, `phase: diagnose-and-improve`.
