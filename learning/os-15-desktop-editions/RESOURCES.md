# Resources — os-15-desktop-editions

Outline topic: every source below is re-verified when P6 reaches this topic.

| Lesson | Primary source (pinned) | House guide | Code |
| --- | --- | --- | --- |
| 01 The graphics stack: DRM and KMS, Mesa, Wayland and X11 | docs.kernel.org "Kernel Mode Setting (KMS)", <https://docs.kernel.org/gpu/drm-kms.html>; Wayland Architecture, <https://wayland.freedesktop.org/architecture.html>; BLFS 13.1 Mesa-26.1.7, <https://www.linuxfromscratch.org/blfs/view/13.1-systemd/x/mesa.html> | — | — (sketched at topic open) |
| 02 Seats, sessions and display managers | BLFS 13.1 seatd-0.9.3, <https://www.linuxfromscratch.org/blfs/view/13.1-systemd/general/seatd.html> | — | — (sketched at topic open) |
| 03 The beginner desktop: KDE Plasma or GNOME | BLFS 13.1 "KDE Plasma", <https://www.linuxfromscratch.org/blfs/view/13.1-systemd/kde/plasma.html>; "GNOME", <https://www.linuxfromscratch.org/blfs/view/13.1-systemd/gnome/gnome.html> | `project-management/src/07-OS-PROFILES/PROFILE-BEGINNER.md` | — (sketched at topic open) |
| 04 The intermediate desktop: Xfce or COSMIC | BLFS 13.1 "Xfce", <https://www.linuxfromscratch.org/blfs/view/13.1-systemd/xfce/xfce.html>; COSMIC Epoch 1.9.0, <https://github.com/pop-os/cosmic-epoch/releases/tag/epoch-1.9.0> | `project-management/src/07-OS-PROFILES/PROFILE-INTERMEDIATE.md` | — (sketched at topic open) |
| 05 The expert desktop: a tiling Wayland compositor | Sway, <https://github.com/swaywm/sway>; Hyprland, <https://github.com/hyprwm/Hyprland>; BLFS 13.1 wlroots-0.20.2, <https://www.linuxfromscratch.org/blfs/view/13.1-systemd/x/wlroots.html> | `project-management/src/07-OS-PROFILES/PROFILE-EXPERT.md` | — (sketched at topic open) |
| 06 The desktop kernel fragment | docs.kernel.org "Kconfig Language", <https://docs.kernel.org/kbuild/kconfig-language.html>; kernel.org releases, <https://www.kernel.org/category/releases.html> | — | `code/src/kernel/msNNN-profile-fragments/` (planned — added at P4) |
| 07 Laptop power: suspend and power management | docs.kernel.org "System Sleep States", <https://docs.kernel.org/admin-guide/pm/sleep-states.html> | — | — (sketched at topic open) |
| 08 Firmware and Wi-Fi | BLFS 13.1 "About Firmware", <https://www.linuxfromscratch.org/blfs/view/13.1-systemd/postlfs/firmware.html>; "Configuring the Linux Kernel for Wireless", <https://www.linuxfromscratch.org/blfs/view/13.1-systemd/basicnet/wireless-kernel.html>; wpa_supplicant 2.12, <https://www.linuxfromscratch.org/blfs/view/13.1-systemd/basicnet/wpa_supplicant.html> | — | — (sketched at topic open) |
