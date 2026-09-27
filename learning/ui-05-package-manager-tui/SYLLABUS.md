# Syllabus — ui-05-package-manager-tui

**Track**: ui · **Phase**: U2 · **Path**: Core · **Detail**: full · **Prerequisites**: ui-03-tui-architecture-and-testing (all lessons); os-07-package-manager (the library crate and its API); os-08-repositories-signing-and-updates (the secure update flow)
**Status**: Planned · **Checked**: 27/09/2026 (sources re-verified by `/teach` step 3 before each lesson)

The package-manager front-end is the tool every Syntek OS user meets first after installing. It is a thin client:
os-07 builds the package manager as a library crate plus a thin CLI, and its API is the contract this TUI consumes;
os-08 supplies the signed repository and the secure update flow the TUI must never route around. The lessons move from
consuming that API, through search and detail views, to transactions that show their whole plan before anything
changes, and progress with safe cancellation. The work lands in the Syntek OS package-manager repository (created when
that build starts) as a front-end crate beside os-07's library and CLI; real transactions run only inside a VM guest
booted from a Syntek OS image, never against the host's package database. Until ui-07 teaches privilege separation,
the TUI runs as root inside that guest.

| # | Lesson | Size | Build | Lenses |
| --- | --- | --- | --- | --- |
| 01 | Consuming the package-manager library | 1 sitting | yes — TUI skeleton and fake backend | — |
| 02 | Search, list and detail views | 2–3 sittings | yes — search and info views | Efficiency |
| 03 | Transactions with a full preview and confirmation | 2–3 sittings | yes — preview and confirm | Security, Safety |
| 04 | Progress and safe cancellation | 2–3 sittings | yes — progress and cancel | Safety |

---

## 01 — Consuming the package-manager library

- **Objective:** Sam can drive os-07's package-manager library from a TUI crate through its public API alone, and test
  the TUI against a fake implementation of that API.
- **Builds on:** os-07 (the library crate plus thin CLI); ui-03 lessons 01 and 04; P3 traits.
- **Key ideas:**
  - The library is the contract: the TUI never shells out to the CLI or parses its output.
  - A trait at the boundary lets tests substitute a fake backend — no root, no real system, deterministic results.
  - Library errors become messages the model can show (ui-03 lesson 05).
  - The TUI pins the library version it was written against; an API change is a deliberate upgrade.
- **Recall targets:** why the TUI must not parse CLI output; what the fake backend makes testable that the real one
  does not.
- **Build:** yes — the TUI crate's skeleton (model, messages, update, view) and a fake backend implementing the
  library's trait, in the Syntek OS package-manager repository (created when that build starts). Checked by
  `cargo test` with `TestBackend` screens driven by the fake backend.
- **Sources:**
  - The Rust Programming Language (Rust 1.92.0), 10.2 "Traits: Defining Shared Behavior"
    (<https://doc.rust-lang.org/1.92.0/book/ch10-02-traits.html>).
  - ratatui 0.30.2 `TestBackend` (<https://docs.rs/ratatui/0.30.2/ratatui/backend/struct.TestBackend.html>).
  - `code/docs/RUST-CODING-PRINCIPLES.md` Section 5 (a small public surface).
- **Done when:** the skeleton lists packages from the fake backend in a passing screen test, with no dependency on the
  CLI.

## 02 — Search, list and detail views

- **Objective:** Sam can present thousands of packages with incremental search, a list and a detail pane, and keep
  every keystroke responsive.
- **Builds on:** lesson 01; ui-03 lessons 02–03 and 06.
- **Key ideas:**
  - Queries run off the render path; a newer query makes an older one stale, so it is cancelled or ignored.
  - Keystrokes are debounced, so typing a word does not start a search per letter.
  - Windowed rendering (ui-03 lesson 06) keeps a list of every package cheap.
  - Installed, available and upgradable are different views of one index; the detail pane shows version, size,
    dependencies and the package's verification status from os-08.
  - Study how an existing manager presents the same data (pacman's query and sync operations) before designing.
- **Recall targets:** why a stale search result must not overwrite a newer one; what debouncing trades away.
- **Build:** yes — search, list and detail views over the fake backend, with tests for stale-result handling and a
  screen test of the detail pane; in the Syntek OS package-manager repository.
- **Efficiency lens:** time from keystroke to updated list over a full repository index, measured with `Instant`
  against a budget set before the lesson.
- **Sources:**
  - ratatui 0.30.2 `Table` (<https://docs.rs/ratatui/0.30.2/ratatui/widgets/struct.Table.html>) and `List`
    (<https://docs.rs/ratatui/0.30.2/ratatui/widgets/struct.List.html>).
  - pacman(8), operations `--query` and `--sync` (<https://man.archlinux.org/man/pacman.8>, read 27/09/2026) — study
    only.
- **Done when:** search stays responsive over the full index, the stale-result tests pass and the latency is recorded.

## 03 — Transactions with a full preview and confirmation

- **Objective:** Sam can show a transaction's whole plan — installs, removals, upgrades, download and disk sizes and
  verification status — and apply it only after an explicit confirmation.
- **Builds on:** lessons 01–02; os-07 (transactions, resolution); os-08 (the secure update flow).
- **Key ideas:**
  - Plan → preview → confirm → apply — the same shape as os-10's installer backend.
  - The plan comes from the library's resolver; the UI never recomputes it.
  - Removals and replaced files stand out by symbol and wording, not colour alone (ui-02 lesson 06); the confirmation
    defaults to "no".
  - Verification failures from os-08 — a bad signature, or metadata that is stale (a freeze) or older than the last
    seen (a rollback) — block the transaction; the TUI offers no "proceed anyway".
- **Recall targets:** what the preview must show before a removal; which verification failures block and why a
  warning is not enough.
- **Build:** yes — preview and confirmation screens over the fake backend, with tests that a declined confirmation
  applies nothing and that every verification failure blocks; then one real transaction in a VM guest booted from a
  Syntek OS image (os-10).
- **Security lens:** TUF's threat model names indefinite freeze and rollback attacks; the UI is part of the defence only
  if it cannot be used to bypass the check.
- **Safety:** real transactions only inside a VM guest, never the host's package database; Claude never runs `sudo`.
- **Sources:**
  - The Update Framework specification, version 1.0.36
    (<https://theupdateframework.github.io/specification/latest/>) — the attacks it protects against, including
    indefinite freeze and rollback attacks.
  - WCAG 2.2 success criterion 1.4.1, Use of Color (<https://www.w3.org/TR/WCAG22/>).
- **Done when:** the tests pass and one real install and one removal in the VM guest showed a preview that matched what
  happened.

## 04 — Progress and safe cancellation

- **Objective:** Sam can show download and install progress reported by the library and let the user cancel only where
  the library says the system stays consistent.
- **Builds on:** lesson 03; ui-03 lessons 02–03 and 05; ui-01 lesson 04 (signals and restoring the terminal).
- **Key ideas:**
  - Progress arrives from the library as events and becomes messages, throttled for redraw.
  - Downloading is safe to cancel; applying is cancellable only between the points os-07's transaction design marks as
    consistent — "cancel" means something different in each phase, and the UI says which.
  - Ctrl-C during apply routes to the library's cancel request, not to process exit: the terminal is restored and the
    transaction is not left half-done.
  - After a crash, the next start reads os-07's transaction log and offers to finish or roll back.
- **Recall targets:** what cancel does in each phase; why SIGINT must not simply end the process during apply.
- **Build:** yes — progress and cancellation in the TUI, with fake-backend tests that cancel in each phase and assert
  the resulting state; then a cancelled download and an interrupted install in the VM guest, followed by recovery.
- **Safety:** VM guest only; the interrupted-install test runs on a disposable image snapshot.
- **Sources:**
  - tokio-util 0.7.19 `CancellationToken`
    (<https://docs.rs/tokio-util/0.7.19/tokio_util/sync/struct.CancellationToken.html>).
  - `man 7 signal` (Linux man-pages 6.7).
  - `man 1 qemu-img` (QEMU 8.2.2) — snapshots of the guest's disk image.
- **Done when:** every phase's cancel test passes and the VM guest recovered cleanly from the interrupted install.
