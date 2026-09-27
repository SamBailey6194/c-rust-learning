# Resources — os-09-networking-fundamentals

| Lesson | Primary source (pinned) | House guide | Code |
| --- | --- | --- | --- |
| 01 Layers, IPv4 addressing and CIDR, MAC and ARP | RFC 791, <https://www.rfc-editor.org/rfc/rfc791>; RFC 4632, <https://www.rfc-editor.org/rfc/rfc4632>; RFC 826, <https://www.rfc-editor.org/rfc/rfc826>; `man 7 ip`, `man 7 arp`, `man 3 inet_pton` (man-pages 6.7) | `code/docs/C-CODING-PRINCIPLES.md`; `code/docs/TESTING.md` — Section 1 | `code/src/c/msNNN-cidr-calc/` (planned) |
| 02 Routing tables and the default gateway | RFC 4632, Section 5.1, <https://www.rfc-editor.org/rfc/rfc4632>; `man 8 ip-route` (iproute2 6.1.0) | `code/docs/MEMORY-SAFETY.md` | `code/src/c/msNNN-cidr-calc/` (planned) |
| 03 DNS and DHCP from the client's side | `man 3 getaddrinfo`, `man 5 nsswitch.conf`, `man 5 resolv.conf`; RFC 1035, <https://www.rfc-editor.org/rfc/rfc1035>; RFC 2131, <https://www.rfc-editor.org/rfc/rfc2131> | — | — |
| 04 IPv6 essentials | RFC 4291, Section 2.5.6, <https://www.rfc-editor.org/rfc/rfc4291>; RFC 4862, <https://www.rfc-editor.org/rfc/rfc4862>; RFC 4861, Section 3.1, <https://www.rfc-editor.org/rfc/rfc4861> | — | — |
| 05 An isolated lab | `man 7 network_namespaces`, `man 1 unshare`, `man 4 veth`, `man 8 bridge` (host); QEMU "Network emulation", <https://www.qemu.org/docs/master/system/devices/net.html> | `project-management/docs/SAFETY-GUIDE.md` | `code/src/os/msNNN-netns-lab/` (planned — added at P6) |
| 06 nftables fundamentals | `man 8 nft` (nftables 1.0.9); nftables wiki "Simple ruleset for a workstation", <https://wiki.nftables.org/wiki-nftables/index.php/Simple_ruleset_for_a_workstation> | — | `code/src/os/msNNN-host-firewall/` (planned — added at P6) |
| 07 Observing traffic with `ss` and `tcpdump` | `man 8 ss` (iproute2 6.1.0), `man 8 tcpdump` (tcpdump 4.99.4); <https://www.tcpdump.org/manpages/tcpdump.1.html>; `man 8 dnsmasq` (2.91, the lab-only DHCP and DNS server) | — | — |
