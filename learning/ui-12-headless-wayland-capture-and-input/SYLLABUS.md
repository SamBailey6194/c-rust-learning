# Syllabus — ui-12-headless-wayland-capture-and-input

**Track**: ui · **Phase**: U2 · **Path**: Later · **Detail**: outline · **Prerequisites**: the scripted recorder's stage 2 `Done` (the Rust port at P3, which creates the capture-library and scripted-recorder repositories — `project-management/src/08-DECISIONS/ADR-MS001-SCRIPTED-RECORDER-STAGED-LEARNING-PROJECT-27-09-2026.md`); P3 including its async Rust topic; ui-08-gui-foundations lesson 01 (the Wayland client model — reading, no GTK); os-15-desktop-editions lesson 01 (the graphics stack — reading); kernel-01-build-and-boot-in-qemu lesson 06 (QEMU invocation), or a how-to runbook added at this topic's first milestone
**Status**: Planned · **Checked**: 27/09/2026 (sources re-verified by `/teach` step 3 before each lesson)

Stage 3a of the scripted demo recorder: the tapes that render on X11 through Xvfb since stage 1 also render on a
headless Wayland compositor, Hyprland, inside a QEMU guest. This topic teaches what that takes — why Hyprland still
needs a DRM device when it has no screen, how a client copies frames out of a compositor through
ext-image-copy-capture-v1 (wlr-screencopy and Hyprland's toplevel export as fallbacks), how the virtual keyboard and
pointer protocols type into it under a pinned keymap the recorder uploads, and why capture and injection are
privileged interfaces the fixture must lock down. The capture backend lands in the capture-library repository and the
input backend in the scripted-recorder repository, both created at stage 2
(`project-management/src/08-DECISIONS/ADR-MS001-CAPTURE-LIBRARY-STANDALONE-27-09-2026.md`); the library returns
frames and damage hints only, and the tape language, input, timeline and captions stay in the recorder. It is marked
**Later**, sits outside U2's exit gate and is an outline until U2 reaches it; in the recorder's binding order it comes
after stage 2 and before the portal stage (ui-13-portal-screencast-and-pipewire) and the QEMU/KVM stage
(kernel-11-qemu-display-and-input-control). Everything runs in a QEMU guest, never Sam's desktop session (GNOME on
X11, which Hyprland refuses as a parent anyway). Points marked "to settle" wait for
`research/HYPRLAND-HEADLESS-CAPTURE-AND-INPUT.md` (planned — written by `/research` when this topic opens); the guest
images are not fetched yet (`GAPS.md` → "Scripted recorder build dependencies not installed").

| # | Lesson | Size | Build | Lenses |
| --- | --- | --- | --- | --- |
| 01 | Running Hyprland without a screen | 2–3 sittings | yes — headless guest spike | Efficiency, Safety |
| 02 | Copying frames out with ext-image-copy-capture-v1 | 2–3 sittings | yes — one-frame grab | Efficiency, Security |
| 03 | A virtual keyboard and pointer, and uploading a keymap | 2–3 sittings | yes — one-key injection | Security |
| 04 | The capture backend in the library, input in the recorder | multi-session build | yes — Wayland backends | Efficiency, Security |
| 05 | Capture and injection as privileged interfaces | 1 sitting | yes — locked-down fixture | Security, Safety |

---

## 01 — Running Hyprland without a screen

- **Objective:** Sam can start a pinned Hyprland release in a QEMU guest, give it a headless output at a chosen size,
  and explain from the source why it still needs a DRM device.
- **Builds on:** kernel-01 lesson 06 (QEMU invocation); os-15 lesson 01 (DRM and KMS; the compositor as the display
  server — reading).
- **Key ideas:**
  - Hyprland asks its backend library, Aquamarine, for three backends: headless (mandatory), DRM (if available) and
    Wayland (fallback). It refuses to start under an X11 parent.
  - Aquamarine's headless backend has no DRM file descriptor, and without one there is no buffer allocator, so
    headless outputs alone do not start: the guest needs a DRM device (KMS, or render-only with
    `AQ_NO_KMS_REQUIREMENT`) or a parent Wayland session.
  - Further outputs come from `hyprctl output create headless <name>`. Each output size is a video geometry (1920x1080,
    1080x1920), rendered fresh; whether portrait headless modes work is to settle.
  - Hyprland's own tests boot a NixOS guest with `-vga none -device virtio-gpu-pci` and 8192 MiB, and start the
    compositor through `su` from the test script; how seat and DRM access work on that path is to settle, and so is
    the renderer under 2D-only virtio-gpu.
  - Pin one release: the configuration is now written in Lua, the wiki describes the current release rather than the
    pinned one, and `hyprctl`'s usage text and the wiki spell some dispatcher names differently.
- **Recall targets:** the three backends and which one is mandatory; why a headless output still needs a DRM file
  descriptor; why Sam's host session cannot be the parent.
- **Build:** yes, outline (sketched in full when U2 reaches this topic) — the stage's spike, part one: a guest image and
  a QEMU command that start the pinned Hyprland with a headless output and answer `hyprctl` queries over its IPC
  socket, with the command, versions and guest size recorded in the milestone. Which guest (a stock image with 2D
  virtio-gpu, a virgl variant, or the Syntek OS expert image at P6) is decided at this spike.
- **Efficiency lens:** guest RAM and the time from boot to the first headless output — the baseline every later
  render is measured against.
- **Safety:** a QEMU guest only, never Sam's desktop session; the guest image is fetched and built outside git; Sam
  runs any install, and Claude never runs `sudo`.
- **Sources:** (to verify when the topic opens) Hyprland (<https://github.com/hyprwm/Hyprland>, BSD-3-Clause) —
  `src/Compositor.cpp` (the backend list and the X11 refusal) and `nix/tests/default.nix`, read at main 4bb6844b on
  27/09/2026, to be re-read at the pinned release; Aquamarine (<https://github.com/hyprwm/aquamarine>, BSD-3-Clause) —
  `src/backend/Headless.cpp` and `src/backend/Backend.cpp`; the Hyprland wiki (<https://wiki.hypr.land/>, source
  <https://github.com/hyprwm/hyprland-wiki>) — "Environment variables" (`AQ_NO_KMS_REQUIREMENT`), "Using hyprctl"
  (`output create`) and "Virtual GPU".
- **Done when:** the guest shows a headless output that answers `hyprctl`, and Sam explains from Aquamarine's source
  why the headless backend alone cannot start.

## 02 — Copying frames out with ext-image-copy-capture-v1

- **Objective:** Sam can grab one frame of a headless output from a Wayland client through ext-image-copy-capture-v1
  into a shared-memory buffer he allocated, and read the damage that comes with it.
- **Builds on:** lesson 01; ui-08 lesson 01 (the registry, globals and `wl_shm` buffers); the stage 2 capture trait
  and its mapped-memory rules.
- **Key ideas:**
  - A capture client binds globals from the registry like any other; Hyprland registers ext-image-copy-capture-v1
    (version 1) beside wlr-screencopy (version 3) and its own toplevel export (version 2).
  - ext-image-copy-capture works on a capture source from ext-image-capture-source-v1 — an output or a toplevel. The
    compositor states the buffer constraints; the client allocates a `wl_shm` buffer (a memfd), attaches it, and gets
    back a filled frame with its damage.
  - wayland.app marks wlr-screencopy deprecated in favour of ext-image-copy-capture; it stays a fallback, as the
    toplevel export does for a single window.
  - Damage is a free stable-screen signal: no damage for several frames means the screen has settled — the Wayland
    accelerator for the recorder's `WaitStable`.
  - wlr-screencopy's `copy_with_damage` waits for new damage, so on a static screen it never returns by itself: every
    wait has a timeout. Whether ext-image-copy-capture behaves the same way is to settle.
- **Recall targets:** the object chain from the registry to a filled buffer; who allocates the buffer and why; what
  damage tells the recorder.
- **Build:** yes, outline (sketched in full when U2 reaches this topic) — the spike, part two: one frame from the
  guest's headless output written as an image, as spike code in the capture-library repository; checked against the
  output's mode (size and pixel format) and by eye.
- **Efficiency lens:** milliseconds per grab and bytes copied per frame at 1920x1080 in the guest, compared with
  stage 1's XShm grab.
- **Security lens:** a client that can copy the screen sees everything on it; lesson 05 decides who may.
- **Sources:** (to verify when the topic opens) ext-image-copy-capture-v1
  (<https://wayland.app/protocols/ext-image-copy-capture-v1>); ext-image-capture-source-v1
  (<https://wayland.app/protocols/ext-image-capture-source-v1>); wlr-screencopy-unstable-v1, with its deprecation
  note (<https://wayland.app/protocols/wlr-screencopy-unstable-v1>); hyprland-toplevel-export-v1
  (<https://wayland.app/protocols/hyprland-toplevel-export-v1>); Hyprland `src/managers/ProtocolManager.cpp` (the
  registered versions); wayland-rs (<https://smithay.github.io/wayland-rs/>) and the wayland-client crate
  (<https://docs.rs/wayland-client/latest/wayland_client/>, MIT); `man 2 memfd_create`, `man 2 mmap` (Linux
  man-pages 6.7).
- **Done when:** a frame from the guest matches the headless output's size and content, and Sam explains when a
  damage wait would hang without a timeout.

## 03 — A virtual keyboard and pointer, and uploading a keymap

- **Objective:** Sam can type into a guest application through the virtual keyboard protocol under a gb/pc105 keymap he
  compiled and uploaded, and move the pointer through the virtual pointer protocol.
- **Builds on:** lesson 01; c-05-scripted-screen-recorder lesson 04 (keysym to keycode under a pinned layout, on
  X11); ui-08 lesson 01.
- **Key ideas:**
  - Hyprland registers `zwp_virtual_keyboard_manager_v1` (version 1) and `zwlr_virtual_pointer_manager_v1`
    (version 2).
  - A virtual keyboard must be given a keymap before its first key, or the compositor raises a protocol error; the
    keymap is an XKB keymap compiled with xkbcommon from rules, model and layout, and handed over as a file
    descriptor.
  - Keys are keycodes in that keymap, so the keysym-to-keycode lookup stays the recorder's job, exactly as on X11;
    modifier state is sent explicitly.
  - Whether the compositor's own configured layout ever applies to a virtual keyboard is to settle; the recorder
    assumes it does not and always uploads its own.
  - Pointer motion is absolute, scaled to the output's extent; keyboard-first tapes rarely need it.
- **Recall targets:** why the keymap comes before any key; where the keysym-to-keycode lookup happens; what the file
  descriptor carries.
- **Build:** yes, outline (sketched in full when U2 reaches this topic) — the spike, part three: one key typed into a
  terminal in the guest, as spike code in the scripted-recorder repository; checked by a lesson 02 frame showing the
  character.
- **Security lens:** a virtual keyboard is an injection device, and Hyprland accepts new keyboards by default (lesson
  05). The recorder never reads input back: captions come from the tape, so no input-capture protocol is ever used.
- **Sources:** (to verify when the topic opens) virtual-keyboard-unstable-v1
  (<https://wayland.app/protocols/virtual-keyboard-unstable-v1>) — the keymap-first rule;
  wlr-virtual-pointer-unstable-v1 (<https://wayland.app/protocols/wlr-virtual-pointer-unstable-v1>); libxkbcommon
  (<https://xkbcommon.org/doc/current/>) and the xkbcommon crate (<https://docs.rs/xkbcommon/latest/xkbcommon/>, MIT);
  Hyprland's virtual-keyboard sources under `src/protocols/` and `src/devices/`.
- **Done when:** the key appears in the guest terminal under the gb layout — `"` and `@` both typed correctly, since gb
  and us swap them — and Sam predicts what a key sent before the keymap does.

## 04 — The capture backend in the library, input in the recorder

- **Objective:** Sam can implement the capture trait for Wayland in the capture library and the input trait for Wayland
  in the recorder, so that stage 1's tapes render in the guest with the same timelines as their X11 renders.
- **Builds on:** lessons 01–03; the stage 2 capture and input traits; P3's async Rust topic.
- **Key ideas:**
  - The library boundary: frames and damage hints out, nothing else. Tape language, input, timeline, captions and
    encoding stay in the recorder.
  - The trait is the seam: a new backend is a new implementation, never a fork of the recorder.
  - The Wayland event loop dispatches events and must never block on the encoder; a bounded queue sits between them,
    and the virtual frame clock holds — a late frame duplicates the last one and is logged, as on X11.
  - Hyprland-specific code lives only in launch (starting the compositor, creating the headless output); capture and
    input use the generic protocols, so a Hyprland change touches one place.
  - The timeline is computed from the tape and the frame clock, never from what the compositor did — so it must equal
    the X11 render's.
- **Recall targets:** what crosses the library boundary and what does not; why Hyprland-specific code is confined to
  launch; why the two timelines must be equal.
- **Build:** yes, outline (sketched in full when U2 reaches this topic) — the stage's two later milestones: the Wayland
  capture backend (ext-image-copy-capture-v1, wlr-screencopy fallback) in the capture-library repository, and the
  virtual keyboard and pointer backend, keymap upload and Hyprland launch in the scripted-recorder repository.
  `cargo fmt --check`, `cargo clippy --all-targets -- -D warnings` and `cargo deny check` clean in both; checked by
  rendering stage 1's tapes in the guest.
- **Efficiency lens:** render time, frames per second and guest RAM against the X11 render of the same tape.
- **Security lens:** `cargo deny check` straight after adding each crate; every `unsafe` block around mapped memory
  carries its `// SAFETY:` comment. The crates.io `hyprland` crate is GPL-3.0-or-later, which is not compatible with
  GPL-2.0, and is never added.
- **Sources:** (to verify when the topic opens) The Rust Programming Language, "Using Trait Objects to Abstract over
  Shared Behavior" (<https://doc.rust-lang.org/book/ch18-02-trait-objects.html>); the wayland-client crate
  (<https://docs.rs/wayland-client/latest/wayland_client/>);
  `project-management/src/08-DECISIONS/ADR-MS001-CAPTURE-LIBRARY-STANDALONE-27-09-2026.md`; FSF, "Various licenses and
  comments about them" (<https://www.gnu.org/licenses/license-list.html>, the GPLv3 entry).
- **Done when:** stage 1's tapes render in the guest with timelines equal to their X11 renders, and the budget is
  recorded in the milestone.

## 05 — Capture and injection as privileged interfaces

- **Objective:** Sam can threat-model the recorder's Wayland fixture — who may copy the screen, who may add a keyboard,
  who may reach the compositor's IPC socket — and lock each down so that no prompt ever reaches a video.
- **Builds on:** lessons 01–04; sec-01 (attack surface, trust boundaries and threat models); c-05 lesson 03 (the
  recorder's first-cut fixture); sec-04 lesson 07 (the sandbox launcher), once taken.
- **Key ideas:**
  - Hyprland's permission system works only with `hyprland-guiutils` installed and is off until enabled; a rule names
    a binary by a path pattern and is not reloaded while the compositor runs.
  - Screen copying defaults to asking, and asking pops a notification — on camera. The fixture allows the recorder's
    own binary and denies the rest; a denied copy renders a black "permission denied" frame, which a render check can
    catch.
  - New keyboards, virtual ones included, are allowed by default; the fixture limits them to the recorder's device.
  - Hyprland cannot restrict its own IPC socket: whoever reaches it can run dispatchers, so confining the socket is the
    sandbox's job, not the compositor's.
  - A prompt or popup in a render is a failure, never something to edit out afterwards.
- **Recall targets:** the three interfaces and each one's default; why a popup is a render failure; who guards the IPC
  socket.
- **Build:** yes, outline (sketched in full when U2 reaches this topic) — the fixture's permission rules and socket
  confinement in the scripted-recorder repository; checked by removing one rule and watching the render fail loudly
  instead of recording a prompt or a black frame.
- **Security lens:** the recorder is itself a screen-capture and key-injection tool; it gets the narrowest permissions
  that let it render, and nothing it is granted outlives the guest.
- **Safety:** guest only; no rule or setting here touches Sam's desktop session.
- **Sources:** (to verify when the topic opens) the Hyprland wiki, "Permissions" and "Dispatchers"
  (<https://wiki.hypr.land/>; source `content/configuring/core/advanced-configuration/permissions.md` and
  `content/configuring/core/dispatchers.md` in <https://github.com/hyprwm/hyprland-wiki>, read at d5498a9 on
  27/09/2026).
- **Done when:** the fixture's threat model is written, a render with every rule in place shows no prompt, and a render
  with a rule removed fails before it records one.
