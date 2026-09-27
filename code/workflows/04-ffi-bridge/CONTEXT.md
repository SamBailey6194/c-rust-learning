# Workflow: FFI Bridge

**Last Updated**: 27/09/2026

A call across the boundary between C and Rust gives up what each compiler checked on its own side — lifetimes,
nullability, who frees — and a Rust panic that reaches an `extern "C"` function aborts the whole process.
The workflow opens with a gate question because the cheapest boundary is one that does not exist.

## Directory Tree

```text
code/workflows/04-ffi-bridge/
├── CONTEXT.md · CLAUDE.md   ← orientation (this file) · operating rules for the workflow
├── STEPS.md                 ← ordered steps, each closing on a "Done when" line
└── CHECKLIST.md             ← the gate ticked before the workflow counts as complete
```

## When to use this

**P3 — the Rust phase** (`project-management/src/01-ROADMAP/ROADMAP.md`). Before P3 this folder is
reading material; the P3 exit gate asks for an FFI crate with both test suites green.

- **Rust calling C:** a crate that reuses a tested C implementation, with the C half compiled into the
  crate by a build script.
- **C calling Rust:** a Rust library built as a static archive and linked into a C test driver.
- Not for a straight port, which is `code/workflows/03-rust-exercise/`: if nothing needs to cross, nothing
  should.

## Key concepts

- **The gate question.** What does crossing buy — reuse of tested C, practice with the C ABI, a
  comparison the P3 gate asks for? The answer is written into the crate's `CONTEXT.md`; a crate that
  cannot answer it is a port in disguise.
- **Plain code first.** The logic lives in ordinary safe Rust (or ordinary C) with no FFI types in it, so
  `cargo test` and `check.h` exercise it at full speed before any boundary exists.
- **A thin boundary.** Each `extern "C"` function validates (null pointers, lengths, UTF-8), delegates to
  the plain code and maps the result to a C return code. Only C-compatible types cross — `std::ffi::c_int`,
  `c_char`, raw pointers, `#[repr(C)]` structs; `String`, `Vec`, slices and `Result` stay on the Rust side.
- **No panic crosses the boundary.** Since Rust 1.81 an uncaught panic in an `extern "C"` function
  aborts the process; on 1.92.0 an out-of-bounds index inside one ends in `panic in a function that
  cannot unwind` and SIGABRT. Boundary code returns error codes instead: no `unwrap`, `expect`, `panic!`
  or slice indexing on a path that can fail.
- **Whoever allocates, frees.** Memory Rust hands to C goes back through an exported `_free` function, not
  C's `free()`; strings C passes in are borrowed through `CStr`; an owned string handed out uses
  `CString::into_raw` and returns through `CString::from_raw`.
- **`unsafe` is denied, not forbidden.** The workspace sets `unsafe_code = "deny"`, which flags every
  `unsafe extern` block, every `#[unsafe(no_mangle)]` function and every `unsafe` block (checked with
  rustc 1.92.0). Each is covered by an `#[allow(unsafe_code)]` on the smallest enclosing item, and each
  `unsafe` block has a `// SAFETY:` comment naming the invariant the caller or the code upholds; a
  missing comment is a review failure.
- **Edition 2024 syntax.** Imported C functions sit in `unsafe extern "C" { ... }` blocks, where an item
  may be marked `safe fn` or `unsafe fn` and an unmarked one is unsafe to call, as in `code/docs/FFI.md`
  Section 3; exported ones carry `#[unsafe(no_mangle)]`.
- **Two suites, both required.** `cargo test` proves the Rust logic; a C test driver built with `check.h`
  proves the boundary as C sees it, and runs under ASan and valgrind too. A crate can pass the first and
  still export a broken boundary.

## Cross-references

### Governing documents

- `code/docs/FFI.md` — ABI and `#[repr(C)]`, both call directions, ownership across the boundary, panics
- `code/docs/RUST-CODING-PRINCIPLES.md` — the lint table, `unsafe` and the `SAFETY:` comment rule
- `code/docs/MEMORY-SAFETY.md` — ownership rules the boundary makes explicit

### Related reading

- `code/workflows/03-rust-exercise/` — crate creation and the three cargo gates reused here
- `code/workflows/02-tdd-cycle/` — the loop both suites are built through
- `code/workflows/06-memory-check/` — ASan, UBSan and valgrind over the C driver
- `code/src/rust/CONTEXT.md` — the workspace the FFI crate joins
- `code/src/c/include/check.h` — the harness the C driver uses
- `code/REFERENCES.md` — the Rustonomicon's FFI chapter, the Rust Reference on `extern` blocks and ABIs,
  and the edition guide's 2024 changes
