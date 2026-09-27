@./CONTEXT.md

# CLAUDE.md — project-management/src/08-DECISIONS/

Read order: `.claude/CLAUDE.md` → `.claude/MEMORY.md` → this folder's `CONTEXT.md` (the ADR listing,
what a record holds, the five scaffold defaults — imported above) → this file →
`project-management/workflows/08-decisions/STEPS.md`.

## Purpose (one line)

The decision store — one immutable `ADR-MS###-<DECISION>-DD-MM-YYYY.md` per hard-to-reverse choice,
arguing its context, options, decision and consequences with cited sources.

## How to work here

- **Routing:** ADRs are written and checked through `project-management/workflows/08-decisions/`
  (`STEPS.md` + `CHECKLIST.md`). A contested option is grounded first with the `research` skill
  (`.claude/skills/research/SKILL.md`), which writes a note under `research/` for the ADR to cite. A
  Rust toolchain bump arrives here from `how-to/workflows/04-toolchain-updates/`.
- **Concrete steps:** Explain-first with the learner → confirm the driving `MS###` → research anything
  factual → copy `ADR-MS000-TEMPLATE.md` → name it per Output & naming → Context (neutral, facts
  checked on the day) → at least two honest options with pros and cons → Decision with its deciding
  factor and what would reopen it → Consequences (Positive / Negative / Follow-on) → Sources with URLs
  and check dates → Status `Proposed` → learner signs off → `Accepted` → list it under the driving
  milestone's Decisions → add it to the tree in `CONTEXT.md`.
- **Definition of done:** named to convention; every metadata row filled; at least two options argued
  fairly; the Decision names its deciding factor; every claim about a tool, standard or version cites
  a primary source or a host command; any supersession linked both ways by full filename; the
  `CONTEXT.md` tree updated; British English; dates DD/MM/YYYY in prose.

## Guardrails

- **Never edit an Accepted decision.** The only edits an Accepted record takes are the Status flip to
  `Superseded` or `Deprecated` and its "Superseded by" row. A falsified premise, a factual slip found
  later, or a change of mind is a new ADR that supersedes the old one.
- **Argue here; enforce in the guide.** An ADR explains why; the rule itself lives in its owning file
  (`code/docs/BUILD.md`, `code/docs/C-CODING-PRINCIPLES.md`, `code/docs/TESTING.md`,
  `code/docs/RUST-CODING-PRINCIPLES.md`, `how-to/docs/TOOLCHAIN.md`). A record that states a rule
  without arguing it belongs in the guide instead.
- **Anchor every ADR to a milestone.** The `MS###` is the milestone whose work surfaced the choice; a
  decision invented in the abstract has no evidence behind it.
- **Check facts on the day, and say when you could not.** Version support moves faster than memory:
  run the tool (`--version`, a test compile, `man`) or read the primary docs, cite them under Sources,
  and label anything unverified as unverified.
- **Cite and link; do not paste.** This repository is public. Paraphrase the source and give the URL;
  keep quotations to a phrase.
- **One decision per record.** Two independent choices make two ADRs, even when they surface together.
- **Keep the folder flat and unindexed.** No sub-folders and no `ADR-###` counter; the tree in
  `CONTEXT.md` is the listing.

## Output & naming

- **Hand-written:** every `ADR-MS###-<DECISION>-DD-MM-YYYY.md`, copied from the template.
- **Template:** `ADR-MS000-TEMPLATE.md` — the copy source; keep it, never fill it in or rename it.
- **Generated:** none.
- Filename `ADR-MS###-<DECISION>-DD-MM-YYYY.md`: `MS###` is the driving milestone (three digits,
  zero-padded); `<DECISION>` names the choice in SCREAMING-KEBAB-CASE, subject first then outcome
  (`C-STANDARD-C17`, `BUILD-SYSTEM-GNU-MAKE`); the date is the day the decision was made. Two ADRs from
  one milestone on one day differ by `<DECISION>`.
- Status values: `Proposed` · `Accepted` · `Superseded` · `Deprecated` — the ADR's own lifecycle,
  separate from milestone statuses (`project-management/docs/planning/MILESTONES.md`).
- Inside a record: other ADRs by full filename, other artefacts by full repo-relative path in
  backticks, dates DD/MM/YYYY.
