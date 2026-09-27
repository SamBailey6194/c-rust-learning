# Resources — os-16-release-and-security-process

| Lesson | Primary source (pinned) | House guide | Code |
| --- | --- | --- | --- |
| 01 Tracking vulnerabilities across packages | docs.kernel.org "CVEs", <https://docs.kernel.org/process/cve.html>; OSV schema 1.9.0, <https://ossf.github.io/osv-schema/>; Debian security tracker, <https://security-tracker.debian.org/tracker/> | `code/docs/RUST-CODING-PRINCIPLES.md`; `code/docs/TESTING.md` | `code/src/rust/crates/msNNN_advisory_match/` (planned) |
| 02 Advisories and coordinated fixes | OSV schema 1.9.0; CSAF 2.0 Errata 01, <https://docs.oasis-open.org/csaf/csaf/v2.0/csaf-v2.0.html>; RFC 9116, <https://www.rfc-editor.org/rfc/rfc9116> | `SECURITY.md` | `code/src/rust/crates/msNNN_advisory_match/` (planned) |
| 03 Versioning and release channels | Semantic Versioning 2.0.0, <https://semver.org/spec/v2.0.0.html>; `man 5 os-release`; Alpine release branches, <https://alpinelinux.org/releases/> | `project-management/workflows/08-decisions/` | — |
| 04 Support windows and end of life | kernel.org "Active kernel releases", <https://www.kernel.org/category/releases.html>; `man 5 os-release` (`SUPPORT_END`) | — | — |
| 05 The release checklist and a dry-run release | <https://reproducible-builds.org/docs/source-date-epoch/>; The Update Framework specification 1.0.36, <https://theupdateframework.github.io/specification/latest/> | `code/src/scripts/CLAUDE.md` (script contract) | `code/src/os/` (planned — added at P6) |
| 06 Documentation and support | Diataxis, <https://diataxis.fr/> | `how-to/docs/GUIDE-CRAFT.md` | the Syntek OS build-system repository that ships the edition (created when this build starts) |
