# ADR-MS001: Security track — authorised, isolated-lab-only offensive work, defensive-only malware work

| Field | Value |
| --- | --- |
| **ID** | ADR-MS001-SECURITY-TRACK-AND-LAB-RULES |
| **Status** | Accepted |
| **Date** | 27/09/2026 |
| **Milestone** | MS001 — Toolchain ready · `project-management/src/02-MILESTONES/MS001-TOOLCHAIN-READY.md` |
| **Deciders** | Sam Bailey |
| **Supersedes** | — |
| **Superseded by** | — |
| **Research** | — (primary sources cited below); `research/PENTEST-LAB-NETWORK-ISOLATION.md` and `research/VULNERABLE-TARGET-LICENCES.md` (both planned) ground the lab build |
| **Enforced in** | `.claude/CLAUDE.md` Section 5 (the non-negotiables) · `project-management/docs/SAFETY-GUIDE.md` → Security track · `project-management/src/01-ROADMAP/ROADMAP.md` → S1 to S3 · `DEFERRED.md` (live-sample analysis) |

---

## Context

Security runs through the roadmap as a lens — every milestone names its threat model
(`ADR-MS001-ROADMAP-KERNEL-OS-UI-LLM-TRACKS-27-09-2026.md`) — and inside topics such as kernel
hardening, repository signing and LLM threats. On 27/09/2026 Sam asked whether the curriculum also
needs penetration-testing and cybersecurity lessons, and the answer was yes: a `sec` track in three
phases — S1 foundations, S2 an authorised penetration-testing lab, S3 securing and testing his own
systems. The same day he asked for malware defence and antivirus lessons, framed as detection,
prevention and protection built into Syntek OS. This record sets the rules that track runs under; the
phases themselves are in `ROADMAP.md`.

Facts checked on 27/09/2026:

- **Authorisation is the legal line in the UK.** Under the Computer Misuse Act 1990, section 1, it is
  an offence to cause a computer to perform a function with intent to secure access to a program or
  data when the access is unauthorised and the person knows it (Sources, item 1). Section 3A adds three
  offences, each tied to an offence under section 1, 3 or 3ZA: making, adapting, supplying or offering
  to supply an article with the intent that it be used to commit or assist one (3A(1)); supplying or
  offering to supply an article in the belief that it is likely to be so used (3A(2)); and obtaining an
  article to use that way, or with a view to its being supplied for that use (3A(3)). An "article"
  includes any program or data held in electronic form (3A(4)) (Sources, item 2).
- **Isolation can be built, not promised.** QEMU's user-mode network option `restrict=on` isolates a
  guest so it cannot contact the host and none of its packets are routed outside (Sources, item 3).
  A libvirt network with no forward element lets guests reach each other and the host but no other
  machine on the LAN (Sources, item 4).
- **Publishing has rules of its own.** GitHub allows dual-use security research content but not the
  use of its platform in direct support of unlawful attacks, and may restrict dual-use content during
  widespread abuse (Sources, item 5). OverTheWire asks players not to spoil its games and not to
  publish any game credentials (Sources, item 6).
- **Legal practice targets exist.** OWASP Juice Shop is an intentionally insecure web application
  built for security training (Sources, item 7).
- **Detection can be tested without malware.** The EICAR anti-malware test file exists so antivirus
  software can be tested without a real virus (Sources, item 8).
- **Method and disclosure are documented.** NIST SP 800-115 is a technical guide to security testing
  and assessment (Sources, item 9), NIST SP 800-61 Rev. 3 covers incident response (Sources, item 10),
  and RFC 9116 defines `security.txt` for publishing a disclosure policy (Sources, item 11).

## Options considered

### Option A — Offensive techniques, but only authorised and only in an isolated lab

- **Summary:** Sam learns attacks against systems he owns, or is authorised in writing to test,
  inside isolated virtual networks; attack tooling runs in VMs, never on the host; training platforms'
  rules are followed; malware work is defensive only.
- **Pros:** Testing Syntek OS profiles and the model (S3) needs an attacker's view. Isolation makes
  harm to the home network impossible by construction, not by care.
- **Cons:** A lab to build and maintain (attacker VM, targets, snapshots); some tools need a VM image
  and disk space the host has to find.

### Option B — Defensive-only track

- **Summary:** Hardening, detection and response; no offensive techniques.
- **Pros:** No legal or publishing questions.
- **Cons:** Syntek OS and the model cannot be tested the way an attacker would test them; defences
  are chosen without knowing what they defend against.

### Option C — Online training platforms only

- **Summary:** Practise only on hosted platforms under their rules.
- **Pros:** No lab to build; the platform supplies authorisation.
- **Cons:** Cannot test Sam's own systems; write-ups are limited by each platform's rules.

### Option D — No track; security stays a lens

- **Summary:** Keep security inside other topics.
- **Pros:** Less curriculum.
- **Cons:** Threat modelling, cryptography and the Linux security model are prerequisites to many OS
  and LLM lessons; without a track they are taught piecemeal.

## Decision

**We will take Option A.** Offensive security work in this repository follows these rules:

1. Techniques run only against systems Sam owns, or is explicitly authorised in writing to test,
   inside isolated lab networks with no route to the home LAN; the written scope comes first.
2. Attack tooling runs in VMs, never on the host.
3. Training and CTF platforms' rules on publishing solutions and credentials are respected; a
   write-up is published only where the platform permits it.
4. The public repository never holds a working exploit for an unpatched third-party vulnerability;
   coordinated disclosure comes first.
5. Deliberately vulnerable exercise builds are confined to clearly named targets that are never
   installed or shipped.
6. No malware is written or distributed. No live malware sample enters the repository, the host or
   CI; detection is tested with the EICAR test file and synthetic, harmless files. Live-sample
   analysis is parked in `DEFERRED.md` until a dedicated air-gapped analysis environment exists and a
   new ADR allows it.

The deciding factor is that S3's purpose — testing Syntek OS and the model as an attacker would — is
impossible without offensive skills, and the Computer Misuse Act makes authorisation and isolation
the conditions under which learning them is lawful. Option C was the runner-up and is kept as a
complement for binary exploitation practice.

This answer changes only if a later need (for example, live-sample analysis) justifies relaxing a
rule, which would be argued in a new ADR with its own environment.

## Consequences

- **Positive:** `sec-01-principles-threat-modelling-and-law` is reachable after P1, so the threat
  models every milestone now names have a lesson behind them. The OS and LLM topics cite one sandbox
  and one set of lab rules.
- **Negative:** The lab (`sec-06-pentest-lab-setup`) needs VM images and tools that are not installed;
  those are toolchain gaps in `GAPS.md` until they are.
- **Follow-on:**
  - `.claude/CLAUDE.md` Section 5 carries rules 1 to 6 as non-negotiables;
    `project-management/docs/SAFETY-GUIDE.md` explains what a security milestone plans for.
  - `DEFERRED.md` records live-malware-sample analysis.
  - `SECURITY.md` stays about reporting vulnerabilities in this repository.
  - The lab network's isolation is proved before any offensive exercise, in the lab-setup milestone,
    with evidence in its verification record.

## Sources

1. **Computer Misuse Act 1990, section 1** — <https://www.legislation.gov.uk/ukpga/1990/18/section/1>,
   checked 27/09/2026
2. **Computer Misuse Act 1990, section 3A** — <https://www.legislation.gov.uk/ukpga/1990/18/section/3A>,
   checked 27/09/2026
3. **QEMU invocation, `-netdev user,restrict=on`** — <https://www.qemu.org/docs/master/system/invocation.html>,
   checked 27/09/2026
4. **libvirt network XML format, isolated network config** — <https://libvirt.org/formatnetwork.html>,
   checked 27/09/2026
5. **GitHub, Active Malware or Exploits** —
   <https://docs.github.com/en/site-policy/acceptable-use-policies/github-active-malware-or-exploits>,
   checked 27/09/2026
6. **OverTheWire rules** — <https://overthewire.org/rules/>, checked 27/09/2026
7. **OWASP Juice Shop** — <https://owasp.org/www-project-juice-shop/>, checked 27/09/2026
8. **EICAR anti-malware test file** — <https://www.eicar.org/download-anti-malware-testfile/>, checked
   27/09/2026
9. **NIST SP 800-115, Technical Guide to Information Security Testing and Assessment** —
   <https://csrc.nist.gov/pubs/sp/800/115/final>, checked 27/09/2026
10. **NIST SP 800-61 Rev. 3, Incident Response Recommendations and Considerations for Cybersecurity
    Risk Management** — <https://csrc.nist.gov/pubs/sp/800/61/r3/final>, checked 27/09/2026
11. **RFC 9116, A File Format to Aid in Security Vulnerability Disclosure** —
    <https://www.rfc-editor.org/rfc/rfc9116>, checked 27/09/2026
12. **Sam's requests of 27/09/2026** — the security track, and the defensive-only malware and
    antivirus topics
