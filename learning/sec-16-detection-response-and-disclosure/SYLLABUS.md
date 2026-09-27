# Syllabus — sec-16-detection-response-and-disclosure

**Track**: sec · **Phase**: S3 · **Path**: Later · **Detail**: outline · **Prerequisites**: sec-04 (auditd, LSMs), sec-06 and sec-07 (the isolated lab and its network), sec-01 (ethics and disclosure)
**Status**: Planned · **Checked**: 27/09/2026 (sources re-verified by `/teach` step 3 before each lesson)

Prevention fails sometimes; this topic is what happens then. It teaches Sam to log and audit a Syntek OS host, detect intrusions on the lab network, respond to an incident with a runbook, do basic forensics, and write a vulnerability-disclosure policy and `security.txt` for a Syntek OS web origin (this repository keeps `SECURITY.md`). It closes the loop from "we were attacked" back to "we fixed it and told people responsibly". Detection and forensics run on lab VMs and the isolated lab network; the disclosure lesson governs how vulnerabilities in Sam's own projects are reported and handled. It is an **outline** topic because S3 is a far phase: its builds are sketched and its sources, checked on 27/09/2026, are re-verified when the topic opens.

| # | Lesson | Size | Build | Lenses |
| --- | --- | --- | --- | --- |
| 01 | Logging and audit with auditd | 2–3 sittings | yes — auditd-rules | Safety |
| 02 | Network intrusion detection | 2–3 sittings | yes — suricata-lab | Safety |
| 03 | The incident-response process | 2–3 sittings | yes — ir-runbook | — |
| 04 | Basic Linux forensics | 2–3 sittings | yes — lab-timeline | Safety |
| 05 | Vulnerability disclosure | 2–3 sittings | yes — disclosure-policy | Security |

---

## 01 — Logging and audit with auditd

- **Objective:** Sam can write auditd rules for a Syntek OS host and confirm the events they produce.
- **Builds on:** sec-04's Linux security model (users, capabilities, syscalls); os-06's logging.
- **Key ideas:**
  - auditd records security-relevant events; rules are file watches and syscall rules.
  - `auditctl` loads rules; `ausearch` and `aureport` query the log.
  - Log the events that matter (authentication, privilege change, sensitive-file access) without drowning in noise.
  - Central, tamper-evident logging is what makes a later investigation possible.
- **Recall targets:** the difference between a file watch and a syscall rule; how to find an event with `ausearch`.
- **Build:** write auditd rules for a server-profile VM (watch a sensitive file, audit a syscall) and confirm the events with `ausearch`. Planned: rules and a note in this topic folder; the shipped policy lands in the Syntek OS build-system repository (created when that build starts).
- **Safety:** VM only; no host audit configuration is changed.
- **Sources:** (checked 27/09/2026; re-verify when S3 opens) `man 8 auditd` (<https://man7.org/linux/man-pages/man8/auditd.8.html>); `man 8 auditctl` (<https://man7.org/linux/man-pages/man8/auditctl.8.html>); `man 8 ausearch` (<https://man7.org/linux/man-pages/man8/ausearch.8.html>).
- **Done when:** Sam's rules produce the expected events and he can retrieve one with `ausearch`.

---

## 02 — Network intrusion detection

- **Objective:** Sam can run Suricata in the lab, read its alerts, and tune a false positive.
- **Builds on:** sec-07's packet capture and network analysis; os-09's isolated network lab.
- **Key ideas:**
  - An IDS inspects traffic and alerts on rule matches (signature-based) or anomalies.
  - Where the sensor sits in the isolated lab determines what it can see.
  - Rules and alerts: reading an alert, mapping it to the rule, and deciding whether it is real.
  - Tuning: a noisy rule that never fires true is worse than no rule.
- **Recall targets:** what an IDS alert tells you and what it does not; why sensor placement matters.
- **Build:** run Suricata against captured lab traffic (or a live isolated-lab segment), read the alerts, and tune one false positive. Planned: a lab exercise and note; lab-only tuning stays in the note, and configuration an edition ships lands in the Syntek OS build-system repository (created when that build starts).
- **Safety:** isolated lab network only (the os-09 namespace-and-veth lab, set up in sec-06); no monitoring of any real or third-party network.
- **Sources:** (checked 27/09/2026; re-verify when S3 opens) Suricata documentation (<https://docs.suricata.io/en/latest/>); Suricata rules introduction (<https://docs.suricata.io/en/latest/rules/intro.html>).
- **Done when:** Sam reads a Suricata alert, maps it to its rule, and tunes one false positive with a reason.

---

## 03 — The incident-response process

- **Objective:** Sam can write an incident runbook for a Syntek OS server grounded in a recognised process.
- **Builds on:** lessons 01–02 (the detections that trigger a response); sec-12's evidence handling.
- **Key ideas:**
  - NIST SP 800-61r3 frames incident response as functions within a cybersecurity-risk profile, not a rigid linear checklist.
  - The runbook covers detection, containment, eradication, recovery and a lessons-learned step.
  - Severity classification decides the response's urgency and who is involved.
  - A runbook written before an incident is worth more than a plan improvised during one.
- **Recall targets:** the phases a runbook must cover; why severity classification comes early.
- **Build:** write an incident runbook for a Syntek OS server, with a worked example for one detection from lessons 01–02. A Markdown note in this topic folder.
- **Sources:** (checked 27/09/2026; re-verify when S3 opens) NIST SP 800-61 Rev. 3, "Incident Response Recommendations and Considerations for Cybersecurity Risk Management" (<https://csrc.nist.gov/pubs/sp/800/61/r3/final>).
- **Done when:** the runbook covers detection through lessons-learned and works through one concrete detection.

---

## 04 — Basic Linux forensics

- **Objective:** Sam can build a timeline from a lab VM's artefacts after a simulated compromise.
- **Builds on:** lesson 01's logs; sec-12's evidence handling and reproducibility.
- **Key ideas:**
  - Volatile data (processes, connections, memory) versus disk data (logs, files, timestamps); order of collection.
  - Common artefacts: authentication logs, shell history, persistence locations (cron, systemd units, profiles).
  - A timeline reconstructs what happened and when from timestamps across sources.
  - Read-only handling: preserve the evidence; work on copies.
- **Recall targets:** volatile versus disk data and why collection order matters; where persistence artefacts live.
- **Build:** after a simulated compromise of a lab VM, build a timeline from its logs and artefacts. Planned: a lab exercise and timeline note; nothing from the lab is committed.
- **Safety:** lab VMs only; no forensic work on any third-party or production system.
- **Sources:** (checked 27/09/2026; re-verify when S3 opens) NIST SP 800-61r3 (<https://csrc.nist.gov/pubs/sp/800/61/r3/final>); `man 8 ausearch` (<https://man7.org/linux/man-pages/man8/ausearch.8.html>) for the audit trail.
- **Done when:** Sam produces a coherent timeline of the simulated compromise from the VM's own artefacts.

---

## 05 — Vulnerability disclosure

- **Objective:** Sam can write a vulnerability-disclosure policy and a `security.txt` for a web origin he runs (the future Syntek OS website or package-archive host), knows that this GitHub repository uses `SECURITY.md` instead, and can request a CVE.
- **Builds on:** sec-01's responsible/coordinated disclosure and law; the repo's existing `SECURITY.md`.
- **Key ideas:**
  - `security.txt` (RFC 9116) advertises how to report: `Contact` and `Expires` are required; `Policy`, `Encryption`, `Preferred-Languages` and others are optional. It is served over HTTPS at `/.well-known/security.txt` on a web origin, as `text/plain`, and covers only that domain — a file committed to a Git repository is not served there, which is why a GitHub repository uses `SECURITY.md` and private vulnerability reporting.
  - Coordinated disclosure: a reporter and a maintainer agree a timeline before public detail.
  - CVE IDs are requested through a CNA; the CVE program coordinates identifiers.
  - The public-repo rule: no working exploit for an unpatched third-party vulnerability is published — coordinated disclosure comes first.
- **Recall targets:** the required `security.txt` fields; where a `security.txt` must be served and what it covers; why coordinated disclosure precedes public exploit detail.
- **Build:** draft a `security.txt` and disclosure policy for the Syntek OS package-archive host (served from its web root when that host exists), as a note in this topic folder; this repository keeps `SECURITY.md` and GitHub private vulnerability reporting.
- **Security lens:** the non-negotiable — the public repository never holds working exploits for unpatched third-party vulnerabilities.
- **Sources:** (checked 27/09/2026; re-verify when S3 opens) RFC 9116, `security.txt` (<https://www.rfc-editor.org/rfc/rfc9116>); `SECURITY.md` (this repository's reporting route: GitHub private vulnerability reporting); the CVE program (<https://www.cve.org/>) and its partner (CNA) list (<https://www.cve.org/PartnerInformation/ListofPartners>).
- **Done when:** the `security.txt` carries the required fields and the policy states a coordinated-disclosure timeline and the no-exploit rule.
