# Syllabus — os-13-nas-edition

**Track**: os · **Phase**: P6 · **Path**: Later · **Detail**: full · **Prerequisites**: `os-12-homelab-edition`; `os-02-storage-and-boot-fundamentals` lessons 01–04 and 08 (block devices, disk images, GPT, filesystems, LUKS2); `os-09-networking-fundamentals` (the isolated lab); `kernel-04-kconfig-and-profile-configs` lessons 02 and 06 (the fragment method, the first-edition fragments); `tooling-05-licensing-and-collaboration` (for lesson 04)
**Status**: Planned · **Checked**: 27/09/2026 (sources re-verified by `/teach` step 3 before each lesson)

The NAS profile is the server family's storage specialist: it keeps data safe across disk failures,
shares it on the home network, and proves its integrity on a schedule. The topic takes the storage
stack one layer per lesson — software RAID, LVM, Btrfs, then ZFS as reading only, because its
licence and its declared kernel range are decisions in their own right — then writes the NAS kernel
fragment with `kernel-04`'s method, shares data over NFS and SMB, and ends with scrubs, drive health
and snapshot schedules. It is marked **Later**: the first edition (server and homelab) does not wait
for it. Every lesson runs in a QEMU guest with several virtual disks; no NAS hardware has been chosen,
and it is chosen by ADR when this topic opens (`GAPS.md`). The NAS web dashboard is
`ui-10-web-admin-dashboard`'s work. Small scripts land in `code/src/os/` (planned — added at P6); the
profile's recipes land in the Syntek OS build-system repository, created when that build starts.

| # | Lesson | Size | Build | Lenses |
| --- | --- | --- | --- | --- |
| 01 | Software RAID with mdadm | 2–3 sittings | yes — fail and rebuild an array | Efficiency, Safety |
| 02 | LVM: volumes, resizing and thin snapshots | 1 sitting | yes — LVM on the array | Safety |
| 03 | Btrfs subvolumes and snapshots | 1 sitting | yes — subvolume layout and send | Safety |
| 04 | ZFS as reading: the licence and the kernel range | 1 sitting | no | Security |
| 05 | The NAS kernel fragment | 1 sitting | yes — NAS fragment | Efficiency, Security, Safety |
| 06 | Sharing with NFS | 1 sitting | yes — NFS export test | Security, Safety |
| 07 | Sharing with SMB through Samba | 1 sitting | yes — SMB share test | Security, Safety |
| 08 | Integrity: scrubs, drive health and snapshot schedules | 2–3 sittings | yes — scrub and repair drill | Efficiency, Safety |

---

## 01 — Software RAID with mdadm

- **Objective:** Sam can build a software RAID array from virtual disks, fail a member, rebuild it
  and run a consistency check, and say what each RAID level trades.
- **Builds on:** `os-02-storage-and-boot-fundamentals` lessons 01–03 (block devices, disk images,
  GPT).
- **Key ideas:**
  - RAID levels trade usable capacity, the failures survived and the cost of writes (mirroring
    against parity).
  - md is the kernel's RAID driver and mdadm its tool; an array runs degraded after a failure and
    rebuilds onto a replacement.
  - A `check` pass reads every block and counts mismatches (`mismatch_cnt`); `repair` also rewrites
    them.
  - RAID keeps a service running through a disk failure; it is not a backup (`os-11` lesson 06).
- **Recall targets:** what each common level survives; what degraded means; what `check` does that
  a normal read does not.
- **Build:** in a NAS test guest with four virtual disks, create an array, fail and remove one member,
  add a replacement and watch the rebuild, then run a check — a script in `code/src/os/` (planned —
  added at P6) that records each state from the kernel's view.
- **Efficiency lens:** rebuild time and throughput for the chosen level, measured in the guest.
- **Safety:** virtual disks only (image files attached to the QEMU guest); never a host disk.
- **Sources:** docs.kernel.org, "RAID arrays" (`sync_action`, `mismatch_cnt`; v7.3-rc4 render),
  <https://docs.kernel.org/admin-guide/md.html>; mdadm(8), <https://man7.org/linux/man-pages/man8/mdadm.8.html>;
  BLFS 13.1 "About RAID" and mdadm-4.6, <https://www.linuxfromscratch.org/blfs/view/13.1-systemd/postlfs/raid.html>
  and <https://www.linuxfromscratch.org/blfs/view/13.1-systemd/postlfs/mdadm.html>.
- **Done when:** the script shows the array healthy, degraded, rebuilding and healthy again, and a
  clean check.

## 02 — LVM: volumes, resizing and thin snapshots

- **Objective:** Sam can put LVM on top of the array, create and grow logical volumes, and take a thin
  snapshot, explaining where LVM sits in the stack.
- **Builds on:** lesson 01; `os-10-profiles-and-installer` lesson 04 (root on an LVM logical volume is
  one of the BLFS reasons for an initramfs).
- **Key ideas:**
  - Physical volumes form a volume group, which is carved into logical volumes; device-mapper does
    the mapping underneath.
  - Growing a volume and then its filesystem is routine; shrinking is where data is lost.
  - Thin pools allocate on demand; thin snapshots share blocks with their origin.
  - Layering order (LVM on RAID, or RAID inside LVM) decides what a failure takes with it.
- **Recall targets:** PV, VG and LV in one sentence each; the order of a safe grow; what a thin
  snapshot shares.
- **Build:** LVM on lesson 01's array: two volumes, one grown online, and a thin snapshot restored
  after a deliberate change — added to lesson 01's script in `code/src/os/` (planned — added at P6).
- **Safety:** virtual disks only.
- **Sources:** `man 8 lvm` and `man 7 lvmthin` (installed on the host); BLFS 13.1 "About Logical Volume
  Management (LVM)" and LVM2-2.03.42, <https://www.linuxfromscratch.org/blfs/view/13.1-systemd/postlfs/aboutlvm.html>
  and <https://www.linuxfromscratch.org/blfs/view/13.1-systemd/postlfs/lvm2.html>.
- **Done when:** the volume grows without unmounting and the thin snapshot restores the earlier
  state.

## 03 — Btrfs subvolumes and snapshots

- **Objective:** Sam can lay out a Btrfs filesystem in subvolumes, take read-only snapshots and send
  one to another filesystem, and explain why a snapshot is not a backup.
- **Builds on:** lesson 01; `os-02-storage-and-boot-fundamentals` lesson 04 (filesystems).
- **Key ideas:**
  - A subvolume is an independently mountable tree inside one filesystem; a snapshot is a subvolume
    with given initial content, read-write by default.
  - Read-only snapshots are the building blocks of `btrfs send` and `receive`, which replicate a
    snapshot to another filesystem, fully or incrementally.
  - A snapshot shares its data blocks with the original, so damage to those blocks damages both — it
    is not a backup.
  - Btrfs checksums data and metadata, which is what lesson 08's scrub relies on.
- **Recall targets:** subvolume versus directory; why send needs read-only snapshots; the failure a
  snapshot does not survive.
- **Build:** a subvolume layout for shares, a read-only snapshot, and an incremental send to a second
  virtual disk, with a script in `code/src/os/` (planned — added at P6) that verifies the received
  copy.
- **Safety:** virtual disks only.
- **Sources:** Btrfs documentation, "Subvolumes" and "btrfs-send" (read 27/09/2026),
  <https://btrfs.readthedocs.io/en/latest/Subvolumes.html> and
  <https://btrfs.readthedocs.io/en/latest/btrfs-send.html>; BLFS 13.1 btrfs-progs-7.1,
  <https://www.linuxfromscratch.org/blfs/view/13.1-systemd/postlfs/btrfs-progs.html>.
- **Done when:** the incremental send arrives intact and Sam explains the shared-block failure case.

## 04 — ZFS as reading: the licence and the kernel range

- **Objective:** Sam can explain why ZFS cannot be built into the Syntek OS kernel image, what
  shipping it as a separate module would involve, and how OpenZFS's declared kernel range would pin
  the NAS kernel line.
- **Builds on:** `tooling-05-licensing-and-collaboration` (copyleft and licence compatibility);
  `kernel-04-kconfig-and-profile-configs` lesson 04 (longterm or stable, per profile).
- **Key ideas:**
  - OpenZFS is CDDL-licensed and Linux is GPLv2. The FSF's statement calls the CDDL incompatible with
    every GPL version, so the two cannot be linked; OpenZFS's own licence page says the combination
    cannot be distributed as one kernel binary but that nothing prevents a separate binary module or
    source. Legal opinions differ, so the NAS decision is an ADR, not a lesson outcome.
  - OpenZFS 2.4.4 declares Linux 4.18 to 7.2 in its `META` file. On 27/09/2026 the stable kernel is
    7.2.8 and mainline is 7.3-rc4, so a ZFS-based NAS would follow a longterm line inside that range
    (6.18 is longterm) and wait whenever the range lags.
  - A kernel pinned by one out-of-tree module is a maintenance cost the downstream kernel carries on
    every rebase.
- **Recall targets:** the two licence positions in one sentence each; where the kernel range is
  declared; what a lagging range does to the NAS kernel line.
- **Build:** none — the output is Sam's input to the ZFS open question in `GAPS.md` and, if ZFS is
  pursued, a research note feeding an ADR.
- **Security lens:** an out-of-tree filesystem module delays kernel security updates when its range
  lags.
- **Sources:** OpenZFS documentation, "License", <https://openzfs.github.io/openzfs-docs/License.html>;
  OpenZFS `META` at tag zfs-2.4.4, <https://github.com/openzfs/zfs/blob/zfs-2.4.4/META>, and the
  release notes, <https://github.com/openzfs/zfs/releases/tag/zfs-2.4.4>; FSF, "Interpreting,
  enforcing and changing the GNU GPL, as applied to combining Linux and ZFS",
  <https://www.fsf.org/licensing/zfs-and-linux>; kernel.org, "Active kernel releases",
  <https://www.kernel.org/category/releases.html>.
- **Done when:** Sam states both positions and the kernel-range consequence unaided, and the GAPS
  entry reflects his reading.

## 05 — The NAS kernel fragment

- **Objective:** Sam can write the NAS profile's kernel fragment with `kernel-04`'s method and justify
  each line against the NAS threat model and budget.
- **Builds on:** `kernel-04-kconfig-and-profile-configs` lessons 02, 06 and 07 (the fragment method,
  the first-edition fragments, measuring a config); lessons 01–03.
- **Key ideas:**
  - The NAS fragment adds only what the storage stack and sharing need (md, device-mapper, the chosen
    filesystems, the NFS server) on top of the base fragment.
  - Storage controller drivers wait for the hardware ADR; until then the QEMU virtual devices stand in.
  - The kernel line is longterm, as for the rest of the server family
    (`project-management/src/08-DECISIONS/ADR-MS001-KERNEL-DOWNSTREAM-OF-UPSTREAM-27-09-2026.md`).
  - Every option added is attack surface and image size; measure both.
- **Recall targets:** which options the NAS needs that the server does not; why hardware drivers
  wait; how the fragment is checked.
- **Build:** the NAS fragment, merged strictly over the base with `kernel-04` lesson 02's script,
  alongside the other fragments in `code/src/kernel/msNNN-profile-fragments/` (planned — added at P4)
  or the downstream kernel repository once `kernel-05-downstream-tree` has created it. Checked by a
  warning-free strict merge on the compiler recorded in `kernel-04` lesson 03 (whose base excludes the
  options that compiler cannot build), a build, and a QEMU boot that assembles lesson 01's array.
- **Efficiency lens:** image size, module count and boot time with `kernel-04` lesson 07's script.
- **Security lens:** each line reviewed against the NAS profile's threat model.
- **Safety:** the NAS kernel boots in QEMU only.
- **Sources:** docs.kernel.org, "Kconfig Language", <https://docs.kernel.org/kbuild/kconfig-language.html>;
  docs.kernel.org, "RAID arrays", <https://docs.kernel.org/admin-guide/md.html>;
  the NAS profile spec (PROFILE-NAS in `project-management/src/07-OS-PROFILES/`).
- **Done when:** the merge, build and boot pass and Sam defends any line he is asked about.

## 06 — Sharing with NFS

- **Objective:** Sam can export a share over NFS to named clients with root squashing and a chosen
  security flavour, and prove the restrictions from a client.
- **Builds on:** `os-09-networking-fundamentals` (the isolated lab); `os-11-server-edition` lesson 04
  (the host firewall); lesson 03.
- **Key ideas:**
  - `/etc/exports` names each export, the clients allowed and per-client options (`ro`, `rw`).
  - Root squashing maps a client's root to an anonymous user and is the default; `no_root_squash`
    trusts every client's root.
  - The `sec=` option picks the security flavour: `sys` trusts the client's claimed identity, while
    `krb5`, `krb5i` and `krb5p` add authentication, integrity and privacy.
  - Transport protection comes from RPC-with-TLS or a VPN, not from NFS's defaults.
- **Recall targets:** what root squashing prevents; what `sec=sys` trusts; how an unlisted client is
  refused.
- **Build:** an NFS export from the NAS guest to a client guest in the lab, with a test script in
  `code/src/os/` (planned — added at P6) asserting that the client's root is squashed and an unlisted
  client is refused.
- **Security lens:** identity with `sec=sys` is only as good as the client network; export to named
  clients only.
- **Safety:** isolated virtual network only, never the home LAN.
- **Sources:** exports(5), <https://man7.org/linux/man-pages/man5/exports.5.html>; BLFS 13.1
  NFS-Utils-2.9.2, <https://www.linuxfromscratch.org/blfs/view/13.1-systemd/basicnet/nfs-utils.html>.
- **Done when:** both assertions pass and Sam explains the `sec=sys` trust assumption.

## 07 — Sharing with SMB through Samba

- **Objective:** Sam can publish an SMB share with Samba for named users only, with SMB1 off and
  encryption required, and prove it from a client.
- **Builds on:** lesson 06; `os-11-server-edition` lesson 02 (accounts).
- **Key ideas:**
  - `smb.conf` has a `[global]` section and one section per share.
  - `server min protocol` defaults to `SMB2_02`, so SMB1 is off unless someone turns it back on.
  - `server smb encrypt` controls whether clients may or must encrypt, per share or globally.
  - Samba users map to Unix accounts, so `os-11`'s account rules apply; guest access stays off.
- **Recall targets:** why SMB1 stays off; how a Samba user relates to a Unix account; how to require
  encryption.
- **Build:** a share from the NAS guest, used from a client guest with `smbclient`, and a test script
  in `code/src/os/` (planned — added at P6) asserting that anonymous access and an SMB1 connection are
  both refused.
- **Security lens:** anonymous and legacy-protocol access are the classic NAS weaknesses.
- **Safety:** isolated virtual network only.
- **Sources:** smb.conf(5), <https://www.samba.org/samba/docs/current/man-html/smb.conf.5.html>
  (`server min protocol`, `server smb encrypt`); BLFS 13.1 Samba-4.24.6,
  <https://www.linuxfromscratch.org/blfs/view/13.1-systemd/basicnet/samba.html>.
- **Done when:** both refusals are shown and a named user reads and writes the share.

## 08 — Integrity: scrubs, drive health and snapshot schedules

- **Objective:** Sam can schedule scrubs, array checks and snapshot rotation, raise an alert when one
  finds a problem, and show a scrub repairing a corrupted copy.
- **Builds on:** lessons 01–03; `os-12-homelab-edition` lesson 05 (alerting); `os-11-server-edition`
  lesson 05 (scheduled jobs).
- **Key ideas:**
  - A Btrfs scrub reads data and metadata, verifies checksums and repairs damage from a good copy
    where redundancy exists; an md `check` does the equivalent for an array.
  - Drive health comes from SMART self-tests on real drives; a virtual disk has no physical health
    to report, so real tests wait for the NAS hardware ADR.
  - Snapshots on a schedule with a retention rule give quick undo; backups (`os-11` lesson 06) are
    still required.
  - An integrity job that fails silently is worse than none: every result reaches an alert.
- **Recall targets:** what a scrub verifies and when it can repair; why SMART is tested only on real
  hardware; what the retention rule protects against.
- **Build:** a scheduled job for scrub, array check and snapshot rotation, alerting through `os-12`
  lesson 05's endpoint; tested by corrupting data on one mirror's image file and watching the scrub
  repair it — `code/src/os/` (planned — added at P6).
- **Efficiency lens:** scrub duration and its I/O pressure on the running shares (`os-12` lesson 04).
- **Safety:** corruption is applied to a guest's image file only, never to a host disk.
- **Sources:** Btrfs documentation, "Scrub", <https://btrfs.readthedocs.io/en/latest/Scrub.html>;
  docs.kernel.org, "RAID arrays" (`sync_action`), <https://docs.kernel.org/admin-guide/md.html>;
  `man 8 smartctl` (smartmontools, installed on the host).
- **Done when:** the scrub reports and repairs the corruption, the alert fires, and snapshots rotate
  by the rule.
