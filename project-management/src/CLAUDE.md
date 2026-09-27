@./CONTEXT.md

# CLAUDE.md — project-management/src/

Read order: `.claude/CLAUDE.md` → `.claude/MEMORY.md` → this folder's `CONTEXT.md` (the four tiers,
the full tree, frozen numbering, zero-ID templates, where each artefact lives — imported above) →
this file → the target numbered folder's `CONTEXT.md` and `CLAUDE.md`.

## Purpose (one line)

The learning artefact store — roadmap, milestones, sprints, specs, decisions, plans and records,
filed in numbered `NN-.../` folders across four tiers: plan (01–03), specify (04–07), decide & plan
(08–09) and record (10–13).

## How to work here

- **Routing:** start from the matching `project-management/workflows/NN-.../` procedure
  (`STEPS.md` + `CHECKLIST.md`); the root `REFERENCES.md` owns the workflow-to-folder table. The
  procedure names the folder; **the target folder's `CLAUDE.md` → Output & naming owns the
  filename**, so a procedure that restates a pattern is stating a rule it does not own.
- **Concrete steps:** read the workflow `STEPS.md` → open the target folder's `CLAUDE.md` → copy
  its zero-ID template to the next free ID → fill it, citing the `MS###` and every artefact it
  rests on by full repo-relative path → tick the workflow `CHECKLIST.md` → refresh the folder's
  `CONTEXT.md` if it keeps an index.
- **Definition of done:** the artefact sits in the right numbered folder, is named to that
  folder's pattern, links to its `MS###`, has every `{PLACEHOLDER}` / `[PLACEHOLDER]` replaced and
  every `[EXAMPLE]` row deleted; British English; DD/MM/YYYY dates in prose.

## Guardrails

- **Treat the `NN-` numbers as frozen — append only.** Renumbering breaks every full-path citation
  in artefacts, commits and handoffs. A new folder takes the next free number at the end, with its
  own `CONTEXT.md` + `CLAUDE.md` pair and a matching workflow.
- **Never write an artefact free-hand.** A milestone, spec, ADR or record without its workflow
  skips the gate that workflow exists to hold. A fix to a typo or a broken link is a mechanical
  touch and needs no workflow. ADRs are the stricter exception: an `Accepted` ADR takes only its
  Status flip and its "Superseded by" row, so even a slip in one is corrected by a superseding ADR
  (`project-management/src/08-DECISIONS/CLAUDE.md`).
- **Explain first, then write.** Before a milestone, spec, map or ADR is drafted, ask the learner
  what they already know, what they expect to be hard, and have them explain the concept back.
  The artefact records their answers; it does not replace them.
- **Keep templates as copy sources.** A zero-ID template holds no real work and is never renamed
  or deleted; real work always takes the next free ID.
- **Respect the tiers.** Specs (04–07) come before decisions and plans (08–09), which come before
  study and build; records (10–13) come after. A record with no plan behind it is a note, and a
  plan with no milestone behind it is a wish.
- **Cite by full repo-relative path in backticks.** `project-management/src/08-DECISIONS/...`, not
  "the C17 ADR", so every citation can be followed and checked.
- **Keep code out of this store.** Exercise solutions live in `code/src/`; kernel source trees,
  build output and disk images are never committed anywhere (`.claude/CLAUDE.md`, kernel safety
  rule). Config fragments and command output excerpts are fine.
- **Keep status words to the one vocabulary.** It is owned by
  `project-management/docs/planning/MILESTONES.md`; do not invent a new state in an artefact. The
  record-local lifecycles a folder's own `CLAUDE.md` defines (ADR status, fix state, verdict, spec,
  kernel and profile status) are separate from it (`MILESTONES.md` → _Statuses_).
- **Keep instructional files short.** `CONTEXT.md` and `CLAUDE.md` files here stay within the
  limit in `code/docs/DOCUMENTATION-LENGTH.md`; the artefacts and templates themselves are exempt.

## Output & naming

- **Hand-written:** every artefact under every numbered folder, each copied from that folder's
  zero-ID template.
- **Generated:** none.
- Folders `NN-SCREAMING-SNAKE/` with a two-digit prefix; milestone IDs `MS###` (three digits);
  sprint IDs `SPRINT-##` (two digits); templates take the zero ID of their own pattern
  (`MS000-TEMPLATE.md`); descriptors `SCREAMING-KEBAB-CASE`; dates DD/MM/YYYY in prose and
  DD-MM-YYYY in filenames.
- **Each folder's own `CLAUDE.md` → Output & naming owns its filename pattern.** This section is
  the fallback for anything directly under `src/` that has no folder of its own — at present,
  nothing but this pair.
