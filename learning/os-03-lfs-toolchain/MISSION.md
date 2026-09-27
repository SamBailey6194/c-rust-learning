# Mission — os-03-lfs-toolchain

**Started**: not yet · **Family**: os · **Phase**: P6 · **Milestone**: not yet allocated

## Why

_Drafted from Sam's planning conversation of 27/09/2026 — confirm or rewrite in your own words at the first lesson._

Sam wants "a clean distro" — Syntek OS built from scratch, not a fork of NixOS or anything else — and the planned path
to it runs through Linux From Scratch before any automated build system. The toolchain is where that starts: nothing
in Syntek OS can be trusted to be independent of the machine that built it unless the compiler, linker and C library
were themselves built so they cannot reach back into the host. Building them by hand once, in a VM, is how Sam learns
what every later Syntek OS recipe will automate.

## Can do it when

- Sam can prepare a build VM that passes LFS 13.1's host checks, with the unprivileged `lfs` user and a clean
  environment, and explain why the build is not run as root.
- Sam can name the build, host and target for each toolchain stage and explain `--with-sysroot`.
- Sam can build an autotools package and a meson package into a `DESTDIR` staging tree and read what each installs.
- Sam has built LFS chapter 5's cross toolchain, and its glibc sanity check passes.
- Sam has built chapter 6's temporary tools and can show from `readelf` that they do not depend on the host.
- Sam has entered the chroot, finished chapter 7 and saved a backup and a VM snapshot of the temporary system.

## Parked for later

- The base system, system configuration and first boot — os-04-lfs-base-system.
- Automating these steps as recipes — os-05-build-system-and-reproducibility.
- glibc or musl for Syntek OS itself — a Frontier node on the Syntek OS map, decided by ADR.
- Namespaces and sandboxes as real isolation — sec-04-linux-security-model.
