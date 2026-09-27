# code/src/rust/crates/ms001_hello/ — Hello, World in Rust

**Last Updated**: 27/09/2026

The Rust twin of `code/src/c/ms001-hello/`, and the proof that the Rust half of milestone MS001
(Toolchain ready) is met: the pinned compiler builds it, rustfmt and clippy pass at `-D warnings`, its
tests pass and cargo-deny is clean. It solves the same problem as the C exercise so the two can be read
side by side — and most of what the C version had to check by hand is simply absent here. `greet()`
returns an owned `String`, so there is no caller-supplied buffer to size, no truncation to report and
no NULL to reject.

## Directory Tree

```text
code/src/rust/crates/ms001_hello/
├── CONTEXT.md · CLAUDE.md   ← this file · tutor rules and the commands for this crate
├── Cargo.toml               ← package ms001_hello; inherits the workspace's facts and lint policy
├── src/                     ← covered by this pair
│   ├── lib.rs               ← pub fn greet(name: &str) -> String, its doc test and unit tests
│   └── main.rs              ← the binary: prints greet(first argument, or "world")
└── tests/                   ← covered by this pair
    └── greet.rs             ← integration tests: the public API, and the built binary run as a process
```

## Learning objective

After this crate the learner can lay out a package with a library crate and a binary crate, write the
three kinds of Rust test (unit, integration and doc tests), and explain which of the C version's error
cases Rust's types remove and which ones it still has to handle.

## The same greeting, two languages

| Concern | C (`ms001-hello`) | Rust (`ms001_hello`) |
| --- | --- | --- |
| Where the text goes | a buffer the caller owns and sizes | a new `String` the function returns and the caller then owns |
| Too little room | `snprintf` truncates; `greet()` returns `-1` | cannot happen: the `String` grows as needed |
| Missing input | `NULL` checked by hand, `-1` returned | cannot happen: a `&str` is a valid reference to UTF-8 text by construction |
| An empty name | greets `""`, printing `Hello, !` | greets the world, by design |
| Characters beyond ASCII | counted in bytes: an accented letter can take two | `&str` is UTF-8; no special case needed |
| Tests | `test_greet.c` with `check.h` | `#[cfg(test)]` unit tests, `tests/greet.rs`, a doc test |

## Concepts practised

| Concept | Where it shows |
| --- | --- |
| Library and binary crates in one package | `src/lib.rs` and `src/main.rs`, found by Cargo's conventional paths; `main.rs` sees the library as a separate crate, which is why it calls `ms001_hello::greet` |
| Borrowing into, owning out of | `greet(name: &str) -> String` |
| `#[must_use]` | ignoring the returned greeting is a compile-time warning |
| `Option` and a default | `env::args().nth(1).unwrap_or_else(...)` in `main.rs` |
| Tests that return `Result` | `tests/greet.rs` uses `?` instead of panicking in a helper |
| Workspace inheritance | `version.workspace = true` and `[lints] workspace = true` in `Cargo.toml` |

## Cross-references

- `code/src/c/ms001-hello/CONTEXT.md` — the C original and its contract
- `code/src/rust/CONTEXT.md` — the workspace, its lint policy and its crate list
- `code/docs/RUST-CODING-PRINCIPLES.md` — how Rust is written here
- `code/docs/TESTING.md` — unit, integration and doc tests
- `project-management/src/02-MILESTONES/MS001-TOOLCHAIN-READY.md` — the milestone this crate helps close
