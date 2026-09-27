---
type: guide
---

# Build — gcc, make and cargo

**Last Updated**: 27/09/2026 | **Version**: 0.1.0 | **Maintained By**: Sam Bailey
**Language**: British English (en_GB) | **Timezone**: Europe/London

This guide **owns the build flags and the make targets**: every flag the C exercises compile with, what
each target does, how an exercise Makefile works, and the cargo commands for the Rust workspace. The
implementation is `code/src/c/mk/flags.mk` and `code/src/c/mk/exercise.mk`, whose comments say why each
line exists at the point where it is set; this is the full reasoning. Each section shows the **raw command
first** — the command is the lesson — and then the script in `code/src/scripts/` that wraps it for CI and
for Claude's own verification. Tool versions are recorded in `how-to/docs/TOOLCHAIN.md`; every gcc flag
below was checked against the gcc 13 manual installed with the compiler (`man gcc`).

---

## 1. From source to binary, by hand

gcc runs four stages. Seeing each once explains most error messages you will meet later — a missing
declaration is a compile error, a missing definition is a link error. From the reference exercise, into a
scratch folder inside the gitignored `build/`:

```bash
cd code/src/c/ms001-hello
mkdir -p build/raw
gcc -std=c17 -E greet.c -o build/raw/greet.i    # 1. preprocess: #include and macros expanded
gcc -std=c17 -S greet.c -o build/raw/greet.s    # 2. compile: C to assembly
gcc -std=c17 -c greet.c -o build/raw/greet.o    # 3. assemble: an object file, not yet runnable
gcc -std=c17 -c main.c -o build/raw/main.o
gcc build/raw/greet.o build/raw/main.o -o build/raw/hello   # 4. link: objects into a program
./build/raw/hello Sam
```

`greet.i` runs to hundreds of lines — that is what `#include <stdio.h>` really pastes in. The test
program, with the full flag set this repository uses:

```bash
gcc -std=c17 -Wall -Wextra -Wpedantic -Wshadow -Wconversion -Wstrict-prototypes -Wformat=2 -Werror \
    -g3 -O0 -I../include greet.c test_greet.c -o build/raw/test_greet
./build/raw/test_greet
```

That is what `make test` does, split into one compile per file so that only changed files are rebuilt.
Keep hand-built files in `build/raw/`: make's own objects in `build/` are judged by their timestamps, and
an object you compiled by hand with fewer flags could be mistaken for an up-to-date one.

---

## 2. Every flag, and why

The variables in `code/src/c/mk/flags.mk`, each holding one kind of flag so a target can combine exactly
the sets it needs:

| Variable | Flag | What it does (gcc 13 manual) | Why it is here |
| --- | --- | --- | --- |
| `CC` | `gcc` | The compiler | GNU make predefines `CC` as `cc`, so `flags.mk` undefines that default first; `make CC=clang` still overrides it |
| `CSTD` | `-std=c17` | ISO C17 with GNU extensions off (gcc 13 defaults to `gnu17`) | Portable C, not GNU C; ADR-MS001-C-STANDARD-C17 |
| `WARN` | `-Wall` | A broad set of "questionable and easy to avoid" warnings — not, despite the name, all of them | The baseline |
| | `-Wextra` | More: unused parameters, signed/unsigned comparisons, missing field initialisers, implicit fall-through | Catches the next layer of slips |
| | `-Wpedantic` | Every diagnostic ISO C requires for the chosen `-std`: GNU extensions in their plain spelling (statement expressions, zero-length arrays) are rejected, but the `__attribute__`/`__typeof__` spellings and anything after `__extension__` are not — "some non-ISO practices, but not all" | Makes `-std=c17` bite (`code/docs/C-CODING-PRINCIPLES.md` Section 4) |
| | `-Wshadow` | A local that hides another variable, parameter or global | "I set it, and nothing changed" |
| | `-Wconversion` | Implicit conversions that can change a value; in C this includes signed/unsigned | Silent truncation is a classic C bug |
| | `-Wstrict-prototypes` | A function declared without parameter types | `int f()` is not `int f(void)` in C17 |
| | `-Wformat=2` | `-Wformat` plus `-Wformat-nonliteral`, `-Wformat-security`, `-Wformat-y2k` | `printf` argument mismatches, and format strings that are not literals |
| | `-Werror` | Every warning becomes an error | A warning that can be ignored will be |
| `DBG` | `-g3` | The most debug information, including macro definitions (`-g` alone is level 2) | gdb can step, print locals, and expand macros |
| | `-O0` | No optimisation, "make debugging produce the expected results" | Every line maps to the code that runs; reports point at the real line |
| `SAN` | `-fsanitize=address,undefined` | AddressSanitizer and UndefinedBehaviorSanitizer | Run-time memory and UB checks (`make san`) |
| | `-fno-omit-frame-pointer` | Keep the frame pointer | Complete sanitiser stack traces |
| `SAN_HALT` | `-fno-sanitize-recover=all` | Make the first recoverable sanitiser error fatal | UBSan otherwise prints its report and carries on |
| `ANALYZE` | `-fanalyzer` | gcc's static analyser: path-by-path search for leaks, double free, use after free, NULL dereference | Finds bugs without running the code (`make lint`) |
| `DEPFLAGS` | `-MMD` | While compiling `foo.c`, write `foo.d`: a make rule listing the project headers it includes | Editing a header rebuilds every object that uses it |
| | `-MP` | Add an empty rule for each header | Deleting a header does not break the build |
| `VALGRIND_FLAGS` | `--leak-check=full`, `--show-leak-kinds=all`, `--errors-for-leak-kinds=all`, `--error-exitcode=1` | Full leak report, every leak kind counted as an error, exit 1 on any error | `make memcheck` fails on anything valgrind finds (`code/docs/MEMORY-SAFETY.md` Section 4) |

Notes that the table cannot hold:

- **`-O0` has a cost.** A few warnings, `-Wmaybe-uninitialized` among them, depend on the optimiser's
  data-flow analysis, and the manual says so. Now and then run
  `make -C code/src/c/ms001-hello clean all DBG="-g3 -O2"` to see whether anything new appears.
- **`-fno-omit-frame-pointer` is belt and braces at `-O0`.** gcc only starts omitting frame pointers at
  `-O1`; the flag keeps sanitiser traces complete if `DBG` ever changes.
- **UBSan's default is to recover.** Checked with gcc 13: without `SAN_HALT`, a signed overflow prints
  `runtime error: ...` and the program still exits 0, so a test run would pass. With it, the first report
  exits non-zero. AddressSanitizer stops at its first error either way.
- **Sanitiser flags go on the link line too** — linking is what pulls in the sanitiser runtimes.
- **Any variable can be overridden for one run**, which is the quickest way to see what a flag does:
  `make -C code/src/c/ms001-hello clean all WARN=-Wall` shows how much less is caught.

---

## 3. The make targets

From the top, `make -C code/src/c <target>` walks every `ms[0-9][0-9][0-9]-*/` folder that holds a
`Makefile`, in name order (a folder without one, such as a `build/` left behind by another branch, is
skipped with a warning), stops at the first exercise that fails, and prints the command to re-run it
alone. For one exercise: `make -C code/src/c/ms001-hello <target>`.

| Target | Builds | Then runs | Output |
| --- | --- | --- | --- |
| `all` (default) | `build/<PROG>` and every `build/test_*` with `CSTD WARN DBG` | nothing | `build/` |
| `test` | every `build/test_*` (not `build/<PROG>`) | each `build/test_*`; the first failure stops the run | `build/` |
| `san` | everything again with `SAN SAN_HALT` added | each sanitised test binary | `build/san/` |
| `memcheck` | every `build/test_*`, not `build/<PROG>` (never the sanitised build) | each test binary under valgrind with `VALGRIND_FLAGS` | `build/` |
| `lint` | every source compiled with `ANALYZE` (objects only, nothing linked or run) | nothing | `build/lint/` |
| `clean` | nothing | deletes `build/` | none |

- **`test` and `memcheck` never compile the `MAIN` file.** A test binary links every `SRCS` file except
  `MAIN`, which is what lets `code/workflows/01-c-exercise/` run tests before `main.c` exists. So a
  `main.c` that does not compile still passes `make test`; `make` (`all`), `san` and `lint` are the
  targets that compile it.
- **`test`, `san` and `memcheck` fail when an exercise has no tests.** A test gate with nothing to run
  would pass having checked nothing; `check_summary()` likewise returns 1 when no checks ran.
- **Objects depend on the makefiles as well as the sources**, so a flag change in `flags.mk` rebuilds
  everything rather than leaving objects compiled under the old flags.
- **Useful make options**: `-n` prints the commands without running them (the best way to learn what a
  target does), `-B` rebuilds everything, `-C <dir>` runs in another folder.

The script for each target takes the same `--path` to narrow it to one exercise:

| Target | Script |
| --- | --- |
| `all` | `code/src/scripts/c/build.sh [--path ms001-hello]` |
| `test` | `code/src/scripts/c/test.sh [--path ...]` |
| `san` | `code/src/scripts/c/san.sh [--path ...]` |
| `memcheck` | `code/src/scripts/c/memcheck.sh [--path ...]` |
| `lint` | `code/src/scripts/c/lint.sh [--path ...]` |

---

## 4. How an exercise Makefile works

An exercise Makefile only names things. The rules live once, in `mk/exercise.mk`:

```make
PROG      := hello
SRCS      := greet.c main.c
TEST_SRCS := test_greet.c

include ../mk/exercise.mk
```

- **`PROG`** is the program, built as `build/hello`.
- **`SRCS`** is every source of the program, `main.c` included. `MAIN` (default `main.c`) names the file
  that holds `main()`; every other file in `SRCS` is the "library" part that each test binary links
  against, which is how a test calls `greet()` without the program's own `main()`.
- **`TEST_SRCS`** lists one test binary per file, each with its own `main()`: `test_greet.c` becomes
  `build/test_greet`.
- **`include ../mk/exercise.mk`** pulls in `flags.mk`, the include path for `code/src/c/include/`, the
  six targets, and the `.d` dependency files that `-MMD -MP` wrote on the previous build.

The make features it leans on, each worth knowing by name:

| Feature | Meaning |
| --- | --- |
| `:=` / `=` / `?=` / `+=` | Assign once, now / expand lazily on every use / assign only if unset / append |
| `$@`, `$<`, `$^` | The target, its first prerequisite, all its prerequisites |
| Static pattern rule `$(OBJS): build/%.o: %.c` | A pattern that applies only to the listed targets |
| Order-only prerequisite `\| build` | The folder has to exist, but its timestamp never forces a rebuild |
| `.PHONY` | Targets that are commands, not files |
| `.DELETE_ON_ERROR` | A recipe that fails half-way deletes its half-written target |
| `-include` | Include if present, and carry on quietly if not |
| Recipe lines | Start with a **tab**, never spaces |

A new exercise copies this Makefile and changes the three names; the full procedure is
`code/workflows/01-c-exercise/`.

---

## 5. The Rust workspace

`code/src/rust/` is one Cargo workspace; every crate in `crates/` is a member, sharing one `Cargo.lock`
(committed), one `target/` (gitignored) and one lint policy (`code/docs/RUST-CODING-PRINCIPLES.md`). Run
cargo **from inside `code/src/rust/`**:

| Task | Raw command | Script |
| --- | --- | --- |
| Build every crate and target | `cargo build --workspace --all-targets` | `code/src/scripts/rust/build.sh` |
| Run the reference binary | `cargo run -p ms001_hello -- Sam` | none |
| Test (unit, integration, doc) | `cargo test --workspace` | `code/src/scripts/rust/test.sh [--crate ms001_hello]` |
| Check formatting | `cargo fmt --all --check` | `code/src/scripts/rust/lint.sh` |
| Lint | `cargo clippy --workspace --all-targets -- -D warnings` | `code/src/scripts/rust/lint.sh` |
| Supply-chain policy | `cargo deny check` | `code/src/scripts/rust/audit.sh` |

**Why from inside the folder.** rustup looks for `rust-toolchain.toml` in the **current directory** and
its parents, so only a run from `code/src/rust/` is guaranteed to use the pinned compiler. The root-level
form `cargo test --manifest-path code/src/rust/Cargo.toml` works, but builds with whatever your default
toolchain is — the same compiler today, a different one after the next `rustup update`. The scripts
change into the folder before running cargo for exactly this reason.

A debug build lands in `target/debug/` (the binary is `target/debug/ms001_hello`); `--release` builds an
optimised one in `target/release/`.

---

## 6. The scripts, and how they report

The scripts in `code/src/scripts/` wrap the commands above and add one thing: an exit-code contract that
CI and Claude's verification rely on. Every script prints its usage with `--help`, and exits:

| Exit | Meaning |
| --- | --- |
| 0 | Pass |
| 1 | The gate ran and found failures |
| 2 | **COULD NOT RUN** — bad arguments, or a tool is missing. Never reported as a pass |

`code/src/scripts/toolchain/check.sh` prints a `| Tool | Version |` table and exits 2 if a required tool
is missing. `code/src/scripts/gates/all.sh` runs every scripted gate in turn and exits with the worst result; the
order of the gates, and the procedure around them, are owned by `how-to/workflows/03-quality-gates/`.
In CI, `Syntax — C` and `Syntax — Rust` call the same scripts.

---

## 7. Changing the build

A flag, a target or the toolchain changes by decision, not by drift. Write the ADR in
`project-management/src/08-DECISIONS/` first — a new ADR supersedes an old one, never an edit to it —
then change the file, then update this guide in the same commit.

| Change | ADR it supersedes | File |
| --- | --- | --- |
| The C standard | `ADR-MS001-C-STANDARD-C17-27-09-2026.md` | `code/src/c/mk/flags.mk` |
| The build system | `ADR-MS001-BUILD-SYSTEM-GNU-MAKE-27-09-2026.md` | `code/src/c/mk/` |
| The Rust edition or toolchain | `ADR-MS001-RUST-EDITION-2024-TOOLCHAIN-PIN-27-09-2026.md` | `code/src/rust/rust-toolchain.toml` |

Bumping the pinned toolchain follows `how-to/workflows/04-toolchain-updates/`.

---

## Cross-references

- `code/docs/MEMORY-SAFETY.md` — what the sanitiser, valgrind and analyser builds find
- `code/docs/TESTING.md` — what the test binaries contain
- `code/docs/DEBUGGING.md` — using the `-g3 -O0` build in gdb
- `code/src/c/mk/flags.mk` and `code/src/c/mk/exercise.mk` — the implementation
- `code/src/scripts/CONTEXT.md` — every script and its options
- `how-to/docs/TOOLCHAIN.md` — the installed versions
- `code/REFERENCES.md` — the GCC and GNU make manuals

_Part of the `code/docs/` documentation family._
