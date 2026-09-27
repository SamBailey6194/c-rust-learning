# Syllabus — os-15-desktop-editions

**Track**: os · **Phase**: P6 · **Path**: Later · **Detail**: outline · **Prerequisites**: `os-10-profiles-and-installer`; `os-06-init-and-services` lesson 03 (what each profile needs from init, seats and sessions included); `kernel-04-kconfig-and-profile-configs` lessons 02, 04, 05 and 07 (the fragment method, longterm or stable per profile, firmware needs, measuring a config)
**Status**: Planned · **Checked**: 27/09/2026 (sources re-verified by `/teach` step 3 before each lesson)

The three desktop profiles — beginner, intermediate and expert, for PCs and laptops — reuse existing
desktops rather than building new ones
(`project-management/src/08-DECISIONS/ADR-MS001-SYNTEK-OS-DESKTOPS-REUSED-27-09-2026.md`); Syntek
OS's own GUI tools come from the UI track (`ui-08-gui-foundations`, `ui-09-gui-tools`). This topic
owns the graphics stack that `ui-08` cites, then packages one desktop per profile, writes the
desktop kernel fragment, and covers what laptops add: power management, suspend, firmware and Wi-Fi.
It is an **outline**: the desktops, BLFS's coverage and the kernel lines move quickly, so each lesson
names its objective, key ideas and the sources to re-verify, and its Build sketch is written when P6
reaches this topic. It is **Later**: the first edition is server and homelab. Every lesson runs in a
QEMU VM first; no desktop or laptop hardware has been chosen, and it is chosen by ADR when this topic
opens (`GAPS.md`).

| # | Lesson | Size | Build | Lenses |
| --- | --- | --- | --- | --- |
| 01 | The graphics stack: DRM and KMS, Mesa, Wayland and X11 | 2–3 sittings | yes — sketched at topic open | — |
| 02 | Seats, sessions and display managers | 1 sitting | yes — sketched at topic open | Security |
| 03 | The beginner desktop: KDE Plasma or GNOME | multi-session build | yes — sketched at topic open | Efficiency |
| 04 | The intermediate desktop: Xfce or COSMIC | multi-session build | yes — sketched at topic open | Efficiency |
| 05 | The expert desktop: a tiling Wayland compositor | 2–3 sittings | yes — sketched at topic open | Efficiency |
| 06 | The desktop kernel fragment | 1 sitting | yes — sketched at topic open | Efficiency, Security |
| 07 | Laptop power: suspend and power management | 2–3 sittings | yes — sketched at topic open | Efficiency, Safety |
| 08 | Firmware and Wi-Fi | 1 sitting | yes — sketched at topic open | Security, Safety |

---

## 01 — The graphics stack: DRM and KMS, Mesa, Wayland and X11

- **Objective:** Sam can trace a frame from an application to the screen under Wayland and under X11,
  naming the kernel and user-space part at each step.
- **Builds on:** `os-06-init-and-services`; `kernel-01-build-and-boot-in-qemu` (the kernel side).
- **Key ideas:**
  - DRM is the kernel's GPU subsystem and KMS the part that sets display modes; Mesa supplies the
    OpenGL and Vulkan drivers in user space.
  - Under Wayland the compositor is the display server; under X11 a separate server sits between
    clients and the compositor; Xwayland runs X11 clients on a Wayland compositor.
  - Input also flows through the compositor, from the kernel's evdev devices.
  - This lesson is the graphics-stack reference `ui-08-gui-foundations` cites.
- **Recall targets:** the path of a frame under each system; what KMS does that Mesa does not; what
  Xwayland is for.
- **Build:** sketched when this topic opens (Detail: outline).
- **Sources:** (to re-verify at topic open) docs.kernel.org, "Introduction" to the GPU driver
  developer's guide, <https://docs.kernel.org/gpu/introduction.html>, and "Kernel Mode Setting (KMS)",
  <https://docs.kernel.org/gpu/drm-kms.html>; Wayland, "Wayland Architecture",
  <https://wayland.freedesktop.org/architecture.html>; Mesa documentation, <https://docs.mesa3d.org/>;
  BLFS 13.1 Mesa-26.1.7, Wayland-1.26.0 and Xwayland,
  <https://www.linuxfromscratch.org/blfs/view/13.1-systemd/x/mesa.html>,
  <https://www.linuxfromscratch.org/blfs/view/13.1-systemd/general/wayland.html> and
  <https://www.linuxfromscratch.org/blfs/view/13.1-systemd/x/xwayland.html>.
- **Done when:** Sam draws both frame paths unaided and a QEMU guest shows a Wayland session.

## 02 — Seats, sessions and display managers

- **Objective:** Sam can explain how a user's login becomes a graphical session with access to the
  display and input devices, and what each profile needs from the init system for that.
- **Builds on:** `os-06-init-and-services` lesson 03 (what each profile needs from init; the
  INIT-SYSTEM-CHOICE research note, planned); lesson 01.
- **Key ideas:**
  - A seat is the set of display and input devices one user sits at; a seat manager grants a session
    access to them without running the compositor as root.
  - The learning build uses systemd's logind; seatd (in BLFS 13.1 as seatd-0.9.3) is a smaller
    alternative, which matters because Syntek OS's own init is chosen later by ADR.
  - Display managers (GDM, SDDM, LightDM — all in BLFS 13.1) start the session after login.
- **Recall targets:** what a seat manager grants and why; which piece depends on the init choice.
- **Build:** sketched when this topic opens (Detail: outline).
- **Security lens:** a compositor that needs root for devices is a large privileged surface.
- **Sources:** (to re-verify at topic open) BLFS 13.1 seatd-0.9.3, GDM and SDDM,
  <https://www.linuxfromscratch.org/blfs/view/13.1-systemd/general/seatd.html>,
  <https://www.linuxfromscratch.org/blfs/view/13.1-systemd/x/gdm.html> and
  <https://www.linuxfromscratch.org/blfs/view/13.1-systemd/x/sddm.html>.
- **Done when:** Sam explains a login-to-session path for the learning build and for a
  non-systemd alternative.

## 03 — The beginner desktop: KDE Plasma or GNOME

- **Objective:** Sam can build the beginner profile's desktop from BLFS and choose between Plasma and
  GNOME against the beginner profile spec.
- **Builds on:** lessons 01–02; `os-05-build-system-and-reproducibility` lesson 01 (from book steps
  to recipes).
- **Key ideas:**
  - BLFS 13.1 has full chapters for KDE Plasma and GNOME (GNOME Shell 50.4), so both start from book
    instructions turned into recipes.
  - The beginner spec decides: discoverability, accessibility, defaults that need no terminal.
  - A desktop is hundreds of packages; its size and idle memory are the profile's budget.
- **Recall targets:** what the beginner spec asks of a desktop; the cost of each candidate.
- **Build:** sketched when this topic opens (Detail: outline).
- **Efficiency lens:** installed size, idle memory and login time, measured in QEMU.
- **Sources:** (to re-verify at topic open) BLFS 13.1 "KDE Plasma" and "GNOME",
  <https://www.linuxfromscratch.org/blfs/view/13.1-systemd/kde/plasma.html> and
  <https://www.linuxfromscratch.org/blfs/view/13.1-systemd/gnome/gnome.html>;
  `project-management/src/07-OS-PROFILES/PROFILE-BEGINNER.md`.
- **Done when:** the chosen desktop runs in a QEMU guest built from recipes, with its budget
  recorded.

## 04 — The intermediate desktop: Xfce or COSMIC

- **Objective:** Sam can build the intermediate profile's desktop and choose between Xfce, which
  BLFS covers, and COSMIC, which Syntek OS would package itself.
- **Builds on:** lesson 03.
- **Key ideas:**
  - BLFS 13.1 has an Xfce part (xfce4-panel 4.20.8); it has no COSMIC page.
  - COSMIC is released as numbered Epoch 1 versions — 1.9.0 on 23/09/2026 — and builds with rustc
    and cargo, so a recipe needs offline, reproducible Cargo builds (`os-05` lessons 03–04).
  - The intermediate spec decides between the familiar and the new.
- **Recall targets:** what a recipe needs that BLFS does not provide for COSMIC; the spec's deciding
  criteria.
- **Build:** sketched when this topic opens (Detail: outline).
- **Efficiency lens:** installed size and idle memory against lesson 03's.
- **Sources:** (to re-verify at topic open) BLFS 13.1 "Xfce",
  <https://www.linuxfromscratch.org/blfs/view/13.1-systemd/xfce/xfce.html>; COSMIC Epoch 1.9.0,
  <https://github.com/pop-os/cosmic-epoch/releases/tag/epoch-1.9.0>;
  `project-management/src/07-OS-PROFILES/PROFILE-INTERMEDIATE.md`.
- **Done when:** the chosen desktop runs in QEMU from recipes and the choice is recorded.

## 05 — The expert desktop: a tiling Wayland compositor

- **Objective:** Sam can package a tiling Wayland compositor for the expert profile and explain
  what it depends on.
- **Builds on:** lessons 01–02.
- **Key ideas:**
  - Sway is built on the wlroots library; BLFS 13.1 has wlroots-0.20.2 (for Wayfire), but no Sway page.
  - Hyprland describes itself as independent of wlroots; it has no BLFS page either.
  - Either needs a recipe Syntek OS writes itself; the expert spec decides which.
- **Recall targets:** what wlroots provides; what a from-scratch recipe must pin.
- **Build:** sketched when this topic opens (Detail: outline).
- **Efficiency lens:** idle memory against the full desktops of lessons 03–04.
- **Sources:** (to re-verify at topic open) Sway, <https://github.com/swaywm/sway>; Hyprland,
  <https://github.com/hyprwm/Hyprland>; BLFS 13.1 wlroots-0.20.2,
  <https://www.linuxfromscratch.org/blfs/view/13.1-systemd/x/wlroots.html>;
  `project-management/src/07-OS-PROFILES/PROFILE-EXPERT.md`.
- **Done when:** the chosen compositor runs in QEMU from a recipe.

## 06 — The desktop kernel fragment

- **Objective:** Sam can write the desktop kernel fragment with `kernel-04`'s method and justify its
  broader hardware support against the server family's minimal ones.
- **Builds on:** `kernel-04-kconfig-and-profile-configs` lessons 02, 04 and 07; lessons 01 and 07–08.
- **Key ideas:**
  - Desktops and laptops follow the stable line, not longterm
    (`project-management/src/08-DECISIONS/ADR-MS001-KERNEL-DOWNSTREAM-OF-UPSTREAM-27-09-2026.md`).
  - The fragment adds GPU (DRM) drivers, input, sound, Wi-Fi and Bluetooth for unknown hardware, so
    it is the largest fragment — measure what that costs.
  - It is merged strictly over the base with `kernel-04` lesson 02's script, on the compiler recorded
    in `kernel-04` lesson 03, so a symbol that does not stick fails the merge instead of vanishing.
- **Recall targets:** why desktops track stable; what the desktop fragment adds that the server's
  omits.
- **Build:** sketched when this topic opens (Detail: outline).
- **Efficiency lens:** image size and module count with `kernel-04` lesson 07's script.
- **Security lens:** broad hardware support is broad attack surface.
- **Sources:** (to re-verify at topic open) docs.kernel.org, "Kconfig Language",
  <https://docs.kernel.org/kbuild/kconfig-language.html>; kernel.org, "Active kernel releases",
  <https://www.kernel.org/category/releases.html>.
- **Done when:** the fragment merges strictly, builds, and boots a desktop session in QEMU.

## 07 — Laptop power: suspend and power management

- **Objective:** Sam can explain the kernel's sleep states and what a laptop profile configures for
  suspend and power saving.
- **Builds on:** lesson 06.
- **Key ideas:**
  - The kernel offers suspend-to-idle, standby, suspend-to-RAM and hibernation; `/sys/power/state`
    and `/sys/power/mem_sleep` choose between them, and "deep" is the suspend-to-RAM variant.
  - Battery and other power-device state reaches the desktop through user-space services such as
    UPower (in BLFS 13.1), which enumerates power devices and reports their events.
  - Real suspend and battery behaviour needs real hardware; the VM covers configuration only.
- **Recall targets:** the sleep states in order of depth; which file selects the `mem` variant.
- **Build:** sketched when this topic opens (Detail: outline).
- **Efficiency lens:** power draw and resume time, measured once laptop hardware is chosen.
- **Safety:** real-hardware tests only on dedicated, wiped test hardware named in the milestone.
- **Sources:** (to re-verify at topic open) docs.kernel.org, "System Sleep States",
  <https://docs.kernel.org/admin-guide/pm/sleep-states.html>; BLFS 13.1 UPower,
  <https://www.linuxfromscratch.org/blfs/view/13.1-systemd/general/upower.html>.
- **Done when:** Sam explains each state and the laptop profile's power settings are specified.

## 08 — Firmware and Wi-Fi

- **Objective:** Sam can say which firmware files a laptop needs, where the kernel loads them from,
  and what a Wi-Fi connection needs from the kernel and user space.
- **Builds on:** `kernel-04-kconfig-and-profile-configs` lesson 05 (firmware needs per profile);
  lesson 06.
- **Key ideas:**
  - Many devices need firmware files from the linux-firmware repository at runtime; in LFS they
    live under `/usr/lib/firmware`.
  - Firmware is binary code from vendors that runs on the device — part of the trusted base, updated
    like any package.
  - Wi-Fi needs kernel wireless support (cfg80211 and a driver) plus a user-space supplicant for
    WPA; BLFS 13.1 covers the kernel configuration, `iw` 6.17 and wpa_supplicant 2.12 (iwd has no
    BLFS page).
- **Recall targets:** why firmware is loaded at runtime; which part of Wi-Fi lives where.
- **Build:** sketched when this topic opens (Detail: outline).
- **Security lens:** firmware provenance and updates.
- **Safety:** Wi-Fi tests only on dedicated test hardware and an isolated test network.
- **Sources:** (to re-verify at topic open) BLFS 13.1 "About Firmware",
  <https://www.linuxfromscratch.org/blfs/view/13.1-systemd/postlfs/firmware.html>; BLFS 13.1
  "Configuring the Linux Kernel for Wireless" and iw,
  <https://www.linuxfromscratch.org/blfs/view/13.1-systemd/basicnet/wireless-kernel.html> and
  <https://www.linuxfromscratch.org/blfs/view/13.1-systemd/basicnet/iw.html>; BLFS 13.1 wpa_supplicant 2.12,
  <https://www.linuxfromscratch.org/blfs/view/13.1-systemd/basicnet/wpa_supplicant.html>; docs.kernel.org,
  firmware guide, <https://docs.kernel.org/driver-api/firmware/index.html>.
- **Done when:** Sam lists a sample laptop's firmware needs and the Wi-Fi stack's parts.
