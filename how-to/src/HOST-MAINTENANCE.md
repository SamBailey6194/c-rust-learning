# Host Maintenance — Pointer

**Last Updated**: 27/09/2026 | **Version**: 0.1.0 | **Maintained By**: Sam Bailey
**Language**: British English (en_GB) | **Timezone**: Europe/London

This repository relies on a maintained Ubuntu host; the sibling repository **reboot-purge** implements
that maintenance. This file points there and stays a pointer: it never grows into a runbook.

## Where host maintenance lives

`https://github.com/SamBailey6194/reboot-purge` — interactive, menu-driven Bash for an apt-based Ubuntu
host, run after booting. Every task shows what will change and waits for approval. It offers:

- **a health report** covering pending reboots, kernel and NVIDIA mismatches, broken or held packages,
  autoremovable packages, pending upgrades, failed units and disk use;
- **autoremove, old-kernel removal, an apt cache clean and a broken-package repair**, each previewed
  with apt's simulation first. Kernel removal never touches the running kernel or the last bootable
  image.

Its README is the authority on what it does; this list is only a signpost. An interactive
`apt update` → `apt list --upgradable` → `apt upgrade` script is on its roadmap but not built yet, so
`how-to/workflows/04-toolchain-updates/` Step 4 still gives the host upgrade to run by hand.

## What stays here

- **Recording what an upgrade changed** in the toolchain → `how-to/workflows/04-toolchain-updates/`, which
  re-records `how-to/docs/TOOLCHAIN.md`.
- **Installing this repository's toolchain** → `how-to/src/MACHINE-SETUP.md`.
- **Kernels built here** run in QEMU only and are never installed on the host (`.claude/CLAUDE.md`), so they
  never appear in reboot-purge's kernel list.
