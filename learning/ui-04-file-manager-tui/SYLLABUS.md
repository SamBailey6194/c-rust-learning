# Syllabus — ui-04-file-manager-tui

**Track**: ui · **Phase**: U2 · **Path**: Core · **Detail**: full · **Prerequisites**: ui-03-tui-architecture-and-testing (all lessons); sec-01-principles-threat-modelling-and-law (attack surface, trust boundaries and threat models)
**Status**: Planned · **Checked**: 27/09/2026 (sources re-verified by `/teach` step 3 before each lesson)

The file manager is the first U2 build and the natural first project for friends and family, because it depends on
nothing in the OS track. It starts by reading how Yazi, a fast Rust file manager, is built, then teaches the pieces a
file manager is made of: listing huge directories without blocking, previewing files an attacker may control without
harm, a trash that follows the FreeDesktop specification, and long operations with progress, cancellation and undo.
Lessons 02–05 are small concept crates in this repository; lesson 06 assembles them into the tool itself — a core
library and a thin ratatui front-end — in the Syntek OS file-manager repository (created when this build starts),
because a substantial build, and a tool that takes outside contributions, lives in its own repository
(`.claude/CLAUDE.md` Section 5; `.claude/skills/teach/FAMILIES.md` → ui). Sam builds the core library and each
lesson's concept; contributors extend it after the move.

| # | Lesson | Size | Build | Lenses |
| --- | --- | --- | --- | --- |
| 01 | Reading Yazi: how a fast file manager is built | 1 sitting | no | Efficiency |
| 02 | Listing directories without blocking, even huge ones | 2–3 sittings | yes — dir_listing | Efficiency |
| 03 | Safe previews of untrusted files | 2–3 sittings | yes — safe_preview | Security |
| 04 | A trash that follows the FreeDesktop specification | 2–3 sittings | yes — trash | Safety |
| 05 | Long operations: progress, cancellation and undo | 2–3 sittings | yes — undo_log | Efficiency, Safety |
| 06 | From exercises to a tool others can build on | multi-session build | yes — the file manager | Security |

---

## 01 — Reading Yazi: how a fast file manager is built

- **Objective:** Sam can describe Yazi's architecture — non-blocking async I/O, prioritised task scheduling, chunked
  loading, discardable previews and a workspace split by concern — and name which ideas his own file manager borrows.
- **Builds on:** ui-03 lessons 02–03 and 06.
- **Key ideas:**
  - Every slow operation is a task; nothing slow runs on the render path.
  - Large directories load in chunks, so the first entries appear before the last are read.
  - Previews are discardable: when the selection moves on, the stale task is aborted rather than finished.
  - Small urgent tasks and large slow ones are scheduled separately, with priorities and a bounded number of workers —
    which also stops a burst of work exhausting file handles.
  - The workspace is split into crates by concern (filesystem, core, scheduler, TUI and more) on top of ratatui's core
    and widget crates — a library core kept apart from the interface.
- **Recall targets:** three techniques that keep Yazi responsive, and the problem each solves.
- **Build:** none — a reading note mapping Yazi's crates to the pieces lessons 02–05 build.
- **Efficiency lens:** note what Yazi's authors chose to measure for large directories (100,000 files); lesson 02
  repeats that measurement on Sam's own code.
- **Sources:**
  - Yazi v26.9.1 (MIT), README and workspace `Cargo.toml` (<https://github.com/sxyazi/yazi/tree/v26.9.1>).
  - "Why is Yazi fast?", Yazi blog, 29/10/2023 (<https://yazi-rs.github.io/blog/why-is-yazi-fast>, linked from the
    v26.9.1 README).
- **Done when:** Sam explains chunked loading and discardable tasks unaided and has a written crate map.

## 02 — Listing directories without blocking, even huge ones

- **Objective:** Sam can list a directory of 100,000 entries while the UI stays responsive, showing the first entries
  quickly and the rest in chunks.
- **Builds on:** lesson 01; ui-03 lessons 02–03 and 06.
- **Key ideas:**
  - `read_dir` returns entries in no guaranteed order, and the order can change between calls — sort explicitly.
  - Underneath, `getdents64` returns several entries per call; each entry's metadata is a further `lstat`/`statx`
    call — the measurement below shows how much of the time those calls take.
  - `tokio::fs` runs blocking calls on the `spawn_blocking` pool, so many entries per task beats one task per entry.
  - Chunks go to the UI as messages; a listing the user has navigated away from is cancelled.
  - File names are bytes, not UTF-8 (`OsStr`): sort and compare them without assuming they decode.
- **Recall targets:** where a listing's time goes, from Sam's own measurement; why tokio's file system calls use a
  thread pool; where a listing's order comes from.
- **Build:** yes — a crate that lists a directory in chunks over a channel; `code/src/rust/crates/msNNN_dir_listing/`
  (planned). A test creates a temporary directory of N files and checks that every entry arrives exactly once and in
  sorted order; `cargo test` and `cargo clippy`.
- **Efficiency lens:** time to first chunk and time to completion for 100,000 generated files, and system calls
  counted with `strace -c -f`, whole-list against chunked — budget against measured with llm-06 lesson 01's method.
- **Sources:**
  - `man 2 getdents`, `man 2 statx`, `man 2 stat` (Linux man-pages 6.7).
  - Rust 1.92.0 `std::fs::read_dir` (<https://doc.rust-lang.org/1.92.0/std/fs/fn.read_dir.html>) and
    `std::ffi::OsStr` (<https://doc.rust-lang.org/1.92.0/std/ffi/struct.OsStr.html>).
  - tokio 1.53.1 `fs` module (<https://docs.rs/tokio/1.53.1/tokio/fs/index.html>).
- **Done when:** the tests pass and the measurements for 100,000 files are in the journal.

## 03 — Safe previews of untrusted files

- **Objective:** Sam can preview a file whose name and contents an attacker controls without executing it, hanging,
  exhausting memory, following it somewhere else, or letting its bytes drive the terminal.
- **Builds on:** sec-01 (trust boundaries and threat models, applied here); ui-01 lesson 02 (escape sequences);
  lesson 02.
- **Key ideas:**
  - Every file in a directory is untrusted input; the trust boundary sits where the file manager reads it.
  - A POSIX file name may contain any byte except `/` and NUL — escape, newline and invalid UTF-8 included — so names
    are neutralised before drawing (CWE-150; ui-01 lesson 02).
  - Read a bounded prefix, and decide the type from `lstat` and the content's leading bytes, not from the extension.
  - Special files: opening a FIFO blocks until a writer appears, and a device can stream forever — check the type
    first, and open without blocking.
  - Symbolic links: `O_NOFOLLOW` on the final component, so a preview does not wander through a link.
  - External previewers (images, PDFs) are programs parsing hostile input: a timeout now, and sec-04's sandbox later.
- **Recall targets:** three ways a naive preview hangs; which bytes must never reach the terminal; why typing by
  extension is wrong.
- **Build:** yes — a crate with (a) a function that turns an `OsStr` file name into display text with control
  characters made visible, and (b) a bounded preview reader that refuses FIFOs and devices and does not follow a
  final symlink; `code/src/rust/crates/msNNN_safe_preview/` (planned). Tests cover hostile names (escape sequences,
  newlines, invalid UTF-8) and a FIFO and a symlink created in a temporary directory; a property test with proptest
  (licence `MIT OR Apache-2.0`, admitted on its MIT side) checks that no output of the name function contains a
  control byte.
- **Security lens:** write the preview pane's threat model in the milestone's `## Threat model` — assets (the
  terminal, the user's session), threats (escape injection, a hang or memory exhaustion, link redirection) and the
  mitigations above.
- **Sources:**
  - POSIX.1-2024, Base Definitions 3.146 "Filename"
    (<https://pubs.opengroup.org/onlinepubs/9799919799/basedefs/V1_chap03.html>).
  - CWE-150 (4.20) (<https://cwe.mitre.org/data/definitions/150.html>).
  - `man 7 fifo`, `man 2 open` (`O_NOFOLLOW`, `O_NONBLOCK`), `man 2 stat` (Linux man-pages 6.7).
  - Rust 1.92.0 `Path::display` (lossy conversion) (<https://doc.rust-lang.org/1.92.0/std/path/struct.Path.html>).
- **Done when:** every hostile-name and special-file test passes and Sam states the pane's threat model in three lines.

## 04 — A trash that follows the FreeDesktop specification

- **Objective:** Sam can move files to the trash exactly as the FreeDesktop Trash specification requires, list and
  restore them, and handle a file on another filesystem.
- **Builds on:** lessons 02–03; P2 file I/O.
- **Key ideas:**
  - The home trash lives under `$XDG_DATA_HOME/Trash`; other mounts use `$topdir/.Trash/$uid` or `$topdir/.Trash-$uid`,
    with the checks the specification lists.
  - A trash directory holds `files/` and `info/`; each `.trashinfo` records `Path` and `DeletionDate`.
  - The info file is created first, atomically, with `O_EXCL` — so two processes trashing the same name get different
    entries.
  - `rename(2)` is atomic within one filesystem but fails with `EXDEV` across mounts; `renameat2` with
    `RENAME_NOREPLACE` never overwrites an existing name.
  - Other file managers read the same trash, so following the specification is what makes it interoperable.
- **Recall targets:** what `files/` and `info/` each hold; why the info file comes first; what `EXDEV` means and the
  two ways to handle it.
- **Build:** yes — trash, list and restore for the home trash in `code/src/rust/crates/msNNN_trash/` (planned). The
  trash root is a parameter, so every test points it at a temporary directory; tests cover a name collision, a
  restore to a path that now exists, and a malformed `.trashinfo`.
- **Safety:** tests and manual runs only touch temporary directories they create; no delete or trash operation is
  pointed at `$HOME` while learning.
- **Sources:**
  - FreeDesktop Trash Specification 1.0 (<https://specifications.freedesktop.org/trash/latest/>) — trash directories,
    the contents of a trash directory, and the info file.
  - `man 2 rename` (`EXDEV`, `RENAME_NOREPLACE`) (Linux man-pages 6.7); Rust 1.92.0 `std::fs::rename`
    (<https://doc.rust-lang.org/1.92.0/std/fs/fn.rename.html>).
- **Done when:** the tests pass and a file Sam's code trashes appears correctly in another file manager's trash view
  (checked by hand on a scratch file).

## 05 — Long operations: progress, cancellation and undo

- **Objective:** Sam can run a copy or move of many files as a cancellable background task with honest progress, and
  undo recent operations from a log.
- **Builds on:** lessons 01–04; ui-03 lessons 02–03.
- **Key ideas:**
  - Plan, then execute: gather the file list and sizes first so progress is honest (Yazi's small-task-then-large-task
    split), then copy.
  - Progress is throttled — a few redraws per second, not one per file.
  - Cancellation is checked between files; a half-written file never sits under its final name — write to a temporary
    name, then rename (os-07's crash-safe pattern).
  - An undo log records each operation's inverse: move back, restore from trash. Permanent deletion has no inverse,
    which is why the trash is the default.
  - `copy_file_range(2)` copies inside the kernel without passing data through user space.
- **Recall targets:** why the file list is gathered first; which operations have inverses; what a cancelled copy must
  never leave behind.
- **Build:** yes — an operation log in `code/src/rust/crates/msNNN_undo_log/` (planned). Tests run a batch of moves in
  a temporary tree, undo them and compare the tree with its starting state; a cancellation test stops mid-batch and
  checks no partial file remains under a final name.
- **Efficiency lens:** throughput and redraws per second while copying a few hundred MiB inside a temporary directory,
  with progress unthrottled and throttled.
- **Safety:** as lesson 04 — temporary directories only.
- **Sources:**
  - `man 2 copy_file_range`, `man 2 rename` (Linux man-pages 6.7).
  - tokio-util 0.7.19 `CancellationToken` (MIT)
    (<https://docs.rs/tokio-util/0.7.19/tokio_util/sync/struct.CancellationToken.html>).
  - "Why is Yazi fast?" — async task scheduling (<https://yazi-rs.github.io/blog/why-is-yazi-fast>).
- **Done when:** the undo and cancellation tests pass and the throttling measurements are in the journal.

## 06 — From exercises to a tool others can build on

- **Objective:** Sam can assemble lessons 02–05 into a first working file manager — a core library and a thin ratatui
  front-end — in its own repository, ready for friends and family to contribute to.
- **Builds on:** lessons 01–05; ui-03 (architecture and tests); tooling-05-licensing-and-collaboration lessons 05–07
  (choosing a product repository's licence, contributor infrastructure, reviewing a contributor's pull request).
- **Key ideas:**
  - A library crate (listing, preview, trash, undo) and a thin TUI binary: the library's API is what contributors code
    against — the same "library crate plus thin client" shape os-07 uses for the package manager.
  - The repository's licence is chosen before the first outside contribution (licences are per repository; tooling-05
    teaches how), with CONTRIBUTING, sign-off and required CI checks in place.
  - First issues sized for newcomers; Sam's lesson exercises stay in this repository, the tool lives there.
- **Recall targets:** what belongs in the library and what in the binary; what must exist before the first outside
  pull request is accepted.
- **Build:** yes — the Syntek OS file-manager repository (created when this build starts): the core library from
  lessons 02–05 and a ratatui front-end, with its own CI (tests including `TestBackend` screens, clippy and
  cargo-deny). Checked by green CI and by one friend or family member building it from the README alone.
- **Security lens:** a contributor's pull request is untrusted code: CI runs with least privilege, nothing merges
  without review, and dependency changes go through cargo-deny.
- **Sources:**
  - `code/docs/RUST-CODING-PRINCIPLES.md` Section 5 "Crate and module layout".
  - Developer Certificate of Origin (<https://developercertificate.org/>).
  - Yazi v26.9.1 `CONTRIBUTING.md` as a worked example (<https://github.com/sxyazi/yazi/tree/v26.9.1>).
- **Done when:** the repository has a licence, CONTRIBUTING and green CI; the file manager browses, previews safely,
  trashes and undoes; and one outside person has built it from the README.
