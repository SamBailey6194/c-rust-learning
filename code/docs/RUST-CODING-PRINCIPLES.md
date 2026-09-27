---
type: guide
---

# Rust Coding Principles

**Last Updated**: 27/09/2026 | **Version**: 0.1.0 | **Maintained By**: Sam Bailey
**Language**: British English (en_GB) | **Timezone**: Europe/London

How Rust is written in the workspace at `code/src/rust/`: layout is rustfmt's, linting is clippy's under
one workspace policy, errors are values, and `unsafe` is an explicit, commented exception. This guide
**owns the Rust lint policy and the `unsafe` rules**; the edition and the toolchain pin are decided in
`project-management/src/08-DECISIONS/ADR-MS001-RUST-EDITION-2024-TOOLCHAIN-PIN-27-09-2026.md`. The
commands themselves are in `code/docs/BUILD.md`, tests in `code/docs/TESTING.md`, and the C boundary in
`code/docs/FFI.md`.

---

## 1. Formatting — rustfmt decides

C here uses the kernel's style and Rust uses rustfmt's: in both languages the upstream style is adopted
whole, so there is nothing to debate and nothing to configure.

- `cargo fmt` rewrites the layout; `cargo fmt --check` changes nothing and fails if anything would move.
  The check is the gate (`code/src/scripts/rust/lint.sh`).
- `code/src/rust/rustfmt.toml` sets only `edition = "2024"`, so running bare `rustfmt` on a single file —
  as an editor does — lays it out the same way `cargo fmt` does. Everything else is rustfmt's defaults.
- Never hand-align code rustfmt will move; run `cargo fmt` and read the diff instead.

---

## 2. The lint policy, and why each line exists

The policy is written once, in `[workspace.lints]` in `code/src/rust/Cargo.toml`, and every crate opts in
with `[lints] workspace = true`.

| Lint | Level | Why |
| --- | --- | --- |
| `unsafe_code` (rustc) | `deny` | `unsafe` is part of the syllabus (FFI, P3), so it cannot be banned outright. `forbid` would make a local `#[allow]` impossible; `deny` makes every use deliberate, visible in the diff, and reviewable (Section 4) |
| `clippy::all` | `deny`, `priority = -1` | The default clippy groups — correctness, suspicious, style, complexity, perf — as errors |
| `clippy::pedantic` | `warn`, `priority = -1` | Opinionated lints with some false positives: they teach idiomatic Rust, as warnings |
| `clippy::unwrap_used`, `clippy::expect_used` | `warn` | Both panic on the unhappy path. They are in clippy's `restriction` group, which is not part of `clippy::all` and is never enabled wholesale (clippy's own `blanket_clippy_restriction_lints` warns against that), so they are named one by one |

**`priority = -1`.** Cargo hands lints to the compiler sorted by priority, lowest first, and a later
setting overrides an earlier one. Giving the groups a lower priority than the single lints means an
individual line can always refine its group, whatever order the table is written in (the Cargo
reference's `[lints]` section).

**`warn` is not optional.** `cargo build` and `cargo test` never run clippy, and `cargo clippy` on its
own prints warnings without failing — that is the edit-compile loop, where a warning should not stop
you. The gate is stricter: `code/src/scripts/rust/lint.sh` and the `Syntax — Rust` CI workflow run
`cargo clippy --workspace --all-targets -- -D warnings`, which turns every remaining warning into an
error. So `deny` means "fix it before clippy passes at all" and `warn` means "fix it before merging".

**Tests may unwrap.** `code/src/rust/clippy.toml` sets `allow-unwrap-in-tests` and
`allow-expect-in-tests`, because inside a `#[test]` a panic **is** the failure report. Outside tests the
warning stands.

**Stricter crates add, they do not replace.** Cargo refuses a crate that inherits the workspace lints and
also lists its own (`cannot override workspace.lints in lints`). A crate that needs more — every FFI crate
does — adds crate-level attributes at the top of `src/lib.rs`, which stack on the inherited policy:

```rust
#![deny(clippy::panic, clippy::indexing_slicing, clippy::unwrap_used, clippy::expect_used)]
```

**Silencing one finding.** Use the narrowest scope, with a reason. Prefer `#[expect]` (stable since Rust
1.81) to `#[allow]`: when the code changes and the lint stops firing, `#[expect]` warns
(`unfulfilled_lint_expectations`), so stale suppressions surface; an `#[allow]` stays silent forever.

```rust
let len = input.len().min(64);
#[expect(
    clippy::cast_possible_truncation,
    reason = "len is capped at 64 on the line above"
)]
let n = len as u8;
```

**Changing the policy** — adding a lint, promoting `warn` to `deny` — is a decision recorded as an ADR in
`project-management/src/08-DECISIONS/`, then made in `code/src/rust/Cargo.toml`.

---

## 3. Errors are values

- **`Result<T, E>` for anything that can fail** for reasons outside the programmer's control: input,
  files, the environment. **`Option<T>` for absence** that is not an error.
- **`?` propagates**, converting the error type through `From` on the way.
- **No `unwrap()` or `expect()` in library code.** A library cannot know whether its caller can survive a
  panic, so `src/lib.rs` returns `Result` and the binary decides, at the edge, what failure means for the
  user.
- **A panic means a bug** — a broken invariant — not bad input. A public function that can panic says so
  in a `# Panics` doc section; clippy's pedantic `missing_panics_doc` asks for it.
- **Standard library first.** Write the error type by hand once before reaching for `thiserror` or
  `anyhow`: it is the lesson, and any new crate is a supply-chain decision that
  `code/src/scripts/rust/audit.sh` checks against `code/src/rust/deny.toml`.

A complete error type, with only `std` (it passes `cargo clippy --all-targets -- -D warnings` under the
workspace policy):

```rust
use std::fmt;
use std::num::ParseIntError;

/// Why a port setting could not be read.
#[derive(Debug)]
pub enum PortError {
    /// No value was given at all.
    Missing,
    /// A value was given, but it is not a number from 0 to 65535.
    NotANumber(ParseIntError),
}

impl fmt::Display for PortError {
    fn fmt(&self, f: &mut fmt::Formatter<'_>) -> fmt::Result {
        match self {
            Self::Missing => write!(f, "no port given"),
            Self::NotANumber(e) => write!(f, "port is not a number: {e}"),
        }
    }
}

impl std::error::Error for PortError {
    fn source(&self) -> Option<&(dyn std::error::Error + 'static)> {
        match self {
            Self::Missing => None,
            Self::NotANumber(e) => Some(e),
        }
    }
}

impl From<ParseIntError> for PortError {
    fn from(e: ParseIntError) -> Self {
        Self::NotANumber(e)
    }
}

/// Parses a TCP port from an optional setting.
///
/// # Errors
///
/// [`PortError::Missing`] for `None`; [`PortError::NotANumber`] when the text is not a `u16`.
pub fn parse_port(raw: Option<&str>) -> Result<u16, PortError> {
    let raw = raw.ok_or(PortError::Missing)?;
    Ok(raw.trim().parse::<u16>()?)
}
```

And the binary deciding what failure means, with an exit status instead of a panic:

```rust
use std::process::ExitCode;

fn main() -> ExitCode {
    match parse_port(std::env::args().nth(1).as_deref()) {
        Ok(port) => {
            println!("port {port}");
            ExitCode::SUCCESS
        }
        Err(e) => {
            eprintln!("error: {e}");
            ExitCode::FAILURE
        }
    }
}
```

---

## 4. `unsafe` — denied, not forbidden

The workspace denies `unsafe_code`. That lint fires on an `unsafe` block, an `unsafe fn`, an `unsafe
impl`, an `unsafe extern` block, and an exported `#[unsafe(no_mangle)]` function — the last two checked
with Rust 1.92, and both unavoidable in FFI. To use `unsafe`:

1. Put `#[allow(unsafe_code)]` on the **smallest item** that needs it — the statement, not the module.
2. Directly above the block, write a `// SAFETY:` comment that **names the invariant** making it sound:
   what is true, and why it is true here.
3. On an `unsafe fn`, write a `# Safety` doc section stating what the **caller** must guarantee.
   clippy's `missing_safety_doc` is in the default set, so it is an error here without one.

```rust
#[allow(unsafe_code)]
// SAFETY: `name` is non-null (checked above) and the caller guarantees it points to a
// NUL-terminated string that stays valid for the duration of this call.
let name = unsafe { CStr::from_ptr(name) };
```

**An `unsafe` block with no `SAFETY:` comment is a review failure, not a style nit.** The comment is the
only part of the block a reviewer can check; the compiler has stopped checking.

Two details from edition 2024:

- **`unsafe_op_in_unsafe_fn` warns by default.** The body of an `unsafe fn` is no longer one big unsafe
  block: each unsafe operation inside it gets its own `unsafe { }` and its own `SAFETY:` comment.
- **`extern` blocks are written `unsafe extern "C" { ... }`**, and `#[no_mangle]` is written
  `#[unsafe(no_mangle)]` — both say that the author, not the compiler, vouches for them.

clippy's restriction lint `undocumented_unsafe_blocks` flags an unsafe block that has no `SAFETY:`
comment. It is not enabled in the workspace today; turning it on would be an ADR (Section 2).

---

## 5. Crate and module layout

- **One crate per exercise**: `code/src/rust/crates/msNNN_snake_name/`, the directory name equal to the
  package name. Cargo rejects package names that start with a digit, hence the `ms` prefix that matches
  the C folder `msNNN-kebab-name/`; which number `NNN` takes is owned by `code/src/CLAUDE.md` → Output
  & naming.
- **`src/lib.rs` holds the logic** and its unit tests; **`src/main.rs` stays thin** — read arguments,
  call the library, print, return an `ExitCode`. Logic in `main.rs` cannot be reached from `tests/`.
- **`tests/*.rs` are integration tests**, each compiled as a separate crate that sees only the `pub` API
  (`code/docs/TESTING.md`).
- **Modules**: `mod parser;` in `lib.rs` loads `src/parser.rs`; a child module of it lives in
  `src/parser/lexer.rs`, declared with `mod lexer;` inside `parser.rs`. No `mod.rs` files are needed.
- **A small public surface.** Items are private by default; make them `pub` only when a caller outside
  the crate needs them, and use `pub(crate)` for sharing inside it.
- **Documentation**: `//!` at the top of `lib.rs` for the crate, `///` on every public item, with
  `# Errors`, `# Panics` and `# Safety` sections where they apply. Examples in `///` comments run as doc
  tests.
- **`#[must_use]`** where ignoring a return value is a bug; clippy's pedantic `must_use_candidate`
  suggests where.
- **Names**: `snake_case` for functions, variables and modules; `PascalCase` for types and traits;
  `SCREAMING_SNAKE_CASE` for constants. The compiler's own naming lints enforce these.

The reference crate is `code/src/rust/crates/ms001_hello/`: a library function, a thin binary, unit tests
and an integration test, laid out as above.

---

## Cross-references

- `code/docs/CODING-PRINCIPLES.md` — the principles behind both languages' rules
- `code/docs/BUILD.md` — the cargo commands, the toolchain pin, and the scripts that wrap them
- `code/docs/TESTING.md` — unit, integration and doc tests
- `code/docs/FFI.md` — `unsafe` at the C boundary, where these rules matter most
- `code/src/rust/Cargo.toml` — the lint policy as configuration
- `code/workflows/03-rust-exercise/` — the procedure for a new crate or a port of a C exercise
- `code/REFERENCES.md` — the Rust Book, Reference, Rustonomicon and clippy's lint list

_Part of the `code/docs/` documentation family._
