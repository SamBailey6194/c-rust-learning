# Mission — kernel-11-qemu-display-and-input-control

**Started**: not yet · **Family**: kernel · **Phase**: P4 · **Milestone**: not yet allocated

## Why

_Drafted from Sam's conversation of 27/09/2026 — confirm or rewrite in your own words at the first lesson._

Sam wants his scripted demo recorder, and the capture library it shares, to cover X11, Wayland and QEMU/KVM — in that
order, which he made binding. QEMU/KVM matters because the videos that promote Syntek OS show images that boot in
QEMU: installers, profiles and text consoles. The skills are ones kernel-01 already starts — the monitor behind the
multiplexer, a control channel bound to a private socket — so this topic sits at P4, but its milestones wait for the
Wayland stages to finish. It also answers why KVM changes nothing for capture: the display is emulated in QEMU either
way.

## Can do it when

- Negotiate QMP on a Unix socket, run a command and read an event, and explain what KVM runs and what QEMU still
  emulates.
- Grab a guest's screen with `screendump` and state its cost, PPM against PNG, at two resolutions and both
  accelerators.
- Stream a guest's screen over RFB on a Unix socket, applying damage, with frames matching `screendump` on a static
  screen.
- Type into a guest and point in it with `send-key` and `input-send-event`, with the layout pinned.
- Trace libvirt's screenshot and send-key to QMP, and say what access to its socket grants.
- Record a stage-1 tape against a TCG guest and a KVM guest to identical timelines, with no TCP listener and the
  Budget recorded.

## Parked for later

- SPICE, the other remote-display protocol in the capture library's scope → a later part of this stage, after RFB,
  decided when the RFB part is `Done`.
- QEMU's D-Bus display as the main stream → weighed in the stage 4 spec.
- libvirt through a binding crate → only after a licence-policy change to `code/src/rust/deny.toml`.
- GL displays (`virtio-gpu-gl`, `egl-headless`) and device passthrough → researched before any use.
- TTY-console and remote-desktop capture backends → `DEFERRED.md`, only after the X11, Wayland and QEMU/KVM stages
  are all `Done`.
- Reading a guest's scanout through DRM from inside it → kernel-10-drm-kms-capture (learning-only).
