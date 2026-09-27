# Syllabus — sec-07-recon-and-network-security

**Track**: sec · **Phase**: S2 · **Path**: Later · **Detail**: outline · **Prerequisites**: sec-06 (the lab exists and has a scope); P4 networking
**Status**: Planned · **Checked**: 27/09/2026 (sources re-verified by `/teach` step 3 before each lesson)

This topic teaches how a defender reads a network the way an attacker would: discovering hosts and
services, capturing and analysing traffic, and recognising the misconfigurations that expose a
system — always ending in the defensive fix. Every exercise runs against Sam's own lab targets from
`sec-06`, inside the isolated network, under the written scope; nothing runs against the home network
or any third party. It is an **outline** topic pending S2 and the lab tooling in `GAPS.md`. `nmap`
and `tcpdump` happen to be installed on the host (`GAPS.md`), but under the lab rules every scan and
capture in this topic runs from the attacker VM against lab targets — never from the host.

| # | Lesson | Size | Build | Lenses |
| --- | --- | --- | --- | --- |
| 01 | Host and service discovery with nmap | 2–3 sittings | no | Security, Safety |
| 02 | Service enumeration and version detection | 1 sitting | no | Security, Safety |
| 03 | Packet capture and analysis | 2–3 sittings | no | Security, Safety |
| 04 | Common network misconfigurations and their fixes | 2–3 sittings | no | Security, Safety |

---

## 01 — Host and service discovery with nmap

- **Objective:** Sam can discover the hosts and open ports of his lab network with nmap and read the
  results.
- **Builds on:** sec-06 (the isolated lab); sec-01 lesson 02 (attack surface).
- **Key ideas:**
  - Host discovery and port scanning at a conceptual level; what an open port reveals as attack
    surface.
  - Reading a scan as the system's own administrator — the same output tells you what to close.
  - Scanning is only ever run against Sam's own lab targets within scope.
- **Recall targets:** interpret a scan result as a list of exposed services to review.
- **Build:** none yet — defined when S2 opens; scans run inside the lab only.
- **Security lens:** the scan is the attack-surface list (sec-01) made concrete for a running system.
- **Safety:** nmap runs only against lab targets in scope; never the home network or a third party
  (Computer Misuse Act 1990, sec-01 lesson 05).
- **Sources:** (to verify when S2 opens) Nmap reference guide, <https://nmap.org/book/man.html>; `man nmap` (read on the host; run in the attacker VM).
- **Done when:** Sam scans his lab and lists the exposed services to close or justify.

## 02 — Service enumeration and version detection

- **Objective:** Sam can enumerate a discovered service and identify its version to check it against
  known issues.
- **Builds on:** lesson 01.
- **Key ideas:**
  - From open port to identified service and version; why version detection matters for patching.
  - Mapping a version to a fix (the defender's use of the same information).
  - Enumeration stays within the lab scope.
- **Recall targets:** say what version detection is for from a defender's point of view.
- **Build:** none yet — defined when S2 opens.
- **Security lens:** knowing what runs and its version is the basis of patch management (feeds os-11).
- **Safety:** lab targets in scope only.
- **Sources:** (to verify when S2 opens) Nmap reference guide, <https://nmap.org/book/man.html>.
- **Done when:** Sam enumerates a lab service and records its version and patch status.

## 03 — Packet capture and analysis

- **Objective:** Sam can capture and read traffic on the lab network with tcpdump and Wireshark.
- **Builds on:** lesson 01; os-09 traffic-observation lesson.
- **Key ideas:**
  - Capturing on a lab interface; filtering to the traffic of interest; reading a handshake.
  - Seeing plaintext versus encrypted traffic (the sec-05 TLS distinction on the wire).
  - Capture is on the lab network only — capturing others' traffic is out of scope and unlawful.
- **Recall targets:** describe what a capture shows about a service and why TLS changes the picture.
- **Build:** none yet — defined when S2 opens.
- **Security lens:** reading traffic reveals what a service exposes and whether it is encrypted.
- **Safety:** capture only on the isolated lab network; never on shared or third-party networks.
- **Sources:** (to verify when S2 opens) tcpdump manual, <https://www.man7.org/linux/man-pages/man8/tcpdump.8.html>; Wireshark User's Guide, <https://www.wireshark.org/docs/wsug_html_chunked/>.
- **Done when:** Sam captures and explains a lab exchange, distinguishing encrypted from plaintext.

## 04 — Common network misconfigurations and their fixes

- **Objective:** Sam can recognise common network misconfigurations on his lab targets and apply the
  defensive fix.
- **Builds on:** lessons 01–03; sec-04 (the security model behind the fixes).
- **Key ideas:**
  - Exposed services, weak defaults, unnecessary open ports, unencrypted protocols — recognised, then
    closed.
  - Every finding pairs with its remediation; the point of the lesson is the fix, not the finding.
  - The findings feed the Syntek OS server and router hardening (os-11, os-14).
- **Recall targets:** for a given misconfiguration, state the fix.
- **Build:** none yet — defined when S2 opens.
- **Security lens:** recon exists here to drive hardening.
- **Safety:** lab targets in scope only.
- **Sources:** (to verify when S2 opens) OWASP Web Security Testing Guide, <https://owasp.org/www-project-web-security-testing-guide/>; NIST SP 800-115, <https://csrc.nist.gov/pubs/sp/800/115/final>.
- **Done when:** Sam finds and fixes at least one misconfiguration on a lab target and records both.
