# Mission — ui-11-consent-first-remote-help

**Started**: not yet · **Family**: ui · **Phase**: U2 · **Milestone**: not yet allocated

## Why

_Drafted from Sam's answers in the networking and licensing round of 27/09/2026 — confirm or rewrite in your own words
at the first lesson._

Sam wants to be able to help family members with their computers at a distance. He decided to give that help first
with existing tools, in the lab and then in real sessions with recorded consent, and also to build a remote-help tool of
his own in Rust. Software
that lets one person see and type into another's terminal is the same kind of software an intruder uses to keep
control of a machine, so the tool is built consent-first by construction: the helped person starts every session,
sees it the whole time, grants control separately, keeps the log and can end it with one key, and nothing stays behind
afterwards. Building it brings together mutual TLS on his own CA, pseudoterminals, sandboxing and a TUI that cannot be
spoofed — and the law is researched before the lessons that depend on it are written.

## Can do it when

- Sam can state the tool's requirements, whose consent each kind of access needs and the abuse cases it must defeat,
  citing the research notes rather than memory.
- The session state machine's tests prove there is no control without a grant, and that every transition is the helped
  side's decision.
- Two lab VM guests complete a mutual-TLS handshake on the private CA, and a foreign, expired or revoked identity is
  refused.
- The helped person sees a consent screen and an indicator the helper cannot hide, and the shared terminal runs as the
  helped user with no new privileges.
- A session's hash-chained log reconstructs it on the helped side, and a before-and-after diff in a VM guest shows
  nothing left behind.
- Every abuse case fails and is logged between two VM guests, and the first real session runs under the graduation
  path with a written consent record.

## Parked for later

- Graphical desktop sharing (xdg-desktop-portal ScreenCast and RemoteDesktop) — `DEFERRED.md` (U3).
- Devices that do not run Linux — `project-management/src/01-ROADMAP/MAP-UI.md` → fog of war.
- Helping someone before this tool exists — `os-18-own-network-operations` lesson 10, with existing tools.
- Designing and running the private CA — `sec-05-applied-cryptography` lessons 08–13.
- Unattended access (an always-on agent) — never: a non-goal of
  `project-management/src/08-DECISIONS/ADR-MS001-REMOTE-HELP-TOOL-CONSENT-FIRST-27-09-2026.md`.
