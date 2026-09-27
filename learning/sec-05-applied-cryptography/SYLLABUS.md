# Syllabus — sec-05-applied-cryptography

**Track**: sec · **Phase**: S1 · **Path**: Core · **Detail**: full · **Prerequisites**: P2; P3 for the library-usage builds; sec-01
**Status**: Planned · **Checked**: 27/09/2026 (sources re-verified by `/teach` step 3 before each lesson)

This topic teaches cryptography as a user, not an inventor: what each primitive guarantees, which one
solves a given problem, and how to reach for a vetted library rather than a home-made construction.
It is Core because the package manager and repository signing (os-07, os-08) and the first
server/homelab edition (os-11) depend on it — Syntek OS cannot ship a trustworthy update without
signatures and key management done correctly. Every build uses an audited library that passes the
licence gate (the RustCrypto crates, `ed25519-dalek` or libsodium; lesson 07 shows why `ring` does
not); any primitive implemented by hand is a learning toy, clearly marked never-for-use.

| # | Lesson | Size | Build | Lenses |
| --- | --- | --- | --- | --- |
| 01 | Hashes: what they guarantee and what they do not | 1 sitting | yes — hash-check | Security |
| 02 | MACs and authenticated encryption | 2–3 sittings | yes — mac-verify | Security |
| 03 | Symmetric encryption and nonces | 2–3 sittings | yes — aead-roundtrip | Security |
| 04 | Public-key signatures with Ed25519 | 2–3 sittings | yes — ed25519-sign | Security |
| 05 | Key exchange and TLS at protocol level | 1 sitting | no | Security |
| 06 | Key management: the hard part | 1 sitting | no | Security, Safety |
| 07 | Don't roll your own: using a vetted library | 1 sitting | yes — library-choice | Security |

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
