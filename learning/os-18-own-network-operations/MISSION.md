# Mission — os-18-own-network-operations

**Started**: not yet · **Family**: os · **Phase**: P6 · **Milestone**: not yet allocated

## Why

_Drafted from Sam's decisions of 27/09/2026 in the networking and licensing round — confirm or
rewrite in your own words at the first lesson._

The router, homelab and server topics build their pieces in an isolated lab and stop there. In the
networking and licensing round Sam decided that his own connectivity should run on those pieces:
a router beside the ISP's, a homelab that takes its names and addresses from it, WireGuard for his
roaming devices, services on his own private CA, monitoring of his own machines, backups he has
drilled, and help for family members when they ask for it. He also decided how: lab first, then a
graduation path to named devices he owns, with a rehearsed rollback, no offensive tooling on the
real LAN, metrics only, configuration defences and recovery drills rather than flood tests, and the
real values kept in a private repository. This topic is where those decisions are practised, one
join at a time, without re-teaching the protocols underneath.

## Can do it when

- Sam can state the graduation conditions, name his devices by role label, and sort artefacts into
  public, private or neither unaided.
- Sam's lab proves a non-overlapping addressing plan behind a stand-in ISP router, with exactly one
  DHCP server answering after the hand-over.
- Sam's lab homelab holds its reserved lease, resolves `home.arpa.` names, refuses rebinding, and
  serves neither DNS nor DHCP.
- Sam's lab peers reach only the management network over WireGuard, over IPv4 and IPv6, and resolve
  local names through the tunnel.
- Sam can revoke a lost device's WireGuard key within minutes and rotate a key with a measured gap.
- Sam's services present short-lived leaves from his private CA, a client without the root is
  refused, and an expiring leaf is caught.
- Sam's lab Prometheus scrapes only his own machines over the tunnel, with rules that fire and a
  stated retention.
- Sam's lab router keeps SYN cookies and per-source limits engaged, fails closed, and keeps the LAN
  working through a WAN outage.
- Sam can rebuild the router from configuration and an encrypted backup in a recorded time, and
  recover from a lost WireGuard key and a lost intermediate.
- Sam can run a consent-first help session over SSH and tmux in the lab that expires, detaches on
  demand and leaves nothing behind, and then a real one with a consent record.

## Parked for later

- Building a consent-first remote-help tool in Rust — a later ui topic.
- Packet capture, flow logs or intrusion detection on Sam's real LAN — not planned;
  `sec-16-detection-response-and-disclosure`'s intrusion detection stays in the lab.
- Flood and load testing of the router's resilience limits — `DEFERRED.md` (S3).
- Alertmanager, for routing and silencing alerts — not in this topic; lesson 07 stops at rules that
  fire.
- Designing the private CA — `sec-05-applied-cryptography` lessons 08–13.
- Choosing the router's DNS and DHCP design — `os-14-router-edition` lesson 03's ADR draft.
- Choosing router hardware — `os-14-router-edition` lesson 08.
