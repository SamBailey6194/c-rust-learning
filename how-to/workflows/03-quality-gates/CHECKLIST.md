---
workflow: 03-quality-gates
phase: run
skills: []
---

# Quality Gates — Checklist

**Last Updated**: 27/09/2026 | **Version**: 0.1.0 | **Maintained By**: Sam Bailey
**Language**: British English (en_GB) | **Timezone**: Europe/London

---

> **See** `how-to/REFERENCES.md` → **Internal → Cross-layer** (`code/docs/BUILD.md`,
> `code/src/scripts/CONTEXT.md`) · **External — Toolchain and build** · **External — Debugging and
> memory** for supporting references.

## Execution Checklist

### Step 1 — Confirm the gates can run

- [ ] `toolchain/check.sh` exited 0

### Step 2 — Run the C gates

- [ ] **[1]** `c/build.sh` — every exercise builds under `-Werror`
- [ ] **[2]** `c/test.sh` — `check: <n> passed, 0 failed` for every exercise
- [ ] **[3]** `c/san.sh` — no ASan report and no UBSan `runtime error:` line
- [ ] **[4]** `c/memcheck.sh` — `All heap blocks were freed -- no leaks are possible`, zero errors
- [ ] **[5]** `c/lint.sh` — `-fanalyzer` found nothing
- [ ] The raw `make -C code/src/c <target>` form of each was run at least once this session

### Step 3 — Run the Rust gates

- [ ] Cargo run from inside `code/src/rust/`, so the 1.92.0 pin applied
- [ ] **[6]** `rust/build.sh` — builds
- [ ] **[7]** `rust/test.sh` — every `test result: ok.`
- [ ] **[8]** `rust/lint.sh` — `cargo fmt --check` clean and clippy clean under `-D warnings`
- [ ] **[9]** `rust/audit.sh` — `advisories ok, bans ok, licenses ok, sources ok`

### Step 4 — Run the docs audits

- [ ] **[10]** `audits/docs-length.sh` — no instructional Markdown over 300 cloc code lines
- [ ] **[11]** `audits/docs-pairing.sh` — every non-exempt directory has `CONTEXT.md` and `CLAUDE.md`

### Step 5 — Run the CI-only lints locally (optional)

- [ ] **[12]** shellcheck clean, or recorded as skipped (not installed locally)
- [ ] **[13]** `npx --yes markdownlint-cli2` clean from the root, or recorded as skipped
- [ ] **[14]** Secrets scan (TruffleHog) left to CI and not claimed as a local pass

### Step 6 — Run the one-shot gate

- [ ] `gates/all.sh` printed `ALL GATES PASS`; its summary table was read, not only its exit code
- [ ] Any gate left out with `--skip` is recorded as skipped

### Step 7 — Record the result

- [ ] Summary quoted into the PROGRESS entry or the milestone verification record

## Exit-code contract

- [ ] Every gate that exited 2 is recorded as **could not run**, never as passed
- [ ] `gates/all.sh` exit code equals the worst gate code (2 over 1 over 0)

---

## Context

- [ ] Directory trees in the relevant `CONTEXT.md` files show every file or folder this workflow created
- [ ] `how-to/REFERENCES.md` lists any new guide, workflow or external source
- [ ] `**Last Updated**` is refreshed in every `CONTEXT.md` modified
- [ ] If the session ended mid-work, a handoff exists in `handoffs/`

---

## Definition of Done

- [ ] Gates 1 to 11 green through `gates/all.sh`, with no exit 2 anywhere in the summary
- [ ] Nothing suppressed to get there: no new `-Wno-…`, `#[allow(…)]`, valgrind suppression or skipped test
      without a stated, agreed reason
- [ ] CI-only gates either run locally and clean, or named as left to CI
- [ ] Local and CI agree; any disagreement was fixed in the scripts or workflows, not pushed around
