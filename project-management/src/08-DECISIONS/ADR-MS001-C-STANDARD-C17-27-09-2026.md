# ADR-MS001: C standard — ISO C17 (`-std=c17`), C23 revisited later

| Field | Value |
| --- | --- |
| **ID** | ADR-MS001-C-STANDARD-C17 |
| **Status** | Accepted |
| **Date** | 27/09/2026 |
| **Milestone** | MS001 — Toolchain ready · `project-management/src/02-MILESTONES/MS001-TOOLCHAIN-READY.md` |
| **Deciders** | Sam Bailey |
| **Supersedes** | — |
| **Superseded by** | — |
| **Research** | — (primary sources cited below) |
| **Enforced in** | `code/src/c/mk/flags.mk` (`CSTD := -std=c17`) · documented in `code/docs/BUILD.md` |

---

## Context

This is one of five scaffold defaults accepted on 27/09/2026 together with the repository skeleton,
before the first exercise was written. It records the choice and the evidence available that day.
Like every Accepted ADR it is immutable: when C23 is revisited, the outcome is a new ADR that
supersedes this one, and this record stays as written.

Every C exercise compiles with one `-std=` flag, set once in `code/src/c/mk/flags.mk`. That flag
decides which language is actually being learned: which constructs are valid, what `-Wpedantic`
reports, and whether a GNU extension slips in unnoticed. Changing it later touches every exercise,
so it is chosen once and on purpose.

Facts checked on the host on 27/09/2026:

- **Compiler:** gcc 13.3.0 (Ubuntu 24.04). With no `-std=` flag it compiles `gnu17`, the GNU dialect
  of C17 (gcc manual, C Dialect Options; `__STDC_VERSION__` printed `201710L`).
- **C17 is complete in gcc 13.** `-std=c17` (aliases `c18`, `iso9899:2017`, `iso9899:2018`) is
  described in the manual as C11 plus defect corrections and a new `__STDC_VERSION__`, supported
  to the same extent as C11. A test compile printed `__STDC_VERSION__` = `201710L` and defined
  `__STRICT_ANSI__`.
- **C23 is not complete in gcc 13.** C23 (ISO/IEC 9899:2024) is reachable only as `-std=c2x`, which
  the manual calls experimental and incomplete. `-std=c23` is rejected outright
  (`unrecognized command-line option '-std=c23'; did you mean '-std=c2x'?`); that spelling arrived in
  GCC 14. Under `-std=c2x`, gcc 13 reports `__STDC_VERSION__` as `202000L`, a placeholder; the final
  value `202311L` arrived in GCC 15, which also made `gnu23` the default dialect.
- **C23 feature spot-check under `-std=c2x`:** `nullptr`, `constexpr` objects, `typeof`, and
  `bool`/`true`/`false` as keywords compiled cleanly; `#embed` was rejected (`invalid preprocessing
  directive #embed`). The GCC 14 release notes list `_BitInt(N)` and `<stdckdint.h>` (checked integer
  arithmetic) as new, so gcc 13 lacks them.
- **Newer compilers on this distribution:** Ubuntu 24.04 offers `gcc-14` (14.2.0) as an optional
  package, not installed; there is no gcc 15 package. CI runs `ubuntu-24.04` with gcc 13.
- **The kernel's dialect:** from P4 the repo builds the Linux kernel, which compiles its C with
  `-std=gnu11` (docs.kernel.org, "Programming Language"; also the top-level `Makefile` of mainline
  7.3-rc4 as of 27/09/2026). The move from `gnu89` to `gnu11` landed in 2022 in commit
  `e8c07082a810` ("Kbuild: move to -std=gnu11").
- **Strict ISO mode shows the GNU line.** Under `-std=c17 -Wpedantic`, `typeof` is an implicit
  function declaration (an error with `-Werror`) and a statement expression draws "ISO C forbids
  braced-groups within expressions"; under `-std=gnu17` the same `typeof` compiles without a word.
- **Strict ISO mode also hides POSIX.** Because `-std=c17` defines `__STRICT_ANSI__`, glibc declares
  only ISO C functions unless a feature-test macro asks for more: `strdup` and `fdopen` were implicit
  declarations under `-std=c17` and clean under `-std=gnu17` or with `-D_POSIX_C_SOURCE=200809L`
  (`man 7 feature_test_macros`).

## Options considered

### Option A — C11 (`-std=c11`)

- **Summary:** Compile every exercise as ISO C11, the base of the kernel's `gnu11` dialect.
- **Pros:** Exactly the standard under the kernel's dialect. Universally supported. Most C teaching
  material covers it.
- **Cons:** C17 added no features to C11; it corrected defects and changed `__STDC_VERSION__`, and
  gcc applies those corrections under `-std=c11` as well. The two flags compile the same programs the
  same way, so choosing C11 buys nothing except an older version number.

### Option B — C17 (`-std=c17`)

- **Summary:** Compile every exercise as ISO C17 in strict mode, with `-Wpedantic` from
  `code/src/c/mk/flags.mk`.
- **Pros:** The newest standard gcc 13 supports completely, so every diagnostic is about the
  learner's code, never a gap in the compiler. The same language as the kernel's base, minus GNU
  extensions. Strict mode plus `-Wpedantic` makes each GNU extension a visible, deliberate choice.
  Reference material marks each feature with the revision that introduced it, so C23 can be learned
  later as a short delta rather than a new language.
- **Cons:** One revision behind the current ISO standard. C23 conveniences are unavailable: `nullptr`,
  `constexpr` objects, `bool` as a keyword (C17 needs `<stdbool.h>`), standard `typeof`, `#embed`,
  `<stdckdint.h>`, `_BitInt`. Some idioms learned now (`NULL`, `<stdbool.h>`, `#define` constants)
  are partly replaced later.

### Option C — C23 (`-std=c2x` on gcc 13, or `-std=c23` after installing gcc-14)

- **Summary:** Learn the current standard from day one.
- **Pros:** Modern idioms from the first exercise, and less to relearn later.
- **Cons:** Experimental and incomplete on the installed compiler: `#embed`, `_BitInt` and
  `<stdckdint.h>` are missing, and `__STDC_VERSION__` is a placeholder. The `c2x` spelling is
  deprecated from GCC 14. A beginner cannot tell "my mistake" from "the compiler has not implemented
  this yet", which is the worst property a learning build under `-Werror` can have. Installing
  gcc-14 moves the repo off the compiler CI uses and is still incomplete (no `#embed`, placeholder
  version value).

### Option D — The GNU dialect (`-std=gnu17`, the compiler's default)

- **Summary:** Pass no `-std=` flag, or pass `-std=gnu17` explicitly, as the kernel does with
  `gnu11`.
- **Pros:** Closest to how the kernel is really compiled. GNU extensions the kernel relies on
  (`typeof`, statement expressions, attributes) are available. POSIX functions are declared without
  feature-test macros.
- **Cons:** The line between ISO C and GNU C becomes invisible: `typeof` compiled silently under
  `gnu17 -Wpedantic`. A learner who starts in the GNU dialect cannot tell which habits are portable
  C and which are gcc — exactly the distinction P4 kernel work presumes they already have.

## Decision

**We will take Option B: ISO C17, strict mode, `-std=c17`.** The deciding factor is that it is the
newest standard the installed compiler implements completely. That keeps every diagnostic about the
learner's code, and strict mode with `-Wpedantic` turns every GNU extension into a conscious choice.
Option A is the same language with an older label. Option C trades a clean feedback loop for
features the compiler only half has. Option D is how the kernel is built, but it is the wrong place
to start learning, because it hides the boundary that makes kernel C readable later.

This answer changes when the host and CI compilers implement C23 completely — GCC 15 or later, where
C23 is the default — at which point C23 is revisited by a new ADR that supersedes this one.

## Consequences

- **Positive:** One well-specified language across every exercise. `-Wpedantic` reports ISO C, not
  compiler gaps. What is learned maps directly onto the kernel's `gnu11` base, and GNU extensions
  arrive at P4 as named additions rather than unexamined habits.
- **Negative:** C23 idioms wait: exercises use `NULL`, `<stdbool.h>` and `#define`/`enum` constants.
  POSIX code from P2 onwards needs a feature-test macro (`#define _POSIX_C_SOURCE 200809L` before the
  first `#include`) — a small cost, and a lesson in its own right. Kernel-style snippets that use
  GNU extensions fail to compile in exercises; they belong in the kernel's own build from P4.
- **Follow-on:** `code/docs/BUILD.md` documents `CSTD` and the feature-test macro;
  `code/docs/C-CODING-PRINCIPLES.md` carries the C17 idioms. C23 is a parked topic: the first
  milestone plan that defers it records it in `DEFERRED.md`, and the revisit itself is a new ADR that
  supersedes this one.

## Sources

- **GCC 13.3 manual, C Dialect Options** — <https://gcc.gnu.org/onlinedocs/gcc-13.3.0/gcc/C-Dialect-Options.html>
  — `-std=` values, C17 as C11 plus defect fixes, `c2x` experimental and incomplete, `gnu17` default;
  cross-checked against the installed `man gcc`, 27/09/2026
- **GCC 14 release notes** — <https://gcc.gnu.org/gcc-14/changes.html> — `-std=c23` added,
  `c2x` deprecated, `_BitInt` and `<stdckdint.h>` new in 14, checked 27/09/2026
- **GCC 15 release notes** — <https://gcc.gnu.org/gcc-15/changes.html> — default changed to
  `gnu23`, `#embed`, `__STDC_VERSION__` = `202311L`, checked 27/09/2026
- **GCC C language status** — <https://gcc.gnu.org/projects/c-status.html> — per-feature C23
  support by GCC version, checked 27/09/2026
- **Linux kernel docs, Programming Language** — <https://docs.kernel.org/process/programming-language.html>
  — the kernel compiles with `-std=gnu11`, checked 27/09/2026
- **Kernel commit e8c07082a810, "Kbuild: move to -std=gnu11"** —
  <https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=e8c07082a810fbb9db303a2b66b66b8d7e588b53>
  — the 2022 move from `gnu89`, checked 27/09/2026
- **WG14 (ISO C committee)** — <https://www.open-std.org/jtc1/sc22/wg14/> — the standard's working
  drafts, the free alternative to the purchased ISO text
- **`man 7 feature_test_macros`** (installed man-pages) — `__STRICT_ANSI__` under `-std=c17` and the
  macros that re-expose POSIX declarations, checked 27/09/2026
