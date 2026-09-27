# Mission — os-07-package-manager

**Started**: not yet · **Family**: os · **Phase**: P6 · **Milestone**: not yet allocated

## Why

_Drafted from Sam's planning conversation of 27/09/2026 — confirm or rewrite in your own words at the first lesson._

A clean, independent Syntek OS needs its own package format and manager — nothing borrowed from another
distribution's base — and Sam wants its tools written in Rust, TUI first, with friends and family able to build on
them. The package-manager TUI they may help with is only as good as the library under it. This topic is where Sam
learns what pacman, apk and XBPS each solved, writes the parts that must never go wrong (hostile archives, crashes
mid-update, half-finished upgrades), and designs the library API that the TUI, and later a GUI, will call.

## Can do it when

- Sam can explain what a package manager records and which upgrade problem each record solves.
- Sam's package reader and writer round-trip a staged tree and reject malformed input (`cargo test`, `cargo clippy`).
- Sam's resolver handles versions, conflicts and virtual packages, and passes its property tests.
- Sam's extractor refuses every archive in a hostile corpus and writes nothing outside its destination.
- Sam's atomic-write helper leaves the old or the new contents after a failure at any step.
- Sam's transaction engine leaves the system all-old or all-new under injected failures, and rolls back an upgrade.
- Sam's package manager is a library plus a thin CLI with install, remove and query, and a documented API for ui-05.
- Sam's hooks and file database pass their tests, including an integrity check that finds a modified file.

## Parked for later

- Repository metadata, signing and the secure update flow — os-08-repositories-signing-and-updates.
- The package-manager TUI — ui-05-package-manager-tui.
- Fuzzing the parsers — sec-03-fuzzing (`GAPS.md` → "Fuzzing Rust needs a nightly toolchain").
- Attacking the package manager as a test case — sec-14 (testing Syntek OS).
- Filesystem snapshots for rollback (Btrfs) — os-13-nas-edition.
