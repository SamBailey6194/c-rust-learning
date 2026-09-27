# PROFILE-BEGINNER — Beginner Desktop Profile

**Last Updated**: 27/09/2026 | **Version**: 0.1.0 | **Maintained By**: Sam Bailey
**Language**: British English (en_GB) | **Timezone**: Europe/London

| Field | Value |
| --- | --- |
| **Profile** | beginner (desktop family) |
| **Status** | Draft — hypotheses to research, then test at P6 (words owned by `project-management/src/07-OS-PROFILES/CLAUDE.md`) |
| **Driving milestone** | none yet — profile milestones are cut at P5 and P6 |
| **Matrix** | `project-management/src/07-OS-PROFILES/PROFILE-MATRIX.md` → Beginner column |
| **Date** | 27/09/2026 |

This is a sketch. Every value below is a hypothesis written before any research, labelled "assumption
to test"; none is a decision. It exists now so that P1 to P5 have a concrete destination, and it is
expected to change. The profile is one of seven on one base
(`project-management/src/08-DECISIONS/ADR-MS001-SYNTEK-OS-PROFILES-ON-ONE-BASE-27-09-2026.md`); its
desktop is reused, not written (`ADR-MS001-SYNTEK-OS-DESKTOPS-REUSED-27-09-2026.md`).

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

One row per axis, spelt exactly as in `PROFILE-MATRIX.md`. The **Value** cell is copied into the
matrix word for word.

| Axis | Value | Why | Source | Tested by |
| --- | --- | --- | --- | --- |
| Target user | New to Linux; has never installed an operating system | The mission's first profile is the one furthest from the learner's own experience | assumption to test | H1 |
| Installer | Guided installer with safe defaults; whole-disk install | One decision (which disk) is the most a first install should ask | assumption to test | H1 |
| Default desktop / shell | A reused desktop (candidate: KDE Plasma or GNOME), if feasible and testable | A beginner expects windows, not a prompt; the desktop is reused, not written (`ADR-MS001-SYNTEK-OS-DESKTOPS-REUSED-27-09-2026.md`) | assumption to test | H1 |
| Package-manager exposure | Hidden behind a few curated commands; updates automatic | Dependency resolution is a mechanism the beginner has no reason to see | assumption to test | H3 |
| Init system | The base init (chosen later by ADR); shared across profiles | Matches what beginner-facing documentation assumes; one init to document (`research/INIT-SYSTEM-CHOICE.md`, planned) | assumption to test | — (no user-facing difference) |
| Kernel config + update cadence | Broad hardware config, most drivers as modules; stable line; automatic updates | Unknown hardware needs broad coverage; a stable line follows current hardware for a desktop | assumption to test | H2 |
| Documentation & guidance level | Task-first plain-language guides; a first-boot welcome; errors say what to do next | The user reads to finish a task, not to understand a system | assumption to test | H1 |
| Rescue / recovery tooling | Previous kernel in the boot menu; a guided recovery mode | Recovery the user has to type is recovery a beginner will not do | assumption to test | H2 |
| Network exposure & firewall default | No inbound services; firewall closed by default | A beginner's machine should expose nothing it was not asked to | assumption to test | H4 |
| Storage stack | Single ext4 root on the whole disk | The simplest layout that boots and is recoverable | assumption to test | H1 |
| Hardware target | Laptops and PCs — VMs and QEMU disk images only until hardware is chosen by ADR | No hardware is chosen yet (Sam's decision after the critique, 27/09/2026); `GAPS.md` holds the Open question | assumption to test | — |

---

## 4. Hypotheses

Every axis that claims a user-facing difference has at least one. Each names the claim, the QEMU
observation that tests it, the pass condition and the phase that tests it.

```text
H1  Claim:      a first-time user reaches a working session from first boot of the installer
                by following only the on-screen text.
    Test:       boot the installer image in qemu-system-x86_64 against an empty disk image;
                read nothing but the screen; count every step that needed outside help.
    Passes if:  the installed system boots to its default session, the count is 0, and
                `uname -r` prints the profile kernel's release.
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

H4  Claim:      a freshly installed beginner system exposes no listening service to the network.
    Test:       in QEMU on an isolated network, run `ss -tulpn` on the installed system and
                scan it from a second guest with nmap.
    Passes if:  no port is open to the network and the scan finds none.
    Tested at:  P6, the beginner image milestone.
```

---

## 5. Kernel config for this profile

The broadest of the seven: a distribution-style config with most drivers built as modules, on the
downstream kernel's stable line (`ADR-MS001-KERNEL-DOWNSTREAM-OF-UPSTREAM-27-09-2026.md`; the exact
line follows `research/LTS-VS-STABLE-PER-PROFILE.md`, planned). Its fragment lives in the downstream kernel repository (created in `kernel-05-downstream-tree`
lesson 02), and its build plan and record in `project-management/src/06-KERNEL/` at P5. It is a Later fragment: the first edition is server and
homelab.

---

## 6. Open questions

| Question | Blocks | Where it goes |
| --- | --- | --- |
| Which reused desktop, and is it feasible and testable in QEMU for a learner-built distribution? | Default desktop / shell; H1 | `os-15-desktop-editions`; research note, then `GAPS.md` if it blocks |
| How can a solo learner who is not a beginner test beginner hypotheses fairly? | H1, H3 | a written screen-only protocol or a willing tester; `GAPS.md` → "Syntek OS profile definitions are hypotheses" |
| Which update mechanism makes "automatic" safe and reversible for kernel updates? | Kernel config + update cadence; H2 | research note; ADR with the package-manager decision |

---

## Cross-references

- `project-management/src/07-OS-PROFILES/PROFILE-MATRIX.md` — this profile's column
- `project-management/src/07-OS-PROFILES/PROFILE-INTERMEDIATE.md` — the next desktop profile along
- `project-management/src/01-ROADMAP/ROADMAP.md` — P5 and P6
- `project-management/src/08-DECISIONS/ADR-MS001-SYNTEK-OS-PROFILES-ON-ONE-BASE-27-09-2026.md` ·
  `ADR-MS001-SYNTEK-OS-DESKTOPS-REUSED-27-09-2026.md`
- `GAPS.md` → "Syntek OS profile definitions are hypotheses" — the open question this sketch is the
  subject of
