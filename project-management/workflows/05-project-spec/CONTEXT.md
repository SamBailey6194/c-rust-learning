# Workflow: Project Spec

**Last Updated**: 27/09/2026

A capstone project without a written finish line keeps growing: the shell gains job control, the
allocator gains threads, and nothing is ever done. Fixing the scope, the reference behaviour and the
acceptance scenarios before the first line of code turns a project into a sequence of milestones that
each end in evidence, and turns every new idea into a stretch goal instead of a delay.

## Directory Tree

```text
project-management/workflows/05-project-spec/
├── CONTEXT.md · CLAUDE.md   ← orientation (this file) · operating rules for the workflow
├── STEPS.md                 ← ordered steps, each closing on a "Done when" line
└── CHECKLIST.md             ← the gate ticked before the workflow counts as complete
```

## When to use this

**Entry condition: the milestone's `Project` flag is not `N/A`.** A milestone whose flag reads `N/A`
skips this gate (`project-management/docs/planning/MILESTONES.md` → _The FLAGS table_).

- **At the first milestone of a project**, to write the spec: the P2 projects (an allocator, a Unix
  shell, a small libc subset), the P3 Rust port of a P2 project and its FFI crate, a P4 kernel module
  project.
- **At each later milestone of the same project**, to update the spec's milestone table and confirm the
  part being started still matches it; no second spec is written.
- **When acceptance turns out to be wrong**, to correct it before the next part is built, with the old
  wording kept in an HTML comment.

## Key concepts

- **One spec per project, named for its first milestone.** Later milestones of the project cite that
  file (`project-management/src/05-PROJECTS/CLAUDE.md` → Output & naming).
- **Scope has two sides.** _In scope_ is what the project does; _out of scope_ is what it deliberately
  does not, and why. The second list is what stops the project growing.
- **Interface or behaviour, then parts.** A library project gives its headers and contracts; a program
  gives its command-line behaviour. The parts and their responsibilities are a map, not a design: which
  pieces exist and what each owns.
- **Cut into provable milestones.** Every part is its own milestone of 8 points or fewer, and
  each milestone closes on its own verification record. A whole project is usually an epic; the spec is
  where it is cut.
- **A reference behaviour is the oracle.** A shell is compared with `dash` or `bash` for the features in
  scope, a libc function with its man page and the C standard, a Rust port with the C project's own
  tests.
- **Acceptance is fixed up front.** Gherkin scenarios `A1`, `A2`, ... naming exact commands; the project
  is finished when they pass, not before and not with new scope added.
- **Allocators need a memory-testing plan.** valgrind intercepts any globally exported `malloc` and
  `free`, the learner's own included, and AddressSanitizer replaces them too, so an allocator spec states
  how its tests stay meaningful.

## Cross-references

### Governing documents

- `project-management/src/05-PROJECTS/CLAUDE.md` — naming, status words and the no-solutions rule
- `project-management/src/05-PROJECTS/PROJ-MS000-TEMPLATE.md` — the scaffold
- `project-management/src/01-ROADMAP/ROADMAP.md` — the P2 and P3 exit gates the projects serve

### Related reading

- `project-management/docs/SAFETY-GUIDE.md` — memory-bug classes and the `unsafe` policy for FFI parts
- `project-management/workflows/02-milestone-creation/` — where each later part becomes a milestone
- `project-management/workflows/04-exercise-design/` — exercises that rehearse a part before it is built
- `project-management/workflows/08-decisions/` — hard-to-reverse design choices inside a project
- `code/workflows/04-ffi-bridge/` — how an FFI part is built
