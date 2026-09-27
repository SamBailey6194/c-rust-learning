# Mission — os-12-homelab-edition

**Started**: not yet · **Family**: os · **Phase**: P6 · **Milestone**: not yet allocated

## Why

_Drafted from Sam's planning conversation of 27/09/2026 — confirm or rewrite in your own words at
the first lesson._

A homelab version is one of the Syntek OS editions Sam listed, and the planning conversation paired
it with the server as the first edition to ship (recommended, to confirm). A homelab host exists to
run other things — containers, virtual machines, and eventually Sam's own local model with its
skills — so this topic teaches those on the kernel primitives Sam will already have built by hand,
and makes the host watch its own CPU, memory and I/O. That fits the wider goal of using computing
resources properly: every service gets a budget, and the budget is measured, not guessed.

## Can do it when

- Sam can run an OCI bundle rootless with a memory limit and show the namespaces, cgroup limits and
  filters applied to it.
- Sam can explain an OCI image, pin it by digest, and his digest verifier rejects tampered content.
- Sam can run a VM under KVM inside the QEMU test guest and compare its boot time with TCG.
- Sam can read pressure and per-service cgroup statistics and say what each means.
- Sam can publish metrics in the Prometheus text format on a restricted endpoint and raise an alert
  on a threshold.

## Parked for later

- Choosing real homelab hardware — an ADR when that decision is due (`GAPS.md`).
- Container orchestration across several hosts — out of scope for the first edition.
- Running the local model as a homelab service — `os-17-local-model-integration`.
- Intrusion detection on the lab network — `sec-16-detection-response-and-disclosure`.
