@./CONTEXT.md

# CLAUDE.md — code/workflows/

Read order: `.claude/CLAUDE.md` → `.claude/MEMORY.md` → this folder's `CONTEXT.md` (the eight workflows,
their families and boundaries, imported above) → this file → the target workflow's `CONTEXT.md`, then its
`CLAUDE.md`.

## Purpose (one line)

The step-by-step procedures (`01`–`08`) for building, testing, verifying, debugging and improving the C and
Rust exercises under `code/src/`, each a numbered folder of `CONTEXT.md`, `CLAUDE.md`, `STEPS.md` and
`CHECKLIST.md`.

## How to work here

- **Routing:** pick the workflow by task — a new C exercise → `01`; the test loop inside any build → `02`;
  a new crate or a C → Rust port → `03`; a boundary between C and Rust (P3) → `04`; a review before merge → `05`;
  a sanitiser, valgrind or analyzer pass → `06`; a wrong result or a crash → `07`; restructuring working
  code → `08`. Read its `CONTEXT.md` first and enter `STEPS.md` only when the learner asks to run it.
- **Tutor mode:** before helping, ask how the learner plans to approach the problem; explain concepts and
  ask guiding questions; do not write exercise solutions unless explicitly asked. Reviews point at the
  relevant `code/docs/` section rather than rewriting the learner's code.
- **Routing frontmatter:** every `STEPS.md` and `CHECKLIST.md` carries `workflow` / `phase` / `skills`.
  `skills` lists only folders under `.claude/skills/` (`teach`, `handoff`, `research`); `wait-what` is
  invoked by the learner alone, so no workflow lists it.
- **Concrete steps (editing a workflow):** read all four files of the target → make the smallest change →
  keep `STEPS.md` and `CHECKLIST.md` step-for-step in line → check every command against
  `code/docs/BUILD.md` and `code/src/scripts/` → run `bash code/src/scripts/audits/docs-length.sh` and
  `bash code/src/scripts/audits/docs-pairing.sh` → update the family tables in `CONTEXT.md` if a purpose
  changed.
- **Definition of done:** the workflow reads coherently end to end, every command matches the build
  contract, every cited path exists (or is labelled planned), and this folder's `CONTEXT.md` lists it
  correctly.

## Guardrails

- **Keep each workflow file within 300 cloc code lines** (`code/docs/DOCUMENTATION-LENGTH.md`); split an
  oversized `STEPS.md` rather than let it sprawl.
- **Teach the raw command first, then name the script that wraps it.** The command is the lesson; Claude's
  own verification and CI run through `code/src/scripts/`.
- **Append, never renumber.** A new workflow takes the next free number and is registered in this
  folder's `CONTEXT.md`, `code/REFERENCES.md` and the root `REFERENCES.md` in the same change.
- **Route, don't restate.** Build flags and targets → `code/docs/BUILD.md`; gates →
  `how-to/workflows/03-quality-gates/`; status vocabulary → `project-management/docs/planning/MILESTONES.md`;
  toolchain versions → `how-to/docs/TOOLCHAIN.md`; branches and commits → `project-management/docs/git/`.
- **Report a gate that could not run as COULD NOT RUN (exit 2), never as clean.** A missing tool is not
  a pass.
- **Keep kernel work inside QEMU.** No workflow, current or planned, instructs `insmod` or a kernel install
  on the host (`.claude/CLAUDE.md` owns this rule).

## Output & naming

- **Hand-written:** every `CONTEXT.md`, `CLAUDE.md`, `STEPS.md` and `CHECKLIST.md` in the workflow folders.
- **Produced by following them:** exercises in `code/src/c/msNNN-<kebab>/`, crates in
  `code/src/rust/crates/msNNN_<snake>/`, records in `project-management/src/11-REVIEWS/` and
  `project-management/src/13-BUGS/`, and learning notes under `learning/`.
- Workflow folders `NN-kebab-name/` holding exactly four `SCREAMING-SNAKE-CASE.md` files; frontmatter
  `workflow: NN-kebab-name` and `phase:` one of `build`, `verify`, `diagnose-and-improve`.
