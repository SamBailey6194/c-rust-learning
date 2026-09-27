# ADR-MS001: Scripted recorder — a staged learning project, display servers first, then kernel interfaces in QEMU

| Field | Value |
| --- | --- |
| **ID** | ADR-MS001-SCRIPTED-RECORDER-STAGED-LEARNING-PROJECT |
| **Status** | Proposed |
| **Date** | 27/09/2026 |
| **Milestone** | MS001 — Toolchain ready · `project-management/src/02-MILESTONES/MS001-TOOLCHAIN-READY.md` |
| **Deciders** | Sam Bailey |
| **Supersedes** | — |
| **Superseded by** | — |
| **Research** | — (primary sources and host checks cited below); `research/HYPRLAND-HEADLESS-CAPTURE-AND-INPUT.md` (planned, written when `ui-12` opens) grounds the headless-Hyprland stage |
| **Enforced in** | `project-management/src/01-ROADMAP/ROADMAP.md` → P2 to P5, U2 · `.claude/skills/teach/FAMILIES.md` |

---

## Context

This record is Sam's answer of 27/09/2026 on how the scripted demo recorder is staged as a learning
project: which capture and input backends it gets, in what order, at which phases, and what its
kernel-interface stage may produce.

Sam wants reproducible demo and tutorial videos for social media — his learning progress, and
promotion of Syntek OS — made from his own content only; the recorder never drives another person's
desktop. A video is scripted the way vhs scripts a terminal session, but for GUI applications too (a
browser, an editor, the Syntek OS tools), keyboard first and the mouse rarely. Voice-over and a
floating head are recorded separately afterwards, so a render is a silent video plus a timeline — a
timestamp per command and labelled marks as chapters — and tapes are cut into short sections so that
re-recording one stays small. He asked for the recorder as an added learning project, built in C and
Rust on Linux, down to the kernel's own interfaces.

Three parts of Sam's answers are recorded here rather than in records of their own, because each
fixes the shape of the staging itself. The backend set and its order — X11, then Wayland, then
QEMU/KVM, with TTY consoles and remote-desktop sessions only after those three — decide which stages
exist and in what sequence. DRM/KMS capture being learning-only decides what the last stage may
produce. Where the capture code lives, and under which licence, is a separate choice with its own
consumers, recorded in `ADR-MS001-CAPTURE-LIBRARY-STANDALONE-27-09-2026.md`.

Facts checked on 27/09/2026:

- **The X11 path is nearly installed.** `dpkg-query` reports Xvfb 2:21.1.12-1ubuntu1.8, ffmpeg
  6.1.1, libx11-dev 1.8.7 and libxext-dev 1.3.4; the XTest runtime library (libxtst6) is present but
  its development headers (libxtst-dev) are not (Sources, item 1). Xvfb can report the display it
  took on a file descriptor, refuse TCP clients and require an authorisation cookie (Sources,
  item 2).
- **XTest sends keycodes, and a delayed fake event blocks its client.** A fake key event names a
  keycode, a physical key, so the keyboard layout must be pinned; with a non-zero delay the server
  processes no other request from that client until the delay has passed (Sources, item 3).
- **Wayland cannot run inside Sam's desktop session.** The host session is GNOME on X11
  (`XDG_SESSION_TYPE=x11`, checked 27/09/2026), and Hyprland's start-up failure message asks to be
  run from a TTY or a Wayland session, not an X11 one (Sources, item 4). The Wayland stages therefore
  run in a QEMU guest.
- **The portal asks for consent, and its tokens are single-use.** Starting an xdg-desktop-portal
  ScreenCast session typically presents a dialog; a restore token is invalidated after one use, each
  restore handing back a new one (Sources, item 5). A dialog must never appear in a video, so consent
  belongs to a set-up run.
- **QEMU already exposes the display and input.** QEMU 8.2.2's QMP offers `screendump`, `send-key`
  and `input-send-event` (Sources, item 6). Under KVM, port and memory-mapped I/O that KVM cannot
  satisfy exits to user space for QEMU to complete (Sources, item 7), so a guest's display stays
  emulated in QEMU and is captured the same way under TCG and KVM.
- **The kernel interfaces are live and privileged on the host.** The running kernel is built with
  `CONFIG_INPUT_UINPUT=y` and `/dev/uinput` exists (Sources, item 8), so a virtual keyboard made there
  would type into Sam's own session. Reading a scanout back through `DRM_IOCTL_MODE_GETFB2` returns
  buffer handles only to the DRM master or a caller with `CAP_SYS_ADMIN`, and ffmpeg's kmsgrab device
  carries the same requirement (Sources, item 9).
- **The roadmap already teaches the pieces.** P2 teaches `fork`, `execve`, `waitpid`, pipes, `dup2`
  and `sigaction`; `kernel-01` lessons 06 and 07 teach QEMU on a serial console, its monitor, and a
  debug stub bound to a Unix socket or the loopback address at P4; U2 opens after U1 and `tooling-05`
  (`project-management/src/01-ROADMAP/ROADMAP.md` → Phase overview and P2;
  `learning/kernel-01-build-and-boot-in-qemu/SYLLABUS.md`).
- **A timeline has a standard shape.** WebVTT defines chapter cues (Sources, item 10), and vhs's tape
  commands are documented well enough to re-implement (Sources, item 11).

## Options considered

The three options Sam was offered on 27/09/2026.

### Option A — Kernel interfaces only

- **Summary:** input through uinput and evdev, capture through DRM/KMS, all inside a QEMU guest; no
  display-server backend.
- **Pros:** Goes straight to the kernel's own interfaces, the deepest of the three.
- **Cons:** Nothing can be recorded before P4–P5, and then only inside a guest. DRM capture needs the
  DRM master or `CAP_SYS_ADMIN`, and a guest with a graphical stack, which the P4 busybox guest lacks.
  It records none of the applications Sam actually demonstrates, so it misses the purpose.

### Option B — Linux as a platform only

- **Summary:** display-server backends only — X11 through Xvfb, then headless Wayland on Hyprland — and
  no direct kernel interfaces.
- **Pros:** Usable from P2; records real GUI applications; needs no privilege.
- **Cons:** Stops short of the kernel interfaces Sam asked to learn, and leaves the Syntek OS installer
  and profile images, which boot only in QEMU, with no capture path.

### Option C — Both: display servers first, then kernel interfaces in QEMU

- **Summary:** display-server backends first (C at P2, a Rust port at P3, Wayland in the UI track),
  then a kernel-interface stage (uinput and evdev, then DRM/KMS) in a QEMU guest at P4–P5.
- **Pros:** A working recorder early; each stage sits in the phase that teaches its skills; the kernel
  stage is learnt where it is safe.
- **Cons:** The longest project on the roadmap, spread over five phases and three tracks, with several
  guest images to maintain.

## Decision

**We will take Option C (Sam's answer of 27/09/2026), widened by his scope statement of the same
day:** QEMU/KVM becomes a backend stage of its own, and Wayland covers GNOME and KDE through the
portal as well as Hyprland. The stages, in Sam's binding backend order X11 → Wayland → QEMU/KVM:

- **Stage 1 — C on X11** (P2, Later; `learning/c-05-scripted-screen-recorder/`): a tape parser, Xvfb
  and the application launched and reaped, XTest keys, frames piped to ffmpeg, a timeline and
  captions. The code lands here, in `code/src/c/msNNN-scripted-recorder/`, under the full C gates.
- **Stage 2 — the Rust port** (P3, Later; P3's rust topics): a capture trait and an input trait. It is
  not P3's gate port. The scripted-recorder repository and the capture-library repository are
  created at this stage, when the capture trait is defined.
- **Stage 3a — Wayland on headless Hyprland** (U2, Later, outside U2's exit gate;
  `learning/ui-12-headless-wayland-capture-and-input/`), in a QEMU guest.
- **Stage 3b — Wayland on GNOME, then KDE, through the xdg-desktop-portal ScreenCast interface and
  PipeWire** (U2, Later, outside U2's exit gate, after 3a;
  `learning/ui-13-portal-screencast-and-pipewire/`), in a guest.
- **Stage 4 — QEMU/KVM** (P4, Later; `learning/kernel-11-qemu-display-and-input-control/`): QMP
  `screendump` and input first, then VNC over a Unix socket, with SPICE and libvirt after it.
- **Stage 5a — uinput and evdev input** (P4, Later; `learning/kernel-09-virtual-input-devices/`), in a
  guest only.
- **Stage 5b — DRM/KMS capture** (P5, Later; `learning/kernel-10-drm-kms-capture/`), in a guest only,
  and **learning-only**.

The rules that go with the stages:

1. **The order is held by prerequisites.** Each backend stage's prerequisites include the previous
   backend stage `Done`, so stage 4 waits for 3a and 3b even though P4 may open first. Only an
   exception Sam states explicitly relaxes it, never a default.
2. **DRM/KMS capture is learning-only.** Stage 5b's lesson code runs in a guest and never becomes a
   capture backend, so no tool ships it.
3. **TTY consoles and remote-desktop sessions wait for stages 1–4.** They are parked in `DEFERRED.md`
   until the X11, Wayland and QEMU/KVM stages are all `Done`; a guest's text console is already
   captured by stage 4.
4. **Every stage is a Later leaf.** No Core topic may list a recorder topic, and recorder milestones
   never delay P2's shell and allocator projects.

The deciding factor is that only Option C gives Sam a working recorder for his own GUI applications
from P2 and still teaches the kernel interfaces he asked for, each at the phase whose lessons it
needs. Option B was the runner-up — it is Option C's display-server half — and lost because it would
leave the kernel interfaces and the QEMU images untaught.

This answer changes if a stage's first spike shows its backend cannot run where it is planned (for
example, headless Hyprland in the guest that stage chooses), or if Sam reorders the backends; either
is argued in a new ADR.

## Consequences

- **Positive:** The recorder makes videos from P2 onwards, and every stage reuses lessons its phase
  already teaches. When P6 arrives, the QEMU/KVM stage records the Syntek OS installer and profile
  images, their text consoles included.
- **Negative:** A long project: stage 1 alone is several milestones, and the guest images for
  Hyprland, GNOME and KDE are fetched and kept outside git. Whether an Xlib client passes `make san`
  and `make memcheck` without suppressions is unverified. Strict order can hold stage 4 back while P4
  is open. Mitigation: every stage is Later, so none holds a phase gate, and each candidate
  milestone is kept to 8 points or fewer.
- **What every stage keeps:**
  - Sam's own content only; the recorder never drives another person's desktop.
  - Captions and the timeline come from the tape, never from observed input: nothing reads
    `/dev/input/event*`, the X RECORD extension stays disabled, and no input-capture protocol is used.
  - A clean fixture: throwaway home and profile directories, an environment built from scratch, a
    private display and cookie, and a pinned keyboard layout. Consent dialogs and permission prompts
    happen in set-up runs, never on camera, and `.claude/CLAUDE.md` Section 5's public-repo hygiene
    covers every published video, screenshot or recording.
  - A render is a silent video plus a WebVTT file and embedded chapters, one file per tape section,
    with each geometry (1080x1920 and 1920x1080) a fresh render, never a crop. Renders are build
    output and are never committed.
  - Guest-only interfaces stay in the guest: uinput and DRM code never touch the host's `/dev/uinput`
    or `/dev/dri`, and QMP and VNC listen on Unix sockets in a private directory, never on TCP.
- **Follow-on:**
  - `project-management/src/01-ROADMAP/ROADMAP.md` gains the stages as Later candidates in P2 to P5
    and U2, the Core row carves out `c-05` and the port, and U2's exit gate carves out `ui-12` and
    `ui-13`.
  - `learning/` gains `c-05`, `ui-12`, `ui-13`, `kernel-09`, `kernel-10` and `kernel-11`;
    `.claude/skills/teach/FAMILIES.md` gains their sources, the guest-only rules, and the placeholders
    "the scripted-recorder repository" and "the capture-library repository".
  - `GAPS.md` records the missing build dependencies (`libxtst-dev`, the guest images);
    `DEFERRED.md` records the TTY-console and remote-desktop backends.
  - Each stage gets a project spec through `project-management/workflows/05-project-spec/`, and
    stage 5a a kernel plan through `project-management/workflows/06-kernel-spec/`, each with its
    Budget and Threat model. The choices left open here — the route for terminal-only videos before
    stage 1 lands, which guest runs Hyprland, which portal desktop comes first, the QEMU frame path,
    and the libvirt and SPICE routes — are settled in the spec of the stage that needs them.
  - Stage 1's first milestone settles the feature-test macro policy, the X11 link flags and any
    suppression policy in `code/docs/BUILD.md` and `code/docs/MEMORY-SAFETY.md`.

## Sources

1. **Host packages, 27/09/2026** — `dpkg-query -W` for xvfb, ffmpeg, libx11-dev, libxext-dev,
   libxtst6 and libxtst-dev
2. **`man 1 Xvfb` and `man 1 Xserver`** (xvfb 2:21.1.12) — `-displayfd`, `-nolisten`, `-auth`,
   `-extension`, `-tst`, checked 27/09/2026
3. **XTEST Extension Library, version 2.2** —
   <https://www.x.org/releases/current/doc/libXtst/xtestlib.html> — `XTestFakeKeyEvent` and the
   delay's effect on the client, checked 27/09/2026
4. **Hyprland, `src/Compositor.cpp`** — <https://github.com/hyprwm/Hyprland/blob/main/src/Compositor.cpp>
   — the back-end start-up failure message, read on the main branch on 27/09/2026
5. **xdg-desktop-portal, ScreenCast interface** —
   <https://flatpak.github.io/xdg-desktop-portal/docs/doc-org.freedesktop.portal.ScreenCast.html>
   and `data/org.freedesktop.portal.ScreenCast.xml` on the main branch — `Start`, `persist_mode` and
   restore tokens, checked 27/09/2026
6. **`man 7 qemu-qmp-ref`** (QEMU 8.2.2) — `screendump`, `send-key`, `input-send-event`, checked
   27/09/2026
7. **The Definitive KVM API Documentation** — <https://docs.kernel.org/virt/kvm/api.html> —
   `KVM_EXIT_IO` and `KVM_EXIT_MMIO`, checked 27/09/2026
8. **uinput module** — <https://docs.kernel.org/input/uinput.html>; the running kernel's
   configuration (`CONFIG_INPUT_UINPUT=y`) and `/dev/uinput`, checked 27/09/2026
9. **`/usr/include/drm/drm.h`** — the `DRM_IOCTL_MODE_GETFB2` comment; **`man 1 ffmpeg-devices`**
   (ffmpeg 6.1.1) → kmsgrab, checked 27/09/2026
10. **WebVTT: The Web Video Text Tracks Format** — <https://www.w3.org/TR/webvtt1/> — Section 3.5,
    WebVTT chapter cues, checked 27/09/2026
11. **vhs README, VHS Command Reference** — <https://github.com/charmbracelet/vhs> — the tape
    commands (MIT licence), checked 27/09/2026
12. **Sam's answers of 27/09/2026** — the recorder's purpose, the staging, the backend scope and order,
    and DRM/KMS as learning-only
