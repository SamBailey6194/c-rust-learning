# Mission — sec-07-recon-and-network-security

**Started**: not yet · **Family**: sec · **Phase**: S2 · **Milestone**: not yet allocated

## Why

_Drafted from Sam's planning conversation of 27/09/2026 — confirm or rewrite in your own words at
the first lesson._

Sam is building a server, a NAS and a router — systems that live on a network and must not expose
more than they mean to. Seeing a network the way an attacker does, then closing what it reveals, is
how a defender knows their attack surface is really as small as they think. This topic teaches
discovery, packet analysis and misconfiguration-spotting inside the isolated lab, always ending in
the fix, so the recon skill exists to drive the hardening of the Syntek OS server and router
editions. Every exercise runs on Sam's own lab targets, in scope, never on the home network.

## Can do it when

- Sam can discover hosts and services on his lab network and read the results as an attack-surface
  list.
- Sam can enumerate a service and its version and map it to patch status.
- Sam can capture and analyse lab traffic, distinguishing encrypted from plaintext.
- Sam can recognise a common misconfiguration and apply its fix.

## Parked for later

- Building the lab itself — `sec-06` (a prerequisite).
- Web-application testing — `sec-08`.
- Applying this to the real Syntek OS images — a later S3 topic.
