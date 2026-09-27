# Mission — kernel-04-kconfig-and-profile-configs

**Started**: not yet · **Family**: kernel · **Phase**: P5 · **Milestone**: not yet allocated

## Why

_Drafted from Sam's planning conversation of 27/09/2026 — confirm or rewrite in your own words at the first lesson._

Sam wants one Syntek OS base with profiles for beginner, intermediate and expert desktops and laptops, and for servers,
NAS, homelab and routers — and he chose to ship the server and homelab edition first. The kernel is where profiles
start to differ: the answer in his planning conversation was that editions differ mostly by configuration (a router
minimal and hardened, a server tuned, a desktop broad), and that a downstream should start near-vanilla with good
per-edition configs. This topic is where he learns to write those configs deliberately — every line justified,
hardened from a measured baseline, with its cost in size and boot time measured — and produces the first edition's
fragments.

## Can do it when

- Read a Kconfig entry and predict whether a fragment line will survive into `.config`.
- Build a configuration from a recorded base and ordered fragments with a strict merge that fails on a lost value.
- Apply the in-tree hardening baseline, measure the gap to KSPP with kernel-hardening-checker, and justify what is
  left open.
- Argue longterm or stable for each of the seven profiles, recorded in the research note.
- State each profile's firmware and initramfs needs.
- Build and boot the base, server and homelab kernels in QEMU from committed fragments.
- Measure a configuration's image size, boot time and module count against a budget.

## Parked for later

- The NAS, router and desktop fragments → os-13-nas-edition, os-14-router-edition and os-15-desktop-editions (one
  lesson each, applying this topic's method).
- Carrying the fragments with a patch series across releases → kernel-05-downstream-tree.
- Building every profile on each new stable release → kernel-06-kernel-ci-and-security.
- Secure Boot, module signing enforcement and lockdown → sec-13-hardening-and-secure-boot and `DEFERRED.md`.
- Kernel integrity at run time (IMA/EVM, dm-verity) → sec-19-runtime-and-kernel-integrity.
