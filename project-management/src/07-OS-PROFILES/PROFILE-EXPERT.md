# PROFILE-EXPERT — Expert Desktop Profile

**Last Updated**: 27/09/2026 | **Version**: 0.1.0 | **Maintained By**: Sam Bailey
**Language**: British English (en_GB) | **Timezone**: Europe/London

| Field | Value |
| --- | --- |
| **Profile** | expert (desktop family) |
| **Status** | Draft — hypotheses to research, then test at P6 (words owned by `project-management/src/07-OS-PROFILES/CLAUDE.md`) |
| **Driving milestone** | none yet — profile milestones are cut at P5 and P6 |
| **Matrix** | `project-management/src/07-OS-PROFILES/PROFILE-MATRIX.md` → Expert column |
| **Date** | 27/09/2026 |

<!-- CHANGED 27/09/2026: this profile was the "experienced" tier; renamed "expert" to Sam's word by
     ADR-MS001-SYNTEK-OS-PROFILES-ON-ONE-BASE-27-09-2026.md. Its content carried over. -->

This is a sketch. Every value below is a hypothesis written before any research, labelled "assumption
to test"; none is a decision. It exists now so that P1 to P5 have a concrete destination, and it is
expected to change. Of the desktop profiles it is the closest to what the learner builds anyway in P4
and P5. The profile is one of seven on one base
(`project-management/src/08-DECISIONS/ADR-MS001-SYNTEK-OS-PROFILES-ON-ONE-BASE-27-09-2026.md`); its
desktop is reused, not written (`ADR-MS001-SYNTEK-OS-DESKTOPS-REUSED-27-09-2026.md`).

---

## 1. Target user

Someone who builds software from source, reads kernel configs and init scripts, and wants to know
and control every component on the system. They want a small, legible base they assemble
themselves. They give up when the system does something they did not ask for, or when a component
cannot be rebuilt or replaced.

---

## 2. Principles

1. **Nothing runs that the user did not choose.** The default system starts the minimum needed to
   reach a shell.
2. **Every component can be rebuilt from what is documented.** The kernel, the init and the
   packages come with the commands that produce them.
3. **Document the what, trust the user with the why.** Reference over tutorial.

---

## 3. Axis values

| Axis | Value | Why | Source | Tested by |
| --- | --- | --- | --- | --- |
| Target user | Builds from source; reads kernel configs and init scripts | The profile the learner will themselves have become by P6 | assumption to test | H1 |
| Installer | No installer: a documented manual install | Doing each install step by hand is the point for this user | assumption to test | H1 |
| Default desktop / shell | A Wayland tiling compositor (candidate: Sway or Hyprland), or a login shell | The user's choice to add; the compositor is reused, not written | assumption to test | H3 |
| Package-manager exposure | Fully exposed, including building packages from source | The user wants to see and change how packages are made | assumption to test | H2 |
| Init system | The base init; a minimal init the user can read is a lesson (os-06) | A small init the user can read end to end; the base init is shared | assumption to test | H3 |
| Kernel config + update cadence | Minimal config the user rebuilds; stable line; user builds each update | The user owns the kernel config and decides every change | assumption to test | H2 |
| Documentation & guidance level | Terse reference: man pages and one handbook | The user looks things up rather than follows along | assumption to test | H1 |
| Rescue / recovery tooling | Busybox rescue shell in the initramfs; recovery documented, done by hand | The user can repair from a shell; the profile provides the shell and the notes | assumption to test | H1 |
| Network exposure & firewall default | User's choice; firewall closed by default, opened knowingly | The user decides what to expose; the default is closed | assumption to test | H4 |
| Storage stack | Whatever the user builds; LVM, Btrfs subvolumes or LUKS as chosen | The user assembles the storage layout they want | assumption to test | H1 |
| Hardware target | Laptops and PCs — VMs and QEMU disk images only until hardware is chosen by ADR | No hardware is chosen yet (Sam's decision after the critique, 27/09/2026); `GAPS.md` holds the Open question | assumption to test | — |

---

## 4. Hypotheses

```text
H1  Claim:      the system can be installed by following the manual-install document alone.
    Test:       boot the live initramfs in QEMU with an empty disk image attached; follow the
                document to partition, populate and make the disk bootable; power off; boot
                QEMU from the disk alone, without -kernel or -initrd.
    Passes if:  the disk boots to a login prompt, and every command typed appears in the document.
    Tested at:  P6, the expert installer milestone.

H2  Claim:      rebuilding and booting a changed kernel takes only the documented commands.
    Test:       in QEMU, change one option in the profile's kernel fragment, rebuild with the
                documented commands, reboot.
    Passes if:  `uname -v` shows the new build, and the changed option is visible in
                /proc/config.gz (needs CONFIG_IKCONFIG and CONFIG_IKCONFIG_PROC).
    Tested at:  P6, the expert kernel-update milestone.

H3  Claim:      the default system starts no service the user did not enable.
    Test:       boot the image in QEMU; run `ps` at the first prompt.
    Passes if:  every user-space process listed is init, the login or shell, or one the
                documentation names as enabled by default.
    Tested at:  P6, the expert init milestone.

H4  Claim:      the default firewall denies inbound traffic until the user opens a port.
    Test:       in QEMU on an isolated network, scan the installed system from a second guest.
    Passes if:  no inbound port is open until the user's documented step opens one.
    Tested at:  P6, the expert image milestone.
```

---

## 5. Kernel config for this profile

The smallest of the desktop profiles: a minimal config (a trimmed `defconfig`, or built up from
`tinyconfig`) for the user's hardware and QEMU's virtual devices, which the user is expected to
rebuild, on the downstream kernel's stable line
(`ADR-MS001-KERNEL-DOWNSTREAM-OF-UPSTREAM-27-09-2026.md`; the line follows
`research/LTS-VS-STABLE-PER-PROFILE.md`, planned). Its fragment lives in the downstream kernel repository (created in `kernel-05-downstream-tree`
lesson 02), and its build plan and record in `project-management/src/06-KERNEL/` at P5.
A Later fragment: the first edition is server and homelab.

---

## 6. Open questions

| Question | Blocks | Where it goes |
| --- | --- | --- |
| Does the expert profile ship a binary package repository at all, or only build recipes? | Package-manager exposure; H2 | ADR with the package-manager decision |
| Which bootloader makes H1's "boot from the disk alone" step documentable in a few commands? | Installer; H1 | research note, then ADR |
| A minimal C init or the base init as the default? | Init system; H3 | ADR at P6, after the os-06 init lesson |

---

## Cross-references

- `project-management/src/07-OS-PROFILES/PROFILE-MATRIX.md` — this profile's column
- `project-management/src/07-OS-PROFILES/PROFILE-INTERMEDIATE.md` — the neighbouring desktop profile
- `project-management/src/01-ROADMAP/ROADMAP.md` — P5 and P6
- `project-management/src/08-DECISIONS/ADR-MS001-SYNTEK-OS-PROFILES-ON-ONE-BASE-27-09-2026.md` ·
  `ADR-MS001-SYNTEK-OS-DESKTOPS-REUSED-27-09-2026.md`
- `GAPS.md` → "Syntek OS profile definitions are hypotheses" — the open question this sketch is the
  subject of
