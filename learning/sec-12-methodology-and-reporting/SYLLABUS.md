# Syllabus — sec-12-methodology-and-reporting

**Track**: sec · **Phase**: S2 · **Path**: Later · **Detail**: outline · **Prerequisites**: sec-01 (law, ethics, scope), and the S2 offensive lessons sec-06 to sec-11
**Status**: Planned · **Checked**: 27/09/2026 (sources re-verified by `/teach` step 3 before each lesson)

An offensive test is only useful if it is scoped lawfully, recorded honestly and reported so the reader can act. This topic is the discipline around the techniques: the recognised methodologies, the rules of engagement and scope document, evidence handling, severity scoring, and the written report. It closes S2 by turning lab exercises into something Sam could hand to a client or apply to his own systems in S3. Everything is practised on the sec-06 lab and Sam's own findings; the ethics and authorisation rules from sec-01 govern throughout. It is an **outline** topic because S2 is a far phase: its builds are sketched and its sources, checked on 27/09/2026, are re-verified when the topic opens.

| # | Lesson | Size | Build | Lenses |
| --- | --- | --- | --- | --- |
| 01 | Methodologies compared: NIST 800-115, PTES, OWASP WSTG | 2–3 sittings | no | — |
| 02 | Rules of engagement and scope | 2–3 sittings | yes — scope-doc | Security |
| 03 | Evidence handling and note-taking | 1 sitting | yes — evidence-log | Security |
| 04 | Severity rating with CVSS | 2–3 sittings | yes — cvss-scoring | — |
| 05 | Writing the report | 2–3 sittings | yes — lab-report | — |

---

## 01 — Methodologies compared: NIST 800-115, PTES, OWASP WSTG

- **Objective:** Sam can name the phases of each methodology and say which fits a given engagement.
- **Builds on:** sec-01's threat modelling and law; the practical work in sec-06 to sec-11.
- **Key ideas:**
  - NIST SP 800-115 frames testing as planning, discovery, attack and reporting, with feedback loops.
  - PTES defines seven phases from pre-engagement interactions through reporting.
  - The OWASP Web Security Testing Guide is a methodology and checklist specific to web applications (ties to sec-08).
  - A methodology gives repeatability and coverage; it does not replace judgement or authorisation.
- **Recall targets:** the high-level phases shared by these methodologies; when the web-specific guide is the right frame versus the general ones.
- **Build:** none (reading and a comparison note that maps the three onto Sam's own lab workflow).
- **Sources:** (checked 27/09/2026; re-verify when S2 opens) NIST SP 800-115, "Technical Guide to Information Security Testing and Assessment" (<https://csrc.nist.gov/pubs/sp/800/115/final>); PTES (<http://www.pentest-standard.org/index.php/Main_Page>); OWASP Web Security Testing Guide, stable (<https://owasp.org/www-project-web-security-testing-guide/stable/>).
- **Done when:** Sam picks a methodology for a described engagement and justifies the choice against its phases.

---

## 02 — Rules of engagement and scope

- **Objective:** Sam can write a rules-of-engagement and scope document that would make a test lawful and unambiguous.
- **Builds on:** sec-01's written authorisation and Computer Misuse Act framing; lesson 01's methodologies.
- **Key ideas:**
  - Scope names in-scope and out-of-scope assets explicitly; anything not in scope is off-limits.
  - Rules of engagement fix the testing window, permitted and forbidden techniques, rate limits, and emergency stop and contact procedures.
  - Data-handling rules say what may be accessed, copied or exfiltrated (in a real test: as little as proves the finding) and how it is stored and destroyed.
  - Deconfliction: how to tell a real incident from the test in progress.
- **Recall targets:** what a scope document must state to keep a test lawful; why "not explicitly in scope" means out of scope.
- **Build:** write a rules-of-engagement and scope document for the sec-06 lab (a Markdown note in this topic folder; no code path). Everything it authorises is Sam's own isolated lab.
- **Security lens:** the non-negotiable — offensive techniques only against systems Sam owns or is authorised in writing to test, inside the isolated lab (`.claude/CLAUDE.md`).
- **Sources:** (checked 27/09/2026; re-verify when S2 opens) NIST SP 800-115, planning phase (<https://csrc.nist.gov/pubs/sp/800/115/final>); PTES pre-engagement interactions (<http://www.pentest-standard.org/index.php/Main_Page>).
- **Done when:** the scope document names assets, window, permitted techniques, data handling and stop conditions, and would stand as authorisation for a lab test.

---

## 03 — Evidence handling and note-taking

- **Objective:** Sam can keep contemporaneous, reproducible evidence for each finding.
- **Builds on:** lesson 02's data-handling rules; the command logs from sec-07 onwards.
- **Key ideas:**
  - Contemporaneous notes with timestamps: what was run, against what, and the result.
  - Reproducibility: a finding a reader cannot reproduce from the notes is not yet a finding.
  - Evidence storage: capturing command output and screenshots, minimising sensitive data, and securing what is kept.
  - Chain of custody at a lab scale: who touched the evidence and when.
- **Recall targets:** why timestamps and exact commands matter; what "reproducible finding" requires.
- **Build:** set up a repeatable evidence log for one lab test — a structured note plus captured command output. No new code path; a note in this topic folder.
- **Security lens:** minimise and secure collected data; store nothing sensitive that the finding does not need.
- **Sources:** (checked 27/09/2026; re-verify when S2 opens) NIST SP 800-115, reporting and documentation (<https://csrc.nist.gov/pubs/sp/800/115/final>); PTES reporting (<http://www.pentest-standard.org/index.php/Main_Page>).
- **Done when:** a second reader could reproduce one of Sam's lab findings from the evidence log alone.

---

## 04 — Severity rating with CVSS

- **Objective:** Sam can score a finding with a CVSS v4.0 base vector and explain what the score does and does not mean.
- **Builds on:** the vulnerabilities found in sec-07 to sec-11; lesson 03's evidence.
- **Key ideas:**
  - CVSS v4.0 has four metric groups: Base, Threat, Environmental and Supplemental.
  - The Base metrics produce a vector and score assuming the worst for Threat and Environmental; those are then amended for a real environment.
  - CVSS measures technical severity, not risk or likelihood; EPSS estimates exploitation probability and complements it.
  - A score without its vector is not reviewable; always record the vector.
- **Recall targets:** the four CVSS v4.0 metric groups; why a base score alone overstates or understates real risk.
- **Build:** score two example lab findings, producing their base vectors, and note how an environmental metric would change each. No code path; a scoring note.
- **Sources:** (checked 27/09/2026; re-verify when S2 opens) FIRST CVSS v4.0 Specification Document (<https://www.first.org/cvss/v4.0/specification-document>); CVSS v3.1 for comparison (<https://www.first.org/cvss/v3.1/specification-document>); FIRST CVSS home (<https://www.first.org/cvss/>).
- **Done when:** Sam produces a defensible CVSS v4.0 vector for a finding and states the score's limits.

---

## 05 — Writing the report

- **Objective:** Sam can write a report that lets a non-attacker understand and fix each finding.
- **Builds on:** lessons 01–04 — methodology, scope, evidence and severity feed the report.
- **Key ideas:**
  - Structure: executive summary, methodology and scope, findings, and appendices.
  - A finding carries severity, evidence, reproduction steps, impact and concrete remediation.
  - Audience: the executive summary is for decision-makers; the findings are for engineers; both come from the same test.
  - Remediation advice is the point — a finding without a fix path is half-done.
- **Recall targets:** the sections of a report and who each serves; what a single finding entry must contain.
- **Build:** write a short pentest report for one prior lab exercise, with at least one fully worked finding. A Markdown note in this topic folder; no code path.
- **Sources:** (checked 27/09/2026; re-verify when S2 opens) NIST SP 800-115, reporting (<https://csrc.nist.gov/pubs/sp/800/115/final>); PTES reporting (<http://www.pentest-standard.org/index.php/Main_Page>); FIRST CVSS v4.0 for the severity field (<https://www.first.org/cvss/v4.0/specification-document>).
- **Done when:** the report's finding is reproducible from its own text, carries a CVSS vector, and states a remediation an engineer could apply.
