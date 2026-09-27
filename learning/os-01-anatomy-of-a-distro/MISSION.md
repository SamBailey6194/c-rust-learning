# Mission — os-01-anatomy-of-a-distro

**Started**: not yet · **Family**: os · **Phase**: P6 · **Milestone**: not yet allocated

## Why

_Drafted from Sam's planning conversation of 27/09/2026 — confirm or rewrite in your own words at the first lesson._

Sam's first question in planning was how hard it would be to learn C well enough "to build my own Linux distro off the
kernel", and when a NixOS fork came up he was clear: "I want a clean distro." Syntek OS is to be independent — built
from scratch, with profiles for desktops and laptops, servers, NAS, homelab and routers on one base. Before building
one, Sam needs to know what a distribution is made of: how a machine boots, where every file lives, what the toolchain
produces, and what an independent distribution has to own that a derivative inherits. This topic is that map; every
later Syntek OS topic fills in one part of it.

## Can do it when

- Sam can draw the boot chain from firmware to a login prompt and predict where a boot stops for a named fault.
- Sam can place a package's files in the filesystem hierarchy and justify each placement.
- Sam can say what the C library, the compiler and binutils each contribute, with concrete glibc and musl differences.
- Sam can build a shared library with a soname, inspect it with `readelf`, and predict how the dynamic loader finds it;
  the exercise passes `make test`, `make san` and `make memcheck`.
- Sam can compare how Arch, Alpine, Void and Gentoo own their package format, build system, repositories and release.
- Sam can explain the three ideas Syntek OS borrows from NixOS and how each would be built from scratch.

## Parked for later

- Partitions, filesystems, firmware and boot loaders in depth — os-02-storage-and-boot-fundamentals.
- Build, host and target triplets and the sysroot — os-03-lfs-toolchain.
- The choice of init system — os-06-init-and-services and the INIT-SYSTEM-CHOICE research note.
- Hardening mitigations (PIE, stack protector, RELRO) in depth — sec-02-memory-corruption-and-mitigations.
- The declarative system configuration file itself — os-10-profiles-and-installer.
