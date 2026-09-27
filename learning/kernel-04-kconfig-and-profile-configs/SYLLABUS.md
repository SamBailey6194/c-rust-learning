# Syllabus — kernel-04-kconfig-and-profile-configs

**Track**: kernel · **Phase**: P5 · **Path**: Core · **Detail**: full · **Prerequisites**: kernel-01-build-and-boot-in-qemu; sec-01-principles-threat-modelling-and-law; llm-06-cpu-performance-in-c lesson 01 (measuring honestly)
**Status**: Planned · **Checked**: 27/09/2026 (sources re-verified by `/teach` step 3 before each lesson)

From one generic kernel to deliberate ones: Sam learns the Kconfig language, then a repeatable **fragment method** —
a recorded base plus layered fragments, merged strictly and checked — and uses it to write the base fragment every
Syntek OS profile shares and the **server** and **homelab** fragments of the first edition. Hardening starts from the
kernel's own `hardening.config`, is measured against the KSPP recommendations, and has its cost measured too; the
kernel line each profile tracks (longterm or stable) is argued from evidence. The NAS, router and desktop fragments
are one lesson each inside os-13-nas-edition, os-14-router-edition and os-15-desktop-editions, which apply this
method. This topic opens P5 and meets the "base + first-edition fragments" part of its exit gate in
`project-management/src/01-ROADMAP/ROADMAP.md`; os-10-profiles-and-installer consumes the fragments. Fragments are
written here as exercises and move into the downstream kernel repository when kernel-05-downstream-tree creates it.

Version pins for this syllabus: docs.kernel.org pages were read on 27/09/2026 (documentation build 7.3.0-rc4);
kernel-tree files, `hardening.config` included, are cited at tag v7.2; KSPP's Recommended Settings and
kernel-hardening-checker (GPL-3.0, run as a separate tool, never vendored) were read the same day.

| # | Lesson | Size | Build | Lenses |
| --- | --- | --- | --- | --- |
| 01 | The Kconfig language | 1 sitting | no | — |
| 02 | The fragment method: merge, check, diff | 2–3 sittings | yes — strict fragment merge | — |
| 03 | A hardening baseline and the gap to KSPP | 2–3 sittings | yes — base hardening fragment | Efficiency, Security |
| 04 | Longterm or stable, per profile | 1 sitting | no | Security |
| 05 | Firmware and initramfs needs per profile | 1 sitting | no | Security |
| 06 | The base, server and homelab fragments | multi-session build | yes — first-edition fragments | Security, Safety |
| 07 | Measuring a config: size, boot time and attack surface | 2–3 sittings | yes — config metrics script | Efficiency, Security |

---

## 01 — The Kconfig language

- **Objective:** Sam can read a Kconfig entry and predict whether a symbol he asks for will survive into `.config`.
- **Builds on:** kernel-01-build-and-boot-in-qemu lesson 03 (configuration targets and `menuconfig`'s help text).
- **Key ideas:**
  - Each `config` entry has a type (`bool`, `tristate`, `string`, `int`, `hex`), an optional prompt, defaults, help
    text and dependencies.
  - `depends on` caps a symbol's value; a symbol with unmet dependencies cannot be turned on, whatever a fragment says.
  - `select` forces another symbol on without checking that symbol's own dependencies, which is why the documentation
    reserves it for invisible symbols without dependencies; `imply` is the softer form that can still be overridden.
  - A symbol without a prompt cannot be set directly; only defaults and selects change it.
  - `tristate` adds `m`, meaningful only with loadable modules.
- **Recall targets:** what `depends on`, `select` and `imply` each do to another symbol's value; why a fragment line
  can silently fail to stick; what a prompt-less symbol means for a fragment.
- **Build:** none — Sam reads two real entries in the tree (for example `LOCALVERSION` in init/Kconfig and
  `PROVE_LOCKING` in lib/Kconfig.debug) and predicts their behaviour before checking in `menuconfig`.
- **Sources:** "Kconfig Language" (<https://docs.kernel.org/kbuild/kconfig-language.html>, "Menu entries" and "Menu
  attributes"); init/Kconfig at v7.2
  (<https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/plain/init/Kconfig?h=v7.2>).
- **Done when:** Sam predicts correctly, for three symbols of his choosing, whether a one-line fragment enabling each
  would survive `olddefconfig`, and explains the one that does not.

## 02 — The fragment method: merge, check, diff

- **Objective:** Sam can build a configuration from a recorded base and ordered fragments, fail loudly when any
  requested value is lost, and show exactly what each fragment changed.
- **Builds on:** lesson 01; tooling-03-shell-scripting (exit status and `set -euo pipefail`).
- **Key ideas:**
  - The tree's scripts/kconfig/merge_config.sh layers fragments over a base in order and warns when a later fragment
    overrides an earlier value or when a requested value does not reach the final `.config`.
  - Its strict mode (`-s`) turns those warnings into a failure; `-m` only merges and skips the final make, which is
    how `make <name>.config` uses it before running `olddefconfig`.
  - `olddefconfig` fills in everything the fragments left unsaid with defaults; `savedefconfig` shows the minimal
    configuration; scripts/diffconfig shows the change between two configs, sorted and readable.
  - A method is only as good as its record: the base (a named defconfig or tinyconfig at a named tag), the fragments
    in order, and the check.
- **Recall targets:** the order of operations from base to built `.config`; what strict mode catches that a plain
  merge only warns about; how to prove a fragment changed only what it claims.
- **Build:** a script that merges a named base and an ordered list of fragments in strict mode, runs the final
  configuration step, and prints the `diffconfig` against the base, in `code/src/kernel/msNNN-fragment-method/`
  (planned — added at P4). Checked by a fragment with one deliberately unsatisfiable line, which must make the script
  exit non-zero, and by a clean fragment, which must pass.
- **Sources:** merge_config.sh at v7.2
  (<https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/plain/scripts/kconfig/merge_config.sh?h=v7.2>,
  its usage text and final check); scripts/kconfig/Makefile at v7.2
  (<https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/plain/scripts/kconfig/Makefile?h=v7.2>, the
  `%.config` rule); diffconfig at v7.2
  (<https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/plain/scripts/diffconfig?h=v7.2>); "Configuration
  targets and editors" (<https://docs.kernel.org/kbuild/kconfig.html>).
- **Done when:** the script fails on the planted bad line and passes on the clean fragment, and Sam explains every line
  of the `diffconfig` output.

## 03 — A hardening baseline and the gap to KSPP

- **Objective:** Sam can apply the kernel's own hardening fragment as a baseline, measure how far the result is from
  the KSPP recommendations, and measure what the hardening costs.
- **Builds on:** lesson 02; sec-01-principles-threat-modelling-and-law (attack surface, defence in depth);
  sec-02-memory-corruption-and-mitigations if already taken (the user-space versions of the same mitigations).
- **Key ideas:**
  - `make hardening.config` merges the in-tree fragment of "basic" hardening the kernel expects to cost little: at
    v7.2, memory permissions, kernel ASLR, stack protector, `FORTIFY_SOURCE`, hardened usercopy, zeroing on
    allocation and free, KFENCE, list hardening, seccomp, control-flow integrity and several attack-surface removals.
  - Some baseline options depend on the compiler: at v7.2 `CONFIG_CFI` needs a compiler that accepts
    `-fsanitize=kcfi` (Clang today, which is not installed; the host's GCC 13.3 rejects it), and `CONFIG_KSTACK_ERASE`
    needs GCC plugin headers or Clang; the headers (`gcc-13-plugin-dev`) are not installed, as
    `GAPS.md` → "Kernel build dependencies not installed" records. With the host's GCC neither sticks:
    `make hardening.config` drops them silently and a strict merge fails, so the base fragment takes the in-tree
    baseline minus the options the recorded compiler cannot build, and the gap report lists each one.
  - The KSPP Recommended Settings go further, across Kconfig options (with separate x86_64 and GCC-plugin lists),
    kernel command-line options and sysctls.
  - kernel-hardening-checker reads a `.config` (and optionally the command line and sysctls) and reports each
    recommendation as met or not; it is a separate GPL-3.0 Python tool, installed per user when the lesson runs.
  - The kernel's threat model leaves defaults to distributions: Syntek OS chooses its own presets per profile.
  - Every extra option has a cost in speed, memory or compatibility; the gap is closed deliberately, not wholesale.
- **Recall targets:** three options in the in-tree baseline and the attack each blunts; the difference between the
  baseline and the KSPP list; which baseline options depend on the compiler, and why a strict merge catches that
  when `make hardening.config` does not; how a hardening choice's cost is measured.
- **Build:** the base hardening fragment (the in-tree baseline minus the compiler-dependent options the recorded
  compiler cannot build, plus the KSPP items Sam decides to adopt, each with a one-line reason) and a short gap report
  that lists every excluded option, in `code/src/kernel/msNNN-profile-fragments/` (planned — added at P4). Checked by
  a strict merge on the recorded compiler, a kernel-hardening-checker run whose remaining failures are each explained,
  and a boot in QEMU through the kernel-01 harness.
- **Efficiency lens:** compare boot time and image size with and without the baseline, using the measuring method of
  llm-06-cpu-performance-in-c lesson 01 (warm-up, repeated runs, variance).
- **Security lens:** the gap report is the kernel part of each profile's threat model: what is mitigated, what is
  accepted and why.
- **Sources:** hardening.config at v7.2
  (<https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/plain/kernel/configs/hardening.config?h=v7.2>);
  KSPP "Recommended Settings" (<https://kspp.github.io/Recommended_Settings>, read 27/09/2026);
  kernel-hardening-checker (<https://github.com/a13xp0p0v/kernel-hardening-checker>, README usage, read 27/09/2026);
  "The Linux Kernel threat model" (<https://docs.kernel.org/process/threat-model.html>); `config CFI` in arch/Kconfig
  and `config KSTACK_ERASE` in security/Kconfig.hardening at v7.2
  (<https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/plain/arch/Kconfig?h=v7.2>,
  <https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/plain/security/Kconfig.hardening?h=v7.2>).
- **Done when:** the base fragment merges strictly on the recorded compiler and boots, every excluded option and every
  remaining checker failure has a written reason, and the measured cost is recorded against its budget.

## 04 — Longterm or stable, per profile

- **Objective:** Sam can argue which kernel line each Syntek OS profile should track, from end-of-life dates, update
  cadence, hardware needs and maintenance cost.
- **Builds on:** kernel-01-build-and-boot-in-qemu lesson 01 (the release lines);
  `project-management/src/08-DECISIONS/ADR-MS001-KERNEL-DOWNSTREAM-OF-UPSTREAM-27-09-2026.md` (longterm for the server
  family, stable for desktops and laptops, as decided in the planning conversation).
- **Key ideas:**
  - A longterm line receives only important fixes for years (projected end of life, extendable); a stable line moves
    to the next release within weeks and gains new hardware support sooner.
  - The kernel CVE team assigns CVEs only against supported lines, so a line past its end of life stops receiving
    both fixes and identifiers.
  - Constraints from outside the kernel can pin a line — for example a filesystem module's supported kernel range
    (os-13-nas-edition's ZFS reading).
  - Each line in use is another branch to rebase, build and boot-test in kernel-06-kernel-ci-and-security.
- **Recall targets:** the trade-off between the two kinds of line; what happens to a profile left on an end-of-life
  line; what the chosen lines cost the CI.
- **Build:** none — the lesson's argument feeds the `LTS-VS-STABLE-PER-PROFILE` research note (planned — suggested in
  `research/CONTEXT.md`, written with `/research` before the first P5 milestone).
- **Security lens:** support windows are a security property: no fixes and no CVE assignments after end of life.
- **Sources:** kernel.org releases (<https://www.kernel.org/category/releases.html>, "Longterm release kernels" and
  "Why are some longterm versions supported longer than others?"); "CVEs" (<https://docs.kernel.org/process/cve.html>,
  "Process"); <https://www.kernel.org/releases.json>.
- **Done when:** Sam states and defends a line for each of the seven profiles, and the research note records the
  argument with its sources.

## 05 — Firmware and initramfs needs per profile

- **Objective:** Sam can say, for a profile, which drivers must be built in, which can be modules, what firmware they
  load from where, and whether the profile needs an initramfs at all.
- **Builds on:** lessons 01–04; kernel-01-build-and-boot-in-qemu lesson 05 (the initramfs);
  os-02-storage-and-boot-fundamentals if taken (when a real root filesystem needs an initramfs).
- **Key ideas:**
  - The kernel looks for firmware under `/lib/firmware` (with its updates and per-release subdirectories searched
    first); a driver needed before the root filesystem is mounted needs its firmware built in or in the initramfs.
  - `CONFIG_EXTRA_FIRMWARE` builds firmware into the kernel image — faster and self-contained, but a rebuild for every
    firmware update, and not possible for firmware whose licence is incompatible with the GPL.
  - A driver built in (`y`) needs no initramfs to reach the root filesystem; a module (`m`) does if root depends on
    it.
  - Hardware for the NAS, router, homelab, server and laptop profiles is not chosen yet, so this lesson works from the
    virtual hardware QEMU presents and records what real hardware will add.
- **Recall targets:** the firmware search order; when built-in firmware is and is not allowed; when a profile can boot
  without an initramfs.
- **Build:** none — the decisions are recorded as comments in the lesson 06 fragments.
- **Security lens:** licence and provenance of firmware blobs are part of what a distributed image carries.
- **Sources:** "Firmware search paths" (<https://docs.kernel.org/driver-api/firmware/fw_search_path.html>); "Built-in
  firmware" (<https://docs.kernel.org/driver-api/firmware/built-in-fw.html>); "Ramfs, rootfs and initramfs"
  (<https://docs.kernel.org/filesystems/ramfs-rootfs-initramfs.html>).
- **Done when:** for the server profile under QEMU, Sam lists what is built in, what is a module and why, and states
  whether an initramfs is needed.

## 06 — The base, server and homelab fragments

- **Objective:** Sam can write and justify the fragments for the first Syntek OS edition — base, server and homelab —
  and show each profile's kernel booting in QEMU.
- **Builds on:** lessons 02–05; the profile specs in `project-management/src/07-OS-PROFILES/`; Sam's NixOS modules
  (one base, options layered per machine) as the mental model for base-plus-profile.
- **Key ideas:**
  - Base holds what every profile needs (the hardening baseline, the console and the virtual devices used for testing);
    a profile fragment adds or removes only what that profile's spec asks for.
  - Server is headless and minimal: every option has to be justified against its threat model.
  - Homelab adds what hosting containers and virtual machines needs, drawing on sec-04-linux-security-model's
    namespaces and cgroups; running guests inside it is os-12-homelab-edition's work.
  - Every line carries a one-line reason, and every merge is strict.
- **Recall targets:** why a given option sits in base rather than a profile; what the server fragment removes and the
  attack surface that removal closes; what homelab adds and why.
- **Build:** the base, server and homelab fragments, merged in order by the lesson 02 script, in
  `code/src/kernel/msNNN-profile-fragments/` (planned — added at P4); they move into the downstream kernel repository
  (created when kernel-05-downstream-tree starts that build). Checked by strict merges on the compiler recorded in
  lesson 03 (so the compiler-dependent exclusions hold), a build of each profile from a clean output directory, and
  each kernel booting to its init through the kernel-01 harness, with the evidence in a `KERNEL-IMPL` record per
  profile.
- **Security lens:** each profile's fragment is reviewed against the threat model in its PROFILE spec.
- **Safety:** every profile kernel boots in QEMU only; no hardware exists for these profiles yet (`GAPS.md` → "No
  hardware chosen for the Syntek OS profiles"), and real hardware is chosen by ADR when its topic opens.
- **Sources:** "Kconfig Language" (<https://docs.kernel.org/kbuild/kconfig-language.html>); merge_config.sh at v7.2
  (<https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/plain/scripts/kconfig/merge_config.sh?h=v7.2>);
  kvm_guest.config at v7.2
  (<https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/plain/kernel/configs/kvm_guest.config?h=v7.2>);
  "The Linux Kernel threat model" (<https://docs.kernel.org/process/threat-model.html>).
- **Done when:** the base kernel and both first-edition profile kernels (server and homelab) build and boot in QEMU
  from the committed fragments on a recorded tag — the P5 exit gate's configuration half — and Sam defends any line
  he is asked about.

## 07 — Measuring a config: size, boot time and attack surface

- **Objective:** Sam can measure a configuration's image size, boot time and module count honestly, and read the
  module count as a rough measure of attack surface.
- **Builds on:** lessons 03 and 06; llm-06-cpu-performance-in-c lesson 01 (measuring honestly: warm-up, repeated runs,
  variance, budget against measured).
- **Key ideas:**
  - Size: `ls -l` of `bzImage` for what is loaded, `size` of `vmlinux` for its sections, and the tree's
    scripts/bloat-o-meter to compare two builds symbol by symbol.
  - Boot time: `printk.time=1` timestamps and `initcall_debug` show where time goes; one boot is an anecdote, so boot
    several times and report the spread.
  - Modules: `make modules_install` with `INSTALL_MOD_PATH` pointing at a scratch directory outside the repository
    counts what a profile would ship, without touching the host.
  - Every kernel-config milestone states a budget for these numbers and records budget against measured
    (`project-management/src/01-ROADMAP/ROADMAP.md` → the Efficiency and Security lenses).
- **Recall targets:** which tool measures which quantity; why one boot is not a measurement; why more modules means
  more attack surface even when they are not loaded.
- **Build:** a script that reports image size, section sizes, module count and median boot time over several QEMU
  boots for a given configuration, in `code/src/kernel/msNNN-config-metrics/` (planned — added at P4). Checked by
  running it on base and server and explaining the difference.
- **Efficiency lens:** the budget and the measurements go into the milestone's resource-measurements section.
- **Security lens:** module count and enabled subsystems as attack surface, compared across profiles.
- **Sources:** kernel parameters (<https://docs.kernel.org/admin-guide/kernel-parameters.html>, `printk.time=` and
  `initcall_debug`); "Kbuild" (<https://docs.kernel.org/kbuild/kbuild.html>, INSTALL_MOD_PATH); bloat-o-meter at
  v7.2 (<https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/plain/scripts/bloat-o-meter?h=v7.2>);
  `man 1 size`.
- **Done when:** the script's numbers for base and server are recorded against their budgets, and Sam explains where
  the difference comes from.
