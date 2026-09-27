# Mission — sec-18-antivirus-and-detection-engineering

**Started**: not yet · **Family**: sec · **Phase**: S3 · **Milestone**: not yet allocated

## Why

Sam wants protection built into Syntek OS — a scanner for the NAS and server profiles that catches
threats on shared storage, with a TUI front-end in the same Rust-and-ratatui style as his other
tools. This topic is where that gets built and, first, understood: how antivirus and integrity
detection actually work and where they fail, how to write ClamAV signatures and YARA rules, how to
monitor file integrity with AIDE, and how to wrap it in a scheduled service that runs within a
resource budget. Every detection is proven against the EICAR test file and synthetic artefacts; no
live malware is ever handled.

_Drafted from Sam's planning conversation of 27/09/2026 — confirm or rewrite in your own words at the first lesson._

## Can do it when

- Sam can explain the detection approaches antivirus and EDR use and where each fails.
- Sam can write a ClamAV signature that matches a synthetic file and confirm it with `clamscan`.
- Sam can write a YARA rule that matches a synthetic artefact without false positives.
- Sam can baseline a system with AIDE and detect an unauthorised change.
- Sam can design a scanner service with a ratatui front-end that scans, quarantines and reports within a resource budget.

## Parked for later

- Kernel- and filesystem-level integrity (IMA/EVM, dm-verity) and eBPF runtime monitoring — sec-19.
- Analysing live malware samples — deferred to a dedicated air-gapped environment (`DEFERRED.md`).
