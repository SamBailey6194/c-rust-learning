# Syllabus — sec-05-applied-cryptography

**Track**: sec · **Phase**: S1 · **Path**: Core (lessons 01–07); Later (lessons 08–13) · **Detail**: full · **Prerequisites**: P2; P3 for the library-usage builds; sec-01; for lessons 12–13, `os-09-networking-fundamentals` lesson 05; for lesson 13, `sec-04-linux-security-model` lesson 07
**Status**: Planned · **Checked**: 27/09/2026 (sources re-verified by `/teach` step 3 before each lesson)

This topic teaches cryptography as a user, not an inventor: what each primitive guarantees, which one
solves a given problem, and how to reach for a vetted library rather than a home-made construction.
It is Core because the package manager and repository signing (os-07, os-08) and the first
server/homelab edition (os-11) depend on it — Syntek OS cannot ship a trustworthy update without
signatures and key management done correctly. Every build uses an audited library that passes the
licence gate (the RustCrypto crates, `ed25519-dalek` or libsodium; lesson 07 shows why `ring` does
not); any primitive implemented by hand is a learning toy, clearly marked never-for-use.

Lessons 08–13, appended in the networking and licensing round of 27/09/2026, sit on the **Later**
path: a private certificate authority made by hand with `openssl` (an offline root, a constrained
intermediate, short-lived leaves and revocation), then run by a standing ACME issuer
(`project-management/src/08-DECISIONS/ADR-MS001-PRIVATE-CA-OFFLINE-ROOT-AND-ACME-27-09-2026.md`,
Proposed). They serve `ui-10-web-admin-dashboard` lesson 05, `os-18-own-network-operations` and
`ui-11-consent-first-remote-help`. `openssl` is run as a program and never linked into code here
(OpenSSL 3 is Apache-2.0, `/usr/share/doc/openssl/copyright`). Every CA made in these lessons is a
throwaway lab CA whose keys never enter any repository; Sam's real CA is built only under
`project-management/src/08-DECISIONS/ADR-MS001-NETWORK-LAB-FIRST-GRADUATION-PATH-27-09-2026.md`.

| # | Lesson | Size | Build | Lenses |
| --- | --- | --- | --- | --- |
| 01 | Hashes: what they guarantee and what they do not | 1 sitting | yes — hash-check | Security |
| 02 | MACs and authenticated encryption | 2–3 sittings | yes — mac-verify | Security |
| 03 | Symmetric encryption and nonces | 2–3 sittings | yes — aead-roundtrip | Security |
| 04 | Public-key signatures with Ed25519 | 2–3 sittings | yes — ed25519-sign | Security |
| 05 | Key exchange and TLS at protocol level | 1 sitting | no | Security |
| 06 | Key management: the hard part | 1 sitting | no | Security, Safety |
| 07 | Don't roll your own: using a vetted library | 1 sitting | yes — library-choice | Security |
| 08 | A private CA by hand: the offline root | 1 sitting | no | Security, Safety |
| 09 | The intermediate: path length and name constraints | 2–3 sittings | no | Security |
| 10 | Short-lived leaves for services | 2–3 sittings | yes — cert-check | Security, Safety |
| 11 | Revocation versus short lifetimes | 1 sitting | no | Security |
| 12 | Distributing the root to trust stores | 1 sitting | no | Security, Safety |
| 13 | A standing ACME issuer for short-lived leaves | 2–3 sittings | yes — lab ACME issuer | Efficiency, Security, Safety |

---

## 01 — Hashes: what they guarantee and what they do not

- **Objective:** Sam can state what a cryptographic hash guarantees (preimage, second-preimage and
  collision resistance) and what it does not (confidentiality), and compute one with a library.
- **Builds on:** sec-01 (integrity as a CIA property); P2 file I/O.
- **Key ideas:**
  - A hash proves integrity, not secrecy; anyone can recompute it.
  - Collision resistance and why MD5/SHA-1 are broken for it; SHA-256/SHA-512/BLAKE2 as current.
  - A hash over a download verifies integrity only if the hash itself is trusted (leads to signatures
    in lesson 04).
- **Recall targets:** say which property a broken hash loses and why a bare hash does not authenticate
  a download.
- **Build:** a `hash-check` crate under `code/src/rust/crates/msNNN_<snake>/` computing and verifying a
  file hash with a RustCrypto crate; passes `cargo test` and `cargo clippy`.
- **Security lens:** integrity checking is the first half of the secure update flow (os-08).
- **Sources:** RustCrypto, <https://github.com/RustCrypto>; libsodium documentation, <https://doc.libsodium.org/>.
- **Done when:** Sam explains the three resistances and verifies a file hash in code.

## 02 — MACs and authenticated encryption

- **Objective:** Sam can explain why integrity needs a keyed MAC (not a bare hash) and use HMAC or an
  AEAD.
- **Builds on:** lesson 01.
- **Key ideas:**
  - A MAC (HMAC) authenticates with a shared key; a bare hash does not, because anyone can recompute
    it.
  - Encrypt-then-MAC versus authenticated encryption with associated data (AEAD); why AEAD is the
    default advice.
  - Constant-time comparison to avoid timing leaks.
- **Recall targets:** say why a hash alone is not authentication and what AEAD adds over encryption.
- **Build:** a `mac-verify` crate under `code/src/rust/crates/msNNN_<snake>/` computing and verifying
  an HMAC with a RustCrypto crate, using a constant-time compare; passes the gates.
- **Security lens:** MACs authenticate messages between the repository and the client.
- **Sources:** RustCrypto, <https://github.com/RustCrypto>; libsodium documentation, <https://doc.libsodium.org/>.
- **Done when:** Sam explains the hash-versus-MAC distinction and verifies a MAC in constant time.

## 03 — Symmetric encryption and nonces

- **Objective:** Sam can encrypt and decrypt with an AEAD cipher and explain why a nonce must never
  repeat under one key.
- **Builds on:** lesson 02.
- **Key ideas:**
  - AES-GCM and ChaCha20-Poly1305 as the standard AEADs; the same call gives confidentiality and
    integrity.
  - The nonce contract: unique per key; reuse breaks the cipher — the classic misuse.
  - Symmetric keys are shared secrets; distributing them is the problem public-key crypto solves
    (lesson 04–05).
- **Recall targets:** say what a nonce is for and what repeating one costs.
- **Build:** an `aead-roundtrip` crate under `code/src/rust/crates/msNNN_<snake>/` doing an
  encrypt/decrypt round trip with a vetted AEAD and a fresh nonce; a test shows tampered ciphertext
  failing to decrypt. Passes the gates.
- **Security lens:** AEAD is confidentiality plus integrity in one primitive.
- **Sources:** RustCrypto, <https://github.com/RustCrypto>; libsodium documentation, <https://doc.libsodium.org/>.
- **Done when:** Sam's round trip works and tampered ciphertext is rejected.

## 04 — Public-key signatures with Ed25519

- **Objective:** Sam can sign and verify with Ed25519 and explain how a signature authenticates a
  publisher without a shared secret.
- **Builds on:** lessons 01–03.
- **Key ideas:**
  - Public/private key pairs; the private key signs, the public key verifies.
  - Ed25519 as the modern signature scheme (deterministic, fast, small keys) — the basis of the
    minisign/signify tooling os-08 chooses.
  - A signature over a hash of the artefact authenticates the artefact; trust flows from the public
    key, so distributing the public key correctly is the next problem (lesson 06).
- **Recall targets:** say which key signs, which verifies, and what a signature over a repository
  index proves.
- **Build:** an `ed25519-sign` crate under `code/src/rust/crates/msNNN_<snake>/` signing and verifying
  a message with `ed25519-dalek` (from dalek-cryptography, BSD-3-Clause, implementing RustCrypto's
  `signature` traits); a test shows a tampered message failing verification.
  Passes the gates.
- **Security lens:** signatures are how a Syntek OS package and repository index are trusted (os-07,
  os-08).
- **Sources:** RFC 8032 (Edwards-Curve Digital Signature Algorithm), <https://www.rfc-editor.org/rfc/rfc8032>; `ed25519-dalek` 3.0.0, <https://docs.rs/ed25519-dalek>; RustCrypto, <https://github.com/RustCrypto>.
- **Done when:** Sam signs and verifies a message and a tampered one is rejected.

## 05 — Key exchange and TLS at protocol level

- **Objective:** Sam can explain Diffie-Hellman key exchange and the shape of a TLS 1.3 handshake,
  without implementing either.
- **Builds on:** lessons 03–04.
- **Key ideas:**
  - (Elliptic-curve) Diffie-Hellman establishes a shared secret over a public channel; X25519 is the
    common curve.
  - TLS 1.3 combines key exchange, authentication (certificates) and AEAD; the handshake at a
    block-diagram level.
  - Certificates and the trust chain — why a mirror's TLS certificate is not the same trust as a
    repository signature (os-08).
- **Recall targets:** explain what Diffie-Hellman achieves and what TLS authenticates versus what a
  package signature authenticates.
- **Build:** none — protocol reading; any TLS use in later lessons goes through a vetted library.
- **Security lens:** transport security and artefact signing are different trust layers; conflating
  them is a common mistake.
- **Sources:** RFC 8446 (TLS 1.3), <https://www.rfc-editor.org/rfc/rfc8446>.
- **Done when:** Sam explains DH and the TLS-versus-signature trust distinction, unaided.

## 06 — Key management: the hard part

- **Objective:** Sam can describe a key's lifecycle — generation, storage, rotation, compromise
  recovery — and why key management, not the maths, is where systems fail.
- **Builds on:** lessons 04–05.
- **Key ideas:**
  - Generating keys with a good source of randomness; storing private keys (never in the repository,
    never in CI logs).
  - Rotation and revocation; what a compromised signing key means for a repository and how to recover
    (forward reference to os-08's key-compromise recovery).
  - Offline signing keys and why the most powerful key is used least.
- **Recall targets:** outline a signing key's lifecycle and where it must never be stored.
- **Build:** none — a written key-management plan for the (future) repository signing key; feeds
  os-08.
- **Security lens:** key management is the part of signing that actually protects users.
- **Safety:** no real private key or secret is committed to this public repository (non-negotiable).
- **Sources:** NIST SP 800-57 Part 1 Rev. 5, Recommendation for Key Management: Part 1 – General (key lifecycle, cryptoperiods, compromise recovery), <https://csrc.nist.gov/pubs/sp/800/57/pt1/r5/final>; The Update Framework specification (offline root keys, key rotation), <https://theupdateframework.github.io/specification/latest/>.
- **Done when:** Sam writes a key-lifecycle plan naming where keys live and how rotation works.

## 07 — Don't roll your own: using a vetted library

- **Objective:** Sam can choose an appropriate audited crypto library and justify not implementing
  primitives himself.
- **Builds on:** lessons 01–06.
- **Key ideas:**
  - Why hand-rolled crypto fails (side channels, nonce misuse, subtle maths) even when it "works".
  - The candidates: the RustCrypto crates (`sha2`, `hmac`, `chacha20poly1305`; MIT OR Apache-2.0,
    pass on MIT) and `ed25519-dalek` (BSD-3-Clause) for Rust; libsodium (ISC) for C. `ring` is
    `Apache-2.0 AND ISC` and fails `code/src/rust/deny.toml` without an exception ADR — a worked
    example of why the gate runs first.
  - When a toy implementation is acceptable (understanding only, marked never-for-use) versus never.
- **Recall targets:** give the reasons not to roll your own and name a suitable library for a task.
- **Build:** a `library-choice` note plus a small program under `code/src/rust/crates/msNNN_<snake>/`
  demonstrating the chosen library's API for one primitive; the choice is checked against
  `cargo-deny`. Passes the gates.
- **Security lens:** using vetted crypto is itself a security control.
- **Sources:** RustCrypto, <https://github.com/RustCrypto>; `ed25519-dalek`, <https://docs.rs/ed25519-dalek>; libsodium documentation, <https://doc.libsodium.org/>; `code/src/rust/deny.toml` (licence allow-list).
- **Done when:** Sam names a suitable library, justifies the choice, and it passes the audit gate.

## 08 — A private CA by hand: the offline root

- **Objective:** Sam can make a root key and a self-signed root certificate with `openssl`, explain
  each extension it carries, and say why the root stays offline.
- **Builds on:** lessons 05–06 (certificates and the trust chain; the most powerful key used least).
- **Key ideas:**
  - `basicConstraints` `CA:TRUE`, marked critical, is what lets a key sign certificates.
  - `keyUsage` `keyCertSign, cRLSign`: the root signs only intermediates and CRLs, never a service.
  - The subject and authority key identifiers link each certificate to the key that issued it.
  - The key algorithm is chosen by what the clients accept on the day, checked at `/teach` step 3.
  - The root is offline, so using it is a deliberate ceremony rather than a routine.
- **Recall targets:** say what each extension in the root permits or forbids, and what someone holding
  the root key could do.
- **Build:** none in code. A throwaway root made in `$XDG_RUNTIME_DIR`, read back with
  `openssl x509 -text -noout`, and destroyed at the end of the sitting.
- **Security lens:** the root key is the whole CA; where it lives decides everything below it.
- **Safety:** lab keys are made outside the repository and destroyed; no private key enters any
  repository (`.claude/CLAUDE.md` Section 5). The `.gitignore` private-key patterns are a backstop,
  not the control.
- **Sources:** `man 1ssl openssl-req`, `man 1ssl openssl-genpkey`, `man 5ssl x509v3_config` (OpenSSL
  3.0.13); RFC 5280 Sections 4.1, 4.2.1.1–4.2.1.3 and 4.2.1.9, <https://www.rfc-editor.org/rfc/rfc5280>.
- **Done when:** Sam explains every extension unaided and writes down where a real root would live.

## 09 — The intermediate: path length and name constraints

- **Objective:** Sam can sign an intermediate with `pathlen:0` and name constraints from the lab root,
  and predict what `openssl verify` says about a chain before running it.
- **Builds on:** lesson 08.
- **Key ideas:**
  - The intermediate does the daily signing, so the root can stay offline.
  - `pathlen:0` forbids any further intermediate below this one.
  - `nameConstraints` with `permitted;DNS:` and `permitted;IP:`, written here with `example.test`
    names and the documentation address ranges only.
  - Path validation checks every link in the chain, not only the leaf; `openssl ca` keeps a database
    of what it issued.
  - Whether a client enforces name constraints is **checked, not assumed** — the private-CA
    client-support research note (planned — `research/PRIVATE-CA-CLIENT-SUPPORT.md`).
- **Recall targets:** predict the result for a leaf inside and outside the constraints, and say what a
  stolen intermediate can sign.
- **Build:** none in code. A table of predicted against actual `openssl verify` results for four
  chains made with the throwaway lab CA.
- **Security lens:** name constraints shrink a stolen intermediate to Sam's own names — where the
  client enforces them.
- **Sources:** `man 1ssl openssl-ca`, `man 1ssl openssl-x509`, `man 1ssl openssl-verify` (OpenSSL
  3.0.13); RFC 5280 Sections 4.2.1.9, 4.2.1.10 and 6.1, <https://www.rfc-editor.org/rfc/rfc5280>;
  RFC 5737, <https://www.rfc-editor.org/rfc/rfc5737>; RFC 3849, <https://www.rfc-editor.org/rfc/rfc3849>;
  RFC 6761, <https://www.rfc-editor.org/rfc/rfc6761>.
- **Done when:** each miss is explained, and Sam says what a stolen intermediate can sign.

## 10 — Short-lived leaves for services

- **Objective:** Sam can issue a short-lived server leaf from the lab intermediate, serve it on
  127.0.0.1 on a port above 1023, and verify it with `openssl s_client` and `curl --cacert`.
- **Builds on:** lesson 09.
- **Key ideas:**
  - The service makes its own key and a certificate signing request; the key never travels.
  - The name goes in subjectAltName, not the common name (RFC 9525).
  - Extended key usage `serverAuth` limits the leaf to serving.
  - The server sends the chain (leaf and intermediate); the client holds only the root.
  - `openssl ca -enddate` sets a lifetime under a day, which `-days` cannot.
- **Recall targets:** say which party makes the key, where the name must be, and what the server has
  to send.
- **Build:** a `cert-check` crate under `code/src/rust/crates/msNNN_<snake>/` that reads a certificate
  and reports its names, key usages and remaining lifetime. It is parse-only: `x509-parser` without
  its `verify` feature (version, licence and dependency graph checked at `/teach` step 3), run through
  `cargo deny check` straight after `cargo add`. Time is injected in tests, and the fixtures are
  certificates only, never keys. Passes the gates.
- **Security lens:** a leaf that lives for hours limits what a stolen service key is worth.
- **Safety:** loopback only, on an unprivileged port; the lab CA's keys stay in `$XDG_RUNTIME_DIR`
  and are destroyed; no test fixture holds a private key.
- **Sources:** `man 1ssl openssl-ca`, `man 1ssl openssl-req`, `man 1ssl openssl-s_client` (OpenSSL
  3.0.13); `man 1 curl` (8.5.0); RFC 5280 Sections 4.2.1.6 and 4.2.1.12,
  <https://www.rfc-editor.org/rfc/rfc5280>; RFC 9525, <https://www.rfc-editor.org/rfc/rfc9525>.
- **Done when:** the service is reached without warnings, a wrong name is refused, and the crate
  passes the gates.

## 11 — Revocation versus short lifetimes

- **Objective:** Sam can revoke a lab leaf, publish a CRL, show `openssl verify` refusing the leaf only
  under `-crl_check`, and argue when a short lifetime replaces revocation.
- **Builds on:** lessons 09–10.
- **Key ideas:**
  - A CRL (RFC 5280 Section 5) is a signed list of revoked serial numbers; OCSP (RFC 6960) answers
    for one certificate at a time.
  - Revocation that no client checks is false comfort: `verify` accepts a revoked leaf unless asked.
  - RFC 9608's no-rev-avail extension says that no revocation information will be published for a
    certificate.
  - The offline root still publishes a CRL for its intermediates, on a schedule.
  - The real CA's recovery drill is `os-18-own-network-operations` lesson 09.
- **Recall targets:** say what a client must do for revocation to count, and what a short lifetime
  gives up.
- **Build:** none in code. A recorded run: revoke, publish the CRL, verify with and without
  `-crl_check`.
- **Security lens:** the choice between revocation and short lifetimes is a choice about which failure
  is tolerable — a stale CRL or an expired leaf.
- **Sources:** `man 1ssl openssl-ca` (`-revoke`, `-gencrl`), `man 1ssl openssl-verification-options`
  (`-crl_check`) (OpenSSL 3.0.13); RFC 5280 Section 5, <https://www.rfc-editor.org/rfc/rfc5280>;
  RFC 6960, <https://www.rfc-editor.org/rfc/rfc6960>; RFC 9608, <https://www.rfc-editor.org/rfc/rfc9608>.
- **Done when:** the result is recorded, and Sam states the lifetime below which the lab stops
  publishing leaf CRLs.

## 12 — Distributing the root to trust stores

- **Objective:** Sam can make each client trust the lab root per application without root privileges,
  and system-wide only inside a VM guest, then remove it again.
- **Builds on:** lessons 08–11; `os-09-networking-fundamentals` lesson 05 (the lab and its QEMU guests).
- **Key ideas:**
  - Name constraints are what make a home root safe to trust; where a client ignores them, trust stays
    per application.
  - Per application, without root: `curl --cacert`, `SSL_CERT_FILE` for OpenSSL-based programs, and a
    per-user NSS database through `certutil`.
  - System-wide: a file in `/usr/local/share/ca-certificates/` plus `update-ca-certificates` needs
    root, so Sam runs it in a VM guest; `trust list` shows what p11-kit sees.
  - Removal is part of the job: a lab root left trusted is a standing risk.
- **Recall targets:** name each client's trust store and the command that adds and removes the root.
- **Build:** none in code. Until a lab guest exists, the system-wide step is reading only.
- **Security lens:** every store the root enters widens what a stolen intermediate can reach.
- **Safety:** the host's system trust store is never changed for a lab root; the system-wide step runs
  in a VM guest, and Sam runs it — Claude never runs `sudo`.
- **Sources:** `man 8 update-ca-certificates` (ca-certificates 20260601~24.04.1); `man 1 trust`
  (p11-kit 0.25.3); `man 1 certutil` (libnss3-tools 3.98); `man 7ssl openssl-env` (`SSL_CERT_FILE`);
  `man 1 curl` (8.5.0).
- **Done when:** each client trusts the lab root, then refuses it after removal.

## 13 — A standing ACME issuer for short-lived leaves

- **Objective:** Sam can walk ACME's steps and run the ADR-chosen issuer under a lab intermediate so
  that a lab leaf renews unattended.
- **Builds on:** lessons 09–12; `sec-04-linux-security-model` lesson 07 (the sandbox launcher);
  `os-14-router-edition` lesson 03 (the lab resolver).
- **Key ideas:**
  - RFC 8555: an account, an order, its authorisations and challenges, then finalising and
    downloading; RFC 8737 adds the TLS-ALPN challenge.
  - Automation is what makes short lifetimes safe: renewal that no one has to remember.
  - The issuer holds the intermediate's key online, so it runs sandboxed through sec-04's launcher.
  - The issuer is chosen by the ACME-issuer research note (planned — `research/PRIVATE-CA-ACME-ISSUER.md`)
    and then an ADR; dns-01 reuses os-14 lesson 03's lab resolver.
- **Recall targets:** put ACME's steps in order and say which one proves control of the name.
- **Build:** lab only, configuration only — the chosen issuer under a lab intermediate, renewing a lab
  leaf. **Blocked** until an issuer is chosen (`GAPS.md` → "No ACME issuer chosen for the private CA").
- **Efficiency lens:** the issuer's resident memory and CPU at idle and per issuance.
- **Security lens:** the online intermediate key is what the issuer must protect; the sandbox and the
  name constraints bound its loss.
- **Safety:** the isolated lab only; the issuer runs sandboxed; no key enters any repository.
- **Sources:** RFC 8555, <https://www.rfc-editor.org/rfc/rfc8555>; RFC 8737,
  <https://www.rfc-editor.org/rfc/rfc8737>; the chosen issuer's own documentation, pinned when its ADR
  lands.
- **Done when:** a leaf with a life of a day or less renews unattended twice.
