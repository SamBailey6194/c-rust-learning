# Workflow: Distro Tier Spec

**Last Updated**: 27/09/2026

"Beginner", "intermediate" and "experienced" are opinions until each is written down as a spec with
testable hypotheses. This workflow turns a tier into that spec, measured on the same axes as its two
siblings, so the P6 images are judged against a claim made in advance rather than one invented after the
build.

## Directory Tree

```text
project-management/workflows/07-distro-tier-spec/
├── CONTEXT.md · CLAUDE.md   ← orientation (this file) · operating rules for the workflow
├── STEPS.md                 ← ordered steps, each closing on a "Done when" line
└── CHECKLIST.md             ← the gate ticked before the workflow counts as complete
```

## When to use this

- A milestone's **Distro** flag is set (anything other than `N/A`, per
  `project-management/docs/planning/MILESTONES.md` → _The FLAGS table_): its track is Distro, or it
  builds something a tier depends on (a per-tier kernel configuration fragment at P5, a root filesystem
  or installer at P6).
- A research note changes the evidence behind a tier's axis value, or a new axis joins `TIER-MATRIX.md`.
- Early in the roadmap (P1 to P4), to capture a hypothesis while the idea is fresh. A tier spec can sit as
  a draft for months before P6 tests it.

It sits in the specify family, after `06-kernel-spec` and before `08-decisions`, and runs only when the
milestone calls for it. The running order lives in `project-management/workflows/CONTEXT.md`.

## Key concepts

- **The matrix compares; the tier file specifies.** `TIER-MATRIX.md` holds one row per axis and one
  column per tier. Each tier file (`TIER-BEGINNER.md`, `TIER-INTERMEDIATE.md`, `TIER-EXPERIENCED.md`)
  expands its column into the target user, the reasoning, the hypotheses and the evidence. The two agree
  cell for cell.
- **The axes are shared.** Every tier answers the same questions (installer, init system, package-manager
  exposure, kernel configuration, documentation depth, recovery tooling and whatever else the matrix
  lists), so a difference between tiers is a choice rather than an omission. `TIER-MATRIX.md` owns the
  axis list.
- **A hypothesis is a claim that P6 can falsify.** "Beginners find it easy" is not one. "A first-time user
  reaches a working shell from first boot in QEMU by following only the on-screen text" is. Each
  hypothesis names the observation that tests it, the pass condition, and the phase that tests it.
- **Research feeds the spec.** An axis value backed only by memory is an assumption. A note in
  `research/<SCREAMING-KEBAB-TOPIC>.md`, written with `.claude/skills/research/SKILL.md` (one question,
  a citation per claim), turns it into evidence that the tier file cites by path.
- **Hard-to-reverse choices are ADRs, not tier properties.** Init system, package manager, bootloader and
  distro base are decided in `08-decisions`; the tier file cites the ADR.
- **Tier kernels live in QEMU.** Every kernel and image a tier describes is built and booted in QEMU only;
  `.claude/CLAUDE.md` owns that rule.

## Cross-references

### Governing documents

- `project-management/src/07-DISTRO-TIERS/CLAUDE.md` — naming, status and authoring rules for tier files
- `project-management/src/07-DISTRO-TIERS/TIER-000-TEMPLATE.md` — the scaffold every tier file follows
- `project-management/src/07-DISTRO-TIERS/TIER-MATRIX.md` — the axes and the side-by-side comparison
- `project-management/src/01-ROADMAP/ROADMAP.md` — P5 and P6 scope and exit gates

### Related reading

- `project-management/src/07-DISTRO-TIERS/TIER-BEGINNER.md` · `TIER-INTERMEDIATE.md` ·
  `TIER-EXPERIENCED.md` — the three live tier specs
- `research/CONTEXT.md` — what a research note contains and how it is named
- `project-management/workflows/06-kernel-spec/` — upstream: kernel plans behind the kernel-config axis
- `project-management/workflows/08-decisions/` — downstream: ADRs for the choices a tier spec surfaces
- `project-management/src/06-KERNEL/` — kernel plans and implementation records the tiers point at
- `DEFERRED.md` — tier ideas parked for a later phase
