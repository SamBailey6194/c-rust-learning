# Mission — ui-12-headless-wayland-capture-and-input

**Started**: not yet · **Family**: ui · **Phase**: U2 · **Milestone**: not yet allocated

## Why

_Drafted from Sam's conversation of 27/09/2026 — confirm or rewrite in your own words at the first lesson._

Sam wants reproducible demo and tutorial videos of his own work — learning progress, and Syntek OS promoted on social
media — scripted like terminal tapes but able to drive GUI applications too, with the voice-over and the floating head
recorded separately against the timeline the recorder exports. He fixed the backend order: X11 first, then Wayland,
then QEMU/KVM. Stage 1 renders tapes on X11 and stage 2 ports the recorder to Rust around a capture library that a
second, private tool also uses. This topic is the first Wayland backend: headless Hyprland in a QEMU guest, captured
through the generic Wayland capture protocols and driven through virtual input, so that the same tapes render on the
kind of tiling compositor the expert profile is choosing between (os-15 lesson 05). It also teaches the other side of
the same interfaces — screen capture and input injection are exactly what an attacker wants from a compositor, so the
recorder is written to need as little of them as possible.

## Can do it when

- Sam can explain, from Aquamarine's source, why headless Hyprland still needs a DRM device, and start it in a QEMU
  guest with a headless output of a chosen size.
- Sam can grab a frame through ext-image-copy-capture-v1 and explain what its damage tells the recorder.
- Sam can type a key into the guest through a virtual keyboard under a keymap he compiled and uploaded, and predict
  what happens without one.
- Stage 1's tapes render in the guest with the same timelines as their X11 renders, both repositories pass
  `cargo fmt --check`, `cargo clippy --all-targets -- -D warnings` and `cargo deny check`, and the budget is recorded.
- The fixture's threat model is written, and no permission prompt can reach a video: a render with a rule removed
  fails instead of recording it.

## Parked for later

- GNOME and KDE through the ScreenCast portal and PipeWire — ui-13-portal-screencast-and-pipewire.
- Capturing and driving a whole virtual machine from outside — kernel-11-qemu-display-and-input-control.
- DRM/KMS capture from user space (learning-only, never a capture-library backend) — kernel-10-drm-kms-capture.
- Re-running the stage on the Syntek OS expert image — os-15-desktop-editions lesson 05, once the image exists.
- TTY-console and remote-desktop capture backends — `DEFERRED.md`, after the X11, Wayland and QEMU/KVM stages.
- Reading input back through an input-capture protocol — never: captions come from the tape.
