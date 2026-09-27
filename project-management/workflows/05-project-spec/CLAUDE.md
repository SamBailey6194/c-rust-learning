@./CONTEXT.md

# CLAUDE.md — project-management/workflows/05-project-spec/

Read order: `.claude/CLAUDE.md` → `.claude/MEMORY.md` → this folder's `CONTEXT.md` (entry condition, key
concepts, governing documents — imported above) → this file → `STEPS.md` then `CHECKLIST.md`.

## Purpose (one line)

Specify a capstone project (scope, interface or behaviour, parts, milestones, acceptance, test strategy,
stretch goals and risks), so it finishes on evidence rather than growing indefinitely.

## How to work here

- **Routing:** run `STEPS.md` in order against `CHECKLIST.md`, only for a milestone whose `Project` flag
  is not `N/A`. Read `project-management/src/05-PROJECTS/CLAUDE.md` and `PROJ-MS000-TEMPLATE.md` before
  Step 2. Reference behaviour that needs looking up goes through `.claude/skills/research/SKILL.md`; a
  hard-to-reverse design choice goes to `project-management/workflows/08-decisions/`.
- **Concrete steps:** Explain-first on what the program needs → copy the template, or open the existing
  spec for a later part → scope and out of scope → interface or behaviour and the parts → cut the
  milestones → acceptance scenarios with exact commands → test strategy and reference behaviour →
  stretch goals and risks → `Status: Ready` → link from the milestone → commit.
- **Definition of done:** scope and out of scope both written; every acceptance scenario names a command
  and a result; every part is a milestone of 8 points or fewer; every C part names its memory gates, and
  an allocator states its memory-testing plan; no solution code; linked from every milestone it spans.

## Guardrails

- **Decide "finished" before starting.** Acceptance is fixed here; an idea that arrives mid-build goes to
  Stretch goals or `DEFERRED.md`, never into scope.
- **Never write the solution.** Interfaces, behaviour and acceptance only; the parts table says what each
  piece is responsible for, not how it works.
- **Cut, do not stretch.** A part estimated at more than 8 points splits into smaller parts; a project that
  cannot be cut into provable parts is not ready to start.
- **Name a reference behaviour or a source for every expected result.** Expected output that nobody can
  check against anything is invented.
- **Plan allocator testing explicitly.** A global `malloc` replaced by the learner's own is intercepted
  by valgrind and collides with AddressSanitizer; the spec says which of the options in `STEPS.md`
  Step 5 it takes.
- **Write one spec per project.** Later parts update this spec's milestone table; they never start a second
  spec.

## Output & naming

- **Writes:** `project-management/src/05-PROJECTS/PROJ-MS###-<NAME>.md` from `PROJ-MS000-TEMPLATE.md`
  (the number of the project's first milestone), and the spec's link in each milestone it spans.
- The folder's `CLAUDE.md` → Output & naming owns the filename pattern and the `A#` scenario IDs.
- Commit on the milestone branch; scope `pm`; dates DD/MM/YYYY.
