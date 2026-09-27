# Syllabus — sec-09-linux-privilege-escalation

**Track**: sec · **Phase**: S2 · **Path**: Later · **Detail**: outline · **Prerequisites**: sec-06 (lab and scope); sec-04 (the Linux security model)
**Status**: Planned · **Checked**: 27/09/2026 (sources re-verified by `/teach` step 3 before each lesson)

This topic teaches the misconfigurations that let a low-privilege user gain more privilege on a Linux
host — and, for each, the configuration that closes it. It is the defensive counterpart of `sec-04`:
having learned how permissions, setuid, sudo and capabilities are meant to work, Sam learns how they
are commonly got wrong, so the Syntek OS profiles ship without those mistakes. Every exercise runs on
deliberately misconfigured **lab VMs only**, within the `sec-06` scope; no technique is used against
any system Sam does not own, and the emphasis is always on recognising and fixing the weakness, not
on a weaponised recipe. It is an **outline** topic pending S2.

| # | Lesson | Size | Build | Lenses |
| --- | --- | --- | --- | --- |
| 01 | Enumeration: what a low-privilege user can learn | 1 sitting | no | Security, Safety |
| 02 | SUID and sudo misconfigurations, and the fix | 2–3 sittings | no | Security, Safety |
| 03 | Cron and PATH weaknesses, and the fix | 1 sitting | no | Security, Safety |
| 04 | Capabilities and writable services, and the fix | 2–3 sittings | no | Security, Safety |

---

## 01 — Enumeration: what a low-privilege user can learn

- **Objective:** Sam can list the information a low-privilege account can gather that indicates a
  privilege-escalation weakness, and read it as a defender.
- **Builds on:** sec-04 lesson 01 (users and permissions); sec-06 lab.
- **Key ideas:**
  - What is readable by any user (world-readable configs, process list, setuid binaries) and why it
    matters.
  - Enumeration is the same information an administrator uses to audit a host.
  - The output is a checklist of things to lock down.
- **Recall targets:** name categories of information that reveal a weakness and their defensive use.
- **Build:** none yet — defined when S2 opens; on lab VMs only.
- **Security lens:** enumeration turns into a hardening to-do list.
- **Safety:** lab VMs only, in scope; never a system Sam does not own (sec-01 lesson 05).
- **Sources:** (to verify when S2 opens) `man 7 credentials`; NIST SP 800-115, <https://csrc.nist.gov/pubs/sp/800/115/final>.
- **Done when:** Sam enumerates a lab VM and produces a hardening checklist.

## 02 — SUID and sudo misconfigurations, and the fix

- **Objective:** Sam can recognise a dangerous setuid binary or sudo rule and correct it.
- **Builds on:** lesson 01; sec-04 lesson 01.
- **Key ideas:**
  - Why an over-broad sudo rule or an unnecessary setuid-root binary is a risk (least privilege,
    sec-01).
  - Reading `sudoers` safely and scoping a rule to the exact command needed.
  - Removing the setuid bit where it is not required; the fix is the lesson.
- **Recall targets:** given a sudo rule, say whether it is over-broad and how to tighten it.
- **Build:** none yet — defined when S2 opens; misconfigured lab VM, then the fix.
- **Security lens:** this is the configuration the server edition (os-11) must get right.
- **Safety:** lab VMs only, in scope.
- **Sources:** (to verify when S2 opens) `man 8 sudo`, <https://man7.org/linux/man-pages/man8/sudo.8.html>; `man 5 sudoers`, <https://man7.org/linux/man-pages/man5/sudoers.5.html>.
- **Done when:** Sam tightens a sudo rule and removes an unnecessary setuid bit on a lab VM.

## 03 — Cron and PATH weaknesses, and the fix

- **Objective:** Sam can recognise unsafe cron jobs and PATH handling that allow escalation, and fix
  them.
- **Builds on:** lesson 02.
- **Key ideas:**
  - A root cron job running a writable script or relying on a mutable PATH is a weakness.
  - Absolute paths, safe permissions on scripts, and a fixed PATH as the fixes.
  - The same discipline applies to Syntek OS service scripts.
- **Recall targets:** say why a writable script in a root cron job is dangerous and how to fix it.
- **Build:** none yet — defined when S2 opens; lab VM.
- **Security lens:** feeds the service-hardening of os-11.
- **Safety:** lab VMs only, in scope.
- **Sources:** (to verify when S2 opens) `man 5 crontab`; NIST SP 800-115, <https://csrc.nist.gov/pubs/sp/800/115/final>.
- **Done when:** Sam fixes an unsafe cron job and PATH on a lab VM.

## 04 — Capabilities and writable services, and the fix

- **Objective:** Sam can recognise over-granted capabilities and writable service units, and correct
  them.
- **Builds on:** lesson 03; sec-04 lesson 02 (capabilities).
- **Key ideas:**
  - A binary with an excessive file capability, or a service file writable by a non-root user, allows
    escalation.
  - Granting the least capability and locking down service-file permissions as the fixes.
  - This closes the loop with sec-04: the model, then its common failures, then the fix.
- **Recall targets:** for an over-granted capability, name the least-privilege alternative.
- **Build:** none yet — defined when S2 opens; lab VM.
- **Security lens:** the capability discipline of sec-04 applied to a real (lab) host.
- **Safety:** lab VMs only, in scope.
- **Sources:** (to verify when S2 opens) `man 7 capabilities`, <https://man7.org/linux/man-pages/man7/capabilities.7.html>.
- **Done when:** Sam reduces an over-granted capability and secures a writable service on a lab VM.
