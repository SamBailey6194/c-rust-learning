# Syllabus — sec-18-antivirus-and-detection-engineering

**Track**: sec · **Phase**: S3 · **Path**: Later · **Detail**: outline · **Prerequisites**: sec-17 (malware concepts), sec-03 (fuzzing, corpora), ui-02 and ui-03 (ratatui), os-11 (server) and os-13 (NAS)
**Status**: Planned · **Checked**: 27/09/2026 (sources re-verified by `/teach` step 3 before each lesson)

This topic is defensive only. It builds the detection Sam wants inside Syntek OS: how antivirus and EDR work and where they fail, ClamAV's architecture and signatures, writing YARA rules, file-integrity monitoring with AIDE, and a scanner service with a ratatui front-end for the NAS and server profiles. Every detection is tested against the EICAR anti-malware test file and synthetic, harmless artefacts only — no live malware is written, stored in the repository, run on the host or placed in CI. Live-sample analysis is deferred to a dedicated air-gapped environment (`DEFERRED.md`). It is an **outline** topic because S3 is a far phase: its builds are sketched and its sources, checked on 27/09/2026, are re-verified when the topic opens.

| # | Lesson | Size | Build | Lenses |
| --- | --- | --- | --- | --- |
| 01 | How antivirus and EDR work, and their limits | 1 sitting | no | — |
| 02 | ClamAV architecture and signatures | 2–3 sittings | yes — clamav-sig | Safety |
| 03 | Writing YARA rules | 2–3 sittings | yes — yara-rules | Safety |
| 04 | File-integrity monitoring with AIDE | 2–3 sittings | yes — aide-fim | Safety |
| 05 | A scanner service for the NAS and server profiles | multi-session build | yes — scanner-service | Efficiency, Safety |

---

## 01 — How antivirus and EDR work, and their limits

- **Objective:** Sam can explain the detection approaches antivirus and EDR use and where each fails.
- **Builds on:** sec-17's families and detection surface.
- **Key ideas:**
  - Signatures match known-bad bytes; heuristics generalise; behavioural/runtime detection watches what a program does; sandboxing observes it in isolation.
  - Each approach has a failure mode: signatures miss novel samples, heuristics and behaviour raise false positives.
  - False negatives and false positives are the two costs to balance, per deployment.
  - Detection is a layer, not a guarantee — which is why integrity monitoring (sec-19) sits alongside it.
- **Recall targets:** the four detection approaches and each one's failure mode; why signatures alone are insufficient.
- **Build:** none (a comparison note of the approaches and their limits).
- **Sources:** (checked 27/09/2026; re-verify when S3 opens) ClamAV project (<https://github.com/Cisco-Talos/clamav>); MITRE ATT&CK for the behaviours being detected (<https://attack.mitre.org/>).
- **Done when:** Sam can match a detection approach to what it catches and what it misses.

---

## 02 — ClamAV architecture and signatures

- **Objective:** Sam can write a ClamAV signature that matches a synthetic test file and confirm detection with `clamscan`.
- **Builds on:** lesson 01; sec-11's ELF and file-format reading (for body-based signatures).
- **Key ideas:**
  - ClamAV's engine is `libclamav`; `clamscan` scans and `freshclam` updates the database.
  - Signature formats: hash-based, body-based (byte patterns) and logical signatures that combine conditions.
  - Detection is tested against the EICAR test file and synthetic artefacts — never a live sample.
  - A signature that is too broad causes false positives; scope it to the intended artefact.
- **Recall targets:** the ClamAV components and their jobs; the signature families and when to use each.
- **Build:** write a hash-based and a body-based signature for a synthetic test file and confirm detection with `clamscan`. Planned code path: signatures and a note in this topic folder; the deployed database lands in the Syntek OS build-system repository (created when that build starts).
- **Safety:** EICAR and synthetic files only; no live malware in the repository, on the host or in CI (`DEFERRED.md`). The EICAR file is generated at test time into a temporary directory (or fetched from eicar.org into the VM) and never committed; the repository holds only signatures, rules and hashes that refer to it.
- **Sources:** (checked 27/09/2026; re-verify when S3 opens) ClamAV project (<https://github.com/Cisco-Talos/clamav>); ClamAV signature documentation (<https://raw.githubusercontent.com/Cisco-Talos/clamav-documentation/main/src/manual/Signatures.md>; the rendered docs at docs.clamav.net return 403 to automated fetch on 27/09/2026); EICAR test file (<https://www.eicar.org/download-anti-malware-testfile/>).
- **Done when:** `clamscan` detects the synthetic file with Sam's signature and does not fire on an unrelated file.

---

## 03 — Writing YARA rules

- **Objective:** Sam can write a YARA rule that matches a synthetic artefact without matching unrelated files.
- **Builds on:** lesson 02's pattern matching; sec-11's ELF/PE structure knowledge.
- **Key ideas:**
  - A YARA rule has three parts: `meta`, `strings` and `condition`.
  - String types (text, hex, regex) and modifiers; the `condition` combines them with logic and counts.
  - The `pe` and `elf` modules match on file-format fields, not just byte strings.
  - Overbroad rules cause false positives; a good rule is specific and documented in `meta`.
  - YARA (C) is in maintenance mode; YARA-X (Rust, BSD-3-Clause, rule-compatible for most rules) is its successor and the natural engine for lesson 05's Rust service — though its dependency tree includes wasmtime (Apache-2.0 WITH LLVM-exception), so `cargo deny` is run before it enters any repository.
- **Recall targets:** the three parts of a YARA rule; why the `condition` and specificity matter.
- **Build:** a small YARA ruleset matching synthetic test artefacts, run with `yara`, with a false-positive check against unrelated files. Planned: rules and a note in this topic folder; deployed rules land in the Syntek OS build-system repository (created when that build starts).
- **Safety:** EICAR and synthetic artefacts only; no live samples. The EICAR file is generated at test time into a temporary directory (or fetched from eicar.org into the VM) and never committed; the repository holds only signatures, rules and hashes that refer to it.
- **Sources:** (checked 27/09/2026; re-verify when S3 opens) YARA writing rules (<https://yara.readthedocs.io/en/stable/writingrules.html>); YARA modules (<https://yara.readthedocs.io/en/stable/modules.html>); the YARA README's maintenance-mode notice (<https://github.com/VirusTotal/yara>); YARA-X documentation (<https://virustotal.github.io/yara-x/>) — pin the version at lesson open (yara-x 1.20.0 on crates.io, 27/09/2026); EICAR (<https://www.eicar.org/download-anti-malware-testfile/>).
- **Done when:** the ruleset matches the synthetic artefacts and stays quiet on unrelated files.

---

## 04 — File-integrity monitoring with AIDE

- **Objective:** Sam can baseline a system with AIDE and detect an unauthorised change.
- **Builds on:** lesson 01 (integrity as a detection layer); sec-13's hardened images.
- **Key ideas:**
  - AIDE builds a baseline database of file hashes and attributes, then reports differences on a later check.
  - Legitimate change (updates, logs) must be accommodated, or the report drowns in noise.
  - FIM catches what signatures miss: an unknown change to a known file.
  - It complements kernel-enforced integrity (IMA/EVM, sec-19) rather than replacing it.
- **Recall targets:** what AIDE baselines and what it reports; why tuning for legitimate change matters.
- **Build:** configure AIDE on a server-profile VM, baseline it, make a change, and detect it. Planned: configuration and a note in this topic folder; the deployed policy lands in the Syntek OS build-system repository (created when that build starts).
- **Safety:** VM only; no host filesystem is baselined by these exercises.
- **Sources:** (checked 27/09/2026; re-verify when S3 opens) AIDE (<https://aide.github.io/>); confirm the current version and config syntax with `aide --help` at lesson open.
- **Done when:** AIDE reports the change Sam made and stays quiet on an untouched baseline.

---

## 05 — A scanner service for the NAS and server profiles

- **Objective:** Sam can design a scheduled scanner service with a ratatui front-end that scans shares, quarantines detections and reports, within a resource budget.
- **Builds on:** lessons 02–04; ui-02 and ui-03's ratatui and testing; os-13's NAS shares and os-11's server.
- **Key ideas:**
  - A scheduled scanner scans shares on a timer, quarantines detections and produces a report.
  - Resource limits keep scans from starving the box — a scan is a background job under a budget.
  - The ratatui front-end shows status, findings and quarantine, keyboard-first and accessible (ui-03).
  - Quarantine and reporting are the actionable output; detection alone is not enough.
- **Recall targets:** the parts of a scanner service; why a scan must run under a resource budget.
- **Build:** a scanner-service prototype (scan, quarantine, report) with a ratatui front-end. Where it lands: the Syntek OS system-tools repository (created when that build starts); a lesson-scale prototype may start under `code/src/rust/crates/` (planned). Tested against EICAR and synthetic files only.
- **Efficiency lens:** measure scan CPU time, RAM and I/O against a stated budget (the measurement method from llm-06 lesson 01); a background scan must not starve the host.
- **Safety:** EICAR and synthetic files only; no live malware in the repository, on the host or in CI (`DEFERRED.md`). The EICAR file is generated at test time into a temporary directory (or fetched from eicar.org into the VM) and never committed; the repository holds only signatures, rules and hashes that refer to it.
- **Sources:** (checked 27/09/2026; re-verify when S3 opens) ClamAV project (<https://github.com/Cisco-Talos/clamav>); YARA (<https://yara.readthedocs.io/en/stable/writingrules.html>); YARA-X (<https://virustotal.github.io/yara-x/>, pin the version at lesson open); ratatui docs via Context7 (`/ratatui/ratatui`); EICAR (<https://www.eicar.org/download-anti-malware-testfile/>).
- **Done when:** the prototype scans a synthetic corpus, quarantines a detection, reports it, and stays within its measured resource budget.
