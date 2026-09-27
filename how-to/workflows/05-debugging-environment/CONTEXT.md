# Workflow: Debugging the Environment

**Last Updated**: 27/09/2026

Environment faults — a missing tool, the wrong toolchain, a kernel setting that blocks the debugger —
look like code bugs, and treating one as the other is where an evening goes. This workflow proves the
environment first; a fault that survives a healthy environment is a logic bug and goes to
`code/workflows/07-debug/`.

## Directory Tree

```text
how-to/workflows/05-debugging-environment/
├── CONTEXT.md · CLAUDE.md   ← when to use, key concepts (this file) · operating rules
├── STEPS.md                 ← ordered steps, each closing on a "Done when" line
└── CHECKLIST.md             ← verification before the fault counts as resolved
```

## When to use this

- A script or gate exits 2 (could not run).
- A command fails before your code runs: `command not found`, `No such file or directory` for a tool,
  `toolchain … is not installed`, `no such command`.
- A debugging tool refuses to work: gdb cannot attach, no core file appears, valgrind or a sanitiser
  aborts before `main`.
- The same code behaves differently in two places (inside and outside `code/src/rust/`, or locally and
  in CI).

## Key concepts

- **Environment first, then code.** `code/src/scripts/toolchain/check.sh` and a version comparison
  against `how-to/docs/TOOLCHAIN.md` come before any reading of source.
- **The exact error line is the evidence.** Copy the first error and the command that produced it; most
  environment faults are identified by that line alone (the table in `STEPS.md` Step 4).
- **The working directory chooses the Rust toolchain.** rustup resolves `rust-toolchain.toml` from where
  `cargo` starts, so the same command can run 1.92.0 in `code/src/rust/` and the host default elsewhere.
- **Ubuntu restricts debugging by default.** `kernel.yama.ptrace_scope = 1` lets gdb debug a program it
  starts but not attach to one already running; core dumps are off (`ulimit -c` is 0) and apport
  collects them when switched on.
- **Two memory tools, two binaries.** ASan and valgrind each replace the allocator; valgrind on a
  `build/san/` binary stops before `main`, and LeakSanitizer does not run under gdb.
- **Changes to the host are the learner's.** Anything needing `sudo` is explained by Claude and run by
  the learner; temporary settings are set back afterwards.

## Cross-references

### Governing documents

- `how-to/docs/TOOLCHAIN.md` — the versions a healthy machine runs, and its Troubleshooting section
- `how-to/workflows/03-quality-gates/` — the exit-code contract (2 = could not run)

### Related reading

- `code/workflows/07-debug/` — the next stop once the environment is proven healthy
- `code/docs/DEBUGGING.md` — gdb, rust-gdb and backtraces as debugging technique
- `code/docs/MEMORY-SAFETY.md` — reading ASan, UBSan and valgrind reports
- `how-to/docs/CLI-TOOLING.md` — the commands this workflow uses, grouped by intent
- `how-to/src/MACHINE-SETUP.md` — the full host setup, including its Failure modes section
- `GAPS.md` — where an environment gap that cannot be fixed today is recorded
