# References — how-to layer

**Last Updated**: 27/09/2026 | **Version**: 0.1.0 | **Maintained By**: Sam Bailey
**Language**: British English (en_GB) | **Timezone**: Europe/London

Internal and external references for setup, study sessions, quality gates, toolchain updates and
environment debugging. `STEPS.md` files point into these tables by section name.

---

## Internal

### Context files

| File | Purpose |
| --- | --- |
| `how-to/CONTEXT.md` | Layer entry point: what lives here, when to read it, where else to go |
| `how-to/docs/CONTEXT.md` | Reference-guide index |
| `how-to/src/CONTEXT.md` | Runbook index |
| `how-to/workflows/CONTEXT.md` | Workflow catalogue: six workflows in five families, six more planned (P4, P6, L1–L2, L5) |
| `how-to/workflows/01-toolchain-setup/CONTEXT.md` | When to set up a machine, and the two-toolchain model |
| `how-to/workflows/02-daily-study-session/CONTEXT.md` | The session routine and why it starts with the handoff |
| `how-to/workflows/03-quality-gates/CONTEXT.md` | The gate list (owner) and the exit-code contract |
| `how-to/workflows/04-toolchain-updates/CONTEXT.md` | Moving the Rust pin by ADR; recording host upgrades |
| `how-to/workflows/05-debugging-environment/CONTEXT.md` | Environment-first diagnosis and where logic bugs go |
| `how-to/workflows/06-write-a-guide/CONTEXT.md` | Which documentation belongs where, and the two homes |

### Steps & checklists

| File | Purpose |
| --- | --- |
| `how-to/workflows/01-toolchain-setup/STEPS.md` | apt → clone → rustup → `toolchain/check.sh` → ms001 in C and Rust → compare versions |
| `how-to/workflows/02-daily-study-session/STEPS.md` | Pull → handoff → unit → branch → check → study → gates → PROGRESS → commit → handoff |
| `how-to/workflows/03-quality-gates/STEPS.md` | C, Rust and docs gates, raw then scripted; CI-only lints; `gates/all.sh` |
| `how-to/workflows/04-toolchain-updates/STEPS.md` | What would change → ADR → matched-set pin → host upgrade → gates → re-record |
| `how-to/workflows/05-debugging-environment/STEPS.md` | Capture the error → check → versions → match the symptom → fix → route |
| `how-to/workflows/06-write-a-guide/STEPS.md` | Place → draft → verify → execute → length and lint → index → commit |
| `how-to/workflows/*/CHECKLIST.md` | Beside each `STEPS.md`: one box per step outcome, then Context and Definition of Done |

### Reference guides

| File | Purpose |
| --- | --- |
| `how-to/docs/TOOLCHAIN.md` | Owner of the recorded versions; prerequisites; P4, P6, L1–L2 and security-track packages; toolchain troubleshooting |
| `how-to/docs/CLI-TOOLING.md` | Commands by intent (C build, memory, debugging, Rust, docs, P4 preview), raw then scripted |
| `how-to/docs/GUIDE-CRAFT.md` | The reader, two homes, the six-part spine, command discipline, execute-to-verify |

### Operator guides

| File | Purpose |
| --- | --- |
| `how-to/src/MACHINE-SETUP.md` | Full Ubuntu 24.04 host setup runbook; Part B lists the P4 additions |
| `how-to/src/HOST-MAINTENANCE.md` | Pointer stub: host maintenance lives in the reboot-purge repository |

### Cross-layer

| File | Purpose |
| --- | --- |
| `REFERENCES.md` | Root index of every layer, guide and workflow |
| `.claude/CLAUDE.md` | The non-negotiables, including the kernel safety rule |
| `GAPS.md` | Active gaps and blockers, including toolchain gaps |
| `code/docs/BUILD.md` | Compiler flags and make targets behind the C gates |
| `code/docs/MEMORY-SAFETY.md` | Reading ASan, UBSan and valgrind reports |
| `code/docs/DEBUGGING.md` | Debugging technique with gdb, rust-gdb and backtraces |
| `code/docs/RUST-CODING-PRINCIPLES.md` | Rust lint policy and idioms |
| `code/docs/DOCUMENTATION-LENGTH.md` | The 300-line rule and the thin-index split |
| `code/docs/DOCUMENTATION-PAIRING.md` | The `CONTEXT.md` + `CLAUDE.md` pairing rule and its exemptions |
| `code/src/scripts/CONTEXT.md` | Every script, its flags and the 0/1/2 exit-code contract |
| `code/workflows/CONTEXT.md` | Code workflows: exercises, TDD, FFI, review, memory check, debug, refactor |
| `project-management/docs/git/BRANCHES.md` | Branch names, settled before the first commit |
| `project-management/docs/git/COMMITS.md` | Conventional Commits, scopes, staging by explicit path |
| `project-management/docs/git/PR-AND-CHECKS.md` | Pull requests and the CI checks they wait for |
| `project-management/src/01-ROADMAP/ROADMAP.md` | The phases of every track, and when each track's material arrives |
| `project-management/src/02-MILESTONES/MS001-TOOLCHAIN-READY.md` | The current milestone, evidenced by workflow 01 |
| `project-management/src/03-STUDY-SPRINTS/` | Current study sprint: where today's unit comes from |
| `project-management/src/09-MILESTONE-PLANS/` | Milestone plans, when no sprint is open |
| `project-management/src/10-PROGRESS/` | Milestone verification records that quote the gate summary |
| `project-management/workflows/08-decisions/` | Writing the ADR that moves the Rust pin |
| `project-management/workflows/10-study-and-build/` | The study procedure a session wraps |
| `project-management/workflows/11-verification/` | Milestone verification, paired with the quality gates |
| `project-management/workflows/13-pr-and-merge/` | Raising and merging the pull request |
| `learning/CONTEXT.md` | Topic folders and their `PROGRESS.md` log |
| `handoffs/CONTEXT.md` | Handoff notes for sessions that end mid-work |
| `research/CONTEXT.md` | Primary-source notes that ground a guide's claims |
| `.claude/skills/teach/SKILL.md` | `/teach`: guided study in `learning/` |
| `.claude/skills/handoff/SKILL.md` | `/handoff`: writes the handoff note |
| `.claude/skills/research/SKILL.md` | `/research`: writes a cited research note |

---

## External — Toolchain and build

| Reference | Description |
| --- | --- |
| [GCC: Options to request or suppress warnings](https://gcc.gnu.org/onlinedocs/gcc/Warning-Options.html) | Every `-W` flag in `code/src/c/mk/flags.mk` |
| [GCC: Options controlling C dialect](https://gcc.gnu.org/onlinedocs/gcc/C-Dialect-Options.html) | `-std=c17` and the GNU dialects it excludes |
| [GCC: Options that control static analysis](https://gcc.gnu.org/onlinedocs/gcc/Static-Analyzer-Options.html) | `-fanalyzer` and its `-Wanalyzer-*` warnings |
| [GNU make manual](https://www.gnu.org/software/make/manual/make.html) | Targets, pattern rules, `-C`, `-n`, `-B` |
| [The rustup book](https://rust-lang.github.io/rustup/) | Installing rustup, toolchains, components, profiles |
| [rustup: overrides and the toolchain file](https://rust-lang.github.io/rustup/overrides.html) | How `rust-toolchain.toml` pins a directory |
| [rustup installer](https://rustup.rs/) | The official install command |
| [The Cargo book](https://doc.rust-lang.org/cargo/) | Workspaces, `cargo build`/`test`/`run`, `--manifest-path` |
| [Clippy documentation](https://doc.rust-lang.org/clippy/) | Lint groups (`all`, `pedantic`) and configuration |
| [rustfmt](https://rust-lang.github.io/rustfmt/) | Formatting options behind `cargo fmt` |
| [rustc lints](https://doc.rust-lang.org/rustc/lints/index.html) | Compiler lints such as `unsafe_code` |
| [cargo-deny book](https://embarkstudios.github.io/cargo-deny/) | `cargo deny check`: advisories, bans, licences, sources |
| [cloc](https://github.com/AlDanial/cloc) | The line counter behind the docs-length audit |
| [markdownlint-cli2](https://github.com/DavidAnson/markdownlint-cli2) | The Markdown lint CI runs, and `npx` runs locally |
| [ShellCheck](https://www.shellcheck.net/) | The shell linter behind `Syntax — Shell` |
| [Ubuntu 24.04 (noble) packages](https://packages.ubuntu.com/noble/) | Package names and versions for `apt install` |
| [git pull](https://git-scm.com/docs/git-pull) | `--ff-only` and what a diverged history means |

---

## External — Debugging and memory

| Reference | Description |
| --- | --- |
| [Debugging with GDB](https://sourceware.org/gdb/current/onlinedocs/gdb.html/) | The GDB manual: breakpoints, watchpoints, core files, `--args` |
| [Valgrind Memcheck manual](https://valgrind.org/docs/manual/mc-manual.html) | Leak kinds, `--leak-check`, `--track-origins`, error messages |
| [Valgrind quick start](https://valgrind.org/docs/manual/quick-start.html) | Reading a first Memcheck report |
| [GCC: program instrumentation options](https://gcc.gnu.org/onlinedocs/gcc/Instrumentation-Options.html) | `-fsanitize=address,undefined` and `-fno-sanitize-recover` |
| [AddressSanitizer](https://github.com/google/sanitizers/wiki/AddressSanitizer) | What ASan detects, `ASAN_OPTIONS`, LeakSanitizer |
| [Yama LSM](https://docs.kernel.org/admin-guide/LSM/Yama.html) | `kernel.yama.ptrace_scope` values and why gdb cannot attach |
| [core(5)](https://man7.org/linux/man-pages/man5/core.5.html) | Core dump limits and `core_pattern` |
| [std::backtrace](https://doc.rust-lang.org/std/backtrace/index.html) | `RUST_BACKTRACE` and captured backtraces |

---

## External — Kernel and QEMU (P4)

| Reference | Description |
| --- | --- |
| [Linux kernel README](https://docs.kernel.org/admin-guide/README.html) | Configuring and building, including `make O=` out-of-tree builds |
| [Minimal requirements to compile the kernel](https://docs.kernel.org/process/changes.html) | Tool minimums: flex, bison, pahole, Rust, bindgen |
| [Building external modules](https://docs.kernel.org/kbuild/modules.html) | `make -C <kernel build dir> M=$PWD` |
| [Rust quick start (kernel)](https://docs.kernel.org/rust/quick-start.html) | Rust-for-Linux requirements, `make LLVM=1 rustavailable` |
| [Debugging kernel and modules via gdb](https://docs.kernel.org/process/debugging/gdb-kernel-debugging.html) | QEMU `-s`, `target remote :1234`, `nokaslr`, `lx-symbols` |
| [Ramfs, rootfs and initramfs](https://docs.kernel.org/filesystems/ramfs-rootfs-initramfs.html) | The `newc` cpio format and how the kernel runs `/init` |
| [QEMU invocation](https://www.qemu.org/docs/master/system/invocation.html) | `-kernel`, `-initrd`, `-append`, `-nographic` |
| [QEMU GDB usage](https://www.qemu.org/docs/master/system/gdb.html) | The gdb stub: `-s` and `-S` |
| [BusyBox](https://busybox.net/) | The single-binary userland for the initramfs |

---

## External — Later tracks (P6, L1–L2, security)

| Reference | Description |
| --- | --- |
| [LFS 13.1-systemd — host system requirements](https://www.linuxfromscratch.org/lfs/view/stable-systemd/chapter02/hostreqs.html) | What the LFS build VM's own system needs (Section 2.2) |
| [LFS 13.1-systemd — creating a new partition](https://www.linuxfromscratch.org/lfs/view/stable-systemd/chapter02/creatingpartition.html) | How much disk the build VM needs (Section 2.4) |
| [QEMU disk images](https://www.qemu.org/docs/master/system/images.html) | qcow2 images, backing files and snapshots for the VMs |
| [libvirt documentation](https://libvirt.org/docs.html) | Virtual networks and VMs for the isolated labs |
| [uv](https://docs.astral.sh/uv/) | Per-project Python environments and interpreter pins |
| [PyTorch — get started locally](https://pytorch.org/get-started/locally/) | Choosing and installing a PyTorch build |
| [NVIDIA CUDA installation guide for Linux](https://docs.nvidia.com/cuda/cuda-installation-guide-linux/) | Installing a CUDA toolkit beside the driver |
| [NVIDIA — GPU performance counter permissions](https://developer.nvidia.com/nvidia-development-tools-solutions-err_nvgpuctrperm-permission-issue-performance-counters) | `NVreg_RestrictProfilingToAdminUsers` and how counter access is granted |
| [Perf events and tool security](https://docs.kernel.org/admin-guide/perf-security.html) | Who may use `perf`, and `CAP_PERFMON` |
| [Kernel sysctl — perf_event_paranoid](https://docs.kernel.org/admin-guide/sysctl/kernel.html) | The levels `kernel.perf_event_paranoid` takes |

---

## External — Host and writing

| Reference | Description |
| --- | --- |
| [reboot-purge](https://github.com/SamBailey6194/reboot-purge) | Sibling repository for post-boot host maintenance |
| [Diataxis](https://diataxis.fr/) | Why a reference and a how-to guide are written differently |
