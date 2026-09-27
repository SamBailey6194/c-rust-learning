@./CONTEXT.md

# CLAUDE.md — how-to/workflows/

Read order: `.claude/CLAUDE.md` → `.claude/MEMORY.md` → `how-to/CONTEXT.md` → this folder's `CONTEXT.md`
(workflow catalogue, imported above) → this file → the target workflow's `CONTEXT.md`/`CLAUDE.md`.

## Purpose (one line)

The six operational workflows in five families — set up (`01`), run (`02`–`03`), maintain (`04`),
diagnose (`05`), author (`06`) — each a four-file procedure for one recurring job on this machine.

## How to work here

- **Routing:** pick the numbered workflow that matches the task; read its `CONTEXT.md` (when to use,
  governing documents) before executing `STEPS.md`, then verify against `CHECKLIST.md`. The frontmatter
  `skills:` list names the skills to load (`/teach`, `/handoff`, `/research`).
- **Concrete steps:** to add or change a workflow, edit its four files together → keep every step ending
  on an italic `_Done when …_` line → keep `STEPS.md` closing with `## Update context files` then
  `## Completion`, and `CHECKLIST.md` with `## Context` then `## Definition of Done` → update the family
  tables in this folder's `CONTEXT.md` and the tables in `how-to/REFERENCES.md`.
- **Definition of done:** `STEPS.md` executes cleanly end to end on this machine; `CHECKLIST.md` has a box
  per step outcome; every cross-reference resolves; each file is ≤ 300 cloc code lines.

## Guardrails

- **Keep the four-file shape.** Every workflow folder holds exactly `CONTEXT.md`, `CLAUDE.md`, `STEPS.md`
  and `CHECKLIST.md`; the two execution files do different jobs and neither replaces the other.
- **Append, never renumber.** A new workflow takes the next free number (07 to 12 are reserved for the
  planned workflows listed in `CONTEXT.md`); an existing number never changes.
- **Respect the hard gates.** Branch naming (`project-management/docs/git/BRANCHES.md`) is settled before
  the first commit in any workflow that commits.
- **Teach the raw command, then name the script.** Steps show the `gcc`/`make`/`cargo` command first and
  the `code/src/scripts/` wrapper second; Claude's own verification runs the scripts.
- **Only real skills in frontmatter.** `skills:` lists names from `.claude/skills/` (teach, handoff,
  research) or is `[]`; `wait-what` is invoked by the learner alone, so no workflow lists it.
- **Cite the gate list, never copy it.** `how-to/workflows/03-quality-gates/` owns it.

## Output & naming

- **Hand-written:** every file here; nothing generated.
- Workflow folders are `NN-kebab-name/`; frontmatter `workflow: NN-kebab-name`, `phase:` the family in
  lower case (`set-up`, `run`, `maintain`, `diagnose`, `author`).
- Steps are `### Step N — <verb phrase>`; checklist items are grouped under the same step headings.
