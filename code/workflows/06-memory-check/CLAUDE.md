@./CONTEXT.md

# CLAUDE.md — code/workflows/06-memory-check/

Read order: `.claude/CLAUDE.md` → `.claude/MEMORY.md` → this folder's `CONTEXT.md` (what each of the three
tools sees and misses, what clean means — imported above) → this file → `STEPS.md` then `CHECKLIST.md`.

## Purpose (one line)

Run AddressSanitizer + UBSan, valgrind memcheck and `-fanalyzer` over C code, read what they report, and
loop until all three are clean.

## How to work here

- **Routing:** run `STEPS.md` in order against `CHECKLIST.md`. Each finding is fixed through
  `code/workflows/07-debug/` (a test that reproduces it, then a minimal fix). A tool that will not start is
  an environment problem: `how-to/workflows/05-debugging-environment/`.
- **Tutor mode:** when a report appears, ask the learner to read it aloud first — the headline, the first
  frame in their own file, the allocation or free stack — and to say what they think happened before
  Claude explains. Point at `code/docs/MEMORY-SAFETY.md`; do not write the fix unless explicitly asked.
- **Concrete steps:** confirm tests green → `make san` and read → `make memcheck` and read → `make lint`
  and read → fix each finding through `07-debug` → re-run all three until clean.
- **Definition of done:** `make san`, `make memcheck` and `make lint` all exit 0 for the code in scope,
  confirmed through `code/src/scripts/c/san.sh`, `memcheck.sh` and `lint.sh`; every finding was fixed at
  its cause, not hidden.

## Guardrails

- **Read the first report first.** Later reports are often knock-on damage from the first; fix one, re-run,
  then read again.
- **Never run a sanitised binary under valgrind.** `build/san/` is for `make san` only; valgrind runs the
  plain build.
- **Fix the cause, never the symptom.** No suppression files for the learner's own code, no dropped
  sanitiser or `-fanalyzer` flag, no `free()` added only to make a leak report go away without knowing
  who owns the block.
- **Treat an analyzer warning as real until shown otherwise.** A suspected false positive is argued in
  review (`code/workflows/05-review/`), usually by restructuring the code so the safe path is obvious.
- **Report a tool that could not run as COULD NOT RUN (exit 2).** A missing valgrind is not a clean
  valgrind run.

## Output & naming

- **Produced by following it:** fixes and regression tests in the exercise folder under `code/src/c/`;
  build output only in its gitignored `build/`, `build/san/` and `build/lint/`.
- Results for a milestone are recorded by `project-management/workflows/11-verification/` in
  `project-management/src/10-PROGRESS/`, not here.
- Workflow files `SCREAMING-SNAKE-CASE.md`, frontmatter `workflow: 06-memory-check`, `phase: verify`.
