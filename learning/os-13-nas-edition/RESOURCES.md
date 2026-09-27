# Resources — os-13-nas-edition

| Lesson | Primary source (pinned) | House guide | Code |
| --- | --- | --- | --- |
| 01 Software RAID with mdadm | docs.kernel.org "RAID arrays", <https://docs.kernel.org/admin-guide/md.html>; mdadm(8), <https://man7.org/linux/man-pages/man8/mdadm.8.html>; BLFS 13.1 mdadm-4.6, <https://www.linuxfromscratch.org/blfs/view/13.1-systemd/postlfs/mdadm.html> | — | `code/src/os/` (planned — added at P6) |
| 02 LVM: volumes, resizing and thin snapshots | `man 8 lvm`, `man 7 lvmthin`; BLFS 13.1 LVM2-2.03.42, <https://www.linuxfromscratch.org/blfs/view/13.1-systemd/postlfs/lvm2.html> | — | `code/src/os/` (planned — added at P6) |
| 03 Btrfs subvolumes and snapshots | Btrfs "Subvolumes", <https://btrfs.readthedocs.io/en/latest/Subvolumes.html>; "btrfs-send", <https://btrfs.readthedocs.io/en/latest/btrfs-send.html> | — | `code/src/os/` (planned — added at P6) |
| 04 ZFS as reading: the licence and the kernel range | OpenZFS "License", <https://openzfs.github.io/openzfs-docs/License.html>; `META` at zfs-2.4.4, <https://github.com/openzfs/zfs/blob/zfs-2.4.4/META>; FSF on Linux and ZFS, <https://www.fsf.org/licensing/zfs-and-linux> | `GAPS.md` (the ZFS open question) | — |
| 05 The NAS kernel fragment | docs.kernel.org "Kconfig Language", <https://docs.kernel.org/kbuild/kconfig-language.html> | the NAS profile spec (PROFILE-NAS in `project-management/src/07-OS-PROFILES/`) | `code/src/kernel/msNNN-profile-fragments/` (planned — added at P4) |
| 06 Sharing with NFS | exports(5), <https://man7.org/linux/man-pages/man5/exports.5.html>; BLFS 13.1 NFS-Utils-2.9.2 | — | `code/src/os/` (planned — added at P6) |
| 07 Sharing with SMB through Samba | smb.conf(5), <https://www.samba.org/samba/docs/current/man-html/smb.conf.5.html>; BLFS 13.1 Samba-4.24.6 | — | `code/src/os/` (planned — added at P6) |
| 08 Integrity: scrubs, drive health and snapshot schedules | Btrfs "Scrub", <https://btrfs.readthedocs.io/en/latest/Scrub.html>; docs.kernel.org "RAID arrays" (`sync_action`); `man 8 smartctl` | — | `code/src/os/` (planned — added at P6) |
