---
workflow: 05-debugging-environment
phase: diagnose
skills: []
---

# Debugging the Environment — Steps

**Last Updated**: 27/09/2026 | **Version**: 0.1.0 | **Maintained By**: Sam Bailey
**Language**: British English (en_GB) | **Timezone**: Europe/London

---

## Key references

Consult `how-to/REFERENCES.md` as you work through these steps:

| Step | Section |
| --- | --- |
| 2–3 | **Internal → Reference guides** → `how-to/docs/TOOLCHAIN.md` (Overview, Troubleshooting) |
| 4 | **External — Debugging and memory** → Yama (ptrace_scope), core(5), Valgrind Memcheck, AddressSanitizer |
| 4 | **External — Toolchain and build** → rustup book (overrides and toolchain file) |
| 6 | **Internal → Cross-layer** → `code/workflows/CONTEXT.md` (07-debug), `code/docs/DEBUGGING.md` |

---

## Steps

### Step 1 — Capture the exact error

Re-run the failing command and keep the command line, the directory it ran in, and the **first** error
line (later errors are often consequences of the first):

```bash
pwd
make -C code/src/c/ms001-hello memcheck
echo "exit=$?"
```

Replace the `make` line with whichever command failed.

_Done when you have the command, the directory, the exit code and the first error line written down._

### Step 2 — Check the toolchain is present

```bash
bash code/src/scripts/toolchain/check.sh
echo "exit=$?"
```

Exit 2 names the missing required tool; its install line is in `how-to/docs/TOOLCHAIN.md` → Prerequisites.
A missing tool also shows up directly, for example `make: gcc: No such file or directory` followed by
`Error 127`, or `bash: valgrind: command not found`.

_Done when `check.sh` exits 0, or the missing tool is identified._

### Step 3 — Confirm which versions are actually running

```bash
gcc --version | head -1
which -a gcc
cd code/src/rust && rustup show active-toolchain && rustc --version && cd ../../..
```

Compare with the Overview table in `how-to/docs/TOOLCHAIN.md`. Inside `code/src/rust/` the active
toolchain line ends `(overridden by '…/code/src/rust/rust-toolchain.toml')`. Two lines from `which -a`
mean something earlier on `PATH` shadows the system compiler. A cargo command started outside
`code/src/rust/`, including one using `--manifest-path`, runs the host default toolchain instead of the pin.

_Done when every version in play matches the record, or the mismatch is named._

### Step 4 — Match the symptom to a known environment fault

| First error line (as printed) | Cause | Fix |
| --- | --- | --- |
| `make: *** No targets specified and no makefile found. Stop.` | Run from the wrong directory | `make -C code/src/c/<exercise> <target>` |
| `make: gcc: No such file or directory` | `build-essential` not installed | Learner: `sudo apt install build-essential` |
| `error: toolchain '1.92.0-x86_64-unknown-linux-gnu' is not installed` | Pinned toolchain missing, auto-install off | `rustup toolchain install` inside `code/src/rust/` |
| `error: rustc 1.85.0 is not supported by the following packages:` | An older toolchain is active | Run cargo inside `code/src/rust/`; check `rustup override list` |
| ``error: no such command: `deny` `` | cargo-deny not installed | `cargo install --locked --version 0.19.0 cargo-deny` |
| `Could not attach to process.  If your uid matches the uid of the target` | `ptrace_scope` is 1 | See "gdb cannot attach" below |
| `Segmentation fault` and no core file anywhere | Core dumps off (`ulimit -c` is 0) | See "No core file" below |
| `ASan runtime does not come first in initial library list` | valgrind run on a `build/san/` binary | Use `make … memcheck` (plain build) |
| `LeakSanitizer does not work under ptrace (strace, gdb, etc)` | LSan run under gdb | `ASAN_OPTIONS=detect_leaks=0` inside gdb; check leaks outside it |
| `AddressSanitizer:DEADLYSIGNAL`, repeated, before any test runs | ASan runtime versus 32-bit mmap randomisation on some kernels (not seen on this machine; `syntax-c.yml` guards CI against it) | Learner: `sudo sysctl -w vm.mmap_rnd_bits=28` (lasts until reboot) |
| `Enable debuginfod for this session? (y or [n])` | gdb offering to download system debug info | Answer `n`, or add `set debuginfod enabled off` to `~/.gdbinit` |

**gdb cannot attach.** Ubuntu ships `kernel.yama.ptrace_scope = 1`: gdb may debug its own children but not
attach to an unrelated running process. The simplest fix needs no privilege — start the program under gdb:

```bash
gdb --args ./code/src/c/ms001-hello/build/hello Sam
```

If attaching really is needed, the learner relaxes the setting for this boot only and sets it back after:

```bash
# See the current value (1 on a stock Ubuntu 24.04)
cat /proc/sys/kernel/yama/ptrace_scope
# Relax it until the next reboot
sudo sysctl -w kernel.yama.ptrace_scope=0
# When the debugging session is over, put it back
sudo sysctl -w kernel.yama.ptrace_scope=1
```

**No core file.** Enable cores for the current shell, reproduce the crash, then look where apport put it:

```bash
ulimit -c unlimited
./path/to/crashing-program
ls -t /var/lib/apport/coredump/ | head -1
gdb ./path/to/crashing-program /var/lib/apport/coredump/<file from the line above>
```

Replace `./path/to/crashing-program` with the program that crashed, and the last argument with the file
name `ls` printed.

On Ubuntu 24.04 `/proc/sys/kernel/core_pattern` pipes cores to apport, which writes them to
`/var/lib/apport/coredump/` as `core.<program path with _ for />.<uid>.<boot id>.<pid>.<time>`, readable
only by you. `bt` in gdb then shows where it crashed. `ulimit -c` resets when the shell closes.

_Done when the symptom matches a row or a paragraph above, or is confirmed as none of them._

### Step 5 — Fix the environment and re-run the original command

Apply the fix (the learner runs anything with `sudo`), then run the command from Step 1 **unchanged**, in
the same directory. If it now passes, record the cause. If it fails with a different first error, return to
Step 4 with the new line.

_Done when the original command runs, or the environment is shown to be healthy and the fault persists._

### Step 6 — Route what is left

- **Environment fixed:** add the symptom to the Troubleshooting section of `how-to/docs/TOOLCHAIN.md` if it
  is new, and set back any temporary setting.
- **Environment healthy, fault persists:** it is a code fault. Hand it to `code/workflows/07-debug/` with the
  command, the first error line and the versions from Step 3.
- **Cannot be fixed today** (a package not yet installable, a blocked P4 tool): add a `GAPS.md` entry with
  **Type:** Toolchain gap and the action that unblocks it.

_Done when the fault is either resolved, handed to `code/workflows/07-debug/`, or recorded in `GAPS.md`._

---

## Update context files

If this workflow created files or folders, or settled a new convention:

1. Add every new file or folder to the directory tree in the nearest `CONTEXT.md`; a new directory also
   gets its own `CONTEXT.md` and `CLAUDE.md`.
2. Add any new guide, workflow or external source to `how-to/REFERENCES.md`.
3. Refresh `**Last Updated**` in every `CONTEXT.md` you modified.
4. If the session ends before Completion, run `/handoff` to write
   `handoffs/HANDOFF-<SCREAMING-KEBAB-DESCRIPTOR>-DD-MM-YYYY.md`.

---

## Completion

Run through `CHECKLIST.md` before marking this workflow complete.
