# Workflow: Exercise Design

**Last Updated**: 27/09/2026

An exercise invented at the keyboard tests whatever turned out to be easy to code, and its expected
results come from whatever the code printed. Specifying the set first, from the milestone's mastery
criteria and the pitfalls the learner predicted, means every exercise earns its place and every test
has an oracle that is not the code under test.

## Directory Tree

```text
project-management/workflows/04-exercise-design/
├── CONTEXT.md · CLAUDE.md   ← orientation (this file) · operating rules for the workflow
├── STEPS.md                 ← ordered steps, each closing on a "Done when" line
└── CHECKLIST.md             ← the gate ticked before the workflow counts as complete
```

## When to use this

**Entry condition: the milestone's `Exercises` flag is not `N/A`.** The flag is set at
`02-milestone-creation`; a milestone whose flag reads `N/A` skips this gate
(`project-management/docs/planning/MILESTONES.md` → _The FLAGS table_).

- After `03-sprint-planning` admits the milestone, and before `08-decisions` and `09-milestone-plans`.
- When `11-verification` or `12-review-and-reflect` shows an exercise tested the wrong thing, to correct
  the spec before the next attempt.

## Key concepts

- **One spec per milestone, several exercises in it.** The set runs from recall to extension: the first
  exercise checks the concept is there, the last stretches it. A second set for the same milestone means
  the milestone is two milestones.
- **Interface and contract, not implementation.** Each exercise gives the signature the tests call and
  its contract, error cases first; the body is the learner's, written in `10-study-and-build`.
- **The oracle comes from sources, not from code.** Worked examples and expected results come from the
  spec's reasoning, the man page or the C standard, so a test can disagree with the code.
- **Every interface has an error case.** NULL pointers, zero lengths, truncation, invalid input: a C
  function's contract is mostly its failure modes, and those are where the memory bugs hide.
- **Hints are a ladder, not a shortcut.** At least three rungs: back to the problem, the concept and
  where to read about it, an approach in prose. No rung is code.
- **The mastery map closes the loop.** Every mastery scenario that needs an exercise names one, and
  every exercise names the scenario it proves.
- **The code lands in its own folder.** A C exercise becomes `code/src/c/ms###-<kebab>/`, a Rust
  exercise a crate in `code/src/rust/crates/ms###_<snake>/`, each built through
  `code/workflows/01-c-exercise/` or `code/workflows/03-rust-exercise/`.

## Cross-references

### Governing documents

- `project-management/src/04-EXERCISES/CLAUDE.md` — naming, status words and the no-solutions rule
- `project-management/src/04-EXERCISES/EX-MS000-TEMPLATE.md` — the scaffold
- `project-management/docs/SAFETY-GUIDE.md` — which memory-bug classes an exercise should provoke

### Related reading

- `code/workflows/01-c-exercise/` · `code/workflows/03-rust-exercise/` — the workflows that build the set
- `code/docs/BUILD.md` · `code/docs/TESTING.md` — make targets, `check.h` and the Rust test layout
- `code/docs/C-CODING-PRINCIPLES.md` — the constraints every C exercise inherits
- `project-management/workflows/05-project-spec/` — the next spec workflow, if the Project flag is set
