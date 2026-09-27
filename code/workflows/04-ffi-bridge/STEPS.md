---
workflow: 04-ffi-bridge
phase: build
skills: [teach, research]
---

# FFI Bridge — Steps

**Last Updated**: 27/09/2026 | **Version**: 0.1.0 | **Maintained By**: Sam Bailey
**Language**: British English (en_GB) | **Timezone**: Europe/London

---

## Key references

Consult `code/REFERENCES.md` for the external sources (the Rustonomicon's FFI chapter, the Rust Reference
on `extern` blocks and ABIs, the edition guide, the `cc` crate docs) as you work through these steps:

| Step | Section |
| --- | --- |
| 1–2 | `code/docs/FFI.md` — when to cross, ABI, ownership across the boundary |
| 2–5 | `code/docs/FFI.md` Section 7 — the crate layout, symbol prefix and free functions (the owner) |
| 3 | `code/workflows/03-rust-exercise/` Step 2 and `code/workflows/02-tdd-cycle/` |
| 4 | `code/docs/RUST-CODING-PRINCIPLES.md` — `unsafe`, `SAFETY:` comments, the lint table |
| 5 | `code/src/c/include/check.h` and `code/docs/TESTING.md` |
| 6 | `code/workflows/06-memory-check/` and `code/docs/MEMORY-SAFETY.md` |

---

## Steps

### Step 1 — Answer the gate question

Ask the learner: what does crossing the boundary buy here? Acceptable answers name something real — reuse
of a tested C implementation, practice with the C ABI for the kernel phase, the comparison the P3 exit
gate asks for. "Rust would be faster" or "just to see" without a named goal fails the gate: route to
`code/workflows/03-rust-exercise/` instead. An open question about ABI rules can go to the `research`
skill for a primary-source note.

_Done when the answer is written as the opening paragraph of the planned crate's `CONTEXT.md`._

---

### Step 2 — Design the boundary on paper

For each function that crosses, the learner writes down: the direction (Rust calls C, or C calls Rust);
every parameter's C type and whether it is borrowed, owned or an out-parameter; how failure is reported
(this repo's C convention — return `-1`, write results through an out-pointer — as `ms001-hello`'s
`greet()` does); and which side frees each allocation. Names follow `code/docs/FFI.md` Section 7: every
export carries the crate's `msNNN_` prefix, so an exported `msNNN_parse` pairs with `msNNN_result_free`.

_Done when every crossing function has a written signature, ownership note and error convention in the
crate's `CONTEXT.md`._

---

### Step 3 — Write the plain code first

Create the crate as in `code/workflows/03-rust-exercise/` Step 2, laid out as `code/docs/FFI.md`
Section 7 sets out, then run `code/workflows/02-tdd-cycle/`
on the logic alone: ordinary Rust functions (or ordinary C in `csrc/`) with no raw pointers and no
`extern`, returning `Result` or `Option`.

```bash
cd code/src/rust
cargo test -p msNNN_<snake>
```

_Done when the plain logic is fully tested and green with no FFI types anywhere in it._

---

### Step 4 — Add the thin boundary

**C calls Rust.** Build the crate as a static archive as well as a normal Rust library, so both the C
driver and the Rust tests can link it: the `crate-type` line under `[lib]` in `code/docs/FFI.md`
Section 7.

An FFI crate is stricter than the workspace: its `src/lib.rs` opens with the crate-level line from
`code/docs/RUST-CODING-PRINCIPLES.md`, which stacks on the inherited lint table and turns the explicit
panic sources (`panic!`, indexing and slicing, `unwrap`, `expect`) into compile errors:

```rust
#![deny(clippy::panic, clippy::indexing_slicing, clippy::unwrap_used, clippy::expect_used)]
```

It does not catch arithmetic overflow in a debug build, division or remainder by zero, `unreachable!`,
`todo!`, `unimplemented!` or `assert!`; any of those reaching an export still aborts the C caller
(`code/docs/FFI.md` Section 4). Code an export reaches uses `checked_*` arithmetic and returns an error
code, as the example below does.

Each exported function validates, delegates and maps. The shape, on a deliberately trivial example
(`checked_add` is the plain, tested function from Step 3; `c_int` comes from `std::ffi`):

```rust
/// Writes `a + b` to `out`. Returns 0 on success, -1 on overflow or a null `out`.
///
/// # Safety
///
/// `out` is either null or valid for a write of one `c_int`.
#[allow(unsafe_code)]
#[unsafe(no_mangle)]
pub unsafe extern "C" fn msNNN_checked_add(a: c_int, b: c_int, out: *mut c_int) -> c_int {
    let Some(sum) = checked_add(a, b) else {
        return -1;
    };
    if out.is_null() {
        return -1;
    }
    // SAFETY: `out` is non-null (checked above) and the caller guarantees it
    // is valid for one write (see `# Safety`).
    unsafe { out.write(sum) };
    0
}
```

Declare the exported functions for C in a hand-written header in the crate's `include/`.

**Rust calls C.** Compile the C half from `csrc/` with the `build.rs` in `code/docs/FFI.md` Section 7,
through the `cc` crate: pin `cc` once in `[workspace.dependencies]` as that section describes, run
`cargo add --build cc -p msNNN_<snake>` from `code/src/rust/`, then `cargo deny check` before anything
builds, because the next build runs `cc`'s build script (`code/src/rust/CLAUDE.md`); Step 6 repeats the
audit as a gate. Declare the C
functions in an edition 2024 `unsafe extern "C"` block with `#[allow(unsafe_code)]` and a `SAFETY:`
comment stating why each declaration matches the C prototype; a safe Rust wrapper validates inputs and
is the only caller (`code/docs/FFI.md` Section 3 shows both directions).

_Done when every boundary function is a thin wrapper over tested plain code, every `unsafe` item or block
is covered by an `#[allow(unsafe_code)]` on the smallest enclosing item, and every `unsafe` block has its
own `SAFETY:` comment._

---

### Step 5 — Write both test suites

**Rust suite:** unit tests for the logic, plus tests that call each boundary function with a null pointer,
an out-of-range value and a valid call, asserting the return codes.

**C suite:** a driver in the crate's `ctest/` using `check.h`, calling the exported functions exactly as a
C program would. Build the archive, ask rustc which system libraries it needs, then link:

```bash
cd code/src/rust
cargo build -p msNNN_<snake>
cargo rustc -p msNNN_<snake> --lib -- --print native-static-libs   # note the -l list it prints
gcc -std=c17 -Wall -Wextra -Wpedantic -Wshadow -Wconversion -Wstrict-prototypes -Wformat=2 -Werror \
    -g3 -O0 -I ../c/include -I crates/msNNN_<snake>/include \
    crates/msNNN_<snake>/ctest/test_<name>.c target/debug/libmsNNN_<snake>.a \
    -lpthread -lm -ldl -o target/test_<name>
./target/test_<name>
```

Replace the `-l` flags with the list rustc printed. The binary lands in `target/`, which git ignores.

_Done when both suites pass, and each boundary function has at least one C test of its failure path._

---

### Step 6 — Run the memory tools and the gates

Rebuild the C driver with the sanitiser flags from `code/src/c/mk/flags.mk` added
(`-fsanitize=address,undefined -fno-omit-frame-pointer -fno-sanitize-recover=all`) and run it; then run
the plain driver under valgrind:

```bash
valgrind --leak-check=full --show-leak-kinds=all --errors-for-leak-kinds=all --error-exitcode=1 \
    ./target/test_<name>
```

Read any report with `code/workflows/06-memory-check/`. Then the cargo gates and, if a dependency was
added, the supply-chain gate:

```bash
cargo fmt --check
cargo clippy --all-targets -- -D warnings
cargo test -p msNNN_<snake>
cargo deny check
```

Scripts: `bash code/src/scripts/rust/lint.sh`, `test.sh` and `audit.sh`.

Do not proceed to Step 7 until every command above exits 0.

_Done when the C driver is clean under ASan + UBSan and valgrind, and every cargo gate passes._

---

### Step 7 — Record the learning note and hand back

The learner writes a note in the matching `learning/rust-NN-<topic>/NOTES/` folder — what the gate answer
was, which ownership rule was hardest to keep, what the C suite caught that the Rust suite could not — and
the `teach` skill logs it. Commit with scope `rust`, staging the crate folder and `Cargo.lock` by name,
then return to `project-management/workflows/10-study-and-build/`.

_Done when the note exists, the work is committed without `target/`, and the PM step has the result._

---

## Update context files

1. Add the crate to the tree in `code/src/rust/CONTEXT.md`, and the folders it uses from the
   `code/docs/FFI.md` Section 7 layout to the crate's own `CONTEXT.md` tree.
2. Add any new external source (a crate's docs, an ABI reference) to `code/REFERENCES.md`.
3. Refresh `**Last Updated**` in every `CONTEXT.md` you modified.
4. If the session ends before Completion, run `/handoff` to write
   `handoffs/HANDOFF-<SCREAMING-KEBAB-DESCRIPTOR>-DD-MM-YYYY.md`.

---

## Completion

Run through `CHECKLIST.md` before marking this workflow complete.
