# Mission — sec-13-hardening-and-secure-boot

**Started**: not yet · **Family**: sec · **Phase**: S3 · **Milestone**: not yet allocated

## Why

Sam's plan ships a server or homelab edition first and treats the router edition as a real security
responsibility. An edition Sam trusts has to boot code he trusts and run in a hardened state. This
topic secures the boot chain with keys Sam controls and hardens each profile image against a
baseline, so "secure by design" is measured, not assumed. It all runs in VMs and OVMF first, in
keeping with the decision that no hardware is chosen yet and every profile is proven in QEMU before
any board is bought.

_Drafted from Sam's planning conversation of 27/09/2026 — confirm or rewrite in your own words at the first lesson._

## Can do it when

- Sam can apply a hardening baseline to a profile image and record its deviations with reasons.
- Sam can audit a profile image with lynis and triage the findings.
- Sam can explain the UEFI Secure Boot key hierarchy and demonstrate acceptance and rejection in an OVMF VM.
- Sam can sign a kernel and bootloader with his own keys and boot them under Secure Boot.
- Sam can read a TPM's PCRs and event log and explain measurement versus enforcement.

## Parked for later

- Secure Boot and measured boot on real hardware — waits for the per-profile hardware ADR (`GAPS.md` → "No hardware
  chosen for the Syntek OS profiles"); Secure Boot for the profile images is P6's (`DEFERRED.md`, row "UEFI Secure
  Boot for Syntek OS images").
- Testing whether the hardening actually resists attack — sec-14 (testing Syntek OS) does that in the lab.
