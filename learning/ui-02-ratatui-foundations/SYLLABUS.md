# Syllabus — ui-02-ratatui-foundations

**Track**: ui · **Phase**: U1 · **Path**: Core · **Detail**: full · **Prerequisites**: ui-01-terminal-fundamentals (all lessons); P3 (ownership, traits, error handling, crates)
**Status**: Planned · **Checked**: 27/09/2026 (sources re-verified by `/teach` step 3 before each lesson)

ratatui is the library every Syntek OS TUI is built on (the choice is recorded in
`project-management/src/08-DECISIONS/ADR-MS001-SYNTEK-OS-TOOLS-RUST-TUI-FIRST-27-09-2026.md`). This topic rebuilds
ui-01's tiny full-screen C program in Rust with ratatui 0.30 over its default backend, crossterm 0.29, one idea at a
time: safe setup and teardown, the immediate-mode render loop, layout, widgets, events and state, and styling that
stays usable without colour. Each lesson grows one lesson crate, the Rust port of ui-01's `msNNN-tiny-tui`, which keeps
the C exercise's number (`code/src/CLAUDE.md` → Output & naming), built through `code/workflows/03-rust-exercise/`
until the TUI workflow (`code/workflows/13-tui-app/`, planned — added at U1) exists. ui-03 then gives it an
architecture, background work and tests.

| # | Lesson | Size | Build | Lenses |
| --- | --- | --- | --- | --- |
| 01 | Setting up ratatui and crossterm safely | 1 sitting | yes — tiny_tui, started | Security |
| 02 | The immediate-mode render loop | 1 sitting | yes — tiny_tui, render loop | Efficiency |
| 03 | Layout: dividing the screen | 1 sitting | yes — tiny_tui, layout | — |
| 04 | Widgets and stateful widgets | 1 sitting | yes — tiny_tui, widgets | — |
| 05 | Events and application state | 1 sitting | yes — tiny_tui, keymap | — |
| 06 | Styling and accessibility | 1 sitting | yes — tiny_tui, theme | — |

---

## 01 — Setting up ratatui and crossterm safely

- **Objective:** Sam can add ratatui and crossterm to a workspace crate, pass the supply-chain gate first, and start
  and restore the terminal — including when the program panics.
- **Builds on:** ui-01 lessons 03–04 (raw mode, and restoring it on every exit path); P3 crates and panics.
- **Key ideas:**
  - ratatui draws; the backend (crossterm by default) does the terminal I/O — its raw mode and alternate screen are
    ui-01's termios work and `CSI ? 1049 h` behind a function call.
  - `ratatui::init()` returns a `DefaultTerminal` with raw mode and the alternate screen on, and installs a panic hook
    that restores the terminal; `ratatui::restore()` undoes both; `ratatui::run` wraps the pair around a closure.
  - Install any other panic hook before `init`, so the terminal is restored before that hook prints.
  - `cargo deny check` runs straight after `cargo add`, before anything is built — the order `code/src/rust/deny.toml`
    gives, because the next build runs the new crates' build scripts.
  - ratatui 0.30.2 needs rustc 1.88 or newer; the workspace pins 1.92.0.
- **Recall targets:** everything `init` sets up (backend, raw mode, alternate screen, panic hook); why the panic hook
  matters (link it to ui-01 lesson 04); why the licence and advisory check comes before the first build.
- **Build:** yes — start `code/src/rust/crates/msNNN_tiny_tui/` (planned): a screen that says hello and quits on a key,
  plus a deliberate panic behind a flag to prove the hook restores the terminal. Checked by `cargo deny check`,
  `cargo test` and `cargo clippy` (`code/src/scripts/rust/audit.sh`, `test.sh`, `lint.sh`), then by hand: after the
  panic path, `stty -a` matches the output taken before the run.
- **Security lens:** every new dependency is third-party code that runs at build time. ratatui's graph reaches `ryu`
  (licence `Apache-2.0 OR BSL-1.0`, via `ratatui-core` → `compact_str`); read which side of that expression
  `deny.toml` accepts, and record the result in the journal.
- **Sources:**
  - ratatui 0.30.2: `init` (<https://docs.rs/ratatui/0.30.2/ratatui/fn.init.html>), `restore`
    (<https://docs.rs/ratatui/0.30.2/ratatui/fn.restore.html>), `run`
    (<https://docs.rs/ratatui/0.30.2/ratatui/fn.run.html>).
  - crossterm 0.29.0, module `terminal`, "Raw Mode" (<https://docs.rs/crossterm/0.29.0/crossterm/terminal/index.html>).
  - Rust 1.92.0 `std::panic::set_hook` (<https://doc.rust-lang.org/1.92.0/std/panic/fn.set_hook.html>).
  - `code/src/rust/deny.toml` (the gate and its reasons); `cargo deny check` output on the day.
- **Done when:** audit, tests and clippy pass; the panic path restores the terminal; Sam names what `init` does unaided.

## 02 — The immediate-mode render loop

- **Objective:** Sam can write a loop that redraws the whole UI from application state on every pass, and explain why
  that is cheap in terminal output.
- **Builds on:** lesson 01; ui-01 lesson 07 (frame diff by hand).
- **Key ideas:**
  - Retained mode keeps widget objects and mutates them; immediate mode rebuilds the UI from state every frame, so the
    UI can never drift out of sync with the state.
  - One `Terminal::draw(|frame| …)` call is one render pass; widgets render into an in-memory `Buffer`.
  - The `Terminal` keeps two buffers and writes only the difference to the terminal — ui-01 lesson 07's diff, done for
    you.
  - `frame.area()` is the source of truth for the size on each pass; after a resize, drawing again is enough for a
    full-screen viewport.
  - The loop owns timing: if the thread that draws is blocked, nothing updates (ui-03 lesson 02 fixes that).
- **Recall targets:** retained versus immediate mode in one sentence each; what the diff saves; where the state lives
  between frames.
- **Build:** yes — extend `msNNN_tiny_tui` with a counter the arrow keys change and a view redrawn every pass. The
  state-change function lives in `src/lib.rs` with unit tests, because integration tests cannot reach `src/main.rs`
  (`code/docs/TESTING.md` Section 2).
- **Efficiency lens:** bytes written per key press (`strace -e trace=write` on a short run), compared with ui-01's C
  program with and without its diff.
- **Sources:**
  - ratatui 0.30.2 `Terminal` — "Typical Usage" and "Rendering Pipeline"
    (<https://docs.rs/ratatui/0.30.2/ratatui/struct.Terminal.html>); `Buffer::diff`
    (<https://docs.rs/ratatui/0.30.2/ratatui/buffer/struct.Buffer.html>).
  - ratatui.rs, "Rendering" (<https://ratatui.rs/concepts/rendering/>, read 27/09/2026).
- **Done when:** the counter works, its tests pass, and Sam explains the double buffer and the diff unaided.

## 03 — Layout: dividing the screen

- **Objective:** Sam can divide a frame into regions with `Layout` and `Constraint`, and predict the size each region
  gets at any terminal size.
- **Builds on:** lesson 02.
- **Key ideas:**
  - A `Rect` is x, y, width and height in cells; a `Layout` splits one `Rect` vertically or horizontally.
  - Constraints: `Length`, `Min`, `Max`, `Percentage`, `Ratio` and `Fill`; layouts nest.
  - A linear constraint solver (kasuari) satisfies as many constraints as it can in priority order, and results are
    cached — so conflicting constraints do not fail, they give a surprise; test at small sizes.
  - Text width is measured in terminal columns, not bytes or characters: a wide character takes two cells.
- **Recall targets:** predict the three areas of a header/body/status split at 80 x 24 and at 20 x 5; explain why
  `str::len` is the wrong width.
- **Build:** yes — a header, body and status layout in `msNNN_tiny_tui`, with the area calculation a function whose
  tests assert the exact `Rect`s at 80 x 24, 20 x 5 and 0 x 0.
- **Sources:**
  - ratatui 0.30.2 `layout::Layout` (<https://docs.rs/ratatui/0.30.2/ratatui/layout/struct.Layout.html>) and
    `layout::Constraint` (<https://docs.rs/ratatui/0.30.2/ratatui/layout/enum.Constraint.html>).
  - `man 3 wcwidth` (Linux man-pages 6.7).
- **Done when:** the layout tests pass at all three sizes and Sam predicts a new split before running it.

## 04 — Widgets and stateful widgets

- **Objective:** Sam can render ratatui's built-in widgets, keep a list's selection in application state across
  frames, and write a widget of his own.
- **Builds on:** lessons 02–03.
- **Key ideas:**
  - A widget renders itself into an area of a `Buffer` (the `Widget` trait); `Paragraph`, `Block`, `List` and `Table`
    cover most screens.
  - Widgets are rebuilt every frame, so anything that must survive — a selection, a scroll offset — lives in the app
    and is passed in: `StatefulWidget` with `ListState` (offset and selected index).
  - A custom widget is a type that implements `Widget`; it is how a tool gets its own status bar or preview pane.
- **Recall targets:** why a list's selection cannot live inside the `List`; what `ListState`'s two fields hold.
- **Build:** yes — a selectable list and a custom status-bar widget in `msNNN_tiny_tui`; a unit test renders the
  status bar straight into a `Buffer` and asserts its text (ui-03 lesson 04 builds on this).
- **Sources:**
  - ratatui 0.30.2 `widgets` module (<https://docs.rs/ratatui/0.30.2/ratatui/widgets/index.html>),
    `StatefulWidget` (<https://docs.rs/ratatui/0.30.2/ratatui/widgets/trait.StatefulWidget.html>) and `ListState`
    (<https://docs.rs/ratatui/0.30.2/ratatui/widgets/struct.ListState.html>).
- **Done when:** the list keeps its selection through resizes and the custom widget's test passes.

## 05 — Events and application state

- **Objective:** Sam can turn terminal events into state changes through one keymap, with the update logic tested
  without a terminal.
- **Builds on:** lessons 02–04; ui-01 lesson 05 (what the decoder did by hand).
- **Key ideas:**
  - `event::read` blocks until an event arrives; `event::poll(timeout)` waits at most that long, which gives the loop a
    tick for anything time-based.
  - Key events carry a kind — `Press`, `Repeat` or `Release` — so the handler acts on presses deliberately.
  - Resize arrives as an event; mouse, focus and bracketed-paste events must be enabled explicitly.
  - crossterm allows `read`/`poll` from one thread only, and never mixed with its async `EventStream` (ui-03 lesson 03).
  - Map keys to actions in one place, so help text and tests read from the same table.
- **Recall targets:** when `poll` beats `read`; why the handler checks the key kind; where the single-thread rule
  bites.
- **Build:** yes — a keymap and an update function in `msNNN_tiny_tui`'s `src/lib.rs`, tested by feeding synthetic
  `KeyEvent` values and asserting the resulting state.
- **Sources:**
  - crossterm 0.29.0 `event` module (<https://docs.rs/crossterm/0.29.0/crossterm/event/index.html>) and
    `KeyEventKind` (<https://docs.rs/crossterm/0.29.0/crossterm/event/enum.KeyEventKind.html>).
- **Done when:** every binding is covered by a test and Sam explains the single-thread rule unaided.

## 06 — Styling and accessibility

- **Objective:** Sam can style a TUI so that it stays usable in monochrome, on any colour theme and from the keyboard
  alone.
- **Builds on:** lessons 03–05.
- **Key ideas:**
  - `Style` combines foreground, background and modifiers (bold, reversed, underlined).
  - Never carry meaning in colour alone: pair it with a symbol, a word or a modifier (WCAG 2.2 success criterion 1.4.1,
    written for the web and applied here by analogy).
  - Contrast: WCAG sets 4.5:1 as the minimum for normal text (1.4.3). Terminal palettes are the user's, so named
    colours and modifiers age better than fixed RGB values.
  - Honour `NO_COLOR`: when it is set and not empty, add no colour.
  - Keyboard first: every action reachable from the keyboard, focus always visible, a help screen generated from the
    keymap (WCAG 2.1.1).
- **Recall targets:** two ways to mark a selected item without colour; what `NO_COLOR` asks of a program.
- **Build:** yes — a theme module in `msNNN_tiny_tui` with a monochrome mode chosen when `NO_COLOR` is set; a test
  renders the list in monochrome into a `Buffer` and asserts the selected row is still distinguishable.
- **Sources:**
  - ratatui 0.30.2 `style` module (<https://docs.rs/ratatui/0.30.2/ratatui/style/index.html>).
  - WCAG 2.2, W3C Recommendation 12/12/2024 (<https://www.w3.org/TR/WCAG22/>) — success criteria 1.4.1, 1.4.3 and
    2.1.1.
  - NO_COLOR (<https://no-color.org/>, read 27/09/2026).
- **Done when:** the monochrome test passes and one full session of the program works with `NO_COLOR=1` and no mouse.
