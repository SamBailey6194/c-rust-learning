# Resources — os-04-lfs-base-system

| Lesson | Primary source (pinned) | House guide | Code |
| --- | --- | --- | --- |
| 01 Building the base packages, and why the order matters | LFS 13.1-systemd Chapter 8, <https://www.linuxfromscratch.org/lfs/view/stable-systemd/chapter08/introduction.html>; Appendix C, <https://www.linuxfromscratch.org/lfs/view/stable-systemd/appendices/dependencies.html> | — | — (build VM) |
| 02 Package management the LFS way | LFS 13.1-systemd Section 8.2, <https://www.linuxfromscratch.org/lfs/view/stable-systemd/chapter08/pkgmgt.html>; `man 8 ldconfig` | — | — (build VM) |
| 03 System configuration with systemd | LFS 13.1-systemd Chapter 9, Sections 9.2, 9.3, 9.10, <https://www.linuxfromscratch.org/lfs/view/stable-systemd/chapter09/introduction.html>; LFS "Read" page, <https://www.linuxfromscratch.org/lfs/read.html> | — | — (build VM) |
| 04 Making it bootable: fstab, a kernel and GRUB | LFS 13.1-systemd Chapter 10, <https://www.linuxfromscratch.org/lfs/view/stable-systemd/chapter10/introduction.html>; kernel.org, <https://www.kernel.org/> (7.1 end-of-life, read 27/09/2026) | — | — (build VM) |
| 05 First boot in QEMU | LFS 13.1-systemd Section 11.3, <https://www.linuxfromscratch.org/lfs/view/stable-systemd/chapter11/reboot.html>; "No working init found", <https://docs.kernel.org/admin-guide/init.html> | `code/docs/DEBUGGING.md` — Section 6 | `code/src/os/msNNN-disk-image/` (planned — added at P6) |
| 06 Stripping, cleanup and snapshots | LFS 13.1-systemd Sections 8.83–8.85, <https://www.linuxfromscratch.org/lfs/view/stable-systemd/chapter08/stripping.html>; `man 1 strip` | — | — (build VM) |
