# PROFILE-HOMELAB — Homelab Profile (first edition)

**Last Updated**: 28/09/2026 | **Version**: 0.1.0 | **Maintained By**: Sam Bailey
**Language**: British English (en_GB) | **Timezone**: Europe/London

| Field | Value |
| --- | --- |
| **Profile** | homelab (server family) — part of the first edition with server |
| **Status** | Draft — hypotheses to research, then test at P6 (words owned by `project-management/src/07-OS-PROFILES/CLAUDE.md`) |
| **Driving milestone** | none yet — profile milestones are cut at P5 and P6 |
| **Matrix** | `project-management/src/07-OS-PROFILES/PROFILE-MATRIX.md` → Homelab column |
| **Date** | 27/09/2026 |

This is a sketch. Every value below is a hypothesis, labelled "assumption to test"; none is a
decision. The homelab profile is one of seven on one base
(`project-management/src/08-DECISIONS/ADR-MS001-SYNTEK-OS-PROFILES-ON-ONE-BASE-27-09-2026.md`) and,
with server, is the **first edition to ship** (`ROADMAP.md` → Critical path). It builds on the
server profile, adding containers and virtual machines.

---

## 1. Target user

Someone running self-hosted services and experiments at home — containers, a few virtual machines,
some monitoring — who is comfortable on the command line and wants room to try things. They give up
when the virtualisation stack is opaque or when an experiment cannot be torn down cleanly.

---

## 2. Principles

1. **Room to experiment, without risking the host.** Containers and VMs are isolated; a broken
   experiment is thrown away, not repaired.
2. **Built on the server base.** Whatever the server profile hardens, the homelab profile inherits.
3. **Observable.** Monitoring shows what is running and what it is using.

---

## 3. Axis values

| Axis | Value | Why | Source | Tested by |
| --- | --- | --- | --- | --- |
| Target user | Runs containers and VMs for self-hosting and experiment | Sam's stated homelab use (Q9) | assumption to test | H1 |
| Installer | Guided text installer; manual for storage and virtualisation | The user configures storage and virtualisation deliberately | assumption to test | H1 |
| Default desktop / shell | Login shell only; managed over SSH | A homelab host is headless, like the server | assumption to test | — |
| Package-manager exposure | Fully exposed | The user installs and builds freely | assumption to test | — |
| Init system | The base init with service supervision | Containers and VMs run as supervised services | assumption to test | — (shared base init) |
| Kernel config + update cadence | Config for KVM and containers; longterm line; user-started updates | Virtualisation needs KVM and the container namespaces built in; the user times updates | assumption to test | H2 |
| Documentation & guidance level | Reference plus container and VM how-tos | The user follows procedures for the stack | assumption to test | H1 |
| Rescue / recovery tooling | Previous kernel kept; container and VM state recovery documented | Recovering guests is its own skill | assumption to test | H3 |
| Network exposure & firewall default | Services on the LAN; administration and metrics on the management network only; DNS and DHCP consumed from the router, not served; firewall deny by default | Homelab services are for the LAN, not the internet; one DNS and DHCP design serves the whole LAN (`os-14-router-edition` lesson 03's ADR draft), and the homelab consumes it (networking and licensing round, 27/09/2026) | assumption to test | H4, H5 |
| Storage stack | LVM or Btrfs for VM and container images | Snapshots and thin volumes suit disposable guests | assumption to test | H3 |
| Hardware target | VMs and QEMU disk images only until hardware is chosen by ADR | No hardware is chosen yet (Sam's decision after the critique, 27/09/2026) | assumption to test | — |

---

## 4. Hypotheses

```text
H1  Claim:      the homelab image installs and runs one container by following the how-to alone.
    Test:       in QEMU (with nested virtualisation where available, or a container runtime
                only), install from the image and start one container following the how-to.
    Passes if:  the container runs and every command used appears in the how-to.
    Tested at:  P6, the homelab edition milestone.

H2  Claim:      the kernel config supports KVM and the container namespaces the stack needs.
    Test:       in QEMU, check /dev/kvm (or the documented CPU-path fallback); check the namespace
                and cgroup options in the built .config recorded in the KERNEL-IMPL record (or
                scripts/extract-ikconfig on the image); /proc/config.gz only if the fragment
                enables CONFIG_IKCONFIG and CONFIG_IKCONFIG_PROC, which x86_64_defconfig does not.
    Passes if:  the required options are present, or the documented fallback is used and noted.
    Tested at:  P6, the homelab kernel milestone.

H3  Claim:      a container or VM can be snapshotted and rolled back on the storage stack.
    Test:       in QEMU, snapshot a guest's volume, change it, roll back.
    Passes if:  the rollback restores the earlier state, following the how-to.
    Tested at:  P6, the homelab storage milestone.

H4  Claim:      homelab services are reachable on the LAN but the firewall denies by default.
    Test:       in QEMU on an isolated network, reach a service from a LAN guest and confirm the
                firewall's default-deny with a scan.
    Passes if:  the chosen service is reachable and nothing else is.
    Tested at:  P6, the homelab image milestone.

H5  Claim:      the homelab takes its address and resolver from the LAN's DHCP server and serves
                neither DHCP nor DNS.
    Test:       in QEMU on os-09's isolated lab, with os-09 lesson 07's lab-only dnsmasq serving
                the LAN with a reservation, boot the image and probe UDP 53 and 67 and TCP 53
                from a LAN guest.
    Passes if:  the reserved lease is held, a lab name resolves, and nothing answers on 53 or 67.
    Tested at:  P6, the homelab image milestone.
```

---

## 5. Kernel config for this profile

Built on the server fragment, adding KVM and the container namespaces and cgroups, on the downstream
kernel's longterm line (`ADR-MS001-KERNEL-DOWNSTREAM-OF-UPSTREAM-27-09-2026.md`). **This is a
first-edition fragment**: the base, server and homelab fragments are P5's exit gate. Its fragment lives in the downstream kernel repository (created in `kernel-05-downstream-tree`
lesson 02; the lesson drafts start under `code/src/kernel/`, planned — added at P4), and its build
plan and record in `project-management/src/06-KERNEL/` at P5.

---

## 6. Open questions

| Question | Blocks | Where it goes |
| --- | --- | --- |
| Can the container and VM stack be tested in QEMU without nested virtualisation, and where is the CPU-path fallback used? | H1, H2 | research note; the P6 homelab milestone |
| Which container and VM tooling the profile ships | Package-manager exposure; the how-tos | `os-12-homelab-edition`; ADR if hard to reverse |
| What hardware the homelab profile targets | Hardware target | `GAPS.md` Open question; ADR when the topic opens |

---

## Cross-references

- `project-management/src/07-OS-PROFILES/PROFILE-MATRIX.md` — this profile's column
- `project-management/src/07-OS-PROFILES/PROFILE-SERVER.md` — the profile this one builds on
- `project-management/src/01-ROADMAP/ROADMAP.md` — P5 and P6, and the critical path
- `project-management/src/08-DECISIONS/ADR-MS001-SYNTEK-OS-PROFILES-ON-ONE-BASE-27-09-2026.md`
- `GAPS.md` → "Syntek OS profile definitions are hypotheses"
