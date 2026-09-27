# Mission — kernel-06-kernel-ci-and-security

**Started**: not yet · **Family**: kernel · **Phase**: P5 · **Milestone**: not yet allocated

## Why

_Drafted from Sam's planning conversation of 27/09/2026 — confirm or rewrite in your own words at the first lesson._

In the planning conversation the downstream kernel came with a condition: automate it — pull each stable release,
apply the patches, build every edition's kernel and flag conflicts — and, once that CI exists, each upstream release
costs hours of his time. Sam also wants Syntek OS to be secure, and the same conversation flagged the router edition as "real security
responsibility". This topic gives the downstream both halves: a pipeline and CI that keep every profile's kernel
current and boot-tested in QEMU, and a method for reading the kernel's CVE stream and deciding what each update means
for each profile — the method the rest of Syntek OS's security process will reuse.

## Can do it when

- Take a new stable tag through the whole update — carry, build every profile, boot-test in QEMU — with one command.
- Run that pipeline automatically in CI, per profile, and read a failure from its report.
- Explain how the kernel's CVE team assigns and publishes CVEs, and read the records in `vulns.git`.
- Triage a stable update's CVEs per profile and keep the record.
- Release a downstream kernel by a written checklist, with evidence for each item.
- Find a regression by an unattended `git bisect run` whose every test boots in QEMU.

## Parked for later

- Triage for every Syntek OS package, release channels and end of life → os-16-release-and-security-process.
- Running the kernel's own self-tests and KUnit in the pipeline → not planned yet; a candidate for `DEFERRED.md`.
- Reporting security bugs to the kernel's security team → sec-16-detection-response-and-disclosure (disclosure) and
  kernel-07-upstreaming (sending patches).
- Fuzzing kernel interfaces → sec-03-fuzzing, and the security track's topic on testing Syntek OS (sec-14).
