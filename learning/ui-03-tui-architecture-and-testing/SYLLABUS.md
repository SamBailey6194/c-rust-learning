# Syllabus — ui-03-tui-architecture-and-testing

**Track**: ui · **Phase**: U1 · **Path**: Core · **Detail**: full · **Prerequisites**: ui-02-ratatui-foundations (all lessons); P3 including its async Rust topic (futures, the tokio runtime, tasks and channels, `select!`, `spawn_blocking`)
**Status**: Planned · **Checked**: 27/09/2026 (sources re-verified by `/teach` step 3 before each lesson)

This topic gives every Syntek OS TUI the same shape before any real tool is built: state, messages, an update function
and a view (The Elm Architecture); slow work that never blocks the render loop, first on a thread with a channel and
then on tokio; tests that assert on the rendered screen; errors that restore the terminal before they are reported; and
redraws that stay cheap with 100,000 items. It closes U1 — its screen tests complete the candidate milestone "a
raw-mode terminal program in C, then the same in ratatui with tests" (`project-management/src/01-ROADMAP/ROADMAP.md`)
— and every U2 tool (file manager, package-manager front-end, installer, system tools) reuses its patterns. Builds
continue in the ui-02 lesson crate, `code/src/rust/crates/msNNN_tiny_tui/` (planned).

| # | Lesson | Size | Build | Lenses |
| --- | --- | --- | --- | --- |
| 01 | The Elm Architecture in Rust | 1 sitting | yes — tiny_tui, refactor | — |
| 02 | Background work on a thread with a channel | 2–3 sittings | yes — tiny_tui, scan on a thread | Efficiency |
| 03 | Async: tokio tasks and an event stream | 2–3 sittings | yes — tiny_tui, scan on tokio | Security |
| 04 | Testing the rendered screen | 1 sitting | yes — tiny_tui, screen tests | — |
| 05 | Errors in a TUI | 1 sitting | yes — tiny_tui, error paths | — |
| 06 | Redraw cost and large lists | 1 sitting | yes — tiny_tui, 100k list | Efficiency |

---

## 01 — The Elm Architecture in Rust

- **Objective:** Sam can structure a TUI as a model, a message type, an update function and a view, with the update
  function tested without a terminal.
- **Builds on:** ui-02 lessons 02 and 05; P3 enums, pattern matching and ownership.
- **Key ideas:**
  - Model: all application state in one type. Message: an enum of everything that can happen — mapped keys, ticks,
    results of background work.
  - `update(model, message)` changes the state and may ask for an effect; `view(&model, frame)` only draws.
  - I/O stays out of `update`: an effect runs elsewhere and its result returns as a new message, so `update` stays
    deterministic and testable.
  - An exhaustive `match` over the message enum makes "every message is handled" a compile-time check.
- **Recall targets:** which of model, update and view may perform I/O; why messages are an enum; where "quit" lives.
- **Build:** yes — refactor `msNNN_tiny_tui` into model, message, update and view modules; unit tests drive `update`
  with message sequences and assert the resulting model.
- **Sources:**
  - "The Elm Architecture", An Introduction to Elm (<https://guide.elm-lang.org/architecture/>, read 27/09/2026).
  - ratatui.rs, "The Elm Architecture (TEA)"
    (<https://ratatui.rs/concepts/application-patterns/the-elm-architecture/>, read 27/09/2026).
  - The Rust Programming Language (Rust 1.92.0), chapter 6 "Enums and Pattern Matching"
    (<https://doc.rust-lang.org/1.92.0/book/ch06-00-enums.html>).
- **Done when:** the refactored program behaves as before and the update tests cover every message variant.

## 02 — Background work on a thread with a channel

- **Objective:** Sam can move slow work onto a worker thread and feed its progress and result back to the UI through
  `std::sync::mpsc`, keeping the interface responsive throughout.
- **Builds on:** lesson 01; P3 threads and message passing.
- **Key ideas:**
  - Anything slow on the render thread freezes the screen — including a directory walk.
  - The worker sends progress and results as messages; the UI loop has two sources to wait on — keys and the channel.
  - Two ways to merge them: poll input with a timeout and drain the channel with `try_recv`, or have one input thread
    send key events into the same channel (crossterm's `read`/`poll` stay on that one thread).
  - Cancellation: a flag the worker checks; and when the receiver is dropped, the worker's next `send` fails — a signal
    to stop.
- **Recall targets:** why the naive version froze; the two ways to merge input and results; what the worker sees when
  the UI has gone.
- **Build:** yes — a "scan" command in `msNNN_tiny_tui` that counts files under a directory on a worker thread, with a
  progress line and a cancel key. Tests feed synthetic progress messages through `update`; by hand, keys still respond
  during a scan of a large directory.
- **Efficiency lens:** latency from key press to redraw while a scan runs, logged with `std::time::Instant`, before and
  after moving the scan off the render thread.
- **Sources:**
  - Rust 1.92.0 `std::sync::mpsc` — "Disconnection" (<https://doc.rust-lang.org/1.92.0/std/sync/mpsc/index.html>).
  - The Rust Programming Language (Rust 1.92.0), 16.2 "Using Message Passing to Transfer Data Between Threads"
    (<https://doc.rust-lang.org/1.92.0/book/ch16-02-message-passing.html>).
  - crossterm 0.29.0 `event` module — the one-thread rule
    (<https://docs.rs/crossterm/0.29.0/crossterm/event/index.html>).
- **Done when:** the UI answers keys during a scan, cancel stops the worker, and the latency is recorded before and
  after.

## 03 — Async: tokio tasks and an event stream

- **Objective:** Sam can run the same TUI on tokio — crossterm's `EventStream`, tasks for I/O and `tokio::select!`
  over keys, task results and a tick — without changing the model, messages or update.
- **Builds on:** lesson 02; P3's async Rust topic.
- **Key ideas:**
  - `EventStream` needs crossterm's `event-stream` feature and replaces `read`/`poll` entirely; the two are never mixed.
  - Tasks report through `tokio::sync::mpsc`; `select!` waits on several futures and, by default, picks randomly among
    ready branches (`biased;` changes that).
  - Blocking or CPU-heavy work goes to `spawn_blocking`; `tokio::fs` itself runs on that pool.
  - A thread is enough for one background job; tasks pay off when there are many concurrent I/O jobs — ui-04's
    listings and previews.
  - A task that is no longer wanted is aborted (`JoinHandle::abort`); dropping its handle only detaches it, and the
    task keeps running. The UI never waits on it.
- **Recall targets:** which work goes to `spawn_blocking`; what `select!` does when two branches are ready; what
  dropping a `JoinHandle` does and does not do; why `event::read` never appears inside the async loop.
- **Build:** yes — port lesson 02's scan to tokio tasks behind the same model and message types; `update` unchanged is
  the proof the architecture holds. Run `cargo deny check` straight after adding tokio and crossterm's feature.
- **Security lens:** a feature flag can widen the dependency graph; the deny check after `cargo add --features` is part
  of the change, not an afterthought (`code/src/rust/deny.toml`).
- **Sources:**
  - crossterm 0.29.0 `EventStream` (<https://docs.rs/crossterm/0.29.0/crossterm/event/struct.EventStream.html>).
  - tokio 1.53.1: `select!` (<https://docs.rs/tokio/1.53.1/tokio/macro.select.html>), `task::spawn_blocking`
    (<https://docs.rs/tokio/1.53.1/tokio/task/fn.spawn_blocking.html>), `sync::mpsc`
    (<https://docs.rs/tokio/1.53.1/tokio/sync/mpsc/index.html>), `fs`
    (<https://docs.rs/tokio/1.53.1/tokio/fs/index.html>), `task::JoinHandle`
    (<https://docs.rs/tokio/1.53.1/tokio/task/struct.JoinHandle.html>).
  - The tokio tutorial (<https://tokio.rs/tokio/tutorial>, read 27/09/2026).
- **Done when:** the async build passes the same update tests as the threaded one and Sam explains where each kind of
  work runs.

## 04 — Testing the rendered screen

- **Objective:** Sam can test widgets and whole screens by rendering into a `Buffer` or a `TestBackend` and asserting
  on the lines, at several sizes.
- **Builds on:** lessons 01–03; ui-02 lesson 04's first `Buffer` test.
- **Key ideas:**
  - Widget unit tests render straight into a `Buffer` — ratatui's own docs prefer this for widgets.
  - Whole-screen integration tests draw through `Terminal::new(TestBackend::new(w, h))` and assert with
    `assert_buffer_lines`; `resize` tests the layout at a new size.
  - Styles live in the `Buffer` too: assert a style where the meaning depends on it (ui-02 lesson 06).
  - Snapshot crates such as insta are Apache-2.0-only; one would enter only with a documented per-crate exception in
    `deny.toml` citing the crate-licence ADR. `Buffer` assertions need no dependency at all.
- **Recall targets:** when to test against a `Buffer` and when against a `TestBackend`; what makes a screen test
  brittle.
- **Build:** yes — screen tests for `msNNN_tiny_tui`: one per widget into a `Buffer`, and an integration test that
  sends messages through `update`, draws to a `TestBackend` at 80 x 24 and 20 x 5, and asserts the lines. With this
  the U1 candidate milestone is complete.
- **Sources:**
  - ratatui 0.30.2 `TestBackend` (<https://docs.rs/ratatui/0.30.2/ratatui/backend/struct.TestBackend.html>) —
    `assert_buffer_lines`, `resize`; `Buffer::with_lines`
    (<https://docs.rs/ratatui/0.30.2/ratatui/buffer/struct.Buffer.html>).
  - ratatui.rs, "Testing with insta snapshots" (<https://ratatui.rs/recipes/testing/snapshots/>) — read for the idea,
    not the crate.
  - `project-management/src/08-DECISIONS/ADR-MS001-LLM-RUST-CRATE-LICENCES-27-09-2026.md` (per-crate exceptions).
- **Done when:** the screen tests pass in `cargo test` and in the `Syntax — Rust` CI run, at both sizes.

## 05 — Errors in a TUI

- **Objective:** Sam can propagate fatal errors out of the event loop so the terminal is restored before they are
  printed, and show recoverable errors inside the UI.
- **Builds on:** lessons 01–04; ui-02 lesson 01 (the panic hook); P3 error handling.
- **Key ideas:**
  - Errors are values (`code/docs/RUST-CODING-PRINCIPLES.md` Section 3): fatal ones return from the run function,
    recoverable ones become messages.
  - Fatal: leave the loop, restore the terminal, then print to stderr — while raw mode and the alternate screen are on,
    printed text is garbled or lost.
  - Recoverable (a file cannot be read, permission denied): a message into the model, shown on a status line.
  - Diagnostics go to a log file, never to the terminal the UI owns.
- **Recall targets:** where a failed directory read is shown and where a failed terminal set-up is shown; why nothing
  is printed while raw mode is on.
- **Build:** yes — error paths in `msNNN_tiny_tui`: a permission-denied scan shows on the status line (tested through
  `update` and a `TestBackend` screen), and a fatal path exits with the terminal restored (checked by hand with
  `stty -a`).
- **Sources:**
  - `code/docs/RUST-CODING-PRINCIPLES.md` Section 3 "Errors are values".
  - ratatui 0.30.2 `restore` (<https://docs.rs/ratatui/0.30.2/ratatui/fn.restore.html>).
  - crossterm 0.29.0 `terminal` — "Raw Mode" (<https://docs.rs/crossterm/0.29.0/crossterm/terminal/index.html>).
- **Done when:** both error paths behave as described and Sam classifies five sample failures as fatal or recoverable.

## 06 — Redraw cost and large lists

- **Objective:** Sam can keep a TUI responsive with 100,000 items by building only what is visible, and prove it with
  measurements.
- **Builds on:** lessons 02–05; ui-02 lesson 04 (`ListState`).
- **Key ideas:**
  - Every frame rebuilds its widgets, so handing `List` 100,000 items costs CPU and memory on every frame even when 40
    rows show.
  - Window the data: slice by the list's offset and the area's height before building items.
  - ratatui's diff keeps terminal output small; it does nothing for the cost of building the frame.
  - Redraw on events and ticks, not in a busy loop; measure before optimising (`code/docs/CODING-PRINCIPLES.md`
    Section 1, Rob Pike's rules).
- **Recall targets:** what grows with list length and what with screen size; which of build, diff and write dominates
  here, and how Sam knows.
- **Build:** yes — a 100,000-item view in `msNNN_tiny_tui` with windowed rendering; the window calculation is unit
  tested at the list's ends, and a screen test checks the visible rows after scrolling.
- **Efficiency lens:** frame build time (`Instant`), peak memory (`/usr/bin/time -v`) and bytes written per frame at
  80 x 24 with 100,000 items — full list against windowed — recorded as budget against measured with llm-06 lesson
  01's method.
- **Sources:**
  - ratatui 0.30.2 `List` (<https://docs.rs/ratatui/0.30.2/ratatui/widgets/struct.List.html>) and `ListState`
    (<https://docs.rs/ratatui/0.30.2/ratatui/widgets/struct.ListState.html>); `Buffer::diff`.
  - `code/docs/CODING-PRINCIPLES.md` Section 1.
- **Done when:** scrolling 100,000 items stays smooth, the tests pass, and the full-versus-windowed numbers are in the
  journal.
