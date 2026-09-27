# Syllabus — os-12-homelab-edition

**Track**: os · **Phase**: P6 · **Path**: Core · **Detail**: full · **Prerequisites**: `os-11-server-edition`; `sec-04-linux-security-model` lessons 02–05 and 07 (capabilities, namespaces, cgroups v2, seccomp, the sandbox launcher); `os-02-storage-and-boot-fundamentals` lesson 02 (disk images, for lesson 03); `llm-06-cpu-performance-in-c` lesson 01 (measuring honestly)
**Status**: Planned · **Checked**: 27/09/2026 (sources re-verified by `/teach` step 3 before each lesson)

The homelab profile completes Syntek OS's first edition with the server: the same hardened base,
plus the three jobs a homelab host exists for — running containers, running virtual machines, and
watching its own resources. Containers are built on the primitives `sec-04` already taught by hand,
so nothing here is magic; VMs use KVM, tested inside the QEMU guest through nested virtualisation;
monitoring starts with what the kernel already reports before any collector is added. Every service
gets a resource budget, and every image or registry is treated as untrusted input. No homelab
hardware has been chosen: every lesson runs in QEMU, and hardware is chosen by ADR when due
(`GAPS.md`). Small exercises land under `code/src/` (`msNNN` paths and `code/src/os/` are planned);
the profile's recipes land in the Syntek OS build-system repository, created when that build starts.

| # | Lesson | Size | Build | Lenses |
| --- | --- | --- | --- | --- |
| 01 | Containers on the kernel's primitives | 2–3 sittings | yes — rootless OCI bundle | Efficiency, Security |
| 02 | Container images, registries and digests | 1 sitting | yes — digest verifier | Security |
| 03 | Virtual machines with KVM | 2–3 sittings | yes — nested VM, KVM versus TCG | Efficiency, Safety |
| 04 | Monitoring: what the kernel already reports | 1 sitting | yes — pressure status tool | Efficiency |
| 05 | Monitoring: collecting and alerting | 2–3 sittings | yes — metrics endpoint and alert | Efficiency, Security |

---

## 01 — Containers on the kernel's primitives

- **Objective:** Sam can run an OCI bundle rootless with a low-level runtime in the homelab guest
  and show which namespaces, cgroup limits, capabilities and seccomp filter apply to it.
- **Builds on:** `sec-04-linux-security-model` lessons 02–05 and 07 (capabilities, namespaces,
  cgroups v2, seccomp, the sandbox launcher); `os-11-server-edition`.
- **Key ideas:**
  - A container is an ordinary process with namespaces, a cgroup, a reduced capability set and a
    seccomp filter — the pieces `sec-04` assembled by hand.
  - The OCI runtime specification: a bundle is `config.json` plus a root filesystem; a runtime such
    as crun (written in C) or runc turns the bundle into that process.
  - Rootless containers map the container's root to an unprivileged user through a user namespace.
  - Per-service limits in cgroup v2 (`memory.max`, `cpu.max`, `pids.max`) are the homelab's resource
    budget, service by service.
  - The kernel is shared: a kernel bug is a container escape, which is why the limits and filters
    matter.
- **Recall targets:** the two parts of a bundle; which kernel feature isolates which resource; what
  a rootless container's root really is on the host.
- **Build:** a bundle whose root filesystem is a small Syntek OS package set, run rootless by a
  runtime packaged for the homelab image with a memory limit, plus a check script in `code/src/os/`
  (planned — added at P6) that compares `/proc/self/ns` and the cgroup files inside and outside the
  container and then drives the process past its memory limit. The runtime's recipe lands in the
  Syntek OS build-system repository (created when this build starts).
- **Efficiency lens:** the container's `memory.peak` and start-up time.
- **Security lens:** shared-kernel escape surface; rootless by default; drop capabilities the
  service does not need.
- **Sources:** OCI Runtime Specification v1.3.0, "Filesystem Bundle" and "Configuration",
  <https://github.com/opencontainers/runtime-spec/blob/v1.3.0/bundle.md> and
  <https://github.com/opencontainers/runtime-spec/blob/v1.3.0/config.md>; crun 1.30.1,
  <https://github.com/containers/crun/tree/1.30.1>; runc v1.5.2,
  <https://github.com/opencontainers/runc/tree/v1.5.2>; docs.kernel.org, "Control Group v2",
  <https://docs.kernel.org/admin-guide/cgroup-v2.html>; `man 7 namespaces`, `man 7 user_namespaces`,
  `man 7 cgroups`, `man 2 seccomp`.
- **Done when:** the check script shows the isolation and the memory limit being enforced, and Sam
  explains each difference between inside and outside.

## 02 — Container images, registries and digests

- **Objective:** Sam can explain an OCI image (index, manifest, configuration, layers), pin an image
  by digest, and verify fetched content against its descriptor.
- **Builds on:** lesson 01; `os-07-package-manager` lesson 04 (safe archive extraction);
  `sec-05-applied-cryptography` lesson 01 (hashes).
- **Key ideas:**
  - Everything in an OCI image is addressed by a descriptor: media type, digest and size.
  - A tag can move; a digest cannot — pin by digest, exactly as `llm-01` pins a model.
  - Content fetched from an untrusted source is verified against its digest and size before use.
  - Unpacking a layer is archive extraction: `os-07`'s rules on paths, symlinks and ownership apply.
  - A registry is an untrusted input, however well known.
- **Recall targets:** the three fields of a descriptor; why a digest pins and a tag does not; what an
  unpacker must refuse.
- **Build:** a small Rust library with tests that checks a blob against a descriptor's digest and
  size and rejects mismatches — `code/src/rust/crates/msNNN_oci_digest/` (planned); checked by
  `cargo test` with a good blob, a tampered blob and a wrong size. Any hashing crate passes
  `code/src/scripts/rust/audit.sh` or carries a documented exception under
  `project-management/src/08-DECISIONS/ADR-MS001-LLM-RUST-CRATE-LICENCES-27-09-2026.md`.
- **Security lens:** supply chain — tampered layers, moved tags, hostile archives.
- **Sources:** OCI Image Format Specification v1.1.1, overview and "Descriptors",
  <https://github.com/opencontainers/image-spec/blob/v1.1.1/spec.md> and
  <https://github.com/opencontainers/image-spec/blob/v1.1.1/descriptor.md>.
- **Done when:** the three test cases pass and Sam explains why the size check is there as well as
  the digest.

## 03 — Virtual machines with KVM

- **Objective:** Sam can run VMs on the homelab edition with KVM — inside the QEMU test guest
  through nested virtualisation — using virtio devices and qcow2 overlays, and compare KVM with TCG.
- **Builds on:** `os-02-storage-and-boot-fundamentals` lesson 02 (disk images, qcow2 backing files);
  `kernel-01-build-and-boot-in-qemu` lesson 06 (booting in QEMU); lesson 01.
- **Key ideas:**
  - KVM is a kernel module exposing `/dev/kvm`; QEMU uses it with `-accel kvm` and otherwise
    emulates with TCG, its default.
  - Nested virtualisation runs KVM inside a KVM guest: from Linux 4.20 the `nested` parameter is on
    by default for Intel and AMD, though distributions may override it — the host's
    `/sys/module/kvm_intel/parameters/nested` read Y on 27/09/2026 — and the first-level guest needs
    a CPU model exposing virtualisation, such as `-cpu host`.
  - Packaging: BLFS 13.1 builds QEMU 11.1.1 and lists its KVM kernel options and the `kvm` group for
    device access; libvirt is not in BLFS 13.1, so it would be a recipe Syntek OS writes itself —
    whether it ships is a decision, not a default.
  - Each VM runs from a qcow2 overlay on a read-only base image, as the test harness does.
- **Recall targets:** what `/dev/kvm` gives QEMU; what must be true on the host and in the
  first-level guest for nesting; why a number measured under TCG says little about KVM.
- **Build:** in the homelab test guest, start a second-level VM from a qcow2 overlay with KVM and
  then with TCG, and record both boot times — a script in `code/src/os/` (planned — added at P6).
- **Efficiency lens:** KVM against TCG boot time and CPU time; memory overhead per VM.
- **Safety:** VMs run only from image files; guest networking is `-nic none`, QEMU user mode with
  `restrict=on` (plain user mode routes the guest out through the host), or `os-09`'s isolated lab.
- **Sources:** docs.kernel.org, "Running nested guests with KVM",
  <https://docs.kernel.org/virt/kvm/x86/running-nested-guests.html>; docs.kernel.org, KVM,
  <https://docs.kernel.org/virt/kvm/index.html>; BLFS 13.1 qemu-11.1.1 (KVM prerequisites),
  <https://www.linuxfromscratch.org/blfs/view/13.1-systemd/postlfs/qemu.html>; `man 1 qemu-system`
  (QEMU 8.2.2 on the host: `-accel`, `-cpu`).
- **Done when:** the second-level VM boots under KVM and under TCG, and both times are recorded.

## 04 — Monitoring: what the kernel already reports

- **Objective:** Sam can read CPU, memory and I/O pressure and per-service cgroup statistics, and
  say what each signal means for a homelab host.
- **Builds on:** lesson 01 (cgroups per service); `sec-04-linux-security-model` lesson 04 (cgroups
  v2); `llm-06-cpu-performance-in-c` lesson 01 (measuring honestly).
- **Key ideas:**
  - Pressure Stall Information: `/proc/pressure/cpu`, `memory` and `io` report the share of time
    some or all tasks were stalled, as 10, 60 and 300 second averages and a running total.
  - Each cgroup has its own pressure files, so pressure can be read per service.
  - `memory.current`, `memory.peak` and `memory.events` (its `high`, `max`, `oom` and `oom_kill`
    counts) are a service's memory record — `oom_kill` is the one that says the service was killed
    for memory; `oom` counts allocations about to fail and `high` counts throttling.
  - Pressure is a better "is this host struggling?" signal than load average alone.
- **Recall targets:** "some" versus "full"; which file answers "was this service killed for memory";
  when rising pressure matters more than high usage.
- **Build:** a small Rust command-line tool that reads `/proc/pressure/*` and one cgroup's memory
  files and prints a one-line status — `code/src/rust/crates/msNNN_pressure_status/` (planned);
  checked by `cargo test` against fixture files, then run in the guest under a synthetic memory load.
- **Efficiency lens:** this lesson builds the measuring tool the homelab budget is checked with.
- **Sources:** docs.kernel.org, "PSI - Pressure Stall Information",
  <https://docs.kernel.org/accounting/psi.html>; docs.kernel.org, "Control Group v2"
  (`memory.events`, `memory.peak`, the pressure files), <https://docs.kernel.org/admin-guide/cgroup-v2.html>.
- **Done when:** the tests pass and the tool's output changes as expected under the synthetic load.

## 05 — Monitoring: collecting and alerting

- **Objective:** Sam can publish host and service metrics in the Prometheus text format, have them
  collected, and raise an alert on a threshold, without making monitoring a new attack surface.
- **Builds on:** lesson 04; `os-11-server-edition` lessons 04–06 (firewall, update and backup
  results worth alerting on).
- **Key ideas:**
  - The text exposition format is line-oriented: `# HELP` and `# TYPE` lines, then samples of a
    counter, gauge, histogram or summary, fetched over HTTP.
  - node_exporter is the reference for what a host exporter publishes — study it before inventing.
  - Alert on symptoms that need a human: sustained pressure, a disk filling, a failed backup, a
    refused update.
  - Metrics endpoints listen on the admin network or localhost only, never on the public side.
  - Monitoring has a budget of its own.
- **Recall targets:** counter versus gauge; what makes an alert actionable; where the endpoint may
  listen.
- **Build:** extend lesson 04's tool to serve its readings in the text exposition format on
  localhost, plus an alert check that fires on a threshold —
  `code/src/rust/crates/msNNN_pressure_status/` (planned); checked by tests on the rendered text and
  by triggering the alert in the guest.
- **Efficiency lens:** the exporter's own CPU and memory cost.
- **Security lens:** bind to localhost or the admin network; the endpoint exposes host details, so
  it is covered by the firewall of `os-11`.
- **Sources:** Prometheus, "Exposition formats",
  <https://prometheus.io/docs/instrumenting/exposition_formats/>; node_exporter v1.12.1,
  <https://github.com/prometheus/node_exporter/tree/v1.12.1>.
- **Done when:** the tests pass, a scrape of the endpoint returns valid text, and the alert fires
  under load.
