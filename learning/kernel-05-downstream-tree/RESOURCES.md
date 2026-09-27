# Resources — kernel-05-downstream-tree

| Lesson | Primary source (pinned) | House guide | Code |
| --- | --- | --- | --- |
| 01 Upstream, downstream and fork | <https://www.kernel.org/category/releases.html> (Distribution kernels); <https://docs.kernel.org/process/stable-kernel-rules.html> (docs build 7.3.0-rc4) | `project-management/src/08-DECISIONS/ADR-MS001-KERNEL-DOWNSTREAM-OF-UPSTREAM-27-09-2026.md` | — |
| 02 The downstream kernel repository | <https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/> (`git ls-remote`, 27/09/2026); <https://www.kernel.org/category/signatures.html>; `man git-verify-tag` | `project-management/docs/git/` — the git conventions | the downstream kernel repository (created when this build starts) |
| 03 A patch series | <https://docs.kernel.org/process/submitting-patches.html> (Describe your changes; Sign your work); <https://developercertificate.org/>; <https://docs.kernel.org/process/coding-assistants.html>; `man git-format-patch`; `man git-am` | `project-management/docs/git/COMMITS.md` | the downstream kernel repository |
| 04 Carrying the series onto the next stable release | `man git-rebase`; `man git-rerere`; `man git-range-diff` (git 2.43.0) | — | the downstream kernel repository |
| 05 Naming and versioning | init/Kconfig (LOCALVERSION) and scripts/setlocalversion at v7.2; <https://docs.kernel.org/admin-guide/README.html> | — | the downstream kernel repository |
| 06 Reproducible kernel builds | <https://docs.kernel.org/kbuild/reproducible-builds.html>; <https://docs.kernel.org/kbuild/kbuild.html> (KBUILD_BUILD_TIMESTAMP); <https://reproducible-builds.org/docs/source-date-epoch/> | — | the downstream kernel repository |
| 07 GPL-2.0 obligations | `LICENSE` (GPL version 2, Section 3); <https://docs.kernel.org/process/license-rules.html>; <https://spdx.org/licenses/GPL-2.0-only.html> | — | — |
| 08 Dropping absorbed patches | `man git-rebase`; `man git-cherry`; `man git-range-diff` | — | the downstream kernel repository |
