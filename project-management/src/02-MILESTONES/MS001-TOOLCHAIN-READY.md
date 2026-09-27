# MS001 — Toolchain Ready

**Track:** C + Rust
**Phase:** P1 — `project-management/src/01-ROADMAP/ROADMAP.md`
**Status:** Open

<!-- Status words and their transitions are owned by
     project-management/docs/planning/MILESTONES.md -> Statuses. Not restated here. -->

<!-- FLAGS — one row per learning gate. N/A skips the gate and carries its reason.
     Row meanings and gates: project-management/docs/planning/MILESTONES.md -> The FLAGS table. -->

| Flag | Value |
| --- | --- |
| Exercises | N/A — `code/src/c/ms001-hello/` and `code/src/rust/crates/ms001_hello/` are smoke tests seeded with the repository, not a designed exercise set |
| Project | N/A — P1's capstone comes at the end of the phase |
| Kernel | N/A — kernel work starts at P4 |
| OS | N/A — Syntek OS work starts at P6 |
| Tests | `make -C code/src/c/ms001-hello test` + `(cd code/src/rust && cargo test)` |
| Memory | `make -C code/src/c/ms001-hello san` + `make -C code/src/c/ms001-hello memcheck` |
| Debugger | gdb on `code/src/c/ms001-hello/build/test_greet`: break on `greet`, print an argument, `finish` to see the return value |
| Lint | `make -C code/src/c/ms001-hello lint` + `cargo fmt --all --check` + `cargo clippy --all-targets -- -D warnings` (both cargo commands run inside `code/src/rust/`) |
| QEMU | N/A — nothing boots before P4; `code/src/scripts/toolchain/check.sh` reports `qemu-system-x86_64` as optional only |
| Budget | N/A — toolchain smoke tests have no resource target |
| Notes | N/A — the toolchain is exercised here, not studied; the gdb transcript goes in the verification record |
| Research | N/A — host versions are already recorded in `how-to/docs/TOOLCHAIN.md` |

---

## Why this matters

Every later milestone assumes that a failing build means a mistake in the learner's code. That only
holds if the compiler, build system, debugger, memory checker and Rust toolchain are present, are
the versions the docs were written against, and have each been seen to **fail when they should**,
not only to pass. MS001 establishes all three, once, so no later milestone spends its points
debugging the machine.

## Learning story

As a learner, I want a verified C and Rust toolchain, so that every later exercise fails for reasons
in my code, not my machine.

## MoSCoW priority

**Must** <!-- every later milestone depends on it -->

## Points

2 <!-- one sitting on tools that are already installed, plus reading every gate's output once -->

## Dependencies

- None — this is the first milestone; nothing upstream.
- Unblocks every later milestone. Host tools that later phases need and this machine lacks (for
  example the kernel build dependencies for P4) are out of scope here; a gap found during MS001 is
  logged in `GAPS.md`, not fixed inside this milestone.

## Decisions

The five scaffold defaults this milestone verifies in practice. Each is `Accepted` and changes only
by a new ADR that supersedes it.

- `project-management/src/08-DECISIONS/ADR-MS001-C-STANDARD-C17-27-09-2026.md` — C17 (`-std=c17`);
  C23 revisited later
- `project-management/src/08-DECISIONS/ADR-MS001-C-CODING-STYLE-LINUX-KERNEL-27-09-2026.md` — Linux
  kernel coding style from the first line of C
- `project-management/src/08-DECISIONS/ADR-MS001-BUILD-SYSTEM-GNU-MAKE-27-09-2026.md` — plain GNU
  make with shared `mk/` includes, no cmake
- `project-management/src/08-DECISIONS/ADR-MS001-C-TEST-HARNESS-CHECK-H-27-09-2026.md` — the
  header-only `check.h` harness, no test library
- `project-management/src/08-DECISIONS/ADR-MS001-RUST-EDITION-2024-TOOLCHAIN-PIN-27-09-2026.md` —
  edition 2024, toolchain pinned to 1.92.0 in `rust-toolchain.toml`

The twelve MS001 ADRs from Sam's planning conversation (the roadmap tracks, the kernel, Syntek OS, the
tools, the LLM, the crate licences, the GUI toolkit and the security track) are driven by this
milestone too, because it was the only one open when they were written; they shape later phases, not
MS001's gates (`project-management/src/08-DECISIONS/CONTEXT.md` → The planning-conversation set).

---

## Threat model

Assets: the learner's host and this public repository. Threats: a gate that silently could not run,
mistaken for a pass; a secret or absolute path committed. Mitigations: a missing tool is exit 2 (could
not run), never clean (`project-management/docs/VERIFICATION-GUIDE.md`); `git diff --staged` is read
before every commit and `Audit — Secrets` scans every push; Claude never runs `sudo`
(`.claude/CLAUDE.md` Section 5).

---

## Mastery Criteria

**Testable means an observer could agree it passed without asking the author.** Commands run from
the repository root unless a scenario says otherwise. The targets and flags behind them are owned by
`code/docs/BUILD.md`.

MS001 is mastered when every gate passes on the seeded code, two gates have been seen to catch a
planted fault, and the learner can say what each tool checks and why two of them never share a
binary.

### Toolchain

```gherkin
Scenario: The host toolchain is present at the documented versions
  Given a fresh shell at the repository root
  When I run bash code/src/scripts/toolchain/check.sh
  Then it prints a "| Tool | Version |" table
  And gcc, make, gdb, valgrind, cargo, rustc, rustfmt and clippy-driver each show a version
  And each version matches how-to/docs/TOOLCHAIN.md
  And the script exits 0

Scenario: A missing required tool is reported as "could not run", never as clean
  Given the rustup directory (~/.cargo/bin by default) is left off PATH for one run
  When I run env PATH=/usr/bin:/bin bash code/src/scripts/toolchain/check.sh
  Then the table shows the Rust tools as "MISSING (required)"
  And the script prints "COULD NOT RUN" naming cargo, rustc, rustfmt and clippy-driver
  And it exits 2

Scenario: The pinned Rust toolchain is the one in use
  Given I am in code/src/rust
  When I run rustup show active-toolchain
  Then it names the 1.92.0 toolchain, overridden by code/src/rust/rust-toolchain.toml
```

rustup finds `rust-toolchain.toml` by walking up from the **current directory**, not from
`--manifest-path`, so every cargo command below runs from inside `code/src/rust/` (a subshell,
`(cd code/src/rust && cargo ...)`, keeps the terminal at the root). The same command given
`--manifest-path code/src/rust/Cargo.toml` from the root would use rustup's default toolchain and
agree with the pin only while that default is also 1.92.0.

### C mastery criteria

```gherkin
Scenario: The C exercise builds and its tests pass
  Given code/src/c/ms001-hello at a clean checkout
  When I run make -C code/src/c/ms001-hello test
  Then ./build/test_greet prints a line of the form "check: N passed, 0 failed"
  And make exits 0

Scenario: The sanitised build is clean
  When I run make -C code/src/c/ms001-hello san
  Then the tests pass again from build/san/ under AddressSanitizer and UBSan
  And no AddressSanitizer report and no "runtime error:" line is printed
  And make exits 0

Scenario: valgrind reports no errors and no leaks
  When I run make -C code/src/c/ms001-hello memcheck
  Then valgrind prints "All heap blocks were freed -- no leaks are possible"
  And valgrind prints "ERROR SUMMARY: 0 errors from 0 contexts"
  And make exits 0

Scenario: The static analyser is clean
  When I run make -C code/src/c/ms001-hello lint
  Then no analyzer diagnostic is printed (under -Werror it would end "[-Werror=analyzer-...]")
  And make exits 0

Scenario: The memory gates fail when they should
  Given a throwaway edit to code/src/c/ms001-hello/test_greet.c that allocates with malloc,
    writes to the block and never frees it
  When I run make -C code/src/c/ms001-hello memcheck
  Then valgrind reports the block as "definitely lost" and "ERROR SUMMARY: 1 errors"
  And make exits non-zero
  When I run make -C code/src/c/ms001-hello san
  Then LeakSanitizer prints "detected memory leaks"
  And make exits non-zero
  And the edit is reverted with git restore before anything is committed
```

### Rust mastery criteria

```gherkin
Scenario: The Rust workspace tests pass
  Given I am in code/src/rust
  When I run cargo test
  Then the ms001_hello unit tests and the tests/greet.rs integration tests pass
  And cargo exits 0

Scenario: Formatting and lints are clean with warnings as errors
  Given I am in code/src/rust
  When I run cargo fmt --all --check
  And I run cargo clippy --all-targets -- -D warnings
  Then both exit 0

Scenario: The lint gate fails when it should
  Given a throwaway "1".parse::<u8>().unwrap() added to greet() in code/src/rust/crates/ms001_hello/src/lib.rs
  And I am in code/src/rust
  When I run cargo clippy --all-targets -- -D warnings
  Then clippy stops with "used `unwrap()` on a `Result` value" (the clippy::unwrap_used lint)
  And cargo exits non-zero
  And the edit is reverted with git restore before anything is committed
```

### Debugging mastery criteria

```gherkin
Scenario: gdb shows source, arguments and return values
  Given make -C code/src/c/ms001-hello has built build/test_greet with -g3 -O0
  When I run gdb -q code/src/c/ms001-hello/build/test_greet
  And I type break greet, then run, then print name, then finish
  Then gdb stops in greet at greet.c with the source line shown
  And print name shows "world"
  And finish reports "Value returned is" 13
```

### Explain-back

```gherkin
Scenario: I can say what each gate checks
  Given no notes or code are open
  When I explain what make test, make san, make memcheck and make lint each check
  Then the explanation says that san instruments the code at compile time, that valgrind runs the
    unmodified binary on a synthetic CPU, and that both take over malloc, which is why the two never
    run on the same binary
  And it names one bug class each gate catches that the others miss
```

---

## Tasks

### Study

- [ ] Read `code/docs/BUILD.md` and say, for each flag in `code/src/c/mk/flags.mk`, what it catches
- [ ] Read `how-to/docs/TOOLCHAIN.md` and compare it with the `check.sh` table on this machine

### Build

- [ ] Run every scenario above in order, keeping the terminal output
- [ ] Plant, observe and revert the two throwaway faults (C leak, Rust `.unwrap()`)
- [ ] Log any missing or mismatched tool in `GAPS.md` rather than working round it
- [ ] When the GitHub repository is first created, before the first pull request, enable private
      vulnerability reporting so the channel `SECURITY.md` names exists: Settings → Advanced Security →
      Private vulnerability reporting → Enable, or
      `gh api -X PUT repos/SamBailey6194/c-rust-learning/private-vulnerability-reporting`; then
      `gh api repos/SamBailey6194/c-rust-learning/private-vulnerability-reporting` reports `enabled` true

---

## Verification Checks

The raw commands are the lesson; `code/src/scripts/gates/all.sh` runs the same gates through their
wrapper scripts (`how-to/workflows/03-quality-gates/`). A tool that is missing is a gate that
**could not run** (exit 2), never a gate that passed.

- [ ] `bash code/src/scripts/toolchain/check.sh` — exit 0
- [ ] `make -C code/src/c/ms001-hello test` — exit 0
- [ ] `make -C code/src/c/ms001-hello san` — exit 0
- [ ] `make -C code/src/c/ms001-hello memcheck` — exit 0
- [ ] `make -C code/src/c/ms001-hello lint` — exit 0
- [ ] `(cd code/src/rust && cargo test)` — exit 0
- [ ] `(cd code/src/rust && cargo fmt --all --check)` — exit 0
- [ ] `(cd code/src/rust && cargo clippy --all-targets -- -D warnings)` — exit 0
- [ ] `bash code/src/scripts/gates/all.sh` — every gate in its summary table passes

---

## Links

| Artefact | Path |
| --- | --- |
| Roadmap position | `project-management/src/01-ROADMAP/ROADMAP.md` → You are here |
| C exercise | `code/src/c/ms001-hello/` |
| Rust crate | `code/src/rust/crates/ms001_hello/` |
| Toolchain setup | `how-to/workflows/01-toolchain-setup/` |
| Plan | `project-management/src/09-MILESTONE-PLANS/` — MS001's plan, written at `09-milestone-plans` |
| Verification | `project-management/src/10-PROGRESS/` — MS001's record, written at `11-verification` |

---

## Definition of Done

- [ ] Every mastery scenario above passes, including both planted-fault scenarios
- [ ] The explain-back was done without notes
- [ ] Every verification check run, with its output kept for the verification record
- [ ] Any tool gap found is an entry in `GAPS.md`
- [ ] Verification record written in `project-management/src/10-PROGRESS/`
- [ ] Merged to `main` through a PR from `ms001/toolchain-ready`
- [ ] **Status** set to `Completed`, and `project-management/src/01-ROADMAP/ROADMAP.md` → You are
      here moved on
