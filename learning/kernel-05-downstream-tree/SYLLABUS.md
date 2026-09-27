# Syllabus — kernel-05-downstream-tree

**Track**: kernel · **Phase**: P5 · **Path**: Core · **Detail**: full · **Prerequisites**: kernel-04-kconfig-and-profile-configs; tooling-04-git-for-patch-series; tooling-05-licensing-and-collaboration lesson 01 (copyleft and what GPL-2.0-only requires on distribution)
**Status**: Planned · **Checked**: 27/09/2026 (sources re-verified by `/teach` step 3 before each lesson)

Syntek OS's kernel is a **downstream** of upstream Linux — not a fork, not from scratch
(`project-management/src/08-DECISIONS/ADR-MS001-KERNEL-DOWNSTREAM-OF-UPSTREAM-27-09-2026.md`). This topic is where
that decision becomes a working tree: kernel.org's stable repository as a remote, one branch per line in use, a small
patch series on top with proper commit messages and sign-offs, carried onto each new stable release, named and
versioned, built reproducibly, and distributed within the GPL-2.0's terms — with patches dropped as upstream absorbs
them. It applies tooling-04-git-for-patch-series to a real tree and closes the "patch series" half of the P5 exit gate
in `project-management/src/01-ROADMAP/ROADMAP.md`. **The downstream kernel gets its own repository, created in lesson
02 when this build starts** (its name and host are Sam's to choose); the kernel-04 fragments move there, and nothing
from the kernel tree is ever committed to this learning repository.

Version pins for this syllabus: docs.kernel.org pages were read on 27/09/2026 (documentation build 7.3.0-rc4);
kernel-tree files are cited at tag v7.2; the stable repository listed `linux-6.18.y`, `linux-7.2.y`, `v6.18.54` and
`v7.2.8` that day (`git ls-remote`); the host runs git 2.43.0.

| # | Lesson | Size | Build | Lenses |
| --- | --- | --- | --- | --- |
| 01 | Upstream, downstream and fork | 1 sitting | no | — |
| 02 | The downstream kernel repository: remotes, tags and one branch per line | 1 sitting | yes — downstream kernel repository | Security |
| 03 | A patch series: commits, sign-offs, `format-patch` and `am` | 2–3 sittings | yes — first patch | — |
| 04 | Carrying the series onto the next stable release | 2–3 sittings | yes — first carry | — |
| 05 | Naming and versioning the downstream kernel | 1 sitting | yes — version scheme | — |
| 06 | Reproducible kernel builds | 2–3 sittings | yes — reproducible build wrapper | Security |
| 07 | GPL-2.0 obligations for a distributed kernel | 1 sitting | no | Security |
| 08 | Dropping patches upstream has absorbed | 1 sitting | yes — series audit | — |

---

## 01 — Upstream, downstream and fork

- **Objective:** Sam can explain the difference between upstream, a downstream and a fork, what distributions
  typically carry, and why Syntek OS chose a downstream.
- **Builds on:** kernel-01-build-and-boot-in-qemu lesson 01 (the release lines and distribution kernels); the ADR
  above.
- **Key ideas:**
  - Upstream is kernel.org's mainline and its stable and longterm trees; a downstream follows upstream's tags and
    carries a small series on top, rebased each release; a fork diverges and merges upstream occasionally.
  - A distribution kernel is upstream plus configuration plus a patch set, and is supported by its distribution.
  - Fixes reach stable only once they are in mainline, so a downstream-only fix never arrives from upstream: every
    carried patch is a standing cost until it is upstreamed or dropped.
  - Start near-vanilla: the series begins empty, and the profile fragments do most of the work.
- **Recall targets:** the three terms and what each costs per release; why a downstream still receives stable fixes
  and a fork struggles to; what makes a patch worth carrying.
- **Build:** none.
- **Sources:** the ADR above (Options considered); kernel.org releases (<https://www.kernel.org/category/releases.html>,
  "Distribution kernels"); "Everything you ever wanted to know about Linux -stable releases"
  (<https://docs.kernel.org/process/stable-kernel-rules.html>, "Rules on what kind of patches are accepted").
- **Done when:** Sam explains, unaided, why a downstream suits Syntek OS and what would make it drift into a fork.

## 02 — The downstream kernel repository: remotes, tags and one branch per line

- **Objective:** Sam can set up the downstream kernel repository with the stable tree as a remote, verify the tags he
  builds on, and keep one branch per kernel line in use.
- **Builds on:** lesson 01; kernel-04-kconfig-and-profile-configs lesson 04 (which lines the profiles track);
  tooling-04-git-for-patch-series (remotes, refs, tags).
- **Key ideas:**
  - The stable repository publishes a branch per line (`linux-X.Y.y`) and a tag per release (`vX.Y.Z`); a downstream
    branch per line in use starts from a verified tag.
  - Release tags are signed; `git verify-tag` checks a tag before anything is built on it.
  - The downstream kernel repository holds the series, the profile fragments and the build scripts — not a copy of every
    upstream object Sam never changes.
  - Where the repository lives, what it is called and its visibility are Sam's decisions, recorded when it is created.
- **Recall targets:** how a stable tag, a stable branch and a downstream branch relate; what `git verify-tag` protects
  against; what belongs in the downstream kernel repository and what does not.
- **Build:** **the downstream kernel repository (created when this build starts)**, with the stable remote, one
  downstream branch for the first edition's line and the kernel-04 fragments moved in from
  `code/src/kernel/msNNN-profile-fragments/` (planned — added at P4). Checked by `git log` showing only Sam's commits
  above a verified tag, and by the server profile building and booting in QEMU from the new repository.
- **Security lens:** build only on verified tags; record the tag, its commit and the signing key.
- **Sources:** the stable repository (<https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/>, checked
  with `git ls-remote` on 27/09/2026); kernel.org "Signatures" (<https://www.kernel.org/category/signatures.html>);
  `man git-verify-tag`; `man git-remote`.
- **Done when:** the repository exists with a verified base tag, and the server kernel builds and boots from it.

## 03 — A patch series: commits, sign-offs, `format-patch` and `am`

- **Objective:** Sam can write a kernel-style patch — one logical change, a commit message that explains why, a
  sign-off — export the series as patch files and re-apply it elsewhere.
- **Builds on:** lesson 02; tooling-04-git-for-patch-series lessons 02 and 05 (crafting commits; `format-patch`, `am`
  and trailers); tooling-05-licensing-and-collaboration lesson 06 (DCO sign-off).
- **Key ideas:**
  - One logical change per patch; the message describes the problem, then the change, in the imperative, with a
    `Fixes:` tag (at least 12 characters of the commit ID plus its subject) when it fixes a known commit.
  - `Signed-off-by:` certifies the Developer's Certificate of Origin 1.1; `git commit -s` adds it.
  - Only a human can certify the DCO: the kernel's guidance for AI coding assistants says a tool never adds a
    `Signed-off-by:` and is credited with an `Assisted-by:` tag instead — so a patch Claude helped with carries Sam's
    sign-off and an `Assisted-by:` line, not this repository's `Co-Authored-By:` habit.
  - `git format-patch` exports the series (`--cover-letter`, `-v <n>` for a new version, `--base` to record the base);
    `git am` applies it to another checkout with authorship and messages intact.
  - The tree's scripts/checkpatch.pl is a guide to style, not a judge.
- **Recall targets:** what makes a good kernel commit message; what a sign-off certifies and who may add one; what
  `format-patch --base` records and why a reviewer wants it.
- **Build:** one small patch on the downstream branch (Sam chooses it — for example a boot message naming the
  downstream), in **the downstream kernel repository (created in lesson 02)**. Checked by exporting it with
  `format-patch`, applying it with `am` onto a clean checkout of the same tag, a clean checkpatch run, and the change
  visible when the kernel boots in QEMU.
- **Sources:** "Submitting patches" (<https://docs.kernel.org/process/submitting-patches.html>, "Describe your
  changes", "Sign your work - the Developer's Certificate of Origin" and "Using Reported-by:, Tested-by:, Reviewed-by:,
  Suggested-by: and Fixes:"); Developer Certificate of Origin (<https://developercertificate.org/>); "AI Coding
  Assistants" (<https://docs.kernel.org/process/coding-assistants.html>, "Signed-off-by and Developer Certificate of
  Origin" and "Attribution"); `man git-format-patch`; `man git-am`.
- **Done when:** the patch round-trips through `format-patch` and `am` unchanged, and Sam explains every trailer on it.

## 04 — Carrying the series onto the next stable release

- **Objective:** Sam can move the series from one stable tag to the next, resolve conflicts, and prove with
  `range-diff` that the carried series says what it said before.
- **Builds on:** lesson 03; tooling-04-git-for-patch-series lessons 03–04 (rebasing a series, conflicts and `rerere`;
  `range-diff`).
- **Key ideas:**
  - A carry is a rebase of the series from the old tag onto the new one (`git rebase --onto <new> <old> <branch>`).
  - `git rerere` records how a conflict was resolved and replays it the next time the same conflict appears.
  - `git range-diff` compares the old and new series patch by patch, so a reviewer (or Sam, next week) sees what the
    carry changed.
  - Stable releases arrive about weekly, so the carry has to become routine — kernel-06-kernel-ci-and-security
    automates it.
- **Recall targets:** the arguments of the rebase and why each is needed; what `rerere` stores; how to read a
  `range-diff`.
- **Build:** carry the series across one real stable update in **the downstream kernel repository**. Checked by the
  `range-diff` between the two carries, a clean build of each first-edition profile and a QEMU boot of each.
- **Sources:** `man git-rebase`; `man git-rerere`; `man git-range-diff`; stable rules
  (<https://docs.kernel.org/process/stable-kernel-rules.html>).
- **Done when:** one real carry is done, its `range-diff` is explained, and both profiles boot on the new tag.

## 05 — Naming and versioning the downstream kernel

- **Objective:** Sam can make every downstream build identify itself — base release, downstream revision and build —
  and predict the version string before building.
- **Builds on:** lessons 02–04; Sam's experience of Nix store paths that encode what a build came from.
- **Key ideas:**
  - The release string is the kernel version, then any `localversion*` files, then `CONFIG_LOCALVERSION`, then the
    `LOCALVERSION` make variable, then, with `CONFIG_LOCALVERSION_AUTO` (default y), `-NNNNN-g<12 hex>` when the
    tree is past the version tag (NNNNN is the commit count since the tag, zero-padded to five digits; the hash is
    exactly 12 hex characters), plus `-dirty` for uncommitted changes (scripts/setlocalversion; init/Kconfig's help
    text still says `-gxxxxxxxx` and is out of date).
  - `CONFIG_LOCALVERSION` belongs in the base fragment so every profile carries it; the whole appended string is
    limited to 64 characters.
  - Without `CONFIG_LOCALVERSION_AUTO` and with the `LOCALVERSION` variable unset, a tree that is not exactly at a
    signed or annotated tag gets a `+` appended instead.
  - `make -s kernelrelease` prints the string without building, but it does not re-sync the configuration: after a
    fragment changes, run `make O=… syncconfig` (or `make prepare`) first, or it prints the previous string. `uname -r`
    in the guest confirms it.
  - The scheme itself — how Syntek OS numbers its kernel revisions — is Sam's decision, written down once.
- **Recall targets:** the order in which the pieces of the release string are joined; where each piece is set; what
  `LOCALVERSION_AUTO` adds and when (the commit count, the 12-hex hash, `-dirty`); why `kernelrelease` can print a
  stale string.
- **Build:** the chosen scheme applied through the base fragment in **the downstream kernel repository**. Checked by
  `make -s kernelrelease`, run after a config sync, matching Sam's prediction and `uname -r` in the QEMU guest.
- **Sources:** init/Kconfig at v7.2
  (<https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/plain/init/Kconfig?h=v7.2>, LOCALVERSION and
  LOCALVERSION_AUTO); scripts/setlocalversion at v7.2
  (<https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/plain/scripts/setlocalversion?h=v7.2>, the
  `scm_version` function); the top-level Makefile at v7.2
  (<https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/plain/Makefile?h=v7.2>,
  `no-sync-config-targets`); the admin-guide README (<https://docs.kernel.org/admin-guide/README.html>, "Compiling the
  kernel").
- **Done when:** Sam predicts the release string for two different configurations and both predictions match.

## 06 — Reproducible kernel builds

- **Objective:** Sam can build the same kernel twice, in different places and at different times, and get
  bit-identical images — or name exactly what differs and why.
- **Builds on:** lesson 05; os-05-build-system-and-reproducibility lessons 04–05 if already taken (`SOURCE_DATE_EPOCH`,
  independent rebuilds and diffoscope) — otherwise this lesson introduces the idea from the kernel's own documentation;
  Sam's Nix derivations (pinned inputs, the same output).
- **Key ideas:**
  - The kernel embeds a timestamp, a user and a host: `KBUILD_BUILD_TIMESTAMP`, `KBUILD_BUILD_USER` and
    `KBUILD_BUILD_HOST` fix them, for example from the commit's date and committer.
  - An out-of-tree build can embed absolute paths in debug information; `-fdebug-prefix-map` in `KCFLAGS` and
    `KAFLAGS` removes them, and a few options embed paths and are better off.
  - Signing modules with a key generated per build makes modules unreproducible; the documented approach treats the
    signatures as a separate step. Structure randomisation needs its seed fixed.
  - Uncommitted changes change the release string; build from a clean commit.
- **Recall targets:** each source of non-reproducibility above and its remedy; why reproducibility matters to someone
  who did not build the image.
- **Build:** a build wrapper in **the downstream kernel repository** that sets the variables from the commit and builds
  a profile out of tree. Checked by two builds in different directories producing identical `bzImage` checksums, or by
  a written account of each remaining difference.
- **Security lens:** reproducibility lets anyone check that a published kernel matches its published source — a
  supply-chain defence; weigh it against module signing.
- **Sources:** "Reproducible builds" (<https://docs.kernel.org/kbuild/reproducible-builds.html>, "Timestamps", "User,
  host", "Absolute filenames", "Module signing" and "Structure randomisation"); "Kbuild"
  (<https://docs.kernel.org/kbuild/kbuild.html>, KBUILD_BUILD_TIMESTAMP and KBUILD_BUILD_USER, KBUILD_BUILD_HOST);
  "SOURCE_DATE_EPOCH" (<https://reproducible-builds.org/docs/source-date-epoch/>).
- **Done when:** two independent builds match, or every difference is explained and tracked.

## 07 — GPL-2.0 obligations for a distributed kernel

- **Objective:** Sam can say what distributing a Syntek OS image with this kernel obliges him to publish, and how.
- **Builds on:** tooling-05-licensing-and-collaboration lesson 01 (copyleft and GPL-2.0-only on distribution);
  lessons 02–06.
- **Key ideas:**
  - The kernel is GPL-2.0 with the Linux syscall note, which keeps the system-call boundary from extending the GPL
    to user-space programs.
  - Distributing a binary requires the complete corresponding source to go with it, or a written offer valid for at
    least three years (Section 3 of the GPL version 2).
  - "Complete source" includes the scripts used to control compilation and installation — for Syntek OS, the
    fragments, the series and the build wrapper, not only the C files.
  - This learning repository distributes no kernel binaries; the obligation starts with the first published image.
  - `MODULE_LICENSE` tells the loader whether a module is GPL-compatible; it is not the licence itself.
- **Recall targets:** what counts as complete corresponding source; the two ways to meet Section 3; what the syscall
  note does and does not allow.
- **Build:** none — the obligations become an item on kernel-06-kernel-ci-and-security's release checklist.
- **Security lens:** publishing the exact source and build scripts is also what makes lesson 06's reproducibility
  checkable by others.
- **Sources:** the repository's `LICENSE` (the GPL version 2 text, Section 3 and the definition of source code);
  "Linux kernel licensing rules" (<https://docs.kernel.org/process/license-rules.html>, the COPYING file and
  "MODULE_LICENSE"); SPDX GPL-2.0-only (<https://spdx.org/licenses/GPL-2.0-only.html>).
- **Done when:** Sam lists everything a published image's source release must contain, and names the Section 3 option
  he will use.

## 08 — Dropping patches upstream has absorbed

- **Objective:** Sam can recognise when upstream has taken a change equivalent to one he carries, and drop it cleanly
  with a record of why.
- **Builds on:** lessons 03–04; kernel-07-upstreaming if taken (sending a patch upstream is how many drops begin).
- **Key ideas:**
  - When the new base already contains a change, `git rebase` skips the matching commit and says so.
  - `git cherry` and `range-diff` show which carried commits have an equivalent upstream; an equivalent fix can differ
    textually and still replace Sam's.
  - Every drop is recorded (what, which upstream commit replaced it, from which tag) so the series' history stays
    readable.
  - A shrinking series is the goal: every patch dropped is maintenance saved.
- **Recall targets:** the evidence that a patch is safe to drop; what rebase does with an already-applied change;
  what the drop record must say.
- **Build:** a short audit of the series against the newest stable tag, in **the downstream kernel repository**,
  listing each patch as kept, dropped (with the upstream commit) or proposed for upstream. Checked by rebasing onto that
  tag and comparing with the audit.
- **Sources:** `man git-rebase` (commits already upstream are skipped); `man git-cherry`; `man git-range-diff`;
  "Submitting patches" (<https://docs.kernel.org/process/submitting-patches.html>).
- **Done when:** the audit matches what the rebase did, and every dropped patch names its upstream replacement.
