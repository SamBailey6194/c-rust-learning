# GAPS.md — Active Gaps, Blockers & Open Questions

**Last Updated**: 27/09/2026 | **Maintained By**: Sam Bailey
**Language**: British English (en_GB)

Tracks what currently stands between c-rust-learning and its next phases: missing tools,
knowledge gaps, blocked milestones and open questions. **Not** a memory store — feedback,
patterns and observations go in `.claude/MEMORY.md`. Topics deliberately parked for a later
phase go in `DEFERRED.md`.

Resolved entries are marked `✅ CLOSED <date>` and removed on the next tidy pass. A permanent
decision that comes out of an entry is promoted to the doc that owns it — the promotion table is
in `.claude/CLAUDE.md` Section 7, which owns that workflow; it is not restated here.

**Read when planning.** Check this file before a milestone is opened or planned
(`project-management/workflows/02-milestone-creation/`, `09-milestone-plans/`), so a known blocker
is scheduled around rather than discovered mid-milestone.

## Format

Append a new entry at the top, newest first:

```text
## DD/MM/YYYY — <title>

**Type:** <Toolchain gap | Knowledge gap | Blocked milestone | Open question>
**Summary:** …
**Blocked by / Action:** …
```

---

## 27/09/2026 — GTK 4 development files not installed

**Type:** Toolchain gap
**Summary:** The GTK 4.14.5 runtime (`libgtk-4-1`) is installed, but its development files are not:
`libgtk-4-dev` (candidate `4.14.5+ds-0ubuntu0.10`) is absent and `pkg-config --modversion gtk4`
reports "Package gtk4 was not found" (27/09/2026). The gtk4-rs book installs `libgtk-4-dev` on
Debian and its derivatives
(<https://gtk-rs.org/gtk4-rs/stable/latest/book/installation_linux.html>), so no gtk4-rs crate
builds here yet — and CI's `ubuntu-24.04` runner lacks the package too.
**Blocked by / Action:** Blocks the gtk4-rs builds in `learning/ui-08-gui-foundations/` (lessons
03–05). When U3 opens, Sam installs it (`sudo apt install libgtk-4-dev`) and records the version in
`how-to/docs/TOOLCHAIN.md`; the milestone that adds the first gtk4-rs crate also installs it in
`.github/workflows/syntax-rust.yml` and lands the `target-lexicon` exception (see "Per-crate licence
exceptions arrive with the first crate that needs them" below). Close this entry when that crate
builds locally and in CI.

## 27/09/2026 — diffoscope not installed

**Type:** Toolchain gap
**Summary:** diffoscope is not installed on the host: `command -v diffoscope` finds nothing, and
Ubuntu 24.04's candidate is 259 (27/09/2026; `how-to/docs/TOOLCHAIN.md` → P6 prerequisites).
**Blocked by / Action:** Blocks the diffoscope half of
`learning/os-05-build-system-and-reproducibility/` lesson 05; the hash comparison of two
independent rebuilds runs without it. Sam installs it (`sudo apt install diffoscope`) when that
lesson opens and records the version in `how-to/docs/TOOLCHAIN.md`, then closes this entry.

## 27/09/2026 — git send-email and b4 not installed

**Type:** Toolchain gap
**Summary:** Neither tool for sending a patch series by email is installed: `git send-email -h`
reports "'send-email' is not a git command" (Ubuntu ships it in `git-email`, candidate
`1:2.43.0-1ubuntu7.3`, matching the installed git 2.43.0), and `command -v b4` finds nothing
(candidate `0.13.0-1`), checked 27/09/2026.
**Blocked by / Action:** Blocks `learning/kernel-07-upstreaming/` lesson 04 (sending a series as
plain-text email) only. Sam installs either himself when kernel-07 opens
(`sudo apt install git-email` or `sudo apt install b4`), records the version in
`how-to/docs/TOOLCHAIN.md`, then closes this entry.

## 27/09/2026 — Per-crate licence exceptions arrive with the first crate that needs them

**Type:** Toolchain gap
**Summary:** Two Accepted ADRs admit crates that `code/src/rust/deny.toml` rejects today.
`project-management/src/08-DECISIONS/ADR-MS001-LLM-RUST-CRATE-LICENCES-27-09-2026.md` covers the
Apache-2.0-only crates lessons may use: `safetensors`, `tokenizers`, `hf-hub` and `insta` are each
licensed `Apache-2.0` on crates.io, and `llama-cpp-2` reaches `clang-sys` (`Apache-2.0`) as a build
dependency through `bindgen`. `project-management/src/08-DECISIONS/ADR-MS001-GUI-TOOLKIT-GTK4-27-09-2026.md`
covers gtk4 0.11, which reaches `target-lexicon` (`Apache-2.0 WITH LLVM-exception`) only as a build
dependency, through `system-deps` → `cfg-expr`. (Licences from crates.io and graphs from `cargo tree`
on scratch crates outside this repository, 27/09/2026.) No exception is written yet, because no crate
in the workspace uses them; `code/src/scripts/rust/audit.sh` fails the first milestone that adds one
until its exception lands. `BSL-1.0`, which ratatui needs, is already on the allow list.
**Blocked by / Action:** In the milestone that first adds such a crate, add a
`[[licenses.exceptions]]` entry per crate to `code/src/rust/deny.toml`, each citing its ADR and the
reason (this repository is for learning and distributes no binaries), and run the audit gate before
building. Plan it in that milestone's `00-PLAN`; close this entry when the last named crate is in.

## 27/09/2026 — CUDA toolkit (`nvcc`) not installed

**Type:** Toolchain gap
**Summary:** The NVIDIA driver is installed (580.178.04; `nvidia-smi` reports CUDA Version 13.0 for
the RTX 2080 Ti, compute capability 7.5), but the CUDA toolkit is not: `command -v nvcc` finds
nothing (27/09/2026).
**Blocked by / Action:** Blocks `learning/llm-08-gpu-kernels-in-cuda/` and the CUDA path of
`learning/llm-09-llm-c/` (their CPU lessons are unaffected). Before L2, answer which toolkit suits
driver 580 with the `CUDA-TOOLKIT-FOR-DRIVER-580.md` research note (planned, `research/CONTEXT.md`);
Sam installs it and records the version in `how-to/docs/TOOLCHAIN.md`.

## 27/09/2026 — Nsight Systems and Nsight Compute not installed

**Type:** Toolchain gap
**Summary:** Neither `nsys` nor `ncu` is installed (27/09/2026). Even once installed, Nsight Compute
cannot collect GPU counters as Sam's user while the driver restricts profiling to administrators
(see "perf and GPU performance counters are locked" below).
**Blocked by / Action:** `learning/llm-07-gpu-architecture-and-vram-budgets/` profiles with
`torch.profiler` until Nsight is installed. Install with the CUDA toolkit at L2 and record it in
`how-to/docs/TOOLCHAIN.md`.

## 27/09/2026 — perf and GPU performance counters are locked for unprivileged users

**Type:** Toolchain gap
**Summary:** `kernel.perf_event_paranoid` is **4** on this host (`/proc/sys/kernel/perf_event_paranoid`),
above the kernel's documented default of 2
(<https://docs.kernel.org/admin-guide/sysctl/kernel.html> → perf_event_paranoid), and `perf stat`
run as Sam's user fails with "No supported events found" (perf 7.0.14, 27/09/2026). The NVIDIA
driver reports `RmProfilingAdminOnly: 1` (`/proc/driver/nvidia/params`), so GPU performance counters
are admin-only; NVIDIA documents the `NVreg_RestrictProfilingToAdminUsers` module option that
controls it
(<https://developer.nvidia.com/nvidia-development-tools-solutions-err_nvgpuctrperm-permission-issue-performance-counters>).
**Blocked by / Action:** Decided 27/09/2026: a lesson that needs counters shows Sam how to relax
the restriction for one session and how to restore it, and Sam runs the commands — Claude never
runs `sudo` (`.claude/CLAUDE.md` Section 5). Every such lesson also teaches the unprivileged
fallback (`valgrind --tool=cachegrind` on the CPU, `torch.profiler` on the GPU). Close this entry
only if Sam relaxes either setting permanently, recording it in `how-to/docs/TOOLCHAIN.md`.

## 27/09/2026 — LLM track tools not installed

**Type:** Toolchain gap
**Summary:** Missing on 27/09/2026: PyTorch (installed per project through uv, not system-wide),
pytest, hyperfine, heaptrack, the llama.cpp binaries, git-lfs, cmake and clang. Installed: python3,
uv, ruff, ollama and the NVIDIA driver (versions in `how-to/docs/TOOLCHAIN.md`).
**Blocked by / Action:** Each is installed when the first lesson that needs it opens, and recorded
in `how-to/docs/TOOLCHAIN.md` → L1–L2 prerequisites. Which PyTorch build suits compute capability
7.5 is the `PYTORCH-SM75-SUPPORT.md` research note (planned) before L1's toolchain lesson.

## 27/09/2026 — CI has no GPU

**Type:** Open question
**Summary:** The CI gates run on GitHub's standard `ubuntu-24.04` runners, which offer CPU, memory
and disk but no GPU; GPU runners exist only among the paid larger runners
(<https://docs.github.com/en/actions/reference/runners/github-hosted-runners>, read 27/09/2026).
CUDA and GPU tests therefore cannot run in CI as it stands.
**Blocked by / Action:** Decide at L2, by ADR, whether GPU code is compile-only in CI (a toolkit in
the runner, no execution) or local-only with its evidence recorded in
`project-management/src/10-PROGRESS/`.

## 27/09/2026 — L6 compute budget and provider not chosen

**Type:** Open question
**Summary:** `learning/llm-21-scaling-on-bare-metal/` rents bare-metal GPUs for a ~1B-parameter base
model. Neither the budget nor the provider is chosen, and prices move, so they are checked on the
day rather than recorded here.
**Blocked by / Action:** Decide by ADR before the first L6 milestone that rents hardware.

## 27/09/2026 — No hardware chosen for the Syntek OS profiles

**Type:** Open question
**Summary:** No hardware is selected yet for the NAS, router, homelab, server ("business server" is
the `server` profile) or laptop and PC profiles. Every lesson runs in VMs or QEMU first.
**Blocked by / Action:** Choose each profile's hardware by ADR when its topic opens. Real-hardware
tests run only on dedicated, wiped test hardware named in the milestone — never the host, never the
home network (`.claude/CLAUDE.md` Section 5).

## 27/09/2026 — A VM with spare disk for the LFS build

**Type:** Toolchain gap
**Summary:** `learning/os-03-lfs-toolchain/` and `learning/os-04-lfs-base-system/` build Linux From
Scratch inside a VM, never on the host's disks. The LFS 13.1-systemd book sizes a minimal build
partition at around 10 GB and calls a 20 GB root partition a good compromise
(<https://www.linuxfromscratch.org/lfs/view/stable-systemd/chapter02/creatingpartition.html>,
Section 2.4). Its host requirements (Section 2.2) then apply to the VM's own system, not this
host. No such VM exists yet.
**Blocked by / Action:** Before P6's LFS topics, create the VM on a QEMU disk image (qemu-img and
OVMF are installed; `how-to/docs/TOOLCHAIN.md` → P6 prerequisites) with room for the build and its
snapshots.

## 27/09/2026 — ZFS licence and kernel range for the NAS profile

**Type:** Open question
**Summary:** OpenZFS is licensed CDDL, and zfs-2.4.4 declares support for Linux 4.18 to 7.2
(`META` at <https://raw.githubusercontent.com/openzfs/zfs/zfs-2.4.4/META>). The FSF lists the CDDL
as incompatible with the GNU GPL, so a GPL module and a CDDL module cannot legally be linked
(<https://www.gnu.org/licenses/license-list.html#CDDL>, read through the Internet Archive's copy
on 27/09/2026 because gnu.org did not answer). Shipping ZFS would pin the NAS profile's kernel line
to OpenZFS's declared range.
**Blocked by / Action:** Decide by ADR at `learning/os-13-nas-edition/` whether the NAS profile
offers ZFS at all; until then it is studied as reading.

## 27/09/2026 — Fuzzing Rust needs a nightly toolchain

**Type:** Open question
**Summary:** cargo-fuzz requires the nightly compiler for its sanitiser flags
(<https://rust-fuzz.github.io/book/cargo-fuzz/setup.html>), while the workspace pins stable 1.92.0
(`code/src/rust/rust-toolchain.toml`). Parser lessons test hostile input with property tests on
stable until this is settled.
**Blocked by / Action:** Decide by ADR at `learning/sec-03-fuzzing/` whether a separate nightly
toolchain, outside the pinned workspace, is allowed for fuzzing.

## 27/09/2026 — Security lab tools and the attacker VM

**Type:** Toolchain gap
**Summary:** On 27/09/2026 the host has nmap 7.94SVN, tcpdump 4.99.4 and libvirt 10.0.0, but not
Wireshark, clang with libFuzzer, AFL++, Ghidra or pwntools, and there is no attacker VM image yet.
`learning/sec-08-web-application-security/` also needs an intercepting proxy (ZAP or Burp Suite
Community) and the OWASP Juice Shop image; neither is on the host (no `zaproxy` or `burpsuite`
binary and no Juice Shop container image, checked 27/09/2026). Attack tooling runs in VMs, never on
the host (`.claude/CLAUDE.md` Section 5).
**Blocked by / Action:** Blocks S1's fuzzing topic (clang or AFL++) and the S2 lab. Build the
attacker VM and the isolated lab network in `learning/sec-06-pentest-lab-setup/`; the proxy goes in
the attacker VM and Juice Shop runs as a lab target inside that network. Install host-side tools
only for work on Sam's own code (fuzzing, reverse engineering his own binaries), recording each in
`how-to/docs/TOOLCHAIN.md`.

## 27/09/2026 — ShellCheck not installed locally

**Type:** Toolchain gap
**Summary:** `shellcheck` is not installed on the host (Ubuntu 24.04's candidate is 0.9.0, the
version CI's runner carries). The `Syntax — Shell` CI gate runs it over the script folders listed in
`.github/workflows/syntax-shell.yml`, so a shell exercise from
`learning/tooling-03-shell-scripting/` is linted only in CI, and only once its folder is on that
list.
**Blocked by / Action:** Sam installs it (`sudo apt install shellcheck`) when tooling-03 opens and
records it in `how-to/docs/TOOLCHAIN.md`.

---

## 27/09/2026 — Sibling repository reboot-purge not yet published — ✅ CLOSED 27/09/2026

**Resolution:** reboot-purge was published at <https://github.com/SamBailey6194/reboot-purge> on
27/09/2026. The "(not yet published)" markers are gone and `how-to/src/HOST-MAINTENANCE.md` carries
its feature signpost again. The host upgrade in Step 4 still runs by hand, because reboot-purge's
interactive upgrade script is on its roadmap and not yet built.

**Type:** Toolchain gap
**Summary:** The how-to layer routes host maintenance (health checks, cleanup, routine
`apt upgrade`) to the sibling repository <https://github.com/SamBailey6194/reboot-purge>, but that
repository has not been published: the URL returns 404 (checked 27/09/2026). Until it exists, every
link to it is marked "(not yet published)" and the host upgrade in
`how-to/workflows/04-toolchain-updates/` Step 4 runs by hand.
**Blocked by / Action:** Publish reboot-purge, public and with at least its README, before this
repository goes public. Then remove the "(not yet published)" markers in `how-to/`, restore the
feature summary in `how-to/src/HOST-MAINTENANCE.md` from its README, and close this entry.

## 27/09/2026 — pahole minimum for P4 is unclear

**Type:** Open question
**Summary:** The kernel's minimal-requirements page (<https://docs.kernel.org/process/changes.html>,
read 27/09/2026) gives two different pahole minimums: its requirements table lists pahole **1.26**,
while its pahole paragraph says BTF generation under `CONFIG_DEBUG_INFO_BTF` needs **v1.22 or
later**. Ubuntu 24.04's `dwarves` package provides pahole **1.25** (`apt-cache policy dwarves`:
candidate `1.25-0ubuntu3`), which satisfies the paragraph but not the table.
**Blocked by / Action:** Settle before the first P4 milestone is planned: with a kernel tree
fetched, read the version check in its own build scripts for the release being built, and try a
build with the P4 config. If 1.25 is refused, choose between disabling `CONFIG_DEBUG_INFO_BTF` in
the P4 config and building pahole from source; record the answer in `how-to/docs/TOOLCHAIN.md`
and the P4 kernel plan, then close this entry.

## 27/09/2026 — Kernel build dependencies not installed

**Type:** Toolchain gap
**Summary:** Building a kernel needs host tools the machine does not have yet. `flex` and `bison`
generate the kernel's lexers and parsers during the build (required since Linux 4.16);
`libelf-dev` supplies libelf, which objtool — built and run during a typical x86_64 kernel
build — links against; `dwarves` supplies `pahole`, which generates BTF type information when
`CONFIG_DEBUG_INFO_BTF` is enabled (the minimum is itself open: see "pahole minimum for P4 is
unclear" above). Already present: `bc`, `cpio`, `busybox-static`,
`libssl-dev`, `libncurses-dev`. Two options in the kernel's own hardening baseline also depend on
the compiler (`learning/kernel-04-kconfig-and-profile-configs/` lesson 03): at v7.2
`CONFIG_KSTACK_ERASE` needs GCC plugins (the `gcc-13-plugin-dev` headers, not installed; candidate
`13.3.0-6ubuntu2~24.04.1`) or Clang, and `CONFIG_CFI` needs a compiler that accepts
`-fsanitize=kcfi`, which GCC 13.3 rejects (Clang only; see the Rust-for-Linux entry below).
**Blocked by / Action:** Blocks **P4** (kernel internals). Install before the first P4 milestone
is planned — `sudo apt install flex bison libelf-dev dwarves` — record the versions in
`how-to/docs/TOOLCHAIN.md`, then close this entry. For the two compiler-dependent options, Sam
chooses at kernel-04 lesson 03: add `gcc-13-plugin-dev` to the install (restoring
`CONFIG_KSTACK_ERASE` under GCC), or keep both options excluded under GCC, as that lesson's gap
report records. `CONFIG_CFI` stays excluded until Clang is installed.

## 27/09/2026 — Rust-for-Linux needs clang/LLVM and bindgen

**Type:** Toolchain gap
**Summary:** The kernel's Rust support is built with a full LLVM toolchain (`make LLVM=1`); the
kernel documentation calls a GCC build of it "very experimental". It also needs `libclang`,
`bindgen` and the `rust-src` component, and a `rustc` the kernel accepts
(<https://docs.kernel.org/rust/quick-start.html>). clang, LLVM and bindgen are not installed;
the pinned workspace toolchain (`code/src/rust/rust-toolchain.toml`) installs rustfmt and clippy
only.
**Blocked by / Action:** Blocks the **P4 Rust-for-Linux track** only — the C module track is
unaffected. Before that milestone: install clang/LLVM and bindgen, add `rust-src` to the kernel
build's toolchain, and run `make LLVM=1 rustavailable` in the kernel tree (which reports exactly
what is missing). Record the versions in `how-to/docs/TOOLCHAIN.md`.

## 27/09/2026 — Distro build approach undecided — ✅ CLOSED 27/09/2026

**Resolution:** decided in Sam's planning conversation of 27/09/2026 and recorded as
`project-management/src/08-DECISIONS/ADR-MS001-SYNTEK-OS-INDEPENDENT-FROM-SCRATCH-27-09-2026.md`:
Syntek OS is built from scratch — Linux From Scratch, then Beyond LFS, then its own automated build
system — and derives from no other distribution.

**Type:** Open question
**Summary:** How the three distro tiers (now the Syntek OS profiles) were to be built was not yet
chosen: from scratch in the style of Linux From Scratch, with a build system such as Buildroot or
the Yocto Project, or derived from a Debian-based system.
**Blocked by / Action:** Blocked **P6** planning until an ADR recorded the decision.

## 27/09/2026 — Syntek OS profile definitions are hypotheses

**Type:** Open question
**Summary:** The seven profile specs in `project-management/src/07-OS-PROFILES/` — beginner,
intermediate and expert for desktops and laptops, and server, NAS, homelab and router — were drafted
before any kernel or OS work was done. What separates them (`PROFILE-MATRIX.md`) is a first guess,
not a finding.
**Blocked by / Action:** Revisit at the P5 exit, with the kernel fragments in hand, and again when
P6 is planned; the `SYNTEK-OS-PROFILE-DEFINITIONS.md` research note (planned) feeds the matrix.
Revise the specs through `project-management/workflows/07-os-profile-spec/`; close this entry once
the matrix has been checked against real builds.
