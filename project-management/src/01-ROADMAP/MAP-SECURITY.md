# MAP-SECURITY — security as a discipline (S1–S3)

**Charted**: 27/09/2026 | **Charted by**: Sam Bailey | **Workflow**: `01-roadmap-map`
**Phase**: S1–S3 — `project-management/src/01-ROADMAP/ROADMAP.md`
**Status**: Charting
**Frontier open**: 3 | **Blocking open**: 1

> A `Charting` draft: destination and open decisions from Sam's request of 27/09/2026 and its ADR;
> nodes resolve in later sessions, one at a time. **The map is an index, not a vault.**

---

## Destination

S1–S3 exit gates met (`ROADMAP.md` → S1, S2, S3): security learned as a discipline — threat modelling
and memory-corruption mitigations turned on Sam's own C; an isolated, authorised penetration-testing
lab; and the Syntek OS profiles and the model hardened, tested in that lab, and given detection and a
disclosure process. All offensive work is authorised and isolated-lab-only; all malware work is
defensive, tested with EICAR and synthetic files.

---

## Notes

| Field | Value |
| --- | --- |
| Phase exit gate | S1–S3 — `project-management/src/01-ROADMAP/ROADMAP.md` → S1, S2, S3 |
| Already known | _Not yet asked — the first charting session with Sam fills this._ (Sam's PHP, JS and HTMX are a standing input for the web-application-security lessons.) |
| Expected to be hard | _Not yet asked — the first charting session with Sam fills this._ |
| Skills to load | from `.claude/skills/`: teach, research, handoff, wait-what |
| Standing preferences | authorised, isolated-lab-only offence; attack tooling in VMs; no working exploits for unpatched third-party bugs; defensive-only malware work; EICAR and synthetic files only |
| Umbrella ADRs | `project-management/src/08-DECISIONS/ADR-MS001-SECURITY-TRACK-AND-LAB-RULES-27-09-2026.md` |
| Primary resources | the S1–S3 lists in `ROADMAP.md`; OWASP, NIST SP 800-115 and 800-61, MITRE ATT&CK, kernel hardening docs, man pages |
| Register entries triaged | 0 closes, 2 blocks, 0 unrelated — from `GAPS.md` |

**Register triage is a claim, not a close.** This track is blocked by two `GAPS.md` entries:
"Security lab tools and the attacker VM" (Wireshark, clang with libFuzzer, AFL++, Ghidra, pwntools,
an intercepting proxy and the Juice Shop image are missing and there is no attacker VM yet; nmap,
tcpdump and libvirt are on the host, but attack tooling runs only in the VM) and "Fuzzing Rust needs
a nightly toolchain" (an Open question settled by ADR at `sec-03-fuzzing`). Nothing here edits
either register.

---

## Resolved decisions

| Node | Decision | Type | Settled | Became |
| --- | --- | --- | --- | --- |
| N-001 | Authorised, isolated-lab-only offensive work; defensive-only malware work | explain-first | 27/09/2026 | `project-management/src/08-DECISIONS/ADR-MS001-SECURITY-TRACK-AND-LAB-RULES-27-09-2026.md` |

---

## Slices

Filled at CUT; candidates in `ROADMAP.md` → S1, S2, S3.

| Slice | Milestone | Title | Nodes | Mastery (what must be true) | Flags |
| --- | --- | --- | --- | --- | --- |
| S-01 | — | cut after the blocking nodes resolve — candidates in `project-management/src/01-ROADMAP/ROADMAP.md` → S1/S2/S3 | — | — | — |

---

## Frontier

| Node | Decision | Type | Blocked by | Blocking a milestone? |
| --- | --- | --- | --- | --- |
| N-002 | How the lab network is proven isolated (QEMU `restrict=on` against a libvirt isolated network) | research | `research/PENTEST-LAB-NETWORK-ISOLATION.md` (planned) | yes |
| N-003 | Which vulnerable targets have licences that permit this use | research | `research/VULNERABLE-TARGET-LICENCES.md` (planned) | no |
| N-004 | The attacker-box VM image and the lab tooling install | spike | `GAPS.md` → "Security lab tools and the attacker VM" | no |

**Blocking a milestone?** N-002 blocks the S2 lab-setup milestone: no offensive exercise runs until
the network is shown to have no route to the home LAN.

---

## Fog of war

- Which legal training platforms (OverTheWire, pwn.college, picoCTF) are used for binary
  exploitation, and each one's rules on publishing solutions.
- Whether Secure Boot on real hardware is in scope at S3. The `DEFERRED.md` row "UEFI Secure Boot
  for Syntek OS images" covers the images only (taught on OVMF VMs in `sec-13-hardening-and-secure-boot`);
  real hardware waits for each profile's hardware ADR
  (`GAPS.md` → "No hardware chosen for the Syntek OS profiles").

---

## Out of scope

| Ruled out | Why |
| --- | --- |
| Offensive techniques against third-party systems | unlawful without authorisation (Computer Misuse Act) — `ADR-MS001-SECURITY-TRACK-AND-LAB-RULES-27-09-2026.md` |
| Working exploits for unpatched third-party bugs in the public repository | coordinated disclosure first — same ADR |
| Writing or storing live malware | defensive only; EICAR and synthetic files — same ADR; live-sample analysis parked in `DEFERRED.md` |
| Attack tooling on the host | it runs in VMs only — same ADR |

---

## Session log

| Date | Node settled | Outcome | Frontier redrawn |
| --- | --- | --- | --- |
| 27/09/2026 | N-001 | lab rules → `ADR-MS001-SECURITY-TRACK-AND-LAB-RULES-27-09-2026.md` | [x] |

---

## Gate to milestones

- [ ] Destination and out-of-scope bounds agreed with the learner
- [ ] Every open `GAPS.md` / `DEFERRED.md` entry triaged — closes, blocks or unrelated
- [ ] Every claimed entry names what will retire it; **neither register edited here**
- [ ] Every knowable decision is a node or sits in fog of war
- [ ] Every node typed and blocker-wired
- [ ] **Every node marked "blocking a milestone" is resolved**
- [ ] Every resolved node links to the artefact it became
- [ ] **Every slice has a mastery line and a flag manifest**
- [ ] Index row in `project-management/src/01-ROADMAP/CONTEXT.md` current

**Milestones may be cut in `project-management/workflows/02-milestone-creation/` once every box above
is ticked.** This map is `Charting`; those boxes are unticked by design.
