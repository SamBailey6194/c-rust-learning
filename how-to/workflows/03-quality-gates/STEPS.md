---
workflow: 03-quality-gates
phase: run
skills: []
---

# Quality Gates — Steps

**Last Updated**: 27/09/2026 | **Version**: 0.1.0 | **Maintained By**: Sam Bailey
**Language**: British English (en_GB) | **Timezone**: Europe/London

---

## Key references

Consult `how-to/REFERENCES.md` as you work through these steps. The gate list itself is the table in this
folder's `CONTEXT.md`.

| Step | Section |
| --- | --- |
| 1 | **Internal → Reference guides** → `how-to/docs/TOOLCHAIN.md` |
| 2 | **Internal → Cross-layer** → `code/docs/BUILD.md`, `code/docs/MEMORY-SAFETY.md` · **External — Debugging and memory** |
| 3 | **External — Toolchain and build** → Cargo book, Clippy documentation, cargo-deny book |
| 4 | **Internal → Cross-layer** → `code/docs/DOCUMENTATION-LENGTH.md`, `code/docs/DOCUMENTATION-PAIRING.md` |
| 5 | **External — Toolchain and build** → markdownlint-cli2, ShellCheck |
| 6–7 | **Internal → Cross-layer** → `code/src/scripts/CONTEXT.md`, `project-management/workflows/11-verification/` |

---

## Steps

### Step 1 — Confirm the gates can run

```bash
bash code/src/scripts/toolchain/check.sh
echo "exit=$?"
```

`exit=0`: carry on. `exit=2`: a required tool is missing, so every gate that needs it would also exit 2.
Fix the machine first through `how-to/workflows/05-debugging-environment/`.

_Done when `check.sh` exits 0._

### Step 2 — Run the C gates

Raw make targets first, from the repository root. Each one walks every `ms###-*/` exercise in turn:

```bash
make -C code/src/c
make -C code/src/c test
make -C code/src/c san
make -C code/src/c memcheck
make -C code/src/c lint
```

What a pass looks like, per exercise:

- `test` and `san` print `check: <n> passed, 0 failed`.
- `memcheck` also prints valgrind's `All heap blocks were freed -- no leaks are possible` and
  `ERROR SUMMARY: 0 errors from 0 contexts (suppressed: 0 from 0)`.
- `lint` prints `-fanalyzer found nothing in …` with the files it analysed.

A failure stops the walk and names the exercise and the one command to re-run alone, for example
`c: re-run it alone with: make -C code/src/c/ms001-hello test`. The `san` build turns off UBSan
recovery, so a `runtime error:` line fails the run as an ASan report does. Then run the scripts CI uses:

```bash
bash code/src/scripts/c/build.sh
bash code/src/scripts/c/test.sh
bash code/src/scripts/c/san.sh
bash code/src/scripts/c/memcheck.sh
bash code/src/scripts/c/lint.sh
```

_Done when all five make targets and all five scripts exit 0._

### Step 3 — Run the Rust gates

From inside the workspace, so the pinned 1.92.0 toolchain is the one that runs:

```bash
cd code/src/rust
cargo build --all-targets      # the test and example code too, as rust/build.sh does
cargo test
cargo fmt --check
cargo clippy --all-targets -- -D warnings
cargo deny check
cd ../../..
```

- `cargo test` ends each test binary with `test result: ok.` and no failures.
- `cargo fmt --check` prints nothing when formatted; a `Diff in …` block and exit 1 when not. Run
  `cargo fmt` to apply the diff, then read what changed.
- Clippy with `-D warnings` turns every warning, pedantic ones included, into an error.
- `cargo deny check` ends with `advisories ok, bans ok, licenses ok, sources ok`. It needs network access
  to refresh the advisory database.

Then the scripts:

```bash
bash code/src/scripts/rust/build.sh
bash code/src/scripts/rust/test.sh
bash code/src/scripts/rust/lint.sh
bash code/src/scripts/rust/audit.sh
```

`rust/audit.sh` exits 2 when cargo-deny is not installed; install it with `cargo install --locked
cargo-deny` rather than reading that as a pass.

_Done when every cargo command and all four scripts exit 0._

### Step 4 — Run the docs audits

`cloc` is the measuring tool behind the length audit; try it on one file to see the number the audit
compares against 300:

```bash
cloc --include-lang=Markdown --quiet --csv how-to/docs/CLI-TOOLING.md
bash code/src/scripts/audits/docs-length.sh
bash code/src/scripts/audits/docs-pairing.sh
```

The `code` column of the cloc CSV (the fifth field of the `Markdown` row) is the count that must stay at
or below 300 for instructional Markdown. `docs-length.sh` names every file over the cap;
`docs-pairing.sh` names every directory missing its `CONTEXT.md` or `CLAUDE.md` that
`code/src/scripts/audits/docs-pairing.exempt` does not excuse.

_Done when both audits exit 0._

### Step 5 — Run the CI-only lints locally (optional)

Markdown lint runs through `npx` (Node.js is on this machine). From the repository root it reads
`.markdownlint-cli2.jsonc`, whose globs select every Markdown file outside `build/` and `target/`:

```bash
npx --yes markdownlint-cli2
```

Shell lint needs `shellcheck`, which is not installed here yet. CI's `ubuntu-24.04` image ships
shellcheck 0.9.0, and Ubuntu 24.04's apt candidate is the same version (`sudo apt install shellcheck`):

```bash
find code/src/scripts .claude/hooks -name '*.sh' -print0 | xargs -0 -r shellcheck -x
```

`-x` lets shellcheck follow each script's `source` of `_lib/common.sh`, as CI does. The secrets scan
(`Audit — Secrets`, TruffleHog) runs in CI only. Skipping this step is allowed; say so in the
record rather than implying these gates passed locally.

_Done when each lint you ran exits 0, and any you skipped is named as skipped._

### Step 6 — Run the one-shot gate

```bash
bash code/src/scripts/gates/all.sh
echo "exit=$?"
```

`gates/all.sh` runs the toolchain check and then gates 1 to 11 in order, carrying on past a failure so one
run shows everything. It ends with a `| Gate | Result |` table marking each row PASS, FAIL or COULD NOT RUN,
and exits with the worst code it saw. `exit=0` (`ALL GATES PASS`) is green. `exit=1` names the failing gate;
fix it, re-run that gate's script on its own, then run `all.sh` again. `exit=2` means at least one gate
could not run. `all.sh --skip <gate>` exists for a gate you cannot run today; a SKIPPED row is recorded as
skipped, never as passed.

_Done when `gates/all.sh` exits 0 and its summary lists every gate as passed._

### Step 7 — Record the result

Quote the summary table where it will be read next:

- **During a study session:** in today's `learning/<track>-NN-<topic>/PROGRESS.md` entry
  (`how-to/workflows/02-daily-study-session/` Step 8).
- **At milestone end:** in the verification record under `project-management/src/10-PROGRESS/`, written
  through `project-management/workflows/11-verification/`.

_Done when the result, including any skipped CI-only lint, is written down._

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
