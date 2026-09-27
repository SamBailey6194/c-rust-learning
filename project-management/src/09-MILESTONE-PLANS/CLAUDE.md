@./CONTEXT.md

# CLAUDE.md — project-management/src/09-MILESTONE-PLANS/

Read order: `.claude/CLAUDE.md` → `.claude/MEMORY.md` → this folder's `CONTEXT.md` (what a plan
records, why the build-order prefix exists — imported above) → this file →
`project-management/workflows/09-milestone-plans/STEPS.md`.

## Purpose (one line)

The plan store — one `<exec-order>-PLAN-MS###-<DESCRIPTOR>.md` per milestone: resources, exercise
order, verification commands, risks and deferrals, written before study starts.

## How to work here

- **Routing:** plans are written through `project-management/workflows/09-milestone-plans/`
  (`STEPS.md` + `CHECKLIST.md`), after `08-decisions` has settled the milestone's ADRs. The As-Built
  summary is filled later by `project-management/workflows/11-verification/`, not by the plan's author.
- **Concrete steps:** Explain-first with the learner → read the milestone, its sprint, its flagged
  specs, its ADRs and any `DEFERRED (MS###)` entries → work out the exec-order → copy
  `00-PLAN-MS000-TEMPLATE.md` to the name below → fill every section marked "always", keep or delete
  the "if it applies" ones with a reason → leave As-Built as a pending stub → learner explains the plan
  back → link the milestone to the plan and the plan to its inputs.
- **Definition of done:** named to the pattern with a prefix that matches the current build order;
  every concept has a cited primary source; every exercise has a spec, a location and a code workflow;
  every mastery criterion has a raw command and a script; every deferral is in `DEFERRED.md`; the
  As-Built stub is present; British English; dates DD/MM/YYYY.

## Guardrails

- **Renumber prefixes when the build order changes, in one pass.** The prefix is only useful while it
  matches the order; rename every affected plan with `git mv` and repoint every citation in the same
  commit.
- **Plan the route; never write the solution.** No exercise code, no worked answers — a plan that
  solves the exercise has removed the learning. Hints belong in the exercise spec, code in `code/src/`.
- **Name commands that run on this host.** Every raw command and script works with the toolchain in
  `how-to/docs/TOOLCHAIN.md`; a command that needs a missing tool is a risk with a `GAPS.md` entry, not
  a verification step. Cargo runs from inside `code/src/rust/`, so the pinned toolchain applies.
- **Mirror the milestone's status; do not invent one.** The words belong to
  `project-management/docs/planning/MILESTONES.md`.
- **Leave As-Built empty until verification.** Filling it early records intent as if it were evidence.
- **Route deferrals and blockers to their registers.** Out-of-scope topics → `DEFERRED.md` with a
  `DEFERRED (MS###)` marker; active blockers → `GAPS.md`. The plan links to them; it does not replace them.

## Output & naming

- **Hand-written:** every `<exec-order>-PLAN-MS###-<DESCRIPTOR>.md`, copied from the template.
- **Template:** `00-PLAN-MS000-TEMPLATE.md` — the copy source; keep it, never fill it in or rename it.
- **Generated:** none.
- Filename `<exec-order>-PLAN-MS###-<DESCRIPTOR>.md`:
  - `<exec-order>` — two digits, zero-padded, counted from `01`: the milestone's position in the build
    order of the whole roadmap (phases in `ROADMAP.md` order, then the order the sprint records schedule
    the milestones). `00` is reserved for the template. Renumbered whenever that order changes.
  - `MS###` — the milestone number, three digits; never changes.
  - `<DESCRIPTOR>` — SCREAMING-KEBAB-CASE, normally the milestone's own title. MS001's plan, not yet
    written, is planned as `01-PLAN-MS001-TOOLCHAIN-READY.md`.
- One plan per milestone. Inside a plan: artefacts by full repo-relative path in backticks, dates
  DD/MM/YYYY.
