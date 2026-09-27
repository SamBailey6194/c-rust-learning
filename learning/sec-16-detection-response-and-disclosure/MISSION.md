# Mission — sec-16-detection-response-and-disclosure

**Started**: not yet · **Family**: sec · **Phase**: S3 · **Milestone**: not yet allocated

## Why

Sam is building systems other people may run — a server and homelab edition, and a router edition which the planning
conversation flagged as a real security responsibility. Responsibility does not end at prevention: it includes
noticing when something goes wrong, responding without making it worse, and handling reports of weaknesses in his
own public repository honestly. This topic gives Sam the detection, response and disclosure half of running a secure
system, all rehearsed in the isolated lab and applied to his own public project.

_Drafted from Sam's planning conversation of 27/09/2026 — confirm or rewrite in your own words at the first lesson._

## Can do it when

- Sam can write auditd rules for a Syntek OS host and confirm the events they produce.
- Sam can run Suricata in the lab, read its alerts and tune a false positive.
- Sam can write an incident runbook grounded in NIST SP 800-61r3.
- Sam can build a timeline from a lab VM's artefacts after a simulated compromise.
- Sam can write a vulnerability-disclosure policy and a `security.txt` for a web origin he runs, and run coordinated
  disclosure.

## Parked for later

- Kernel- and filesystem-level integrity and runtime monitoring — sec-19.
- Malware-specific detection (ClamAV, YARA) — sec-18.
