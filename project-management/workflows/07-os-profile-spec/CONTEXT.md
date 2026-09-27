# Workflow: OS Profile Spec

**Last Updated**: 27/09/2026

<!-- CHANGED 27/09/2026: this workflow was 07-distro-tier-spec, specifying three distro tiers.
     Renamed to 07-os-profile-spec for the seven Syntek OS profiles by
     ADR-MS001-ROADMAP-KERNEL-OS-UI-LLM-TRACKS-27-09-2026.md and
     ADR-MS001-SYNTEK-OS-PROFILES-ON-ONE-BASE-27-09-2026.md. -->

The seven Syntek OS profiles — three desktop (beginner, intermediate, expert) and four in the server
family (server, NAS, homelab, router) — are opinions until each is written down as a spec with
testable hypotheses. This workflow turns a profile into that spec, measured on the same eleven axes as
its siblings, so the P6 images are judged against a claim made in advance rather than one invented
after the build.

## Directory Tree

```text
project-management/workflows/07-os-profile-spec/
├── CONTEXT.md · CLAUDE.md   ← orientation (this file) · operating rules for the workflow
├── STEPS.md                 ← ordered steps, each closing on a "Done when" line
└── CHECKLIST.md             ← the gate ticked before the workflow counts as complete
```

## When to use this

- A milestone's **OS** flag is set (anything other than `N/A`, per
  `project-management/docs/planning/MILESTONES.md` → _The FLAGS table_): its track is OS, or it builds
  something a profile depends on (a per-profile kernel configuration fragment at P5, a root filesystem
  or installer at P6).
- A research note changes the evidence behind a profile's axis value, or a new axis joins
  `PROFILE-MATRIX.md` by ADR.
- Early in the roadmap, to capture a hypothesis while the idea is fresh. A profile spec can sit as a
  draft for months before P6 tests it.

It sits in the specify family, after `06-kernel-spec` and before `08-decisions`, and runs only when
the milestone calls for it. The running order lives in `project-management/workflows/CONTEXT.md`.

## Key concepts

- **The matrix compares; the profile file specifies.** `PROFILE-MATRIX.md` holds one row per axis and
  one column per profile, in two tables (desktop family and server family). Each profile file expands
  its column into the target user, the reasoning, the hypotheses and the evidence. The two agree cell
  for cell.
- **The eleven axes are shared.** Every profile answers the same questions (installer, init system,
  package-manager exposure, kernel configuration, documentation depth, recovery tooling, network
  exposure, storage stack, hardware target and the rest), so a difference between profiles is a choice
  rather than an omission. `PROFILE-MATRIX.md` owns the axis list; keep seven profiles.
- **A hypothesis is a claim that P6 can falsify.** "Beginners find it easy" is not one. "A first-time
  user reaches a working session from first boot in QEMU by following only the on-screen text" is. Each
  hypothesis names the observation that tests it, the pass condition, and the phase that tests it.
- **Research feeds the spec.** An axis value backed only by memory is an assumption. A note in
  `research/<SCREAMING-KEBAB-TOPIC>.md`, written with `.claude/skills/research/SKILL.md` (one question,
  a citation per claim), turns it into evidence the profile file cites by path.
- **Hard-to-reverse choices are ADRs, not profile properties.** Init system, package manager and
  signing, bootloader, a storage layer and a profile's hardware are decided in `08-decisions`; the
  profile file cites the ADR.
- **Profile kernels and images live in QEMU.** Every kernel and image a profile describes is built and
  booted in QEMU only; router labs run on isolated virtual networks; `.claude/CLAUDE.md` owns the
  rules.

## Cross-references

### Governing documents

- `project-management/src/07-OS-PROFILES/CLAUDE.md` — naming, status and authoring rules for profile
  files
- `project-management/src/07-OS-PROFILES/PROFILE-000-TEMPLATE.md` — the scaffold every profile file
  follows
- `project-management/src/07-OS-PROFILES/PROFILE-MATRIX.md` — the eleven axes and the side-by-side
  comparison
- `project-management/src/01-ROADMAP/ROADMAP.md` — P5 and P6 scope and exit gates

### Related reading

- `project-management/src/07-OS-PROFILES/PROFILE-BEGINNER.md` · `PROFILE-INTERMEDIATE.md` ·
  `PROFILE-EXPERT.md` · `PROFILE-SERVER.md` · `PROFILE-NAS.md` · `PROFILE-HOMELAB.md` ·
  `PROFILE-ROUTER.md` — the seven live profile specs
- `research/CONTEXT.md` — what a research note contains and how it is named
- `project-management/workflows/06-kernel-spec/` — upstream: kernel plans behind the kernel-config
  axis
- `project-management/workflows/08-decisions/` — downstream: ADRs for the choices a profile spec
  surfaces
- `project-management/src/06-KERNEL/` — kernel plans and implementation records the profiles point at
- `DEFERRED.md` — profile ideas parked for a later phase
