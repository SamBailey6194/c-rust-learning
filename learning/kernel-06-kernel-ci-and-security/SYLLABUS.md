# Syllabus — kernel-06-kernel-ci-and-security

**Track**: kernel · **Phase**: P5 · **Path**: Core · **Detail**: full · **Prerequisites**: kernel-05-downstream-tree; tooling-03-shell-scripting; tooling-04-git-for-patch-series (its bisect lesson, 06); sec-01-principles-threat-modelling-and-law
**Status**: Planned · **Checked**: 27/09/2026 (sources re-verified by `/teach` step 3 before each lesson)

A downstream kernel is only as good as the routine that keeps it current and the judgement applied to each security
fix. This topic turns kernel-05's hand-carried series into a pipeline — new stable tag, apply the series, build every
profile, boot-test each in QEMU — then automates it, and **owns the kernel CVE triage method**: reading the kernel
CNA's records in `vulns.git` and deciding, per Syntek OS profile, what each update fixes for that profile. It adds a
release checklist and regression hunting with `git bisect` in QEMU. os-16-release-and-security-process generalises
the triage method to every package; the CI lessons apply os-05-build-system-and-reproducibility's "CI and build farms"
lesson. Everything built here lands in **the downstream kernel repository** created in kernel-05-downstream-tree, and
every kernel it boots, it boots in QEMU.

Version pins for this syllabus: docs.kernel.org pages were read on 27/09/2026 (documentation build 7.3.0-rc4);
`vulns.git` was read the same day (its README, its cve/schema file and the layout of cve/published/); the kernel CVE
announcement list's archive on lore.kernel.org refused scripted requests that day, so it was checked through
`vulns.git`'s README and the kernel's CVE document instead.

| # | Lesson | Size | Build | Lenses |
| --- | --- | --- | --- | --- |
| 01 | The update pipeline by hand: tag, series, profiles, boot test | 2–3 sittings | yes — pipeline script | Efficiency, Safety |
| 02 | Automating the pipeline in CI | multi-session build | yes — kernel CI | Efficiency, Security |
| 03 | How kernel CVEs are assigned and published | 1 sitting | no | Security |
| 04 | Triaging a stable update's CVEs per profile | 2–3 sittings | yes — triage tool | Security |
| 05 | Stable cadence and a release checklist | 1 sitting | yes — release checklist | Security |
| 06 | Regression triage with `git bisect` in QEMU | 2–3 sittings | yes — bisect runner | Safety |

---

## 01 — The update pipeline by hand: tag, series, profiles, boot test

- **Objective:** Sam can take a new stable tag through the whole update — carry the series, build every first-edition
  profile, boot-test each in QEMU — with one command that ends in pass or fail.
- **Builds on:** kernel-05-downstream-tree lessons 02–06; kernel-01-build-and-boot-in-qemu lesson 06 (the scripted
  boot); tooling-03-shell-scripting (exit status, `trap` and cleanup).
- **Key ideas:**
  - The pipeline's stages are fixed and ordered; each stage fails loudly, and a failure stops the run.
  - A boot test needs an unambiguous signal: the guest's init prints a marker and powers off; `panic=-1` with QEMU's
    `-no-reboot` turns a panic into QEMU exiting; a timeout catches a hang.
  - Build output, images and logs live outside git; only the scripts and the record of each run are kept.
  - Each run records the tag, the series' head commit and per-profile results.
- **Recall targets:** the stages in order and what each proves; how the boot test tells success, panic and hang
  apart; what a run record must contain to be reproducible.
- **Build:** a pipeline script in **the downstream kernel repository** that runs the stages for the base, server and
  homelab profiles. Checked by one real stable update passing end to end, and by a planted boot failure making the run
  fail at the right stage.
- **Efficiency lens:** time each stage per profile and set a budget for a full update run on this machine's 16
  threads; record budget against measured.
- **Safety:** every boot is a QEMU guest with no disk and no network.
- **Sources:** kernel parameters (<https://docs.kernel.org/admin-guide/kernel-parameters.html>, `panic=`);
  `qemu-system-x86_64 -help` (QEMU 8.2.2: `-no-reboot`, `-nic none`); stable rules
  (<https://docs.kernel.org/process/stable-kernel-rules.html>).
- **Done when:** one command takes a real stable tag to three booted profiles, and a planted failure is caught.

## 02 — Automating the pipeline in CI

- **Objective:** Sam can run the pipeline automatically whenever a new tag appears on the lines he tracks, and read
  its results without being at the machine.
- **Builds on:** lesson 01; os-05-build-system-and-reproducibility lesson 06 ("CI and build farms") if already taken —
  otherwise this lesson introduces triggers, matrices and artefacts itself; the P1 CI workflows in `.github/workflows/`
  as a model of gates that fail loudly.
- **Key ideas:**
  - A trigger notices new tags (for example by comparing `git ls-remote` against the last tag built).
  - A matrix runs one job per profile and line; every job is independent and reports separately.
  - QEMU with KVM is fast but needs the runner to offer it; without KVM QEMU emulates the CPU, which is slower but
    works anywhere — whether a given runner offers KVM is checked on the day, not assumed.
  - Artefacts and logs are kept for a set time; kernels and images are never committed.
  - KernelCI, the Linux Foundation project that tests upstream kernels at scale, is a model to read, not to copy.
- **Recall targets:** what starts a run; why each profile is its own job; what changes when KVM is not available.
- **Build:** the CI configuration in **the downstream kernel repository** running lesson 01's pipeline per profile.
  Checked by a real new tag producing a run with per-profile results, and by a deliberately broken patch failing it.
- **Efficiency lens:** CI minutes or local machine time per update, with and without KVM, against a budget.
- **Security lens:** the CI never holds signing keys it does not need, and build logs never print secrets.
- **Sources:** the stable repository (<https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/>, tags);
  `man git-ls-remote`; KernelCI (<https://kernelci.org/>); `qemu-system-x86_64 -help` (`-enable-kvm`).
- **Done when:** a new tag triggers a run on its own, and Sam reads a failure from the CI's report alone.

## 03 — How kernel CVEs are assigned and published

- **Objective:** Sam can explain how the kernel's own CVE Numbering Authority assigns and publishes CVEs, and where
  to read them in machine-readable form.
- **Builds on:** kernel-01-build-and-boot-in-qemu lesson 01 (supported lines);
  sec-01-principles-threat-modelling-and-law (vulnerabilities, coordinated disclosure).
- **Key ideas:**
  - The kernel CVE team assigns CVEs to fixes once they are applied to a stable tree, tracked by the fixing commit;
    it is deliberately cautious, so many bug fixes get CVEs.
  - No CVE is assigned for an unsupported kernel version, nor for a problem that exists only in a distribution's own
    changes — for Syntek OS's carried patches, the distribution itself is responsible.
  - Whether a CVE applies to a given system is the user's call, not the CVE team's; they recommend taking all stable
    changes together rather than cherry-picking.
  - `vulns.git` holds the records: its cve/published/ directory has a folder per year and, per CVE, the fixing
    commit (`.sha1`), the JSON record, the announcement mail and a `.dyad` file listing vulnerable-and-fixed version
    pairs per line; its scripts/cve_search maps a commit to its CVE and back.
  - The same announcements go to the linux-cve-announce list.
- **Recall targets:** when a kernel CVE is assigned and when it is not; who decides applicability; what each file per
  CVE holds.
- **Build:** none — Sam clones `vulns.git` outside every repository and reads the records for one recent stable
  update.
- **Security lens:** the CVE stream is an input to each profile's threat model, not a to-do list.
- **Sources:** "CVEs" (<https://docs.kernel.org/process/cve.html>, "Process", "Invalid CVEs" and "Applicability of
  specific CVEs"); `vulns.git` (<https://git.kernel.org/pub/scm/linux/security/vulns.git/>, README and cve/schema, read
  27/09/2026); "Security bugs" (<https://docs.kernel.org/process/security-bugs.html>).
- **Done when:** Sam explains the assignment rules unaided and reads a `.dyad` file to name the first fixed version on
  a line he tracks.

## 04 — Triaging a stable update's CVEs per profile

- **Objective:** Sam can take the CVEs fixed by a stable update and decide, for each Syntek OS profile, which fixes
  touch code that profile actually builds — and record the result.
- **Builds on:** lesson 03; kernel-04-kconfig-and-profile-configs lesson 06 (each profile's configuration);
  sec-01-principles-threat-modelling-and-law (threat models).
- **Key ideas:**
  - From each CVE's fixing commit, the files it changed; from a profile's build output, whether those files were
    compiled at all — code a profile does not build cannot be exploited in it.
  - Reachability matters next: a compiled driver for hardware the profile never has, or an interface the profile's
    threat model keeps closed, lowers the priority without removing the fix.
  - The default stays "take the whole stable update"; triage decides urgency and communication, not which fixes to
    skip.
  - The kernel's threat model separates vulnerabilities from weaknesses — a bug that needs another breach first.
  - Records per update and per profile make later questions answerable; os-16-release-and-security-process reuses
    the method for every package.
- **Recall targets:** the steps from CVE to per-profile verdict; why "not compiled" is strong evidence and "not
  reachable" is weaker; why triage does not mean cherry-picking.
- **Build:** a triage tool in **the downstream kernel repository** that, for a stable range, lists each CVE fixed,
  the files its fix touched, and which profiles compiled those files. Checked against a hand triage of one real update
  for the server profile.
- **Security lens:** the triage record is the kernel part of each profile's security process.
- **Sources:** "CVEs" (<https://docs.kernel.org/process/cve.html>, "Applicability of specific CVEs"); "The Linux Kernel
  threat model" (<https://docs.kernel.org/process/threat-model.html>, "What classes of problems are not considered
  vulnerabilities"); `vulns.git` cve/schema (<https://git.kernel.org/pub/scm/linux/security/vulns.git/>);
  `man git-show`.
- **Done when:** the tool's output for one real update matches Sam's hand triage, and the record is written for each
  first-edition profile.

## 05 — Stable cadence and a release checklist

- **Objective:** Sam can plan the downstream's release rhythm around upstream's and release a kernel by a written
  checklist.
- **Builds on:** lessons 01–04; kernel-05-downstream-tree lessons 05–07 (versioning, reproducibility, GPL
  obligations).
- **Key ideas:**
  - Stable updates arrive as needed, usually weekly; longterm lines see fewer; mainline every 9–10 weeks.
  - A checklist turns a release into steps anyone can verify: verified base tag, series carried and `range-diff`
    reviewed, every profile built reproducibly and booted, CVE triage recorded, release string set, source release
    (fragments, series, scripts) published under the GPL.
  - End-of-life dates on the release page drive when a profile has to move line.
- **Recall targets:** the checklist's items and what each one guards against; how often each line needs a release.
- **Build:** the release checklist in **the downstream kernel repository**, used for one real release to Sam's own
  test images. Checked by every item being ticked with evidence.
- **Security lens:** a release that skips triage or verification is not released.
- **Sources:** kernel.org releases (<https://www.kernel.org/category/releases.html>, cadence and end-of-life dates);
  "How the development process works" (<https://docs.kernel.org/process/2.Process.html>, 2.1 The big picture);
  `LICENSE` (GPL version 2, Section 3).
- **Done when:** one release is made by the checklist, with evidence for every item.

## 06 — Regression triage with `git bisect` in QEMU

- **Objective:** Sam can find the commit that broke a boot or a behaviour between two kernels by bisecting, first by
  hand and then automatically, with every test run in QEMU.
- **Builds on:** tooling-04-git-for-patch-series lesson 06 (`git bisect` by hand, then `bisect run`); lesson 01's
  pipeline.
- **Key ideas:**
  - Bisection needs a known-good and a known-bad commit and a test that separates them; each step halves the range.
  - `git bisect run` drives a script: exit 0 means good, 1–127 (except 125) bad, 125 "skip this commit" — used when a
    commit cannot be built.
  - The script builds, boots in QEMU and checks the behaviour, so a whole bisection runs unattended.
  - The kernel's own guide adds practical advice: keep a prepared `.config` as a pristine base for every step (run
    `olddefconfig` on it), be certain of each good or bad verdict, save the bisect log, and validate the result by
    reverting the culprit on top of the latest code.
- **Recall targets:** the exit-code contract of `bisect run`; how many steps a range of a given size takes; why one
  wrong verdict ruins a bisection; how to confirm the culprit.
- **Build:** a bisect runner script in **the downstream kernel repository**, practised on a regression Sam plants in a
  throwaway branch of his own series. Checked by the bisection naming the planted commit.
- **Safety:** every candidate kernel boots in QEMU only.
- **Sources:** "Bisecting a regression" (<https://docs.kernel.org/admin-guide/bug-bisect.html>, "Finding the change
  causing a kernel issue using a bisection"); `man git-bisect` (the `run` exit codes).
- **Done when:** an unattended bisection names the planted commit, and Sam confirms it by reverting it.
