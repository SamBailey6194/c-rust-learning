# Host Maintenance — Pointer

**Last Updated**: 27/09/2026 | **Version**: 0.1.0 | **Maintained By**: Sam Bailey
**Language**: British English (en_GB) | **Timezone**: Europe/London

This repository relies on a maintained Ubuntu host; the sibling repository **reboot-purge** implements
that maintenance. This file points there and stays a pointer: it never grows into a runbook.

## Where host maintenance lives

`https://github.com/SamBailey6194/reboot-purge` (not yet published) — interactive, menu-driven Bash
scripts for an apt-based Ubuntu host, run after booting, each task showing what will change and waiting
for approval. The repository is not public yet (`GAPS.md` → _Sibling repository reboot-purge not yet
published_), so nothing here describes its features; its README will, once it is published. Until then,
`how-to/workflows/04-toolchain-updates/` Step 4 gives the host upgrade to run by hand.

## What stays here

- **Recording what an upgrade changed** in the toolchain → `how-to/workflows/04-toolchain-updates/`, which
  re-records `how-to/docs/TOOLCHAIN.md`.
- **Installing this repository's toolchain** → `how-to/src/MACHINE-SETUP.md`.
- **Kernels built here** run in QEMU only and are never installed on the host (`.claude/CLAUDE.md`), so they
  never appear in reboot-purge's kernel list.
