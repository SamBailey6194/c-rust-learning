# Resources — ui-05-package-manager-tui

| Lesson | Primary source (pinned) | House guide | Code |
| --- | --- | --- | --- |
| 01 Consuming the package-manager library | The Rust Book (Rust 1.92.0) 10.2, <https://doc.rust-lang.org/1.92.0/book/ch10-02-traits.html>; ratatui 0.30.2 `TestBackend`, <https://docs.rs/ratatui/0.30.2/ratatui/backend/struct.TestBackend.html> | `code/docs/RUST-CODING-PRINCIPLES.md` — Section 5 Crate and module layout | the Syntek OS package-manager repository (created when that build starts) |
| 02 Search, list and detail views | ratatui 0.30.2 `Table`, <https://docs.rs/ratatui/0.30.2/ratatui/widgets/struct.Table.html>; pacman(8), <https://man.archlinux.org/man/pacman.8> (study only) | `code/docs/TESTING.md` — Section 3 Test discipline | the Syntek OS package-manager repository |
| 03 Transactions with a full preview and confirmation | The Update Framework specification 1.0.36, <https://theupdateframework.github.io/specification/latest/>; WCAG 2.2 SC 1.4.1, <https://www.w3.org/TR/WCAG22/> | — | the Syntek OS package-manager repository |
| 04 Progress and safe cancellation | tokio-util 0.7.19 `CancellationToken`, <https://docs.rs/tokio-util/0.7.19/tokio_util/sync/struct.CancellationToken.html>; `man 7 signal` (Linux man-pages 6.7); `man 1 qemu-img` (QEMU 8.2.2) | `code/docs/DEBUGGING.md` — Section 5 Rust | the Syntek OS package-manager repository |
