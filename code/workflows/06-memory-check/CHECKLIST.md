---
workflow: 06-memory-check
phase: verify
skills: []
---

# Memory Check — Checklist

**Last Updated**: 27/09/2026 | **Version**: 0.1.0 | **Maintained By**: Sam Bailey
**Language**: British English (en_GB) | **Timezone**: Europe/London

---

> **See** `code/docs/MEMORY-SAFETY.md` · `code/docs/BUILD.md` · `code/src/c/mk/flags.mk` ·
> `code/REFERENCES.md` for supporting references.

## Pre-Conditions

- [ ] `bash code/src/scripts/toolchain/check.sh` exits 0 (gcc and valgrind present)
- [ ] The code in scope builds without warnings

---

## Execution Checklist

### Step 1 — Start from green tests

- [ ] `make -C code/src/c/msNNN-<kebab> test` exits 0

### Step 2 — Run AddressSanitizer + UBSan and read the report

- [ ] `make ... san` run; every report read headline first, then the first frame in the learner's code
- [ ] The learner explained each report before Claude did

### Step 3 — Run valgrind and read the report

- [ ] `make ... memcheck` run on the plain build, never on `build/san/`
- [ ] Uninitialised-value reports re-run with `--track-origins=yes` to find their source
- [ ] Every leak kind in `LEAK SUMMARY` accounted for, `still reachable` included

### Step 4 — Run the static analyzer and read its paths

- [ ] `make ... lint` run; each `-Wanalyzer-*` warning's event path followed in the source
- [ ] Suspected false positives taken to review, not suppressed

### Step 5 — Fix each finding at its cause

- [ ] Each finding fixed through `code/workflows/07-debug/`, one at a time, first report first
- [ ] Each fix has a test (or a `san` / `memcheck` run) that would catch it again
- [ ] Leaks fixed by settling ownership, not by scattering `free` calls
- [ ] No suppression file, dropped flag or pragma introduced

### Step 6 — Re-run all three until clean

- [ ] `test`, `san`, `memcheck` and `lint` exit 0 in the same run
- [ ] Confirmed through `bash code/src/scripts/c/san.sh`, `memcheck.sh` and `lint.sh`

---

## Context

- [ ] Directory trees in the relevant `CONTEXT.md` files show any new test file
- [ ] `code/REFERENCES.md` lists any new external source
- [ ] `**Last Updated**` is refreshed in every `CONTEXT.md` modified
- [ ] If the session ended mid-work, a handoff exists in `handoffs/`

---

## Definition of Done

- [ ] No AddressSanitizer, LeakSanitizer or UBSan report
- [ ] valgrind: `ERROR SUMMARY: 0 errors from 0 contexts` for every test binary
- [ ] `-fanalyzer`: no warnings
- [ ] Any tool that could not run is reported as COULD NOT RUN, and the code is not called clean
