# Mission — os-15-desktop-editions

**Started**: not yet · **Family**: os · **Phase**: P6 · **Milestone**: not yet allocated

## Why

_Drafted from Sam's planning conversation of 27/09/2026 — confirm or rewrite in your own words at
the first lesson._

Sam wants beginner, intermediate and expert versions of Syntek OS for laptops and PCs, and he is
happy to use existing GUIs rather than write a desktop. The plan settled in that conversation pairs
KDE Plasma or GNOME with beginners, Xfce or COSMIC with intermediate users, and a tiling Wayland
compositor such as Sway or Hyprland with experts.
What Syntek OS adds is the integration — a from-scratch build of each desktop, a desktop kernel, and
the laptop details that decide whether a machine is pleasant to use — while its own tools come from
the TUI and GUI track. This comes after the server and homelab edition, so it stays an outline until
P6 reaches it.

## Can do it when

- Sam can trace a frame through the graphics stack under Wayland and under X11.
- Sam can explain how a login becomes a graphical session and what that needs from init.
- Each desktop profile's chosen desktop runs in a QEMU guest built from recipes, with its size and
  idle memory recorded.
- Sam's desktop kernel fragment merges strictly, builds and boots a desktop session in QEMU.
- Sam can explain the kernel's sleep states and has specified the laptop profile's power settings.
- Sam can list a laptop's firmware needs and the parts of the Wi-Fi stack.

## Parked for later

- Choosing desktop and laptop test hardware — an ADR when this topic opens (`GAPS.md`).
- Syntek OS's own GUI tools — `ui-08-gui-foundations` and `ui-09-gui-tools`.
- Secure Boot on laptops — `DEFERRED.md` and `sec-13-hardening-and-secure-boot`.
- Disk encryption for laptops beyond the concepts — `os-02-storage-and-boot-fundamentals` lesson 08.
