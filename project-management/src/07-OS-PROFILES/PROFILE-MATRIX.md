# PROFILE-MATRIX — The Seven Syntek OS Profiles Compared

**Last Updated**: 28/09/2026 | **Version**: 0.1.0 | **Maintained By**: Sam Bailey
**Language**: British English (en_GB) | **Timezone**: Europe/London

**Status:** Draft — every cell is a hypothesis to research and then test at P5 and P6, not a decision.

The seven Syntek OS profiles on eleven fixed axes. All seven share one base, build system and package
set (`project-management/src/08-DECISIONS/ADR-MS001-SYNTEK-OS-PROFILES-ON-ONE-BASE-27-09-2026.md`);
a profile is a package set, a set of defaults, a kernel fragment and its installer choices. The
profiles split into two families, shown as two tables with identical axis rows: the **desktop
profiles** (beginner, intermediate, expert — for laptops and PCs) and the **server family** (server,
NAS, homelab, router). Each cell is the profile's value exactly as its profile file states it; the
reasoning, the source and the QEMU test for each value live in the profile file.

The axes are fixed so the profiles stay comparable: adding or renaming one changes every profile and
goes through an ADR first (`CLAUDE.md` → Guardrails). The eight scaffold axes gained three —
**Network exposure & firewall default**, **Storage stack** and **Hardware target** — because the
server family's defining choices had nowhere to live in the desktop-only axis set
(`ADR-MS001-SYNTEK-OS-PROFILES-ON-ONE-BASE-27-09-2026.md`).

---

## Desktop profiles

| Axis | Beginner | Intermediate | Expert |
| --- | --- | --- | --- |
| **Target user** | New to Linux; has never installed an operating system | Uses a terminal daily; has run a mainstream distribution | Builds from source; reads kernel configs and init scripts |
| **Installer** | Guided installer with safe defaults; whole-disk install | Guided text installer with manual partitioning | No installer: a documented manual install |
| **Default desktop / shell** | A reused desktop (candidate: KDE Plasma or GNOME), if feasible and testable | Login shell; an optional lightweight desktop (candidate: Xfce or COSMIC) | A Wayland tiling compositor (candidate: Sway or Hyprland), or a login shell |
| **Package-manager exposure** | Hidden behind a few curated commands; updates automatic | Package manager CLI exposed, with confirmation prompts | Fully exposed, including building packages from source |
| **Init system** | The base init (chosen later by ADR); shared across profiles | The base init, shared on purpose | The base init; a minimal init the user can read is a lesson (os-06) |
| **Kernel config + update cadence** | Broad hardware config, most drivers as modules; stable line; automatic updates | Trimmed config for common and virtual hardware; stable line; user-started updates | Minimal config the user rebuilds; stable line; user builds each update |
| **Documentation & guidance level** | Task-first plain-language guides; a first-boot welcome; errors say what to do next | Reference manual plus how-tos that explain what each tool does | Terse reference: man pages and one handbook |
| **Rescue / recovery tooling** | Previous kernel in the boot menu; a guided recovery mode | Previous kernel kept; a documented initramfs emergency shell | Busybox rescue shell in the initramfs; recovery documented, done by hand |
| **Network exposure & firewall default** | No inbound services; firewall closed by default | No inbound services by default; firewall closed, opened per need | User's choice; firewall closed by default, opened knowingly |
| **Storage stack** | Single ext4 root on the whole disk | Manual partitioning; ext4 or Btrfs by choice; LUKS for a laptop | Whatever the user builds; LVM, Btrfs subvolumes or LUKS as chosen |
| **Hardware target** | Laptops and PCs — VMs and QEMU disk images only until hardware is chosen by ADR | Laptops and PCs — VMs and QEMU disk images only until hardware is chosen by ADR | Laptops and PCs — VMs and QEMU disk images only until hardware is chosen by ADR |

---

## Server family

| Axis | Server | NAS | Homelab | Router |
| --- | --- | --- | --- | --- |
| **Target user** | Runs headless services and wants them stable and patched | Stores and shares files reliably; cares about data integrity | Runs containers and VMs for self-hosting and experiment | Routes and filters traffic between networks |
| **Installer** | Guided text installer; whole-disk or manual | Guided text installer; the data disks configured separately | Guided text installer; manual for storage and virtualisation | Minimal installer or an image written to the device |
| **Default desktop / shell** | Login shell only; managed over SSH | Login shell; an optional web dashboard (`ui-10`) | Login shell only; managed over SSH | Login shell; an optional web dashboard (`ui-10`) |
| **Package-manager exposure** | CLI exposed; unattended security updates | CLI exposed; updates user-started to protect uptime | Fully exposed | Minimal; updates deliberate and tested |
| **Init system** | The base init with service supervision | The base init with service supervision | The base init with service supervision | The base init, minimal |
| **Kernel config + update cadence** | Tuned config; longterm line; unattended security updates | Storage-focused config (see Storage stack); longterm line pinned to the storage layer's supported range | Config for KVM and containers; longterm line; user-started updates | Minimal hardened config; longterm line; deliberate updates |
| **Documentation & guidance level** | Reference manual and runbooks | Reference plus storage and backup how-tos | Reference plus container and VM how-tos | Reference plus a security and firewall handbook |
| **Rescue / recovery tooling** | Previous kernel kept; a documented emergency shell; a restore drill | Previous kernel kept; array and snapshot recovery documented | Previous kernel kept; container and VM state recovery documented | Previous kernel kept; a documented reset to a known-good config |
| **Network exposure & firewall default** | SSH only; host firewall on, deny by default | File-sharing ports on the LAN only; firewall deny by default | Services on the LAN; administration and metrics on the management network only; DNS and DHCP consumed from the router, not served; firewall deny by default | The routing/NAT/firewall subject itself; deny by default on the untrusted side |
| **Storage stack** | Root plus a data volume; ext4 or Btrfs | One lesson per layer — mdadm RAID, LVM, Btrfs subvolumes and snapshots; ZFS as reading (CDDL, pins the kernel line) | LVM or Btrfs for VM and container images | Small, simple root; no data pooling |
| **Hardware target** | A business server — VMs and QEMU disk images only until hardware is chosen by ADR | VMs and QEMU disk images only until hardware is chosen by ADR | VMs and QEMU disk images only until hardware is chosen by ADR | VMs and isolated virtual networks only until hardware is chosen by ADR |

---

## Reading the matrix

- **The two families answer the same eleven questions.** A difference between profiles is a choice,
  not an omission, because every profile has a value on every axis.
- **Shared values are deliberate or they are mistakes.** The profiles share one base init on purpose:
  one init to document and test. Any other shared cell is either argued in both profile files or is an
  error.
- **The kernel row is where P5 starts.** Each profile's kernel config and update cadence becomes a
  Kconfig fragment and a `KERNEL-PLAN-...` in `project-management/src/06-KERNEL/`, on the downstream
  kernel (`ADR-MS001-KERNEL-DOWNSTREAM-OF-UPSTREAM-27-09-2026.md`). The server and homelab fragments
  are the first edition.
- **Hardware is not chosen yet.** Every profile's Hardware target is "VMs and QEMU disk images only
  until hardware is chosen by ADR" (Sam's decision after the critique, 27/09/2026); `GAPS.md` holds
  one Open question covering all of them.
- **Nothing here is decided.** The init system, package signing and each profile's kernel line are
  hard to reverse and each gets an ADR or a research note before P6 builds on it. Until then, every
  cell is a hypothesis.

---

## Open questions shared across profiles

| Question | Why it matters | Where it goes |
| --- | --- | --- |
| Which init system Syntek OS ships | Decides the Init system row for every profile | `research/INIT-SYSTEM-CHOICE.md` (planned), then an ADR; the learning build follows LFS systemd meanwhile |
| Which stable or longterm line each profile follows | Decides the Kernel row per profile | `research/LTS-VS-STABLE-PER-PROFILE.md` (planned); a follow-on to `ADR-MS001-KERNEL-DOWNSTREAM-OF-UPSTREAM-27-09-2026.md` |
| Which package format and signing scheme | Decides Package-manager exposure and the update flow | `research/PACKAGE-SIGNING-SCHEME.md` (planned), then an ADR |
| ZFS CDDL for the NAS profile and its kernel range | The FSF says CDDL cannot be linked with GPL; OpenZFS declares a supported kernel range that pins the NAS line | `GAPS.md` Open question; read in `os-13-nas-edition` |
| What hardware each profile targets | Decides the Hardware target row | `GAPS.md` → one Open question for all profiles; an ADR per profile when its topic opens |

---

## Cross-references

- `project-management/src/07-OS-PROFILES/PROFILE-BEGINNER.md` · `PROFILE-INTERMEDIATE.md` ·
  `PROFILE-EXPERT.md` — the desktop profiles
- `project-management/src/07-OS-PROFILES/PROFILE-SERVER.md` · `PROFILE-NAS.md` · `PROFILE-HOMELAB.md`
  · `PROFILE-ROUTER.md` — the server family
- `project-management/workflows/07-os-profile-spec/` — the procedure that keeps matrix and profile
  files in step
- `project-management/src/01-ROADMAP/ROADMAP.md` — P5 and P6
- `project-management/src/08-DECISIONS/ADR-MS001-SYNTEK-OS-PROFILES-ON-ONE-BASE-27-09-2026.md` — the
  seven profiles, one base, and the eleven-axis decision
- `GAPS.md` → "Syntek OS profile definitions are hypotheses" — the register entry that says this
  matrix is a first guess
