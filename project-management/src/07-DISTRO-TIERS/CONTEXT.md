# project-management/src/07-DISTRO-TIERS/ — Distro Tier Specs

**Last Updated**: 27/09/2026

The specs for the three distribution tiers the mission ends with — beginner, intermediate and
experienced. `TIER-MATRIX.md` compares the tiers on eight fixed axes (target user, installer, default
desktop or shell, package-manager exposure, init system, kernel config and update cadence,
documentation and guidance level, rescue and recovery tooling); each `TIER-<NAME>.md` states that
tier's value on every axis with a reason, and turns each user-facing difference into a hypothesis
that a QEMU boot can pass or fail. All three tiers are **Draft sketches** today: hypotheses to be
researched and then tested at P5 (the per-tier kernel configs) and P6 (the tier images), not
decisions. Writing them this early gives every earlier phase a destination to aim at.

## Directory Tree

```text
project-management/src/07-DISTRO-TIERS/
├── CONTEXT.md · CLAUDE.md      ← this pair: what the tier specs are · how to work here
├── TIER-000-TEMPLATE.md        ← tier template — copied if a tier file is lost or a tier is added by ADR
├── TIER-MATRIX.md              ← the eight axes by three tiers, one cell per tier value
├── TIER-BEGINNER.md            ← beginner tier: Draft hypotheses
├── TIER-INTERMEDIATE.md        ← intermediate tier: Draft hypotheses
└── TIER-EXPERIENCED.md         ← experienced tier: Draft hypotheses
```

## How the files relate

| File | Holds | Agrees with |
| --- | --- | --- |
| `TIER-MATRIX.md` | One row per axis, one column per tier: the value only | each tier file, cell for cell |
| `TIER-<NAME>.md` | Target user, principles, each axis value with its reason and test, hypotheses, open questions | its column in the matrix |
| `TIER-000-TEMPLATE.md` | The shape of a tier file | — |

A tier's value lives in two places on purpose — the matrix is for comparing, the tier file for
reasoning — and the distro-tier workflow keeps them identical.

## What is still open

The biggest open questions are shared by all three tiers: which distro base to build on (from
scratch in the Linux From Scratch style, a build system such as Buildroot or the Yocto Project, or
a Debian-family base), which
init system and package manager, and whether a graphical session is feasible and testable in QEMU
for the beginner tier. Each is hard to reverse, so each becomes an ADR in
`project-management/src/08-DECISIONS/` when P6 approaches. Two entries in `GAPS.md` already track
this: "Distro build approach undecided" and "Distro tier definitions are hypotheses".

## Cross-references

- `project-management/workflows/07-distro-tier-spec/` — the procedure that writes and updates these files
- `project-management/src/01-ROADMAP/ROADMAP.md` — P5 and P6: what the tiers have to achieve, and the exit gates
- `project-management/src/06-KERNEL/` — the per-tier kernel config plans and records at P5
- `research/` — the notes that turn a Draft value into a cited one
- `GAPS.md` — open questions that block a tier
