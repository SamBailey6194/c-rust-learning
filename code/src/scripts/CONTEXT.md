# code/src/scripts/ — The Gate Scripts

**Last Updated**: 27/09/2026

Every quality gate in the repository, as a bash script. Each one wraps a raw command the learner can
also type by hand — `make -C code/src/c test`, `cargo clippy`, `cloc` — and adds the one thing the raw
command lacks: a single exit-code contract. **0** means the check ran and found nothing; **1** means it
ran and found a problem in the code; **2** means it could not run at all, because a tool is missing or
an argument is wrong. The third code is the reason the scripts exist: "could not look" is reported as
COULD NOT RUN and not as a pass, because a gate that cannot fail is worse than no gate — it is believed.
CI runs these same scripts for gates 1 to 11, so a green local run of them and a green CI run of them
mean the same thing; CI's shell lint, Markdown lint and secrets scan run their tools directly
(`how-to/workflows/03-quality-gates/`).

## Directory Tree

```text
code/src/scripts/
├── CONTEXT.md · CLAUDE.md       ← this file · how to run, add or change a script
├── _lib/                        ← sourced by the scripts, not run on its own (covered by this pair)
│   └── common.sh                ← PROJECT_ROOT, log, bold, die, need_tool, print_help, run_gate, c_make, rust_enter
├── c/                           ← the C gates — each wraps one make target (covered by this pair)
│   └── build.sh · test.sh · san.sh · memcheck.sh · lint.sh
├── rust/                        ← the Rust gates, run inside code/src/rust/ (covered by this pair)
│   └── build.sh · test.sh · lint.sh · audit.sh
├── audits/                      ← the documentation gates (covered by this pair)
│   ├── docs-length.sh           ← instructional Markdown at most 300 cloc code lines
│   ├── docs-pairing.sh          ← every directory paired, every pair in shape
│   └── docs-pairing.exempt      ← the exemption globs docs-pairing.sh reads
├── toolchain/                   ← (covered by this pair)
│   └── check.sh                 ← prints the | Tool | Version | table
└── gates/                       ← (covered by this pair)
    └── all.sh                   ← every gate above, in order, then one summary table
```

## Scripts

| Script | Wraps (the raw command) | Exit 1 means | Needs (exit 2 without) |
| --- | --- | --- | --- |
| `c/build.sh` | `make -C code/src/c` | a compile error or any warning | gcc, make |
| `c/test.sh` | `make -C code/src/c test` | a test binary failed | gcc, make |
| `c/san.sh` | `make -C code/src/c san` | AddressSanitizer or UBSan reported, or a test failed | gcc, make |
| `c/memcheck.sh` | `make -C code/src/c memcheck` | valgrind reported an error or a leak of any kind | gcc, make, valgrind |
| `c/lint.sh` | `make -C code/src/c lint` | `gcc -fanalyzer` reported a path to a bug | gcc, make |
| `rust/build.sh` | `cargo build --workspace --all-targets` | a crate or its tests did not compile | cargo |
| `rust/test.sh` | `cargo test --workspace` | a unit, integration or doc test failed | cargo |
| `rust/lint.sh` | `cargo fmt --all --check` + `cargo clippy --workspace --all-targets -- -D warnings` | formatting drift or a clippy lint | cargo, rustfmt, clippy |
| `rust/audit.sh` | `cargo deny fetch` + `cargo deny check --disable-fetch` | an advisory, licence, ban or source violation | cargo, cargo-deny, network |
| `audits/docs-length.sh` | `cloc --include-lang=Markdown` per instructional file | a file over 300 code lines | cloc |
| `audits/docs-pairing.sh` | (no raw equivalent) | a missing pair or a pair out of shape | git or find |
| `toolchain/check.sh` | each tool's `--version` | rustc in `code/src/rust/` differs from the pin | the eight required tools |
| `gates/all.sh` | every script above, in order | at least one gate failed (2 if one could not run) | whatever the gates need |

Every C script takes `--path <exercise>` to run one exercise; `rust/test.sh` takes `--crate <name>`;
`rust/build.sh` takes `--release`; `rust/lint.sh` takes `--fix`; both audits take `--path <dir>` and
`--self-test`; `gates/all.sh` takes `--skip <gate>`. Every script prints its own header with `--help`.

## The shape every script shares

Each script starts `#!/usr/bin/env bash`, then a header comment: a one-line summary, `Usage:` lines,
what it does and why, and `# Exit codes: 0 = pass  1 = failures  2 = script/tool error`. `--help` prints
that header, so the documentation and the behaviour live in one place. The script sets
`set -euo pipefail` and sources `_lib/common.sh`, whose `need_tool` turns a missing tool into exit 2
with an install hint. The two audits also carry a `--self-test`, which builds a scratch tree with a
known answer and checks that the detector finds exactly what was planted — a detector is trusted only
after it has been seen to fail.

## Cross-references

- `how-to/workflows/03-quality-gates/` — running the gates and reading their results
- `code/docs/BUILD.md` — the make targets the C scripts wrap
- `code/docs/DOCUMENTATION-LENGTH.md` and `code/docs/DOCUMENTATION-PAIRING.md` — the rules the audits enforce
- `.github/workflows/` — CI: `Syntax — C`, `Syntax — Rust`, `Syntax — Shell`, `Markdown — Lint`,
  `Audit — Docs` and `Audit — Secrets`, each calling these scripts
- `how-to/docs/TOOLCHAIN.md` — the tool versions `toolchain/check.sh` reports against
