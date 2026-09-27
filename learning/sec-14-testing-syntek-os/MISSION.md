# Mission — sec-14-testing-syntek-os

**Started**: not yet · **Family**: sec · **Phase**: S3 · **Milestone**: not yet allocated

## Why

Sam is building an independent distribution with its own package manager, repository and installer.
A distribution's repository and update path are its highest-value target: if they can be subverted,
every machine that trusts them is compromised. This topic attacks Sam's own Syntek OS in the lab —
its images, its parsers and its supply chain — so he finds the weaknesses first and turns each into
a test that stays green. It is the "prove it, do not assume it" counterpart to the hardening in
sec-13.

_Drafted from Sam's planning conversation of 27/09/2026 — confirm or rewrite in your own words at the first lesson._

## Can do it when

- Sam can run a scoped lab test against a profile image and confirm the hardening holds.
- Sam can build a fuzz harness for a Syntek OS parser and triage the crashes it finds.
- Sam can write test cases that prove the update client rejects malicious repository metadata.
- Sam can simulate a compromised mirror or tampered package in the lab and confirm the client refuses it.
- Sam can wire the durable adversarial tests into the build gates so a regression is caught.

## Parked for later

- The general release and security-tracking process across packages — os-16 owns that.
- Detecting and responding to a compromise that gets past these tests — sec-16 and sec-19.
