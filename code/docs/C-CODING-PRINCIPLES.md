---
type: guide
---

# C Coding Principles

**Last Updated**: 27/09/2026 | **Version**: 0.1.0 | **Maintained By**: Sam Bailey
**Language**: British English (en_GB) | **Timezone**: Europe/London

How C is written in this repository: the Linux kernel coding style from the first exercise, headers and
linkage that scale from one file to a multi-file program, error handling that never loses a failure, and
the C17 dialect the compiler holds every file to. This guide **owns C style**; the decision behind it is
`project-management/src/08-DECISIONS/ADR-MS001-C-CODING-STYLE-LINUX-KERNEL-27-09-2026.md`, and the
language standard is `ADR-MS001-C-STANDARD-C17-27-09-2026.md` in the same folder. The flags that enforce
parts of it belong to `code/docs/BUILD.md`; undefined behaviour belongs to `code/docs/MEMORY-SAFETY.md`.
The general principles behind all of it are in `code/docs/CODING-PRINCIPLES.md`.

---

## 1. Style — the Linux kernel coding style

The destination is kernel work (P4 onwards), so the kernel's style is learned once, from the start,
rather than unlearned later. The authority is the kernel's own document,
[docs.kernel.org/process/coding-style.html](https://docs.kernel.org/process/coding-style.html). Read it in
full once. The table summarises the points that come up most often in userspace exercises; it points at
the document, it does not replace it.

| Topic | The rule | Kernel style section |
| --- | --- | --- |
| Indentation | Tabs, 8 columns wide. Spaces are never used for indentation | 1 |
| Nesting | More than three levels of indentation means the function needs restructuring | 1 |
| `switch` | `case` labels line up with the `switch`, not indented beneath it | 1 |
| Line length | 80 columns preferred; break long statements into sensible pieces, but never split a user-visible string (it stops being greppable). 100 is checkpatch's default limit, not a hard kernel rule: a WARNING on a patch, but only a CHECK in `--file` mode, which `--strict` shows. The ADR makes 100 this repository's hard ceiling in review | 2 |
| Braces | K&R: the opening brace ends the line for `if`, `for`, `while`, `switch`, `struct`; a function's opening brace goes on a line of its own | 3 |
| One-statement bodies | No braces around a single statement — unless another branch of the same `if` needs them, then all branches get them | 3 |
| Spaces | After `if`, `switch`, `case`, `for`, `do`, `while`; not after `sizeof`, `typeof`, `alignof`, and never just inside parentheses. One space around binary operators, none after unary ones. The `*` sits next to the name: `char *p` | 3.1 |
| Naming | `lower_case_with_underscores`. Descriptive names for globals, short ones for locals (`i`, `tmp`) | 4 |
| Typedefs | Not for structs or pointers: write `struct node *`, so the reader sees what it is | 5 |
| Functions | Short, one job, five to ten locals at most | 6 |
| Prototypes | Parameter names included in declarations, not only types | 6.1 |
| Exits | Centralised cleanup with `goto` labels named for what they undo (Section 3 below) | 7 |
| Comments | Say what and why, not how. `/* ... */` block comments; a multi-line comment has a column of `*` down the left | 8 |
| Return values | A function named as an action returns an error code (0 on success); one named as a predicate returns a boolean; one that computes a result returns an out-of-range value on failure | 16 |

**`/* */`, not `//`.** The ADR adopts block comments throughout. That is this repository's rule, stricter
than the kernel's tooling: mainline checkpatch tolerates `//` by default and reports `C99_COMMENTS` only
when run with `--ignore C99_COMMENT_TOLERANCE`, so review, not checkpatch, holds the line. The single
exception is the licence line: the kernel's
[licence rules](https://docs.kernel.org/process/license-rules.html) put `// SPDX-License-Identifier:
GPL-2.0-only` on line 1 of a `.c` file and `/* SPDX-License-Identifier: GPL-2.0-only */` on line 1 of a
`.h` file, and this repository follows them.

**Tooling.** There is no C formatter on the machine (`how-to/docs/TOOLCHAIN.md` lists what is
installed); `.editorconfig` sets tabs of width 8 for `*.c` and `*.h`, and review does the rest. From P4,
the fetched kernel tree brings `scripts/checkpatch.pl`, which checks a userspace file too (planned —
added at P4). `--strict` is what makes it report the 100-column ceiling in `--file` mode:

```bash
<kernel-tree>/scripts/checkpatch.pl --no-tree --strict --file code/src/c/ms001-hello/greet.c
```

**Where userspace differs.** The kernel has no C library and returns negative `errno` values such as
`-ENOMEM`; userspace code calls libc and POSIX, which mostly return `-1` and set `errno`. Section 3 says
how to choose.

---

## 2. Headers and linkage

- **A header declares; a `.c` file defines.** Headers hold function prototypes, the structs and macros
  other files need, and `extern` declarations. Function bodies and object definitions live in exactly
  one `.c` file.
- **Every header has an include guard**, named after the file, so a second `#include` in the same
  translation unit is harmless. `#pragma once` is a common compiler extension, not ISO C, so guards are
  used instead:

  ```c
  #ifndef GREET_H
  #define GREET_H

  #include <stddef.h>

  int greet(char *buf, size_t len, const char *name);

  #endif /* GREET_H */
  ```

- **Headers are self-contained.** A header includes what it needs — `greet.h` includes `<stddef.h>` for
  `size_t` — and each `.c` file includes its own header **first**, so a missing include fails there,
  where it is cheap to fix, and not in some unrelated caller.
- **File-local by default: `static`.** A helper used only in one file is `static`. It gets internal
  linkage, cannot collide with another file's name, and `-Wall` warns if it goes unused.
- **`extern` for the rare shared object.** Declare it `extern int verbosity;` in the header and define it
  `int verbosity;` in exactly one `.c` file. Since gcc 10 the default is `-fno-common`, so the same
  definition written in two files is a `multiple definition` error at link time rather than being
  silently merged — checked with the local gcc 13.
- **One definition.** The C standard requires exactly one external definition for each identifier with
  external linkage that is actually used (C17 clause 6.9, paragraph 5). The linker is what enforces it,
  so the error arrives late and names the symbol, not the line.
- **`(void)` for "no parameters".** In C17, `int f()` declares a function whose parameters are
  _unspecified_; `int f(void)` declares one that takes none. `-Wstrict-prototypes` rejects the first.
- **`static inline` for small helpers shared through a header** — `check.h` is built this way, which is
  why it needs no `.c` file and nothing to link.

---

## 3. Error handling

**Every failure is reported, and every report is checked.** A return value that can signal failure is
tested before anything else happens. gcc warns when the result of a function marked
`warn_unused_result` is ignored, and it still warns if the call is cast to `(void)` — by design, because
discarding that result is almost always a bug.

**Choose one convention per function and write it in the header comment:**

| Convention | Success | Failure | Seen in |
| --- | --- | --- | --- |
| Count or status, `errno` on failure | a non-negative value: `0`, a count or a descriptor | `-1`, with `errno` saying why | POSIX calls: `open`, `read`, `close` |
| Negative error code | `0` or a count | `-EINVAL`, `-ENOMEM`, ... | the kernel (P4) |
| Pointer | a valid pointer | `NULL`, often with `errno` set | `malloc`, `fopen` |
| Out-of-range result | a count | `-1` | `greet()` in `code/src/c/ms001-hello/` |

**`errno` rules.** `errno` is only meaningful straight after a call that reported failure **and**
documents setting it; success does not reset it to zero. Anything called in between — `printf` included —
may overwrite it, so save it first. Since C11 it has thread-local storage duration (C17 clause 7.5), so
each thread sees its own.

```c
	fd = open(path, O_RDONLY);
	if (fd < 0) {
		int err = errno;        /* fprintf() may change errno */

		fprintf(stderr, "open %s: %s\n", path, strerror(err));
		return -1;
	}
```

**The `goto` cleanup ladder.** When a function acquires several resources, each failure has to release
exactly what was acquired before it. Kernel style Section 7 does this with labels in reverse order of
acquisition, each named for what it undoes:

```c
int copy_first_line(const char *src, const char *dst)
{
	FILE *in;
	FILE *out;
	char *line;
	int ret = -1;

	in = fopen(src, "r");
	if (!in)
		return -1;

	out = fopen(dst, "w");
	if (!out)
		goto out_close_in;

	line = malloc(LINE_LEN);
	if (!line)
		goto out_close_out;

	if (fgets(line, LINE_LEN, in) && fputs(line, out) != EOF)
		ret = 0;

	free(line);
out_close_out:
	if (fclose(out) == EOF)
		ret = -1;
out_close_in:
	fclose(in);
	return ret;
}
```

(`LINE_LEN` is a `#define` in the file. The example compiles clean under the full flag set and
`-fanalyzer` with gcc 13.)

- **A failure before anything is acquired returns directly** — there is nothing to undo.
- **Labels say what they do** (`out_close_in`), never `err1:` / `err2:`, which have to be renumbered
  whenever a path is added.
- **One label per resource.** A single `err:` label that frees everything is the "one err bug" kernel
  style warns about: on some paths a pointer it frees was never set. `free(NULL)` happens to be a no-op,
  but `fclose(NULL)` is undefined behaviour.
- **The ladder is also the success path.** The normal exit falls through the same releases, so there is
  one place where each resource is let go.

**`assert()` is for programmer errors, not input.** An `assert` documents an invariant that only a bug
can break, and it vanishes when `NDEBUG` is defined. Anything a user, a file or the network can get
wrong is checked with an `if` and reported as an error.

---

## 4. C17 and the dialect

The build uses `-std=c17`: ISO C17 with GNU extensions switched off. gcc 13's own default is
`-std=gnu17` (see `man gcc`, C Dialect Options). C17 is C11 with defect corrections and no new
features. Together with `-Wpedantic -Werror` (`code/docs/BUILD.md`), the strict dialect turns
extensions into errors instead of habits. Observed with the local gcc 13:

| Written | Under `-std=gnu17` | Under this repository's flags |
| --- | --- | --- |
| `typeof(x) y = x;` | accepted | error: `typeof` is not a C17 keyword (`__typeof__` is the reserved spelling) |
| `int m = 0b101;` | accepted | error: "binary constants are a C2X feature or GCC extension" |
| `getline()`, `strdup()` or `fileno()` with no feature-test macro | declared | error: implicit declaration of the function |

**POSIX functions need a feature-test macro.** Under `-std=c17` glibc exposes only ISO C declarations.
From P2 onwards, a file that uses POSIX calls starts, before any `#include`, with:

```c
#define _POSIX_C_SOURCE 200809L
```

Putting it in the file rather than in the Makefile keeps the dependency visible to the reader.

**C23** is known to gcc 13 only as `-std=c2x`, described in its manual as experimental and incomplete.
Moving to it is a new ADR that supersedes the C17 one, never an edit to it.

**Three kinds of "the standard does not say".** _Implementation-defined_ behaviour is documented by the
compiler (the result of right-shifting a negative `int`). _Unspecified_ behaviour picks one of several
allowed outcomes without saying which (the order in which function arguments are evaluated).
_Undefined_ behaviour carries no requirements at all, and is the subject of the next section.

## 5. Undefined behaviour

Out-of-bounds access, use after free, signed overflow, uninitialised reads, strict-aliasing violations
and data races — what each looks like, and the tools that catch it — are covered in
`code/docs/MEMORY-SAFETY.md`.

---

## Cross-references

- `code/docs/CODING-PRINCIPLES.md` — the principles this style serves
- `code/docs/BUILD.md` — the flags that turn parts of this guide into compiler errors
- `code/docs/MEMORY-SAFETY.md` — undefined behaviour, ownership, and the tools
- `code/src/c/ms001-hello/` — the reference exercise, written in this style
- `code/workflows/05-review/` — the review that checks code against this guide
- `code/REFERENCES.md` — the C standard drafts, cppreference and the GCC manual

_Part of the `code/docs/` documentation family._
