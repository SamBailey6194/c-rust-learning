# PROFILE-ROUTER — Router Profile

**Last Updated**: 27/09/2026 | **Version**: 0.1.0 | **Maintained By**: Sam Bailey
**Language**: British English (en_GB) | **Timezone**: Europe/London

| Field | Value |
| --- | --- |
| **Profile** | router (server family) — Later on the critical path; real security responsibility |
| **Status** | Draft — hypotheses to research, then test at P6 (words owned by `project-management/src/07-OS-PROFILES/CLAUDE.md`) |
| **Driving milestone** | none yet — profile milestones are cut at P5 and P6 |
| **Matrix** | `project-management/src/07-OS-PROFILES/PROFILE-MATRIX.md` → Router column |
| **Date** | 27/09/2026 |

This is a sketch. Every value below is a hypothesis, labelled "assumption to test"; none is a
decision. The router profile is one of seven on one base
(`project-management/src/08-DECISIONS/ADR-MS001-SYNTEK-OS-PROFILES-ON-ONE-BASE-27-09-2026.md`); it is
**Later** on the critical path and carries real security responsibility, so it is tested only in
isolated virtual networks, never on the home network
(`ADR-MS001-NETWORK-LAB-FIRST-GRADUATION-PATH-27-09-2026.md`, which sets the one path by which a lab-proven router config
reaches Sam's own network; a Syntek OS router image is not in its scope).

---

## 1. Target user

Someone routing and filtering traffic between networks at home — a WAN side and a LAN side, perhaps a
VPN — who wants a small, hardened, legible system whose whole job is the network. They give up when
the firewall's behaviour is unclear or when a change cannot be rolled back to a known-good config.

---

## 2. Principles

1. **Deny by default on the untrusted side.** Nothing crosses from the WAN that was not explicitly
   allowed.
2. **Small and legible.** The smallest system that routes; every rule readable.
3. **Rollback to known-good.** A bad rule change is reversed to a saved config, not debugged live.

---

## 3. Axis values

| Axis | Value | Why | Source | Tested by |
| --- | --- | --- | --- | --- |
| Target user | Routes and filters traffic between networks | Sam's stated router use (Q9); "real security responsibility" (Q9 answer) | assumption to test | H1 |
| Installer | Minimal installer or an image written to the device | A router is often flashed rather than installed interactively | assumption to test | H1 |
| Default desktop / shell | Login shell; an optional web dashboard (`ui-10`) | Headless, with an optional dashboard for status and rules | assumption to test | — |
| Package-manager exposure | Minimal; updates deliberate and tested | A router changes rarely and only deliberately | assumption to test | — |
| Init system | The base init, minimal | The router runs few services | assumption to test | — (shared base init) |
| Kernel config + update cadence | Minimal hardened config; longterm line; deliberate updates | The smallest attack surface; the longest-supported line | assumption to test | H3 |
| Documentation & guidance level | Reference plus a security and firewall handbook | The firewall is the product; its rules need clear documentation | assumption to test | H1 |
| Rescue / recovery tooling | Previous kernel kept; a documented reset to a known-good config | A bad rule set must be reversible | assumption to test | H4 |
| Network exposure & firewall default | The routing/NAT/firewall subject itself; deny by default on the untrusted side | This is the profile's whole purpose | assumption to test | H2 |
| Storage stack | Small, simple root; no data pooling | A router stores config, not data | assumption to test | — |
| Hardware target | VMs and isolated virtual networks only until hardware is chosen by ADR | No hardware is chosen yet; router labs never touch the home network (`ADR-MS001-NETWORK-LAB-FIRST-GRADUATION-PATH-27-09-2026.md`) | assumption to test | — |

---

## 4. Hypotheses

```text
H1  Claim:      the router image installs and routes between two networks by the handbook alone.
    Test:       in QEMU with two isolated virtual networks (a WAN side and a LAN side), install
                and configure routing and NAT following the handbook; reach the WAN guest from
                the LAN guest.
    Passes if:  the LAN guest reaches the WAN guest and every command used appears in the handbook.
    Tested at:  P6, the router edition milestone.

H2  Claim:      the default firewall denies inbound WAN traffic while allowing established replies.
    Test:       in QEMU, from the WAN-side guest, scan and connect to the router and the LAN;
                from the LAN side, open a connection and confirm the reply returns.
    Passes if:  unsolicited WAN traffic is denied and established LAN connections work.
    Tested at:  P6, the router firewall milestone.

H3  Claim:      the minimal kernel config still carries the netfilter and routing options the profile needs.
    Test:       check the netfilter, NAT and forwarding options in the built .config recorded in
                the KERNEL-IMPL record, not /proc/config.gz: that needs CONFIG_IKCONFIG and
                CONFIG_IKCONFIG_PROC, options beyond this profile's need.
    Passes if:  the required options are present and nothing beyond the profile's need is enabled.
    Tested at:  P6, the router kernel milestone.

H4  Claim:      a bad rule change is reversed to the known-good config following the handbook.
    Test:       in QEMU, apply a rule change that breaks routing, then reset to the saved config.
    Passes if:  routing returns to working, following the handbook, with no live debugging.
    Tested at:  P6, the router recovery milestone.
```

---

## 5. Kernel config for this profile

The smallest and most hardened of the server family: forwarding, NAT, netfilter and the interfaces
the router needs, and little else, on the downstream kernel's longterm line
(`ADR-MS001-KERNEL-DOWNSTREAM-OF-UPSTREAM-27-09-2026.md`). Its fragment lives in the downstream kernel
repository (created in `kernel-05-downstream-tree` lesson 02); its plan and record in
`project-management/src/06-KERNEL/` at P5. A Later fragment.

---

## 6. Open questions

| Question | Blocks | Where it goes |
| --- | --- | --- |
| Which DHCP and DNS server, and whether WireGuard ships by default | Network exposure; the handbook | `os-14-router-edition`; ADR if hard to reverse |
| How IPv6 (RA, DHCPv6-PD) is configured and tested in the lab | Network exposure | `os-14-router-edition`; research note |
| What hardware the router profile targets | Hardware target | `GAPS.md` Open question; ADR when the topic opens |

---

## Cross-references

- `project-management/src/07-OS-PROFILES/PROFILE-MATRIX.md` — this profile's column
- `project-management/src/07-OS-PROFILES/PROFILE-HOMELAB.md` — the neighbouring server-family profile
- `project-management/src/01-ROADMAP/ROADMAP.md` — P5 and P6
- `project-management/src/08-DECISIONS/ADR-MS001-SYNTEK-OS-PROFILES-ON-ONE-BASE-27-09-2026.md` ·
  `ADR-MS001-SECURITY-TRACK-AND-LAB-RULES-27-09-2026.md` · `ADR-MS001-NETWORK-LAB-FIRST-GRADUATION-PATH-27-09-2026.md`
- `GAPS.md` → "Syntek OS profile definitions are hypotheses"
