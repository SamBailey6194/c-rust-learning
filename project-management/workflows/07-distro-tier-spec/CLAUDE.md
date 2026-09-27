@./CONTEXT.md

# CLAUDE.md — project-management/workflows/07-distro-tier-spec/

Read order: `.claude/CLAUDE.md` → `.claude/MEMORY.md` → this folder's `CONTEXT.md` (when to use, key
concepts, governing documents — imported above) → this file → `STEPS.md` then `CHECKLIST.md`.

## Purpose (one line)

Turn a distro tier into a spec of axis values and QEMU-testable hypotheses that agrees with
`TIER-MATRIX.md` and that P6 can pass or fail.

## How to work here

- **Routing:** run `STEPS.md` in order against `CHECKLIST.md`. Read
  `project-management/src/07-DISTRO-TIERS/CLAUDE.md` and `TIER-000-TEMPLATE.md` before Step 3. Load
  `.claude/skills/research/SKILL.md` (`/research <question>`) for every axis value that rests on memory.
- **Concrete steps:** the learner describes the tier's target user → read the P5/P6 roadmap rows, the
  matrix and the tier file → research unbacked axis values → fill every axis → write the hypotheses →
  check the three tiers against each other and against the ADRs → cross-link and set status → commit by
  explicit path.
- **Definition of done:** the tier file and `TIER-MATRIX.md` agree cell for cell; every hypothesis names
  its test, pass condition and phase; every hard-to-reverse choice cites an ADR; `CHECKLIST.md` is fully
  ticked.

## Guardrails

- **Ask the learner to describe the tier before drafting anything.** A spec Claude writes alone records
  Claude's idea of a beginner, not the learner's, and the learner is the one who has to build it.
- **Change the matrix and the tier file in the same commit.** A mismatch between them means one of the
  two is wrong, and P6 will test the wrong one.
- **Write hypotheses, not adjectives.** "Easy", "powerful" and "minimal" cannot fail; rewrite each as an
  observation made in QEMU with a pass condition.
- **Send hard-to-reverse choices to `08-decisions`.** The tier file cites an ADR for init system, package
  manager, bootloader or distro base; it never settles one inline.
- **Cite and link external sources instead of pasting them.** This is a public repo; copyrighted text
  (Linux From Scratch chapters, man pages beyond a line) stays at its source.
- **Keep every tier kernel and image in QEMU.** Nothing specified here is installed or booted on the host
  (`.claude/CLAUDE.md` owns the rule).

## Output & naming

- **Writes:** `project-management/src/07-DISTRO-TIERS/TIER-<TIER>.md`, the matching column of
  `TIER-MATRIX.md`, and any research notes the spec cites.
- Tier names are `BEGINNER`, `INTERMEDIATE` and `EXPERIENCED`; the folder's `CLAUDE.md` → Output & naming
  owns the filename pattern.
- Research notes `research/<SCREAMING-KEBAB-TOPIC>.md`; dates DD/MM/YYYY in prose.
- Commit scope `distro` (`research` for a note committed on its own), per
  `project-management/docs/git/COMMITS.md`.
