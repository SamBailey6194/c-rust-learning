# PROFILE-NAS — NAS Profile

**Last Updated**: 27/09/2026 | **Version**: 0.1.0 | **Maintained By**: Sam Bailey
**Language**: British English (en_GB) | **Timezone**: Europe/London

| Field | Value |
| --- | --- |
| **Profile** | nas (server family) — Later on the critical path |
| **Status** | Draft — hypotheses to research, then test at P6 (words owned by `project-management/src/07-OS-PROFILES/CLAUDE.md`) |
| **Driving milestone** | none yet — profile milestones are cut at P5 and P6 |
| **Matrix** | `project-management/src/07-OS-PROFILES/PROFILE-MATRIX.md` → NAS column |
| **Date** | 27/09/2026 |

This is a sketch. Every value below is a hypothesis, labelled "assumption to test"; none is a
decision. The NAS profile is one of seven on one base
(`project-management/src/08-DECISIONS/ADR-MS001-SYNTEK-OS-PROFILES-ON-ONE-BASE-27-09-2026.md`); it is
**Later** on the critical path — after the first edition. Its distinguishing axis is Storage stack.

---

## 1. Target user

Someone storing important files at home who wants them shared reliably across the LAN and protected
against a disk failing or a file quietly corrupting. They give up when a rebuild is risky or when the
system cannot tell them a disk is failing.

---

## 2. Principles

1. **Data integrity first.** Redundancy, scrubs and snapshots come before features.
2. **A failing disk is visible early.** SMART and scrub results are surfaced, not buried.
3. **Sharing is on the LAN only.** Files are reachable at home, not on the internet.

---

## 3. Axis values

| Axis | Value | Why | Source | Tested by |
| --- | --- | --- | --- | --- |
| Target user | Stores and shares files reliably; cares about data integrity | Sam's stated NAS use (Q9) | assumption to test | H1 |
| Installer | Guided text installer; the data disks configured separately | The system disk and the data pool are different decisions | assumption to test | H1 |
| Default desktop / shell | Login shell; an optional web dashboard (`ui-10`) | Headless, with a dashboard for storage status | assumption to test | H4 |
| Package-manager exposure | CLI exposed; updates user-started to protect uptime | Storage uptime matters; updates are timed | assumption to test | — |
| Init system | The base init with service supervision | The sharing services run supervised | assumption to test | — (shared base init) |
| Kernel config + update cadence | Storage-focused config; longterm line pinned to the storage layer's supported range | The storage layer (for example OpenZFS) declares a supported kernel range | assumption to test | H2 |
| Documentation & guidance level | Reference plus storage and backup how-tos | Storage operations need clear procedures | assumption to test | H1 |
| Rescue / recovery tooling | Previous kernel kept; array and snapshot recovery documented | Recovering an array is the critical skill | assumption to test | H3 |
| Network exposure & firewall default | File-sharing ports on the LAN only; firewall deny by default | Shares are for the LAN; nothing faces the internet | assumption to test | H4 |
| Storage stack | One lesson per layer — mdadm RAID, LVM, Btrfs subvolumes and snapshots; ZFS as reading (CDDL, pins the kernel line) | The NAS is the profile where the storage layers are taught one at a time | assumption to test | H2, H3 |
| Hardware target | VMs and QEMU disk images only until hardware is chosen by ADR | No hardware is chosen yet (Sam's decision after the critique, 27/09/2026) | assumption to test | — |

---

## 4. Hypotheses

```text
H1  Claim:      the NAS image installs, builds a redundant array and shares a folder by the how-to.
    Test:       in QEMU with several small virtual disks, install, build a RAID or Btrfs array
                and share a folder following the how-to; mount the share from a LAN guest.
    Passes if:  the share mounts and every command used appears in the how-to.
    Tested at:  P6, the NAS edition milestone.

H2  Claim:      the kernel line satisfies the chosen storage layer's supported range.
    Test:       read the storage layer's declared kernel range (for OpenZFS, its release notes),
                compare with the profile's longterm line.
    Passes if:  the line is within the supported range, or the layer is used only as reading.
    Tested at:  P6, the NAS kernel milestone.

H3  Claim:      a lost disk is rebuilt from redundancy following the how-to.
    Test:       in QEMU, remove one virtual disk from the array, add a replacement, rebuild.
    Passes if:  the array returns to healthy and the data is intact, following the how-to.
    Tested at:  P6, the NAS recovery milestone.

H4  Claim:      the NAS exposes only file-sharing ports, on the LAN, behind a default-deny firewall.
    Test:       in QEMU on an isolated network, scan the NAS from a LAN guest.
    Passes if:  only the sharing ports are open and the firewall denies the rest.
    Tested at:  P6, the NAS image milestone.
```

---

## 5. Kernel config for this profile

A storage-focused fragment on the downstream kernel's longterm line, **pinned to the storage layer's
supported kernel range** (`ADR-MS001-KERNEL-DOWNSTREAM-OF-UPSTREAM-27-09-2026.md`). The FSF holds
that ZFS's CDDL cannot be linked with the GPL kernel, and OpenZFS declares a supported kernel range,
so ZFS is studied as reading and the fragment prefers mdadm, LVM and Btrfs; the choice is recorded in
`os-13-nas-edition`. The fragment lives in the downstream kernel repository (created in
`kernel-05-downstream-tree` lesson 02); its plan and record in `project-management/src/06-KERNEL/` at
P5. A Later fragment.

---

## 6. Open questions

| Question | Blocks | Where it goes |
| --- | --- | --- |
| ZFS CDDL versus GPL, and OpenZFS's supported kernel range | Storage stack; Kernel config; H2 | `GAPS.md` Open question; read in `os-13-nas-edition` |
| Which storage layers the profile ships by default | Storage stack | `os-13-nas-edition`; ADR if hard to reverse |
| What hardware the NAS profile targets | Hardware target | `GAPS.md` Open question; ADR when the topic opens |

---

## Cross-references

- `project-management/src/07-OS-PROFILES/PROFILE-MATRIX.md` — this profile's column
- `project-management/src/07-OS-PROFILES/PROFILE-HOMELAB.md` · `PROFILE-SERVER.md` — the neighbouring
  server-family profiles
- `project-management/src/01-ROADMAP/ROADMAP.md` — P5 and P6
- `project-management/src/08-DECISIONS/ADR-MS001-SYNTEK-OS-PROFILES-ON-ONE-BASE-27-09-2026.md`
- `GAPS.md` → "Syntek OS profile definitions are hypotheses"
