# Mission — os-08-repositories-signing-and-updates

**Started**: not yet · **Family**: os · **Phase**: P6 · **Milestone**: not yet allocated

## Why

_Drafted from Sam's planning conversation of 27/09/2026 — confirm or rewrite in your own words at the first lesson._

Syntek OS is meant to run on servers, NAS boxes, homelabs and routers — the router edition being, in the planning
conversation's words, a real security responsibility — and every one of them will trust whatever its update client
accepts. An independent distribution cannot lean on anyone else's repository or keys; it has to publish its own,
sign them, and give its machines a way to tell a fresh, genuine update from a stale or forged one. This topic builds
that trust chain end to end, and its secure update flow is the one every later Syntek OS tool reuses.

## Can do it when

- Sam can say what a repository index carries and what a malicious mirror can still do.
- Sam's verifier checks a minisign signature over an index and rejects tampered data and wrong keys, and the crate
  passes the licence gate.
- Sam can explain each attack TUF defends against and how its roles divide the work, and has written the Syntek OS package
  repository's threat model.
- Sam's verifier accepts a rotated key only through a correctly signed, correctly versioned statement, and the
  PACKAGE-SIGNING-SCHEME research note holds his key plan and compromise drill.
- Sam's update client refuses expired, rolled-back, mixed, tampered and oversized updates and applies a clean one.
- Sam's build farm signs and publishes to a test mirror in an order clients can never catch half-done.

## Parked for later

- Choosing the signing scheme for Syntek OS — an ADR fed by the PACKAGE-SIGNING-SCHEME research note.
- Unattended security updates on the server edition — os-11-server-edition.
- The update screen in the system tools — ui-07-system-tools-tui.
- Attacking the repository (rollback, freeze) as test cases — sec-14 (testing Syntek OS).
- A model file as a signed, large package — os-17-local-model-integration.
