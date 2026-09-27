# TIER-MATRIX — The Three Distro Tiers Compared

**Last Updated**: 27/09/2026 | **Version**: 0.1.0 | **Maintained By**: Sam Bailey
**Language**: British English (en_GB) | **Timezone**: Europe/London

**Status:** Draft — every cell is a hypothesis to research and then test at P5 and P6, not a decision.

The three tiers side by side on eight fixed axes. Each cell is the tier's value exactly as its tier
file states it; the reasoning, the source and the QEMU test for each value live in the tier file:
`TIER-BEGINNER.md`, `TIER-INTERMEDIATE.md`, `TIER-EXPERIENCED.md`. The axes are fixed so the tiers
stay comparable: adding or renaming one changes every tier, and goes through an ADR first.

---

## The matrix

| Axis | Beginner | Intermediate | Experienced |
| --- | --- | --- | --- |
| **Target user** | New to Linux; has never installed an operating system | Uses a terminal daily; has run a mainstream distro | Builds from source; reads kernel configs and init scripts |
| **Installer** | Guided installer with safe defaults; whole-disk install | Guided text installer with manual partitioning | No installer: a documented manual install |
| **Default desktop / shell** | A graphical session, if feasible and testable (open question) | Login shell; an optional lightweight window manager | Login shell only |
| **Package-manager exposure** | Hidden behind a few curated commands; updates automatic | Package manager CLI exposed, with confirmation prompts | Fully exposed, including building packages from source |
| **Init system** | A mainstream service manager (candidate: systemd); ADR pending | Same as beginner, shared on purpose | A minimal init (candidates: busybox init or the P5 C init) |
| **Kernel config + update cadence** | Broad hardware config, most drivers as modules; longterm branch; automatic updates | Trimmed config for common and virtual hardware; longterm or stable; user-started updates | Minimal config the user rebuilds; stable branch; user builds each update |
| **Documentation & guidance level** | Task-first plain-language guides; a first-boot welcome; errors say what to do next | Reference manual plus how-tos that explain what each tool does | Terse reference: man pages and one handbook |
| **Rescue / recovery tooling** | Previous kernel in the boot menu; a guided recovery mode | Previous kernel kept; a documented initramfs emergency shell | Busybox rescue shell in the initramfs; recovery documented, done by hand |

---

## Reading the matrix

- **Each column is a direction, not a feature list.** Moving right, the system hides less, decides
  less on the user's behalf, and documents less of the "why" — because the user needs less of it.
- **Shared values are deliberate or they are mistakes.** Beginner and intermediate share an init
  system on purpose: one init to document and test for the two tiers most likely to meet service
  files. Any other shared cell is either argued in both tier files or is an error.
- **The kernel row is where P5 starts.** Each tier's kernel config and update cadence becomes a
  Kconfig fragment and a `KERNEL-PLAN-...` in `project-management/src/06-KERNEL/`.
- **Nothing here is decided.** Distro base, init system, package manager and bootloader are all
  hard to reverse and each gets an ADR in `project-management/src/08-DECISIONS/` before P6 builds on
  it. Until then, every cell is a hypothesis.

---

## Open questions shared by all three tiers

| Question | Why it matters | Where it goes |
| --- | --- | --- |
| Which distro base: from scratch (Linux From Scratch style), a build system such as Buildroot or the Yocto Project, or a Debian-family base? | Decides what "package manager" and "installer" can even mean per tier | `GAPS.md` → "27/09/2026 — Distro build approach undecided"; research notes first, then an ADR before P6 |
| Is a graphical session feasible and testable in QEMU for a learner-built distro? | Decides the beginner tier's default desktop / shell cell | research note; `GAPS.md` if it blocks |
| How is a beginner hypothesis tested fairly by a solo learner who is not a beginner? | Every beginner hypothesis is observed by someone who already knows the answer | a written protocol (screen-only, step count) or a willing tester; `GAPS.md` open question |
| Do the three tiers share one base and differ only in configuration, or diverge in base too? | Decides how much of P6 is built once versus three times | ADR at P6 |

---

## Cross-references

- `project-management/src/07-DISTRO-TIERS/TIER-BEGINNER.md`
- `project-management/src/07-DISTRO-TIERS/TIER-INTERMEDIATE.md`
- `project-management/src/07-DISTRO-TIERS/TIER-EXPERIENCED.md`
- `project-management/workflows/07-distro-tier-spec/` — the procedure that keeps matrix and tier files in step
- `project-management/src/01-ROADMAP/ROADMAP.md` — P5 and P6
- `GAPS.md` → "27/09/2026 — Distro tier definitions are hypotheses" — the register entry that says
  this matrix is a first guess
- `GAPS.md` → "27/09/2026 — Distro build approach undecided" — the distro-base question
