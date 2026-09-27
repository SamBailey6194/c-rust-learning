@./CONTEXT.md

# CLAUDE.md — project-management/workflows/12-review-and-reflect/

Read order: `.claude/CLAUDE.md` → `.claude/MEMORY.md` → this folder's `CONTEXT.md` (when to use, review
versus reflection, the registers — imported above) → this file → `STEPS.md` then `CHECKLIST.md`.

## Purpose (one line)

Close a milestone's learning: run the content review into `11-REVIEWS`, record the corrected
misconceptions and what is expensive to relearn in `12-FINDINGS`, route the rest to the right register,
and write the sprint Retrospective when the sprint ends.

## How to work here

- **Routing:** run `STEPS.md` in order against `CHECKLIST.md`. The content review follows
  `code/workflows/05-review/`; required actions go to `code/workflows/07-debug/` (behaviour changes) or
  `code/workflows/08-refactor/` (behaviour-preserving). Read `project-management/src/11-REVIEWS/CLAUDE.md`
  and `project-management/src/12-FINDINGS/CLAUDE.md` before writing either record.
- **Concrete steps:** the learner self-reviews first → run `05-review` over the milestone diff → confirm
  the review record → act on required actions and re-verify what they touched → gather misconceptions
  from `PROGRESS.md` entries and bug records → write the finding → route to `GAPS.md`, `DEFERRED.md`,
  `.claude/MEMORY.md` → schedule re-drills → write the Retrospective if the sprint is ending → commit.
- **Definition of done:** a complete review record exists for the milestone with every required action
  resolved or routed; a finding record exists with misconceptions, expensive-to-relearn items and
  carried-forward rows; each register holds only its own kind of entry; a closing sprint has its
  Retrospective; `CHECKLIST.md` is fully ticked.

## Guardrails

- **Ask the learner to review their own code first.** What they flag before Claude does shows what they
  can already see, and the gap between the two lists is itself a finding.
- **Point at `code/docs/`; leave the edit to the learner.** A review names the section that applies and
  why; it does not rewrite the learner's code.
- **Write the finding even when little went wrong.** An empty milestone is rare, and "nothing found" is
  itself evidence that the next plan can lean on.
- **Keep the registers apart.** Blockers to `GAPS.md`, parked topics to `DEFERRED.md`, working patterns
  to `.claude/MEMORY.md`; an entry in the wrong register is an entry nobody reads at the right time.
- **Re-verify from the top after any fix.** A required action that changes code sends the milestone
  back through the whole of `11-verification` before it moves to `13-pr-and-merge`; a partial rerun
  proves only the part that was rerun.
- **Record misconceptions without judgement.** A finding says what was believed and what is true, with a
  source; it is a map for the next milestone, not a mark.

## Output & naming

- **Writes:** the review record in `project-management/src/11-REVIEWS/` (through `05-review`), the finding
  record in `project-management/src/12-FINDINGS/`, the Retrospective section of the sprint record in
  `project-management/src/03-STUDY-SPRINTS/`, and register entries.
- Filenames follow each folder's `CLAUDE.md` → Output & naming, which wins over this summary:
  `REVIEW-MS###-<DESCRIPTOR>.md` from `REVIEW-MS000-TEMPLATE.md`, and
  `FINDING-MS###-<DESCRIPTOR>-DD-MM-YYYY.md` from `FINDING-MS000-TEMPLATE.md`; descriptors
  SCREAMING-KEBAB-CASE; dates DD/MM/YYYY in prose, DD-MM-YYYY in filenames.
- Commit scope `pm`, per `project-management/docs/git/COMMITS.md`.
