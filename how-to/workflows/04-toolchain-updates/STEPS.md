---
workflow: 04-toolchain-updates
phase: maintain
skills: [research]
---

# Toolchain Updates — Steps

**Last Updated**: 27/09/2026 | **Version**: 0.1.0 | **Maintained By**: Sam Bailey
**Language**: British English (en_GB) | **Timezone**: Europe/London

---

## Key references

Consult `how-to/REFERENCES.md` as you work through these steps:

| Step | Section |
| --- | --- |
| 1 | **External — Toolchain and build** → rustup book · **Internal → Reference guides** → `how-to/docs/TOOLCHAIN.md` |
| 2 | **Internal → Cross-layer** → `project-management/workflows/08-decisions/` |
| 3 | **External — Toolchain and build** → rustup book (toolchain file), cargo-deny book |
| 4 | **Internal → Operator guides** → `how-to/src/HOST-MAINTENANCE.md` |
| 5 | **Internal → Steps & checklists** → `how-to/workflows/03-quality-gates/STEPS.md` |
| 6–7 | **Internal → Reference guides** → `how-to/docs/TOOLCHAIN.md` · **Internal → Cross-layer** → `project-management/docs/git/COMMITS.md` |

---

## Steps

### Step 1 — See what would change

```bash
rustup check
cargo install --list | grep -A1 '^cargo-deny'
apt list --upgradable 2>/dev/null | grep -E '^(gcc|cpp|gdb|valgrind|qemu-system|make|cloc)'
```

`rustup check` lists channel toolchains with an update, for example
`stable-x86_64-unknown-linux-gnu - Update available : 1.92.0 (…) -> 1.98.1 (…)`. The pinned 1.92.0
toolchain is not listed: a toolchain named by exact version has nothing to update. `apt list` shows host
packages with a newer candidate. Compare both with the Overview table in `how-to/docs/TOOLCHAIN.md`.

_Done when you know which tools would move and whether any of them is the Rust pin._

### Step 2 — Decide on the Rust pin, and record it

Moving the pin is a decision. State the driver in one line (a feature, a lint, a fix, a kernel minimum),
then write the ADR through `project-management/workflows/08-decisions/`: a new
`ADR-MS###-RUST-TOOLCHAIN-<VERSION>-DD-MM-YYYY.md` that supersedes the current pin ADR, with the new
version, the reason, and what the upgrade is expected to break (new lints, new warnings). If the answer is
"not now", nothing moves and Step 3 is skipped.

_Done when the ADR is Accepted with the learner's reason in it, or the pin is deliberately left alone._

### Step 3 — Move the pin as a matched set

Update the channel toolchains, then change the two pin files together (use the version the ADR names):

```bash
rustup update stable
cd code/src/rust
```

Edit `rust-toolchain.toml` (`channel = "<new version>"`) and `Cargo.toml` (`rust-version` under
`[workspace.package]`), then install and prove the new pin from inside the workspace:

```bash
rustup show active-toolchain || rustup toolchain install
rustc --version
cargo build
cargo test
cargo fmt --check
cargo clippy --all-targets -- -D warnings
cd ../../..
```

`rustc --version` prints the new version. New clippy lints are expected; fix them, or argue a scoped
`#[allow(…)]` in the ADR.

**cargo-deny moves as its own matched set**, pinned so that the supply-chain gate asks the same question
on this machine as in CI. To move it, install the new release by version and change every place that
names the old one in the same change — `CARGO_DENY_VERSION` in `.github/workflows/syntax-rust.yml` and
the install lines in the how-to docs and `code/src/scripts/rust/audit.sh`:

```bash
cargo install --locked --version <new version> cargo-deny
grep -rn -e '--version <old version> cargo-deny' -e 'CARGO_DENY_VERSION: <old version>' .
```

Leaving cargo-deny where it is, on purpose, is also a choice; say so in the pull request.

_Done when the new toolchain is active in `code/src/rust/` and builds, tests, formats and lints clean, and
cargo-deny's version is the same on this machine and in CI._

### Step 4 — Upgrade the host packages through reboot-purge

Host maintenance belongs to the reboot-purge repository (`how-to/src/HOST-MAINTENANCE.md`), which is not
published yet (`GAPS.md`). Until it is, the learner runs the upgrade by hand, reading the list before
agreeing to it:

```bash
sudo apt update
apt list --upgradable
sudo apt upgrade
```

A kernel or driver update can need a reboot; Ubuntu marks a pending one by creating
`/var/run/reboot-required`, which `cat /var/run/reboot-required` prints when it exists.

_Done when the upgrade has run, or has been deliberately deferred and noted._

### Step 5 — Run every gate on the new toolchain

Run `how-to/workflows/03-quality-gates/` in full, ending with:

```bash
bash code/src/scripts/gates/all.sh
echo "exit=$?"
```

A newer gcc can add warnings that `-Werror` turns into build failures; a newer valgrind can report what the
old one missed. Each new finding is fixed now, on this branch, not waved through.

_Done when `gates/all.sh` exits 0 on the updated toolchain._

### Step 6 — Re-record the versions

```bash
bash code/src/scripts/toolchain/check.sh
```

Copy the printed versions into the Overview table of `how-to/docs/TOOLCHAIN.md`, refresh its
`**Last Updated**` line, and update any P4 row whose status changed (for example a package now installed).
Close any `GAPS.md` entry the update resolved with its `✅ CLOSED <date>` marker.

_Done when every row of the Overview table matches the `check.sh` output._

### Step 7 — Commit by explicit path

On a branch named per `project-management/docs/git/BRANCHES.md`, stage each file by name and commit each
concern with its own scope, for example:

```bash
git add code/src/rust/rust-toolchain.toml code/src/rust/Cargo.toml code/src/rust/Cargo.lock
git commit -m "build(rust): move toolchain pin to <new version>"
git add .github/workflows/syntax-rust.yml code/src/scripts/rust/audit.sh   # only if cargo-deny moved
git commit -m "ci(rust): move cargo-deny to <new version>"
git add how-to/docs/TOOLCHAIN.md
git commit -m "docs(how-to): re-record toolchain versions"
```

A moved cargo-deny also changes the install lines the Step 3 `grep` found in the how-to docs; stage each
by name with the `docs(how-to)` commit. The ADR is committed through its own workflow with scope `pm`.
Everything lands in the same pull request, so the pins, the reason and the record move together.

_Done when `git status` shows nothing from this update left uncommitted._

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
