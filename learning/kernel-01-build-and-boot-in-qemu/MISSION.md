# Mission — kernel-01-build-and-boot-in-qemu

**Started**: not yet · **Family**: kernel · **Phase**: P4 · **Milestone**: not yet allocated

## Why

_Drafted from Sam's planning conversation of 27/09/2026 — confirm or rewrite in your own words at the first lesson._

Sam's plan runs "learn C and Rust → kernel development → a kernel off Linux → the distro". He asked whether editing
the kernel needs C, and chose to base Syntek OS on the standard Linux kernel as a downstream that takes its updates
from upstream rather than a fork. Before any of that can happen he has to be able to take a kernel release, configure
it, build it and boot it himself — safely, in QEMU, never on the machine he learns on. This topic is that first step,
and the boot harness built here is the one the Syntek OS lessons reuse when they need a kernel to boot.

## Can do it when

- Name the mainline, stable and longterm lines, their cadence and today's versions, read from kernel.org on the day.
- Fetch a pinned kernel release outside this repository and verify its signature before building it.
- Produce a `.config` from defconfig, from tinyconfig and by merging a committed fragment, and explain each step.
- Build out of tree with `O=` and say what `bzImage` and `vmlinux` are for, with build time and image size measured.
- Pack a busybox initramfs by hand and boot it in QEMU on a serial console, with no disk and no network, by hand and
  from a script that fails on a panic.
- Diagnose a failed boot from its console messages, and break into the kernel with gdb through QEMU's gdb stub.

## Parked for later

- Kconfig language, hardening and the profile fragments → kernel-04-kconfig-and-profile-configs.
- An initramfs for real root filesystems and live ISOs, and booting under UEFI → os-10-profiles-and-installer
  (with os-02-storage-and-boot-fundamentals for when an initramfs is required).
- Installing a kernel into a root filesystem and booting it through GRUB → os-04-lfs-base-system.
- Secure Boot and signed kernels → sec-13-hardening-and-secure-boot and `DEFERRED.md`.
- Rust in the kernel → kernel-08-rust-for-linux.
