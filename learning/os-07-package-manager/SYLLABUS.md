# Syllabus — os-07-package-manager

**Track**: os · **Phase**: P6 · **Path**: Core · **Detail**: full · **Prerequisites**: os-05 (recipes and the build farm's staged output); P3 (Rust, error handling, testing); sec-05 lessons 01 and 04 (hashes; Ed25519 signatures)
**Status**: Planned · **Checked**: 27/09/2026 (sources re-verified by `/teach` step 3 before each lesson)

The package manager is how every Syntek OS profile installs, upgrades and removes software, and the component the
package-manager TUI (ui-05) is built on. This topic studies pacman, apk and XBPS, designs a package format, resolves
dependencies, extracts untrusted archives safely, updates files so a crash cannot corrupt them, and then builds
transactions with rollback, a library-plus-CLI split whose API is ui-05's contract, and hooks over a file database.
Lessons 02–05 are small Rust exercises in this repository; from lesson 06 the work is **the Syntek OS package-manager
repository (created when this build starts)**. Parsers of hostile input are tested with property tests (proptest, on
stable Rust); fuzzing waits on `GAPS.md` → "Fuzzing Rust needs a nightly toolchain".

| # | Lesson | Size | Build | Lenses |
| --- | --- | --- | --- | --- |
| 01 | What pacman, apk and XBPS keep, and why | 1 sitting | no | Security |
| 02 | Designing a package format | 2–3 sittings | yes — package reader and writer | Security |
| 03 | Dependency resolution: versions, conflicts, provides | 2–3 sittings | yes — resolver | Efficiency |
| 04 | Safe archive extraction | 2–3 sittings | yes — safe extractor | Security |
| 05 | Crash-safe file updates | 1 sitting | yes — atomic write | Efficiency, Security |
| 06 | Transactions, atomic upgrade and rollback | multi-session build | yes — transaction engine | Security, Safety |
| 07 | A library crate and a thin CLI | 2–3 sittings | yes — install, remove, query | Security |
| 08 | Hooks, triggers and the file database | 2–3 sittings | yes — hooks and file database | Security |

---

## 01 — What pacman, apk and XBPS keep, and why

- **Objective:** Sam can describe what a package manager records about the installed system and use pacman's, apk's
  and XBPS's documented features to explain why each record exists.
- **Builds on:** os-04 lesson 02 (LFS's package-management techniques and upgrade issues); os-01 lesson 05 (the three
  distributions).
- **Key ideas:**
  - A local database records every installed package, its files and why it was installed (explicitly or as a
    dependency); pacman keeps it under `/var/lib/pacman`.
  - The file list answers "who owns this file?" (`pacman -Qo`) and "is anything missing?" (`pacman -Qk`).
  - An installation root option (`pacman -r`) lets the manager work on a tree other than `/` — how installers and
    image builders use it.
  - XBPS records package states to recover from broken installs, can resume partial updates, and checks shared
    libraries in reverse dependencies; apk keeps a world file — the constraints that describe the desired system.
  - Each of these exists because of an upgrade problem LFS lists: sonames, overwritten files, half-finished installs.
- **Recall targets:** what the local database must hold; what install reasons are for; which LFS upgrade issue each
  studied feature answers.
- **Build:** none — a feature-by-problem table in the concept note.
- **Security lens:** the database is trusted state — whoever can write to it can make the manager remove or overwrite
  any file.
- **Sources:** `pacman(8)` 7.1.0 (<https://man.archlinux.org/man/pacman.8.en>: `--dbpath`, `-r/--root`, `-Qo`, `-Qk`,
  `--asdeps`); XBPS README (<https://github.com/void-linux/xbps>, the feature list); Alpine "Alpine Package Keeper",
  "World" (<https://wiki.alpinelinux.org/wiki/Alpine_Package_Keeper>) and "Apk spec"
  (<https://wiki.alpinelinux.org/wiki/Apk_spec>); LFS 13.1-systemd Section 8.2.1
  (<https://www.linuxfromscratch.org/lfs/view/stable-systemd/chapter08/pkgmgt.html>).
- **Done when:** Sam's table maps each studied feature to the problem it solves, with a source for each row.

## 02 — Designing a package format

- **Objective:** Sam can design a package format — archive, metadata, file list with hashes, and room for a signature
  — and implement a reader and writer for it with tests.
- **Builds on:** lesson 01; os-05 lesson 01 (recipes and the staged `DESTDIR` tree); sec-05 lesson 01 (hashes).
- **Key ideas:**
  - A package is the staged tree plus metadata (name, version, dependencies, provides, conflicts, install scripts) and
    a manifest of every file with its hash, mode and type.
  - apk's v2 format is a worked example: a signature segment over a control segment, then the data tarball, each in
    its own gzip stream, with per-file hashes in the tar headers.
  - Its signature is an RSA PKCS#1 v1.5 signature over a SHA-1 hash of the control segment — a design choice to
    examine critically against sec-05's material.
  - The format must be readable without trusting it: sizes bounded, fields validated, the signature checked before the
    contents are believed (os-08 adds the signature itself).
- **Recall targets:** the parts of a package and what each is for; what apk signs and what that leaves unsigned; why
  the manifest carries hashes.
- **Build:** a package reader and writer in Rust in `code/src/rust/crates/msNNN_pkg_format/` (planned code path),
  using the `tar` crate (0.4.46, MIT OR Apache-2.0, so it passes `code/src/rust/deny.toml` on MIT) and a RustCrypto
  hash crate. Checked by `cargo test` (a staged tree round-trips; a manifest hash mismatch is reported; oversized or
  malformed metadata is rejected) and `cargo clippy`.
- **Security lens:** every field of an incoming package is attacker-controlled until its signature is verified.
- **Sources:** Alpine "Apk spec" (<https://wiki.alpinelinux.org/wiki/Apk_spec>, Sections 1.1 "Tar Segments", 2.1
  "Binary Format" and 4 "Installed Database V2"); `tar` crate docs (<https://docs.rs/tar/latest/tar/>); `PKGBUILD(5)`
  (<https://man.archlinux.org/man/PKGBUILD.5.en>, `provides`, `conflicts`, `replaces`, `backup`); `man 1 tar` (GNU tar
  1.35).
- **Done when:** the crate passes its tests and lints, and Sam critiques apk's signature choice against sec-05.

## 03 — Dependency resolution: versions, conflicts, provides

- **Objective:** Sam can resolve an install request against a repository — versions, conflicts and virtual packages —
  and explain why real package managers turn this into a satisfiability problem.
- **Builds on:** lesson 02; os-05 lesson 02 (the dependency graph).
- **Key ideas:**
  - A request becomes constraints: dependencies with version ranges, conflicts, and `provides` for virtual packages
    that several real packages can satisfy.
  - A greedy "newest first" pass can paint itself into a corner; backtracking or a SAT solver explores alternatives —
    openSUSE's libsolv is a dependency solver built on satisfiability (SAT) solving.
  - A good resolver explains a failure (which constraints clash), not just "no".
  - Property tests state what must always hold — every chosen package's dependencies are satisfied, no two chosen
    packages conflict — and let proptest search for a counter-example.
- **Recall targets:** the constraint kinds and an example of each; why greedy resolution fails; the two properties
  every solution must satisfy.
- **Build:** a resolver in `code/src/rust/crates/msNNN_depsolve/` (planned code path) over an in-memory repository,
  with proptest (1.11.0, MIT OR Apache-2.0) property tests. Checked by `cargo test` (hand-written cases including a
  conflict that forces a non-newest version, plus the two properties over generated repositories) and `cargo clippy`.
- **Efficiency lens:** time the resolver on growing generated repositories and note where the search blows up.
- **Sources:** `PKGBUILD(5)` (<https://man.archlinux.org/man/PKGBUILD.5.en>, `depends`, `provides`, `conflicts`);
  libsolv README (<https://github.com/openSUSE/libsolv>); proptest (<https://docs.rs/proptest/latest/proptest/>) and
  the proptest book (<https://proptest-rs.github.io/proptest/>).
- **Done when:** the resolver passes its property tests, and Sam explains one failing case the properties caught.

## 04 — Safe archive extraction

- **Objective:** Sam can list the ways a hostile archive attacks its extractor — path traversal, symbolic and hard
  links, special files, ownership and permission bits — and build an extractor that refuses each.
- **Builds on:** lesson 02; sec-04 lesson 01 (permissions and setuid); os-01 lesson 02 (where files may go).
- **Key ideas:**
  - Entries named with `..` or an absolute path try to escape the destination; a symbolic link planted earlier in
    the archive lets a later entry write through it; hard links and device nodes are further routes.
  - Ownership and setuid or setgid bits come from the archive, so a package can smuggle a setuid binary unless the
    extractor applies a policy.
  - The `tar` crate documents its own limit: path checks are best-effort, and a destination changed concurrently
    (a swapped symbolic link) is outside its threat model — it points to OS primitives and sandboxing.
  - Linux's `openat2(2)` (since 5.6) resolves paths relative to a directory with `RESOLVE_BENEATH` or
    `RESOLVE_IN_ROOT`, and `RESOLVE_NO_SYMLINKS` refuses symbolic links anywhere in the path.
  - Extract into a fresh staging directory the manager owns, never directly over the live system.
- **Recall targets:** five attack shapes and the defence for each; what `RESOLVE_BENEATH` guarantees; why the staging
  directory must be fresh.
- **Build:** a safe extractor in `code/src/rust/crates/msNNN_safe_extract/` (planned code path) with a corpus of
  hostile test archives built in the tests themselves, plus proptest-generated entry names. Directory-relative opening
  can use rustix or cap-std (both "Apache-2.0 WITH LLVM-exception OR Apache-2.0 OR MIT", so they pass `deny.toml` on
  MIT) — checked against `code/src/scripts/rust/audit.sh` at the lesson. Checked by `cargo test` (every hostile
  archive is refused and nothing appears outside the destination) and `cargo clippy`.
- **Security lens:** this is the component that turns a malicious package into a compromised system — the tests are
  the threat model written as code.
- **Sources:** `man 2 openat2` (man-pages 6.7: `RESOLVE_BENEATH`, `RESOLVE_IN_ROOT`, `RESOLVE_NO_SYMLINKS`, HISTORY
  Linux 5.6), `man 7 symlink`, `man 7 path_resolution` (host); `tar` crate "Security"
  (<https://docs.rs/tar/latest/tar/>); rustix (<https://github.com/bytecodealliance/rustix>) and cap-std
  (<https://github.com/bytecodealliance/cap-std>); `GAPS.md` → "Fuzzing Rust needs a nightly toolchain".
- **Done when:** every hostile archive in the corpus is refused, and Sam explains the attack each one encodes.

## 05 — Crash-safe file updates

- **Objective:** Sam can replace a file so that, after a crash at any moment, it holds either the old contents or the
  new — never a mix — and explain each step of the sequence.
- **Builds on:** lesson 04; P2 file I/O.
- **Key ideas:**
  - Write the new contents to a temporary file in the same directory, `fsync` it, `rename` it over the target, then
    `fsync` the directory.
  - `rename(2)` replaces the target atomically — no other process sees it missing — but only within one filesystem
    (`EXDEV` otherwise), hence the same directory.
  - `fsync(2)` on the file does not make its directory entry durable; that needs an `fsync` on the directory.
  - In Rust: `File::sync_all`, `std::fs::rename`, and `sync_all` on the opened directory.
  - The package database and every configuration file the manager writes use this sequence (lessons 06 and 08).
- **Recall targets:** the four steps in order and what each protects against; why the temporary file must be on the
  same filesystem; what is lost without the directory `fsync`.
- **Build:** an atomic-write helper in `code/src/rust/crates/msNNN_atomic_write/` (planned code path) with
  fault-injection points between the steps. Checked by `cargo test` (stopping at each point leaves the old contents
  intact and no stray temporary file after recovery; completion leaves the new contents) and `cargo clippy`.
- **Efficiency lens:** measure the cost of the two `fsync` calls per update (repeated runs, variance) and what it
  means for a transaction that writes thousands of files.
- **Security lens:** a predictable temporary name in a shared directory invites a symbolic-link attack — create it
  exclusively (`O_EXCL` semantics) in a directory only the manager can write.
- **Sources:** `man 2 rename` (atomic replacement, `EXDEV`), `man 2 fsync` (the directory note), `man 2 open`
  (`O_EXCL`) — man-pages 6.7 on the host; Rust `std::fs::File::sync_all`
  (<https://doc.rust-lang.org/std/fs/struct.File.html>) and `std::fs::rename`
  (<https://doc.rust-lang.org/std/fs/fn.rename.html>), Rust 1.98.1 docs, read 27/09/2026.
- **Done when:** the fault-injection tests pass, and Sam explains what each step guards against without notes.

## 06 — Transactions, atomic upgrade and rollback

- **Objective:** Sam can design and build a transaction engine that plans, verifies, stages and commits a set of
  package changes so that a failure at any step leaves the system as it was, and that can roll back a committed
  upgrade.
- **Builds on:** lessons 02–05; os-01 lesson 06 (rollback as NixOS does it).
- **Key ideas:**
  - Plan (resolve, check file conflicts against the database), fetch and verify, stage every package's files, then
    commit with lesson 05's sequence and update the database last.
  - Anything that fails before commit discards the staging area; the live system never saw a change.
  - Rollback needs the old state kept: previous files and database, as NixOS keeps earlier configurations, or a
    filesystem snapshot (Btrfs, os-13).
  - XBPS's package states are one way to recover from an interrupted run.
  - Tests inject a failure at every step and assert "all old or all new".
- **Recall targets:** the transaction steps and the invariant after each; what a file conflict is; two ways to keep
  the old state for rollback.
- **Build:** the first code in the Syntek OS package-manager repository (created when this build starts): the
  transaction engine, working on a test root directory, reusing lessons 02–05. Checked by its tests — a failure
  injected at each step leaves the root and the database exactly as before; a committed upgrade rolls back to the
  previous state.
- **Security lens:** a verified signature (os-08) is a precondition of staging, not an afterthought.
- **Safety:** tests use a scratch root directory, never `/`; the engine refuses to run on `/` outside a VM.
- **Sources:** XBPS README (<https://github.com/void-linux/xbps>, package states, resumable updates); NixOS Manual
  26.05, "Rolling Back Configuration Changes" (<https://nixos.org/manual/nixos/stable/>); LFS 13.1-systemd Section 8.2.1
  (<https://www.linuxfromscratch.org/lfs/view/stable-systemd/chapter08/pkgmgt.html>); `man 2 rename`, `man 2 fsync`.
- **Done when:** every fault-injection test passes and a rollback restores the previous state byte for byte.

## 07 — A library crate and a thin CLI

- **Objective:** Sam can split the package manager into a library crate that does everything and a thin command-line
  client that only parses arguments and prints, and document the library's API as the contract the
  package-manager TUI (ui-05) consumes.
- **Builds on:** lesson 06; P3 (crates, modules, error types); `code/docs/RUST-CODING-PRINCIPLES.md` Sections 3 and 5.
- **Key ideas:**
  - The Rust Book's advice for binaries: move the logic into `lib.rs` and keep `main.rs` to argument parsing and
    reporting.
  - The library returns typed results and errors and never prints; each front-end (CLI, TUI, later a GUI) decides how
    to show them.
  - Install, remove and query, each with a dry-run plan the caller can show before confirming — the preview ui-05
    needs.
  - An installation-root parameter (like `pacman -r`) makes the library usable by installers and tests alike.
  - A stable API is a promise: document it, version it, and test it through the public interface only.
- **Recall targets:** what belongs in the library and what in the CLI; why the library never prints; what a dry-run
  plan must contain for a TUI to preview it.
- **Build:** in the Syntek OS package-manager repository: the library and CLI with install, remove and query. Checked by
  integration tests through the public API against a test root, `cargo clippy`, and API docs that build without
  warnings.
- **Security lens:** the CLI runs privileged; keep it thin so the privileged surface is small and the library carries
  the tests.
- **Sources:** The Rust Programming Language, "Refactoring to Improve Modularity and Error Handling", "Separating
  Concerns in Binary Projects" (<https://doc.rust-lang.org/book/ch12-03-improving-error-handling-and-modularity.html>);
  `pacman(8)` (<https://man.archlinux.org/man/pacman.8.en>, `-r/--root`, `-p/--print`).
- **Done when:** the CLI does nothing the library does not expose, the integration tests pass, and Sam walks through
  the API a TUI would call for a previewed install.

## 08 — Hooks, triggers and the file database

- **Objective:** Sam can add hooks that run when a transaction touches matching paths or packages, and keep a file
  database that answers ownership and integrity questions.
- **Builds on:** lessons 06–07.
- **Key ideas:**
  - pacman's hooks run before or after a transaction (`When = PreTransaction|PostTransaction`), triggered by paths or
    package names (`Type = Path|Package`), and a pre-transaction hook can abort it (`AbortOnFail`).
  - A hook runs for the transaction when any trigger matches, and can receive every matched target at once on
    standard input (`NeedsTargets`) — so rebuilding the library cache happens once after many libraries are
    installed, not once per file.
  - The file database maps each path to its owner with the hash and mode from the manifest, so conflicts are caught
    at planning time and `-Qk`-style checks detect changed or missing files.
  - The database is written with lesson 05's crash-safe sequence.
- **Recall targets:** when a pre- and a post-transaction hook run; why a hook runs per transaction rather than per
  file; the questions the file database must answer.
- **Build:** in the Syntek OS package-manager repository: path- and package-triggered hooks and the file database.
  Checked by tests — a hook fires once for a transaction touching many matching files; an aborting pre-hook leaves
  the system unchanged; an integrity check reports a deliberately modified file.
- **Security lens:** hooks run as root from package-supplied or system configuration; only hooks from trusted,
  signed packages or the administrator are honoured.
- **Sources:** `alpm-hooks(5)` (<https://man.archlinux.org/man/alpm-hooks.5.en>: `Type`, `When`, `AbortOnFail`,
  `Target`, `NeedsTargets`); `pacman(8)` (`-Qo`, `-Qk`); `man 8 ldconfig` (host).
- **Done when:** the hook and database tests pass, and Sam explains a trigger he would ship for Syntek OS and why it
  runs once per transaction.
