@./CONTEXT.md

# CLAUDE.md — project-management/docs/planning/

Read order: `.claude/CLAUDE.md` → `.claude/MEMORY.md` → `project-management/docs/CONTEXT.md` → this
folder's `CONTEXT.md` (which file owns what, imported above) → this file → the one sub-document that
matches the artefact in hand.

## Purpose (one line)

The three planning sub-documents — `CADENCE.md`, `MILESTONES.md`, `SPRINTS.md` — behind the thin
`project-management/docs/PLANNING-GUIDE.md` index.

## How to work here

- **Routing:** these are reference guides, not artefacts. Enter via
  `project-management/docs/PLANNING-GUIDE.md`, read the sub-document that matches the artefact being
  written, and edit it only when the convention itself changes. A milestone, sprint or map is written
  under `project-management/src/` by its workflow, never here.
- **Concrete steps:** edit the owning sub-document → check the other two do not now contradict it →
  update `project-management/docs/PLANNING-GUIDE.md` and this folder's `CONTEXT.md` if what a file owns
  changed → check any workflow that cites a changed heading still resolves → confirm each file is
  still within 300 cloc code lines (`bash code/src/scripts/audits/docs-length.sh`).
- **Definition of done:** each convention is stated in exactly one of the three files; the ownership
  table in `CONTEXT.md` and the index table in `PLANNING-GUIDE.md` both match; every cited workflow
  number and path resolves; British English throughout.

## Guardrails

- **State each tunable figure once.** Sprint length, capacity (13 points) and grace (16 points) live in
  `CADENCE.md` only; everything else points there. Two copies drift the first time one is tuned.
- **Keep the milestone status vocabulary in `MILESTONES.md` only.** Changing a status word here means
  sweeping every milestone record and every file that cites it in the same commit.
- **Respect the ownership split.** A milestone convention added to `SPRINTS.md` is one nobody writing a
  milestone will find. A fact that genuinely serves two files belongs in `CADENCE.md`.
- **Describe the process; let the workflows execute it.** Do not restate a workflow's `STEPS.md` here;
  cite the workflow by path.
- **Never rename an H2 that other files cite.** `CADENCE.md` → _Sprint capacity — the trigger_ and
  `MILESTONES.md` → _Statuses_ and _The FLAGS table_ are cited by name across the repository; add a
  heading rather than rewording one.

## Output & naming

- **Hand-written:** `CADENCE.md`, `MILESTONES.md`, `SPRINTS.md`; nothing here is generated.
- Files `SCREAMING-SNAKE-CASE.md` with `type: guide` frontmatter and the standard metadata line; the
  folder is `kebab-case/`.
- Milestones cited as `MS###`, sprints as `SPRINT-##`; dates DD/MM/YYYY in prose.
- Commit scope `pm` (`project-management/docs/git/COMMITS.md`).
