@./CONTEXT.md

# CLAUDE.md — project-management/workflows/09-milestone-plans/

Read order: `.claude/CLAUDE.md` → `.claude/MEMORY.md` → this folder's `CONTEXT.md` (when to use, key
concepts, governing documents — imported above) → this file → `STEPS.md` then `CHECKLIST.md`.

## Purpose (one line)

Write the per-milestone plan that `10-study-and-build` works from: what to read, which exercises in which
order, the exact commands that prove mastery, the risks, and what is deferred.

## How to work here

- **Routing:** run `STEPS.md` in order against `CHECKLIST.md`. Read
  `project-management/src/09-MILESTONE-PLANS/CLAUDE.md` and `00-PLAN-MS000-TEMPLATE.md` before Step 2,
  and `code/docs/BUILD.md` before Step 5.
- **Concrete steps:** the learner predicts the hardest part → gather the milestone, sprint, specs, ADRs
  and register entries → compute `<exec-order>` and copy the template → list resources and chapters →
  order the exercises → turn every mastery criterion into a raw command and its script → record risks
  and deferrals → leave the As-Built stub → the learner explains the plan back → cross-link → commit.
- **Definition of done:** every mastery criterion maps to a verification command; every exercise maps to
  a spec and a code workflow; every Accepted ADR the milestone rests on is cited; the As-Built summary is
  a marked stub; `CHECKLIST.md` is fully ticked.

## Guardrails

- **Start from the template.** Copy `00-PLAN-MS000-TEMPLATE.md`; a free-hand plan drops the sections that
  make it checkable.
- **Write the verification commands before any code exists.** A proof chosen after the build tends to
  prove whatever was built.
- **Teach the raw command, then name its script.** Each verification line shows the `make`, `cargo` or
  `valgrind` invocation first and the `code/src/scripts/` wrapper second (`code/docs/BUILD.md` owns
  both).
- **Cite resources by chapter and link.** Never paste book or manual text into this public repo.
- **Renumber in the same commit that reorders.** A plan prefix that no longer matches the build order
  says nothing; fix the plans and every citation together.
- **Leave the solutions out.** The plan names exercises and their specs; it holds no worked answers.

## Output & naming

- **Writes:** `project-management/src/09-MILESTONE-PLANS/<exec-order>-PLAN-MS###-<DESC>.md`.
- `<exec-order>` is two digits from `01`; `<DESC>` is SCREAMING-KEBAB-CASE and matches the milestone's
  descriptor. The folder's `CLAUDE.md` → Output & naming owns the pattern.
- Updates: `DEFERRED.md` (`DEFERRED (MS###)` markers) and `GAPS.md` (blocking risks) where Step 6 found
  them.
- Commit scope `pm`, per `project-management/docs/git/COMMITS.md`.
