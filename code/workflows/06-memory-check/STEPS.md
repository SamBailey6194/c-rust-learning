---
workflow: 06-memory-check
phase: verify
skills: []
---

# Memory Check — Steps

**Last Updated**: 27/09/2026 | **Version**: 0.1.0 | **Maintained By**: Sam Bailey
**Language**: British English (en_GB) | **Timezone**: Europe/London

---

## Key references

Consult `code/REFERENCES.md` for the external sources (GCC Instrumentation Options, GCC Static Analyzer
Options, the Valgrind user manual) as you work through these steps:

| Step | Section |
| --- | --- |
| All | `code/docs/MEMORY-SAFETY.md` — what the tools are checking for |
| 2–4 | `code/docs/BUILD.md` and `code/src/c/mk/flags.mk` — the targets and every flag behind them |
| 3 | `code/docs/DEBUGGING.md` — valgrind in more depth |
| 5 | `code/workflows/07-debug/` — turning a finding into a test and a fix |

---

## Steps

### Step 1 — Start from green tests

```bash
make -C code/src/c/msNNN-<kebab> test
```

A memory tool run on failing tests mixes two problems. Whole track: `make -C code/src/c test`.

_Done when every test passes on the plain build._

---

### Step 2 — Run AddressSanitizer + UBSan and read the report

```bash
make -C code/src/c/msNNN-<kebab> san
```

Wrapped by `bash code/src/scripts/c/san.sh --path msNNN-<kebab>`. `make` echoes every gcc line it runs —
reading them is how the flags in `code/src/c/mk/flags.mk` become familiar. To re-run one sanitised test
with a stack trace for UBSan reports as well:

```bash
UBSAN_OPTIONS=print_stacktrace=1 ./code/src/c/msNNN-<kebab>/build/san/test_<name>
```

Read a report top-down: the headline says what kind of bug; frame `#0` is where it happened — find the
first frame in the learner's own file; a second stack (`allocated by thread T0 here`,
`freed by thread T0 here`) says where the block came from; `SUMMARY:` names the file and line.

| Headline | Meaning | First question |
| --- | --- | --- |
| `AddressSanitizer: heap-buffer-overflow` | Access past a `malloc`ed block (`located 0 bytes after 16-byte region` = one past the end) | Which length or index is one too many? |
| `AddressSanitizer: stack-buffer-overflow` / `global-buffer-overflow` | Access past a local or a global array | Where does the bound come from? |
| `AddressSanitizer: heap-use-after-free` | Access after `free` | Who freed it, and who still held the pointer? |
| `AddressSanitizer: attempting double-free` | A second `free` of one block | Which owner was meant to free it? |
| `AddressSanitizer: SEGV on unknown address 0x000000000000` | NULL dereference | Which call can return NULL unchecked? |
| `LeakSanitizer: detected memory leaks` | Blocks never freed (`Direct leak` / `Indirect leak`) | Which path skips the free? |
| `runtime error: signed integer overflow` | Undefined arithmetic | What range can the inputs take? |
| `runtime error: shift exponent ... is too large` | Shift by at least the type's width | Where is the shift count checked? |
| `runtime error: index ... out of bounds for type` | Array index past a known bound | Is the loop condition `<` or `<=`? |
| `runtime error: load of null pointer` | Reading through NULL | Where should NULL have been rejected? |

_Done when `make san` exits 0 with no report, or every report is understood and queued for Step 5._

---

### Step 3 — Run valgrind and read the report

```bash
make -C code/src/c/msNNN-<kebab> memcheck
```

Wrapped by `bash code/src/scripts/c/memcheck.sh --path msNNN-<kebab>`. The raw command it runs on each
plain test binary:

```bash
valgrind --leak-check=full --show-leak-kinds=all --errors-for-leak-kinds=all --error-exitcode=1 \
    ./code/src/c/msNNN-<kebab>/build/test_<name>
```

Lines start `==PID==`. What the common ones mean:

- `Invalid write of size 4` / `Invalid read of size N`, then `Address ... is 0 bytes after a block of
  size 16 alloc'd` — an access just past a heap block; the second stack shows where it was allocated.
- `Conditional jump or move depends on uninitialised value(s)` — a decision made on memory never written.
  Re-run with `--track-origins=yes` added: valgrind then says where the value came from
  (`Uninitialised value was created by a heap allocation`).
- `Invalid free() / delete / delete[] / realloc()` — freeing something twice or something never
  allocated.
- `LEAK SUMMARY` — `definitely lost` (no pointer left), `indirectly lost` (reachable only through a lost
  block), `possibly lost`, `still reachable` (a pointer survives, but the block was never freed). All four
  count as errors here.

_Done when every run ends `ERROR SUMMARY: 0 errors from 0 contexts` and `make memcheck` exits 0, or each
error is queued for Step 5._

---

### Step 4 — Run the static analyzer and read its paths

```bash
make -C code/src/c/msNNN-<kebab> lint
```

Wrapped by `bash code/src/scripts/c/lint.sh --path msNNN-<kebab>`. Under the build's `-Werror` each finding
prints as an error, such as `double-'free' of 'a' [CWE-415] [-Werror=analyzer-double-free]` (the
`-Wanalyzer-double-free` warning made fatal), followed by numbered events —
`(1) entry to 'main'`, `(2) calling 'dup_name' from 'main'`, and so on — that trace the path to the problem.
Follow the events in the source; the question is whether that path can happen, not whether the tests
took it. An `analyzer-possible-null-argument` finding on a `malloc` result usually means a missing NULL
check.

_Done when `make lint` reports that `-fanalyzer` found nothing, or each warning is queued for Step 5._

---

### Step 5 — Fix each finding at its cause

Take the queued findings one at a time, first report first, through `code/workflows/07-debug/`: a test
that makes the tool report the problem (a failing assertion, or a failing `make san` / `make memcheck`
run), then the learner's minimal fix. A leak is fixed by deciding who owns the block, not by adding a
`free` wherever the report points.

_Done when every queued finding has a fix and a test that would catch it again._

---

### Step 6 — Re-run all three until clean

```bash
make -C code/src/c/msNNN-<kebab> test san memcheck lint
```

Claude confirms through `bash code/src/scripts/c/san.sh`, `memcheck.sh` and `lint.sh`, each with
`--path msNNN-<kebab>`. A fix for one tool
can surface something in another, so all three run again after every fix.

Do not mark the code clean until all three pass in the same run.

_Done when `test`, `san`, `memcheck` and `lint` all exit 0 together._

---

## Update context files

1. Add any new test file to the exercise's `CONTEXT.md` tree.
2. Add any new external source used to read a report to `code/REFERENCES.md`.
3. Refresh `**Last Updated**` in every `CONTEXT.md` you modified.
4. If the session ends before Completion, run `/handoff` to write
   `handoffs/HANDOFF-<SCREAMING-KEBAB-DESCRIPTOR>-DD-MM-YYYY.md`.

---

## Completion

Run through `CHECKLIST.md` before marking this workflow complete.
