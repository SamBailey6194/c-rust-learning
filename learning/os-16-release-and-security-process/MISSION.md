# Mission — os-16-release-and-security-process

**Started**: not yet · **Family**: os · **Phase**: P6 · **Milestone**: not yet allocated

## Why

_Drafted from Sam's planning conversation of 27/09/2026 — confirm or rewrite in your own words at
the first lesson._

Owning every layer above the kernel includes owning its release and security process: the planning
conversation named "release + security process" as one of the layers an independent distribution
has to own, and warned that the real cost of a distribution is maintenance. Sam's aim is a Syntek OS
that stays secure after it ships, not only on the day it ships. This topic is how that happens —
tracking the vulnerabilities of everything the editions contain, publishing clear advisories,
numbering and supporting releases honestly, and writing documentation each edition's users can
follow.

## Can do it when

- Sam's advisory matcher reports affected packages per profile from OSV records, and ignores a
  backported fix.
- Sam can write and validate an OSV-format advisory and explain how a fix is coordinated.
- Sam has drafted the release-versioning ADR: the scheme, the channels and the reasons.
- Sam can set a support window traceable to each profile's kernel line and publish `SUPPORT_END`.
- A dry-run release of the server edition passes the checklist in the lab and fails when a gate is
  broken on purpose.
- The server edition has a documentation skeleton that a tester can follow unaided.

## Parked for later

- Contributor infrastructure (CONTRIBUTING, sign-off, labels, required checks) —
  `tooling-05-licensing-and-collaboration`.
- The vulnerability-disclosure policy and security contact — `sec-16-detection-response-and-disclosure`.
- Kernel-specific triage and the kernel release checklist — `kernel-06-kernel-ci-and-security`.
