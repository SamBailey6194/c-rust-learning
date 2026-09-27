# Mission — os-14-router-edition

**Started**: not yet · **Family**: os · **Phase**: P6 · **Milestone**: not yet allocated

## Why

_Drafted from Sam's planning conversation of 27/09/2026 — confirm or rewrite in your own words at
the first lesson._

A router version is one of the Syntek OS editions Sam listed. The planning conversation put it
later on purpose and called it "real security responsibility": a router sits between every device
in the house and the internet, so a mistake in it is a mistake for everyone behind it. That is why
this topic builds the router one function at a time, proves each one in an isolated virtual lab,
keeps the kernel minimal, audits what it exposes, and leaves real hardware until an ADR has chosen
it and the lab tests pass.

## Can do it when

- Sam's lab router forwards and masquerades LAN traffic, refuses unsolicited inbound connections and
  drops spoofed sources.
- Sam can isolate a guest VLAN from the main LAN and prove it.
- Sam can serve DHCP and DNS on the LAN only, and has drafted the ADR choosing the design.
- Sam's router obtains a delegated IPv6 prefix, advertises a /64 to the LAN and keeps the LAN
  unreachable from upstream.
- Sam can give a remote peer WireGuard access limited by its key's allowed addresses.
- Sam's router kernel fragment merges strictly and passes every earlier test, with its size recorded.
- Sam's audit shows the router exposes exactly what its profile spec allows, from both sides.
- Sam has drafted the router hardware ADR with its criteria.

## Parked for later

- The router's web admin — `ui-10-web-admin-dashboard`.
- Penetration-testing the router image — `sec-14` (testing Syntek OS).
- Intrusion detection on the lab network — `sec-16-detection-response-and-disclosure`.
- Wi-Fi access-point support — decided with the hardware ADR, not assumed.
