# ADR-MS001: C build system — plain GNU make with shared `mk/` includes

| Field | Value |
| --- | --- |
| **ID** | ADR-MS001-BUILD-SYSTEM-GNU-MAKE |
| **Status** | Accepted |
| **Date** | 27/09/2026 |
| **Milestone** | MS001 — Toolchain ready · `project-management/src/02-MILESTONES/MS001-TOOLCHAIN-READY.md` |
| **Deciders** | Sam Bailey |
| **Supersedes** | — |
| **Superseded by** | — |
| **Research** | — (primary sources cited below) |
| **Enforced in** | `code/src/c/Makefile` · `code/src/c/mk/flags.mk` · `code/src/c/mk/exercise.mk` · documented in `code/docs/BUILD.md` |

---

## Context

This is one of five scaffold defaults accepted on 27/09/2026 together with the repository skeleton,
before the first exercise was written. It records the choice and the evidence available that day.
Like every Accepted ADR it is immutable: a different build system later means a new ADR that
supersedes this one, and this record stays as written.

Every C exercise needs the same six targets — build, run the tests, run them under AddressSanitizer
and UndefinedBehaviorSanitizer, run them under valgrind, compile with gcc's static analyser, and
clean — with one set of flags shared by all of them. Each exercise is small and independent: a
handful of `.c` files, one or more `test_*.c` files and no dependency on another exercise. The
learner at P1 is also learning what a build system is for: turning sources into objects and
binaries, knowing which objects are stale when a header changes, and not rebuilding what is current.

Facts checked on the host on 27/09/2026:

- **Installed:** GNU make 4.3.
- **Not installed:** CMake, Meson, Ninja and Bear. Ubuntu 24.04 offers them (CMake 3.28.3,
  Meson 1.3.2, Bear 3.1.3), so the absence is a choice, not a hard wall — but each would be a new
  dependency on the host and in CI.
- **The kernel builds with make.** Kbuild is a set of GNU make files; the kernel's minimal
  requirements list GNU make 4.0. An out-of-tree module — P4's first kernel code — is built with
  `make -C <path_to_kernel_dir> M=$PWD`, from a `Kbuild`/`Makefile` naming `obj-m` targets.
- **gcc writes header dependencies itself.** `-MMD` emits a `.d` make rule listing the project
  headers each source includes, and `-MP` adds an empty rule per header so deleting one does not
  break the build (gcc manual, Preprocessor Options). GNU make can include those files directly.
- **No `compile_commands.json`.** Language servers such as clangd read that file for per-file flags.
  Plain make does not write it; CMake (`CMAKE_EXPORT_COMPILE_COMMANDS`) and Meson do, and Bear can
  capture it from a make run. clangd is not installed either, so nothing on the host needs the file
  today.

## Options considered

### Option A — Plain GNU make with shared includes

- **Summary:** `code/src/c/mk/flags.mk` holds every flag once; `code/src/c/mk/exercise.mk` holds the
  rules once. Each exercise `Makefile` sets `PROG`, `SRCS` and `TEST_SRCS` and includes
  `../mk/exercise.mk`. `make -C code/src/c <target>` walks every `ms###-*/` exercise;
  `make -C code/src/c/ms001-hello <target>` runs one.
- **Pros:** Already installed, locally and on the CI image. The Makefile is itself a lesson — targets,
  prerequisites, automatic variables, pattern rules, `-MMD -MP` dependency files — and every compiler
  command it runs can be read in full, which is what the docs teach first. It is the same tool the
  kernel builds with, so Kbuild at P4 is an extension of known ground rather than a new system. No
  generator step sits between the learner and the compiler.
- **Cons:** GNU-make-specific syntax (`:=`, `?=`, `$(wildcard ...)`, `undefine`) ties the build to GNU
  make, which is acceptable on a Linux-only repository. No `compile_commands.json` for editor tooling.
  Recursing into sub-directories has well-known pitfalls (Peter Miller's "Recursive Make Considered
  Harmful"): the top level cannot see dependencies across directories.

### Option B — CMake, generating Ninja or Makefiles

- **Summary:** A `CMakeLists.txt` per exercise, configured once into a build directory.
- **Pros:** The most common build generator for C and C++ projects outside the kernel. CTest for test
  running. Writes `compile_commands.json` on request. Out-of-source builds by design.
- **Cons:** Not installed. A second language to learn before C itself. The compiler command line is
  generated: `cmake --build build --verbose` shows it, but the learner reads CMake's output rather
  than writing the rule. Sanitiser and valgrind targets still need custom configuration. The kernel
  does not use it, so it adds nothing to P4.

### Option C — Meson with Ninja

- **Summary:** A `meson.build` per exercise; `meson setup` then `meson test`.
- **Pros:** Clean syntax. Sanitisers are a built-in option (`b_sanitize`), `meson test --wrapper=valgrind`
  runs tests under valgrind, `meson test --gdb` under gdb, and the Ninja backend writes
  `compile_commands.json` into the build directory without being asked.
- **Cons:** Not installed, and brings Python and Ninja with it. Another language between the learner
  and the compiler. Not what the kernel uses.

### Option D — Shell scripts that call gcc directly

- **Summary:** `code/src/scripts/c/build.sh` compiles every file every time.
- **Pros:** Zero build tooling; every command visible.
- **Cons:** No incremental builds, no header dependency tracking — it reimplements the part of make
  that matters, badly. The scripts layer exists to wrap make targets for CI, not to replace them.

## Decision

**We will take Option A: plain GNU make, with flags and rules defined once in `code/src/c/mk/`.**
The deciding factor is that make is both the lesson and the destination: it is already installed,
it keeps every compiler command in plain sight, and it is the tool Kbuild is built from. Options B
and C are better build *generators*, but at P1 a generator hides the very thing being learned and
adds a dependency the repository does not otherwise need. Option D throws away incremental builds.

The recursive-make critique is noted and does not bite here, because exercises share no code and so
have no cross-directory dependencies for the top level to miss.

This answer changes if exercises start depending on each other (for example, a shared library that
later exercises link against) or if editor tooling that needs `compile_commands.json` becomes part
of the daily loop. Either would be argued in a new ADR that supersedes this one.

## Consequences

- **Positive:** `make -C code/src/c test` works from the repository root, and one exercise builds on
  its own with `make -C code/src/c/ms001-hello test`. Flags live once in `code/src/c/mk/flags.mk`,
  so adding a warning is a one-line change. `-MMD -MP` makes header edits rebuild the right objects
  without hand-maintained lists. Build output stays in each exercise's `build/` folder, which is
  gitignored. The scripts under `code/src/scripts/c/` wrap these targets for CI.
- **Negative:** No `compile_commands.json`, so a future clangd setup needs `bear -- make` or a new
  decision. The build is GNU-make-only. The learner maintains `mk/exercise.mk`, which is more to
  understand than a one-line CMake target — deliberately.
- **Follow-on:** `code/docs/BUILD.md` owns the targets and flags and teaches the raw commands first.
  At P4, out-of-tree modules are built with Kbuild through the kernel's own make; how that is wired
  into this repository is a P4 decision, taken when `code/src/kernel/` is added (planned — added at P4).

## Sources

- **GNU make manual** — <https://www.gnu.org/software/make/manual/make.html> — rules, variables,
  `include`, automatic prerequisites; the installed version is 4.3
- **GCC 13.3 manual, Preprocessor Options** — <https://gcc.gnu.org/onlinedocs/gcc-13.3.0/gcc/Preprocessor-Options.html>
  — `-MMD` and `-MP`, checked 27/09/2026
- **Linux kernel docs, Minimal requirements to compile the Kernel** — <https://docs.kernel.org/process/changes.html>
  — GNU make 4.0 minimum, checked 27/09/2026
- **Linux kernel docs, Building External Modules** — <https://docs.kernel.org/kbuild/modules.html> —
  `make -C <path_to_kernel_dir> M=$PWD`, checked 27/09/2026
- **Peter Miller, "Recursive Make Considered Harmful" (1997)** — <https://aegis.sourceforge.net/auug97.pdf>
  — the recursive-make critique weighed in Option A
- **CMake, `CMAKE_EXPORT_COMPILE_COMMANDS`** —
  <https://cmake.org/cmake/help/latest/variable/CMAKE_EXPORT_COMPILE_COMMANDS.html> — Option B's
  compile-database support, checked 27/09/2026
- **Meson, Built-in options and Unit tests** — <https://mesonbuild.com/Builtin-options.html> ·
  <https://mesonbuild.com/Unit-tests.html> — `b_sanitize`, `meson test --wrapper`, `--gdb`,
  checked 27/09/2026
- **Meson source, Ninja backend** —
  <https://github.com/mesonbuild/meson/blob/master/mesonbuild/backend/ninjabackend.py> — writes
  `compile_commands.json` into the build directory, checked 27/09/2026
- **Bear** — <https://github.com/rizsotto/Bear> — generating `compile_commands.json` from a make run
