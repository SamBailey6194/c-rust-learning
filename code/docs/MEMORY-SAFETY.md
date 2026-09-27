---
type: guide
---

# Memory Safety and Undefined Behaviour

**Last Updated**: 27/09/2026 | **Version**: 0.1.0 | **Maintained By**: Sam Bailey
**Language**: British English (en_GB) | **Timezone**: Europe/London

C will let a program read memory it does not own, free the same block twice, or overflow a signed
integer, and it will usually say nothing when it happens. This guide covers what those bugs are, who is
responsible for each allocation, the three tools that find them — AddressSanitizer with
UndefinedBehaviorSanitizer, valgrind's memcheck, and gcc's `-fanalyzer` — and why the first two are never
run on the same binary. The flags and make targets belong to `code/docs/BUILD.md`; reading the reports
line by line is in `code/docs/DEBUGGING.md`; the procedure that runs all three tools is
`code/workflows/06-memory-check/`.

---

## 1. What undefined behaviour means

The C standard defines undefined behaviour as behaviour "for which this document imposes no
requirements" (C17 clause 3.4.3). That does not mean "it crashes". It may appear to work, crash much
later somewhere unrelated, or change when the optimisation level changes, because the compiler is
entitled to assume it never happens — and to delete code on that assumption. A check such as
`if (x + 1 < x)` on a signed `x` can be removed outright, since signed overflow "cannot" occur.

Two consequences shape everything below:

- **A clean run proves only that the paths the tests took were clean.** Every tool here watches the code
  that actually executes, so the tools and the tests (`code/docs/TESTING.md`) work as a pair.
- **"It works on my machine" is not evidence.** Undefined behaviour that happens to produce the right
  answer today is still a bug.

The standard's two milder cases — implementation-defined and unspecified behaviour — are described in
`code/docs/C-CODING-PRINCIPLES.md` Section 4.

---

## 2. The bug classes

| Class | What it looks like in C | Caught by | How Rust answers it |
| --- | --- | --- | --- |
| Out-of-bounds access | `buf[len]`; copying 20 bytes into 16 | ASan: heap, stack and globals. valgrind: heap only. UBSan `bounds`: arrays of known size. `-fanalyzer` for some | Indexing is bounds-checked and panics; `.get(i)` returns an `Option` |
| Use after free | reading through a pointer after `free()` | ASan, valgrind, `-fanalyzer`; `-Wuse-after-free` (in `-Wall`) for obvious cases | The borrow checker: no reference outlives its owner |
| Double free | `free(p)` twice, or two owners both freeing | ASan, valgrind, `-fanalyzer` | One owner; `Drop` runs exactly once |
| Leak (a bug, not UB) | an allocation nobody frees | LeakSanitizer (part of ASan, at exit), valgrind, `-fanalyzer` | Freed when the owner goes out of scope; a leak takes a deliberate `Box::leak` or an `Rc` cycle |
| Uninitialised read | a local, or `malloc`ed memory, read before it is written | valgrind (add `--track-origins=yes` to see where the value came from); `-Wuninitialized`, `-Wmaybe-uninitialized`; `-fanalyzer`. **Not ASan** | A compile error |
| Signed integer overflow | `INT_MAX + 1` (unsigned arithmetic wraps, and is defined) | UBSan `signed-integer-overflow` | Debug builds panic; release builds wrap. Say which you mean: `checked_add`, `wrapping_add`, `saturating_add` |
| Strict-aliasing violation | reading a `float` through an `int *` | No sanitiser. `-Wstrict-aliasing` is in `-Wall` but only active when `-fstrict-aliasing` is, which gcc enables from `-O2` | Reinterpreting memory takes `unsafe`; safe code uses `f32::to_bits` and friends |
| Data race | two threads, at least one writing, no synchronisation | ThreadSanitizer (`-fsanitize=thread`, a separate build that cannot be combined with ASan); valgrind's `helgrind` and `drd` tools | `Send` and `Sync` make a data race a compile error in safe Rust |
| `NULL` dereference | `*p` where `p` is `NULL` | UBSan `null`, `-fanalyzer`, and usually `SIGSEGV` | References are never null; absence is `Option<&T>` |

Two gaps in that table matter. **ASan does not see uninitialised reads** (gcc has no MemorySanitizer), and
**valgrind does not see overruns of stack or global arrays** — both confirmed with the local toolchain.
That is why both tools run. **The strict-aliasing rule** allows any object to be read through a
character type, so the portable way to reinterpret bytes is `memcpy` into an object of the other type;
the kernel sidesteps the question by building with `-fno-strict-aliasing`.

The right-hand column is the case for Rust in one table, and the reason P3 exists: each row is a bug the
Rust compiler refuses, or turns into a panic, instead of leaving to a tool.

---

## 3. Who owns an allocation

Most memory bugs in C are ownership bugs: two parts of the program disagree about who frees a block, or
when. Make ownership explicit.

- **Every allocation has exactly one owner** — the code responsible for freeing it. The header comment
  says who: _"the caller frees the returned string with `free()`"_.
- **Prefer a caller-supplied buffer.** `greet(buf, len, name)` writes into memory the caller owns and
  never allocates, so ownership never moves. It is the simplest pattern there is.
- **If a function allocates and returns, the caller frees.** Say so in the header, and give the
  function a name that says it allocates.
- **Structures with inner allocations get a create/destroy pair** — `list_new()` and `list_free()` —
  so no caller needs to know what is inside.
- **After `free(p)`, set `p = NULL`** when the pointer outlives the call. `free(NULL)` is a no-op, so a
  second free becomes harmless instead of undefined.
- **Every length says whether it counts the terminating NUL.** `snprintf` returns the length it _would_
  have written; a result `>= len` means truncation, which is exactly how `greet()` detects it.
- **Bounded functions only.** `snprintf` and `memcpy` with a checked length, never `strcpy`, `strcat`
  or `sprintf` into a fixed buffer. `gets` was removed from the language in C11.
- **`sizeof` a parameter is the size of a pointer.** Inside `void f(char *buf)`, `sizeof(buf)` is 8 on
  x86-64, whatever the caller passed; pass the length alongside the pointer.

---

## 4. The tools

### AddressSanitizer and UndefinedBehaviorSanitizer — `make san`

Compile-time instrumentation: every load and store is checked against a shadow map of valid memory, and
UBSan adds run-time checks for overflow, bad shifts, misaligned or `NULL` pointers, and more. The
AddressSanitizer documentation puts the slowdown at about 2x, which makes it cheap enough to run on every
change.

```bash
make -C code/src/c/ms001-hello san                                 # the target
bash code/src/scripts/c/san.sh --path ms001-hello                  # the gate script
```

- **ASan stops at its first error** and exits 1; its LeakSanitizer half reports leaks when the program
  exits, also exiting 1.
- **UBSan recovers by default**: it prints `file:line:col: runtime error: ...` and carries on, and the
  program can still exit 0. The build adds `-fno-sanitize-recover=all` so the first report is fatal
  (`code/docs/BUILD.md` Section 2). When you compile by hand without it, read the output, not only the
  exit status — or set `UBSAN_OPTIONS=halt_on_error=1`.
- **Run-time options** go in `ASAN_OPTIONS` and `UBSAN_OPTIONS`: `ASAN_OPTIONS=help=1` lists them, and
  `UBSAN_OPTIONS=print_stacktrace=1` adds a stack to each UBSan report.
- The sanitised build lives in its own tree, `build/san/`.

### valgrind memcheck — `make memcheck`

No recompilation: valgrind runs the ordinary binary on a synthetic CPU and watches every byte. Its manual
warns of programs running 20 to 30 times slower. Raw, on the plain test binary, from inside
`code/src/c/ms001-hello/` once `make` has built it:

```bash
valgrind --leak-check=full --show-leak-kinds=all --errors-for-leak-kinds=all --error-exitcode=1 \
    ./build/test_greet
```

| Flag | valgrind's default | Why it is changed here |
| --- | --- | --- |
| `--leak-check=full` | `summary` | Show each leak with the stack that allocated it |
| `--show-leak-kinds=all` | `definite,possible` | Also show indirectly lost and still-reachable blocks |
| `--errors-for-leak-kinds=all` | `definite,possible` | Count every kind as an error: memory still reachable at exit was never freed either |
| `--error-exitcode=1` | `0`, meaning off | Without it valgrind exits with the program's own status, so a leaking run "passes" |

The four leak kinds, paraphrasing the memcheck manual: **definitely lost** (no pointer to the block
remains), **indirectly lost** (reachable only through a lost block), **possibly lost** (only an interior
pointer remains), **still reachable** (a pointer remains at exit, but nothing freed it). When chasing an
uninitialised value, add `--track-origins=yes` by hand; it is slower, and it names the allocation or
stack frame the bad value came from. The gate script is `code/src/scripts/c/memcheck.sh`.

### `-fanalyzer` — `make lint`

Static analysis at compile time: gcc follows paths through and across functions looking for double
free, use after free, leaks, `NULL` dereference, file-descriptor leaks and more, without running
anything. Its own manual is candid that it is "neither sound nor complete" — it can miss bugs and it can
report paths that cannot happen — and that in gcc 13 it is suitable only for C. It is also slow, so it
runs only for `make lint`, into `build/lint/`. Its findings are `-Wanalyzer-*` warnings, which `-Werror`
makes fatal.

```bash
cd code/src/c/ms001-hello && mkdir -p build/raw     # gcc does not create the output folder
gcc -std=c17 -Wall -Werror -fanalyzer -I../include -c greet.c -o build/raw/greet.o
```

---

## 5. Why ASan and valgrind never mix

Both take over `malloc` and `free` and track the state of every byte, in incompatible ways: ASan through
code compiled into the program and a shadow map reserved at fixed addresses, valgrind by running the
program on its own synthetic CPU with its own allocator. Run an ASan binary under valgrind and they fight
over the same memory — with valgrind 3.22 and a gcc 13 ASan binary, the ASan runtime refuses to start
("ASan runtime does not come first in initial library list") and nothing is checked at all.

So there are two build trees: the plain build in `build/`, which `make memcheck` runs under valgrind, and
the sanitised one in `build/san/`, which `make san` runs on its own. `code/src/c/mk/exercise.mk` keeps
them apart.

They are complements, not rivals:

| | ASan + UBSan | valgrind memcheck |
| --- | --- | --- |
| Needs a special build | yes | no — any binary with `-g` |
| Stack and global array overruns | yes | no |
| Uninitialised reads | no | yes |
| Undefined behaviour beyond memory (overflow, shifts) | yes, via UBSan | no |
| Speed | about 2x slower | about 20 to 30x slower |

---

## 6. What "clean" means

An exercise is memory-clean when `make san`, `make memcheck` and `make lint` all exit 0 — and, for any
run you did by hand, when no `runtime error:` line appeared in the output. Where these runs sit among the
other gates, and in what order, is owned by `how-to/workflows/03-quality-gates/`.

---

## Cross-references

- `code/workflows/06-memory-check/` — the procedure that runs all three tools and loops until clean
- `code/docs/DEBUGGING.md` — reading an ASan, UBSan, valgrind or analyser report
- `code/docs/BUILD.md` — the `SAN`, `SAN_HALT`, `ANALYZE` and `VALGRIND_FLAGS` definitions
- `code/docs/C-CODING-PRINCIPLES.md` — error handling and the cleanup ladder that prevents leaks
- `code/docs/FFI.md` — ownership when memory crosses between C and Rust
- `code/REFERENCES.md` — the GCC instrumentation options, the sanitiser and valgrind manuals

_Part of the `code/docs/` documentation family._
