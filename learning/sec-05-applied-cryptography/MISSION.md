# Mission — sec-05-applied-cryptography

**Started**: not yet · **Family**: sec · **Phase**: S1 · **Milestone**: not yet allocated

## Why

_Drafted from Sam's planning conversation of 27/09/2026 — confirm or rewrite in your own words at
the first lesson._

Sam is building an independent distribution with its own package manager, repository and signing
keys, and asked for cybersecurity lessons alongside it. A distribution people install and update is
only as trustworthy as its cryptography: users have to know a package really came from Sam and was
not tampered with in transit or on a mirror. This topic teaches the primitives behind that —
hashes, MACs, authenticated encryption, Ed25519 signatures, key exchange and, hardest of all, key
management — as a competent user of vetted libraries rather than an inventor of ciphers. It feeds the
package-manager signing (os-07), the repository trust model (os-08) and the first server/homelab
edition (os-11).

## Can do it when

- Sam can state what a hash, a MAC and an AEAD each guarantee, and use each through a vetted library.
- Sam can sign and verify with Ed25519 and explain what a repository signature proves.
- Sam can explain Diffie-Hellman and the difference between TLS trust and package-signature trust.
- Sam can write a key-management plan (generation, storage, rotation, compromise recovery).
- Sam can choose an audited crypto library and justify not rolling his own.

## Parked for later

- Signing a real repository and key-compromise recovery in practice — os-08.
- The Linux security model that protects a key at rest — `sec-04`.
- Supply-chain attacks on the repository as test cases — a later S3 topic.
