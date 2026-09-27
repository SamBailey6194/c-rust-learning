# ADR-MS001: Rust — edition 2024, toolchain pinned to 1.92.0 by `rust-toolchain.toml`

| Field | Value |
| --- | --- |
| **ID** | ADR-MS001-RUST-EDITION-2024-TOOLCHAIN-PIN |
| **Status** | Accepted |
| **Date** | 27/09/2026 |
| **Milestone** | MS001 — Toolchain ready · `project-management/src/02-MILESTONES/MS001-TOOLCHAIN-READY.md` |
| **Deciders** | Sam Bailey |
| **Supersedes** | — |
| **Superseded by** | — |
| **Research** | — (primary sources cited below) |
| **Enforced in** | `code/src/rust/rust-toolchain.toml` (`channel = "1.92.0"`) · `code/src/rust/Cargo.toml` (`edition = "2024"`, `rust-version = "1.92"`, `resolver = "3"`) · documented in `code/docs/RUST-CODING-PRINCIPLES.md` and `how-to/docs/TOOLCHAIN.md` |

---

## Context

This is one of five scaffold defaults accepted on 27/09/2026 together with the repository skeleton,
before the first exercise was written. It records the choice and the evidence available that day.
Like every Accepted ADR it is immutable: every later pin bump or edition change is a new ADR that
supersedes this one, through `how-to/workflows/04-toolchain-updates/`, and this record stays as
written.

The Rust workspace at `code/src/rust/` needs two settings that are really one decision — which Rust
the learner writes, and which compiler checks it. The edition sets the language rules and a minimum
compiler; the toolchain pin fixes the exact compiler, clippy and rustfmt that local runs and CI both
use. With `-D warnings` on clippy, the clippy version decides whether the build is green, so an
unpinned toolchain can turn the build red without any code changing.

Facts checked on 27/09/2026:

- **Installed:** rustc and cargo 1.92.0, clippy 0.1.92, rustfmt 1.8.0. Rust 1.92.0 was released on
  11/12/2025. On this host rustup's `stable` channel still resolves to 1.92.0.
- **Upstream stable is newer:** the stable channel manifest names rustc 1.98.1. A pin at 1.92.0 is six
  minor releases behind on the day it is accepted.
- **Edition 2024** was stabilised in Rust 1.85.0 (20/02/2025), which is its minimum compiler. The
  changes a learner meets early: `extern` blocks are written `unsafe extern`, and their items can be
  marked `safe` or `unsafe`; `no_mangle`, `export_name` and `link_section` must be written as unsafe
  attributes (`#[unsafe(no_mangle)]`); the `unsafe_op_in_unsafe_fn` lint warns by default, so an
  unsafe operation inside an `unsafe fn` still needs its own `unsafe {}` block; references to a
  `static mut` are an error by default; return-position `impl Trait` captures all in-scope lifetimes.
  Most of these land squarely on P3's `unsafe` and FFI work.
- **The Rust Programming Language** (the online stable edition) says it assumes Rust 1.90.0 or later
  with `edition = "2024"` in every project, so the pin satisfies the book the learner reads.
- **Cargo's resolver 3** is the default for edition 2024 packages and prefers dependency versions
  whose own `rust-version` fits the project's. A virtual workspace — a root `Cargo.toml` with no
  package, as here — has no edition to infer the resolver from, so `resolver = "3"` is written
  explicitly.
- **How the pin is found:** rustup picks the toolchain from, in order, a `+toolchain` on the command
  line, `RUSTUP_TOOLCHAIN`, a directory override, a `rust-toolchain.toml` in the **current directory
  or a parent**, and finally the default. rustup 1.28.1 and later installs a missing pinned toolchain
  automatically unless `RUSTUP_AUTO_INSTALL=0`.
- **A trap, verified on the host:** the lookup starts from the current directory, not from the
  manifest. `cargo --manifest-path code/src/rust/Cargo.toml build`, run from the repository root, used
  the default toolchain; run from inside the workspace, cargo used the pinned one (tested with a
  scratch workspace pinned to 1.85.0). Only running cargo from inside `code/src/rust/` honours the pin.
- **Kernel Rust later:** the kernel's minimal requirements list Rust 1.85.0 as the oldest supported
  compiler, and mainline's top-level `Makefile` builds its Rust with `--edition=2021` (7.3-rc4, checked
  27/09/2026). Rust-for-Linux also needs `rust-src`, bindgen and libclang, none of which this pin
  installs. The kernel's Rust is built by the kernel's own build, not by this workspace.

## Options considered

### Option A — Edition 2021 on the floating `stable` channel

- **Summary:** The previous edition, with whatever `stable` is on the day.
- **Pros:** A large body of existing tutorials and crates are written in it. Matches the edition the
  kernel's own Rust code uses today.
- **Cons:** The book the learner studies assumes 2024, so its examples and the workspace would
  disagree. 2021 permits exactly the `unsafe` shapes 2024 was changed to flag, at the point in P3 where
  that discipline matters most. The kernel's edition is set by the kernel's build, not by this
  workspace, so matching it here buys nothing. Floating `stable` adds the drift problem of Option B.

### Option B — Edition 2024 on the floating `stable` channel

- **Summary:** The current edition, with no pin; each machine uses its own `stable`.
- **Pros:** Always the newest compiler, lints and diagnostics, with no pin to maintain.
- **Cons:** Unreproducible. A new release adds clippy lints, and under `-D warnings` a green build
  goes red with no code change — in CI, whose runner updates, before the laptop does. A learner cannot
  tell a toolchain change from their own regression, which is the one confusion a learning repository
  most needs to avoid.

### Option C — Edition 2024, exact pin 1.92.0 in `rust-toolchain.toml`

- **Summary:** `channel = "1.92.0"`, `profile = "minimal"`, `components = ["rustfmt", "clippy"]`;
  `rust-version = "1.92"` and `resolver = "3"` in the workspace.
- **Pros:** The same compiler, clippy and rustfmt locally and in CI. Toolchain changes become
  deliberate, reviewable events rather than weather. It is the toolchain already installed and the one
  every other tool version in `how-to/docs/TOOLCHAIN.md` was recorded against. It meets the book's
  1.90.0 minimum and the 2024 edition's 1.85.0 minimum.
- **Cons:** Six releases behind upstream on day one: newer language features, library APIs and lints
  are unavailable until a bump. Each bump is manual work across three files. The pin is silently
  bypassed by cargo runs made from outside `code/src/rust/`.

### Option D — Edition 2024, exact pin to the newest stable (1.98.1)

- **Summary:** As Option C, but pinned to the newest release on the day.
- **Pros:** The newest features and lints, still reproducible.
- **Cons:** Not installed on the host; the scaffold's verification and the recorded toolchain table
  would describe a compiler that was never run here. Its advantage over Option C is small at P1–P2,
  where the only Rust is MS001's smoke-test crate, and a bump is exactly what
  `how-to/workflows/04-toolchain-updates/` exists to exercise when the Rust phase starts.

## Decision

**We will take Option C: edition 2024, with the toolchain pinned to exactly 1.92.0 by
`code/src/rust/rust-toolchain.toml`.** The deciding factor is reproducibility: a pinned toolchain is
the only way a red build always means a change in the code, and that property is worth more to a
learner than the newest release. Edition 2024 is chosen because it is the edition the learner's main
book assumes and because its stricter `unsafe` rules arrive exactly where P3 needs them. Option D is
the obvious next step and is deliberately left as the first real use of the toolchain-update
workflow, rather than taken untested in the scaffold.

This answer changes whenever the pin is bumped — most likely at the start of P3, or when the kernel's
minimum Rust version at P4 moves past 1.92.0 — and each bump is a new ADR that supersedes this one.

## Consequences

- **Positive:** `cargo test`, `cargo fmt --check` and `cargo clippy --all-targets -- -D warnings`
  give the same answer on the laptop and in CI. Edition 2024's `unsafe extern`, unsafe attributes and
  `unsafe_op_in_unsafe_fn` make every unsafe operation in the FFI work explicit, alongside the
  workspace-level `unsafe_code = "deny"` lint.
- **Negative:** The learner meets release-note features that do not compile here until a bump. Cargo
  commands that pass `--manifest-path` from the repository root use the default toolchain instead of
  the pin; the docs and scripts run cargo from inside `code/src/rust/` for that reason. Pin bumps are
  recurring maintenance.
- **Follow-on:** A bump moves `channel` in `code/src/rust/rust-toolchain.toml`, `rust-version` in
  `code/src/rust/Cargo.toml` and the Rust rows of `how-to/docs/TOOLCHAIN.md` together, through
  `how-to/workflows/04-toolchain-updates/` and a superseding ADR. At P4, Rust-for-Linux needs
  `rust-src`, bindgen and clang/LLVM — a separate decision, taken with the kernel work.

## Sources

- **Rust 1.85.0 release announcement** — <https://blog.rust-lang.org/2025/02/20/Rust-1.85.0/> —
  edition 2024 stabilised, checked 27/09/2026
- **Rust 1.92.0 release announcement** — <https://blog.rust-lang.org/2025/12/11/Rust-1.92.0/> — the
  pinned release, checked 27/09/2026
- **The Rust Edition Guide, Rust 2024** — <https://doc.rust-lang.org/edition-guide/rust-2024/index.html>
  — release version 1.85.0; unsafe extern blocks, unsafe attributes, `unsafe_op_in_unsafe_fn`,
  `static mut` references, lifetime capture, resolver 3; checked 27/09/2026
- **The Rust Programming Language** — <https://doc.rust-lang.org/book/title-page.html> — assumes Rust
  1.90.0 or later with edition 2024, checked 27/09/2026
- **rustup book, Overrides** — <https://rust-lang.github.io/rustup/overrides.html> — toolchain
  precedence and the `rust-toolchain.toml` format, checked 27/09/2026
- **Cargo book, Dependency Resolution** — <https://doc.rust-lang.org/cargo/reference/resolver.html> and
  **Workspaces** — <https://doc.rust-lang.org/cargo/reference/workspaces.html> — resolver 3 as the 2024
  default; virtual workspaces set `resolver` explicitly, checked 27/09/2026
- **Rust stable channel manifest** — <https://static.rust-lang.org/dist/channel-rust-stable.toml> —
  rustc 1.98.1 as upstream stable, checked 27/09/2026
- **Linux kernel docs, Minimal requirements** — <https://docs.kernel.org/process/changes.html> — Rust
  1.85.0 minimum, bindgen 0.71.1, Clang/LLVM 17.0.1, checked 27/09/2026
- **Linux kernel docs, Rust Quick Start** — <https://docs.kernel.org/rust/quick-start.html> —
  `rust-src`, bindgen and libclang for Rust-for-Linux, checked 27/09/2026
