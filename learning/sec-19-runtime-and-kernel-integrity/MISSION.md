# Mission — sec-19-runtime-and-kernel-integrity

**Started**: not yet · **Family**: sec · **Phase**: S3 · **Milestone**: not yet allocated

## Why

Sam wants protection built into Syntek OS at every layer, including below userland. This topic is
the kernel- and filesystem-level integrity that makes an appliance image trustworthy: IMA/EVM
measurement, dm-verity immutable roots, eBPF runtime monitoring, and the alerting and response hooks
that turn a detection into an action. It closes the security track by composing every layer — from
Secure Boot to antivirus to runtime monitoring — into one defence-in-depth profile with its
overhead measured, because security and efficiency are both first-class goals. It all runs in QEMU
first, before any hardware is chosen.

_Drafted from Sam's planning conversation of 27/09/2026 — confirm or rewrite in your own words at the first lesson._

## Can do it when

- Sam can enable an IMA measurement policy in a VM and read the measurement log.
- Sam can build a dm-verity image, boot it read-only, and observe verification failing on a corrupted block.
- Sam can write an eBPF or bpftrace probe that flags a suspicious behaviour and measure its overhead.
- Sam can wire an integrity or monitoring event to an alert and a bounded automated response.
- Sam can specify a defence-in-depth profile for a Syntek OS edition and state its total overhead.

## Parked for later

- Choosing hardware for any profile — deferred until a profile is proven in QEMU (`GAPS.md`).
- The release and security-tracking process across the whole distribution — os-16.
