@./CONTEXT.md

# CLAUDE.md — project-management/src/05-PROJECTS/

Read order: `.claude/CLAUDE.md` → `.claude/MEMORY.md` → this folder's `CONTEXT.md` (what a project
spec records — imported above) → this file → the driving milestone and the phase in
`project-management/src/01-ROADMAP/ROADMAP.md`.

## Purpose (one line)

The capstone project specs — one `PROJ-MS###-<NAME>.md` per project: scope, behaviour, milestone
breakdown, acceptance, test strategy and stretch goals, never a solution.

## How to work here

- **Routing:** start from `project-management/workflows/05-project-spec/` (`STEPS.md` +
  `CHECKLIST.md`). A project too big for one milestone is cut into several through
  `project-management/workflows/02-milestone-creation/`; a hard-to-reverse design choice inside it
  goes to `project-management/workflows/08-decisions/`.
- **Concrete steps:** explain-first interview (what the learner thinks the program needs, what they
  expect to be hard) → copy `PROJ-MS000-TEMPLATE.md` to `PROJ-MS###-<NAME>.md` → fix scope and
  out-of-scope → write the interface or command-line behaviour → cut the milestones → write the
  acceptance scenarios with exact commands → write the test strategy, stretch goals and risks →
  set **Status** to `Ready` → link it from each milestone it spans.
- **Definition of done:** scope and out-of-scope both written; every acceptance scenario names a
  command and a result; each project milestone provable on its own; memory gates named for every C
  part; no solution code; British English; DD/MM/YYYY.

## Guardrails

- **Decide "finished" before starting.** Acceptance is fixed in the spec; an idea that arrives
  mid-build goes to Stretch goals or `DEFERRED.md`, not into scope.
- **Cut big projects into provable milestones.** A project estimated at 13 points or more is an
  epic: split it (for example an allocator's free list, then splitting and coalescing, then
  `realloc`) so each part closes with its own verification record.
- **Never write the solution.** Interfaces, behaviour and acceptance only; design sketches stay at
  the level of "which parts exist and what each is responsible for".
- **Name a reference behaviour where one exists.** A shell is compared against `bash` or `dash`
  for the features in scope, a libc function against its man page and the C standard — so expected
  results are not invented.
- **Plan the allocator's memory testing explicitly.** valgrind intercepts any globally exported
  `malloc` and `free`, including the learner's own, so an allocator spec states how its tests avoid
  that (see `project-management/src/01-ROADMAP/ROADMAP.md` → P2).
- **Move a spec through its status words in order.** `Draft` while it is being written, `Ready`
  when this folder's definition of done holds, `Done` when every acceptance scenario passes and the
  last project milestone's verification record cites it.

## Output & naming

- **Hand-written:** every `PROJ-MS###-<NAME>.md`.
- **Template:** `PROJ-MS000-TEMPLATE.md` — the copy source; keep it, do not repurpose it.
- **Generated:** none.
- Specs are named `PROJ-MS###-<NAME>.md`: the number of the **first** milestone the project spans,
  then the project name in `SCREAMING-KEBAB-CASE` (for example `PROJ-MS020-UNIX-SHELL.md`). Later
  milestones of the same project cite this file rather than taking a spec of their own.
- Acceptance scenario IDs are `A1`, `A2`, ...; dates DD/MM/YYYY.
