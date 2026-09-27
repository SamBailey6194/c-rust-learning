@./CONTEXT.md

# CLAUDE.md — code/workflows/01-c-exercise/

Read order: `.claude/CLAUDE.md` → `.claude/MEMORY.md` → this folder's `CONTEXT.md` (the four gates, the
exercise folder shape, tutor mode — imported above) → this file → `STEPS.md` then `CHECKLIST.md`.

## Purpose (one line)

Take one C exercise from its `EX-MS###` spec to green tests, clean `san`, `memcheck` and `lint` runs, and a
recorded learning note — with the learner writing every line of the solution.

## How to work here

- **Routing:** run `STEPS.md` in order against `CHECKLIST.md`. Steps 3–4 run `code/workflows/02-tdd-cycle/`;
  reading a sanitiser or valgrind report runs `code/workflows/06-memory-check/`; a wrong result the
  learner cannot explain runs `code/workflows/07-debug/`. The `teach` skill (`.claude/skills/teach/SKILL.md`)
  owns the learning-note loop in Step 9.
- **Tutor mode:** before any help, ask how the learner plans to approach the exercise. Explain concepts,
  ask guiding questions and point at the `code/docs/` section that answers them; do not write the
  exercise's functions or tests unless the learner explicitly asks for that. Scaffolding the learner
  asks for — the folder, the Makefile's three variables — is fine to show.
- **Concrete steps:** read the spec and restate the objective → create the exercise folder, its pair and
  Makefile → write failing tests → implement → `make test` → `make san` → `make memcheck` → `make lint` →
  record the learning note and hand back to the PM layer.
- **Definition of done:** all four make targets exit 0 for the exercise; the folder has its
  `CONTEXT.md` + `CLAUDE.md`; `code/src/c/CONTEXT.md` lists it; a learning note exists; `CHECKLIST.md` is
  fully ticked.

## Guardrails

- **Write no solution code unprompted.** The exercise exists so the learner writes it; a working answer
  from Claude removes the learning it was set for.
- **Run every gate, in order.** A green `make test` is not a clean exercise; `san`, `memcheck` and `lint`
  each look for something the others miss.
- **Fix warnings, never silence them.** No `#pragma GCC diagnostic`, no dropped flag, no cast added only
  to quieten `-Wconversion` without understanding the conversion.
- **Keep ASan and valgrind apart.** `make san` and `make memcheck` use separate builds for a reason;
  never run a sanitised binary under valgrind.
- **Teach the raw command, verify with the script.** Show `make -C ...` first; Claude's own verification
  runs `code/src/scripts/c/*.sh` and reports a missing tool as COULD NOT RUN (exit 2).

## Output & naming

- **Produced by following it:** `code/src/c/msNNN-<kebab>/` with `CONTEXT.md`, `CLAUDE.md`, `Makefile`,
  `<name>.h`, `<name>.c`, `main.c` and `test_<name>.c`; build output in its `build/` (gitignored, never
  committed); a note under `learning/`.
- `NNN` is the spec's milestone number; `<kebab>` names the exercise in lower-case kebab-case.
- Commits use scope `c` (`project-management/docs/git/COMMITS.md`) on an `ms###/<short-kebab>` branch.
- Workflow files `SCREAMING-SNAKE-CASE.md`, frontmatter `workflow: 01-c-exercise`, `phase: build`.
