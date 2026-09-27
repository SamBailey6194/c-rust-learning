# Mission — os-13-nas-edition

**Started**: not yet · **Family**: os · **Phase**: P6 · **Milestone**: not yet allocated

## Why

_Drafted from Sam's planning conversation of 27/09/2026 — confirm or rewrite in your own words at
the first lesson._

A NAS version is one of the Syntek OS editions Sam listed alongside the server, homelab and router
versions. It comes after the first edition because it carries the most irreplaceable thing a home
server holds — the data — so it has to survive a failed disk, share files safely with the rest of
the house, and prove its own integrity rather than assume it. Building it one storage layer at a
time also shows where the harder decisions are: ZFS is attractive, but its licence and its kernel
range are questions for an ADR, not a default.

## Can do it when

- Sam can build, fail, rebuild and check a software RAID array in a QEMU guest.
- Sam can layer LVM on the array, grow a volume online and restore from a thin snapshot.
- Sam can lay out Btrfs subvolumes and send a read-only snapshot to another disk, and explain why a
  snapshot is not a backup.
- Sam can state the CDDL and GPLv2 positions on ZFS and the kernel-range consequence, and has fed
  the ZFS open question in `GAPS.md`.
- Sam's NAS kernel fragment merges strictly, builds and boots in QEMU with the array assembled.
- Sam can share over NFS and SMB to named clients only, and prove the refusals from the lab.
- Sam's scheduled scrub finds and repairs a deliberately corrupted copy and raises an alert.

## Parked for later

- Choosing NAS hardware and real drive-health testing — an ADR when this topic opens (`GAPS.md`).
- The NAS web dashboard — `ui-10-web-admin-dashboard`.
- A scanner service for shares — `sec-18-antivirus-and-detection-engineering`.
- Encrypting the data disks beyond the concepts — `os-02-storage-and-boot-fundamentals` lesson 08
  (LUKS2 concepts), applied when the NAS spec asks for it.
