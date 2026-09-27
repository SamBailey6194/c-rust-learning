# Mission — os-10-profiles-and-installer

**Started**: not yet · **Family**: os · **Phase**: P6 · **Milestone**: not yet allocated

## Why

_Drafted from Sam's planning conversation of 27/09/2026 — confirm or rewrite in your own words at
the first lesson._

Sam wants one clean distribution of his own — "not a Nix fork", built from scratch — with beginner,
intermediate and expert versions for laptops and PCs, and server, NAS, homelab and router versions.
The plan is to keep those as profiles on one base, so one build system and one package set serve
every edition and a fix reaches all of them; the conversation recommended shipping the server and
homelab edition first (to confirm). This topic is where that happens: profiles resolve from the
base, a declarative configuration file describes a machine (the idea Sam already uses in NixOS,
rebuilt without Nix), and an installer backend turns that description into an installed, bootable
disk — the backend a friendly installer TUI will later drive.

## Can do it when

- Sam can describe a profile as the base plus packages, defaults, a kernel fragment and boot modes,
  and resolve a layered profile's package set (tests in lesson 01's crate pass).
- Sam can design and validate a declarative machine configuration with a schema and merge rules.
- Sam can build a partitioned disk image and a qcow2 from a root-filesystem directory without root
  on the host, reproducibly or with every difference explained.
- Sam can build an initramfs that finds a root by UUID, and a live variant with an overlay, both
  booting in QEMU.
- Sam can install a UEFI boot path into an ESP and boot it under OVMF, with and without a firmware
  boot entry.
- Sam's installer backend plans, confirms, applies and verifies an install onto an image file,
  refuses any other target, and its result boots.
- Every profile image passes an automated QEMU boot test that records boot time and idle memory.

## Parked for later

- Secure Boot, shim and key enrolment — `DEFERRED.md` (P6) and `sec-13-hardening-and-secure-boot`.
- The installer's user interface — `ui-06-installer-tui`.
- Disk encryption as an installer option beyond the concepts — `os-02-storage-and-boot-fundamentals`
  (concepts) and the NAS and desktop editions (`os-13-nas-edition`, `os-15-desktop-editions`).
- The NAS, router and desktop kernel fragments — one lesson each inside `os-13`, `os-14` and
  `os-15`.
