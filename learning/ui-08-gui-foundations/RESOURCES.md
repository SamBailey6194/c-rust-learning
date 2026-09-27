# Resources — ui-08-gui-foundations

| Lesson | Primary source (pinned) | House guide | Code |
| --- | --- | --- | --- |
| 01 Wayland from a client's point of view | "Wayland Protocol and Model of Operation", <https://wayland.freedesktop.org/docs/html/ch04.html>; core protocol, <https://wayland.freedesktop.org/docs/html/apa.html>; xdg-shell v7 via <https://wayland.app/protocols/xdg-shell> (to verify when the topic opens) | — | — |
| 02 Choosing a toolkit: licences, accessibility and Wayland | `project-management/src/08-DECISIONS/ADR-MS001-GUI-TOOLKIT-GTK4-27-09-2026.md`; <https://docs.gtk.org/gtk4/> (LGPL-2.1-or-later); iced issue 552, <https://github.com/iced-rs/iced/issues/552>; Slint v1.18.1 `LICENSE.md`, <https://github.com/slint-ui/slint/blob/v1.18.1/LICENSE.md> (to verify) | `code/src/rust/deny.toml` | — |
| 03 A first gtk4-rs application | gtk4-rs book, <https://gtk-rs.org/gtk4-rs/stable/latest/book/>; gtk4 0.11.5, <https://docs.rs/gtk4/0.11.5/gtk4/> (to verify) | `code/docs/TESTING.md` — Section 2 Rust | `code/src/rust/crates/msNNN_gtk_first_app/` (planned; Blocked — GTK 4 development files) |
| 04 Theming and HiDPI | GTK 4 "CSS in GTK", <https://docs.gtk.org/gtk4/css-overview.html>; fractional-scale-v1 via <https://wayland.app/protocols/fractional-scale-v1> (to verify) | — | `code/src/rust/crates/msNNN_gtk_first_app/` (planned; Blocked) |
| 05 Accessibility with AT-SPI | GTK 4 "GTK Accessibility", <https://docs.gtk.org/gtk4/section-accessibility.html>; gtk4-rs book "Accessibility", <https://gtk-rs.org/gtk4-rs/stable/latest/book/accessibility.html>; Orca help, <https://help.gnome.org/users/orca/stable/> (to verify) | — | `code/src/rust/crates/msNNN_gtk_first_app/` (planned; Blocked) |
