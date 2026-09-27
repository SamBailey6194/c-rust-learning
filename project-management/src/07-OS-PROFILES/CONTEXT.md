# project-management/src/07-OS-PROFILES/ — Syntek OS Profile Specs

**Last Updated**: 27/09/2026

<!-- CHANGED 27/09/2026: this folder was 07-DISTRO-TIERS/ with three tier files (beginner,
     intermediate, experienced). Renamed to 07-OS-PROFILES/ with seven profile files by
     ADR-MS001-ROADMAP-KERNEL-OS-UI-LLM-TRACKS-27-09-2026.md and
     ADR-MS001-SYNTEK-OS-PROFILES-ON-ONE-BASE-27-09-2026.md. The folder number is unchanged. -->

The specs for the seven Syntek OS profiles the mission builds — three **desktop** profiles (beginner,
intermediate, expert, for laptops and PCs) and four in the **server family** (server, NAS, homelab,
router). All seven share one base, build system and package set
(`project-management/src/08-DECISIONS/ADR-MS001-SYNTEK-OS-PROFILES-ON-ONE-BASE-27-09-2026.md`); a
profile is a package set, a set of defaults, a kernel fragment and its installer choices.
`PROFILE-MATRIX.md` compares them on eleven fixed axes; each `PROFILE-<NAME>.md` states that profile's
value on every axis with a reason, and turns each user-facing difference into a hypothesis a QEMU boot
can pass or fail. All seven are **Draft sketches** today: hypotheses to research and then test at P5
(the per-profile kernel configs) and P6 (the profile images). The first edition to ship is server and
homelab (`project-management/src/01-ROADMAP/ROADMAP.md` → Critical path).

## Directory Tree

```text
project-management/src/07-OS-PROFILES/
├── CONTEXT.md · CLAUDE.md      ← this pair: what the profile specs are · how to work here
├── PROFILE-000-TEMPLATE.md     ← profile template — copied if a file is lost or a profile is added by ADR
├── PROFILE-MATRIX.md           ← the eleven axes by seven profiles, in two tables (desktop / server family)
│   ── Desktop family ──
├── PROFILE-BEGINNER.md         ← beginner desktop: Draft hypotheses
├── PROFILE-INTERMEDIATE.md     ← intermediate desktop: Draft hypotheses
├── PROFILE-EXPERT.md           ← expert desktop (was "experienced" tier): Draft hypotheses
│   ── Server family ──
├── PROFILE-SERVER.md           ← server: Draft hypotheses (first edition)
├── PROFILE-HOMELAB.md          ← homelab: Draft hypotheses (first edition)
├── PROFILE-NAS.md              ← NAS: Draft hypotheses (Later)
└── PROFILE-ROUTER.md           ← router: Draft hypotheses (Later)
```

## How the files relate

| File | Holds | Agrees with |
| --- | --- | --- |
| `PROFILE-MATRIX.md` | Two tables, one row per axis, one column per profile: the value only | each profile file, cell for cell |
| `PROFILE-<NAME>.md` | Target user, principles, each axis value with its reason and test, hypotheses, open questions | its column in the matrix |
| `PROFILE-000-TEMPLATE.md` | The shape of a profile file | — |

A profile's value lives in two places on purpose — the matrix is for comparing, the profile file for
reasoning — and `project-management/workflows/07-os-profile-spec/` keeps them identical.

## What is still open

The biggest open questions are shared across profiles: which init system Syntek OS ships (the learning
build follows LFS systemd meanwhile), which stable or longterm kernel line each profile follows, which
package format and signing scheme, ZFS's CDDL for the NAS profile, and what hardware each profile
targets. Each is hard to reverse, so each becomes a research note and then an ADR before P6 builds on
it. `GAPS.md` tracks the profile-definitions question and the per-profile hardware Open question.

## Cross-references

- `project-management/workflows/07-os-profile-spec/` — the procedure that writes and updates these
  files
- `project-management/src/01-ROADMAP/ROADMAP.md` — P5 and P6: what the profiles have to achieve, and
  the exit gates
- `project-management/src/06-KERNEL/` — the per-profile kernel config plans and records at P5
- `project-management/src/08-DECISIONS/ADR-MS001-SYNTEK-OS-PROFILES-ON-ONE-BASE-27-09-2026.md` — seven
  profiles, one base, eleven axes
- `research/` — the notes that turn a Draft value into a cited one
- `GAPS.md` — open questions that block a profile
