# Mission — kernel-10-drm-kms-capture

**Started**: not yet · **Family**: kernel · **Phase**: P5 · **Milestone**: not yet allocated

## Why

_Drafted from Sam's conversation of 27/09/2026 — confirm or rewrite in your own words at the first lesson._

Sam chose to stage his scripted demo recorder so that, after the display-server backends, it reaches the kernel's own
interfaces in a QEMU guest at P4–P5: uinput for input (kernel-09) and DRM/KMS for the screen. He then decided that DRM
capture is **learning-only**: lesson code in the guest, never a capture-library backend, so it never ships in any tool
built on that library. The value is understanding — what a display is at the kernel's boundary, and why reading one
back needs the privileges it does — which also explains why the recorder captures a guest from outside, through QEMU.

## Can do it when

- Name a guest display's KMS objects from his own lister and draw the chain from framebuffer to connector.
- Put a known test pattern on screen through a dumb buffer, with pitch handled and every object released.
- Read the displayed framebuffer back from a second process with `GETFB2`, matching byte for byte, with no GEM handle
  leaked over a thousand grabs.
- Check his frames against kmsgrab and account for any difference.
- Argue, from a frame captured both ways, why the capture library reads a guest's display through QEMU and never
  through DRM.

## Parked for later

- A DRM/KMS backend in the capture library → never (the staging ADR); the library's QEMU backend is
  kernel-11-qemu-display-and-input-control.
- GPU-rendered buffers — tiling, format modifiers, importing into a GPU → not scheduled.
- VKMS writeback as a capture target → only if the MAP-KERNEL spike finds it in the pinned guest kernel.
- The graphics stack as a whole (Mesa, compositors) → os-15-desktop-editions lesson 01.
