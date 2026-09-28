# Mission — kernel-09-virtual-input-devices

**Started**: not yet · **Family**: kernel · **Phase**: P4 · **Milestone**: not yet allocated

## Why

_Drafted from Sam's conversation of 27/09/2026 — confirm or rewrite in your own words at the first lesson._

Sam wants reproducible demo and tutorial videos of his own work — his learning progress and Syntek OS — rendered from
scripted tapes, keyboard first. He chose to build the recorder as a learning project in C and Rust that reaches down to
the Linux kernel: display-server backends first, then a kernel-interface stage in QEMU at P4–P5. This topic is the
input half of that stage. Typing through uinput shows what XTest, Wayland's virtual keyboard and QEMU's `send-key` all
stand on — the kernel's input subsystem — and it does so in a disposable guest, because the same program on the host
would type into his own session.

## Can do it when

- Trace a key press from driver to evdev node, and explain an event's type, code and value and what `SYN_REPORT`
  closes.
- Explain why a key code names a position, not a character, and where the layout is applied.
- Create, use and destroy a uinput keyboard in a QEMU guest, with its events read back exactly.
- Boot a guest with uinput and evdev from kernel-01's harness, with a self-test that fails the boot's exit status
  when a key is dropped.
- Show a recorder tape typing into the guest through the uinput backend, with the capture library unchanged and the
  Budget recorded.

## Parked for later

- DRM/KMS capture from user space, the other half of the kernel-interface stage → kernel-10-drm-kms-capture
  (learning-only).
- Typing into a guest from outside, through QEMU → kernel-11-qemu-display-and-input-control.
- A virtual pointer (`EV_ABS` through `UI_ABS_SETUP`) → appended to this syllabus only if a tape needs `Click` or
  `MoveTo`; tapes are keyboard first.
- An input driver of his own inside the kernel → not scheduled.
- Reading any real keyboard's events → never: the recorder's captions come from the tape, not from input devices.
