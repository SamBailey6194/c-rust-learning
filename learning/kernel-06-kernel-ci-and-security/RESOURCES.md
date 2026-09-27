# Resources — kernel-06-kernel-ci-and-security

| Lesson | Primary source (pinned) | House guide | Code |
| --- | --- | --- | --- |
| 01 The update pipeline by hand | <https://docs.kernel.org/admin-guide/kernel-parameters.html> (`panic=`; docs build 7.3.0-rc4); `qemu-system-x86_64 -help` (8.2.2: `-no-reboot`, `-nic none`) | `how-to/workflows/03-quality-gates/` — gates that fail loudly | the downstream kernel repository (created in kernel-05-downstream-tree) |
| 02 Automating the pipeline in CI | <https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/>; `man git-ls-remote`; <https://kernelci.org/> | `.github/workflows/` — this repository's CI as a model | the downstream kernel repository |
| 03 How kernel CVEs are assigned and published | <https://docs.kernel.org/process/cve.html> (Process; Invalid CVEs; Applicability); <https://git.kernel.org/pub/scm/linux/security/vulns.git/> (README, cve/schema; read 27/09/2026) | — | — |
| 04 Triaging a stable update's CVEs per profile | <https://docs.kernel.org/process/cve.html> (Applicability of specific CVEs); <https://docs.kernel.org/process/threat-model.html>; `man git-show` | `project-management/src/07-OS-PROFILES/` — each profile's threat model | the downstream kernel repository |
| 05 Stable cadence and a release checklist | <https://www.kernel.org/category/releases.html>; <https://docs.kernel.org/process/2.Process.html> (2.1 The big picture); `LICENSE` (Section 3) | `project-management/docs/VERIFICATION-GUIDE.md` — evidence for each item | the downstream kernel repository |
| 06 Regression triage with `git bisect` in QEMU | <https://docs.kernel.org/admin-guide/bug-bisect.html>; `man git-bisect` (run exit codes) | `code/workflows/07-debug/` — reproduce, shrink, fix | the downstream kernel repository |
