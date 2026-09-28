# Syllabus — os-14-router-edition

**Track**: os · **Phase**: P6 · **Path**: Later · **Detail**: full · **Prerequisites**: `os-12-homelab-edition` (and through it `os-11-server-edition`); `os-09-networking-fundamentals` (addressing and routing, DNS and DHCP from the client's side, IPv6 essentials, the isolated lab of namespaces, veth, bridge and tap, nftables fundamentals, `ss` and `tcpdump`); `kernel-04-kconfig-and-profile-configs` lessons 02 and 07 (the fragment method, measuring a config); `sec-05-applied-cryptography` lessons 05 and 06 (X25519 key exchange and key management, for WireGuard's keys)
**Status**: Planned · **Checked**: 27/09/2026 (sources re-verified by `/teach` step 3 before each lesson)

The router profile sits between the home network and the internet, so it carries more security
responsibility than any other edition: a mistake here exposes every device behind it. The topic
builds a router one function at a time — forwarding and NAT, bridges and VLANs, DHCP and DNS
service, IPv6 with router advertisements and prefix delegation, WireGuard — then writes its minimal
kernel fragment, audits its attack surface, and ends with how its hardware will be chosen. It is
marked **Later**: the first edition does not wait for it. Every lesson runs in `os-09`'s isolated
lab — an upstream namespace or guest standing in for the internet, the router guest, and client
guests — and never touches the home network; testing on real hardware waits for dedicated, wiped
hardware chosen by ADR (`GAPS.md`), and a lab-proven config reaches Sam's own network only under
`project-management/src/08-DECISIONS/ADR-MS001-NETWORK-LAB-FIRST-GRADUATION-PATH-27-09-2026.md`.
The router's web admin is `ui-10-web-admin-dashboard`'s work. Small scripts land in `code/src/os/`
(planned — added at P6); the profile's recipes land in the Syntek OS build-system repository,
created when that build starts.

| # | Lesson | Size | Build | Lenses |
| --- | --- | --- | --- | --- |
| 01 | Forwarding and NAT | 1 sitting | yes — lab router with NAT | Security, Safety |
| 02 | Bridges and VLANs | 1 sitting | yes — isolated guest VLAN | Security, Safety |
| 03 | DHCP and DNS service for the LAN | 2–3 sittings | yes — LAN services test | Security, Safety |
| 04 | IPv6 for routers: advertisements and prefix delegation | 2–3 sittings | yes — delegated prefix in the lab | Security, Safety |
| 05 | WireGuard | 1 sitting | yes — road-warrior tunnel | Security, Safety |
| 06 | The router kernel fragment | 1 sitting | yes — router fragment | Efficiency, Security, Safety |
| 07 | Hardening and attack surface | 1 sitting | yes — surface audit | Security, Safety |
| 08 | Choosing router hardware | 1 sitting | no | Efficiency, Safety |

---

## 01 — Forwarding and NAT

- **Objective:** Sam can turn a guest into a router that forwards LAN traffic to an upstream network
  with masquerading, admits only replies back in, and drops spoofed sources.
- **Builds on:** `os-09-networking-fundamentals` (routing tables, the isolated lab, nftables
  fundamentals); `os-11-server-edition` lesson 04 (a host firewall).
- **Key ideas:**
  - IPv4 forwarding is off by default (`ip_forward` = 0); turning it on also resets the interface
    settings to router defaults.
  - A router's firewall lives in the forward chain: policy drop, LAN to upstream allowed, replies
    allowed back through connection tracking.
  - Masquerading is source NAT to the outgoing interface's address, done in a `nat` chain on the
    postrouting hook; private LAN ranges are the RFC 1918 blocks.
  - Reverse-path filtering (`rp_filter`, strict or loose as in RFC 3704) drops packets whose source
    could not have arrived on that interface.
- **Recall targets:** which chain decides forwarding; why masquerade belongs in postrouting; what
  strict reverse-path filtering drops.
- **Build:** in `os-09`'s lab, an upstream namespace, a router guest with two interfaces and a LAN
  guest; the router's forwarding and NAT ruleset; and a test script in `code/src/os/` (planned —
  added at P6) asserting that the LAN reaches upstream, upstream cannot open a connection into the
  LAN, and a spoofed source is dropped.
- **Security lens:** default-deny forwarding; anti-spoofing; nothing on the upstream side reaches
  the LAN unasked.
- **Safety:** isolated virtual network only; the lab has no route to the home LAN (`os-09`'s proof).
- **Sources:** docs.kernel.org, "IP Sysctl" (`ip_forward`, `rp_filter`; v7.3-rc4 render),
  <https://docs.kernel.org/networking/ip-sysctl.html>; nftables wiki, "Performing Network Address
  Translation (NAT)" (revision 1113),
  <https://wiki.nftables.org/wiki-nftables/index.php/Performing_Network_Address_Translation_(NAT)>;
  nftables wiki, "Simple ruleset for a home router" (revision 1057),
  <https://wiki.nftables.org/wiki-nftables/index.php/Simple_ruleset_for_a_home_router>; RFC 1918,
  <https://www.rfc-editor.org/rfc/rfc1918>.
- **Done when:** the three assertions pass and Sam explains each rule in the forward chain.

## 02 — Bridges and VLANs

- **Objective:** Sam can bridge LAN ports into one segment and add an isolated guest VLAN, and prove
  the isolation from a client.
- **Builds on:** lesson 01; `os-09-networking-fundamentals` (the bridge in the lab).
- **Key ideas:**
  - A Linux bridge forwards frames between segments by destination MAC address — a software switch.
  - An 802.1Q VLAN interface (`ip link add ... type vlan id N`) tags traffic on a parent link; a
    VLAN-aware bridge (`vlan_filtering`, `bridge vlan`) keeps VLANs apart inside one bridge.
  - Separate networks for the main LAN, guests and management, with the firewall deciding what
    crosses between them.
- **Recall targets:** what a bridge learns and forwards; what a VLAN tag changes; where traffic
  between VLANs is decided.
- **Build:** the router guest bridges two LAN ports and adds a guest VLAN, with a test script in
  `code/src/os/` (planned — added at P6) proving that a guest-VLAN client reaches upstream but not
  the main LAN.
- **Security lens:** segmentation limits what a compromised guest device can reach.
- **Safety:** isolated virtual network only.
- **Sources:** docs.kernel.org, "Ethernet Bridging", <https://docs.kernel.org/networking/bridge.html>;
  `man 8 ip-link` (VLAN type support, `vlan_filtering`); `man 8 bridge` (`bridge vlan`).
- **Done when:** the isolation test passes and fails when the inter-VLAN rule is opened.

## 03 — DHCP and DNS service for the LAN

- **Objective:** Sam can serve DHCP leases and DNS to the LAN from the router, only on LAN interfaces,
  and choose between a combined and a split design.
- **Builds on:** `os-09-networking-fundamentals` (DHCP and DNS from the client's side); lessons 01–02.
- **Key ideas:**
  - A DHCPv4 server hands out a lease: an address, the router and the DNS server.
  - dnsmasq combines DHCP, a caching DNS forwarder and router advertisements for a small LAN; a split
    design pairs ISC's Kea (the successor of ISC DHCP, which went out of support in December 2022)
    with Unbound, a validating recursive resolver.
  - BLFS 13.1 builds Kea 3.0.2 and BIND but has no page for dnsmasq or Unbound, so choosing either
    means a recipe Syntek OS writes itself; the choice is an ADR.
  - Services bind to LAN interfaces only; a resolver that answers the internet becomes an open
    resolver.
- **Recall targets:** what a lease contains; combined against split designs; why the resolver must
  not answer on the upstream side.
- **Build:** one design serving the lab's LAN guest, with a test script in `code/src/os/` (planned —
  added at P6) asserting that the LAN client gets a lease and resolves names while the upstream side
  gets no DNS or DHCP answer.
- **Security lens:** open-resolver abuse; rogue DHCP on the LAN; DNSSEC validation in the split
  design.
- **Safety:** isolated virtual network only.
- **Sources:** dnsmasq(8) (manual dated 05/02/2025),
  <https://thekelleys.org.uk/dnsmasq/docs/dnsmasq-man.html>; BLFS 13.1 "Kea 3.0.2 DHCP Server",
  <https://www.linuxfromscratch.org/blfs/view/13.1-systemd/server/kea.html>; Kea 3.0.2 reference
  manual, <https://kea.readthedocs.io/en/kea-3.0.2/>; Unbound documentation (read 27/09/2026),
  <https://unbound.docs.nlnetlabs.nl/en/latest/>.
- **Done when:** the assertions pass and the design choice is written up as an ADR draft.

## 04 — IPv6 for routers: advertisements and prefix delegation

- **Objective:** Sam can have the router obtain a delegated IPv6 prefix from upstream, advertise a
  /64 from it on the LAN, and keep a stateful firewall in front of the LAN.
- **Builds on:** `os-09-networking-fundamentals` (IPv6 essentials: link-local, SLAAC, NDP);
  lessons 01 and 03.
- **Key ideas:**
  - Routers announce prefixes and themselves with Router Advertisements (RFC 4861); hosts form
    addresses with SLAAC (RFC 4862).
  - The upstream delegates a prefix to the router with DHCPv6 prefix delegation (the IA_PD option,
    RFC 9915, which obsoletes RFC 8415); RFC 7084 requires customer-edge routers to support it.
  - With forwarding on, an interface ignores Router Advertisements unless `accept_ra` is 2 — the
    upstream interface needs that.
  - There is no NAT in the usual IPv6 design, so the stateful firewall is what keeps the LAN
    unreachable; ICMPv6 neighbour discovery must still pass.
- **Recall targets:** RA against DHCPv6; why the upstream interface needs `accept_ra` = 2; what
  replaces NAT's accidental protection.
- **Build:** in the lab, an upstream namespace or guest that delegates a prefix (Kea's DHCPv6 server
  has prefix-delegation pools), a router that advertises a /64 to the LAN, and a test script in
  `code/src/os/` (planned — added at P6) asserting that the LAN guest gets a SLAAC address and reaches
  upstream while upstream cannot open a connection into the LAN.
- **Security lens:** a globally addressed LAN is protected only by the firewall.
- **Safety:** isolated virtual network only.
- **Sources:** RFC 4861, <https://www.rfc-editor.org/rfc/rfc4861>; RFC 4862,
  <https://www.rfc-editor.org/rfc/rfc4862>; RFC 9915 (January 2026; Section 21.21, IA_PD),
  <https://www.rfc-editor.org/rfc/rfc9915>; RFC 7084 (requirement WPD-1),
  <https://www.rfc-editor.org/rfc/rfc7084>; docs.kernel.org, "IP Sysctl" (`accept_ra`); Kea 3.0.2,
  "The DHCPv6 Server" (subnet and prefix delegation pools),
  <https://kea.readthedocs.io/en/kea-3.0.2/arm/dhcp6-srv.html>; dnsmasq(8) (`--enable-ra`).
- **Done when:** the assertions pass for IPv6 as they did for IPv4 in lesson 01.

## 05 — WireGuard

- **Objective:** Sam can give a remote peer access to the LAN through WireGuard on the router,
  limited to the addresses its key allows.
- **Builds on:** `sec-05-applied-cryptography` lessons 05 and 06 (X25519 key exchange, key management);
  lessons 01–02.
- **Key ideas:**
  - Cryptokey routing: each peer's public key is bound to the tunnel addresses it may use
    (`AllowedIPs`), which acts as a routing table when sending and as an access list when receiving.
  - Keys are made with `wg genkey` and `wg pubkey`; the private key is a secret that never enters the
    repository or an image.
  - WireGuard fixes its cryptography (the Noise protocol framework, Curve25519, ChaCha20, Poly1305,
    BLAKE2) rather than negotiating it.
  - The router's firewall admits the WireGuard UDP port and decides what the tunnel may reach.
- **Recall targets:** what `AllowedIPs` does in each direction; where the private key lives; what the
  firewall must allow.
- **Build:** a road-warrior peer guest that reaches one LAN host through the router's WireGuard
  interface, with a test script in `code/src/os/` (planned — added at P6) asserting that a wrong key
  is ignored and that addresses outside `AllowedIPs` are unreachable.
- **Security lens:** key custody; the tunnel as a new way into the LAN.
- **Safety:** isolated virtual network only.
- **Sources:** WireGuard, "Cryptokey Routing", <https://www.wireguard.com/>; WireGuard whitepaper,
  <https://www.wireguard.com/papers/wireguard.pdf>; WireGuard quick start,
  <https://www.wireguard.com/quickstart/>; `man 8 wg`.
- **Done when:** the tunnel works for the allowed host and both refusals are shown.

## 06 — The router kernel fragment

- **Objective:** Sam can write the router profile's minimal kernel fragment with `kernel-04`'s
  method and measure it against the server's.
- **Builds on:** `kernel-04-kconfig-and-profile-configs` lessons 02, 06 and 07; lessons 01–05.
- **Key ideas:**
  - The router needs netfilter and nftables, bridging, 802.1Q VLANs and WireGuard on top of the base
    fragment; almost everything else can go.
  - Network drivers wait for the hardware choice (lesson 08); until then the QEMU virtual devices
    stand in.
  - The kernel line is longterm, as for the rest of the server family
    (`project-management/src/08-DECISIONS/ADR-MS001-KERNEL-DOWNSTREAM-OF-UPSTREAM-27-09-2026.md`).
  - A smaller kernel is less attack surface; measure image size and module count.
- **Recall targets:** what the router fragment adds and removes; why drivers wait; how the fragment
  is checked.
- **Build:** the router fragment, merged strictly over the base with `kernel-04` lesson 02's script,
  alongside the other fragments in `code/src/kernel/msNNN-profile-fragments/` (planned — added at P4)
  or the downstream kernel repository once `kernel-05-downstream-tree` has created it. Checked by a
  warning-free strict merge on the compiler recorded in `kernel-04` lesson 03 (whose base excludes the
  options that compiler cannot build), a build, and lessons 01–05's tests passing on the new kernel.
- **Efficiency lens:** image size, module count and boot time with `kernel-04` lesson 07's script.
- **Security lens:** each line reviewed against the router profile's threat model.
- **Safety:** the router kernel boots in QEMU only.
- **Sources:** docs.kernel.org, "Kconfig Language", <https://docs.kernel.org/kbuild/kconfig-language.html>;
  the router profile spec (PROFILE-ROUTER in `project-management/src/07-OS-PROFILES/`).
- **Done when:** the merge, build and all earlier tests pass on the router kernel, and the
  measurements are recorded against the server kernel's.

## 07 — Hardening and attack surface

- **Objective:** Sam can audit what the router exposes on each side and show that it matches the
  profile spec exactly.
- **Builds on:** lessons 01–06; `sec-01-principles-threat-modelling-and-law` lesson 02 (attack surface
  and trust boundaries); `os-11-server-edition` lessons 03 and 05 (SSH, updates).
- **Key ideas:**
  - Nothing listens on the upstream side; administration comes only from the management network,
    over SSH with keys.
  - Updates follow `os-08`'s signed flow, but a failed router update takes the network down, so they
    are staged with a way back.
  - Logging of dropped traffic is rate-limited so it cannot flood the disk.
  - The audit is evidence: a scan from each side and the router's own socket list, compared with the
    spec.
- **Recall targets:** what may listen on each side; why router updates need a way back; what the
  audit compares.
- **Build:** an audit script in `code/src/os/` (planned — added at P6) that scans the router from the
  upstream namespace and from the LAN, reads `ss` inside the router guest, and fails on any
  difference from the profile spec.
- **Security lens:** the whole lesson.
- **Safety:** scans run only inside the isolated lab, against Sam's own guests.
- **Sources:** `man 8 ss` (iproute2); nftables wiki, "Simple ruleset for a home router" (revision
  1057); the router profile spec (PROFILE-ROUTER in `project-management/src/07-OS-PROFILES/`).
- **Done when:** the audit passes and fails when an extra service is started.

## 08 — Choosing router hardware

- **Objective:** Sam can set out the criteria for router hardware and draft the ADR that chooses it.
- **Builds on:** lessons 01–07; `kernel-04-kconfig-and-profile-configs` lesson 05 (firmware needs).
- **Key ideas:**
  - No hardware has been chosen for any profile; each is chosen by ADR when its topic opens.
  - Criteria: enough network ports; network chips whose drivers are in the chosen longterm line; the
    firmware files they need from linux-firmware; CPU headroom for NAT and WireGuard at the line
    rate; power draw.
  - Real-hardware tests run only on dedicated, wiped hardware named in the milestone, and only after
    the lab tests pass — never on the home network; what may later reach Sam's own network, and how,
    is `project-management/src/08-DECISIONS/ADR-MS001-NETWORK-LAB-FIRST-GRADUATION-PATH-27-09-2026.md`.
- **Recall targets:** the criteria in priority order; why driver support is checked against the
  kernel line; the rule for real-hardware tests.
- **Build:** none — the output is a hardware ADR draft through `project-management/workflows/08-decisions/`.
- **Efficiency lens:** power and throughput targets recorded as the router's budget.
- **Safety:** the real-hardware rule in `.claude/CLAUDE.md`.
- **Sources:** BLFS 13.1 "About Firmware",
  <https://www.linuxfromscratch.org/blfs/view/13.1-systemd/postlfs/firmware.html>; `GAPS.md` ("No hardware chosen for
  the Syntek OS profiles").
- **Done when:** the ADR draft names the criteria and the evidence each candidate needs.
