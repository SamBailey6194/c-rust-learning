# Machine Setup — Ubuntu 24.04

**Last Updated**: 27/09/2026 | **Version**: 0.1.0 | **Maintained By**: Sam Bailey
**Language**: British English (en_GB) | **Timezone**: Europe/London

The full host setup for this repository's toolchain, written as a runbook. It covers everything the C and
Rust phases need (Part A) and records the additions P4 will need (Part B, not yet run). Part A was checked
on 27/09/2026 on a machine that already had its packages: every check, version command and gate below was
run there and its output quoted, while the installers themselves (`apt install`, the rustup script,
`cargo install`, the first clone) had nothing left to do and were not re-run from a blank machine. The short, checklist-driven version of Part A is
`how-to/workflows/01-toolchain-setup/`; the versions it produces are recorded in `how-to/docs/TOOLCHAIN.md`.

---

## Purpose

Take an Ubuntu 24.04 LTS (x86_64) machine to one where `code/src/scripts/toolchain/check.sh` passes and
`code/src/scripts/gates/all.sh` runs every gate green, so study sessions start on a known-good toolchain.

---

## Prerequisites

- **Ubuntu 24.04 LTS on x86_64.** Other releases have different package versions; the recorded versions in
  `how-to/docs/TOOLCHAIN.md` assume this one.
- **A user who can run `sudo`.** Every `sudo` line in this runbook is run by the learner at the keyboard.
  Claude explains these lines but does not run them.
- **Network access** to the Ubuntu archive, `sh.rustup.rs` and `static.rust-lang.org` (rustup), `crates.io`
  (cargo-deny, crate dependencies) and GitHub (the clone, and cargo-deny's advisory database).
- **Disk space** for the Rust toolchain: the pinned 1.92.0 toolchain takes about 600 MB, and one workspace
  build (`code/src/rust/target/`) about 30 MB. Kernel builds at P4 need far more; that figure is measured
  when P4 opens.
- **bash** for the scripts under `code/src/scripts/` (any interactive shell is fine for typing commands).

What this machine already had on 27/09/2026, from `apt-cache policy`:

| Package | State |
| --- | --- |
| `build-essential` | installed, 12.10ubuntu1 |
| `gdb` | installed, 15.1-1ubuntu1~24.04.1 |
| `valgrind` | installed, 1:3.22.0-0ubuntu3 |
| `qemu-system-x86` | installed, 1:8.2.2+ds-0ubuntu1.18 |
| `cloc` | installed, 1.98-1 |
| `git`, `curl` | installed, 1:2.43.0-1ubuntu7.3 and 8.5.0-2ubuntu10.15 |
| `bc`, `cpio`, `libssl-dev`, `libncurses-dev`, `busybox-static` | installed (P4 helpers) |
| `llvm` | installed, 1:18.0-59~exp2 (P4 helper) |
| `flex`, `bison`, `libelf-dev`, `dwarves` | **not installed** (P4, Part B) |
| `clang`, `lld`, `libclang-dev`, `bindgen-0.71` | **not installed** (P4, Part B) |
| `shellcheck` | **not installed** (optional; candidate 0.9.0-1) |

---

## Steps

### Part A — the C and Rust toolchain

#### 1. Confirm the operating system

```bash
grep -E '^(PRETTY_NAME|VERSION_ID)' /etc/os-release
uname -m
```

Success:

```text
PRETTY_NAME="Ubuntu 24.04.5 LTS"
VERSION_ID="24.04"
x86_64
```

Any other `VERSION_ID` → the package versions below differ; continue, but expect Step 11 to show a
different version table and route the difference through `how-to/workflows/04-toolchain-updates/`.

#### 2. See what is already installed

```bash
apt-cache policy build-essential gdb valgrind qemu-system-x86 cloc git curl | grep -E '^[a-z]|Installed'
```

Success: each package name followed by an `Installed:` line. On this machine every one showed a version,
for example:

```text
build-essential:
  Installed: 12.10ubuntu1
gdb:
  Installed: 15.1-1ubuntu1~24.04.1
```

`Installed: (none)` marks a package Step 3 will install.

#### 3. Install the apt packages

The learner runs:

```bash
sudo apt update
sudo apt install build-essential gdb valgrind qemu-system-x86 cloc git curl
```

Success: apt finishes without an `E:` line, and re-running Step 2 shows a version for every package.
Packages already present are reported as `already the newest version` and left alone. If apt reports
`E: Unable to locate package` → Failure modes.

#### 4. Install rustup

Skip this step if `rustup --version` already prints a version.

```bash
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
. "$HOME/.cargo/env"
rustup --version
```

Accept the default installation when asked. Success: `rustup --version` prints a version; this machine
shows `rustup 1.28.2 (e4f3ad6f8 2025-04-28)`. rustup 1.28.1 or later is wanted, because 1.28.0 did not
install a pinned toolchain automatically.

#### 5. Add the Rust components and cargo-deny

```bash
rustup component add rustfmt clippy
cargo install --locked --version 0.19.0 cargo-deny
cargo deny --version
```

`rustup component add` covers the host default toolchain. `cargo install` builds cargo-deny from source,
which takes a few minutes. The version is pinned to the one `how-to/docs/TOOLCHAIN.md` records and CI runs
(`CARGO_DENY_VERSION` in `.github/workflows/syntax-rust.yml`); `how-to/workflows/04-toolchain-updates/`
moves them together. Success: `cargo deny --version` prints `cargo-deny 0.19.0`.

#### 6. Clone the repository

```bash
git clone https://github.com/SamBailey6194/c-rust-learning.git
cd c-rust-learning
```

Success: `git status` prints `On branch main` and `nothing to commit, working tree clean`. Every remaining
step runs from the root of this clone.

#### 7. Install the pinned Rust toolchain

```bash
cd code/src/rust
rustup show active-toolchain || rustup toolchain install
rustc --version
cd ../../..
```

Success:

```text
1.92.0-x86_64-unknown-linux-gnu (overridden by '.../code/src/rust/rust-toolchain.toml')
rustc 1.92.0 (ded5c06cf 2025-12-08)
```

The path in brackets is wherever you cloned. `rust-toolchain.toml` also pulls in `rustfmt` and `clippy`
for this toolchain. If the first line is an error instead → Failure modes.

#### 8. Optional: markdownlint through Node.js

Markdown lint runs in CI regardless. To run it locally you need Node.js and `npx`. This machine runs
Node.js 24.13.0 (installed outside apt, through nvm), with which `npx --yes markdownlint-cli2` fetched and
ran markdownlint-cli2 0.23.3. Ubuntu 24.04's own `nodejs` package is 18.19.1; whether the current
markdownlint-cli2 runs on it has not been tested here.

```bash
node --version
npx --yes markdownlint-cli2 --help | head -1
```

Success: a Node.js version, then `markdownlint-cli2 v0.23.3 (markdownlint v0.41.1)` or newer.

#### 9. Optional: shellcheck

CI's `ubuntu-24.04` image ships shellcheck 0.9.0, and Ubuntu 24.04's candidate is the same 0.9.0-1, so a
local install matches CI. The learner runs:

```bash
sudo apt install shellcheck
shellcheck --version
```

#### 10. Optional now, needed at P4: KVM access for QEMU

QEMU runs much faster with KVM. Check that `/dev/kvm` exists and that you can use it:

```bash
ls -l /dev/kvm
id -nG | tr ' ' '\n' | grep -x kvm
```

Success on this machine: `crw-rw----+ 1 root kvm 10, 232 …` and `kvm`. The `+` means an access-control
list also grants the logged-in user access. If `grep` prints nothing and `-enable-kvm` later fails with a
permission error, the learner adds the user to the group and logs out and in again:

```bash
sudo usermod -aG kvm "$USER"
```

#### 11. Record the version table

```bash
bash code/src/scripts/toolchain/check.sh
echo "exit=$?"
```

Success: a `| Tool | Version |` table (gcc 13.3.0, make 4.3, gdb 15.1, valgrind 3.22.0, cargo, rustc 1.92.0,
rustfmt 1.8.0, clippy-driver 0.1.92, qemu-system-x86_64 8.2.2, cloc 1.98, cargo-deny 0.19.0), then
`PASS: every required tool is present; rustc matches the pin (1.92.0).` and `exit=0`. Compare it with the
Overview in `how-to/docs/TOOLCHAIN.md`.

### Part B — P4 additions (not yet run on this machine)

Run these when P4 (kernel internals) opens, per `project-management/src/01-ROADMAP/ROADMAP.md`. The package
names were confirmed with `apt-cache policy` and a simulated install (`apt-get -s install …`, which needs no
privilege) on 27/09/2026; the installs themselves have not been run.

#### 12. Kernel build packages

```bash
sudo apt install flex bison libelf-dev dwarves
```

The simulated install adds `libfl2`, `libfl-dev`, `libzstd-dev` and `pahole` 1.25 as dependencies.
`bc`, `cpio`, `libssl-dev`, `libncurses-dev` and `busybox-static` are already present. Check `pahole`
against the minimum in the kernel's `Documentation/process/changes.rst` for the kernel version chosen at P4
(`how-to/docs/TOOLCHAIN.md` → P4 prerequisites).

#### 13. Rust-for-Linux packages

```bash
sudo apt install clang lld libclang-dev bindgen-0.71
```

The simulated install pulls in 21 packages. `bindgen-0.71` installs a `bindgen-0.71` binary rather than
`bindgen`; the kernel's Rust quick start (docs.kernel.org/rust/quick-start.html) shows how to select it.
The kernel build also needs the `rust-src` component for whichever Rust toolchain it uses:
`rustup component add rust-src`. `make LLVM=1 rustavailable` in the kernel tree then reports whether
everything is found.

---

## Failure modes

The first three and the gdb prompt were met while checking this runbook on 27/09/2026; the apt case is
the standard one and is included because Step 3 is where a new machine most often stops.

### `error: toolchain '1.92.0-x86_64-unknown-linux-gnu' is not installed`

Seen with automatic installation switched off (`RUSTUP_AUTO_INSTALL=0`); rustup 1.28.0 behaves the same by
default. rustup prints the fix under it, ``help: run `rustup toolchain install` to install it``. Run that
from inside `code/src/rust/`, then repeat Step 7.

### `rustc 1.85.0 is not supported by the following packages`

An older toolchain was active: cargo was started in a directory where the pin does not apply (including
`cargo --manifest-path …` from the repository root, which uses the host default toolchain). Run cargo from
inside `code/src/rust/`; `rustup show active-toolchain` there names the pin.

### ``error: no such command: `deny` ``

cargo-deny is not installed for this user. Repeat Step 5. Until it is installed, `rust/audit.sh` exits 2.

### `Installed: (none)` after Step 3

apt did not install the package. Scroll back through the apt output for the `E:` line; the usual causes
are a typo in the package name or an unfinished `sudo apt update`. `E: Unable to locate package` for a name
listed here means the package index is stale: re-run `sudo apt update`.

### gdb stops at `Enable debuginfod for this session? (y or [n])`

Not a failure: gdb 15 offers to download debug symbols for system libraries. Answer `n`, or add
`set debuginfod enabled off` to `~/.gdbinit`. Anything else gdb or the sanitisers do on this host is in
`how-to/workflows/05-debugging-environment/`.

---

## Rollback

Each part can be undone on its own. Destructive lines are flagged.

```bash
# apt packages installed in Step 3, 9, 12 or 13 (the learner runs this; name only what you added)
sudo apt remove flex bison libelf-dev dwarves

# The pinned toolchain only
rustup toolchain uninstall 1.92.0

# cargo-deny
cargo uninstall cargo-deny

# DESTRUCTIVE: removes rustup, every Rust toolchain and everything cargo installed under ~/.cargo
rustup self uninstall

# Undo Step 10's group change (the learner runs this)
sudo gpasswd -d "$USER" kvm
```

Removing packages that were already present before this runbook (see the Prerequisites table) is not a
rollback: leave `build-essential`, `gdb`, `valgrind`, `qemu-system-x86` and `cloc` alone unless you
installed them in Step 3. Packages apt pulled in as dependencies are cleared by an autoremove, which the
reboot-purge repository handles with a preview (`how-to/src/HOST-MAINTENANCE.md`).

Deleting the clone is **destructive**: uncommitted and unpushed work in it is lost. Push first.

---

## Verification

Independently of the output each step printed, run the whole gate set from the clone's root:

```bash
bash code/src/scripts/gates/all.sh
echo "exit=$?"
```

Success: every row of the closing `| Gate | Result |` table reads `PASS` — `toolchain/check`, the five C
gates (`c/build`, `c/test`, `c/san`, `c/memcheck`, `c/lint`), the four Rust gates (`rust/build`,
`rust/test`, `rust/lint`, `rust/audit`) and the two docs audits — followed by `ALL GATES PASS` and
`exit=0`. Any `FAIL` or `COULD NOT RUN` row names the gate to investigate:
`how-to/workflows/03-quality-gates/` for failures, `how-to/workflows/05-debugging-environment/` for gates
that could not run.

For Part B, verification waits for P4: the planned `07-kernel-source-setup` and `08-build-and-boot-kernel`
workflows end with a kernel booting to a busybox shell in QEMU.
