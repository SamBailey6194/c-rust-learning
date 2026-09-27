# TIER-BEGINNER — Beginner Tier

**Last Updated**: 27/09/2026 | **Version**: 0.1.0 | **Maintained By**: Sam Bailey
**Language**: British English (en_GB) | **Timezone**: Europe/London

| Field | Value |
| --- | --- |
| **Tier** | beginner |
| **Status** | Draft — hypotheses to research, then test at P6 (words owned by `project-management/src/07-DISTRO-TIERS/CLAUDE.md`) |
| **Driving milestone** | none yet — tier milestones are cut at P5 and P6 |
| **Matrix** | `project-management/src/07-DISTRO-TIERS/TIER-MATRIX.md` → Beginner column |
| **Date** | 27/09/2026 |

This is a sketch. Every value below is a hypothesis written before any research, labelled
"assumption to test"; none is a decision. It exists now so that P1 to P5 have a concrete
destination, and it is expected to change.

---

## 1. Target user

Someone new to Linux who has used a computer for years but has never installed an operating system
or opened a terminal on purpose. They want a system that works after installation without having to
learn how it works first. They give up when a screen asks a question they cannot answer, or when an
error message tells them what went wrong but not what to do.

---

## 2. Principles

1. **A safe default beats a choice the user is not ready to make.** Every question the installer
   asks has a default that is correct for most people.
2. **Every failure has a next step.** No error, boot failure or update problem leaves the user
   without an on-screen instruction or a menu entry that recovers.
3. **Hide mechanisms, not information.** The package manager and the init system are hidden; what
   they did (installed, updated, failed) is still shown in plain language.

---

## 3. Axis values

| Axis | Value | Why | Source | Tested by |
| --- | --- | --- | --- | --- |
| Target user | New to Linux; has never installed an operating system | The mission's first tier is the one furthest from the learner's own experience | assumption to test | H1 |
| Installer | Guided installer with safe defaults; whole-disk install | One decision (which disk) is the most a first install should ask | assumption to test | H1 |
| Default desktop / shell | A graphical session, if feasible and testable (open question) | A beginner expects windows, not a prompt; feasibility for a learner-built distro is unknown | assumption to test | H1 |
| Package-manager exposure | Hidden behind a few curated commands; updates automatic | Dependency resolution is a mechanism the beginner has no reason to see | assumption to test | H3 |
| Init system | A mainstream service manager (candidate: systemd); ADR pending | Matches what most beginner-facing documentation and tools assume; shared with intermediate | assumption to test | — (no user-facing difference) |
| Kernel config + update cadence | Broad hardware config, most drivers as modules; longterm branch; automatic updates | Unknown hardware needs broad coverage; a longterm branch changes least between updates | assumption to test | H2 |
| Documentation & guidance level | Task-first plain-language guides; a first-boot welcome; errors say what to do next | The user reads to finish a task, not to understand a system | assumption to test | H1 |
| Rescue / recovery tooling | Previous kernel in the boot menu; a guided recovery mode | Recovery the user has to type is recovery a beginner will not do | assumption to test | H2 |

---

## 4. Hypotheses

```text
H1  Claim:      a first-time user reaches a working session from first boot of the installer
                by following only the on-screen text.
    Test:       boot the installer image in qemu-system-x86_64 against an empty disk image;
                read nothing but the screen; count every step that needed outside help.
    Passes if:  the installed system boots to its default session, the count is 0, and
                `uname -r` prints the tier kernel's release.
    Tested at:  P6, the milestone that first boots the beginner image.

H2  Claim:      after a deliberately broken kernel update, the user returns to a working
                system by choosing one boot-menu entry, typing no command.
    Test:       in QEMU, install a kernel built to panic at boot, reboot, pick the previous
                kernel from the boot menu.
    Passes if:  the previous kernel boots to the default session with no command typed.
    Tested at:  P6, the beginner rescue milestone.

H3  Claim:      installing an application needs no package-manager command.
    Test:       in QEMU, follow the beginner guide to install one named application.
    Passes if:  the application runs, and the shell history shows no package-manager command.
    Tested at:  P6, the beginner package milestone.
```

---

## 5. Kernel config for this tier

The broadest of the three: a distribution-style config with most drivers built as modules, on a
longterm branch. Its fragment lives under `code/src/kernel/` (planned — added at P4), and its build
plan and record in `project-management/src/06-KERNEL/` at P5.

---

## 6. Open questions

| Question | Blocks | Where it goes |
| --- | --- | --- |
| Is a graphical session feasible for a learner-built distro, and testable in QEMU? | Default desktop / shell; H1 | research note, then `GAPS.md` open question if it blocks |
| How can a solo learner who is not a beginner test beginner hypotheses fairly? | H1, H3 | a written screen-only protocol or a willing tester; `GAPS.md` open question |
| Which update mechanism makes "automatic" safe (and reversible) for kernel updates? | Kernel config + update cadence; H2 | research note; ADR with the package-manager decision |
| Which distro base and package manager? | Package-manager exposure; Installer | `GAPS.md` → "27/09/2026 — Distro build approach undecided"; ADR at P6 (shared with all tiers) |

---

## Cross-references

- `project-management/src/07-DISTRO-TIERS/TIER-MATRIX.md` — this tier's column
- `project-management/src/07-DISTRO-TIERS/TIER-INTERMEDIATE.md` — the next tier along
- `project-management/src/01-ROADMAP/ROADMAP.md` — P5 and P6
- `GAPS.md` → "27/09/2026 — Distro tier definitions are hypotheses" — the open question this sketch is the subject of
- `GAPS.md` → "27/09/2026 — Distro build approach undecided" — the distro-base question every axis waits on
