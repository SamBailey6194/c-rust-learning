@./CONTEXT.md

# CLAUDE.md — project-management/workflows/04-exercise-design/

Read order: `.claude/CLAUDE.md` → `.claude/MEMORY.md` → this folder's `CONTEXT.md` (entry condition, key
concepts, governing documents — imported above) → this file → `STEPS.md` then `CHECKLIST.md`.

## Purpose (one line)

Specify a milestone's exercise set (problems, constraints, interfaces, contracts, worked examples, test
cases and hints ladders), mapped to its mastery criteria, with no solution anywhere.

## How to work here

- **Routing:** run `STEPS.md` in order against `CHECKLIST.md`, only for a milestone whose `Exercises`
  flag is not `N/A`. Read `project-management/src/04-EXERCISES/CLAUDE.md` and `EX-MS000-TEMPLATE.md`
  before Step 2. A fact the spec rests on that needs looking up goes through
  `.claude/skills/research/SKILL.md` into `research/`.
- **Concrete steps:** Explain-first on the concept and its pitfalls → copy the template → what the set
  teaches and its constraints → each exercise (problem, interface, contract, worked examples, test
  cases, hints ladder) → the mastery map → reflection questions → `Status: Ready` → link the spec from
  the milestone → commit on the milestone branch.
- **Definition of done:** every exercise has an interface, a contract with its error cases, at least
  one normal, one boundary and one error test case, and three or more hint rungs; every mastery scenario
  that needs an exercise has one; the spec is `Ready` and linked from its milestone.

## Guardrails

- **Never write a solution into a spec.** Not in a hint, not in a worked example, not in a comment. A
  signature and its contract are allowed; a function body is not.
- **Take expected results from sources, never from running code.** A test that copies what the code
  printed proves only that the code agrees with itself.
- **Turn every predicted pitfall into a test case.** The learner's Explain-first predictions are the
  most valuable test cases in the set; each one appears as a `T#` row.
- **Keep C exercises inside the house rules.** C17, the Linux kernel coding style and the warning set
  in `code/docs/BUILD.md` apply to every exercise; a spec that needs an exception raises an ADR through
  `08-decisions` rather than granting it inline.
- **Keep `unsafe` out of Rust exercises** unless the milestone is about `unsafe` or FFI
  (`project-management/docs/SAFETY-GUIDE.md` → _Rust — the `unsafe` policy_).
- **Write one spec per milestone.** If the set will not fit, the milestone is too big; go back to
  `02-milestone-creation` or the map rather than writing a second spec.

## Output & naming

- **Writes:** `project-management/src/04-EXERCISES/EX-MS###-<TOPIC>.md` from `EX-MS000-TEMPLATE.md`,
  and the spec's link in the milestone file.
- The folder's `CLAUDE.md` → Output & naming owns the filename pattern and the `T#` test-case IDs.
- Exercise directories named in the spec follow `code/src/c/ms###-<kebab>/` and
  `code/src/rust/crates/ms###_<snake>/` (created later, in `10-study-and-build`).
- Commit on the milestone branch; scope `pm`; dates DD/MM/YYYY.
