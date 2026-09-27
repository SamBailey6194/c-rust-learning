# Resources — ui-06-installer-tui

| Lesson | Primary source (pinned) | House guide | Code |
| --- | --- | --- | --- |
| 01 Guided flows as state machines | The Rust Book (Rust 1.92.0) chapter 6, <https://doc.rust-lang.org/1.92.0/book/ch06-00-enums.html> (to verify when the topic opens) | `code/docs/RUST-CODING-PRINCIPLES.md` — Section 3 Errors are values | the Syntek OS installer repository (created when this build starts) |
| 02 Choosing a disk safely | `man 8 lsblk`, `man 8 losetup` (util-linux 2.39.3); `man 1 qemu-img` (QEMU 8.2.2) (to verify) | — | the Syntek OS installer repository |
| 03 Choosing a profile | `project-management/src/07-OS-PROFILES/PROFILE-MATRIX.md` (to verify) | — | the Syntek OS installer repository |
| 04 Validating what the user types | `man 7 hostname` (Linux man-pages 6.7); `man 8 useradd` — CAVEATS (shadow-utils 4.13) (to verify) | `code/docs/TESTING.md` — Section 3 Test discipline | the Syntek OS installer repository |
| 05 Recovering from failure, and testing the installer in QEMU | `man 1 qemu-img` — snapshots (QEMU 8.2.2) (to verify) | — | the Syntek OS installer repository |
