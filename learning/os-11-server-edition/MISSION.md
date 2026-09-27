# Mission — os-11-server-edition

**Started**: not yet · **Family**: os · **Phase**: P6 · **Milestone**: not yet allocated

## Why

_Drafted from Sam's planning conversation of 27/09/2026 — confirm or rewrite in your own words at
the first lesson._

Sam's list of Syntek OS versions includes a server edition (the "business server" profile), and the
planning conversation recommended starting lean and shipping a server and homelab edition first
(recorded as "recommended, to confirm"): it needs no GUI, and it is where the independent base, the
signed repository and the installer first have to work together on a real job. A server is also
where security stops being theory — Sam asked for security lessons as well as building — so every
lesson here is one defence taken from the edition's own threat model: accounts, SSH, the firewall,
updates, and backups that are proven by a restore.

## Can do it when

- Sam can state the server profile's scope, threat model and resource budget, and they are written
  in the server profile spec.
- Sam can set up service and admin accounts and a sudo policy that grants named commands, and the
  in-guest check script passes.
- Sam can configure sshd for key-only admin access and prove the effective configuration with
  `sshd -T` and a login test.
- Sam can write and load a default-deny nftables ruleset and prove from the isolated lab that only
  the intended ports answer.
- Sam's unattended update job applies a valid signed update and refuses a tampered package and
  replayed metadata.
- Sam can back up a server, restore it into a fresh VM, and report the restore time against the
  budget.

## Parked for later

- Choosing real server hardware — an ADR when that decision is due (`GAPS.md`).
- Hardening baselines and lynis audits of each profile image — `sec-13-hardening-and-secure-boot`.
- Penetration-testing the server image — `sec-14` (testing Syntek OS).
- Intrusion detection and incident response — `sec-16-detection-response-and-disclosure`.
- Containers, VMs and monitoring — `os-12-homelab-edition`.
