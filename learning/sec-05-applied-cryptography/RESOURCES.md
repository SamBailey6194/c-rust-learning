# Resources — sec-05-applied-cryptography

| Lesson | Primary source (pinned) | House guide | Code |
| --- | --- | --- | --- |
| 01 Hashes | RustCrypto, <https://github.com/RustCrypto>; libsodium, <https://doc.libsodium.org/> | — | `code/src/rust/crates/msNNN_<snake>/` (planned) |
| 02 MACs and AEAD | RustCrypto, <https://github.com/RustCrypto>; libsodium, <https://doc.libsodium.org/> | — | `code/src/rust/crates/msNNN_<snake>/` (planned) |
| 03 Symmetric encryption and nonces | RustCrypto, <https://github.com/RustCrypto>; libsodium, <https://doc.libsodium.org/> | — | `code/src/rust/crates/msNNN_<snake>/` (planned) |
| 04 Ed25519 signatures | RFC 8032, <https://www.rfc-editor.org/rfc/rfc8032>; `ed25519-dalek` 3.0.0, <https://docs.rs/ed25519-dalek> | — | `code/src/rust/crates/msNNN_<snake>/` (planned) |
| 05 Key exchange and TLS | RFC 8446, <https://www.rfc-editor.org/rfc/rfc8446> | — | — |
| 06 Key management | NIST SP 800-57 Part 1 Rev. 5, <https://csrc.nist.gov/pubs/sp/800/57/pt1/r5/final>; The Update Framework specification, <https://theupdateframework.github.io/specification/latest/> | — | — |
| 07 Using a vetted library | RustCrypto, <https://github.com/RustCrypto>; libsodium, <https://doc.libsodium.org/> | `code/docs/RUST-CODING-PRINCIPLES.md` | `code/src/rust/crates/msNNN_<snake>/` (planned) |
| 08 A private CA by hand: the offline root | `man 1ssl openssl-req`, `man 1ssl openssl-genpkey`, `man 5ssl x509v3_config` (OpenSSL 3.0.13); RFC 5280 Sections 4.1, 4.2.1.1–4.2.1.3 and 4.2.1.9, <https://www.rfc-editor.org/rfc/rfc5280> | `project-management/src/08-DECISIONS/ADR-MS001-PRIVATE-CA-OFFLINE-ROOT-AND-ACME-27-09-2026.md` | — |
| 09 The intermediate: path length and name constraints | `man 1ssl openssl-ca`, `man 1ssl openssl-x509`, `man 1ssl openssl-verify` (OpenSSL 3.0.13); RFC 5280 Sections 4.2.1.9, 4.2.1.10 and 6.1; RFC 5737, <https://www.rfc-editor.org/rfc/rfc5737>; RFC 3849, <https://www.rfc-editor.org/rfc/rfc3849>; RFC 6761, <https://www.rfc-editor.org/rfc/rfc6761> | — | — |
| 10 Short-lived leaves for services | `man 1ssl openssl-ca`, `man 1ssl openssl-req`, `man 1ssl openssl-s_client` (OpenSSL 3.0.13); `man 1 curl` (8.5.0); RFC 5280 Sections 4.2.1.6 and 4.2.1.12; RFC 9525, <https://www.rfc-editor.org/rfc/rfc9525> | `code/docs/RUST-CODING-PRINCIPLES.md` | `code/src/rust/crates/msNNN_<snake>/` (planned) |
| 11 Revocation versus short lifetimes | `man 1ssl openssl-ca`, `man 1ssl openssl-verification-options` (OpenSSL 3.0.13); RFC 5280 Section 5; RFC 6960, <https://www.rfc-editor.org/rfc/rfc6960>; RFC 9608, <https://www.rfc-editor.org/rfc/rfc9608> | — | — |
| 12 Distributing the root to trust stores | `man 8 update-ca-certificates` (ca-certificates 20260601~24.04.1); `man 1 trust` (p11-kit 0.25.3); `man 1 certutil` (libnss3-tools 3.98); `man 7ssl openssl-env`; `man 1 curl` (8.5.0); `research/PRIVATE-CA-CLIENT-SUPPORT.md` (planned) | — | — |
| 13 A standing ACME issuer for short-lived leaves | RFC 8555, <https://www.rfc-editor.org/rfc/rfc8555>; RFC 8737, <https://www.rfc-editor.org/rfc/rfc8737>; the chosen issuer's documentation, pinned when its ADR lands | — | lab configuration only; **Blocked** (`GAPS.md` → "No ACME issuer chosen for the private CA") |
