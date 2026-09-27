@./CONTEXT.md

# CLAUDE.md — project-management/src/04-EXERCISES/

Read order: `.claude/CLAUDE.md` → `.claude/MEMORY.md` → this folder's `CONTEXT.md` (what a spec
records and where it leads — imported above) → this file → the driving milestone in
`project-management/src/02-MILESTONES/`.

## Purpose (one line)

The exercise-set specs — one `EX-MS###-<TOPIC>.md` per milestone with a running Exercises flag:
problems, constraints, interfaces, worked examples, test cases and hints, never solutions.

## How to work here

- **Routing:** start from `project-management/workflows/04-exercise-design/` (`STEPS.md` +
  `CHECKLIST.md`). The spec is consumed by `code/workflows/01-c-exercise/` (C) or
  `code/workflows/03-rust-exercise/` (Rust); a fact a spec rests on that needs looking up goes
  through the `research` skill into `research/`.
- **Concrete steps:** read the milestone's mastery criteria → ask the learner what they expect to
  find hard → copy `EX-MS000-TEMPLATE.md` to `EX-MS###-<TOPIC>.md` → write the constraints → write
  each exercise (problem, interface, contract, worked examples, test cases, hints ladder) → map
  every exercise to a mastery scenario → set **Status** to `Ready` → link the spec from the
  milestone's Links table.
- **Definition of done:** every exercise has an interface, a contract with its error cases, at
  least one normal, one boundary and one error test case, and a hints ladder of at least three
  rungs; every mastery scenario that needs an exercise has one; no solution code anywhere; British
  English; DD/MM/YYYY.

## Guardrails

- **Never write a solution into a spec.** Not in a hint, not in a worked example, not in a
  comment. An interface (a function signature and its contract) is allowed; a body is not.
- **Write expected results from the spec's sources, not from running code.** A test that copies
  what the code printed can only prove the code agrees with itself.
- **Make every hint a question or a nudge.** Rung one points back at the problem, rung two names
  the concept and where to read about it, rung three describes an approach in prose. None of them
  is code.
- **Include an error case for every interface.** NULL pointers, zero lengths, truncation, invalid
  input: a C function's contract is mostly its failure modes.
- **Keep one spec per milestone.** Several exercises belong in one set; a second set for the same
  milestone means the milestone is two milestones.
- **Move a spec through its status words in order.** `Draft` while it is being written, `Ready`
  when this folder's definition of done holds, `Done` when every exercise in it is green and the
  milestone's verification record cites it.

## Output & naming

- **Hand-written:** every `EX-MS###-<TOPIC>.md`.
- **Template:** `EX-MS000-TEMPLATE.md` — the copy source; keep it, do not repurpose it.
- **Generated:** none.
- Specs are named `EX-MS###-<TOPIC>.md`: the driving milestone's number, then the topic in
  `SCREAMING-KEBAB-CASE` (for example `EX-MS002-POINTER-DRILLS.md`). Exercise directories in
  `code/src/` take the same `MS###` in lower case (`ms002-<kebab>/`, `ms002_<snake>/`).
- Test case IDs are `T1`, `T2`, ... within an exercise; dates DD/MM/YYYY.
