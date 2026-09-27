# Syllabus — sec-13-hardening-and-secure-boot

**Track**: sec · **Phase**: S3 · **Path**: Later · **Detail**: outline · **Prerequisites**: sec-04 (Linux security model), kernel-04 (hardening config), os-02 (storage and boot: UEFI, ESP, OVMF), os-10 (profiles and installer)
**Status**: Planned · **Checked**: 27/09/2026 (sources re-verified by `/teach` step 3 before each lesson)

S3 turns the discipline on Sam's own systems. This topic hardens the Syntek OS profile images and secures their boot chain: a hardening baseline and audit, then UEFI Secure Boot with keys Sam controls, then measured boot and the TPM. It is the security half of shipping a server or homelab edition Sam can trust. Every build runs in a VM or QEMU disk image with OVMF and a virtual TPM. Secure Boot for the profile images is taken up in P6 (`DEFERRED.md`, row "UEFI Secure Boot for Syntek OS images"); real hardware waits for the per-profile hardware ADR (`GAPS.md` → "No hardware chosen for the Syntek OS profiles"), and no host disks or host firmware are touched. It is an **outline** topic because S3 is a far phase: its builds are sketched and its sources, checked on 27/09/2026, are re-verified when the topic opens.

| # | Lesson | Size | Build | Lenses |
| --- | --- | --- | --- | --- |
| 01 | Hardening baselines | 2–3 sittings | yes — baseline-apply | Safety |
| 02 | Auditing with lynis | 2–3 sittings | yes — lynis-audit | Safety |
| 03 | The UEFI Secure Boot chain | multi-session build | yes — sb-ovmf | Safety |
| 04 | Signing kernels and bootloaders | 2–3 sittings | yes — sb-sign | Safety |
| 05 | Measured boot and TPM basics | 2–3 sittings | yes — tpm-pcr | Safety |

---

## 01 — Hardening baselines

- **Objective:** Sam can apply a hardening baseline to a Syntek OS profile image and record its deviations with reasons.
- **Builds on:** sec-04's users, permissions, capabilities and LSMs; kernel-04's hardening config; os-10's profiles.
- **Key ideas:**
  - A baseline is a checklist of hardening settings (a CIS-benchmark style); applying one is a per-profile decision, not a blanket copy.
  - Every deviation from the baseline is recorded with a reason — a deviations register, not silent drift.
  - Measure before and after: which settings changed the attack surface, and at what cost to function.
  - The server and homelab profiles are the first editions, so they are hardened first.
- **Recall targets:** what a baseline is and why deviations are recorded; why hardening is per-profile.
- **Build:** apply a baseline checklist to a server-profile VM image and record deviations. Planned: a baseline checklist and deviations note in this topic folder; the applied settings land in the Syntek OS build-system repository (created when that build starts).
- **Safety:** VM images only; no host system is hardened by these exercises.
- **Sources:** (checked 27/09/2026; re-verify when S3 opens) CIS Benchmarks (<https://www.cisecurity.org/cis-benchmarks>; site blocks automated fetch (403 on 27/09/2026) — read in a browser and pin the specific benchmark and version at lesson open); kernel-04's hardening config for the kernel side.
- **Done when:** a server-profile VM has a baseline applied and a deviations register that explains each exception.

---

## 02 — Auditing with lynis

- **Objective:** Sam can audit a profile image with lynis, read its findings, and triage them.
- **Builds on:** lesson 01's baseline; sec-04's model of what the findings are about.
- **Key ideas:**
  - lynis runs a system audit and reports a hardening index and specific suggestions and warnings.
  - Findings are triaged, not blindly applied: some suggestions do not fit a given profile.
  - Re-auditing after fixes shows movement and catches regressions.
  - The audit is a starting point that feeds the deviations register from lesson 01.
- **Recall targets:** what lynis reports and how to read its priority; why a suggestion is triaged, not obeyed.
- **Build:** run lynis against a server and a NAS profile VM image and triage the findings into fix, accept-with-reason and not-applicable. Planned: an audit note in this topic folder.
- **Safety:** VM images only.
- **Sources:** (checked 27/09/2026; re-verify when S3 opens) Lynis (<https://cisofy.com/lynis/>) — the `man lynis` page is not shipped by the host (checked 27/09/2026), so cite the CISOfy documentation and the tool's own `--help`.
- **Done when:** Sam produces a triaged lynis finding list for a profile image and can justify each disposition.

---

## 03 — The UEFI Secure Boot chain

- **Objective:** Sam can explain how UEFI Secure Boot verifies each stage of the boot chain and demonstrate it in an OVMF VM.
- **Builds on:** os-02's UEFI, the ESP and OVMF in QEMU; os-10's images.
- **Key ideas:**
  - Secure Boot verifies the bootloader (and onward) against signatures in the firmware's databases.
  - The key hierarchy: Platform Key (PK), Key Exchange Key (KEK), the allowed (db) and forbidden (dbx) databases.
  - shim is a first-stage loader that the firmware verifies against db (on shipped PCs, a Microsoft UEFI CA signature); it then verifies the next stage against its built-in vendor certificate or the Machine Owner Key (MOK) list, so an owner can add keys without taking over the firmware. A fully owner-controlled chain instead puts the firmware in Setup Mode and enrols the owner's own PK, KEK and db (what `sbctl enroll-keys` automates) — no shim needed.
  - OVMF gives a full UEFI firmware inside QEMU, so the whole chain is testable without real hardware.
- **Recall targets:** what each of PK, KEK, db and dbx does; where shim and MOK fit, and which of the two routes (shim with MOK, or owner-enrolled PK, KEK and db) keeps a vendor key in the chain.
- **Build:** enrol owner keys and boot a signed image in an OVMF QEMU VM; observe a rejection when a signature is missing. Planned: an OVMF-based `msNNN-sb-ovmf` harness in `code/src/os/` (planned — added at P6), VM only; the profile signing lands in the Syntek OS build-system repository (created when that build starts).
- **Safety:** OVMF and QEMU only; Secure Boot for the profile images is taken up in P6 (`DEFERRED.md`, row "UEFI Secure Boot for Syntek OS images"), real hardware waits for the per-profile hardware ADR (`GAPS.md` → "No hardware chosen for the Syntek OS profiles"), and no host firmware is touched.
- **Sources:** (checked 27/09/2026; re-verify when S3 opens) shim (<https://github.com/rhboot/shim>, README <https://github.com/rhboot/shim/blob/main/README.md>); kernel module-signing background (<https://docs.kernel.org/admin-guide/module-signing.html>); sbctl for key management, README `enroll-keys` (<https://github.com/Foxboron/sbctl>).
- **Done when:** in an OVMF VM, a signed image boots and an unsigned or tampered one is rejected, and Sam can name which key allowed or denied it.

---

## 04 — Signing kernels and bootloaders

- **Objective:** Sam can sign a kernel and a bootloader with keys he controls and boot them under Secure Boot.
- **Builds on:** lesson 03's key hierarchy; kernel-05's downstream tree (the kernel being signed).
- **Key ideas:**
  - Signing tools (`sbsign`/`sbctl`) attach a signature the firmware's db can verify.
  - What gets signed: the bootloader (systemd-boot or GRUB) and the kernel image; the chain must be signed end to end.
  - Key management: owner keys versus enrolled vendor keys, where private keys live, and rotation.
  - A signed kernel plus module signing (from the kernel track) closes the gap between boot and running modules.
- **Recall targets:** what is signed and in what order; why key storage and rotation matter as much as the signing.
- **Build:** sign a kernel and the bootloader and boot them under Secure Boot in an OVMF VM. Planned: extends the lesson 03 harness; the production signing pipeline lands in the Syntek OS build-system repository (created when that build starts).
- **Safety:** OVMF and QEMU only; private keys are test keys, never committed (`.gitignore`).
- **Sources:** (checked 27/09/2026; re-verify when S3 opens) `sbsign` (<https://man.archlinux.org/man/sbsign.1>); sbctl (<https://github.com/Foxboron/sbctl>); systemd-boot (<https://www.freedesktop.org/software/systemd/man/latest/systemd-boot.html>; if freedesktop.org answers 418 to scripted checks, as it did on 27/09/2026, check via <https://man.archlinux.org/man/systemd-boot.7>); kernel module signing (<https://docs.kernel.org/admin-guide/module-signing.html>).
- **Done when:** a kernel and bootloader Sam signed boot under Secure Boot in an OVMF VM, and swapping in an unsigned kernel is rejected.

---

## 05 — Measured boot and TPM basics

- **Objective:** Sam can read a TPM's PCRs and the measured-boot log and explain how measurement differs from Secure Boot's enforcement.
- **Builds on:** lessons 03–04; the TPM as a hardware root of trust.
- **Key ideas:**
  - Measured boot records a hash of each stage into TPM Platform Configuration Registers (PCRs); it measures, it does not block.
  - The event log explains what each PCR value came from.
  - Secrets can be sealed to a set of PCR values so they unseal only in a known-good state (concept).
  - Secure Boot enforces at boot; measured boot lets a later check (local or remote) attest what booted.
- **Recall targets:** the difference between measurement and enforcement; what a PCR holds and why the event log is needed to interpret it.
- **Build:** boot a QEMU guest with a virtual TPM (swtpm), read the PCRs and the event log, and match a PCR to its log entries. Planned: a `msNNN-tpm-pcr` VM harness in `code/src/os/` (planned — added at P6); read-only inspection only.
- **Safety:** VM with a virtual TPM only; no host TPM state is changed.
- **Sources:** (checked 27/09/2026; re-verify when S3 opens) kernel TPM documentation (<https://docs.kernel.org/security/tpm/index.html>); confirm the `tpm2-tools` and `swtpm` commands with their `--help` at lesson open.
- **Done when:** Sam reads PCRs and the event log in a VM and explains why measured boot alone does not stop a bad boot.
