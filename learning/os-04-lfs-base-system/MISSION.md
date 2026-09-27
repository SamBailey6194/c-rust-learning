# Mission — os-04-lfs-base-system

**Started**: not yet · **Family**: os · **Phase**: P6 · **Milestone**: not yet allocated

## Why

_Drafted from Sam's planning conversation of 27/09/2026 — confirm or rewrite in your own words at the first lesson._

Sam's plan runs "C and Rust → kernel development → a kernel off Linux → the distro", and the distro is to be clean and
his own. Finishing Linux From Scratch is the proof that he can take a system from nothing to a login prompt: every
package in order, configured, made bootable and booted. It is also where the problems Syntek OS must solve become real
— tracking what each package installed, upgrading a library without breaking its users, choosing a kernel line that
still gets fixes — so the build system and package manager that follow are answers to problems Sam has already met.

## Can do it when

- Sam has built LFS 13.1's chapter 8 base system in the VM and can explain the build order from Appendix C.
- Sam can explain LFS's package-management techniques and the upgrade issues each must handle, and his build recorded
  which files each package installed.
- Sam has configured the system under systemd and can list what a non-systemd Syntek OS would have to replace.
- Sam's image carries an fstab, a kernel from a supported line, and GRUB for BIOS and UEFI.
- The image boots in QEMU to a login prompt with no failed units, and Sam can diagnose a broken `root=` from its
  messages.
- Sam has measured the image's size and boot time before and after stripping, and kept a final snapshot.

## Parked for later

- Turning the book's steps into recipes and a build system — os-05-build-system-and-reproducibility.
- Syntek OS's own init — os-06-init-and-services and the INIT-SYSTEM-CHOICE research note.
- A real package manager — os-07-package-manager.
- Choosing and tracking a kernel line per profile — kernel-04-kconfig-and-profile-configs and
  kernel-06-kernel-ci-and-security.
- UEFI Secure Boot — `DEFERRED.md` (P6) and sec-13-hardening-and-secure-boot.
