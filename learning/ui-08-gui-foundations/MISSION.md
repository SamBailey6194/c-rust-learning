# Mission — ui-08-gui-foundations

**Started**: not yet · **Family**: ui · **Phase**: U3 · **Milestone**: not yet allocated

## Why

_Drafted from Sam's planning conversation of 27/09/2026 — confirm or rewrite in your own words at the first lesson._

Sam is happy to use existing GUIs for Syntek OS's desktops, with GUI versions of his own tools to follow the TUIs. The
beginner profile in particular will need graphical tools, so the foundations have to be sound: what a Wayland client
really does, why a toolkit is chosen on licence and accessibility evidence rather than taste, how a first GTK
application is built in this GPL-2.0-only repository, and how it stays usable for people who rely on a screen reader
or a keyboard. The product tools themselves are written in Slint in their own repositories (ui-09); this topic is
where the GUI concepts are learned.

## Can do it when

- Sam can describe the Wayland object chain from display to toplevel and what a toolkit does on top of it.
- Sam can explain, from the sources, why the lessons use gtk4-rs and the products use Slint.
- A first gtk4-rs application runs under Wayland, its tests pass and `cargo deny check` passes with the documented
  exception.
- The application is themed, reads well in light and dark, and stays sharp at a fractional scale.
- The application's main task can be completed with Orca and the keyboard alone.

## Parked for later

- The graphics stack itself (DRM/KMS, Mesa, compositors) — os-15-desktop-editions; DRM/KMS capture from
  user space (learning-only) — kernel-10-drm-kms-capture.
- Slint's model and the product GUI tools — ui-09-gui-tools.
- Writing a Wayland client without a toolkit — ui-12-headless-wayland-capture-and-input.
