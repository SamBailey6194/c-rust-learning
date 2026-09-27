# Syllabus — kernel-11-qemu-display-and-input-control

**Track**: kernel · **Phase**: P4 · **Path**: Later · **Detail**: outline · **Prerequisites**: kernel-01-build-and-boot-in-qemu lessons 06–07 (the QEMU harness and its monitor through the multiplexer; a debug stub bound to 127.0.0.1 or a Unix socket); P2 sockets (a client with `socket` and `connect`, here on `AF_UNIX`); for every Build, the scripted recorder's Wayland stages `Done` — ui-12-headless-wayland-capture-and-input and ui-13-portal-screencast-and-pipewire — in Sam's backend order X11 → Wayland → QEMU/KVM, kept strictly
**Status**: Planned · **Checked**: 27/09/2026 (sources re-verified by `/teach` step 3 before each lesson)

Stage 4 of the scripted demo recorder
(`project-management/src/08-DECISIONS/ADR-MS001-SCRIPTED-RECORDER-STAGED-LEARNING-PROJECT-27-09-2026.md`) and the
capture library's QEMU/KVM backend
(`project-management/src/08-DECISIONS/ADR-MS001-CAPTURE-LIBRARY-STANDALONE-27-09-2026.md`): watching and driving a QEMU
guest from outside it, through QMP, through RFB on a Unix socket and, as a wrapper, through libvirt. It extends
kernel-01's monitor and socket-binding lessons without changing that Core topic. It sits at P4 because its skills are
P4's — QEMU invocation, the monitor, a control channel bound to a socket — while P6 only adds images to record: Syntek
OS installer and profile demos boot in QEMU and find the backend ready, guest text consoles included. Being a P4 topic
does not let it jump Sam's order: its milestones wait until both Wayland stages are `Done`, and until then its lessons
are reading, recall and a note only. It is **Later** and **outline** detail, a leaf that no Core topic lists. Its
Builds land in the capture-library repository (the capture backend) and the scripted-recorder repository (the input),
both created at the recorder's stage 2. Every control socket is a Unix socket in a private directory, never TCP: the
QMP socket is full control of the VM, and a VNC socket an unauthenticated view of its screen.

Version facts to re-verify on the day (read 27/09/2026): the host runs QEMU 8.2.2, whose `man 7 qemu-qmp-ref` is the
pinned QMP reference, and libvirt 10.0.0; qemu.org's manual pages are the master build. A probe that day (TCG, SeaBIOS
text mode at 720x400, one datapoint) measured `screendump` at about 1.8 ms per PPM grab and 9.0 ms per PNG grab, and saw
a relative filename fail with `EACCES` under `-daemonize`, cause unknown — so filenames are absolute.

| # | Lesson | Size | Build | Lenses |
| --- | --- | --- | --- | --- |
| 01 | From the human monitor to QMP | 2–3 sittings | yes — QMP client | Security, Safety |
| 02 | `screendump`: polled frames and their cost | 1 sitting | yes — polled capture | Efficiency |
| 03 | RFB over a Unix socket: pulled updates and damage | 2–3 sittings | yes — RFB client | Efficiency, Security |
| 04 | Input from outside the guest: `send-key` and `input-send-event` | 1 sitting | yes — QEMU input | Safety |
| 05 | libvirt as a wrapper, and the socket as the trust boundary | 1 sitting | no | Security |
| 06 | The QEMU backend in the library, input in the recorder | multi-session build | yes — QEMU backend | Efficiency, Security |

---

## 01 — From the human monitor to QMP

- **Objective:** Sam can open QEMU's machine protocol on a Unix socket, negotiate it, run a command and read an event
  — and say what KVM runs and what QEMU still emulates.
- **Builds on:** kernel-01 lessons 06 (the monitor behind `Ctrl+a c`) and 07 (a control channel bound to 127.0.0.1 or
  a Unix socket, never every interface); P2 sockets.
- **Key ideas:**
  - The human monitor is for people; QMP is the same control as JSON for programs, opened with
    `-qmp unix:<path>,server=on,wait=off`.
  - On connecting, QEMU sends a greeting with its version and capabilities; `qmp_capabilities` must be the first
    command, and nothing else is accepted until it has run.
  - A command is `execute` with `arguments`, answered by `return` or `error`; events such as a shutdown arrive unasked
    between replies, so a client tags its commands with an `id` and matches the replies.
  - KVM runs the virtual CPUs; when the guest touches a device's I/O ports or memory-mapped registers, the exit comes
    back to QEMU, which emulates the device — so the display stays in QEMU, and TCG and KVM guests are captured the
    same way.
  - A socket path must fit `sun_path` (108 bytes, `man 7 unix`).
- **Recall targets:** why `qmp_capabilities` comes first; how a client tells a reply from an event; what KVM runs and
  what QEMU still emulates, and what that means for capture.
- **Build:** a QMP client — greeting, negotiation, one command, one event — in the capture-library repository (created
  at the recorder's stage 2). Checked against a disposable guest from kernel-01's harness, under TCG and under KVM.
- **Security lens:** the QMP socket is full control of the VM, so it lives in a private 0700 directory; the manual's
  own example listens on TCP, which this repository never copies.
- **Safety:** a disposable guest with `-nic none`; nothing runs on the host kernel.
- **Sources:** (to verify when the topic opens) `man 7 qemu-qmp-ref` (QEMU 8.2.2, "QMP monitor control",
  `qmp_capabilities`); "QEMU Machine Protocol Specification" (<https://www.qemu.org/docs/master/interop/qmp-spec.html>);
  `man 1 qemu-system` (`-qmp`, `-mon`, `-chardev`); "The Definitive KVM (Kernel-based Virtual Machine) API
  Documentation" (<https://docs.kernel.org/virt/kvm/api.html>, `KVM_EXIT_IO` and `KVM_EXIT_MMIO`); `man 7 unix`.
- **Done when:** the client negotiates, runs a command and reports a shutdown event under both accelerators, and Sam
  predicts what a command sent before negotiation returns.

## 02 — `screendump`: polled frames and their cost

- **Objective:** Sam can grab a guest's screen through QMP on demand, as PPM or PNG, and measure what each grab
  costs.
- **Builds on:** lesson 01.
- **Key ideas:**
  - `screendump` writes one image file per call — there is no stream; `device` and `head` (since 2.12) pick a display
    and `format` (since 7.1) picks PNG or PPM, with PPM the default.
  - It works under `-display none`, so the guest needs no window on the host.
  - PPM is raw pixels behind a short header; PNG compresses inside QEMU, about five times dearer in the probe, so
    encoding belongs in the recorder's pipeline, not in QEMU.
  - Polling says nothing about whether the screen changed; the library holds the last frame to keep a constant video
    rate, and lesson 03's stream adds the change information.
- **Recall targets:** what each argument selects; why PPM rather than PNG; what polling cannot tell the recorder.
- **Build:** polled capture on lesson 01's client, writing frames to absolute paths in a private directory, in the
  capture-library repository. Checked by identical frames on a static screen.
- **Efficiency lens:** milliseconds per grab, PPM against PNG, at the text mode and at 1080p, under TCG and KVM, with
  host CPU while polling.
- **Sources:** (to verify when the topic opens) `man 7 qemu-qmp-ref` (`screendump`, `ImageFormat`); Netpbm, "PPM"
  (<https://netpbm.sourceforge.net/doc/ppm.html>).
- **Done when:** the cost table is recorded and Sam explains the PNG penalty from what each format does.

## 03 — RFB over a Unix socket: pulled updates and damage

- **Objective:** Sam can read a guest's screen as a stream from QEMU's VNC server on a Unix socket, applying the
  changed rectangles each update carries.
- **Builds on:** lesson 02; P2 sockets; c-05-scripted-screen-recorder lesson 08 (waiting on the screen, not the clock).
- **Key ideas:**
  - `-vnc unix:<path>` serves RFB on a Unix socket; the TCP form listens on every interface when its host is omitted,
    so it is never used here.
  - RFB is pulled: the client sends `FramebufferUpdateRequest`, full or incremental, and the server answers when it has
    something — possibly after an indefinite wait, so the backend holds the last frame for a constant rate.
  - Each update is a set of changed rectangles — damage, which tells the recorder's screen-stability wait what
    `screendump` cannot.
  - The handshake agrees a version and a security type; over a private Unix socket "None" is acceptable, over a network
    never.
  - Stretch: `-display dbus` (since 7.0) pushes frames over D-Bus instead; read from the master manual only, it is
    weighed in the stage 4 spec.
- **Recall targets:** pulled against pushed updates; what an incremental request yields on a static screen; why a TCP
  VNC listener is ruled out.
- **Build:** an RFB client for the capture backend, in the capture-library repository. Checked by an RFB frame
  matching a `screendump` frame on a static screen, with no new TCP listener on the host (`ss -ltn`).
- **Efficiency lens:** frames per second and host CPU, against lesson 02's polling.
- **Security lens:** RFB with security type "None" is an unauthenticated view of the guest's screen; the socket's
  directory is its only access control.
- **Sources:** (to verify when the topic opens) RFC 6143, "The Remote Framebuffer Protocol"
  (<https://www.rfc-editor.org/rfc/rfc6143>, 7.1 handshake, 7.5.3 FramebufferUpdateRequest, 7.6.1 FramebufferUpdate);
  `man 1 qemu-system` (`-vnc`, `unix:path`; `-display dbus`); the community RFB protocol notes for QEMU's extensions
  (<https://github.com/rfbproto/rfbproto>).
- **Done when:** the frames match, no TCP port opens, and Sam explains why the backend must hold the last frame.

## 04 — Input from outside the guest: `send-key` and `input-send-event`

- **Objective:** Sam can type into a guest and move its pointer through QMP with the guest's layout pinned, and check
  what arrived.
- **Builds on:** lessons 01–02; kernel-09-virtual-input-devices lesson 01 if taken (a key code is a position).
- **Key ideas:**
  - `send-key` takes QEMU key codes (qcodes) or raw numbers and sends them all at once, releasing them after
    `hold-time` (100 ms by default): one call is one chord, and a typed word is one call per key.
  - `input-send-event` (since 2.6) sends key, button, relative and absolute pointer events, optionally to a named
    display device and head.
  - The QMP reference gives absolute coordinates a range of 0 to 0x7ffff, while QEMU's input header uses 0x7FFF — a
    discrepancy this lesson checks rather than assumes.
  - qcodes are positions; the guest's layout is pinned in its image, and `-k` matters only for displays that cannot
    pass raw PC key codes.
  - Input belongs to the recorder, not the capture library; whether it shares the library's QMP connection or opens its
    own is settled in the stage 4 spec.
- **Recall targets:** why one `send-key` call is one chord; what `hold-time` changes; where the layout is pinned.
- **Build:** QEMU input behind the recorder's input trait — `send-key` per chord, `input-send-event` for a rare pointer
  line — in the scripted-recorder repository (created at the recorder's stage 2). Checked by a tape line typed into a
  shell on the guest's VGA console and read back in a `screendump` frame.
- **Safety:** a disposable guest; control sockets in a private directory.
- **Sources:** (to verify when the topic opens) `man 7 qemu-qmp-ref` (`send-key`, `input-send-event`,
  `InputMoveEvent`, `QKeyCode`); QEMU include/ui/input.h at v8.2.2
  (<https://gitlab.com/qemu-project/qemu/-/blob/v8.2.2/include/ui/input.h>); `man 1 qemu-system` (`-k`).
- **Done when:** the typed line appears in the frame, and Sam resolves the coordinate-range discrepancy from the source.

## 05 — libvirt as a wrapper, and the socket as the trust boundary

- **Objective:** Sam can show that libvirt's screenshot and send-key calls are QMP underneath, and say what access to
  libvirt's socket grants.
- **Builds on:** lessons 01–04.
- **Key ideas:**
  - `virDomainScreenshot` in libvirt's QEMU driver runs `screendump` into a temporary file and streams it back: access
    control around the same path, not a new capture path.
  - `virDomainSendKey` takes a codeset, a hold time and at most 16 key codes, sent together and possibly received in
    any order; `virsh send-key` defaults to the Linux codeset.
  - libvirt checks each call against permissions such as `domain:screenshot` and `domain:send-input`; read-write access
    to its socket is treated here as equivalent to root — a threat-model assumption, not a quotation.
  - Whether the recorder ever drives libvirt — through `virsh` as a subprocess, or a binding crate that needs a
    licence-policy change — is decided at stage start.
- **Recall targets:** what `virsh screenshot` does underneath; why sixteen keys "together" are not a typed word; what
  the socket grants.
- **Build:** none — reading, with `virsh screenshot` and `virsh send-key` run against a disposable libvirt-managed
  guest.
- **Security lens:** the socket is the trust boundary; the group memberships that grant it are never recorded in the
  repository.
- **Sources:** (to verify when the topic opens) libvirt domain API
  (<https://libvirt.org/html/libvirt-libvirt-domain.html>, `virDomainScreenshot`, `virDomainSendKey`); libvirt
  "Client access control" (<https://libvirt.org/acl.html>, domain permissions); `man 1 virsh` (libvirt 10.0.0,
  `screenshot`, `send-key`); src/qemu/qemu_driver.c at v10.0.0
  (<https://gitlab.com/libvirt/libvirt/-/blob/v10.0.0/src/qemu/qemu_driver.c>).
- **Done when:** Sam traces a `virsh screenshot` to its `screendump` and states what the socket grants.

## 06 — The QEMU backend in the library, input in the recorder

- **Objective:** Sam can record a stage-1 tape against a TCG guest and a KVM guest through the capture library's QEMU
  backend and the recorder's QEMU input, with identical timelines.
- **Builds on:** lessons 01–05; the recorder's stage 2 traits (capture in the library, input in the recorder).
- **Key ideas:**
  - The backend implements the library's capture trait — start, grab, damage hint, stop — with polled `screendump`
    first and RFB as the stream, holding the last frame for a constant rate.
  - Input stays in the recorder, behind its input trait; the library returns frames and damage hints only.
  - The guest starts with its QMP and VNC sockets in a private directory, `-nic none` and a disposable image with its
    layout pinned.
  - A guest's text console is captured like any other screen — the probe's first frame was VGA text mode — so Syntek
    OS installer demos need nothing extra at P6.
  - Every render logs the QEMU version, the guest image and the accelerator, so a re-render is comparable.
- **Recall targets:** which half lives where and why; what makes the TCG and KVM renders identical.
- **Build:** the QEMU capture backend in the capture-library repository and the QEMU input in the scripted-recorder
  repository (both created at the recorder's stage 2). Checked by a stage-1 tape driving a TCG guest and a KVM guest
  to identical timelines, `screendump` and RFB frames matching on a static screen, and no TCP listener while
  recording.
- **Efficiency lens:** the milestone's Budget — milliseconds per grab, frames per second and host RSS — measured and
  recorded.
- **Security lens:** the stage 4 spec's threat model covers the QMP, VNC and any libvirt socket, and the fixture that
  keeps personal data out of a public video.
- **Sources:** (to verify when the topic opens) the staging and capture-library ADRs; lessons 01–05's sources.
- **Done when:** both renders' timelines match, both repositories' gates pass (`cargo fmt --check`,
  `cargo clippy --all-targets -- -D warnings`, `cargo deny check`), and the Budget is recorded.
