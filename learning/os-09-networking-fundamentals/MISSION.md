# Mission — os-09-networking-fundamentals

**Started**: not yet · **Family**: os · **Phase**: P6 · **Milestone**: not yet allocated

## Why

_Drafted from Sam's planning conversation of 27/09/2026 — confirm or rewrite in your own words at the first lesson._

Sam's list of Syntek OS versions ends with "server, NAS, homelab, router" — every one of them a networked machine,
and the router nothing but networking. Before building any of them, Sam needs the fundamentals from the client's side:
how addresses, routes, DNS, DHCP and IPv6 actually work, how a stateful firewall protects a host, and how to watch the
traffic to check. Just as important, he needs somewhere safe to practise: an isolated virtual network that provably
cannot reach his home network, which the router edition and the security track's lab will both build on.

## Can do it when

- Sam can compute CIDR ranges by hand and his `cidr-calc` exercise passes `make test`, `make san` and `make memcheck`.
- Sam can predict which route a destination takes, and his longest-prefix match agrees with `ip route get`.
- Sam can trace a name lookup on the host and describe the DHCP exchange message by message.
- Sam can explain where each IPv6 address on an interface came from and what Neighbour Discovery replaces.
- Sam's lab script builds an isolated network with QEMU guests and its self-test proves the home network unreachable.
- Sam's host firewall passes `nft -c` and the lab connection tests.
- Sam can read ARP, ND, DHCP and DNS exchanges from a lab capture and match them to their RFCs.

## Parked for later

- Forwarding, NAT, VLANs, DHCP and DNS servers, WireGuard — os-14-router-edition.
- The server edition's host firewall and SSH hardening — os-11-server-edition.
- Scanning and attacking lab targets — sec-06-pentest-lab-setup and sec-07-recon-and-network-security.
- Sharing files over the network (NFS, SMB) — os-13-nas-edition.
- Network screens in the system tools — ui-07-system-tools-tui.
