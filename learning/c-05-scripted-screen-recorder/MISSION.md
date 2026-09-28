# Mission — c-05-scripted-screen-recorder

**Started**: not yet · **Family**: c · **Phase**: P2 · **Milestone**: not yet allocated

## Why

_Drafted from Sam's conversation of 27/09/2026 — confirm or rewrite in your own words at the first
lesson._

Sam wants reproducible demo and tutorial videos for social media — his learning progress, and
promotion of Syntek OS — made from his own content only. He wants them scripted the way vhs scripts a
terminal, but for GUI applications too (a browser, an editor, the Syntek OS tools), keyboard first
and the mouse rarely. Voice-over and a floating head are recorded separately afterwards, so what a
render must produce is a silent video plus a timeline to record against, and tapes are cut into
short sections so that re-recording one stays small. He asked for the recorder as an added learning
project, built in C and Rust on Linux. This topic is its first stage: C on X11 at P2, where the
processes, pipes and signals P2 teaches drive a real tool from the first lesson.

## Can do it when

- Sam can explain how Xvfb's `-displayfd` tells the parent which display it took, and why that beats
  a fixed sleep.
- Sam can predict which character one keycode types under the gb and us layouts, and say why the
  recorder pins the layout.
- Sam can say why XTest input and frame capture use separate X connections.
- Sam can predict what the recorder does when the ffmpeg pipe is full, and when ffmpeg dies.
- Sam can explain why captions and the timeline come from the tape, never from observed input.
- vhs's example tapes parse, and malformed tapes fail with the right line and column.
- A two-section tape renders at 1080x1920 and 1920x1080 with a `.vtt` file and ffmetadata chapters
  that match the tape.
- The exercise's `make test`, `make san` and `make memcheck` all exit 0, and the stage's Budget
  (render time, peak resident memory, frames per second) is measured.

## Parked for later

- The Rust port, its capture and input traits, and the scripted-recorder and capture-library
  repositories — stage 2, at P3 (P3's rust topics).
- Wayland on headless Hyprland — `ui-12-headless-wayland-capture-and-input`; GNOME and KDE through the
  portal and PipeWire — `ui-13-portal-screencast-and-pipewire`.
- QEMU/KVM display and input control — `kernel-11-qemu-display-and-input-control`.
- uinput and evdev input — `kernel-09-virtual-input-devices`; DRM/KMS capture, learning-only —
  `kernel-10-drm-kms-capture`.
- Fixed user and host names in a video through namespaces — `sec-04` lesson 07's sandbox launcher.
- AltGr (third- and fourth-level) characters through the XKB library — a stretch the stage's project
  spec may include.
- TTY-console and remote-desktop capture — `DEFERRED.md`, until the X11, Wayland and QEMU/KVM stages
  are done.
