---
type: guide
---

# FFI — the C and Rust boundary

**Last Updated**: 27/09/2026 | **Version**: 0.1.0 | **Maintained By**: Sam Bailey
**Language**: British English (en_GB) | **Timezone**: Europe/London

**Stage: P3.** How C and Rust call each other in this repository: the question to answer before crossing the
boundary, the shape of a boundary that stays safe, who frees what, and why every FFI crate needs two test
suites. No FFI crate exists yet — the layout in Section 7, which this guide owns, is planned, and arrives with
the first P3 FFI exercise. The procedure is `code/workflows/04-ffi-bridge/`; the `unsafe` rules this guide
leans on are owned by `code/docs/RUST-CODING-PRINCIPLES.md` Section 4. The code below was built and tested
with the local toolchain (Rust 1.92, gcc 13) before it was written here.

---

## 1. The gate: why cross the boundary?

Answer this before writing a line. Crossing between languages earns its place on one of three grounds:

| Ground | Example |
| --- | --- |
| **Reuse** — working, tested code already exists in the other language | Calling a P2 C library from Rust while porting it piece by piece |
| **A caller in the other language** — the code has to be callable from C | A Rust function a C program links against |
| **The boundary is the lesson** | The P3 exit gate asks for an FFI crate with both test suites green (`project-management/src/01-ROADMAP/ROADMAP.md`) |

If none holds, write the code in one language. Every crossing costs something: the compiler stops
checking types across it, `unsafe` appears, and a second test suite becomes necessary.

---

## 2. Plain code first

Write the logic as ordinary code in its own language, with that language's types, and test it there at
full speed — `check.h` for C, `cargo test` for Rust. Only then add the boundary. Logic that lives inside
an `extern "C"` function can only be reached through raw pointers, which is slower to test and easier to
get wrong.

## 3. A thin boundary

An `extern "C"` function does three things and no more: **validate** what arrived (null pointers,
lengths, UTF-8), **delegate** to the plain function, and **map** the result into something C
understands — a return code, or a value written through an out-pointer.

**Rust called from C.** The exported function is `unsafe` because it dereferences a raw pointer the
caller supplies (clippy's `not_unsafe_ptr_arg_deref` rejects a safe function that does so), and it
carries a `# Safety` section saying what the C caller has to guarantee:

```rust
use std::ffi::{CStr, c_char, c_int};

/// Returns the length of the greeting for `name`, or -1 if `name` is null or not UTF-8.
///
/// # Safety
///
/// `name` must be null or point to a NUL-terminated string that stays valid for the call.
#[allow(unsafe_code)]
#[unsafe(no_mangle)]
pub unsafe extern "C" fn msNNN_greeting_len(name: *const c_char) -> c_int {
    if name.is_null() {
        return -1;
    }
    // SAFETY: `name` is non-null (checked above) and the caller guarantees it points to a
    // NUL-terminated string that stays valid for the duration of this call.
    let name = unsafe { CStr::from_ptr(name) };
    match name.to_str() {
        Ok(name) => c_int::try_from(greeting_len(name)).unwrap_or(-1),
        Err(_) => -1,
    }
}
```

`greeting_len` is the plain function from Section 2, tested on its own. `msNNN` stands for the crate's
milestone number (Section 7 names the prefix). `#[unsafe(no_mangle)]` keeps the symbol name
`msNNN_greeting_len` so the C linker can find it; in edition 2024 the attribute is written
with `unsafe(...)`, and it trips the workspace's `unsafe_code` lint just as an `unsafe` block does —
hence the `#[allow]` on the item.

**C called from Rust.** The C declaration is repeated in an `unsafe extern "C"` block — the `unsafe`
says the author vouches that the signature matches the header — and wrapped in a safe Rust function so
no caller ever touches the raw call:

```rust
use std::ffi::c_int;

#[allow(unsafe_code)]
unsafe extern "C" {
    /// `csrc/add.h`: store `a + b` in `*out`; return 0, or -1 on overflow or a null `out`.
    fn add_checked(a: c_int, b: c_int, out: *mut c_int) -> c_int;
}

/// Adds two numbers in C, returning `None` on overflow.
#[must_use]
pub fn add(a: i32, b: i32) -> Option<i32> {
    let mut out: c_int = 0;
    #[allow(unsafe_code)]
    // SAFETY: `add_checked` matches its C declaration in csrc/add.h, and `out` points to a
    // live, writable `c_int` for the whole call; C keeps no pointer after it returns.
    let rc = unsafe { add_checked(a, b, &raw mut out) };
    (rc == 0).then_some(out)
}
```

**Types that cross.** Use the C types from `std::ffi` — `c_int`, `c_char`, `c_long` — rather than
guessing that `int` is `i32`. A struct that crosses is marked `#[repr(C)]`, which gives it C's field order
and padding; Rust's default layout is unspecified and may reorder fields. A C `enum` crosses as a plain
integer and is converted with `TryFrom`, because a C caller can pass a value no Rust variant matches.

---

## 4. Never panic across the boundary

A panic that reaches an `extern "C"` function does not unwind into C: the process aborts. Checked with
Rust 1.92, a `panic!` inside an exported function prints `panic in a function that cannot unwind` and
the program dies with `SIGABRT` (exit status 134). That is the behaviour the Rust Reference specifies
for a panic reaching a non-unwinding ABI such as `"C"`: letting it unwind into C frames instead would be
undefined behaviour, so Rust aborts.

So every FFI crate closes off the explicit panic sources, on top of the workspace policy, with
crate-level attributes at the top of `src/lib.rs` (Cargo does not let a crate extend the inherited
`[lints]` table — `code/docs/RUST-CODING-PRINCIPLES.md` Section 2):

```rust
#![deny(clippy::panic, clippy::indexing_slicing, clippy::unwrap_used, clippy::expect_used)]
```

`indexing_slicing` is there because `v[i]` panics on a bad index — use `.get(i)`. **The line does not
close every path to a panic.** Checked with clippy 0.1.92, it lets through arithmetic overflow in a debug
build (`a + b`), division or remainder by zero, `unreachable!`, `todo!`, `unimplemented!` and `assert!`,
and any of them reaching an exported function aborts the C caller exactly as above. So code an export
reaches uses `checked_*` arithmetic and returns an error code instead of asserting, as the
`msNNN_checked_add` example in `code/workflows/04-ffi-bridge/` Step 4 does; review checks for it. If a dependency could
panic where you cannot prevent it, catch it at the boundary with `std::panic::catch_unwind` and turn it
into an error code. The `"C-unwind"` ABI, which lets a panic cross deliberately, is out of scope here.

---

## 5. Who owns an allocation

The ownership rules of `code/docs/MEMORY-SAFETY.md` Section 3 apply across the boundary with one
addition: **memory is freed by the same side, and the same allocator, that allocated it.**

- **Borrowed for the call.** A pointer passed in is valid only for the duration of the call; the callee
  never keeps it. Both examples above work this way, and it is the simplest contract.
- **Rust allocates, C holds it for a while.** Hand it over with `CString::into_raw` or `Box::into_raw`,
  and export a matching free function (`msNNN_greeting_free`) that takes it back with `CString::from_raw` or
  `Box::from_raw`. C never calls `free()` on it.
- **C allocates, Rust borrows it.** Rust never drops it; C's `free()` releases it, through the C side's
  own API.
- **Opaque handles** — `thing_new()` / `thing_free()` pairs where C sees only a pointer to an incomplete
  `struct thing` — keep the layout private to the side that owns it.
- **Strings**: `CStr` borrows a C string on the Rust side; `CString` owns one that Rust made, and cannot
  contain an interior NUL.

Every `unsafe` block at the boundary names the ownership fact it relies on in its `SAFETY:` comment, as
the examples do.

---

## 6. Two test suites, both required

| Suite | Runs via | Catches |
| --- | --- | --- |
| **Rust** | `cargo test` / `code/src/scripts/rust/test.sh` | Logic errors, and the boundary as Rust sees it |
| **C** | a `check.h` test driver in the crate's `ctest/`, compiled by `gcc` against the header in `include/` and linked against the crate | A wrong signature in the C header, a struct layout mismatch, a return code C misreads, a leak |

Both are required, because a crate can be entirely correct in Rust and still expose a broken boundary:
the C header is written by hand, and nothing checks it against the Rust signature except a C program that
calls it. The C driver also runs under valgrind, which works on the mixed binary as it does on any other.

For **Rust called from C**, build the crate as a static library and ask rustc which system libraries the
link needs:

```bash
cargo rustc -p msNNN_<snake> --lib -- --print native-static-libs
```

On this machine that prints `-lgcc_s -lutil -lrt -lpthread -lm -ldl -lc`, which go after the `.a` on the
`gcc` link line of the C driver. Write at least one C test per exported function that exercises the
**failure** path (the `NULL` argument, the invalid input), not only the happy path.

---

## 7. The planned crate layout — added at P3

**This section owns the FFI crate layout**; `code/workflows/04-ffi-bridge/` follows it and cites it.
Each FFI exercise is an ordinary member of the Rust workspace, named like every other crate
(`code/src/rust/CLAUDE.md` → Output & naming), so one exercise stays in one folder:

```text
code/src/rust/crates/msNNN_<snake>/    ← planned — added at P3
├── CONTEXT.md · CLAUDE.md             ← the gate answer, the boundary design, commands (tutor mode)
├── Cargo.toml                         ← [lints] workspace = true; cc.workspace = true under [build-dependencies]
├── build.rs                           ← compiles csrc/ with the cc crate (Rust calls C)
├── csrc/                              ← the C half: .c and .h, kernel style (Rust calls C)
├── include/                           ← hand-written C header of the exported functions (C calls Rust)
├── ctest/                             ← the C test driver, test_<name>.c, using check.h
├── src/lib.rs                         ← plain Rust, the thin boundary, the extra #![deny]
└── tests/                             ← Rust-side integration tests
```

- **Exported symbols carry the crate's prefix**, `msNNN_<verb>` (`msNNN_greeting_len`), because C has a
  single global namespace and an unprefixed name can collide with the C library or another crate.
- **Every allocation handed to C has a matching `msNNN_<noun>_free`** (`msNNN_greeting_free`), the one
  way back to the Rust allocator (Section 5).
- A crate uses only the folders its direction needs: `build.rs` and `csrc/` when Rust calls C,
  `include/` and `ctest/` when C calls Rust.

The C half is compiled by `build.rs` through the [`cc`](https://docs.rs/cc/latest/cc/) crate, which runs
the system compiler and links the result as a static archive:

```rust
fn main() {
    println!("cargo::rerun-if-changed=csrc");
    cc::Build::new()
        .file("csrc/add.c")
        .std("c17")
        .flag("-Wpedantic")
        .warnings_into_errors(true)
        .compile("add");
}
```

- `.std("c17")` and `.warnings_into_errors(true)` hold the C half to `-std=c17` and `-Werror`; add the
  rest of the `WARN` set from `code/docs/BUILD.md` Section 2 with further `.flag(...)` calls, so the C in
  a crate meets the same bar as every exercise.
- `cargo::rerun-if-changed=csrc` re-runs the build script when anything in `csrc/` changes; pointing it at
  a directory makes cargo scan the whole folder.
- `cc` is pinned once, in `[workspace.dependencies]` in `code/src/rust/Cargo.toml`, so every FFI crate
  builds with the same one; after that, `cargo add --build cc -p msNNN_<snake>` (run in
  `code/src/rust/`) writes `cc.workspace = true` under the crate's `[build-dependencies]`.
- `cc` is dual-licensed MIT OR Apache-2.0, so it passes `code/src/rust/deny.toml` on its MIT side. Adding
  it is still a supply-chain event: `code/src/scripts/rust/audit.sh` runs before the change merges, and
  `Cargo.lock` records the exact version.

A crate exporting Rust to C adds `crate-type = ["staticlib", "rlib"]` under `[lib]`: `staticlib` for the
C driver to link, `rlib` so the crate's own Rust tests still build.

---

## Cross-references

- `code/workflows/04-ffi-bridge/` — the procedure, from the gate question to both suites green
- `code/docs/RUST-CODING-PRINCIPLES.md` — `unsafe`, `SAFETY:` comments and the lint policy
- `code/docs/MEMORY-SAFETY.md` — ownership in C, which the boundary inherits
- `code/docs/TESTING.md` — `check.h` for the C driver, `cargo test` for the Rust suite
- `code/docs/C-CODING-PRINCIPLES.md` — the style of the C half
- `code/REFERENCES.md` — the Rustonomicon's FFI chapter, `std::ffi`, the `cc` crate and Cargo build
  scripts

_Part of the `code/docs/` documentation family._
