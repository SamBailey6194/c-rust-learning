# Syllabus — sec-04-linux-security-model

**Track**: sec · **Phase**: S1 · **Path**: Core · **Detail**: full · **Prerequisites**: P2 (processes, users and syscalls); sec-01
**Status**: Planned · **Checked**: 27/09/2026 (sources re-verified by `/teach` step 3 before each lesson)

This topic teaches the Linux kernel's own access-control machinery — the primitives every Syntek OS
profile, the package manager, the TUI system tools and the LLM's sandbox are built on. It is Core:
os-05, os-06, os-11, os-12, ui-07, llm-13 and llm-18 all name it, and it **owns the one sandbox
launcher** those lessons reuse to run untrusted or generated code. The lessons move from the
discretionary model (users and permissions) through capabilities, namespaces, cgroups and seccomp to
the mandatory-access-control LSMs, and end by composing them into a least-privilege sandbox. All
exercises run as Sam's own user with harmless test programs; Claude never runs `sudo`, and no live
malware is ever handled (`sec-17` framing).

| # | Lesson | Size | Build | Lenses |
| --- | --- | --- | --- | --- |
| 01 | The discretionary model: users, groups, permissions, setuid | 2–3 sittings | yes — perms-probe | Security |
| 02 | Capabilities: breaking root into pieces | 2–3 sittings | yes — caps-probe | Security |
| 03 | Namespaces: isolating a process's view | 2–3 sittings | yes — ns-demo | Security, Safety |
| 04 | cgroups v2: bounding resources | 2–3 sittings | yes — cgroup-limit | Efficiency, Security |
| 05 | seccomp: restricting the syscall surface | 2–3 sittings | yes — seccomp-filter | Security |
| 06 | Mandatory access control: AppArmor, SELinux, Landlock | 2–3 sittings | yes — landlock-guard | Security |
| 07 | Composing a least-privilege sandbox launcher | multi-session build | yes — sandbox-launcher | Efficiency, Security, Safety |

---

## 01 — The discretionary model: users, groups, permissions, setuid

- **Objective:** Sam can explain UID/GID, the permission bits, and what setuid changes about a
  process's privileges.
- **Builds on:** P2 processes and syscalls; sec-01 (least privilege).
- **Key ideas:**
  - Real, effective and saved user IDs; how `execve` of a setuid binary raises the effective UID.
  - Permission bits and the three classes; why setuid-root binaries are attack surface.
  - Discretionary means the owner decides — the default model, and its limits (leads to MAC in
    lesson 06).
- **Recall targets:** predict which UID a process runs a file operation under after a setuid `execve`;
  say why setuid-root is risk.
- **Build:** a `perms-probe` under `code/src/c/msNNN-<kebab>/` that prints its real/effective/saved
  IDs and demonstrates a permission-denied path, run only as Sam's user. Passes the gates.
- **Security lens:** the discretionary model is the baseline every later primitive tightens.
- **Sources:** `man 7 credentials`; `man 2 setuid`; `man 2 execve`.
- **Done when:** Sam explains the ID model and reads the probe's output correctly.

## 02 — Capabilities: breaking root into pieces

- **Objective:** Sam can explain how Linux capabilities split root's power and inspect a process's
  capability sets.
- **Builds on:** lesson 01.
- **Key ideas:**
  - Capabilities partition root (for example `CAP_NET_BIND_SERVICE`, `CAP_SYS_ADMIN`); a service
    keeps only what it needs.
  - The permitted, effective and inheritable sets, and ambient capabilities.
  - Dropping capabilities is least privilege applied to a daemon (feeds os-11's service hardening).
- **Recall targets:** given a task, name the single capability it needs instead of full root.
- **Build:** a `caps-probe` under `code/src/c/msNNN-<kebab>/` that reads and prints its own capability
  sets (`/proc/self/status`, `libcap` if present) as Sam's user. Passes the gates.
- **Security lens:** capabilities are how a Syntek OS service avoids running as full root.
- **Sources:** `man 7 capabilities`; capabilities online reference, <https://man7.org/linux/man-pages/man7/capabilities.7.html>.
- **Done when:** Sam names the least capability for a task and reads the probe's sets.

## 03 — Namespaces: isolating a process's view

- **Objective:** Sam can explain what each namespace isolates and how a user namespace lets an
  unprivileged process gain capabilities inside it.
- **Builds on:** lessons 01–02; P2 processes.
- **Key ideas:**
  - The namespace kinds (mount, PID, network, UTS, IPC, user, cgroup, time) and what each
    virtualises (`man 7 namespaces` lists all eight).
  - The user namespace is the one that makes unprivileged isolation possible — the basis of the
    sandbox in lesson 07.
  - Namespaces are the mechanism under containers (feeds os-12's containers lesson).
- **Recall targets:** for a given isolation goal, name the namespace that provides it.
- **Build:** an `ns-demo` under `code/src/c/msNNN-<kebab>/` (or a small Rust program) that enters a
  new user + mount namespace with `unshare`/`clone` as Sam's user and shows the changed view; run
  locally. Passes the gates.
- **Security lens:** namespaces are the isolation half of the sandbox.
- **Safety:** runs as Sam's user in a user namespace; no privileged operation, nothing installed.
- **Sources:** `man 7 namespaces`; `man 2 unshare`; `man 7 user_namespaces`.
- **Done when:** Sam explains each namespace and the demo shows an isolated view.

## 04 — cgroups v2: bounding resources

- **Objective:** Sam can explain the cgroup v2 hierarchy and set a memory or CPU limit on a process.
- **Builds on:** lesson 03; P2 processes.
- **Key ideas:**
  - The unified v2 hierarchy, controllers, and the `memory.max` / `cpu.max` interface files.
  - Bounding resources is availability protection (sec-01 CIA) and the mechanism behind the LLM's
    memory-limited service (os-17) and cgroup-limited sandbox.
  - Reading and writing the interface files under `/sys/fs/cgroup`.
- **Recall targets:** name the interface file that caps memory and what happens when the cap is hit.
- **Build:** a `cgroup-limit` note plus a small program under `code/src/c/msNNN-<kebab>/` run inside a
  delegated cgroup with a memory cap, observing the limit; local only. Passes the gates.
- **Efficiency lens:** the memory cap is measured against the process's peak — the budget-vs-measured
  method of llm-06 lesson 01; feeds the LLM's VRAM/RAM budgets.
- **Security lens:** resource limits stop a denial-of-service through exhaustion.
- **Sources:** `man 7 cgroups`; kernel cgroup v2 documentation, <https://docs.kernel.org/admin-guide/cgroup-v2.html>.
- **Done when:** Sam sets a memory cap and explains the enforcement.

## 05 — seccomp: restricting the syscall surface

- **Objective:** Sam can explain seccomp filtering and write a filter that restricts a process to an
  allowed set of syscalls.
- **Builds on:** lessons 01–04; P2 syscalls.
- **Key ideas:**
  - `seccomp` mode 2 (BPF filter): allow, deny or kill on syscall number and argument.
  - The syscall surface is attack surface (sec-01 lesson 02); a tight filter shrinks it.
  - An allow-list beats a deny-list; how a filter interacts with the C library's syscalls.
- **Recall targets:** describe how a seccomp filter decides a syscall's fate and why allow-listing is
  safer.
- **Build:** a `seccomp-filter` under `code/src/c/msNNN-<kebab>/` (using `libseccomp` if present, or a
  raw BPF program) that confines a child to an allow-list and shows a denied syscall being blocked;
  local only. Passes the gates.
- **Security lens:** the syscall filter is the sandbox's second wall (with namespaces and Landlock).
- **Sources:** `man 2 seccomp`; kernel seccomp filter documentation, <https://docs.kernel.org/userspace-api/seccomp_filter.html>.
- **Done when:** Sam's filter blocks a syscall outside its allow-list and permits the rest.

## 06 — Mandatory access control: AppArmor, SELinux, Landlock

- **Objective:** Sam can contrast discretionary and mandatory access control and write a Landlock
  ruleset restricting a process's filesystem access.
- **Builds on:** lessons 01–05.
- **Key ideas:**
  - Mandatory access control: a system-wide policy the owner cannot override — AppArmor (path-based)
    and SELinux (label-based) surveyed at the concept level.
  - Landlock is the unprivileged LSM: a process sandboxes *itself* over filesystem (and, on newer
    kernels, network) access — the one that fits a launcher run as Sam's user.
  - Which profile uses which (feeds the Syntek OS hardening choices).
- **Recall targets:** contrast DAC and MAC; say why Landlock suits an unprivileged sandbox.
- **Build:** a `landlock-guard` under `code/src/rust/crates/msNNN_<snake>/` (or C) that applies a
  Landlock ruleset limiting a program to one directory and shows an out-of-scope open being denied;
  local only. Passes the gates.
- **Security lens:** MAC is defence in depth beyond the discretionary bits.
- **Sources:** kernel LSM index, <https://docs.kernel.org/admin-guide/LSM/index.html>; kernel Landlock documentation, <https://docs.kernel.org/userspace-api/landlock.html>.
- **Done when:** Sam's Landlock ruleset denies an out-of-scope file access and permits the allowed
  path.

## 07 — Composing a least-privilege sandbox launcher

- **Objective:** Sam can build a sandbox launcher that composes a user namespace, a seccomp filter, a
  Landlock ruleset, resource limits and no-network to run an untrusted program.
- **Builds on:** lessons 03, 05, 06; sec-01 (least privilege).
- **Key ideas:**
  - Layering the primitives: namespace for isolation, seccomp for the syscall surface, Landlock for
    the filesystem, cgroups/rlimits for resources, an empty network namespace for no egress.
  - This is the **one sandbox launcher** llm-13 (running generated code), llm-18 (skill scripts),
    os-05 (build isolation) and ui-07 (privileged-helper separation) reuse — one owner, cited by all.
  - Auditing what the sandbox denied (auditd / logging) so a blocked action is visible.
- **Recall targets:** list the layers of the sandbox and what each one stops.
- **Build:** a `sandbox-launcher` prototype under `code/src/rust/crates/msNNN_<snake>/` that runs a
  harmless test program under all the layers, with a test proving a network connection and an
  out-of-scope file open are both denied. The production sandbox moves to the sandbox-launcher
  repository (created at the first lesson that runs it from a product repository, `os-05` lesson 03
  or `llm-13` lesson 03), which the model-training and inference repositories and the Syntek OS
  build-system and system-tools repositories then depend on. Passes `cargo test` and `cargo clippy`.
- **Efficiency lens:** measure the launcher's start-up cost and the sandboxed program's resource
  ceiling (llm-06 lesson 01 method).
- **Security lens:** this launcher is the reusable safety boundary for every "runs generated or
  untrusted code" lesson.
- **Safety:** only harmless, synthetic test programs run inside; no live malware, ever
  (`sec-17` framing); no network egress from the sandbox.
- **Sources:** `man 7 namespaces`; `man 2 seccomp`; kernel Landlock documentation, <https://docs.kernel.org/userspace-api/landlock.html>; auditd reference, <https://www.man7.org/linux/man-pages/man8/auditd.8.html>.
- **Done when:** the launcher runs a test program with network and out-of-scope file access both
  provably denied, and a test asserts it.
