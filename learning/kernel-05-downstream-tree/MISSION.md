# Mission — kernel-05-downstream-tree

**Started**: not yet · **Family**: kernel · **Phase**: P5 · **Milestone**: not yet allocated

## Why

_Drafted from Sam's planning conversation of 27/09/2026 — confirm or rewrite in your own words at the first lesson._

Sam asked whether he could "use the standard Linux kernel as a base and create a downstream, bringing in updates via
upstream", and he decided that is what Syntek OS's kernel will be: kernel.org's stable tree as a remote, a small patch
series rebased onto each release, per-profile configs, and upstreaming whatever can be upstreamed. He also asked what
his own kernel would cost; the answer was mostly time — hours per upstream release once the process is in place —
plus the GPL-2.0 obligation to publish the source of what he distributes. This topic builds that downstream for real,
in the downstream kernel repository, and makes carrying it across releases a routine he can repeat every week.

## Can do it when

- Explain upstream, downstream and fork, and why Syntek OS is a downstream.
- Run the downstream kernel repository: the stable remote, verified tags, one branch per line in use.
- Write kernel-style patches with sign-offs, and round-trip a series through `format-patch` and `am`.
- Carry the series onto a new stable release, resolve conflicts with `rerere`, and review the carry with `range-diff`.
- Give every build a predictable release string under a written naming scheme.
- Build the same kernel twice and get identical images, or account for every difference.
- State what distributing an image obliges him to publish under the GPL-2.0.
- Drop patches upstream has absorbed, with a record of each.

## Parked for later

- Automating the carry, building every profile and boot-testing in CI → kernel-06-kernel-ci-and-security.
- CVE triage for the carried lines → kernel-06-kernel-ci-and-security.
- Sending patches upstream → kernel-07-upstreaming.
- Signing kernels and modules for Secure Boot → sec-13-hardening-and-secure-boot and `DEFERRED.md`.
- Publishing images and their source releases → os-16-release-and-security-process.
