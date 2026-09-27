# Mission — ui-13-portal-screencast-and-pipewire

**Started**: not yet · **Family**: ui · **Phase**: U2 · **Milestone**: not yet allocated

## Why

_Drafted from Sam's conversation of 27/09/2026 — confirm or rewrite in your own words at the first lesson._

Sam's scope for the recorder's Wayland step covers the wlroots family — Hyprland, in ui-12 — and GNOME and KDE through
xdg-desktop-portal's ScreenCast interface and PipeWire. GNOME and KDE are the desktops most people run, and the
beginner profile chooses between them (os-15 lesson 03), so demos of those desktops need this backend. The portal is
also worth learning for its own sake: it is how a modern Linux desktop lets a program see the screen only with the
user's consent, and the recorder has to work with that consent — granted once in a set-up run, restored by token, and
never shown or clicked on camera — rather than around it. The backend lives in the capture library, which a second,
private tool also uses.

## Can do it when

- Sam can trace a portal call from method call to Response signal and name every object path involved.
- Sam can open a ScreenCast session in a guest and explain each call, the dialog and what the Response carries.
- Sam can read frames from the portal's PipeWire stream in shared memory and explain the DMA-BUF fallback.
- A set-up run grants the session once, later renders restore it without a dialog, and a stale token fails the render
  instead of recording one.
- Stage 1's tapes render in a GNOME guest and a KDE guest with the same timelines as their X11 renders, the capture
  library passes `cargo fmt --check`, `cargo clippy --all-targets -- -D warnings` and `cargo deny check`, and the
  budget is recorded.

## Parked for later

- Graphical desktop sharing for remote help, which rests on the same portals — `DEFERRED.md` (`DEFERRED (U3)`).
- Capture from inside remote-desktop sessions, GNOME Remote Desktop included — `DEFERRED.md`, after the X11, Wayland
  and QEMU/KVM stages.
- Capturing and driving a whole virtual machine from outside — kernel-11-qemu-display-and-input-control.
- Importing DMA-BUF frames on the GPU — not scheduled; the library maps shared memory on the CPU.
- Reading input back through an input-capture portal — never: captions come from the tape.
