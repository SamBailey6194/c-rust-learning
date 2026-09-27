# Syllabus — os-09-networking-fundamentals

**Track**: os · **Phase**: P6 · **Path**: Core · **Detail**: full · **Prerequisites**: P2 (sockets); tooling-03-shell-scripting; may be taken any time after P2
**Status**: Planned · **Checked**: 27/09/2026 (sources re-verified by `/teach` step 3 before each lesson)

The networking every later Syntek OS profile relies on — the server's firewall, the homelab's VMs, the NAS's shares
and above all the router edition — taught from the client's side first: addresses and routes, DNS and DHCP, IPv6,
a stateful firewall, and how to watch traffic. At its centre is **an isolated lab**: network namespaces, veth pairs
and a bridge, with QEMU guests on a tap inside the namespace, and a proof that nothing in it can reach the home
network. That lab lesson is the one every later "isolated network" Safety line cites (the router edition, sec-06's
pentest lab). On this host the whole lab runs unprivileged inside a user namespace (checked 27/09/2026), so Claude
never needs `sudo` and the host's own network is never touched.

| # | Lesson | Size | Build | Lenses |
| --- | --- | --- | --- | --- |
| 01 | Layers, IPv4 addressing and CIDR, MAC and ARP | 2–3 sittings | yes — cidr-calc | — |
| 02 | Routing tables and the default gateway | 1 sitting | yes — longest-prefix match | — |
| 03 | DNS and DHCP from the client's side | 1 sitting | no | Security |
| 04 | IPv6 essentials: link-local, SLAAC, Neighbour Discovery | 1 sitting | no | — |
| 05 | An isolated lab: namespaces, veth, a bridge and QEMU guests | 2–3 sittings | yes — netns lab | Security, Safety |
| 06 | nftables fundamentals: a stateful host firewall | 2–3 sittings | yes — host firewall | Security |
| 07 | Observing traffic with `ss` and `tcpdump` | 1 sitting | no | Security, Safety |

---

## 01 — Layers, IPv4 addressing and CIDR, MAC and ARP

- **Objective:** Sam can place a packet's addresses at the right layer, compute a CIDR block's network, broadcast and
  host range by hand and in C, and explain how ARP maps an IPv4 address to a MAC address on the local link.
- **Builds on:** P2 sockets (TCP and UDP from C); P1 bit operations.
- **Key ideas:**
  - Link, network and transport layers each carry their own addresses: MAC on the link, IP between networks, ports
    between programs.
  - CIDR writes a block as an address and a prefix length; the prefix is a mask, so the network, broadcast and host
    range fall out of bit operations.
  - Private ranges (10/8, 172.16/12, 192.168/16) are for internal networks; 192.0.2.0/24, 198.51.100.0/24 and
    203.0.113.0/24 are reserved for documentation — safe to use in examples and lab notes.
  - ARP asks "who has this IPv4 address?" on the local link and caches the answer (`ip neigh`).
- **Recall targets:** the three address kinds and their layers; a block's network and broadcast from its prefix; what
  an ARP request and reply contain.
- **Build:** a CIDR calculator in `code/src/c/msNNN-cidr-calc/` (planned code path), using `inet_pton(3)`, that prints
  a block's network, broadcast and host range. Checked by `make test` (cases including /0, /24, /31 and /32 and
  malformed input), `san` and `memcheck`.
- **Sources:** RFC 791 "Internet Protocol" (<https://www.rfc-editor.org/rfc/rfc791>); RFC 4632 "Classless
  Inter-domain Routing (CIDR)" (<https://www.rfc-editor.org/rfc/rfc4632>); RFC 826 "An Ethernet Address Resolution
  Protocol" (<https://www.rfc-editor.org/rfc/rfc826>); RFC 1918 (<https://www.rfc-editor.org/rfc/rfc1918>, private
  ranges); RFC 5737 (<https://www.rfc-editor.org/rfc/rfc5737>, documentation ranges); `man 7 ip`, `man 7 arp`,
  `man 3 inet_pton`, `man 8 ip-address`, `man 8 ip-neighbour` (man-pages 6.7 and iproute2 6.1.0 on the host).
- **Done when:** the exercise passes its gates, and Sam computes a block's range by hand before running the program.

## 02 — Routing tables and the default gateway

- **Objective:** Sam can read a routing table, predict which route a destination uses, and explain the default
  gateway.
- **Builds on:** lesson 01.
- **Key ideas:**
  - Forwarding picks the most specific matching route — longest match — so a /24 beats a /16 beats the default route
    (0.0.0.0/0).
  - The default gateway is the next hop for everything no other route covers; without one, anything off-link is
    unreachable.
  - `ip route` shows the table; `ip route get <address>` shows the route the kernel would choose.
  - A network namespace has its own routing table — the property lesson 05's lab relies on.
- **Recall targets:** which route wins for a given destination and why; what happens with no default route.
- **Build:** extend the CIDR exercise with longest-prefix match over a small routing table read from a file. Checked by
  `make test` (ties, the default route and no match), `san` and `memcheck`, and by comparing its answers with
  `ip route get` inside a lab namespace (lesson 05).
- **Sources:** RFC 4632, Section 5.1 "Rules for Route Advertisement" (longest-match forwarding,
  <https://www.rfc-editor.org/rfc/rfc4632>); `man 8 ip-route` (iproute2 6.1.0: `ip route show`, `ip route get`);
  `man 7 network_namespaces`.
- **Done when:** the exercise passes its gates and agrees with `ip route get` on every destination Sam tries.

## 03 — DNS and DHCP from the client's side

- **Objective:** Sam can trace how a program turns a name into an address on this host, and describe the DHCP
  exchange that gives a client its address, gateway and DNS server.
- **Builds on:** lessons 01–02; P2 sockets (`getaddrinfo`).
- **Key ideas:**
  - `getaddrinfo(3)` consults `nsswitch.conf(5)` for the order of sources (files, DNS and others); `resolv.conf(5)`
    names the DNS servers — on this host a local systemd-resolved stub (`resolvectl`).
  - DNS is a distributed, hierarchical database queried over UDP and TCP port 53; a resolver follows referrals or asks
    a recursive server.
  - DHCP gives a client its configuration in four messages: DISCOVER, OFFER, REQUEST, ACK.
  - Both protocols are traffic lesson 07 will capture in the lab, and the router edition will later serve.
- **Recall targets:** the path from `getaddrinfo` to a DNS query on this host; the four DHCP messages in order and
  what each carries.
- **Build:** none — the exchanges are captured in lesson 07's lab.
- **Security lens:** plain DNS and DHCP are unauthenticated — anyone on the link can answer first, which is why the lab
  is isolated and why the router edition's DHCP and DNS servers matter.
- **Sources:** `man 3 getaddrinfo`, `man 5 nsswitch.conf`, `man 5 resolv.conf`, `man 1 resolvectl` (host); RFC 1034
  and RFC 1035 (<https://www.rfc-editor.org/rfc/rfc1034>, <https://www.rfc-editor.org/rfc/rfc1035>, port 53); RFC 2131
  "Dynamic Host Configuration Protocol" (<https://www.rfc-editor.org/rfc/rfc2131>).
- **Done when:** Sam traces a lookup on the host from program to resolver and names the DHCP messages with their
  contents unaided.

## 04 — IPv6 essentials: link-local, SLAAC, Neighbour Discovery

- **Objective:** Sam can read an interface's IPv6 addresses, explain where each came from, and say what Neighbour
  Discovery does in place of ARP.
- **Builds on:** lessons 01–03.
- **Key ideas:**
  - Every IPv6 interface has a link-local address in `fe80::/10`, usable only on its own link.
  - Stateless address autoconfiguration (SLAAC) lets a host form its own global addresses from router
    advertisements.
  - Neighbor Discovery (RFC 4861) combines what IPv4 does with ARP, ICMP router discovery and ICMP redirects, using
    router and neighbour solicitations and advertisements.
  - `2001:db8::/32` is reserved for documentation; unique local addresses (`fc00::/7`) are IPv6's private range.
- **Recall targets:** where each address on an interface came from; the IPv4 mechanisms ND replaces; which prefixes
  are for documentation and for private use.
- **Build:** none — link-local addresses and ND traffic are observed in lessons 05 and 07.
- **Sources:** RFC 8200 "Internet Protocol, Version 6 (IPv6) Specification" (<https://www.rfc-editor.org/rfc/rfc8200>);
  RFC 4291, Section 2.5.6 "Link-Local IPv6 Unicast Addresses" (<https://www.rfc-editor.org/rfc/rfc4291>); RFC 4862
  "IPv6 Stateless Address Autoconfiguration" (<https://www.rfc-editor.org/rfc/rfc4862>); RFC 4861 "Neighbor Discovery
  for IP version 6", Section 3.1 "Comparison with IPv4" (<https://www.rfc-editor.org/rfc/rfc4861>); RFC 3849
  (<https://www.rfc-editor.org/rfc/rfc3849>); RFC 4193 (<https://www.rfc-editor.org/rfc/rfc4193>); `man 7 ipv6`.
- **Done when:** Sam explains the origin of every IPv6 address on a lab interface and predicts the ND messages a
  first ping will cause.

## 05 — An isolated lab: namespaces, veth, a bridge and QEMU guests

- **Objective:** Sam can build a virtual network inside a network namespace — veth pairs, a bridge and QEMU guests on
  a tap — and prove it has no route to the home network.
- **Builds on:** lessons 01–04; os-02 lesson 05 (QEMU launches); sec-04 lesson 03 (namespaces) when reached.
- **Key ideas:**
  - A network namespace has its own interfaces, routes and firewall; a new one starts with only a loopback and an
    empty routing table.
  - A veth pair is a virtual cable between two interfaces, often in two namespaces; a bridge is a virtual switch.
  - On this host `unshare --user --map-root-user --net` gives an unprivileged user a namespace in which veth pairs, a
    bridge and a tap can be created, and QEMU can attach a guest to that tap (checked 27/09/2026). `ip netns add`
    needs real root, which the lab avoids.
  - QEMU's default network is user mode, which gives the guest a path out through the host unless `restrict=on` is
    set; lab guests use `-netdev tap` inside the namespace, or `-nic none`.
  - The proof: inside the namespace there is no default route, and a connection to a home-network address fails with
    "Network is unreachable".
- **Recall targets:** what each lab component does; why a guest on QEMU's default network is not isolated; the two
  checks that prove isolation.
- **Build:** a lab script in `code/src/os/msNNN-netns-lab/` (planned — added at P6) that creates the namespace, a
  bridge, two veth-connected endpoints and a tap for a QEMU guest, runs its own isolation self-test, and cleans up with
  `trap`; the planned `how-to/workflows/11-isolated-network-lab/` (planned — added at P6) will document its use.
  Checked by the self-test (no default route; a home-network address unreachable; the lab endpoints reach each other)
  and by ShellCheck in CI (`GAPS.md` → "ShellCheck not installed locally").
- **Security lens:** the lab is where later lessons run deliberately unsafe services and, in the security track,
  attack tools — its isolation is the control that makes that acceptable.
- **Safety:** never add a physical interface to the lab bridge, never give a lab guest QEMU's default (unrestricted)
  user-mode network (`restrict=on` is acceptable), and never change the host's own namespace; Claude never runs
  `sudo`. This is the lesson every later "isolated network" Safety line points to.
- **Sources:** `man 7 network_namespaces`, `man 7 user_namespaces`, `man 1 unshare` (`--net`, `--map-root-user`),
  `man 4 veth`, `man 8 ip-link`, `man 8 bridge`, `man 8 ip-netns` (man-pages 6.7, util-linux 2.39.3 and iproute2
  6.1.0 on the host); QEMU "Network emulation", "Using TAP network interfaces" and "Using the user mode network stack"
  (<https://www.qemu.org/docs/master/system/devices/net.html>) and the `-netdev user` `restrict=on` option
  (<https://www.qemu.org/docs/master/system/invocation.html>).
- **Done when:** the self-test passes, and Sam demonstrates the unreachable home network from inside the lab without
  notes.

## 06 — nftables fundamentals: a stateful host firewall

- **Objective:** Sam can write an nftables ruleset — a table, chains on the right hooks, a drop policy and connection
  tracking — that protects a host, check it before loading, and test it from another machine in the lab.
- **Builds on:** lesson 05 (the lab to test in).
- **Key ideas:**
  - nftables organises rules in tables of chains; a base chain attaches to a netfilter hook — prerouting, input,
    forward, output, postrouting — with a priority and a policy.
  - A host firewall is an input chain with `policy drop`, accepting loopback and `ct state established,related`, then
    only the services the host offers.
  - Forwarded traffic passes prerouting, forward and postrouting — the router edition's concern, not a host's.
  - `nft -c -f` checks a ruleset without applying it; inside the lab namespace a ruleset can be loaded without root
    (checked 27/09/2026).
- **Recall targets:** the five hooks and which traffic passes each; why established and related traffic is accepted
  first; what `policy drop` means for anything not listed.
- **Build:** a host-firewall ruleset in `code/src/os/msNNN-host-firewall/` (planned — added at P6), loaded into one lab
  endpoint. Checked by `nft -c -f` and by connection tests from the other endpoint: the allowed port connects, every
  other port times out, and replies to the host's own outbound connections still arrive.
- **Security lens:** default-deny on input is the baseline; every open port is a decision recorded in the ruleset.
- **Sources:** `man 8 nft` (nftables 1.0.9 on the host); nftables wiki "Netfilter hooks"
  (<https://wiki.nftables.org/wiki-nftables/index.php/Netfilter_hooks>), "Simple ruleset for a workstation"
  (<https://wiki.nftables.org/wiki-nftables/index.php/Simple_ruleset_for_a_workstation>) and "Matching connection
  tracking stateful metainformation"
  (<https://wiki.nftables.org/wiki-nftables/index.php/Matching_connection_tracking_stateful_metainformation>).
- **Done when:** the ruleset passes `nft -c` and the connection tests, and Sam explains every rule's purpose.

## 07 — Observing traffic with `ss` and `tcpdump`

- **Objective:** Sam can list a machine's listening and connected sockets with `ss`, capture traffic with `tcpdump`
  using filters, and read ARP, Neighbour Discovery, DHCP and DNS exchanges from a capture.
- **Builds on:** lessons 01–06.
- **Key ideas:**
  - `ss -tulpn` lists TCP and UDP listening sockets with their processes — the first check of a host's attack
    surface.
  - `tcpdump` captures on one interface with a filter expression and can write the capture to a file for later
    reading.
  - Inside a user namespace, `tcpdump` must be told not to drop privileges to its own user (`-Z root`), because that
    user does not exist there (checked 27/09/2026).
  - The protocols from lessons 01–04 appear exactly as their RFCs describe: ARP requests and replies, Neighbour
    Solicitations, the four DHCP messages, DNS queries on port 53.
  - The lab has no route out and no servers of its own, so a DHCP or DNS capture needs a lab-only server: dnsmasq
    (dnsmasq-base 2.91 is on the host) run inside the namespace with `--no-daemon`, `--bind-interfaces`,
    `--interface=<bridge>`, a `--dhcp-range=`, `--no-resolv` (else it reads the host's `/etc/resolv.conf`) and an
    `--address=/lab/…` answer, or BusyBox `udhcpd`. Serving DHCP and DNS as a service stays os-14's.
- **Recall targets:** what `ss -tulpn` shows and why it matters; a filter for DNS only; the DHCP exchange as it appears
  in a capture.
- **Build:** none in code — captures of ARP, ND, DHCP and DNS in the lab, with the lab-only dnsmasq bound to the lab
  bridge answering the DHCP and DNS requests, read and annotated in the note. Capture files stay outside the
  repository.
- **Security lens:** captures can hold credentials and personal data — capture only lab traffic, keep files out of
  git, and delete them after the lesson.
- **Safety:** captures and the lab-only DHCP and DNS server run inside the lab namespace only, never on the host's
  real interfaces.
- **Sources:** `man 8 ss` (iproute2 6.1.0: `-t`, `-u`, `-l`, `-p`, `-n`); `man 8 tcpdump` (tcpdump 4.99.4 on the host:
  `-Z`, `-w`, `-r`, filter expressions) and the tcpdump project's page
  (<https://www.tcpdump.org/manpages/tcpdump.1.html>); `man 8 dnsmasq` (dnsmasq 2.91 on the host: `--no-daemon`,
  `--bind-interfaces`, `--interface`, `--dhcp-range`, `--no-resolv`, `--address`);
  RFC 826, RFC 4861, RFC 2131 and RFC 1035 as in lessons 01–04.
- **Done when:** Sam reads each captured exchange message by message and matches it to its RFC.
