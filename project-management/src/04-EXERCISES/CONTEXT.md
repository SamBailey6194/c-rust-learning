# project-management/src/04-EXERCISES/ — Exercise-Set Specs

**Last Updated**: 27/09/2026

Exercise-set specs — one `EX-MS###-<TOPIC>.md` per milestone whose Exercises flag runs. A spec
states each problem, its constraints, the interface the tests call, worked examples of expected
input and output, the test cases, and a hints ladder that nudges without solving. It holds **no
solutions**: the only solution to an exercise is the learner's own code in `code/src/`. The spec is
the oracle the tests are written from — expected results come from the spec, a man page or the C
standard, not from running the code — which is why it is written before any code exists.

## Directory Tree

```text
project-management/src/04-EXERCISES/
├── CONTEXT.md · CLAUDE.md    ← this pair: what an exercise spec is · how to write one
├── EX-MS000-TEMPLATE.md      ← exercise-set template — copied for each milestone's set
└── EX-MS###-<TOPIC>.md       ← one exercise set per milestone (none written yet)
```

## What each spec records

| Section | Holds |
| --- | --- |
| **Header table** | Milestone, track, code location, the code workflow that builds it, status, date |
| **What this set teaches** | Concepts, the mastery criteria it serves, the order the exercises climb in |
| **Constraints** | Standard, flags, allowed and banned library calls, memory and style rules |
| **Exercises** | Per exercise: problem, interface, contract, worked examples, test cases, hints ladder, stretch |
| **Mastery map** | Which exercise proves which of the milestone's mastery scenarios |
| **Reflection questions** | Questions answered in the learning note after the set is green |

## Where specs lead

A C exercise is built by `code/workflows/01-c-exercise/` in `code/src/c/ms###-<kebab>/`; a Rust
exercise by `code/workflows/03-rust-exercise/` in `code/src/rust/crates/ms###_<snake>/`. One
milestone can hold several exercise directories; the spec's header table lists them all.
`MS001` has no spec here: its `ms001-hello` pair was seeded with the repository as a smoke test.

## Cross-references

- `project-management/workflows/04-exercise-design/` — the procedure that writes here
- `code/workflows/01-c-exercise/`, `code/workflows/03-rust-exercise/` — the build side that consumes a spec
- `code/workflows/02-tdd-cycle/` — the test-first loop the test cases feed
- `code/docs/TESTING.md` — `check.h` and the test discipline the test cases are written for
- `project-management/src/02-MILESTONES/` — the milestone whose mastery criteria a spec serves
