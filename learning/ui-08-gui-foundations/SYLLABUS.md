# Syllabus — ui-08-gui-foundations

**Track**: ui · **Phase**: U3 · **Path**: Later · **Detail**: outline · **Prerequisites**: ui-03-tui-architecture-and-testing (all lessons); tooling-05-licensing-and-collaboration lesson 02 (licence compatibility with GPL-2.0-only, checked by `cargo deny`); os-15-desktop-editions lesson 01 (the graphics stack — reading, for lesson 01)
**Status**: Planned · **Checked**: 27/09/2026 (sources re-verified by `/teach` step 3 before each lesson)

Syntek OS reuses existing desktops, and its own tools come to the GUI after the TUI. This topic lays the GUI
foundations: what a Wayland client does underneath any toolkit, how the toolkit was chosen, a first application,
theming and HiDPI, and accessibility as a lesson of its own. The lessons here use gtk4-rs
(`project-management/src/08-DECISIONS/ADR-MS001-GUI-TOOLKIT-GTK4-27-09-2026.md`, accepted for learning, with the
build-dependency licence exception it records); Syntek OS products are written in Slint in their own repositories,
which ui-09 introduces. It is marked **Later** and is an outline until U3 opens, when the Build sketches and sources
are filled in and re-verified. Lesson crates land under `code/src/rust/crates/` here. On 27/09/2026 the host has the
GTK 4.14.5 runtime but not its development files (`pkg-config --modversion gtk4` finds no `gtk4.pc`), so every gtk4-rs
build is **Blocked** until they are installed and CI's runner installs them too (`GAPS.md` → "GTK 4 development files
not installed").

| # | Lesson | Size | Build | Lenses |
| --- | --- | --- | --- | --- |
| 01 | Wayland from a client's point of view | 1 sitting | no | — |
| 02 | Choosing a toolkit: licences, accessibility and Wayland | 1 sitting | no | Security |
| 03 | A first gtk4-rs application | 2–3 sittings | yes — first GTK app | Security |
| 04 | Theming and HiDPI | 1 sitting | yes — themed app | — |
| 05 | Accessibility with AT-SPI | 2–3 sittings | yes — accessible app | — |

---

## 01 — Wayland from a client's point of view

- **Objective:** Sam can describe what a Wayland client does to put a window on screen — the objects it binds, the
  requests it sends and the events it answers — and list what a toolkit does for him.
- **Builds on:** os-15 lesson 01 (the graphics stack: DRM/KMS, Mesa, Wayland against X11); ui-01 (a program talking a
  protocol to a display).
- **Key ideas:**
  - Wayland is an asynchronous, object-oriented protocol: requests go from client to compositor, events come back,
    every message targets an object by ID.
  - The client connects to `wl_display`, discovers globals through `wl_registry`, creates a `wl_surface` from
    `wl_compositor` and fills it with a `wl_buffer` (for example from `wl_shm`).
  - A surface becomes a window only with a role: `xdg_wm_base` → `xdg_surface` → `xdg_toplevel`; the client must answer
    the compositor's ping with a pong or be treated as unresponsive.
  - Window management belongs to the compositor; each desktop brings its own compositor rather than one shared server.
  - What a toolkit hides: the event loop, buffer management, input, scaling, decorations and accessibility.
- **Recall targets:** the chain from display to toplevel; why a surface needs a role; what the ping and pong are
  for.
- **Build:** none — a reading lesson; a diagram of the object chain in the note.
- **Sources:** (to verify when the topic opens) the Wayland project's overview (<https://wayland.freedesktop.org/>);
  Wayland documentation, "Wayland Protocol and Model of Operation"
  (<https://wayland.freedesktop.org/docs/html/ch04.html>) and the core protocol specification
  (<https://wayland.freedesktop.org/docs/html/apa.html>); xdg-shell, version 7 — the wayland-protocols repository on
  gitlab.freedesktop.org answers automated requests with a bot check, so checked via its rendering at
  <https://wayland.app/protocols/xdg-shell>; The Wayland Book (<https://wayland-book.com/>).
- **Done when:** Sam draws the object chain and names five things the toolkit will do for him.

## 02 — Choosing a toolkit: licences, accessibility and Wayland

- **Objective:** Sam can explain why the lessons use gtk4-rs and the products use Slint, weighing licence
  compatibility, accessibility and Wayland support from primary evidence.
- **Builds on:** tooling-05 lesson 02 (licence compatibility, checked by `cargo deny`); lesson 01; ui-02 lesson 06
  (accessibility).
- **Key ideas:**
  - Licences are per repository: this one is GPL-2.0-only, so every linked crate must pass `deny.toml` or enter by a
    documented exception.
  - gtk4-rs: MIT bindings over GTK, which is LGPL-2.1-or-later; AT-SPI accessibility is built into GTK; one
    build-time dependency needs the exception the GUI-toolkit ADR records.
  - iced: MIT itself, but its Linux dependency graph reaches Apache-2.0-only crates such as winit, and it has no
    screen-reader support yet (iced issue 552, open on 27/09/2026).
  - Slint: offered under GPL-3.0-only, a royalty-free licence or a commercial licence — none of them compatible with
    this repository's GPL-2.0-only — so Slint is studied here and built in product repositories that choose their own
    licence (ui-09).
- **Recall targets:** the licence reason each option passes or fails here; which option has screen-reader support
  today.
- **Build:** none — Sam reads the GUI-toolkit ADR and re-runs `cargo deny check` on a scratch branch to see the
  evidence for himself.
- **Security lens:** a toolkit brings a large dependency graph with it; the graph is read before it is added.
- **Sources:** (to verify when the topic opens)
  `project-management/src/08-DECISIONS/ADR-MS001-GUI-TOOLKIT-GTK4-27-09-2026.md`; GTK 4 documentation
  (<https://docs.gtk.org/gtk4/>, licence LGPL-2.1-or-later, documentation build 4.23.4); gtk4 0.11.5 (MIT)
  (<https://docs.rs/gtk4/0.11.5/gtk4/>); iced issue 552, "Implement accessibility support"
  (<https://github.com/iced-rs/iced/issues/552>); Slint v1.18.1 `LICENSE.md`
  (<https://github.com/slint-ui/slint/blob/v1.18.1/LICENSE.md>).
- **Done when:** Sam states each option's licence and accessibility position from the sources and reproduces the
  `cargo deny` result.

## 03 — A first gtk4-rs application

- **Objective:** Sam can build a small gtk4-rs application — an `Application`, a window, widgets and signal handlers —
  that passes this repository's gates.
- **Builds on:** lessons 01–02; ui-03 lesson 01 (the same model/update split, applied to a retained-mode toolkit).
- **Key ideas:**
  - GTK is retained mode: widgets are objects that live between frames, the opposite of ratatui's immediate mode.
  - An `Application` owns the main loop; signals connect widget events to Rust closures.
  - Pick the gtk4 crate's `v4_xx` feature from `pkg-config --modversion gtk4`, so the code uses only API the installed
    GTK has.
  - Keep logic in a library module that tests can reach without a display (`code/docs/TESTING.md` Section 2).
- **Recall targets:** retained versus immediate mode, with a TUI and a GUI example of each; where logic lives so that
  tests do not need a display.
- **Build:** yes, outline (sketched in full when U3 opens) — a small window with a list and a button, in
  `code/src/rust/crates/msNNN_gtk_first_app/` (planned). **Blocked**: the GTK 4 development files are not installed
  (`GAPS.md` → "GTK 4 development files not installed"); CI also needs them, and `deny.toml` needs the per-crate
  exception the ADR names.
- **Security lens:** the build-dependency exception enters `deny.toml` with its reason and the ADR's path, in the
  milestone that first needs it.
- **Sources:** (to verify when the topic opens) gtk4-rs book (<https://gtk-rs.org/gtk4-rs/stable/latest/book/>) —
  "Installation on Linux", "Project Setup", "Hello World"; gtk4 0.11.5 (<https://docs.rs/gtk4/0.11.5/gtk4/>, MSRV
  1.92).
- **Done when:** the application runs under Wayland on the host desktop, its tests pass, and `cargo deny check` passes
  with the documented exception.

## 04 — Theming and HiDPI

- **Objective:** Sam can style a GTK application with CSS, follow the user's light or dark preference, and render
  sharply at integer and fractional scales.
- **Builds on:** lesson 03; ui-02 lesson 06 (never colour alone).
- **Key ideas:**
  - GTK styles widgets with CSS; an application adds its own provider rather than fighting the theme.
  - Respect the user's colour scheme and contrast settings instead of hard-coding colours.
  - Wayland scaling: an integer buffer scale on `wl_surface`, and the fractional-scale protocol's preferred scale; which
    GTK release handles each is to verify when U3 opens. Icons and images need sources that scale.
- **Recall targets:** where an application's CSS sits relative to the theme; what changes on a 1.5x display.
- **Build:** yes, outline (sketched in full when U3 opens) — the lesson 03 application with a CSS provider and a dark
  variant, checked by eye at scale 1 and at a fractional scale. **Blocked** with lesson 03 (`GAPS.md` → "GTK 4
  development files not installed").
- **Sources:** (to verify when the topic opens) GTK 4 "CSS in GTK" (<https://docs.gtk.org/gtk4/css-overview.html>);
  gtk4-rs book, "CSS" (<https://gtk-rs.org/gtk4-rs/stable/latest/book/css.html>); fractional-scale-v1, checked via
  <https://wayland.app/protocols/fractional-scale-v1>; `wl_surface::set_buffer_scale` in the core protocol
  (<https://wayland.freedesktop.org/docs/html/apa.html>).
- **Done when:** the themed application reads well in light and dark and stays sharp at a fractional scale.

## 05 — Accessibility with AT-SPI

- **Objective:** Sam can make a GTK application usable with a screen reader and from the keyboard, and check it with
  Orca.
- **Builds on:** lessons 03–04; ui-02 lesson 06.
- **Key ideas:**
  - On Linux, GTK exposes its accessibility tree over AT-SPI; assistive technology such as the Orca screen reader reads
    it.
  - Each widget has a fixed accessible role; its state and properties describe it — built-in widgets get this right,
    custom ones must set it.
  - Icon-only buttons need an accessible label; relations tie labels to the fields they describe.
  - Keyboard: every action reachable, focus order logical, focus always visible.
- **Recall targets:** what a role is and why it cannot change; which widgets need extra work.
- **Build:** yes, outline (sketched in full when U3 opens) — the lesson 03 application with labels and relations set,
  tested by completing its main task with Orca and the keyboard only. **Blocked** with lesson 03 (`GAPS.md` → "GTK 4
  development files not installed").
- **Sources:** (to verify when the topic opens) GTK 4 "GTK Accessibility"
  (<https://docs.gtk.org/gtk4/section-accessibility.html>) — roles, attributes and the AT-SPI backend; gtk4-rs book,
  "Accessibility" (<https://gtk-rs.org/gtk4-rs/stable/latest/book/accessibility.html>); Orca help
  (<https://help.gnome.org/users/orca/stable/>).
- **Done when:** the main task completes with Orca speaking every control and no mouse used.
