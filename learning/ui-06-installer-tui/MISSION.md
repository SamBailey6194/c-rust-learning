# Mission — ui-06-installer-tui

**Started**: not yet · **Family**: ui · **Phase**: U2 · **Milestone**: not yet allocated

## Why

_Drafted from Sam's planning conversation of 27/09/2026 — confirm or rewrite in your own words at the first lesson._

A guided TUI installer that selects the profile is one of the custom Syntek OS tools Sam settled on, alongside the
package-manager front-end and the file manager. The installer is where one wrong keypress can destroy someone's data,
so this topic is about making the dangerous step hard to get wrong: a flow that is an explicit state machine, a disk
choice that only offers what is safe, a profile choice drawn from the profile specifications, validation before
anything reaches the backend, and a way back after failure — all tested unattended in QEMU. It is Later work: the
first edition can be installed with os-10's backend CLI, and this TUI makes Syntek OS installable by the friends and
family it is meant for.

## Can do it when

- Sam can model the installer's flow as a state machine with every transition tested.
- Sam can build a disk-selection screen that identifies disks by stable facts and never offers the running root or a
  host disk.
- Sam can present the seven profiles from their specifications.
- Sam can validate host names, user names and passwords with helpful messages, never logging a password.
- An unattended QEMU run installs each first-edition profile into a fresh disk image, and each image boots.

## Parked for later

- The installer backend itself (plan, confirm, apply, verify) — os-10-profiles-and-installer.
- Disk encryption choices in the installer (LUKS2) — os-02-storage-and-boot-fundamentals first, then a later lesson.
- A graphical installer for the desktop profiles — ui-09-gui-tools, if one is needed.
