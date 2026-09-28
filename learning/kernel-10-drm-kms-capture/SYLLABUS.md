# Syllabus — kernel-10-drm-kms-capture

**Track**: kernel · **Phase**: P5 · **Path**: Later · **Detail**: outline · **Prerequisites**: kernel-09-virtual-input-devices (all lessons — the recorder's stage 5a); kernel-03-syscalls-memory-and-concurrency lesson 03 (mapping memory); a capture target in the guest, the open spike on `project-management/src/01-ROADMAP/MAP-KERNEL.md` → Frontier (lesson 03)
**Status**: Planned · **Checked**: 27/09/2026 (sources re-verified by `/teach` step 3 before each lesson)

**Learning-only: the code in this topic runs in a QEMU guest and is never a capture-library backend**
(`project-management/src/08-DECISIONS/ADR-MS001-SCRIPTED-RECORDER-STAGED-LEARNING-PROJECT-27-09-2026.md`). It is stage
5b of the scripted demo recorder, and it ships nothing: the recorder captures a guest's display from outside, through
QEMU (`kernel-11-qemu-display-and-input-control`), and neither the recorder nor the capture library ever reads a
scanout through DRM. What the topic teaches is what a display is at the kernel's boundary — connectors, CRTCs, planes
and framebuffers — and what reading one back costs in privilege, since `DRM_IOCTL_MODE_GETFB2` hands out buffer handles
only to the DRM master or to a process with `CAP_SYS_ADMIN`. It is **Later** and **outline** detail at P5, a leaf that
no Core topic lists. Every lesson runs in a QEMU guest: on a desktop host the active session's user can open
`/dev/dri/*` without `sudo` (a logind access-control list, seen with `getfacl` on 27/09/2026), so "never point DRM code
at the host's `/dev/dri`" is a rule the lessons keep, not one permissions enforce. Guest programs are small,
statically linked C under `code/src/kernel/` (planned — added at P4), calling the raw `ioctl`s from the kernel's UAPI
headers (`drm/drm.h`, `drm/drm_mode.h`): libdrm's development files are not installed.

Open question, settled before lesson 03 (the MAP-KERNEL spike): what the guest can show before P6 — lesson 02's own
test pattern is a known target, but whether the framebuffer console on virtio-gpu gives `GETFB2` a mappable
framebuffer, whether a dumb-buffer map or a PRIME export with a dma-buf `mmap` is the right read path, and whether VKMS
is available in the pinned guest kernel are all unverified.

| # | Lesson | Size | Build | Lenses |
| --- | --- | --- | --- | --- |
| 01 | DRM and KMS objects from user space | 1 sitting | yes — KMS object lister | Safety |
| 02 | Dumb buffers: allocate, map, draw, show | 2–3 sittings | yes — test-pattern scanout | Safety |
| 03 | Reading back the scanout: `GETFB2`, GEM handles and who may ask | 2–3 sittings | yes — scanout reader | Security, Safety |
| 04 | Checking against kmsgrab | 1 sitting | yes — frame comparison | Efficiency, Safety |
| 05 | Why the capture library reads a guest's display from QEMU instead | 1 sitting | no | Security |

---

## 01 — DRM and KMS objects from user space

- **Objective:** Sam can list a guest display's KMS objects from user space and say what each one is: connector,
  encoder, CRTC, plane and framebuffer.
- **Builds on:** kernel-09 lessons 01–03 (device nodes, `ioctl` queries, the input guest); os-15-desktop-editions
  lesson 01 as reading (the graphics stack, where DRM and KMS sit).
- **Key ideas:**
  - DRM is the kernel's GPU subsystem and KMS its display half; a card's primary node (`/dev/dri/cardN`) can set
    modes, while a render node (`/dev/dri/renderDN`) cannot.
  - `DRM_IOCTL_MODE_GETRESOURCES` lists connectors, encoders, CRTCs and framebuffers; planes need their own query,
    after the client asks for universal planes with `DRM_IOCTL_SET_CLIENT_CAP`.
  - A CRTC scans a framebuffer out through a plane to a connector; the framebuffer ID it shows is the thing a capture
    would read.
  - QEMU's standard VGA is driven by the bochs DRM driver and virtio-gpu by its own; the guest fragment enables one,
    and the `KERNEL-PLAN` records which.
- **Recall targets:** what each KMS object is for; why a render node cannot be used here; where a CRTC's current
  framebuffer ID is found.
- **Build:** a small, statically linked KMS object lister in `code/src/kernel/msNNN-drm-capture/` (planned — added at
  P4), packed into the guest's initramfs. Checked by its output on the guest's serial console matching QEMU's display
  configuration.
- **Safety:** QEMU guest only, never the host's `/dev/dri`; learning-only — never a capture-library backend.
- **Sources:** (to verify when the topic opens) "Userland interfaces" (<https://docs.kernel.org/gpu/drm-uapi.html>,
  primary and render nodes, DRM master); "Kernel Mode Setting (KMS)" (<https://docs.kernel.org/gpu/drm-kms.html>,
  the KMS object overview); include/uapi/drm/drm.h and drm_mode.h at v7.2
  (<https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/plain/include/uapi/drm/drm_mode.h?h=v7.2>);
  QEMU "virtio-gpu" (<https://www.qemu.org/docs/master/system/devices/virtio-gpu.html>).
- **Done when:** the lister's output names every object in the guest and Sam draws the chain from framebuffer to
  connector for that guest unaided.

## 02 — Dumb buffers: allocate, map, draw, show

- **Objective:** Sam can allocate a dumb buffer, map it, draw a known test pattern into it and put it on screen, then
  release everything he created.
- **Builds on:** lesson 01; kernel-03 lesson 03 (`mmap` and pages).
- **Key ideas:**
  - A dumb buffer is the kernel's simplest scanout buffer, for software rendering only: `DRM_IOCTL_MODE_CREATE_DUMB`
    returns a handle, a pitch and a size; `DRM_IOCTL_MODE_ADDFB` (or `ADDFB2`) wraps it as a framebuffer;
    `DRM_IOCTL_MODE_MAP_DUMB` gives the offset to `mmap`.
  - The pitch is the length of a row in bytes, which can exceed width times bytes per pixel; drawing by width alone
    shears the image.
  - Setting a mode needs DRM master; with no compositor in the guest, the lesson's program can hold it — the rules for
    acquiring it are read at the pinned version.
  - A framebuffer is removed when the file that created it closes, so the program keeps running while its pattern is
    on screen.
- **Recall targets:** handle, framebuffer ID and mapping offset — what each names; why pitch matters; what a dumb
  buffer is not suitable for.
- **Build:** a test-pattern program that shows a known image and holds it, in `code/src/kernel/msNNN-drm-capture/`
  (planned — added at P4). Checked by QEMU's `screendump` of the guest matching the pattern Sam drew.
- **Safety:** QEMU guest only, never the host's `/dev/dri`; learning-only — never a capture-library backend.
- **Sources:** (to verify when the topic opens) "Kernel Mode Setting (KMS)" (<https://docs.kernel.org/gpu/drm-kms.html>,
  "Dumb Buffer Objects"); include/uapi/drm/drm.h at v7.2 (`DRM_IOCTL_MODE_CREATE_DUMB` and its comment); QEMU
  "QEMU Monitor" (<https://www.qemu.org/docs/master/system/monitor.html>, `screendump`); `man 2 mmap`.
- **Done when:** the pattern appears in a `screendump` pixel for pixel, and the program releases every object it
  created.

## 03 — Reading back the scanout: `GETFB2`, GEM handles and who may ask

- **Objective:** Sam can read the framebuffer a CRTC is showing from a second process, map its pixels, and prove that
  no GEM handle leaks.
- **Builds on:** lessons 01–02; the capture-target spike on MAP-KERNEL, settled first.
- **Key ideas:**
  - `DRM_IOCTL_MODE_GETFB2` returns a framebuffer's format, pitches and modifier; it fills in GEM buffer handles only
    for the DRM master or a caller with `CAP_SYS_ADMIN`, and zeroes them for anyone else.
  - Every call returns **fresh** handles, even for a buffer already open, and the caller must close each unique one
    with `DRM_IOCTL_GEM_CLOSE` — a capture loop that forgets leaks a handle per frame.
  - A handle becomes pixels by a dumb-buffer map, or by `DRM_IOCTL_PRIME_HANDLE_TO_FD` and an `mmap` of the dma-buf
    bracketed by `DMA_BUF_IOCTL_SYNC`; only a linear buffer reads correctly on the CPU.
  - The framebuffer ID changes when the display page-flips, so it is looked up again for every frame.
- **Recall targets:** who may receive handles and why; what leaks without `GEM_CLOSE`; why a tiled buffer reads as
  noise.
- **Build:** a scanout reader that grabs lesson 02's pattern into a file, in `code/src/kernel/msNNN-drm-capture/`
  (planned — added at P4). Checked by a byte-for-byte match with the pattern, and by a thousand grabs showing no
  handle leak — the measure (for example the DRM usage stats in the reader's `fdinfo`) chosen when the topic opens
  and recorded in the `KERNEL-PLAN`.
- **Security lens:** reading another client's screen is a privileged act — the whole display, including anything
  secret on it. That privilege, not convenience, is why this code stays in a throwaway guest.
- **Safety:** QEMU guest only, never the host's `/dev/dri`; root in the guest only, and Claude never runs `sudo`;
  learning-only — never a capture-library backend.
- **Sources:** (to verify when the topic opens) include/uapi/drm/drm.h at v7.2 (`DRM_IOCTL_MODE_GETFB2`,
  `DRM_IOCTL_GEM_CLOSE` and `DRM_IOCTL_PRIME_HANDLE_TO_FD` comments); "Buffer Sharing and Synchronization (dma-buf)"
  (<https://docs.kernel.org/driver-api/dma-buf.html>, CPU access); "Kernel Mode Setting (KMS)"
  (<https://docs.kernel.org/gpu/drm-kms.html>, framebuffers and format modifiers); "DRM client usage stats"
  (<https://docs.kernel.org/gpu/drm-usage-stats.html>).
- **Done when:** the grab matches, no handle leaks, and Sam explains the privilege check from the header's own
  comment.

## 04 — Checking against kmsgrab

- **Objective:** Sam can check his reader's frames against ffmpeg's kmsgrab device on the same guest display and
  explain any difference.
- **Builds on:** lesson 03.
- **Key ideas:**
  - kmsgrab captures the scanout framebuffer of a CRTC or plane as a DRM frame and needs DRM master or
    `CAP_SYS_ADMIN`, the same privilege as lesson 03.
  - Downloading its frames to ordinary memory works only when the framebuffer is linear and mappable — the same limit
    Sam's reader meets.
  - kmsgrab samples at a fixed rate, not in step with page flips, so a fast sample repeats a frame.
  - Frames leave the guest over `AF_VSOCK` or are encoded inside it; kmsgrab needs ffmpeg in the guest, so this
    lesson needs a stock-distribution guest image, fetched outside git.
- **Recall targets:** what kmsgrab requires and what it cannot download; why two tools reading the same buffer can
  still disagree.
- **Build:** a frame comparison between the reader and kmsgrab, beside the reader in
  `code/src/kernel/msNNN-drm-capture/` (planned — added at P4). Checked by matching frame hashes on a static screen.
- **Efficiency lens:** milliseconds per grab for the reader and for kmsgrab, and the guest's CPU while grabbing.
- **Safety:** QEMU guest only, never the host's `/dev/dri`; learning-only — never a capture-library backend.
- **Sources:** (to verify when the topic opens) `man 1 ffmpeg-devices` (kmsgrab; ffmpeg 6.1.1 on the host,
  27/09/2026); `man 7 vsock`; "VKMS" (<https://docs.kernel.org/gpu/vkms.html>, writeback) as the alternative
  target.
- **Done when:** the hashes match on a static screen, and Sam accounts for any mismatch on a changing one.

## 05 — Why the capture library reads a guest's display from QEMU instead

- **Objective:** Sam can argue, from evidence, why the recorder's capture of a guest goes through QEMU and never
  through DRM inside the guest.
- **Builds on:** lessons 01–04; kernel-11-qemu-display-and-input-control lessons 01–02 (taken, or read for this
  comparison).
- **Key ideas:**
  - With KVM or TCG alike, the display device stays emulated in QEMU, so QEMU holds every frame without any code in
    the guest.
  - The DRM route needs root or master inside the guest, one read path per driver and buffer layout, and handle
    hygiene on every frame; the QEMU route needs none of these.
  - The capture library's scope is X11, Wayland and QEMU/KVM; a DRM backend would need that privilege wherever the
    library runs, and the staging ADR rules it out.
- **Recall targets:** the three costs of the DRM route; what QEMU sees that the guest need not cooperate with.
- **Build:** none — a comparison run with lesson 03's reader in the guest and QMP `screendump` from outside.
- **Security lens:** a capture path that needs `CAP_SYS_ADMIN` in the captured system is a privilege the recorder
  never asks for.
- **Safety:** QEMU guest only, never the host's `/dev/dri`; learning-only — never a capture-library backend.
- **Sources:** (to verify when the topic opens) "The Definitive KVM (Kernel-based Virtual Machine) API Documentation"
  (<https://docs.kernel.org/virt/kvm/api.html>, `KVM_EXIT_IO` and `KVM_EXIT_MMIO`); `man 7 qemu-qmp-ref`
  (`screendump`, QEMU 8.2.2); the capture-library ADR
  (`project-management/src/08-DECISIONS/ADR-MS001-CAPTURE-LIBRARY-STANDALONE-27-09-2026.md`).
- **Done when:** a frame captured both ways matches, and Sam states the privilege each path needed.
