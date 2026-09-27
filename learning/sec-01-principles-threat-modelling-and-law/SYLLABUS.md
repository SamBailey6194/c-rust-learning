# Syllabus — sec-01-principles-threat-modelling-and-law

**Track**: sec · **Phase**: S1 · **Path**: Core · **Detail**: full · **Prerequisites**: P1 (sec-01 may start once C foundations are in place; no offensive work here)
**Status**: Planned · **Checked**: 27/09/2026 (sources re-verified by `/teach` step 3 before each lesson)

This topic is the foundation of the whole `sec` track and the source of the **Security lens** that
every kernel, OS and LLM milestone carries. It teaches security as a way of reasoning — what is
being protected, from whom, and how much effort a defence is worth — and it fixes the law and ethics
that bound every later lesson: authorised work on Sam's own systems and legal training platforms
only. Nothing offensive runs anywhere until `sec-06` builds the isolated lab. It sits before the
Syntek OS hardening lessons (kernel-04, os-08, os-11) and the LLM threat-model lesson (llm-18), all
of which name it as a prerequisite.

| # | Lesson | Size | Build | Lenses |
| --- | --- | --- | --- | --- |
| 01 | Security properties and the principles that follow from them | 1 sitting | no | Security |
| 02 | Attack surface and trust boundaries | 1 sitting | no | Efficiency, Security |
| 03 | Threat modelling with STRIDE over a data-flow diagram | 2–3 sittings | no | Security |
| 04 | Writing a milestone's threat model (assets, threats, mitigations) | 1 sitting | no | Security |
| 05 | The law: authorisation, scope and the UK Computer Misuse Act 1990 | 1 sitting | no | Security, Safety |
| 06 | Coordinated vulnerability disclosure | 1 sitting | no | Security |

---

## 01 — Security properties and the principles that follow from them

- **Objective:** Sam can state the CIA properties (confidentiality, integrity, availability) for a
  given asset and name which principle (least privilege, defence in depth, fail-safe defaults,
  economy of mechanism, complete mediation) a given control serves.
- **Builds on:** no prior security lesson; draws on Sam's experience running a public repository and
  a maintained Ubuntu host (<https://github.com/SamBailey6194/reboot-purge>, via
  `how-to/src/HOST-MAINTENANCE.md`).
- **Key ideas:**
  - Security is a property of an **asset relative to a threat**, not an absolute state; name the
    asset and the property before naming a control.
  - Confidentiality, integrity and availability — and why availability trades against the other two.
  - Fail-safe defaults, complete mediation, economy of mechanism and least privilege come from
    Saltzer and Schroeder (1975), four of their eight design principles; defence in depth is a later
    layering principle (NIST SP 800-12 Rev. 1, Section 2.6). Each is a lens on a design.
  - A control has a cost; a principle says where to spend it.
- **Recall targets:** name the CIA property most at risk for a chosen asset (a signing key, a
  package repository, the LLM's training data) and the principle a proposed control serves.
- **Build:** none — the output is a short written note; no code artefact.
- **Security lens:** this lesson defines the vocabulary every later Security lens uses.
- **Sources:** Saltzer and Schroeder, "The Protection of Information in Computer Systems" (1975), Section I.A.3 "Design Principles", <https://web.mit.edu/Saltzer/www/publications/protection/Basic.html>; NIST SP 800-12 Rev. 1 (An Introduction to Information Security), Section 2.6 (defense-in-depth), <https://csrc.nist.gov/pubs/sp/800/12/r1/final>; NIST SP 800-160 Vol. 1 Rev. 1 (Engineering Trustworthy Secure Systems), <https://csrc.nist.gov/pubs/sp/800/160/v1/r1/final>; OWASP Threat Modeling process, <https://owasp.org/www-community/Threat_Modeling_Process>.
- **Done when:** Sam names, for one of his own assets, the property at risk and the principle a
  control serves, unaided.

## 02 — Attack surface and trust boundaries

- **Objective:** Sam can draw the trust boundaries of a small system and list its attack surface
  (the inputs an untrusted party can influence).
- **Builds on:** lesson 01.
- **Key ideas:**
  - Attack surface = every input, interface and privilege an untrusted party can reach; reducing it
    is the cheapest defence.
  - A trust boundary is where data crosses from a less-trusted to a more-trusted context (a socket,
    a file parsed, a command-line argument, a package downloaded).
  - Every boundary crossing is a place to validate; every unused interface is surface to remove.
  - Module count and open ports as measurable attack surface (forward reference to kernel-04's
    config-measurement method).
- **Recall targets:** for a given component, list its inputs and mark which cross a trust boundary.
- **Build:** none.
- **Efficiency lens:** fewer interfaces means less code to build, audit and run — surface and cost
  fall together.
- **Security lens:** the surface list feeds every milestone's `## Threat model` section.
- **Sources:** OWASP Threat Modeling Cheat Sheet, <https://cheatsheetseries.owasp.org/cheatsheets/Threat_Modeling_Cheat_Sheet.html>; NIST SP 800-12 Rev. 1, <https://csrc.nist.gov/pubs/sp/800/12/r1/final>.
- **Done when:** Sam produces a labelled data-flow sketch with trust boundaries marked for one of
  his components.

## 03 — Threat modelling with STRIDE over a data-flow diagram

- **Objective:** Sam can build a data-flow diagram for a system and enumerate threats against each
  element using STRIDE.
- **Builds on:** lesson 02.
- **Key ideas:**
  - A data-flow diagram: external entities, processes, data stores, data flows, and trust
    boundaries drawn across them.
  - STRIDE as a checklist per element — Spoofing, Tampering, Repudiation, Information disclosure,
    Denial of service, Elevation of privilege — and which elements each threat class applies to.
  - From threat to mitigation to residual risk; not every threat is worth mitigating.
  - Threat modelling is iterative and cheap early; it is the method the Security lens standardises.
- **Recall targets:** given a data-flow element, name the STRIDE classes that apply and one
  mitigation for each identified threat.
- **Build:** none — the artefact is a diagram plus a threat table (a written note, not code).
- **Security lens:** this is the method every milestone's threat model uses.
- **Sources:** OWASP Threat Modeling Cheat Sheet, <https://cheatsheetseries.owasp.org/cheatsheets/Threat_Modeling_Cheat_Sheet.html>; Microsoft — STRIDE threat categories, <https://learn.microsoft.com/en-us/azure/security/develop/threat-modeling-tool-threats>.
- **Done when:** Sam completes a STRIDE pass over a data-flow diagram of one of his own systems and
  lists a mitigation per accepted threat.

## 04 — Writing a milestone's threat model (assets, threats, mitigations)

- **Objective:** Sam can write the `## Threat model` section a milestone requires: assets, threats,
  mitigations, or the non-negotiable it runs under.
- **Builds on:** lesson 03.
- **Key ideas:**
  - The milestone threat-model format (owned by `project-management/docs/planning/MILESTONES.md`):
    one to three lines naming assets, threats and mitigations.
  - Mapping a STRIDE finding onto that section without over-writing it.
  - When "the non-negotiable it runs under" is the right answer (for example a gate that could not
    run is not a pass).
- **Recall targets:** turn a STRIDE table into a three-line milestone threat model.
- **Build:** none — the output lands in a milestone's `## Threat model` section under
  `project-management/`, not in a code path.
- **Security lens:** this lesson operationalises the lens for the roadmap.
- **Sources:** `project-management/docs/planning/MILESTONES.md` (the milestone format; house owner); OWASP Threat Modeling Cheat Sheet, <https://cheatsheetseries.owasp.org/cheatsheets/Threat_Modeling_Cheat_Sheet.html>.
- **Done when:** Sam writes a threat-model section for a real candidate milestone that another
  reader can act on.

## 05 — The law: authorisation, scope and the UK Computer Misuse Act 1990

- **Objective:** Sam can state what the UK Computer Misuse Act 1990 makes an offence and why written
  authorisation and a defined scope are the boundary of every offensive lesson in this track.
- **Builds on:** lesson 01; sets the rule the whole track obeys.
- **Key ideas:**
  - The Act's offences at a plain-reading level: unauthorised access (section 1), access with intent
    (section 2), unauthorised acts impairing operation (section 3), unauthorised acts causing, or
    creating risk of, serious damage (section 3ZA), and making, supplying or obtaining articles for
    use in an offence under section 1, 3 or 3ZA (section 3A, where intent or belief is the element)
    — read from the legislation, not paraphrased from memory.
  - **Authorisation is the pivot:** the same action is lawful on your own system and an offence on
    another's. Every offensive lesson in this track (`sec-06`–`sec-10`, `sec-14`, `sec-15`) runs on
    Sam's own isolated lab or on a legal training platform under its own rules.
  - Written authorisation, defined scope and rules of engagement as the artefacts that record
    permission.
  - The repository never holds working exploits for unpatched third-party software.
- **Recall targets:** given a described action, say whether it needs authorisation and which offence
  it would be without it; why downloading nmap for the lab is not a section 3A offence (no intent to
  commit an offence; Sam's own lab, under a written scope).
- **Build:** none.
- **Security lens:** this is the ethics gate; it is cited by the security-track ADR and SAFETY-GUIDE.
- **Safety:** no offensive technique runs against any system Sam does not own or is not explicitly
  authorised in writing to test; Claude never runs `sudo`.
- **Sources:** Computer Misuse Act 1990, <https://www.legislation.gov.uk/ukpga/1990/18/contents>, sections 1, 2, 3, 3ZA (<https://www.legislation.gov.uk/ukpga/1990/18/section/3ZA>) and 3A (<https://www.legislation.gov.uk/ukpga/1990/18/section/3A>); `project-management/docs/SAFETY-GUIDE.md` (house safety rules).
- **Done when:** Sam states the authorisation boundary and cites the offence an unauthorised act
  would be, unaided.

## 06 — Coordinated vulnerability disclosure

- **Objective:** Sam can describe a coordinated-disclosure process and run one for this repository.
- **Builds on:** lesson 05.
- **Key ideas:**
  - Coordinated (responsible) disclosure: report privately, give the maintainer time to fix, publish
    after a fix or an agreed deadline.
  - What a good report contains and why proof-of-concept detail is withheld until a fix ships.
  - How this repository receives reports (`SECURITY.md` → GitHub private advisories) and the
    forward links to running a disclosure policy for Syntek OS (a later S3 topic).
- **Recall targets:** outline the steps from finding a bug to public disclosure and where the
  private-report channel for this repository is.
- **Build:** none.
- **Security lens:** disclosure is the responsible end of every finding this track produces.
- **Sources:** NCSC — Vulnerability reporting / disclosure, <https://www.ncsc.gov.uk/information/vulnerability-reporting>; `SECURITY.md` (this repository's reporting channel).
- **Done when:** Sam describes the coordinated-disclosure timeline and names this repository's
  private-report channel, unaided.
