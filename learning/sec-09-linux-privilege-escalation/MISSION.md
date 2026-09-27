# Mission — sec-09-linux-privilege-escalation

**Started**: not yet · **Family**: sec · **Phase**: S2 · **Milestone**: not yet allocated

## Why

_Drafted from Sam's planning conversation of 27/09/2026 — confirm or rewrite in your own words at
the first lesson._

Sam is shipping a server and a router edition — hosts that must not let an ordinary user become root
through a careless setuid binary, an over-broad sudo rule or a writable cron script. Having learned
in `sec-04` how the Linux security model is meant to work, this topic teaches how it is commonly got
wrong and, for each mistake, the configuration that closes it. The goal is defensive: Syntek OS
profiles that ship without these weaknesses. Every exercise runs on deliberately misconfigured lab
VMs, in scope, never on a system Sam does not own, and always ends in the fix rather than a weapon.

## Can do it when

- Sam can enumerate a lab host and turn the findings into a hardening checklist.
- Sam can recognise and fix a dangerous setuid binary or sudo rule.
- Sam can recognise and fix unsafe cron jobs and PATH handling.
- Sam can reduce an over-granted capability and secure a writable service.

## Parked for later

- The Linux security model itself — `sec-04` (a prerequisite).
- Binary exploitation of a vulnerable program — `sec-10`, own binaries and legal platforms only.
- Applying the fixes to the real Syntek OS images — os-11 and a later S3 topic.
