# Mission — ui-05-package-manager-tui

**Started**: not yet · **Family**: ui · **Phase**: U2 · **Milestone**: not yet allocated

## Why

_Drafted from Sam's planning conversation of 27/09/2026 — confirm or rewrite in your own words at the first lesson._

Sam wants a clean, independent Syntek OS, and the plan he settled on gives it its own package manager, written in Rust
with signed repositories — with a package-manager TUI front-end among the custom tools. This topic builds that
front-end as a thin client of the os-07 library, so the package manager's rules live in one place and the TUI can only
show them clearly: what a transaction will do before it does it, whether the repository verified, and what cancelling
means at each step. It is the everyday face of Syntek OS's secure update story.

## Can do it when

- Sam can drive the package-manager library through its public API from a TUI, tested against a fake backend.
- Sam can build search, list and detail views that stay responsive over a full repository index, with latency measured.
- Sam can show a transaction's full plan and apply it only after explicit confirmation, with every verification failure
  blocking.
- Sam can show progress and cancel safely in each phase, and recover after an interrupted install in a VM guest.

## Parked for later

- Running the TUI unprivileged with a privileged helper — ui-07-system-tools-tui.
- A GUI package tool for the beginner profile — ui-09-gui-tools.
- Repository signing, mirrors and key rotation themselves — os-08-repositories-signing-and-updates.
