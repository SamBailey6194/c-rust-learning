# Mission — ui-02-ratatui-foundations

**Started**: not yet · **Family**: ui · **Phase**: U1 · **Milestone**: not yet allocated

## Why

_Drafted from Sam's planning conversation of 27/09/2026 — confirm or rewrite in your own words at the first lesson._

Syntek OS's own tools are to be written in Rust with ratatui, TUIs first, and friends and family may help build them.
Sam already has a little Rust; this topic turns it into the working knowledge every tool needs — a terminal set up and
restored safely, a render loop, layout, widgets, events and styling that works for everyone — by porting the tiny C
program from ui-01, so each ratatui call maps onto something he has already done by hand. It unlocks ui-03's
architecture and tests, and through them the file manager, package-manager front-end, installer and system tools.

## Can do it when

- Sam can add a dependency the safe way (`cargo deny check` before the first build) and start and restore a ratatui
  terminal, with the panic path proved.
- Sam can explain immediate-mode rendering and the double-buffer diff, and write the render loop.
- Sam can predict a layout's areas at any size and test them.
- Sam can render built-in and custom widgets and keep selection state across frames.
- Sam can route events through one keymap into a tested update function.
- The ratatui port of the tiny C program works in monochrome with `NO_COLOR` set and from the keyboard alone.

## Parked for later

- The Elm Architecture, background work and screen tests — ui-03-tui-architecture-and-testing.
- Async input with crossterm's `EventStream` and tokio — ui-03-tui-architecture-and-testing.
- Mouse support — not scheduled; add a lesson if a tool needs it.
