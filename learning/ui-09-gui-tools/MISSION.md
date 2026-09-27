# Mission — ui-09-gui-tools

**Started**: not yet · **Family**: ui · **Phase**: U3 · **Milestone**: not yet allocated

## Why

_Drafted from Sam's planning conversation of 27/09/2026 — confirm or rewrite in your own words at the first lesson._

Sam's plan is Syntek OS tools as TUIs first and GUI versions later, built with help from friends and family. The
beginner profile is for people who may never open a terminal, so its settings and package tools need to be graphical.
Sam chose to write Syntek OS's products in Slint, in their own repositories; this topic teaches Slint's model, builds
one real beginner tool as another thin client of the libraries the TUIs already use, packages it for the desktops, and
closes the loop by watching friends and family use it.

## Can do it when

- Sam can map a GUI tool's screens onto existing library and helper calls, with no system logic in the GUI.
- Sam can build a Slint window whose state flows through bindings, with the markup/Rust boundary explained.
- A beginner-profile GUI tool completes its main task in a VM guest for someone who never uses a terminal.
- The tool installs with a valid desktop entry and icons, and appears in two desktop profiles' menus.
- Three moderated usability sessions, with consent, have produced ranked issues.

## Parked for later

- Choosing the Syntek OS GUI-tools repository's licence against Slint's options —
  tooling-05-licensing-and-collaboration lesson 05, then the Syntek OS GUI-tools repository itself.
- GUI versions of the installer and the file manager — only if usability testing shows the TUIs are not enough.
- The desktop environments themselves — os-15-desktop-editions.
