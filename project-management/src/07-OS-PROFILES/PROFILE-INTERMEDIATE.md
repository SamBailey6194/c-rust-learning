# PROFILE-INTERMEDIATE — Intermediate Desktop Profile

**Last Updated**: 27/09/2026 | **Version**: 0.1.0 | **Maintained By**: Sam Bailey
**Language**: British English (en_GB) | **Timezone**: Europe/London

| Field | Value |
| --- | --- |
| **Profile** | intermediate (desktop family) |
| **Status** | Draft — hypotheses to research, then test at P6 (words owned by `project-management/src/07-OS-PROFILES/CLAUDE.md`) |
| **Driving milestone** | none yet — profile milestones are cut at P5 and P6 |
| **Matrix** | `project-management/src/07-OS-PROFILES/PROFILE-MATRIX.md` → Intermediate column |
| **Date** | 27/09/2026 |

This is a sketch. Every value below is a hypothesis written before any research, labelled "assumption
to test"; none is a decision. It exists now so that P1 to P5 have a concrete destination, and it is
expected to change. The profile is one of seven on one base
(`project-management/src/08-DECISIONS/ADR-MS001-SYNTEK-OS-PROFILES-ON-ONE-BASE-27-09-2026.md`); its
desktop is reused, not written (`ADR-MS001-SYNTEK-OS-DESKTOPS-REUSED-27-09-2026.md`).

---

## 1. Target user

Someone who uses a terminal every day and has run a mainstream distribution, but has not built one.
They want to understand what their system is doing and change it — partition the disk their way,
choose what runs at boot, read what a package will change before it changes it. They give up when
the system hides a mechanism they want to see, or when documentation says which command to type but
not what it does.

---

## 2. Principles

1. **Show the mechanism, keep the guard rails.** The package manager and the service files are in
   plain view; destructive actions still ask for confirmation.
2. **Explain, then instruct.** Documentation says what a tool does before it says how to use it.
3. **Recovery is a documented skill.** Things will break; the manual says how to fix them from a
   shell.

---

## 3. Axis values

| Axis | Value | Why | Source | Tested by |
| --- | --- | --- | --- | --- |
| Target user | Uses a terminal daily; has run a mainstream distro | The middle desktop profile bridges "uses Linux" and "builds Linux" | assumption to test | H2 |
| Installer | Guided text installer with manual partitioning | The user wants control over layout but not to type every step | assumption to test | H1 |
| Default desktop / shell | Login shell; an optional lightweight desktop (candidate: Xfce or COSMIC) | The terminal is home; a graphical session is a choice, reused not written | assumption to test | H1 |
| Package-manager exposure | Package manager CLI exposed, with confirmation prompts | Seeing what a transaction changes is part of understanding the system | assumption to test | H2 |
| Init system | The base init, shared on purpose | One init to document and test across profiles | assumption to test | — (no user-facing difference) |
| Kernel config + update cadence | Trimmed config for common and virtual hardware; stable line; user-started updates | Fewer drivers to reason about; the user decides when the kernel changes | assumption to test | H3 |
| Documentation & guidance level | Reference manual plus how-tos that explain what each tool does | The user reads to understand, and comes back to look things up | assumption to test | H2 |
| Rescue / recovery tooling | Previous kernel kept; a documented initramfs emergency shell | The user can type a repair if the manual shows them how | assumption to test | H3 |
| Network exposure & firewall default | No inbound services by default; firewall closed, opened per need | A desktop exposes nothing until the user opens a port knowingly | assumption to test | H4 |
| Storage stack | Manual partitioning; ext4 or Btrfs by choice; LUKS for a laptop | The user chooses the layout; encryption for a portable machine | assumption to test | H1 |
| Hardware target | Laptops and PCs — VMs and QEMU disk images only until hardware is chosen by ADR | No hardware is chosen yet (Sam's decision after the critique, 27/09/2026); `GAPS.md` holds the Open question | assumption to test | — |

---

## 4. Hypotheses

```text
H1  Claim:      the installer's manual partitioning produces exactly the layout the user asked for.
    Test:       in QEMU, install to an empty disk image with a written layout (partitions,
                sizes, mount points); after first boot run `lsblk` and `findmnt`.
    Passes if:  the `lsblk` and `findmnt` output matches the written layout on every row.
    Tested at:  P6, the intermediate installer milestone.

H2  Claim:      a user who has run another distro can install, query and remove a package
                using only the profile's manual.
    Test:       in QEMU, with only the manual open, install a named package, list its files,
                then remove it.
    Passes if:  all three succeed, and the manual section used for each is recorded.
    Tested at:  P6, the intermediate package milestone.

H3  Claim:      the documented emergency-shell steps repair a broken root mount.
    Test:       in QEMU, corrupt the root entry in /etc/fstab, reboot, follow the manual
                from the initramfs emergency shell.
    Passes if:  the system boots normally afterwards, and no step outside the manual was needed.
    Tested at:  P6, the intermediate rescue milestone.

H4  Claim:      a freshly installed intermediate system exposes no listening service by default.
    Test:       in QEMU on an isolated network, run `ss -tulpn` and scan from a second guest.
    Passes if:  no port is open to the network until the user opens one.
    Tested at:  P6, the intermediate image milestone.
```

---

## 5. Kernel config for this profile

Narrower than beginner: common physical hardware plus the virtual devices QEMU presents, on the
downstream kernel's stable line (`ADR-MS001-KERNEL-DOWNSTREAM-OF-UPSTREAM-27-09-2026.md`; the line
follows `research/LTS-VS-STABLE-PER-PROFILE.md`, planned). Its fragment lives in the downstream kernel repository (created in `kernel-05-downstream-tree`
lesson 02), and its build plan and record in `project-management/src/06-KERNEL/` at P5.
A Later fragment: the first edition is server and homelab.

---

## 6. Open questions

| Question | Blocks | Where it goes |
| --- | --- | --- |
| Which "common hardware" does the trimmed config cover, and how is that measured without real hardware? | Kernel config + update cadence | research note; the P5 profile-config milestone |
| Does the emergency shell come from the init system's own rescue target or from a hand-built initramfs? | Rescue / recovery tooling; H3 | ADR with the init-system decision (`research/INIT-SYSTEM-CHOICE.md`, planned) |
| Which reused lightweight desktop, and is it testable in QEMU? | Default desktop / shell; H1 | `os-15-desktop-editions`; research note |

---

## Cross-references

- `project-management/src/07-OS-PROFILES/PROFILE-MATRIX.md` — this profile's column
- `project-management/src/07-OS-PROFILES/PROFILE-BEGINNER.md` · `PROFILE-EXPERT.md` — the neighbouring
  desktop profiles
- `project-management/src/01-ROADMAP/ROADMAP.md` — P5 and P6
- `project-management/src/08-DECISIONS/ADR-MS001-SYNTEK-OS-PROFILES-ON-ONE-BASE-27-09-2026.md` ·
  `ADR-MS001-SYNTEK-OS-DESKTOPS-REUSED-27-09-2026.md`
- `GAPS.md` → "Syntek OS profile definitions are hypotheses" — the open question this sketch is the
  subject of
