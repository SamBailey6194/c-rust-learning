# Resources — os-02-storage-and-boot-fundamentals

| Lesson | Primary source (pinned) | House guide | Code |
| --- | --- | --- | --- |
| 01 Block devices, partitions and sysfs | `man 8 lsblk` (util-linux 2.39.3); `Documentation/ABI/stable/sysfs-block` at v7.2.8, <https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/plain/Documentation/ABI/stable/sysfs-block?h=v7.2.8> | `how-to/docs/CLI-TOOLING.md` | — |
| 02 Disk images and loop devices | `man 1 qemu-img` (QEMU 8.2.2); QEMU "Disk Images", <https://www.qemu.org/docs/master/system/images.html>; `man 8 losetup` | `how-to/docs/CLI-TOOLING.md` | `code/src/os/msNNN-disk-image/` (planned — added at P6) |
| 03 GPT and MBR on a disk image | `man 8 sfdisk` ("INPUT FORMATS"), `man 8 fdisk` ("DISK LABELS"); UAPI "Discoverable Partitions Specification", <https://uapi-group.org/specifications/specs/discoverable_partitions_specification/> | — | `code/src/os/msNNN-disk-image/` (planned — added at P6) |
| 04 Filesystems, mounting, fstab, UUID and PARTUUID | `man 8 mkfs.ext4` (e2fsprogs 1.47.0), `man 5 fstab`, `man 8 blkid`; `block/early-lookup.c` at v7.2.8, <https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/plain/block/early-lookup.c?h=v7.2.8> | — | `code/src/os/msNNN-disk-image/` (planned — added at P6) |
| 05 Firmware boot: BIOS, UEFI, the ESP and OVMF | LFS 13.1-systemd Sections 2.4.1 and 10.4.4, <https://www.linuxfromscratch.org/lfs/view/stable-systemd/chapter10/grub.html>; `ovmf` 2024.02 `README.Debian` (host) | — | `code/src/os/msNNN-disk-image/` (planned — added at P6) |
| 06 Boot loaders and the kernel command line | GNU GRUB Manual (2.12 via `info grub` on the host; LFS 13.1 builds GRUB 2.14 — re-check options against the 2.14 manual in the build VM); `systemd-boot(7)`, <https://www.freedesktop.org/software/systemd/man/latest/systemd-boot.html>; `man 7 bootparam` | — | — |
| 07 When an initramfs is required | BLFS 13.1 systemd "About initramfs", <https://www.linuxfromscratch.org/blfs/view/stable-systemd/postlfs/initramfs.html>; "The Linux Microcode Loader", <https://docs.kernel.org/arch/x86/microcode.html> | — | — |
| 08 Disk-encryption concepts: LUKS2 | `man 8 cryptsetup` (cryptsetup 2.7.0); "dm-crypt", <https://docs.kernel.org/admin-guide/device-mapper/dm-crypt.html>; LUKS2 docs, <https://gitlab.com/cryptsetup/LUKS2-docs> | — | `code/src/os/msNNN-disk-image/` (planned — added at P6) |
