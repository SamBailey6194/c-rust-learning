# ADR-MS001: Kernel — a downstream of upstream Linux, not a fork and not from scratch

| Field | Value |
| --- | --- |
| **ID** | ADR-MS001-KERNEL-DOWNSTREAM-OF-UPSTREAM |
| **Status** | Accepted |
| **Date** | 27/09/2026 |
| **Milestone** | MS001 — Toolchain ready · `project-management/src/02-MILESTONES/MS001-TOOLCHAIN-READY.md` |
| **Deciders** | Sam Bailey |
| **Supersedes** | — |
| **Superseded by** | — |
| **Research** | — (primary sources cited below); the per-profile line choice follows in `research/LTS-VS-STABLE-PER-PROFILE.md` (planned — written with the `research` skill before the first P5 milestone) |
| **Enforced in** | `project-management/src/01-ROADMAP/ROADMAP.md` → P5 · `project-management/src/06-KERNEL/` (every plan records its base tag) · `code/src/kernel/` (planned — added at P4) for the lesson fragments and practice patches of `kernel-01` to `kernel-04` · the downstream kernel repository (created in `kernel-05-downstream-tree` lesson 02) for the profile fragments, the patch series and the kernel CI |

---

## Context

Syntek OS needs a kernel, and P5 is where the learner stops building someone else's kernel and
starts maintaining their own. The question is what "their own" means. Sam asked it directly in his
planning conversation of 27/09/2026 (Q12): use the standard Linux kernel as a base and create a
downstream, bringing in updates from upstream. Earlier questions (Q2, Q13) established that real
kernel edits need C, and asked what a kernel of one's own would cost.

Facts checked on 27/09/2026:

- **Release lines.** kernel.org publishes mainline releases every 9 to 10 weeks. After release a
  kernel is "stable", and fixes are backported to it from mainline by a stable maintainer, roughly
  weekly; a few lines are designated longterm and receive only important fixes for years
  (Sources, item 1). On the day: mainline 7.3-rc4, stable 7.2.8, and longterm 6.18.54, 6.12.111,
  6.6.157, 6.1.188, 5.15.221 and 5.10.270 (Sources, item 2). Projected end of life runs from
  December 2026 (5.10, 5.15) to December 2028 (6.12, 6.18).
- **What reaches stable.** A patch is accepted into a stable tree only if it, or an equivalent fix,
  already exists in mainline; it has to be obviously correct and tested, and at most 100 lines with
  context (Sources, item 3). A fix that exists only downstream never arrives from stable.
- **The remote exists and is reachable.** `git ls-remote` against the stable repository on
  git.kernel.org lists the tags `v6.18.54` and `v7.2.8` (Sources, item 4) — the tags a downstream
  branch would rebase onto.
- **Distributions already work this way.** kernel.org notes that many distributions ship their own
  longterm kernels, which may or may not be based on kernel.org's (Sources, item 1).
- **Licence.** The kernel is GPL-2.0 with the Linux syscall exception (Sources, item 5). Under GPL
  version 2, Section 3, distributing a binary means accompanying it with the complete corresponding
  source, or a written offer of it valid for at least three years (the repository's own `LICENSE`,
  Section 3). This repository distributes no kernel binaries; a Syntek OS image would.
- **Tooling for a series.** The kernel's patch discipline (a `Signed-off-by:` certifying the
  Developer's Certificate of Origin 1.1) and its reproducible-build variables
  (`KBUILD_BUILD_TIMESTAMP`, `KBUILD_BUILD_USER`, `KBUILD_BUILD_HOST`) are documented upstream
  (Sources, items 6 and 7) and taught in P5.

## Options considered

### Option A — A downstream: track kernel.org, carry a small series, keep per-profile configs

- **Summary:** Add kernel.org's stable repository as a git remote; keep one branch per line in use;
  carry a small patch series on top, rebased onto each new stable or longterm tag; keep a Kconfig
  fragment per Syntek OS profile. Start near-vanilla, with configs doing most of the work.
- **Pros:** Every upstream fix and security update arrives with the next tag at the cost of a rebase.
  Maintaining a series (format-patch, am, range-diff, conflicts) is exactly the skill P5 teaches. The
  kernel CVE process and the stable cadence can be followed as published. Configs rarely conflict on
  rebase.
- **Cons:** Every release costs a rebase, a build of each profile and a QEMU boot; that work never
  ends while the kernel ships. A patch that upstream will not take becomes a permanent carry.

### Option B — A fork

- **Summary:** Branch once and merge upstream occasionally, carrying changes indefinitely.
- **Pros:** Freedom to change anything.
- **Cons:** Divergence grows with each skipped merge, and each merge gets harder. Stable fixes stop
  applying cleanly, so security updates become manual backports.

### Option C — A kernel from scratch

- **Summary:** Write a new kernel.
- **Pros:** The deepest possible lesson in operating-system design.
- **Cons:** Years of work before it boots real hardware; the answer in the conversation (Q13) named
  drivers as the barrier. Not a base a distribution can ship on.

### Option D — Another distribution's kernel package as the base

- **Summary:** Build from, for example, a Debian or Arch kernel source package.
- **Pros:** Someone else's config and patches as a starting point.
- **Cons:** Inherits that distribution's decisions and cadence, which contradicts Syntek OS's
  independence (`ADR-MS001-SYNTEK-OS-INDEPENDENT-FROM-SCRATCH-27-09-2026.md`).

### Option E — Vanilla only: upstream tags and configs, never a patch

- **Summary:** Option A without a series.
- **Pros:** No rebase work.
- **Cons:** No way to carry a fix before upstream takes it, and no practice at series maintenance,
  which is half of P5.

## Decision

**We will take Option A: Syntek OS's kernel is a downstream of upstream Linux.** The deciding factor
is that the stable and longterm trees keep delivering fixes that a fork would have to backport by
hand, while a small carried series still teaches the maintenance P5 exists for. Option E was the
runner-up and remains the starting state: the series begins empty and grows only when a patch earns
its place.

This answer changes if carrying the series across a stable release repeatedly takes longer than one
milestone, or if a feature Syntek OS needs cannot be upstreamed and grows into a divergence. Either
would be argued in a new ADR that supersedes this one.

## Consequences

- **Positive:** Security fixes arrive through the stable process. The same method serves every
  profile; only the fragment differs. P5's exit gate becomes checkable: the base and first-edition
  (server and homelab) fragments build and boot in QEMU on a recorded tag.
- **Negative:** A standing cost per release (rebase, build, boot-test) that CI has to carry
  (`kernel-06-kernel-ci-and-security`). Distributing an image with this kernel brings the GPL-2.0
  source obligation with it.
- **Follow-on:**
  - To confirm — the split recommended in the conversation, longterm lines for the server, NAS,
    homelab and router profiles and stable for the desktop profiles, is researched per profile in
    `research/LTS-VS-STABLE-PER-PROFILE.md` (planned) and recorded in each
    `project-management/src/07-OS-PROFILES/PROFILE-<NAME>.md` → Kernel config + update cadence.
  - To confirm — "upstream what can be upstreamed" was the conversation's recommendation; it is
    taught in `kernel-07-upstreaming` (a Later topic) and adopted per patch.
  - Kernel CVE triage per profile follows the kernel CNA's published process (Sources, item 8),
    taught in `kernel-06-kernel-ci-and-security`.
  - The downstream tree, its profile fragments, its series and its CI live in the downstream kernel
    repository from `kernel-05-downstream-tree` lesson 02, when that build starts
    (`ADR-MS001-ROADMAP-KERNEL-OS-UI-LLM-TRACKS-27-09-2026.md` → the repository boundary); this
    repository keeps the lesson-sized fragments and practice patches of `kernel-01` to `kernel-04`.

## Sources

1. **kernel.org, Active kernel releases** — <https://www.kernel.org/category/releases.html> —
   mainline, stable and longterm definitions and cadence; the longterm table with projected end of
   life; distributions' own longterm kernels, checked 27/09/2026
2. **kernel.org front page** — <https://www.kernel.org/> — the versions current on 27/09/2026
3. **Everything you ever wanted to know about Linux -stable releases** —
   <https://docs.kernel.org/process/stable-kernel-rules.html> — upstream-first rule and size limit,
   checked 27/09/2026
4. **Host command, 27/09/2026** —
   `git ls-remote https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git refs/tags/v6.18.54 refs/tags/v7.2.8`
   — both tags listed
5. **Linux kernel licensing rules** — <https://docs.kernel.org/process/license-rules.html> —
   GPL-2.0 with the syscall exception, checked 27/09/2026
6. **Submitting patches** — <https://docs.kernel.org/process/submitting-patches.html> — the
   Developer's Certificate of Origin 1.1 and `Signed-off-by:`, checked 27/09/2026
7. **Reproducible builds (kbuild)** — <https://docs.kernel.org/kbuild/reproducible-builds.html> —
   `KBUILD_BUILD_TIMESTAMP`, `KBUILD_BUILD_USER`, `KBUILD_BUILD_HOST`, checked 27/09/2026
8. **CVEs (kernel process)** — <https://docs.kernel.org/process/cve.html> — the kernel CNA and the
   linux-cve-announce list, checked 27/09/2026
9. **Sam's planning conversation, 27/09/2026** — Q12 (the decision), Q2 and Q13 (context)
