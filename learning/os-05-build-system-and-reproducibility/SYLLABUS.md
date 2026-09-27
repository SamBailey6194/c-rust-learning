# Syllabus — os-05-build-system-and-reproducibility

**Track**: os · **Phase**: P6 · **Path**: Core · **Detail**: full · **Prerequisites**: os-04 (the complete LFS build); P3 (Rust); sec-05 lesson 01 (hashes); sec-04 lessons 03 and 07 (namespaces; the sandbox launcher)
**Status**: Planned · **Checked**: 27/09/2026 (sources re-verified by `/teach` step 3 before each lesson)

Where Syntek OS stops being a book followed by hand and becomes a system that builds itself: recipes that describe
each package, a dependency graph that orders them, isolated builds that cannot reach the network or the host, builds
that are reproducible bit for bit, and a build farm that runs it all on every change. This topic **owns reproducible
builds** (kernel-05 applies them to the kernel) and **owns "CI and build farms"** (kernel-06 and os-08 apply it). Its
first two lessons are small Rust exercises in this repository; from lesson 03 the work is the Syntek OS build system
itself, which lives in **the Syntek OS build-system repository (created when this build starts)**, as the repository
boundary in `.claude/skills/teach/FAMILIES.md` sets out.

| # | Lesson | Size | Build | Lenses |
| --- | --- | --- | --- | --- |
| 01 | From book steps to recipes | 2–3 sittings | yes — recipe parser | Security |
| 02 | The dependency graph and build order | 2–3 sittings | yes — build-order solver | Efficiency |
| 03 | Isolated builds: chroot, namespaces, containers, no network | 2–3 sittings | yes — isolated builder | Security, Safety |
| 04 | Reproducible builds and `SOURCE_DATE_EPOCH` | 2–3 sittings | yes — two identical builds | Security |
| 05 | Proving reproducibility: independent rebuilds and diffoscope | 1 sitting | yes — rebuild and compare | Security |
| 06 | CI and build farms | multi-session build | yes — the build pipeline | Efficiency, Security |

---

## 01 — From book steps to recipes

- **Objective:** Sam can turn an LFS package's instructions into a declarative recipe — source, checksum, build and
  install into `DESTDIR` — and compare his format with PKGBUILD, APKBUILD and Void's templates.
- **Builds on:** os-04 lessons 01–02 (the base build; package-management techniques); os-03 lesson 03 (`DESTDIR`);
  Sam's Nix derivations, which describe a build the same way; P3 (Rust, error handling).
- **Key ideas:**
  - A recipe is data plus a few build steps: name, version, source URLs, checksums, dependencies, then prepare, build,
    check and package phases (PKGBUILD names its functions `prepare()`, `build()`, `check()` and `package()`).
  - Every source is pinned by a checksum (PKGBUILD's `sha256sums` or `b2sums`, APKBUILD's `sha512sums`, Void's
    `checksum`); a mismatch stops the build.
  - A checksum proves the download matches what the recipe's author saw — integrity, not who published it; signed
    sources (PKGBUILD's `validpgpkeys`) add authenticity.
  - The package phase installs into `DESTDIR`, never into the live system; the staged tree is what gets packaged.
  - A recipe format is an input to a program, so its parser treats every field as untrusted.
- **Recall targets:** the fields every recipe needs and why; what a checksum does and does not prove; why the package
  step writes to `DESTDIR`.
- **Build:** a small recipe format and its parser in Rust, in `code/src/rust/crates/msNNN_recipe/` (planned code
  path), with a few LFS packages written as recipes as test fixtures. Checked by `cargo test` (a valid recipe parses;
  a missing checksum, an unknown field and a malformed version are each rejected with a clear error) and
  `cargo clippy` clean.
- **Security lens:** checksums stop a corrupted or swapped download from being built; sec-05 lesson 01 is why a hash
  alone is not a signature.
- **Sources:** `PKGBUILD(5)` from pacman 7.1.0 (<https://man.archlinux.org/man/PKGBUILD.5.en>: `source`, the checksum
  arrays, `validpgpkeys`, `depends`/`makedepends`/`checkdepends`, the `package()` function); Alpine "APKBUILD
  Reference" (<https://wiki.alpinelinux.org/wiki/APKBUILD_Reference>, `sha256sums/sha512sums`); void-packages
  "Manual" (<https://github.com/void-linux/void-packages/blob/master/Manual.md>, the template format); LFS 13.1-systemd
  Section 8.2.2.3 (<https://www.linuxfromscratch.org/lfs/view/stable-systemd/chapter08/pkgmgt.html>).
- **Done when:** the crate passes its tests and lints, and Sam explains each field of his format against its
  PKGBUILD equivalent.

## 02 — The dependency graph and build order

- **Objective:** Sam can model packages and their dependencies as a directed graph, compute a build order by
  topological sort, report a cycle, and explain how LFS breaks its own cycles.
- **Builds on:** lesson 01; os-04 lesson 01 (Appendix C's dependency kinds); P2 data structures.
- **Key ideas:**
  - Build-time, run-time and test-time dependencies are different edges (PKGBUILD's `makedepends`, `depends`,
    `checkdepends`); a build order needs only the build-time ones plus what those pull in at run time.
  - A topological sort orders a directed acyclic graph; `tsort(1)` is the command-line reference.
  - A cycle has no order; LFS breaks cycles by building a package twice (binutils and GCC pass 1 and pass 2, the
    temporary tools), which the graph models as separate nodes.
  - Reverse dependencies say what to rebuild when a package changes — the input to lesson 06's farm.
  - Independent branches of the graph can build in parallel.
- **Recall targets:** why a cycle has no build order and how LFS escapes it; the difference between the three edge
  kinds; what a reverse-dependency query is for.
- **Build:** a build-order solver in the lesson 01 crate or a sibling, `code/src/rust/crates/msNNN_build_order/`
  (planned code path), that reads the recipes, prints an order and names the packages in any cycle. Checked by
  `cargo test` (a known graph matches `tsort`'s order constraints; a cycle is reported with its members; reverse
  dependencies are correct).
- **Efficiency lens:** count how many packages could build in parallel at each level of the graph for the LFS
  chapter 8 set, against the serial order the book uses.
- **Sources:** LFS 13.1-systemd Appendix C "Dependencies"
  (<https://www.linuxfromscratch.org/lfs/view/stable-systemd/appendices/dependencies.html>); `man 1 tsort` (GNU
  coreutils 9.4 on the host); `PKGBUILD(5)` (<https://man.archlinux.org/man/PKGBUILD.5.en>, the three dependency
  arrays).
- **Done when:** the solver's tests pass and Sam explains, from its output, why binutils appears twice in an LFS
  graph.

## 03 — Isolated builds: chroot, namespaces, containers, no network

- **Objective:** Sam can run a recipe's build step in an isolated environment with no network and no view of the
  host's files, and explain what a chroot, namespaces and a container each isolate.
- **Builds on:** lessons 01–02; os-03 lesson 06 (the chroot); sec-04 lessons 03 and 07 (namespaces; the sandbox
  launcher).
- **Key ideas:**
  - `chroot` only changes the root for path lookups and is not a security mechanism; namespaces give a process its
    own instance of mounts, PIDs, the network, users and more, and are how containers are implemented; cgroups add
    resource limits.
  - Fetch and build are separate phases: sources are downloaded and checksummed first, then the build runs with no
    network, so it cannot pull in anything the recipe did not declare.
  - On this host an unprivileged user can create user, mount and network namespaces (checked 27/09/2026 with
    `unshare --user --map-root-user --net`), so builds need no `sudo`; `bwrap` (bubblewrap 0.9.0 on the host) packages
    the same primitives.
  - Isolation also catches mistakes: a build that writes outside its `DESTDIR` fails instead of polluting the builder.
  - sec-04's sandbox launcher (a lesson crate here, then the sandbox-launcher repository once that build starts) is the
    one sandbox these builds share; the builder depends on it rather than writing a second.
- **Recall targets:** what each namespace type isolates for a build; why fetch and build are separate; why a chroot
  alone is not enough.
- **Build:** the first code in the Syntek OS build-system repository (created when this build starts): a builder that
  runs one recipe's build in a fresh user, mount and network namespace (through sec-04's launcher or `bwrap`), with
  sources fetched and verified beforehand. Checked by its tests: a recipe that tries to reach the network during the
  build fails; a build that writes outside its staging directory fails; a clean recipe produces its staged tree.
- **Security lens:** a build script is untrusted code — a compromised upstream tarball runs with the builder's
  privileges, so the builder has none it does not need.
- **Safety:** unprivileged namespaces only; Claude never runs `sudo`.
- **Sources:** `man 2 chroot` (NOTES), `man 7 namespaces`, `man 7 user_namespaces`, `man 7 network_namespaces`,
  `man 1 unshare` (util-linux 2.39.3), `man 1 bwrap` (bubblewrap 0.9.0) on the host; "Control Group v2"
  (<https://docs.kernel.org/admin-guide/cgroup-v2.html>); LFS 13.1-systemd Section 8.77 "Systemd-261.2", where the
  book itself runs a test suite under `unshare -m`
  (<https://www.linuxfromscratch.org/lfs/view/stable-systemd/chapter08/systemd.html>).
- **Done when:** the builder's isolation tests pass, and Sam names what each namespace in his builder prevents.

## 04 — Reproducible builds and `SOURCE_DATE_EPOCH`

- **Objective:** Sam can find what makes two builds of the same source differ, remove each cause, and produce
  bit-for-bit identical packages from two separate builds.
- **Builds on:** lesson 03; os-01 lesson 06 (the idea borrowed from Nix).
- **Key ideas:**
  - A build is reproducible when anyone with the same source, build environment and instructions gets bit-for-bit
    identical artefacts, checked by comparing them.
  - The usual culprits: embedded timestamps, file order in archives, locale and time zone, build paths, user and group
    names, and parallelism.
  - `SOURCE_DATE_EPOCH` (specification revision 1.1) is a Unix timestamp the build uses in place of "now", normally
    the source's last modification time; later timestamps are clamped to it.
  - Archives are normalised with GNU tar's `--sort=name`, `--mtime`, `--clamp-mtime`, `--owner=0 --group=0
    --numeric-owner`.
  - Reproducibility is a security property: it lets anyone check that a binary really came from its source.
- **Recall targets:** five sources of non-determinism and the fix for each; what `SOURCE_DATE_EPOCH` must be derived
  from; why reproducibility defends against a compromised builder.
- **Build:** in the Syntek OS build-system repository: build one package twice (different times, working directories and
  locales), compare the results with `sha256sum`, then fix each difference until the hashes match. Checked by two
  matching hashes recorded in the note and a test in the repository that fails if they diverge again.
- **Security lens:** a builder that injects code produces a binary that no independent rebuild matches — the attack
  reproducibility exposes (arXiv:2104.06020).
- **Sources:** reproducible-builds.org "Definitions" (<https://reproducible-builds.org/docs/definition/>), "Timestamps"
  (<https://reproducible-builds.org/docs/timestamps/>) and "Archive metadata"
  (<https://reproducible-builds.org/docs/archives/>); "SOURCE_DATE_EPOCH specification", revision 1.1, 27/11/2017
  (<https://reproducible-builds.org/specs/source-date-epoch/>); `man 1 tar` (GNU tar 1.35 on the host); Lamb and
  Zacchiroli, "Reproducible Builds: Increasing the Integrity of Software Supply Chains", arXiv:2104.06020
  (<https://arxiv.org/abs/2104.06020>).
- **Done when:** two independent builds of the package hash identically, and Sam lists the differences he removed
  and their causes.

## 05 — Proving reproducibility: independent rebuilds and diffoscope

- **Objective:** Sam can rebuild a package in a second, independent environment, compare it with the first, and use
  diffoscope to explain any difference down to the file and byte.
- **Builds on:** lesson 04.
- **Key ideas:**
  - Proof needs a second builder that shares nothing with the first but the recipe and the sources.
  - diffoscope unpacks archives recursively and shows where two artefacts differ in human-readable form.
  - Distributions run rebuilders continuously: Debian and others through reproducible-builds.org's test
    infrastructure, Arch through its rebuilderd-based status site.
  - A rebuild that does not match is a finding to investigate, not noise to ignore.
- **Recall targets:** what makes two builders independent; what diffoscope shows that `sha256sum` cannot; what a
  distribution publishes so others can rebuild.
- **Build:** in the Syntek OS build-system repository: a rebuild step that builds a package in a second, clean
  environment and compares hashes; on a mismatch, a diffoscope report. diffoscope is not installed on the host
  (checked 27/09/2026), so the diffoscope half is **Blocked** until Sam installs it
  (`GAPS.md` → "diffoscope not installed"); the hash comparison runs now. Checked by a matching rebuild
  recorded in the note, and one deliberately broken build explained with diffoscope once it is available.
- **Security lens:** independent verification means one compromised builder is not enough to ship a tampered
  package.
- **Sources:** diffoscope (<https://diffoscope.org/>); reproducible-builds.org "Tools", rebuilderd
  (<https://reproducible-builds.org/tools/>) and "Continuous tests" (<https://tests.reproducible-builds.org/>); Arch
  Linux Reproducible Status (<https://reproducible.archlinux.org/>); arXiv:2104.06020.
- **Done when:** a second-environment rebuild matches, and — once diffoscope is installed — Sam explains a deliberate
  difference from its report.

## 06 — CI and build farms

- **Objective:** Sam can design and run a pipeline that, on each recipe change, rebuilds the package and its reverse
  dependencies in isolation, tests them, checks reproducibility and publishes the results to a staging repository —
  with signing kept off the builders.
- **Builds on:** lessons 02–05; this repository's own CI (`.github/workflows/`) as a working example.
- **Key ideas:**
  - A build farm is a scheduler, isolated builders, an artefact store and a publishing step; Hydra (NixOS's
    continuous build system) is one working design to study.
  - A recipe change triggers a rebuild of the package and of everything that depends on it (lesson 02's reverse
    dependencies).
  - Builders never hold signing keys: artefacts are signed in a separate step after tests and a reproducibility check
    (os-08 owns signing and publishing).
  - GitHub's own guidance: self-hosted runners should almost never serve public repositories, because anyone can
    open a pull request that runs code on them.
  - Every build records its time, peak memory and output size, so regressions are visible.
- **Recall targets:** the stages of the pipeline and what each guards; why keys stay off builders; the risk of
  self-hosted runners on a public repository.
- **Build:** in the Syntek OS build-system repository: the pipeline — recipe change → rebuild with reverse dependencies in
  isolation → tests → reproducibility check → publish unsigned to a staging area. Checked by a pipeline run on a
  deliberate recipe change that rebuilds exactly the expected set, and by recorded build metrics.
- **Efficiency lens:** per-package build time and peak memory measured with `/usr/bin/time -v`, following llm-06
  lesson 01's measurement method, and the time saved by building independent branches in parallel.
- **Security lens:** the farm is a supply-chain target — isolate builders, keep keys off them, publish build logs,
  and treat a public repository's pull requests as untrusted input.
- **Sources:** Hydra (<https://github.com/NixOS/hydra>, "a Continuous Integration service for Nix based projects");
  reproducible-builds.org "Continuous tests" (<https://tests.reproducible-builds.org/>); GitHub Docs "Secure use
  reference", self-hosted runners (<https://docs.github.com/en/actions/reference/security/secure-use>); `man 1 time`
  (GNU time on the host, `-v`).
- **Done when:** the pipeline rebuilds the right set on a change, publishes to staging with no key on any builder,
  and its metrics are recorded.
