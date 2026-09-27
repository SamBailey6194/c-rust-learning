# ADR-MS001: Private CA — an offline root and intermediate made by hand, an ACME issuer for leaves

| Field | Value |
| --- | --- |
| **ID** | ADR-MS001-PRIVATE-CA-OFFLINE-ROOT-AND-ACME |
| **Status** | Proposed |
| **Date** | 27/09/2026 |
| **Milestone** | MS001 — Toolchain ready · `project-management/src/02-MILESTONES/MS001-TOOLCHAIN-READY.md` |
| **Deciders** | Sam Bailey |
| **Supersedes** | — |
| **Superseded by** | — |
| **Research** | `research/PRIVATE-CA-CLIENT-SUPPORT.md` (planned) — which clients enforce name constraints, which trust store each reads, and a primary source for Certificate Transparency; it gates Acceptance. `research/PRIVATE-CA-ACME-ISSUER.md` (planned) grounds the follow-on issuer ADR |
| **Enforced in** | `learning/sec-05-applied-cryptography/SYLLABUS.md` → lessons 08–13 · `learning/ui-10-web-admin-dashboard/SYLLABUS.md` → lesson 05 |

---

## Context

Several Later topics need certificates for services on Sam's own network: the web dashboard's TLS
(`learning/ui-10-web-admin-dashboard/SYLLABUS.md` lesson 05, which left the certificate choice for a
device on a home network to be decided when the topic opens), the services of
`learning/os-18-own-network-operations/` (lesson 06), and the mutual TLS of
`learning/ui-11-consent-first-remote-help/` (lesson 03). On 27/09/2026 Sam answered how: a private
certificate authority whose offline root and intermediate he makes by hand with `openssl`, then a
standing ACME issuer, chosen by research, that signs short-lived leaves. This record argues that
hierarchy. Which issuer product runs it is a separate, later record.

This record is **Proposed**. Its case for a root of Sam's own in his trust stores rests on name
constraints limiting what a stolen intermediate can sign, and whether the clients Sam uses enforce
them has not been checked (Research row).

Facts checked on 27/09/2026:

- **The tools are installed.** `openssl version` reports OpenSSL 3.0.13 (30 Jan 2024), and the
  package's copyright file gives its licence as Apache-2.0 (Sources, items 4 and 5). The lessons run
  `openssl` as a separate program and never link it into code here, so it does not pass through the
  crate licence gate in `code/src/rust/deny.toml`. The trust-store tools are installed too:
  libnss3-tools 3.98, p11-kit 0.25.3 and ca-certificates 20260601~24.04.1 (`dpkg-query -W`).
- **Basic constraints bound the hierarchy.** The cA flag is what lets a certified key verify
  certificate signatures, and pathLenConstraint caps how many further non-self-issued intermediates
  may follow; zero allows none (Sources, item 1, Section 4.2.1.9).
- **Name constraints bound what a CA may name.** The extension is used only in CA certificates, and
  every subject name in later certificates on the path must fall inside the name space it permits;
  conforming CAs must mark it critical (Sources, item 1, Section 4.2.1.10). Whether a given client
  enforces it, above all on a trust anchor, is **not verified here**.
- **Revocation and validation are specified.** CRLs are profiled in RFC 5280 Section 5 and path
  validation in Section 6.1 (Sources, item 1). Whether a short lifetime can stand in for revocation
  is argued in `learning/sec-05-applied-cryptography/SYLLABUS.md` lesson 11, not here.
- **Issuance can be automated.** ACME (RFC 8555, March 2019) automates certificate issuance and
  defines HTTP and DNS challenges (its Sections 8.3 and 8.4); RFC 8737 adds a TLS-ALPN challenge
  (Sources, items 2 and 3).
- **Public certificates are logged in public.** Public CAs submit the certificates they issue to
  Certificate Transparency logs, so an internal name under a public domain would become public. The
  primary source for this is still to be cited by `research/PRIVATE-CA-CLIENT-SUPPORT.md`; it is
  **unverified here**.
- **The ground is already laid.** `learning/sec-05-applied-cryptography/SYLLABUS.md` lessons 05 (key
  exchange and TLS at protocol level) and 06 (key management) come before any CA lesson, and
  `.claude/CLAUDE.md` Section 5's public-repository hygiene keeps every private key out of this
  repository.
- **Sam's answer of 27/09/2026 on the private CA:** an offline root and an intermediate made by hand
  with `openssl`, then a standing ACME issuer chosen by `/research`.

Clash check (`project-management/workflows/08-decisions/STEPS.md` Step 3):

- **`ADR-MS001-NETWORK-LAB-FIRST-GRADUATION-PATH-27-09-2026.md`** — consistent. Every CA made in a
  lesson is a throwaway lab CA; the real CA is built only under that path, whose rule 8 lists CA
  trust anchors among what may graduate and whose rule 3 lets the root into the study host's trust
  store as userspace configuration. A lab root is trusted system-wide only inside a VM guest; on the
  host, a lab root is trusted per application.
- **`ADR-MS001-SECURITY-TRACK-AND-LAB-RULES-27-09-2026.md`** — unaffected; nothing here is offensive
  work.
- **`ADR-MS001-LLM-RUST-CRATE-LICENCES-27-09-2026.md`** — unaffected: `openssl` is run, not linked,
  and any crate a CA lesson adds goes through `cargo deny check` like every other.
- **`ADR-MS001-REMOTE-HELP-TOOL-CONSENT-FIRST-27-09-2026.md`** (Proposed) — consistent. Its constraint
  9 takes both ends' session identities from this CA and pins the intermediate in the tool's own trust
  file, not a system trust store. Whether a helped person's leaf may sit on a family device is argued
  in that record's clash check against the graduation path.
- **The product-licence records** (`ADR-MS001-PRODUCT-LICENCES-INBOUND-RULES-27-09-2026.md`,
  `ADR-MS001-PRODUCT-LICENCES-APPROVED-OUTBOUND-LIST-27-09-2026.md` and
  `ADR-MS001-PRODUCT-COMPONENT-REGISTER-SPDX-SBOM-27-09-2026.md`, all Proposed) — unaffected. A CA is
  run, not shipped: lesson CAs stay in lessons, and the real CA's configuration lives in the private
  infrastructure repository, which takes no entry and keeps no register.
- **The scripted-recorder records**
  (`ADR-MS001-SCRIPTED-RECORDER-STAGED-LEARNING-PROJECT-27-09-2026.md`,
  `ADR-MS001-CAPTURE-LIBRARY-STANDALONE-27-09-2026.md`) — unaffected; neither uses a certificate.

## Options considered

### Option A — A private CA by hand, then an ACME issuer for leaves

- **Summary:** An offline root, and one intermediate with a path length of zero and name
  constraints, both made by hand with `openssl`. A standing ACME issuer holds the intermediate's key
  and signs short-lived leaves for services.
- **Pros:** X.509 is learned by hand before anything is automated. The root stays offline, so using
  it needs physical access. Name constraints limit a stolen intermediate to Sam's own names, if the
  clients enforce them. Short lifetimes shrink what revocation has to carry. No internal name is
  published anywhere.
- **Cons:** A CA to operate: the root ceremony, encrypted backups and a recovery drill. The value of
  the constraints depends on client enforcement, which is unverified. The issuer's intermediate key
  is online and has to be protected. The root has to reach every trust store, and some stores need
  root to change.

### Option B — Public-CA certificates through dns-01

- **Summary:** Certificates from a public ACME CA for names under a registered domain, validated
  through DNS.
- **Pros:** Every client already trusts them; there is no root to distribute or protect.
- **Cons:** It needs a registered public domain and a DNS-provider credential on the network. Every
  internal name would be published in Certificate Transparency logs (source to be supplied by
  `research/PRIVATE-CA-CLIENT-SUPPORT.md`). Nothing about how a CA works is learned, and lifetimes
  are the public CA's to set.

### Option C — A turnkey CA product

- **Summary:** One product generates the root, the intermediate and the ACME endpoint together.
- **Pros:** The fastest route to working leaves.
- **Cons:** The hierarchy's extensions and constraints are generated rather than learned. The
  product choice is itself open and unresearched, and where the root key lives follows the
  product's defaults unless they are changed.

### Option D — A self-signed certificate per service, pinned by each client

- **Summary:** No CA; each service presents its own self-signed certificate and each client pins it.
- **Pros:** No hierarchy to run; each pin is exact.
- **Cons:** Every client pins every service, and every renewal means re-pinning everywhere, so
  lifetimes drift long. There is no revocation path, and it does not fit the remote-help tool's
  mutual TLS.

### Option E — Do nothing

- **Summary:** Plain HTTP on the management network, or certificate warnings clicked through.
- **Pros:** No work.
- **Cons:** `learning/ui-10-web-admin-dashboard/SYLLABUS.md` lesson 05 cannot meet its objective of an
  encrypted connection, and clicking through warnings trains the habit that makes interception work.

## Decision

**Proposed: Option A — an offline root and a constrained intermediate made by hand with `openssl`,
and a standing ACME issuer for short-lived leaves.** The deciding factor is that the mechanics are
learned by hand, the root stays offline, only the leaves are automated, and internal names stay
private. Option B is the runner-up: it removes the problem of distributing a root, but it publishes
every name and teaches nothing about the hierarchy.

The answer flips if the clients Sam uses ignore name constraints — a root of his own in their trust
stores would then vouch for any name — or if Sam decides that publishing his internal names in
Certificate Transparency logs is acceptable, which would make Option B the simpler choice.

To move to `Accepted`: `research/PRIVATE-CA-CLIENT-SUPPORT.md` lands and shows that the clients Sam
uses enforce name constraints, or names those that do not and the per-application trust that
contains them; then Sam signs off. The issuer product is not decided here:
`research/PRIVATE-CA-ACME-ISSUER.md` feeds a follow-on ADR.

## Consequences

- **Positive:** `learning/ui-10-web-admin-dashboard/SYLLABUS.md` lesson 05's deferred choice has an
  answer. One CA serves the dashboard, Sam's own network and the remote-help tool. The hierarchy is
  taught by hand before any automation.
- **Negative:** An operated CA: the root ceremony, encrypted backups of key material outside every
  git repository, and a recovery drill. Until the client-support note lands, the safety of a root of
  Sam's own rests on an unverified assumption. The issuer's intermediate key is online, so the
  issuer runs sandboxed through `learning/sec-04-linux-security-model/`'s launcher.
- **Follow-on:**
  - `learning/sec-05-applied-cryptography/SYLLABUS.md` appends lessons 08–13 on the Later path;
    lesson 13 is Blocked until the issuer is chosen.
  - `GAPS.md` logs "No ACME issuer chosen for the private CA": `research/PRIVATE-CA-ACME-ISSUER.md`,
    then the issuer ADR, then Sam installs it and records it in `how-to/docs/TOOLCHAIN.md`, which
    also records `openssl` and the trust-store tools.
  - The real CA is built only under `ADR-MS001-NETWORK-LAB-FIRST-GRADUATION-PATH-27-09-2026.md`
    (`learning/os-18-own-network-operations/` lesson 06); its recovery drill is that topic's
    lesson 09.
  - Every CA made in a lesson is a throwaway lab CA whose keys never enter any repository; `.gitignore`
    gains private-key patterns as a backstop.
  - `learning/ui-11-consent-first-remote-help/` lesson 03 takes its client certificates (mutual TLS)
    from this CA.

## Sources

1. **RFC 5280, Internet X.509 Public Key Infrastructure Certificate and CRL Profile** —
   <https://www.rfc-editor.org/rfc/rfc5280> — basic constraints and path length (Section 4.2.1.9),
   name constraints (Section 4.2.1.10), the CRL profile (Section 5) and basic path validation
   (Section 6.1), checked 27/09/2026
2. **RFC 8555, Automatic Certificate Management Environment (ACME)** —
   <https://www.rfc-editor.org/rfc/rfc8555> — automated issuance; the HTTP and DNS challenges
   (Sections 8.3 and 8.4), checked 27/09/2026
3. **RFC 8737, ACME TLS Application-Layer Protocol Negotiation (ALPN) Challenge Extension** —
   <https://www.rfc-editor.org/rfc/rfc8737>, checked 27/09/2026
4. **Host commands, 27/09/2026** — `openssl version`;
   `dpkg-query -W openssl libnss3-tools p11-kit ca-certificates`
5. **The openssl package's copyright file** — `/usr/share/doc/openssl/copyright` on the host
   (Apache-2.0), read 27/09/2026
6. **Sam's answer of 27/09/2026, networking and licensing round** — the private CA: an offline root
   and an intermediate by hand, then an ACME issuer chosen by research
