# Syllabus — ui-13-portal-screencast-and-pipewire

**Track**: ui · **Phase**: U2 · **Path**: Later · **Detail**: outline · **Prerequisites**: ui-12-headless-wayland-capture-and-input (all lessons — the recorder's stage order; taking this topic first is Sam's explicit choice, never a default); the scripted recorder's stage 2 `Done` (`project-management/src/08-DECISIONS/ADR-MS001-SCRIPTED-RECORDER-STAGED-LEARNING-PROJECT-27-09-2026.md`); ui-07-system-tools-tui lessons 02–03 (D-Bus with zbus; polkit and the consent model), with the lesson 01 they build on; ui-03-tui-architecture-and-testing lesson 03 (tokio tasks and an event stream); ui-04-file-manager-tui lesson 02 (tokio doing real I/O); os-15-desktop-editions lessons 01–03 (the graphics stack; seats and sessions; the GNOME and KDE desktops — reading)
**Status**: Planned · **Checked**: 27/09/2026 (sources re-verified by `/teach` step 3 before each lesson)

Stage 3b of the scripted demo recorder: the same tapes render on GNOME and KDE Wayland sessions, where a program
reaches the screen through the desktop's portal — xdg-desktop-portal's ScreenCast interface, which asks the user for
consent and then hands back a PipeWire stream. This topic teaches portals as a D-Bus API, a ScreenCast session and its
dialog, PipeWire streams read from shared memory, and the restore tokens that let one set-up run carry consent into
later renders so that no dialog is ever recorded; the RemoteDesktop portal is an optional input route, used only where
the compositor offers no better one. The backend lands in the capture-library repository, created at the recorder's
stage 2 (`project-management/src/08-DECISIONS/ADR-MS001-CAPTURE-LIBRARY-STANDALONE-27-09-2026.md`); any portal input
lands in the scripted-recorder repository. It is marked **Later**, sits outside U2's exit gate and is an outline until
U2 reaches it; it follows ui-12 by default and comes before the QEMU/KVM stage
(kernel-11-qemu-display-and-input-control). ui-07 teaches D-Bus and polkit on the LFS learning build; this topic uses
a stock GNOME or KDE Wayland guest instead — which desktop comes first is decided at the stage's first milestone —
and never Sam's desktop session, where `Start` would raise a real dialog about his real screen. The host
(GNOME on X11, xdg-desktop-portal 1.18.4, read 27/09/2026) predates the host registry an unsandboxed caller uses, so
the guest pins a portal of 1.20 or later. Points marked "to settle" wait for a `/research` note on the portal in the
guest (planned, before lessons 02, 04 and 06 are written in full); the guest images are not fetched yet (`GAPS.md` →
"Scripted recorder build dependencies not installed").

| # | Lesson | Size | Build | Lenses |
| --- | --- | --- | --- | --- |
| 01 | Portals as a D-Bus API: requests, responses and sessions | 1 sitting | yes — portal property probe | Security |
| 02 | A ScreenCast session and its consent dialog | 2–3 sittings | yes — ScreenCast session spike | Security, Safety |
| 03 | PipeWire streams: the portal's descriptor, formats, shared memory against DMA-BUF | 2–3 sittings | yes — one PipeWire frame | Efficiency |
| 04 | `persist_mode` and restore tokens: what survives, what revokes, why a set-up run | 1 sitting | yes — restore-token round trip | Security |
| 05 | The portal backend in the library | multi-session build | yes — portal backend | Efficiency, Security |
| 06 | RemoteDesktop keysyms and libei as recorder input (optional) | 2–3 sittings | yes — portal input, if needed | Security |

---

## 01 — Portals as a D-Bus API: requests, responses and sessions

- **Objective:** Sam can explain how a portal call works on D-Bus — the method call that returns a Request object path,
  the Response signal that carries the answer, and the Session object a long interaction lives on — and follow one
  with `busctl`.
- **Builds on:** ui-07 lesson 02 (D-Bus with zbus); ui-03 lesson 03 (tokio tasks and `select!`).
- **Key ideas:**
  - Portals are D-Bus services on the session bus (`org.freedesktop.portal.Desktop` at
    `/org/freedesktop/portal/desktop`); a desktop-specific backend — GNOME's or KDE's — does the work behind it.
  - A portal method returns at once with a Request object path; the real answer comes later as that Request's
    `Response` signal. The `handle_token` option makes the path predictable, so the caller can subscribe to the signal
    before calling and never miss the answer.
  - Session-based portals (ScreenCast, RemoteDesktop) create a Session object, named through `session_handle_token`,
    that holds state until it is closed.
  - The portal, not the caller, shows the user what is being asked: it is the trust boundary.
  - ashpd wraps the pattern in async Rust over zbus.
- **Recall targets:** why the answer comes as a signal and not a return value; what the handle token prevents; which
  side draws the dialog.
- **Build:** yes, outline (sketched in full when U2 reaches this topic) — in the guest, the ScreenCast portal's
  `version`, `AvailableSourceTypes` and `AvailableCursorModes` properties read with `busctl`, then from Rust with
  ashpd, as spike code in the capture-library repository; checked by the two agreeing.
- **Security lens:** a portal is a privilege boundary like ui-07's helper — the caller asks, the desktop decides, and
  the user is in the loop.
- **Sources:** (to verify when the topic opens) xdg-desktop-portal documentation, Request
  (<https://flatpak.github.io/xdg-desktop-portal/docs/doc-org.freedesktop.portal.Request.html>) and Session
  (<https://flatpak.github.io/xdg-desktop-portal/docs/doc-org.freedesktop.portal.Session.html>); ashpd 0.13.13
  (<https://docs.rs/ashpd/0.13.13/ashpd/>, MIT); zbus 5.19.0 (<https://docs.rs/zbus/5.19.0/zbus/>, MIT);
  `man 1 busctl` (systemd 255).
- **Done when:** Sam traces one call from method to Response signal in `busctl monitor` output and names every object
  path involved.

## 02 — A ScreenCast session and its consent dialog

- **Objective:** Sam can open a ScreenCast session in the guest — create, select sources, start — see its consent
  dialog, and name what each step asks for and returns.
- **Builds on:** lesson 01; ui-07 lesson 03 (the mechanism asks, the user or policy decides).
- **Key ideas:**
  - The flow is `CreateSession`, `SelectSources`, `Start`, then `OpenPipeWireRemote`; each of the first three answers
    through a Request's Response.
  - `SelectSources` says what may be shared: `types` is a bitmask (monitor 1, window 2, virtual 4) checked against
    `AvailableSourceTypes`, and `cursor_mode` against `AvailableCursorModes`. A session selects sources once only.
  - `Start` is where the desktop typically shows its dialog. Its Response carries the streams and, if persistence was
    asked for, a restore token (lesson 04). From interface version 6 a stream also carries a PipeWire serial, to target
    in place of a node ID, which can be reused.
  - `OpenPipeWireRemote` returns a file descriptor to a PipeWire connection that exposes only this session's
    screen-cast streams.
  - KDE's portal refuses screen casting in X11 sessions; GNOME 46.2 registers the portal on X11 and does not refuse it
    in source, but frames end to end there are to settle — one more reason the guest runs a Wayland session.
- **Recall targets:** the four calls in order and what each returns; what the source-type bitmask means; why a node ID
  is not a stable name.
- **Build:** yes, outline (sketched in full when U2 reaches this topic) — the stage's spike, part one: a ScreenCast
  session in the guest through ashpd, printing the stream it was granted, as spike code in the capture-library
  repository.
- **Security lens:** the dialog is the consent. Code that clicks it, hides it or races it is attacking the user; the
  recorder never does, and grants it once in a set-up run instead (lesson 04).
- **Safety:** a GNOME or KDE Wayland guest only, never Sam's desktop session.
- **Sources:** (to verify when the topic opens) the ScreenCast portal
  (<https://flatpak.github.io/xdg-desktop-portal/docs/doc-org.freedesktop.portal.ScreenCast.html>; interface XML
  `data/org.freedesktop.portal.ScreenCast.xml` in <https://github.com/flatpak/xdg-desktop-portal>, version 6, read
  27/09/2026); xdg-desktop-portal-kde `src/screencast.cpp` (<https://invent.kde.org/plasma/xdg-desktop-portal-kde>, the
  X11 refusal); xdg-desktop-portal-gnome (<https://gitlab.gnome.org/GNOME/xdg-desktop-portal-gnome>) and Mutter
  (<https://gitlab.gnome.org/GNOME/mutter>) at 46.2.
- **Done when:** the guest grants a stream after the dialog, and Sam explains each call's part in the flow.

## 03 — PipeWire streams: the portal's descriptor, formats, shared memory against DMA-BUF

- **Objective:** Sam can consume a screen-cast stream from the portal's PipeWire descriptor, read raw frames from shared
  memory, and explain why the library asks for shared memory rather than DMA-BUF.
- **Builds on:** lesson 02; ui-12 lesson 02 (a frame as shared memory); os-15 lesson 01 (reading).
- **Key ideas:**
  - The portal's descriptor goes to `pw_context_connect_fd`; a `pw_stream` is created for input and connected to the
    granted stream with automatic connection and mapped buffers.
  - Formats are negotiated: the consumer offers raw video formats (BGRx, RGBx and similar); `param_changed` reports
    the format the producer fixed, and that is parsed before any frame is read.
  - The `process` callback runs per buffer: dequeue, read the first data plane, queue it back — never hold a buffer
    across frames.
  - DMA-BUF needs a modifier negotiation. A consumer that offers no modifier makes the producer fall back to shared
    memory (MemFd or MemPtr), which a CPU-only consumer such as the library can map.
- **Recall targets:** where the portal's descriptor goes; what happens when the consumer offers no modifier; why a
  buffer goes back promptly.
- **Build:** yes, outline (sketched in full when U2 reaches this topic) — the spike, part two: one frame from the
  granted stream written as an image through the pipewire crate, in the capture-library repository; `cargo deny
  check` straight after adding pipewire and libspa.
- **Efficiency lens:** CPU per frame and frame latency in the guest, against ui-12's capture at the same geometry.
- **Sources:** (to verify when the topic opens) PipeWire documentation, "Tutorial - Part 5: Capturing Video Frames"
  (<https://docs.pipewire.org/page_tutorial5.html>), "Portal Access Control"
  (<https://docs.pipewire.org/page_portal.html>) and "DMA-BUF Sharing"
  (<https://docs.pipewire.org/devel/page_dma_buf.html>); pipewire 0.10.1 (<https://docs.rs/pipewire/0.10.1/pipewire/>)
  and libspa 0.10.1 (<https://docs.rs/libspa/0.10.1/libspa/>), both MIT.
- **Done when:** a frame from the stream matches the negotiated size and format, and Sam explains the shared-memory
  fallback from the DMA-BUF page.

## 04 — `persist_mode` and restore tokens: what survives, what revokes, why a set-up run

- **Objective:** Sam can make a set-up run grant a ScreenCast session once and every later render restore it without a
  dialog, and explain what survives, what revokes, and why a stale token must fail the render.
- **Builds on:** lessons 02–03.
- **Key ideas:**
  - `persist_mode`: 0 does not persist (the default), 1 persists while the application runs, 2 persists until
    explicitly revoked.
  - A restore token works once: each restore returns a new token, which the render stores for the next. A stale or
    unknown token is ignored and the dialog comes back.
  - So the first run is a set-up step, never recorded, and a render that would meet a dialog fails instead.
  - An unsandboxed caller has an application ID only if it registers one through `org.freedesktop.host.portal.Registry`
    — once, before any portal call, with an ID that matches a `.desktop` file. Whether restore tokens work for an
    unsandboxed caller without it is to settle.
  - A combined RemoteDesktop and ScreenCast session persists only through RemoteDesktop's `SelectDevices`.
- **Recall targets:** the three persist modes; why every render stores a new token; what a stale token does.
- **Build:** yes, outline (sketched in full when U2 reaches this topic) — the spike, part three: a set-up run that
  stores a token and two later runs that restore without a dialog, in the capture-library repository; checked by a
  third run with a deliberately stale token failing loudly.
- **Security lens:** a restore token is a standing grant to see the screen: it is stored like a credential (an
  owner-only file inside the fixture), never committed, and the user can revoke it (where each desktop shows its
  grants is to settle).
- **Sources:** (to verify when the topic opens) the ScreenCast portal, `SelectSources` options and `Start` results
  (<https://flatpak.github.io/xdg-desktop-portal/docs/doc-org.freedesktop.portal.ScreenCast.html>); the host Registry
  interface (`data/org.freedesktop.host.portal.Registry.xml` in <https://github.com/flatpak/xdg-desktop-portal>); the
  RemoteDesktop portal, `SelectDevices`
  (<https://flatpak.github.io/xdg-desktop-portal/docs/doc-org.freedesktop.portal.RemoteDesktop.html>).
- **Done when:** two renders in a row restore without a dialog, the stale-token run fails before recording, and Sam
  explains why the token changes every time.

## 05 — The portal backend in the library

- **Objective:** Sam can implement the capture trait over the ScreenCast portal and PipeWire in the capture library,
  so that stage 1's tapes render in a GNOME guest and a KDE guest with the same timelines as their X11 renders.
- **Builds on:** lessons 01–04; ui-12 lesson 04 (a backend behind the capture trait); ui-04 lesson 02 (tokio doing real
  I/O).
- **Key ideas:**
  - The portal side is async (ashpd over zbus) and PipeWire runs its own loop; the backend joins them without blocking
    either and hands frames across a bounded queue.
  - A damage-driven source delivers a frame only when something changed, so the backend holds the last frame and the
    recorder's virtual frame clock still runs at a constant rate.
  - The backend owns the session and closes it on stop and on error; a closed session or a revoked grant ends the render
    with a clear error, never a silent black video.
  - Frames and damage hints out, nothing else — the same boundary as every other backend.
- **Recall targets:** which loop the portal runs on and which PipeWire runs on; why the last frame is held; what ends a
  render.
- **Build:** yes, outline (sketched in full when U2 reaches this topic) — the stage's second milestone: the portal and
  PipeWire backend in the capture-library repository; `cargo fmt --check`, `cargo clippy --all-targets -- -D warnings`
  and `cargo deny check` clean; checked by rendering stage 1's tapes in both guests, with the dialog only in the set-up
  run.
- **Efficiency lens:** guest RAM, CPU per frame and frame latency, recorded as the stage's budget.
- **Security lens:** `cargo deny check` after adding ashpd, zbus, pipewire and libspa (all MIT on 27/09/2026 — to
  re-check at the pinned versions); restore tokens handled as in lesson 04.
- **Sources:** (to verify when the topic opens) ashpd (<https://docs.rs/ashpd/0.13.13/ashpd/>); pipewire
  (<https://docs.rs/pipewire/0.10.1/pipewire/>); PipeWire "Tutorial - Part 5: Capturing Video Frames"
  (<https://docs.pipewire.org/page_tutorial5.html>);
  `project-management/src/08-DECISIONS/ADR-MS001-CAPTURE-LIBRARY-STANDALONE-27-09-2026.md`.
- **Done when:** stage 1's tapes render in both guests with timelines equal to their X11 renders and no dialog in any
  recorded section, and the budget is recorded in the milestone.

## 06 — RemoteDesktop keysyms and libei as recorder input (optional)

- **Objective:** Sam can decide whether the recorder needs portal input in a GNOME or KDE guest at all and, if it does,
  send keys through the RemoteDesktop portal or through libei, and explain the trade-off.
- **Builds on:** lessons 01–05; ui-12 lesson 03 (a virtual keyboard and its keymap).
- **Key ideas:**
  - Only if useful: where the compositor offers a virtual-keyboard protocol, ui-12's input backend is enough. Whether
    GNOME and KDE offer one is to settle.
  - RemoteDesktop (its documentation describes version 2) runs a session like ScreenCast, with `SelectDevices`
    choosing keyboard and pointer.
  - `NotifyKeyboardKeysym` takes an X keysym and a pressed or released state — unambiguous for keyboard-first tapes.
    The code space `NotifyKeyboardKeycode` expects is not stated and is to settle.
  - `ConnectToEIS` (version 2) hands back a libei file descriptor, the route the portal documentation recommends; once
    it is used, every `Notify*` call errors, so the two routes do not mix.
  - Input only, never input capture: captions come from the tape.
- **Recall targets:** when the recorder needs this at all; a keysym against a keycode; what `ConnectToEIS` rules out.
- **Build:** yes, outline, optional (sketched in full when U2 reaches this topic) — a RemoteDesktop input backend in
  the scripted-recorder repository, built only if the first key idea says it is needed; checked by a tape typing `"`
  and `@` correctly in the guest.
- **Security lens:** a RemoteDesktop grant is control of the session: it persists only as far as asked, and never
  outside the guest.
- **Sources:** (to verify when the topic opens) the RemoteDesktop portal
  (<https://flatpak.github.io/xdg-desktop-portal/docs/doc-org.freedesktop.portal.RemoteDesktop.html>); libei
  (<https://libinput.pages.freedesktop.org/libei/>); reis 0.7.1 (<https://docs.rs/reis/0.7.1/reis/>, MIT).
- **Done when:** Sam states from the sources whether the guest needs portal input and, if the backend is built, a tape
  types correctly through it.
