# Resources — os-07-package-manager

| Lesson | Primary source (pinned) | House guide | Code |
| --- | --- | --- | --- |
| 01 What pacman, apk and XBPS keep | `pacman(8)` 7.1.0, <https://man.archlinux.org/man/pacman.8.en>; XBPS README, <https://github.com/void-linux/xbps>; Alpine "Alpine Package Keeper", <https://wiki.alpinelinux.org/wiki/Alpine_Package_Keeper> | — | — |
| 02 Designing a package format | Alpine "Apk spec", <https://wiki.alpinelinux.org/wiki/Apk_spec>; `tar` crate 0.4.46, <https://docs.rs/tar/latest/tar/> | `code/docs/RUST-CODING-PRINCIPLES.md` — Section 3 | `code/src/rust/crates/msNNN_pkg_format/` (planned) |
| 03 Dependency resolution | `PKGBUILD(5)`, <https://man.archlinux.org/man/PKGBUILD.5.en>; libsolv, <https://github.com/openSUSE/libsolv>; proptest 1.11.0, <https://docs.rs/proptest/latest/proptest/> | `code/docs/TESTING.md` — Sections 2–3 | `code/src/rust/crates/msNNN_depsolve/` (planned) |
| 04 Safe archive extraction | `man 2 openat2`, `man 7 path_resolution`, `man 7 symlink` (man-pages 6.7); `tar` crate "Security", <https://docs.rs/tar/latest/tar/> | `project-management/docs/SAFETY-GUIDE.md` | `code/src/rust/crates/msNNN_safe_extract/` (planned) |
| 05 Crash-safe file updates | `man 2 rename`, `man 2 fsync`, `man 2 open` (man-pages 6.7); Rust `std::fs::File`, <https://doc.rust-lang.org/std/fs/struct.File.html> | `code/docs/RUST-CODING-PRINCIPLES.md` — Section 3 | `code/src/rust/crates/msNNN_atomic_write/` (planned) |
| 06 Transactions, atomic upgrade and rollback | XBPS README, <https://github.com/void-linux/xbps>; NixOS Manual 26.05, <https://nixos.org/manual/nixos/stable/> | — | the Syntek OS package-manager repository (created when this build starts) |
| 07 A library crate and a thin CLI | The Rust Book, "Separating Concerns in Binary Projects", <https://doc.rust-lang.org/book/ch12-03-improving-error-handling-and-modularity.html> | `code/docs/RUST-CODING-PRINCIPLES.md` — Section 5 | the Syntek OS package-manager repository |
| 08 Hooks, triggers and the file database | `alpm-hooks(5)`, <https://man.archlinux.org/man/alpm-hooks.5.en>; `pacman(8)` (`-Qo`, `-Qk`) | — | the Syntek OS package-manager repository |
