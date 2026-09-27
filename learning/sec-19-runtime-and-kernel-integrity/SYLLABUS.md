# Syllabus — sec-19-runtime-and-kernel-integrity

**Track**: sec · **Phase**: S3 · **Path**: Later · **Detail**: outline · **Prerequisites**: sec-18 (antivirus and detection), sec-04 (LSMs, seccomp), sec-16 (auditd), kernel-03 (kernel internals), os-06 (init and services)
**Status**: Planned · **Checked**: 27/09/2026 (sources re-verified by `/teach` step 3 before each lesson)

The deepest detection layer lives in the kernel and the filesystem. This topic teaches filesystem integrity with IMA/EVM, immutable roots with dm-verity, runtime monitoring with auditd and eBPF, and alerting and response hooks for Syntek OS — then ties the whole security track together into a defence-in-depth profile with its overhead measured. It is where "secure by design" reaches below userland. Every build runs in a QEMU VM; no host kernel configuration, filesystem or boot state is changed, and eBPF probes run only in the lab. It is an **outline** topic because S3 is a far phase: its builds are sketched and its sources, checked on 27/09/2026, are re-verified when the topic opens.

| # | Lesson | Size | Build | Lenses |
| --- | --- | --- | --- | --- |
| 01 | Filesystem integrity with IMA/EVM | multi-session build | yes — ima-policy | Safety |
| 02 | Immutable roots with dm-verity | 2–3 sittings | yes — verity-image | Safety |
| 03 | Runtime monitoring with auditd and eBPF | multi-session build | yes — ebpf-monitor | Efficiency, Safety |
| 04 | Alerting and response hooks for Syntek OS | 2–3 sittings | yes — response-hook | Safety |
| 05 | Putting it together: a defence-in-depth profile | 2–3 sittings | no | Efficiency, Safety |

---

## 01 — Filesystem integrity with IMA/EVM

- **Objective:** Sam can enable an IMA measurement policy in a VM and read the measurement log.
- **Builds on:** sec-18's file-integrity concept; kernel-03's kernel internals; sec-13's signing keys.
- **Key ideas:**
  - IMA measures (and can appraise) files against a policy; EVM protects a file's security metadata.
  - The measurement log records the hash of each measured file, extendable into a TPM PCR (sec-13's measured boot).
  - Appraisal enforces (blocks unsigned/altered files); measurement only records — a policy decision.
  - Keys tie appraisal to signatures Sam controls.
- **Recall targets:** the difference between measuring and appraising; what EVM protects that IMA does not.
- **Build:** enable an IMA measurement policy in a QEMU guest and read the measurement log; observe a new file being measured. Planned: a VM harness and note; the shipped policy lands in the Syntek OS build-system repository (created when that build starts).
- **Safety:** VM only; no host IMA policy is changed.
- **Sources:** (checked 27/09/2026; re-verify when S3 opens) kernel IMA templates and integrity documentation (<https://docs.kernel.org/security/IMA-templates.html>); kernel parameters, `ima_policy=` (for example `tcb`) (<https://docs.kernel.org/admin-guide/kernel-parameters.html>); the ABI `ima_policy` file (<https://docs.kernel.org/admin-guide/abi-testing-files.html>); kernel TPM docs for the PCR link (<https://docs.kernel.org/security/tpm/index.html>).
- **Done when:** Sam reads the measurement log in a VM and explains what measurement alone does and does not stop.

---

## 02 — Immutable roots with dm-verity

- **Objective:** Sam can build a dm-verity image, boot it read-only in a VM, and observe verification failing on a corrupted block.
- **Builds on:** lesson 01; os-02's disk images and loop devices; kernel device-mapper.
- **Key ideas:**
  - dm-verity provides transparent integrity checking of a read-only block device via a hash tree.
  - The target is read-only; a block that fails its hash is refused, so tampering is caught at read time.
  - It suits appliance-style images — router, NAS and server roots that should not change at run time.
  - The hash tree's root is the trust anchor; protecting it (signature, kernel command line) matters.
- **Recall targets:** why dm-verity is read-only; what a hash tree buys over a single whole-image hash.
- **Build:** build a dm-verity image, boot it read-only in a VM, then corrupt a block and observe the failure. Planned: a VM harness; the production image build lands in the Syntek OS build-system repository (created when that build starts).
- **Safety:** VM images and loop devices only; no host disk is touched (`.claude/CLAUDE.md`).
- **Sources:** (checked 27/09/2026; re-verify when S3 opens) kernel dm-verity documentation (<https://docs.kernel.org/admin-guide/device-mapper/verity.html>); device-mapper index (<https://docs.kernel.org/admin-guide/device-mapper/index.html>); `veritysetup` (<https://man.archlinux.org/man/veritysetup.8>).
- **Done when:** a dm-verity image boots read-only and a corrupted block is refused at read time.

---

## 03 — Runtime monitoring with auditd and eBPF

- **Objective:** Sam can write an eBPF or bpftrace probe that flags a suspicious behaviour in a lab VM, and measure its overhead.
- **Builds on:** sec-16's auditd rules; kernel-03's kernel internals; sec-17's foothold behaviours.
- **Key ideas:**
  - auditd covers syscall and file events; eBPF programs run in the kernel to observe behaviour more flexibly.
  - bpftrace is a high-level front-end to eBPF for tracing and monitoring.
  - eBPF has overhead and safety constraints (the verifier); a probe is a cost as well as a capability.
  - Runtime monitoring detects behaviour that static and signature checks miss.
- **Recall targets:** what eBPF adds over auditd; why an eBPF probe's overhead and the verifier matter.
- **Build:** a bpftrace script that flags a suspicious behaviour (for example an unexpected exec or file access) in a lab VM. Planned: a script and note; the shipped monitor lands in the Syntek OS build-system repository (created when that build starts).
- **Efficiency lens:** measure the probe's overhead (the measurement method from llm-06 lesson 01); a monitor that slows the box too much is not shipped.
- **Safety:** lab VM only; eBPF runs in the VM, never on the host.
- **Sources:** (checked 27/09/2026; re-verify when S3 opens) kernel BPF documentation (<https://docs.kernel.org/bpf/index.html>); `man 7 bpf-helpers` (<https://man7.org/linux/man-pages/man7/bpf-helpers.7.html>); bpftrace (<https://github.com/bpftrace/bpftrace>); eBPF overview (<https://ebpf.io/what-is-ebpf/>).
- **Done when:** the probe flags the behaviour in a lab VM and Sam reports its measured overhead.

---

## 04 — Alerting and response hooks for Syntek OS

- **Objective:** Sam can wire an integrity or monitoring event to an alert and a bounded automated response.
- **Builds on:** lessons 01–03; sec-16's incident runbook; os-06's services and supervision.
- **Key ideas:**
  - An integrity violation or a monitor hit becomes an alert (notify) and, optionally, an automated response (quarantine, isolate).
  - Automated responses must be bounded so they do not become a self-inflicted denial of service.
  - The response policy decides what is automatic and what needs a human (ties to sec-16's runbook).
  - Alerts feed the same logging pipeline as the rest of the detection stack.
- **Recall targets:** why an automated response must be bounded; what belongs to automation versus a human.
- **Build:** wire an integrity-violation event (from lesson 01 or 02) to an alert in a lab VM, with a bounded response. Planned: a lab exercise and note; the shipped hooks land in the Syntek OS build-system repository (created when that build starts).
- **Safety:** lab VM only; responses are tested where a mistaken action cannot harm a real system.
- **Sources:** (checked 27/09/2026; re-verify when S3 opens) NIST SP 800-61r3 for the response framing (<https://csrc.nist.gov/pubs/sp/800/61/r3/final>); `man 8 auditd` (<https://man7.org/linux/man-pages/man8/auditd.8.html>); os-06 (repo topic).
- **Done when:** an integrity event raises an alert and its bounded response runs in a lab VM without cascading.

---

## 05 — Putting it together: a defence-in-depth profile

- **Objective:** Sam can specify a defence-in-depth security profile for a Syntek OS server or NAS and state its total overhead.
- **Builds on:** the whole security track — Secure Boot (sec-13), FIM (sec-18 lesson 04), IMA (lesson 01), dm-verity (lesson 02), auditd and eBPF (lesson 03), ClamAV and YARA (sec-18), IDS (sec-16 lesson 02).
- **Key ideas:**
  - Defence in depth layers prevention, integrity, detection and response so no single failure is fatal.
  - Each layer has a cost; the profile states the total overhead, not just the protections.
  - The profile is per edition — a router's layers differ from a NAS's.
  - This is the security track's capstone: the whole picture, measured.
- **Recall targets:** how the layers compose into defence in depth; why the total overhead must be stated.
- **Build:** none (an integration note specifying the layered profile for one edition, with a measured-overhead table).
- **Efficiency lens:** total detection and integrity overhead against a budget (CPU, RAM, I/O, boot time) — the measurement method from llm-06 lesson 01.
- **Safety:** VM only; the profile is proven in QEMU before any hardware is considered (no hardware is chosen yet — `GAPS.md`).
- **Sources:** (checked 27/09/2026; re-verify when S3 opens) the security-track topics it composes (repo topics); measurement method from llm-06 lesson 01 (repo topic).
- **Done when:** the profile names each layer, the threat it addresses, and its measured overhead, and the totals fit a stated budget.
