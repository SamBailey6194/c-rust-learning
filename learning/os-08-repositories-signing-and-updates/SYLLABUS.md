# Syllabus — os-08-repositories-signing-and-updates

**Track**: os · **Phase**: P6 · **Path**: Core · **Detail**: full · **Prerequisites**: os-07 (the package format, transactions and the library); sec-01 lessons 03–04 (threat modelling); sec-05 lessons 01, 04 and 06 (hashes; Ed25519 signatures; key management); os-05 lesson 06 (the build farm)
**Status**: Planned · **Checked**: 27/09/2026 (sources re-verified by `/teach` step 3 before each lesson)

How a Syntek OS machine learns that updates exist and decides to trust them. This topic covers repository metadata
and mirrors, signing a repository (minisign and signify against OpenPGP), The Update Framework's threat model —
freeze, rollback and mix-and-match attacks that a signature alone does not stop — key management and recovery from
a compromised key, and the build farm's publishing step. It **owns the secure update flow**: os-11's unattended
security updates and ui-07's update screen apply it rather than re-teaching it. Lessons 02 and 04 build a small
verification exercise in this repository; the rest is **the Syntek OS package-manager repository** and **the Syntek OS
build-system repository** (each created when its build starts). The signing scheme itself is decided by ADR, fed by
the PACKAGE-SIGNING-SCHEME research note (planned — `research/PACKAGE-SIGNING-SCHEME.md`).

| # | Lesson | Size | Build | Lenses |
| --- | --- | --- | --- | --- |
| 01 | Repository metadata and mirrors | 1 sitting | yes — index writer and reader | Efficiency, Security |
| 02 | Signing a repository: minisign and signify against OpenPGP | 2–3 sittings | yes — repository verifier | Security |
| 03 | The Update Framework's threat model | 2–3 sittings | no | Security |
| 04 | Key management, rotation and compromise recovery | 2–3 sittings | yes — key rotation | Security |
| 05 | The secure update flow | multi-session build | yes — update client | Security, Safety |
| 06 | Building, signing and publishing a repository | 2–3 sittings | yes — publishing pipeline | Efficiency, Security |

---

## 01 — Repository metadata and mirrors

- **Objective:** Sam can say what a repository index must carry, generate one for a directory of packages, and
  explain why mirrors are treated as untrusted transport.
- **Builds on:** os-07 lessons 02 and 06 (the package format; transactions).
- **Key ideas:**
  - An index lists every package with its version, dependencies, size and hash, so a client can plan a transaction
    without downloading the packages (Alpine's `APKINDEX`; pacman's database built by `repo-add`; XBPS's
    `xbps-rindex`).
  - apk's index checksum for a package is the SHA-1 of its control segment; the client checks each downloaded
    package against the index.
  - Mirrors copy the repository; anyone running one can serve old, partial or altered files, so trust comes from
    signatures and metadata, never from the mirror or the connection.
  - HTTPS protects the connection to one mirror; it does not say the files are the ones the distribution published.
- **Recall targets:** the fields an index needs and why; what a malicious mirror can do; what HTTPS does and does not
  prove.
- **Build:** in the Syntek OS package-manager repository (created when its build starts, os-07 lesson 06): an index
  writer for a directory of packages and a reader for the client. Checked by tests — every hash and size matches its
  package; a truncated or oversized index is rejected.
- **Efficiency lens:** index size and parse time for a few thousand packages — the cost every client pays on each
  update check.
- **Security lens:** until lesson 02 the index is unauthenticated; the tests record what an attacker could change.
- **Sources:** Alpine "Apk spec", Section 3 "Index Format V2" (<https://wiki.alpinelinux.org/wiki/Apk_spec>);
  `repo-add(8)` (<https://man.archlinux.org/man/repo-add.8.en>); Void Handbook "Signing Repositories"
  (<https://docs.voidlinux.org/xbps/repositories/signing.html>); TUF specification 1.0.36, Section 2.1.5 "Mirrors
  role" and 2.2 "Threat model and analysis" (<https://theupdateframework.github.io/specification/latest/>).
- **Done when:** the index tests pass, and Sam lists what a malicious mirror could still do against this unsigned
  index.

## 02 — Signing a repository: minisign and signify against OpenPGP

- **Objective:** Sam can sign and verify a repository index with an Ed25519 tool (minisign or signify), compare that
  with OpenPGP, and say exactly what a valid signature proves.
- **Builds on:** lesson 01; sec-05 lesson 04 (Ed25519 signatures).
- **Key ideas:**
  - minisign and OpenBSD's signify sign files with Ed25519 and small, single-purpose key and signature files;
    minisign adds a signed "trusted comment" (for example a version or timestamp).
  - OpenPGP (RFC 9580, which obsoletes RFC 4880) is a general format with keyrings and trust models; pacman signs
    its databases and packages with it (`repo-add --sign`, `pacman-key`), while apk and XBPS sign with RSA.
  - A valid signature proves that a key holder signed these bytes; it does not prove they are the latest bytes —
    lesson 03's problem.
  - The client ships the public key; how the key is distributed and replaced is lesson 04's problem.
  - In this repository's licence gate: the minisign C tool is ISC, and the Rust crates `minisign` (0.10.0) and
    `minisign-verify` (0.3.0) are MIT — all on `code/src/rust/deny.toml`'s allow list.
- **Recall targets:** what is signed, with which key, and what verification checks; what a signature does not prove;
  one difference between minisign and OpenPGP that matters for a small distribution.
- **Build:** a repository verifier in `code/src/rust/crates/msNNN_repo_verify/` (planned code path) that verifies an
  index's minisign signature with `minisign-verify`, with test fixtures signed inside the tests by the `minisign`
  crate (so no command-line tool is needed). Checked by `cargo test` (a good signature passes; a tampered index, a
  tampered trusted comment and the wrong key each fail), `cargo clippy`, and `code/src/scripts/rust/audit.sh`
  (the licence gate).
- **Security lens:** throwaway test keys only, generated in the tests; no real signing key is ever created in or
  committed to this repository.
- **Sources:** minisign (<https://jedisct1.github.io/minisign/>, and <https://github.com/jedisct1/minisign>, ISC);
  `signify(1)` (<https://man.openbsd.org/signify>); `minisign-verify`
  (<https://docs.rs/minisign-verify/latest/minisign_verify/>)
  and `minisign` (<https://docs.rs/minisign/latest/minisign/>) crate docs; RFC 9580 "OpenPGP"
  (<https://www.rfc-editor.org/rfc/rfc9580>); `repo-add(8)` (`--sign`) and `pacman-key(8)`
  (<https://man.archlinux.org/man/pacman-key.8.en>); Void Handbook "Signing Repositories"
  (<https://docs.voidlinux.org/xbps/repositories/signing.html>).
- **Done when:** the verifier's tests and the licence gate pass, and Sam states what a passing verification does and
  does not establish.

## 03 — The Update Framework's threat model

- **Objective:** Sam can explain the attacks TUF is designed to stop — rollback, indefinite freeze, mix-and-match,
  fast-forward, endless data, wrong software, malicious mirrors, key compromise — and how its four top-level roles
  divide the work.
- **Builds on:** lesson 02; sec-01 lessons 03–04 (STRIDE; writing a threat model).
- **Key ideas:**
  - A signed index can still be replayed: an attacker serves yesterday's validly signed metadata (freeze) or an older
    version (rollback). Expiry dates and version numbers the client remembers defeat both.
  - Root delegates trust to the other roles' keys and is kept offline; targets signs the metadata describing the
    packages; snapshot signs the versions of all targets metadata, preventing mix-and-match; timestamp is re-signed
    often with an online key so a client can tell fresh metadata from stale.
  - Separating roles limits the damage from any one key: losing the online timestamp key is far less serious than
    losing root.
  - Size limits on every download stop endless-data attacks.
  - Syntek OS need not adopt TUF wholesale; the threat model is the checklist any design is measured against.
- **Recall targets:** each attack in one sentence and the mechanism that stops it; what each of the four roles signs;
  why root stays offline.
- **Build:** none in code — a threat model for the Syntek OS package repository using sec-01's method, listing which TUF
  attacks the lesson 02 design stops and which it does not.
- **Security lens:** this lesson is the threat model for every later update lesson.
- **Sources:** TUF specification 1.0.36 (05/08/2026), Sections 1.5.2 "Goals to protect against specific attacks",
  2.1 "Roles and PKI" and 2.2 "Threat model and analysis"
  (<https://theupdateframework.github.io/specification/latest/>);
  Samuel, Mathewson, Cappos and Dingledine, "Survivable Key Compromise in Software Update Systems" (ACM CCS 2010,
  <https://theupdateframework.io/papers/survivable-key-compromise-ccs2010.pdf>); Cappos, Samuel, Baker and Hartman,
  "A Look In the Mirror: Attacks on Package Managers" (ACM CCS 2008,
  <https://theupdateframework.io/papers/attacks-on-package-managers-ccs2008.pdf>).
- **Done when:** Sam's threat model marks each TUF attack as stopped or not by the lesson 02 design, with the reason.

## 04 — Key management, rotation and compromise recovery

- **Objective:** Sam can design how Syntek OS's signing keys are held, rotated and revoked, rehearse a rotation in
  code, and write the recovery plan for a compromised key.
- **Builds on:** lessons 02–03; sec-05 lesson 06 (key management).
- **Key ideas:**
  - Offline keys for rare, high-value signatures (root); online keys only where automation needs them (timestamp),
    with short expiry to limit the damage.
  - Thresholds: requiring several keys to sign root means one stolen key is not enough.
  - Rotation in TUF: a new root must be signed by a threshold of the old root's keys and of its own, and its version
    must be exactly one higher — a line of continuity the client can follow.
  - Distributions distribute keys differently: apk looks for the named key in `/etc/apk/keys`; pacman manages a
    PGP keyring with `pacman-key`; XBPS publishes the repository's RSA public key in the repository metadata
    (`xbps-rindex --sign`).
  - A compromise plan says in advance who revokes, how clients learn, and what is rebuilt.
- **Recall targets:** why root is offline and timestamp online; the two signatures a rotated root needs; the steps of
  the compromise plan.
- **Build:** extend `code/src/rust/crates/msNNN_repo_verify/` (planned code path) with a rotation step: a client that
  trusts key A accepts key B only through a statement signed by A (and B), and refuses a statement that skips a
  version. Checked by `cargo test`. The design itself goes into the PACKAGE-SIGNING-SCHEME research note (planned —
  `research/PACKAGE-SIGNING-SCHEME.md`), written through `/research`, which feeds the signing ADR.
- **Security lens:** a real signing key never touches this repository, CI or the build farm's builders; test keys are
  generated inside tests and discarded.
- **Sources:** TUF specification 1.0.36, Sections 2.1.1 "Root role", 5.3 "Update the root role" and 6.1 "Key
  management and migration" (<https://theupdateframework.github.io/specification/latest/>); Alpine "Apk spec",
  "Package signature" in Section 2.1 (<https://wiki.alpinelinux.org/wiki/Apk_spec>); `pacman-key(8)`
  (<https://man.archlinux.org/man/pacman-key.8.en>); Void Handbook "Signing Repositories"
  (<https://docs.voidlinux.org/xbps/repositories/signing.html>).
- **Done when:** the rotation tests pass and the research note holds Sam's key plan and compromise drill, each claim
  cited.

## 05 — The secure update flow

- **Objective:** Sam can build the client side of Syntek OS updates — fetch fresh, signed, consistent metadata, then
  verified packages, then hand them to os-07's transaction — and prove with tests that each TUF attack from lesson 03
  is refused.
- **Builds on:** lessons 01–04; os-07 lessons 05–07 (crash-safe writes, transactions, the library API).
- **Key ideas:**
  - Order matters: timestamp, then snapshot, then targets or the index, then the package — each checked for
    signature, expiry and version before the next is fetched.
  - The client persists the highest versions it has seen (with os-07's crash-safe write) so a rollback is detectable
    after a reboot.
  - Every download has a size limit, and a package must match the hash and size its metadata promised before the
    transaction sees it.
  - A refused update is reported clearly and leaves the system untouched; "no updates reachable" is itself a signal
    (freeze).
  - This flow is what os-11's unattended updates and ui-07's update screen call — they do not reimplement it.
- **Recall targets:** the fetch order and the check at each step; what the client must remember between runs; how
  the flow fails safe.
- **Build:** in the Syntek OS package-manager repository: the update client, tested against a local test repository
  served from a directory. Checked by one test per attack — expired metadata, a rolled-back version, mixed snapshot
  and index, a tampered package, an oversized download — each refused with the system unchanged, and a clean update
  applied through the transaction engine.
- **Security lens:** the update client is the most exposed code in the system: it parses network input as root.
- **Safety:** tests use a local directory as the repository and a scratch root; nothing is fetched from the internet
  in tests.
- **Sources:** TUF specification 1.0.36, Section 5 "Detailed client workflow", 5.1–5.7
  (<https://theupdateframework.github.io/specification/latest/>); `man 2 rename` and `man 2 fsync` (persisting state);
  os-07's library API.
- **Done when:** every attack test passes, a clean update applies, and Sam walks through the flow step by step without
  notes.

## 06 — Building, signing and publishing a repository

- **Objective:** Sam can extend os-05's build farm so that packages are built, tested and checked for
  reproducibility, then signed in a separate step, published to a staging area and promoted to mirrors so clients
  never see a half-published repository.
- **Builds on:** lessons 01–05; os-05 lesson 06 (CI and build farms).
- **Key ideas:**
  - Signing is a separate step with its own keys: builders never hold them, and nothing unsigned or irreproducible
    is signed.
  - Publish order: packages first, then the index, then the fresh timestamp — so a client never sees metadata that
    points at packages not yet uploaded.
  - Staging then promotion gives a place to test the repository with a real client before the world sees it.
  - Mirrors sync from the primary; clients trust metadata, not mirrors (lesson 01).
- **Recall targets:** the publishing order and what goes wrong if it is reversed; where signing happens and why there;
  what promotion adds.
- **Build:** in the Syntek OS build-system repository: the signing and publishing stages added to os-05's pipeline,
  publishing to a test mirror directory. Checked by lesson 05's client updating from the test mirror, and by a test
  that interrupts publishing and shows clients still see the previous consistent repository.
- **Efficiency lens:** time from a recipe change to a signed package on the test mirror, measured, and the share spent
  in each stage.
- **Security lens:** signing is the crown jewel of the pipeline — keep it offline or on a dedicated host, log every
  signature, and reject irreproducible builds before signing.
- **Sources:** TUF specification 1.0.36, Sections 2.1.4 "Timestamp role", 6.2 "Consistent snapshots" and 6.3 "Adding
  and updating targets" (<https://theupdateframework.github.io/specification/latest/>); `repo-add(8)`
  (<https://man.archlinux.org/man/repo-add.8.en>); reproducible-builds.org "Definitions"
  (<https://reproducible-builds.org/docs/definition/>); GitHub Docs "Secure use reference"
  (<https://docs.github.com/en/actions/reference/security/secure-use>).
- **Done when:** the client updates from the test mirror, the interrupted-publish test passes, and the pipeline's
  stage timings are recorded.
