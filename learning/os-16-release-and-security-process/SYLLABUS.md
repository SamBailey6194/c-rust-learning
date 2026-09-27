# Syllabus — os-16-release-and-security-process

**Track**: os · **Phase**: P6 · **Path**: Core · **Detail**: full · **Prerequisites**: `os-10-profiles-and-installer`; `kernel-06-kernel-ci-and-security` lessons 03–05 (how kernel CVEs are assigned, triage per profile, the kernel release checklist); `os-05-build-system-and-reproducibility` and `os-08-repositories-signing-and-updates` via `os-10`; `sec-01-principles-threat-modelling-and-law` lesson 06 (coordinated vulnerability disclosure, for lesson 02); `sec-16-detection-response-and-disclosure` lesson 05 recommended, if taken (a disclosure policy and `security.txt`)
**Status**: Planned · **Checked**: 27/09/2026 (sources re-verified by `/teach` step 3 before each lesson)

Shipping the first edition is not the end of the work but the start of a promise: security fixes
arrive for every package it ships, releases are numbered and supported for a stated time, and people
can find out how to use it and whom to tell about a problem. This topic generalises `kernel-06`'s
kernel CVE triage to every package, turns it into advisories, fixes how Syntek OS releases are
versioned, channelled and ended, runs a release through a checklist in the lab, and writes the
documentation each profile's reader needs. Contributor infrastructure is `tooling-05`'s, not this
topic's. Small exercises land under `code/src/` (`msNNN` paths and `code/src/os/` are planned); the
production security tracker and release tooling land in the Syntek OS build-system repository,
created when that build starts.

| # | Lesson | Size | Build | Lenses |
| --- | --- | --- | --- | --- |
| 01 | Tracking vulnerabilities across packages | 2–3 sittings | yes — advisory matcher | Security |
| 02 | Advisories and coordinated fixes | 1 sitting | yes — one advisory, validated | Security |
| 03 | Versioning and release channels | 1 sitting | no | Security |
| 04 | Support windows and end of life | 1 sitting | no | Security |
| 05 | The release checklist and a dry-run release | multi-session build | yes — release dry run | Efficiency, Security, Safety |
| 06 | Documentation and support | 1 sitting | yes — server edition docs skeleton | — |

---

## 01 — Tracking vulnerabilities across packages

- **Objective:** Sam can apply `kernel-06`'s triage method to every package Syntek OS ships: which
  feeds to watch, how to match an advisory to the exact version and patches shipped, and how to
  decide "affected" per profile.
- **Builds on:** `kernel-06-kernel-ci-and-security` lessons 03–04 (the kernel CNA's assignments and
  per-profile triage); `os-07-package-manager` lesson 02 (package metadata); `os-10-profiles-and-installer`
  lesson 01 (which packages each profile ships).
- **Key ideas:**
  - The kernel's CNA assigns CVEs to fixes and publishes them on its own channels (`kernel-06`); other
    upstreams are covered by CVE records and by OSV records, which state affected version ranges per
    ecosystem.
  - Distributions' trackers (Debian, Arch, Alpine's secdb) are prior art for the question that
    matters: is our build affected, not just the upstream version.
  - A backported patch changes the answer: matching uses the upstream version plus the patches
    applied, never the name alone.
  - Triage is per profile — a package the router does not ship does not affect the router.
- **Recall targets:** why a version match alone is not enough; what an OSV "affected" entry holds;
  what per-profile triage saves.
- **Build:** a small Rust library and CLI that reads a package manifest (name, upstream version,
  applied patch identifiers, profiles) and a directory of OSV-format records, and reports affected
  packages per profile — `code/src/rust/crates/msNNN_advisory_match/` (planned); checked by
  `cargo test` with synthetic records, including a backported-fix case that must not be reported. The
  production tracker lands in the Syntek OS build-system repository (created when this build starts).
- **Security lens:** a missed advisory is an unpatched edition; a false "affected" wastes the
  maintainer's time — both are measured in the tests.
- **Sources:** docs.kernel.org, "CVEs" (v7.3-rc4 render), <https://docs.kernel.org/process/cve.html>;
  OSV schema 1.9.0 (06/08/2026), <https://ossf.github.io/osv-schema/>; CVE Program,
  <https://www.cve.org/>; Debian security tracker, <https://security-tracker.debian.org/tracker/>;
  Arch Linux security tracker, <https://security.archlinux.org/>; Alpine secdb,
  <https://secdb.alpinelinux.org/>.
- **Done when:** the tests pass, including the backport case, and Sam explains each match decision.

## 02 — Advisories and coordinated fixes

- **Objective:** Sam can write a machine-readable security advisory for a Syntek OS package and say
  how a fix is coordinated before it is published.
- **Builds on:** lesson 01; `sec-01-principles-threat-modelling-and-law` lesson 06 (coordinated
  vulnerability disclosure); `sec-16-detection-response-and-disclosure` lesson 05 recommended, if
  taken (writing a disclosure policy).
- **Key ideas:**
  - An advisory states what is affected, what is fixed, how severe it is and what the user should do.
  - Two machine-readable formats: OSV (lesson 01's format) and OASIS CSAF 2.0.
  - A fix for an unpublished issue waits for the coordinated date (`sec-01` lesson 06); writing the
    disclosure policy and the security contact (security.txt, RFC 9116) is `sec-16`'s, if taken.
- **Recall targets:** the fields an advisory cannot omit; what changes before and after the public
  date.
- **Build:** an OSV-format advisory for a synthetic issue in a Syntek OS package, validated by lesson
  01's parser in a new test in `code/src/rust/crates/msNNN_advisory_match/` (planned).
- **Security lens:** an advisory that overstates or understates impact misleads the people it is for.
- **Sources:** OSV schema 1.9.0, <https://ossf.github.io/osv-schema/>; Common Security Advisory
  Framework 2.0 Errata 01 (OASIS, 26/01/2024), <https://docs.oasis-open.org/csaf/csaf/v2.0/csaf-v2.0.html>;
  RFC 9116, <https://www.rfc-editor.org/rfc/rfc9116>.
- **Done when:** the advisory passes the parser's test and Sam explains each field.

## 03 — Versioning and release channels

- **Objective:** Sam can choose how Syntek OS releases and its tools are versioned and which channels
  exist, and record the choice.
- **Builds on:** `os-10-profiles-and-installer` (one base for all profiles); `os-07-package-manager`
  lesson 07 (the library API its consumers depend on).
- **Key ideas:**
  - Semantic Versioning suits Syntek OS's libraries and tools: a breaking API change is a major
    version, which tells consumers such as the package-manager TUI what they must change.
  - A distribution release is versioned for people and recorded for machines in `os-release`
    (`VERSION_ID`, `IMAGE_VERSION`, `BUILD_ID`).
  - Channels (for example stable and testing) are the same for every profile, because the base is
    shared.
  - Alpine as a model: a release branch each May and November, the main repository typically
    supported for two years and the community repository until the next stable release.
- **Recall targets:** when a tool's major version must change; which `os-release` field a tool reads
  for the release; what one base means for channels.
- **Build:** none — the output is a release-versioning ADR draft through
  `project-management/workflows/08-decisions/`.
- **Security lens:** consumers of an unannounced breaking change skip updates, security ones included.
- **Sources:** Semantic Versioning 2.0.0, <https://semver.org/spec/v2.0.0.html>; `man 5 os-release`
  (systemd 255); Alpine Linux, "Alpine release branches", <https://alpinelinux.org/releases/>.
- **Done when:** the ADR draft states the scheme, the channels and the reasons.

## 04 — Support windows and end of life

- **Objective:** Sam can set a support window for a Syntek OS release that its parts can actually
  honour, and publish its end date.
- **Builds on:** lesson 03; `kernel-04-kconfig-and-profile-configs` lesson 04 (longterm or stable, per
  profile).
- **Key ideas:**
  - Support is bounded by what Syntek OS does not control: a longterm kernel line has a projected
    end of life that usually starts at about two years and may be extended.
  - A release's support end cannot outlast its kernel line's unless the release moves to a newer
    line.
  - `SUPPORT_END` in `os-release` gives the first day without support, so tools can warn.
  - The server family's longterm kernels and the desktops' stable kernels give different windows.
- **Recall targets:** what bounds a release's support; what `SUPPORT_END` means exactly; why
  profiles differ.
- **Build:** none — the output is the first edition's end-of-life table, carried into lesson 05's
  checklist.
- **Security lens:** a system past its support end receives no security fixes; saying so plainly is
  part of the job.
- **Sources:** kernel.org, "Active kernel releases" (longterm table, projected EOL),
  <https://www.kernel.org/category/releases.html>; `man 5 os-release` (`SUPPORT_END`, systemd 255).
- **Done when:** the table gives each profile a window traceable to its kernel line.

## 05 — The release checklist and a dry-run release

- **Objective:** Sam can take a server edition release through a checklist in the lab, with each
  automated gate run and each manual step signed off.
- **Builds on:** `kernel-06-kernel-ci-and-security` lesson 05 (the kernel release checklist);
  `os-05-build-system-and-reproducibility` lessons 04–06 (reproducible builds, CI);
  `os-08-repositories-signing-and-updates` (signing and publishing); `os-10-profiles-and-installer`
  lesson 07 (boot tests); lessons 01–04.
- **Key ideas:**
  - A release is a checklist, not a feeling: reproducibility checked, every profile image passing its
    boot tests, vulnerability triage clean or each waiver reasoned, repository metadata signed and
    published, `os-release` values and release notes written, and a way back if it goes wrong.
  - Automate every gate that can be automated; the checklist records the rest by hand.
  - The kernel half of the checklist is `kernel-06`'s.
- **Recall targets:** the gates in order and what each proves; what the way back is for a bad release.
- **Build:** a release checklist and a dry-run script in `code/src/os/` (planned — added at P6) that
  runs each automated gate against a lab release of the server edition and prints the checklist with
  pass or fail per item. The real release tooling lands in the Syntek OS build-system repository
  (created when this build starts).
- **Efficiency lens:** pipeline time, and image sizes against each profile's budget, recorded per
  release.
- **Security lens:** a release signed from an unreproducible build, or with unreviewed advisories, is
  a supply-chain risk.
- **Safety:** the dry run publishes only to a local lab repository.
- **Sources:** SOURCE_DATE_EPOCH, <https://reproducible-builds.org/docs/source-date-epoch/>;
  `man 5 os-release` (systemd 255); The Update Framework specification 1.0.36,
  <https://theupdateframework.github.io/specification/latest/>.
- **Done when:** the dry run passes end to end and fails when one gate is broken on purpose.

## 06 — Documentation and support

- **Objective:** Sam can plan and start the documentation for an edition so each kind of reader finds
  what they need, and state what support is offered.
- **Builds on:** lessons 03–05; the house guide on writing guides (`how-to/docs/GUIDE-CRAFT.md`).
- **Key ideas:**
  - Documentation serves four needs, following Diataxis: tutorials (learning), how-to guides (a
    task), reference (facts) and explanation (why).
  - Each profile has its own reader: a beginner desktop user and a server administrator need
    different tutorials.
  - Release notes are reference plus how-to (what changed, how to upgrade).
  - Support has a scope and an end date (lesson 04); security reports go through the edition's
    disclosure policy (`sec-01` lesson 06; `sec-16` lesson 05 if taken).
- **Recall targets:** the four kinds of documentation and the question each answers; what release
  notes must contain.
- **Build:** a documentation skeleton for the server edition — an install tutorial, a how-to for
  adding an admin, a reference for the machine configuration keys of `os-10` lesson 02, and an
  explanation of why updates are signed — in the Syntek OS build-system repository that ships the
  edition (created when this build starts); checked by markdownlint and by someone following the tutorial in
  a VM.
- **Sources:** Diataxis, <https://diataxis.fr/>; `how-to/docs/GUIDE-CRAFT.md`.
- **Done when:** the skeleton passes markdownlint and a tester completes the tutorial unaided.
