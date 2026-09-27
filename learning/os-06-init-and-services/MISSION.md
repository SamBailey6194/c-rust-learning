# Mission — os-06-init-and-services

**Started**: not yet · **Family**: os · **Phase**: P6 · **Milestone**: not yet allocated

## Why

_Drafted from Sam's planning conversation of 27/09/2026 — confirm or rewrite in your own words at the first lesson._

Sam asked for "a clean distro" rather than a fork, and an independent Syntek OS owns every layer above the kernel —
the first of which is PID 1. His profiles pull in different directions: the beginner,
intermediate and expert desktops need sessions and seats, while the server, NAS, homelab and router profiles need
services that stay up. Writing a small init in C shows what the job really is; comparing the real init systems
against each profile's needs gives the evidence for the ADR that will choose Syntek OS's own — a decision Sam has
deliberately left until the learning build is done.

## Can do it when

- Sam can list PID 1's duties and predict the failure when each is neglected.
- Sam's minimal init in C passes `make test`, `make san` and `make memcheck`, reaps orphans as PID 1 of a PID
  namespace, and boots to a shell in QEMU.
- Sam has written the INIT-SYSTEM-CHOICE research note comparing systemd, runit, s6 and OpenRC per profile.
- Sam's supervisor restarts a failing service with backoff, orders services by readiness, and runs one in a cgroup
  with an enforced memory limit.
- Sam's init logs its services and shuts down in order, and the QEMU guest powers off cleanly.

## Parked for later

- Choosing Syntek OS's own init — an ADR fed by the INIT-SYSTEM-CHOICE research note (`DEFERRED.md`).
- A supervised local model service under a cgroup limit — os-17-local-model-integration.
- Privilege separation and D-Bus for system tools — ui-07-system-tools-tui.
- Service hardening with seccomp and Landlock — sec-04-linux-security-model.
