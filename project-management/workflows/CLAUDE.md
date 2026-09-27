@./CONTEXT.md

# CLAUDE.md — project-management/workflows/

Read order: `.claude/CLAUDE.md` → `.claude/MEMORY.md` → this folder's `CONTEXT.md` (Explain-first, the
cadence and the thirteen-workflow index, imported above) → this file → the target `NN-kebab-name/`
workflow's `CONTEXT.md` and `CLAUDE.md`, then its `STEPS.md` and `CHECKLIST.md`.

## Purpose (one line)

The ordered PM playbook — thirteen numbered procedures (from `01-roadmap-map` to `13-pr-and-merge`) that take a
concept from a phase map to a merged, verified, reflected-on milestone.

## How to work here

- **Routing:** never freehand a PM artefact. Open the matching `NN-kebab-name/` folder and run its
  `STEPS.md` in order against its `CHECKLIST.md`; the numbering is the running order, and the root
  `REFERENCES.md` says which `src/` folder each one writes and what it pairs with. Load the skill a
  step names (`.claude/skills/research/SKILL.md` for a research node, `.claude/skills/teach/SKILL.md`
  in `10`, `.claude/skills/handoff/SKILL.md` when a session ends mid-workflow).
- **Explain-first:** every workflow opens with the learner's three moves (what they know, the pitfalls
  they predict, the concept explained back) as `CONTEXT.md` → _Explain-first_ describes. Ask, wait,
  record the answers; do not answer for the learner.
- **Concrete steps:** read the workflow's `CONTEXT.md` → check its entry condition (a flag not `N/A`, a
  previous workflow complete) → follow `STEPS.md` step by step, each to its _Done when_ line → write the
  artefact into the `src/` folder the workflow names, from that folder's template → tick every
  `CHECKLIST.md` item → commit by explicit path.
- **Definition of done:** the checklist is fully ticked, the artefact sits in the correct numbered
  `src/` folder under that folder's naming pattern, and the next workflow's entry conditions are met.

## Guardrails

- **Take the gates in order.** Do not start `10` for a milestone before its `09` plan exists, and do not
  start the next milestone before this one is merged, `Blocked` or `Parked`
  (`project-management/docs/planning/CADENCE.md`).
- **Do not batch across milestones.** Writing five milestones and then five exercise specs plans every
  one of them against the same early understanding, which throws away the compounding the loop exists
  for.
- **Read the flag before demanding the artefact.** A spec workflow (`04`–`07`) runs only when its flag is
  not `N/A`, and a checklist item about a gate's artefact applies only to milestones whose flag is set.
- **Keep each workflow to its own output.** A spec workflow does not write code, a planning workflow does
  not verify, and `11` does not fix what it finds; each hands forward.
- **Commit only when the learner asks.** The commit steps in each `STEPS.md` say how to commit (by
  explicit path, in Conventional Commits form), not permission to; `.claude/CLAUDE.md` → Section 9
  owns that rule.
- **Keep the four-file shape.** Every workflow folder holds exactly `CONTEXT.md`, `CLAUDE.md`,
  `STEPS.md` and `CHECKLIST.md`, each within the instructional length cap
  (`code/docs/DOCUMENTATION-LENGTH.md`).
- **Treat these numbers as a sequence.** Inserting a workflow means renumbering every later one and sweeping
  every reference, `.claude/skills/` included, in the same change. Never renumber a `src/` folder to
  match.

## Output & naming

- **Hand-written:** `STEPS.md` and `CHECKLIST.md` in each folder, with `workflow` / `phase` / `skills`
  frontmatter (`skills` names only skills that exist in `.claude/skills/`, else `[]`); `CONTEXT.md` holds
  the tree and the key concepts.
- **Nothing here is generated**, and no artefact lives here: the artefacts these workflows produce are
  under `project-management/src/`, `learning/`, `research/` and `code/src/`.
- Workflow folders `NN-kebab-name/`; the `phase` value is the family in `CONTEXT.md`'s index, in lower
  case (`plan`, `specify`, `decide-and-plan`, `build`, `record`); steps are `### Step N — <verb phrase>`
  ending on an italic _Done when_ line.
