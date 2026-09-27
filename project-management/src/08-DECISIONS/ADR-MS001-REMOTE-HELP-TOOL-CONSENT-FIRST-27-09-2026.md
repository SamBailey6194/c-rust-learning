# ADR-MS001: Remote-help tool — consent-first by construction

| Field | Value |
| --- | --- |
| **ID** | ADR-MS001-REMOTE-HELP-TOOL-CONSENT-FIRST |
| **Status** | Proposed |
| **Date** | 27/09/2026 |
| **Milestone** | MS001 — Toolchain ready · `project-management/src/02-MILESTONES/MS001-TOOLCHAIN-READY.md` |
| **Deciders** | Sam Bailey |
| **Supersedes** | — |
| **Superseded by** | — |
| **Research** | — (primary sources cited below); `research/REMOTE-HELP-CONSENT-AND-THE-COMPUTER-MISUSE-ACT.md`, `research/REMOTE-HELP-TOOL-AND-SECTION-3A.md`, `research/REMOTE-HELP-SESSION-RECORDS-AND-UK-GDPR.md`, `research/DUAL-USE-TOOLS-ON-GITHUB.md` and `research/RUST-MTLS-STACK-LICENCES.md` (all planned) |
| **Enforced in** | `project-management/docs/SAFETY-GUIDE.md` → Remote help · `project-management/src/01-ROADMAP/ROADMAP.md` → U2 · the remote-help repository's README and threat model (created when this build starts) — each once Accepted |

---

## Context

In the networking and licensing round of 27/09/2026, Sam answered the question of how he helps
family members with their computers: first with existing tools, in the lab and then in real
sessions with recorded consent (`learning/os-18-own-network-operations/` lesson 10, SSH and a shared
terminal over the tunnel), and also by building his own remote-help tool in Rust that is consent-first
by construction. He asked for the law to be researched before that tool's lessons are written. This
record sets the envelope the tool is designed inside, before any of its code exists; the lessons are
`learning/ui-11-consent-first-remote-help/`.

A remote-help tool is dual-use by nature: the software that lets a helper see and type into someone
else's terminal is the same class of software an intruder reuses to keep control of a machine. The
record therefore states only the text of the statutes and policies below. **How each applies to a
family helping session, and to publishing this tool, is unverified** until the four planned notes
named in the Research row (the consent, section 3A, session-records and GitHub notes) exist.

Facts checked on 27/09/2026:

- **Authorisation, in the statute's words.** Under the Computer Misuse Act 1990, section 17(5),
  access of any kind to a program or data is unauthorised if the person is not entitled to control
  access of that kind and does not have consent to it from someone who is. Section 17(8) makes an act
  in relation to a computer unauthorised if the person doing it neither has responsibility for the
  computer with the right to decide whether the act may be done, nor has consent from such a person
  (Sources, item 1). Whose consent that is for an adult's own device, a child's, a shared or an
  employer's device is the consent note's question, not answered here.
- **Making and supplying articles.** Section 3A makes it an offence to make, adapt, supply or offer
  to supply an article intending it to be used for an offence under section 1, 3 or 3ZA; to supply or
  offer one believing it is likely to be so used; or to obtain one for such use. An "article" includes
  any program or data held in electronic form (Sources, item 2).
- **How prosecutors weigh a dual-use article.** The CPS legal guidance on the Act (updated
  03/08/2023) lists factors for deciding whether an article is likely to be used for an offence:
  whether it was developed primarily and deliberately to commit one, whether it is sold widely through
  legitimate channels, whether it is in widespread legitimate use with a substantial installed base,
  and the context in which it is used compared with its intended use. It also treats how the article
  is distributed (to vetted professionals, or posted publicly) as relevant (Sources, item 3). Whether
  keeping the repository private, or publishing it, changes anything for this tool is the section 3A
  note's question.
- **Personal data at home.** UK GDPR Article 2(2)(a) excludes processing "by an individual in the
  course of a purely personal or household activity" (Sources, item 4). Whether a session log of a
  family member's terminal falls inside that exclusion, and what changes if help were ever paid, is
  the session-records note's question.
- **Publishing on GitHub.** GitHub's Acceptable Use Policies allow dual-use security content, forbid
  using the platform in direct support of unlawful attacks or as malware delivery or command-and-control
  infrastructure, and may restrict dual-use content during widespread abuse. Owners are asked to
  mark potentially harmful content and to provide a `SECURITY.md` with a contact for abuse
  reports (Sources, item 5).
- **The abuse this design must refuse.** MITRE ATT&CK technique T1219, "Remote Access Tools"
  (version 3.0, last modified 12/05/2026), is in the Command and Control tactic and covers
  adversaries using legitimate remote-access software for an interactive channel after a compromise;
  its sub-techniques include remote desktop software (Sources, item 6).
- **The TLS stack's licences.** On crates.io, rustls 0.23.45 is "Apache-2.0 OR ISC OR MIT"; its two
  production crypto providers carry Apache-2.0 as a required term: ring 0.17.14 is "Apache-2.0 AND
  ISC", and aws-lc-sys 0.45.0 (under aws-lc-rs 1.18.1) includes a bare "AND Apache-2.0" (Sources, item
  7). The Free Software Foundation lists Apache-2.0 as compatible with GPL version 3 but not version 2
  (Sources, item 8). Reasoned from those strings, neither provider fits this repository's GPL-2.0-only
  allow list in `code/src/rust/deny.toml` without an exception; the mTLS-stack note confirms it with a
  cargo-deny run and picks the provider.
- **Mutual TLS is standard.** TLS 1.3 lets a server request a client certificate and the client
  answer with its own Certificate and CertificateVerify messages (Sources, item 10); rustls verifies
  client certificates against the trust anchors it is given, and can check CRLs while doing so
  (Sources, item 9).

**Clash check** (`project-management/workflows/08-decisions/`, Step 3), against the records this one
touches:

- `ADR-MS001-NETWORK-LAB-FIRST-GRADUATION-PATH-27-09-2026.md` allows remote-help sessions, never
  configuration, on family devices named in the milestone, with a written consent record from whoever
  controls the device. This record governs the tool such a session may use; the two are consistent.
- `ADR-MS001-SECURITY-TRACK-AND-LAB-RULES-27-09-2026.md`, rule 2 (attack tooling runs in VMs, never on
  the host): the abuse-case harness and every weakened build run in VMs only. The helper client on the
  host is argued **not** to be attack tooling: it cannot start a session, it reaches only a person who
  dialled out to it and consented, it sees only what that person grants, and every session ends and is
  logged on their side. Sam's sign-off accepts or rejects this argument; if he rejects it, real
  sessions run from a VM. Rule 5: lesson 08's weakened build is a named target, never installed or
  shipped. Rule 6 (no malware): the ten constraints and the non-goals below are the argument that the
  tool is not malware — it refuses the stealth, persistence and unattended access that make
  remote-access software malicious.
- `ADR-MS001-LLM-RUST-CRATE-LICENCES-27-09-2026.md`: no TLS provider enters this repository. Lesson
  02's crate here uses no third-party crates, and from lesson 03 the tool lives in its own repository.
- `ADR-MS001-SYNTEK-OS-TOOLS-RUST-TUI-FIRST-27-09-2026.md`: a Rust TUI, consistent.
- `ADR-MS001-PRIVATE-CA-OFFLINE-ROOT-AND-ACME-27-09-2026.md`: session identities are leaves from that
  CA. `ADR-MS001-PRODUCT-LICENCES-INBOUND-RULES-27-09-2026.md` and
  `ADR-MS001-PRODUCT-LICENCES-APPROVED-OUTBOUND-LIST-27-09-2026.md`: the provider must fit the entry the
  remote-help repository picks from the approved list when its build starts.
- `.claude/CLAUDE.md` Section 5: Claude never runs `sudo`, never opens a session to a real device and
  never holds a credential for one.

## Options considered

### Option A — Build it, consent-first by construction

- **Summary:** A Rust terminal tool whose consent, visibility, time limits, logging and teardown are
  properties of its code, each stated as a testable constraint, proved between two VMs before any
  real session.
- **Pros:** The learning Sam asked for (mutual TLS, pseudoterminals, sandboxing, a TUI that cannot be
  spoofed), and a tool whose design refuses the abuse cases rather than relying on the helper's care.
  Every constraint becomes a test in `ui-11`.
- **Cons:** A network-facing, dual-use program to design, secure and eventually publish; a separate
  repository; lessons that wait on four research notes; and the risk that the research finds exposure
  no design removes.

### Option B — Existing tools only

- **Summary:** Keep `os-18` lesson 10's route: SSH with restricted, expiring keys and a shared
  terminal session, set up by hand for each session with a consent record.
- **Pros:** Mature, audited tools; nothing new to publish; available as soon as the lab exists.
- **Cons:** The consent properties rest on configuration and procedure repeated by hand each time,
  not on a code path the abuse cases can test; it does not teach building such a tool.

### Option C — An unattended agent

- **Summary:** An always-on agent on each family device that the helper can connect to at any time.
- **Pros:** Convenient; help without the helped person present.
- **Cons:** It has the shape of a remote-access trojan and of T1219's abuse: persistent, listening,
  usable without the person at the keyboard. **Rejected.**

### Option D — Do nothing

- **Summary:** No remote help at all; help happens in person.
- **Pros:** No legal, security or publishing questions.
- **Cons:** Leaves Sam's answer unmet and family devices without help at a distance.

## Decision

**Proposed: Option A — a remote-help tool, consent-first by construction.** Option B remains the
route until A is proven, and the fallback if A is not. The deciding factor is that A moves consent
and visibility from procedure into code, where the abuse-case suite can prove them; C was rejected on
its shape alone.

The tool meets ten constraints. Each names the `ui-11` lesson that tests it:

1. **User-initiated.** The helped person starts the session, and the tool dials out once to a pinned
   helper identity; nothing listens on the helped side (lesson 02).
2. **Consent per session, per kind.** View is the default; control is a separate grant the helped
   person can revoke at any time. A device an employer controls is refused (lessons 02 and 04).
3. **An indicator the helper cannot suppress.** While a session is live, the helped side shows it,
   and no helper input or output can hide or spoof it (lesson 04).
4. **Time-limited.** A hard maximum in code, an idle timeout and no resume: an ended session is a new
   request (lessons 02 and 07).
5. **A log held by the helped person.** A hash-chained record of what the helper saw and did, kept on
   the helped device. Filled consent records and logs stay on that device, plus Sam's machine if the
   helped person agrees, and never enter any git repository; only a blank template may live in the
   private infrastructure repository (lesson 06).
6. **No persistence.** No service unit, timer, cron entry, profile hook or autostart entry, before or
   after a session (lesson 07).
7. **No stealth.** The tool runs under its own name and stays visible in `ps`, the journal and
   auditd (lesson 08).
8. **No privilege beyond the session.** It runs as the helped user with no new privileges, caches no
   credential and gives the helper nothing that user does not have (lesson 05).
9. **Mutual TLS on the private CA.** Both ends present leaves from the CA of
   `ADR-MS001-PRIVATE-CA-OFFLINE-ROOT-AND-ACME-27-09-2026.md`, with the intermediate pinned in the
   tool's own trust file, and a crypto provider whose licence is compatible with the remote-help
   repository's entry in `ADR-MS001-PRODUCT-LICENCES-APPROVED-OUTBOUND-LIST-27-09-2026.md` (lesson 03).
10. **Revocation and an "end now" key.** A revoked identity is refused, and the helped person can end
    the session with one key at any moment (lessons 03 and 04).

**Non-goals.** Unattended access, hiding, persistence, spreading to other machines, credential
capture, exfiltration, camera or microphone access, and desktop capture. Each needs a superseding
ADR. Graphical desktop sharing is parked in `DEFERRED.md` (U3), and devices other than Linux are left
to `project-management/src/01-ROADMAP/MAP-UI.md` → fog of war.

**Publishing.** The remote-help repository stays private until the section 3A and GitHub notes exist
and this record is Accepted; it then goes public, with the non-goals in its README and a
`SECURITY.md` for abuse reports.

To move to `Accepted`: the consent, section 3A, session-records and GitHub notes exist, none finds
exposure the design cannot meet (the constraints are revised against them while this record is
still Proposed), and Sam signs off, including the clash-check argument on lab rule 2.

This answer reopens if the section 3A or GitHub note finds exposure whatever the design, if a need
for unattended access arises, or if desktop sharing is taken up.

## Consequences

- **Positive:** The tool's shape is argued before any code exists; every constraint is a test; the
  dual-use repository goes public only after the research allows it.
- **Negative:**
  - A separate repository to secure and, later, to publish.
  - `ui-11` lessons 01, 06 and 09 wait on the research notes, and lesson 03 on the mTLS-stack note.
  - U2's exit gate does not wait on `ui-11`, so the tool may land long after U2 closes.
  - Real sessions from the host rest on the clash-check argument, which Sam may reject.
- **Follow-on:**
  - `project-management/docs/SAFETY-GUIDE.md` → Remote help carries the constraints as the threat
    model's mitigations.
  - `GAPS.md` logs the remote-help law and dual-use publishing as an open question; the export rules
    for shipping cryptography also block lesson 09's first public binary.
  - `DEFERRED.md` parks graphical desktop sharing (U3).
  - `project-management/src/01-ROADMAP/MAP-UI.md` charts the research, this record and the mTLS stack
    as frontier nodes.
  - The remote-help repository takes its outbound licence from the approved list when its build
    starts.

## Sources

1. **Computer Misuse Act 1990, section 17** — <https://www.legislation.gov.uk/ukpga/1990/18/section/17>
   — subsections (5) and (8), checked 27/09/2026
2. **Computer Misuse Act 1990, section 3A** — <https://www.legislation.gov.uk/ukpga/1990/18/section/3A>,
   checked 27/09/2026
3. **Crown Prosecution Service, legal guidance "Computer Misuse Act"** (updated 03/08/2023) —
   <https://www.cps.gov.uk/legal-guidance/computer-misuse-act> — the section 3A dual-use factors,
   checked 27/09/2026
4. **UK GDPR, Article 2** — <https://www.legislation.gov.uk/eur/2016/679/article/2> — paragraph
   2(a), checked 27/09/2026
5. **GitHub, Active Malware or Exploits** —
   <https://docs.github.com/en/site-policy/acceptable-use-policies/github-active-malware-or-exploits>,
   checked 27/09/2026
6. **MITRE ATT&CK, T1219 Remote Access Tools** — <https://attack.mitre.org/techniques/T1219/> —
   version 3.0, checked 27/09/2026
7. **crates.io licence fields** — <https://crates.io/crates/rustls> (0.23.45),
   <https://crates.io/crates/ring> (0.17.14), <https://crates.io/crates/aws-lc-rs> (1.18.1),
   <https://crates.io/crates/aws-lc-sys> (0.45.0), checked 27/09/2026
8. **FSF, Various Licenses and Comments about Them — Apache License 2.0** —
   <https://www.gnu.org/licenses/license-list.html#apache2> — compatible with GPL version 3, not
   version 2; read through the Internet Archive's copy of 27/09/2026
9. **rustls, `WebPkiClientVerifier`** —
   <https://docs.rs/rustls/latest/rustls/server/struct.WebPkiClientVerifier.html> — client
   certificates verified against given trust anchors, with CRLs, checked 27/09/2026
10. **RFC 8446, TLS 1.3** — <https://www.rfc-editor.org/rfc/rfc8446> — Sections 4.3.2 (Certificate
    Request) and 4.4.2 (Certificate), checked 27/09/2026
11. **Sam's answer of 27/09/2026 on remote help** — the networking and licensing round
