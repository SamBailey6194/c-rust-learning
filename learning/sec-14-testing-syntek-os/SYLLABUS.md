# Syllabus — sec-14-testing-syntek-os

**Track**: sec · **Phase**: S3 · **Path**: Later · **Detail**: outline · **Prerequisites**: sec-06 (isolated lab), sec-07 (recon), sec-03 (fuzzing), os-07 (package manager), os-08 (repositories and signing), os-10 (profiles and installer), os-11 (server edition)
**Status**: Planned · **Checked**: 27/09/2026 (sources re-verified by `/teach` step 3 before each lesson)

This topic attacks Sam's own Syntek OS in the lab, so a weakness is found by him before anyone else. It pentests the profile images, fuzzes the package manager and installer inputs, and treats repository metadata and the update flow as hostile input — the supply chain being the highest-value target for a distribution. It closes by wiring the durable tests into the build gates so a regression is caught. All work is on Sam's own systems inside the sec-06 isolated lab; nothing offensive touches a third party or the host. It is an **outline** topic because S3 is a far phase: its builds are sketched and its sources, checked on 27/09/2026, are re-verified when the topic opens.

| # | Lesson | Size | Build | Lenses |
| --- | --- | --- | --- | --- |
| 01 | Pentesting the profile images in the lab | 2–3 sittings | yes — profile-pentest | Safety |
| 02 | Fuzzing the package manager and installer inputs | multi-session build | yes — pm-fuzz | Security |
| 03 | Repository metadata as hostile input | 2–3 sittings | yes — meta-hostile | Security |
| 04 | Supply-chain attack simulations | 2–3 sittings | yes — supply-chain-lab | Safety |
| 05 | Turning tests into a regression suite | 2–3 sittings | yes — regress-suite | Efficiency |

---

## 01 — Pentesting the profile images in the lab

- **Objective:** Sam can run a scoped test against a Syntek OS profile image and confirm the sec-13 hardening actually holds.
- **Builds on:** sec-07's recon and enumeration; sec-12's scope discipline; sec-13's hardened images; os-11's server edition.
- **Key ideas:**
  - Treat the server, NAS and router images as lab targets: enumerate services, check exposure against the profile's intended surface.
  - Verify that the hardening from sec-13 resists the checks it claimed to — hardening asserted is not hardening proven.
  - A rules-of-engagement document (sec-12) governs even a test of your own systems.
  - Findings feed back into the profile and its deviations register.
- **Recall targets:** why testing your own hardened image is still scoped; the difference between an image's intended and actual attack surface.
- **Build:** run a scoped enumeration and check against a server-profile VM in the isolated lab and record findings. Planned: a test note in this topic folder; fixes land in the Syntek OS build-system repository (created when that build starts).
- **Safety:** isolated lab network only (the namespace-and-veth lab from os-09, set up in sec-06); own systems; no route to the home LAN.
- **Sources:** (checked 27/09/2026; re-verify when S3 opens) NIST SP 800-115 (<https://csrc.nist.gov/pubs/sp/800/115/final>); os-08 and os-11 for the intended surface (repo topics); tool `--help` at lesson open.
- **Done when:** Sam produces a scoped finding list for a profile image and each finding maps to a fix or an accepted deviation.

---

## 02 — Fuzzing the package manager and installer inputs

- **Objective:** Sam can build a fuzz harness for a Syntek OS parser and triage the crashes it finds.
- **Builds on:** sec-03's coverage-guided fuzzing, sanitisers and crash triage; os-07's package format and safe archive extraction; os-10's installer inputs.
- **Key ideas:**
  - Identify the attack surface: archive extraction, package metadata parsing, repository metadata, installer answers.
  - A fuzz harness feeds mutated input to one parser; sanitisers turn latent memory bugs into crashes.
  - Corpus, coverage and minimisation make fuzzing find more with less; triage separates distinct bugs.
  - This is where os-07's "safe extraction" (path traversal, symlinks, ownership) is proven, not assumed.
- **Recall targets:** the parser attack surfaces in a package manager; why sanitisers plus fuzzing find more than either alone.
- **Build:** a fuzz harness for the package-manager metadata or extraction parser, run with a small corpus, crashes triaged. Planned code path: a fuzz target in the Syntek OS package-manager repository (created when that build starts), or a lesson-scale harness under `code/src/rust/crates/` (planned). GAPS: `cargo-fuzz` needs the nightly toolchain and the workspace pins stable (`GAPS.md`); `proptest` (stable) is the in-workspace fallback.
- **Security lens:** hostile input is the threat; the parser must reject or contain it, never trust it.
- **Sources:** (checked 27/09/2026; re-verify when S3 opens) sec-03 for the fuzzing method (repo topic); os-07's `man 2 rename`, `man 2 fsync` for the crash-safe update path it protects; `proptest` docs via Context7 (`/proptest-rs/proptest`) for the stable fallback.
- **Done when:** the harness runs against a real parser, at least one class of malformed input is handled or a bug is triaged, and the finding is reproducible.

---

## 03 — Repository metadata as hostile input

- **Objective:** Sam can write test cases that prove the update client rejects malicious repository metadata.
- **Builds on:** os-08's repository metadata, signing and the secure update flow; sec-05's signatures; the TUF threat model from os-08.
- **Key ideas:**
  - The update client must verify signatures before acting on metadata — an unsigned or wrongly signed index is refused.
  - Replay, rollback and freeze attacks: an attacker serves old-but-valid or frozen metadata; the client must detect it (the TUF threat model).
  - Malformed metadata is a parser problem (lesson 02) and a trust problem (this lesson) at once.
  - Test cases assert the refusal, so a regression that weakens verification fails a test.
- **Recall targets:** what the update client must verify before trusting metadata; what a rollback or freeze attack is.
- **Build:** adversarial test cases against os-08's update flow — tampered signature, rolled-back version, frozen index — each asserting a refusal. Planned: test cases in the Syntek OS package-manager repository, which holds the update client (created when that build starts).
- **Security lens:** the repository is the highest-value target; verification failures are the finding.
- **Sources:** (checked 27/09/2026; re-verify when S3 opens) the TUF specification (pin the version at lesson open; introduced in os-08); os-08 signing (repo topic); sec-05 signatures (repo topic).
- **Done when:** each adversarial metadata case is refused by the client and asserted by a test.

---

## 04 — Supply-chain attack simulations

- **Objective:** Sam can simulate a compromised mirror or tampered package in the lab and confirm the client refuses it.
- **Builds on:** lesson 03; os-08's key management, rotation and compromise recovery.
- **Key ideas:**
  - A compromised mirror serving a tampered package is caught by signature verification, not transport security alone.
  - Key compromise: what recovery looks like (rotation, revocation, re-signing) and how a client learns of it.
  - Rollback protection stops an attacker downgrading to a known-vulnerable package.
  - The drill is defensive: prove the defence works, do not build a distributable attack.
- **Recall targets:** why signing beats transport security for package integrity; what key-compromise recovery requires.
- **Build:** in the lab, stand up a mirror serving a tampered package and confirm the client refuses it; run a key-rotation drill. Planned: a lab exercise; artefacts stay in the lab, never committed.
- **Safety:** isolated lab only; no working attack against any third-party repository; nothing weaponised leaves the lab.
- **Sources:** (checked 27/09/2026; re-verify when S3 opens) os-08 (repo topic); sec-05 signatures (repo topic); the TUF specification (pinned at lesson open).
- **Done when:** the client refuses the tampered package and the rotation drill restores a trusted state.

---

## 05 — Turning tests into a regression suite

- **Objective:** Sam can wire the durable adversarial tests into the build gates so a regression is caught automatically.
- **Builds on:** lessons 02–04; the repo's CI-and-gates model (os-05's CI-and-build-farms; the existing `.github/workflows/`).
- **Key ideas:**
  - Separate tests that run in CI (parser and metadata cases) from those that need a VM or the lab (image pentests).
  - A regression suite runs the metadata and extraction cases on every change, so a weakened check fails a gate.
  - CI has no privileged lab network and runs no VMs, so lab-only tests run locally with recorded evidence — the same pattern `GAPS.md` → "CI has no GPU" sets for GPU tests.
  - The suite is documentation of the threat model that stays true.
- **Recall targets:** which adversarial tests can run in CI and which need a VM; why a regression suite is worth the upkeep.
- **Build:** a test manifest wiring the CI-safe adversarial cases into the gates and listing the VM-only tests with their evidence path. Planned: a manifest in each repository whose gates run the cases — the Syntek OS package-manager and build-system repositories (created when those builds start).
- **Efficiency lens:** measure the added CI time; keep the fast CI-safe cases in the gate and the slow lab cases local.
- **Sources:** (checked 27/09/2026; re-verify when S3 opens) os-05 CI-and-build-farms (repo topic); the repo's `.github/workflows/` as the working CI pattern.
- **Done when:** the CI-safe adversarial cases run in a gate and the VM-only cases are listed with how their evidence is recorded.
