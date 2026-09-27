# ADR-MS001: Crate licences — this repository stays GPL-2.0-only; Apache-2.0-only crates enter by documented exception

| Field | Value |
| --- | --- |
| **ID** | ADR-MS001-LLM-RUST-CRATE-LICENCES |
| **Status** | Accepted |
| **Date** | 27/09/2026 |
| **Milestone** | MS001 — Toolchain ready · `project-management/src/02-MILESTONES/MS001-TOOLCHAIN-READY.md` |
| **Deciders** | Sam Bailey |
| **Supersedes** | — |
| **Superseded by** | — |
| **Research** | — (primary sources and a cargo-deny run cited below); `research/LLM-RUST-CRATE-LICENCES.md` (planned) may extend the survey |
| **Enforced in** | `code/src/rust/deny.toml` (`[licenses] allow` and one `[[licenses.exceptions]]` entry per admitted crate, each citing this record) · `code/src/scripts/rust/audit.sh` |

---

## Context

This repository is licensed GPL-2.0-only, like the Linux kernel, and its cargo-deny policy
(`code/src/rust/deny.toml`) allows only permissive licences — MIT, BSD-2-Clause, BSD-3-Clause, ISC,
Zlib and Unicode-3.0. It deliberately leaves out Apache-2.0 on its own: the Free Software Foundation
lists the Apache License 2.0 as compatible with GPL version 3 but not with version 2, because of its
patent-termination and indemnification terms (Sources, item 1); the Apache Software Foundation says
the same of GPLv2 (Sources, item 2). A crate licensed `MIT OR Apache-2.0` passes on its MIT side.

The LLM and UI lessons want crates that are Apache-2.0 only. Facts checked on 27/09/2026 with
crates.io and a cargo-deny 0.19.0 run, using this repository's `deny.toml`, against scratch crates
outside the repository (Sources, items 3 and 4):

| Crate (version) | Licence | Why a lesson wants it | cargo-deny result |
| --- | --- | --- | --- |
| candle-core 0.11.0 | MIT OR Apache-2.0 | Rust tensors and inference | Rejected: its non-optional dependencies `safetensors` 0.8.0 and `tokenizers` 0.22.2 are Apache-2.0, and `tokenizers` brings `esaxx-rs` and `spm_precompiled` (Apache-2.0); `ryu` as below |
| safetensors 0.8.0 | Apache-2.0 | reading weight files | Rejected |
| tokenizers (0.22.2 via candle; 0.23.2 latest stable) | Apache-2.0 | a trained BPE tokeniser at inference | Rejected |
| hf-hub 1.0.0 | Apache-2.0 | fetching models from the Hugging Face Hub | Rejected (not run; licence from crates.io) |
| insta 1.48.0 | Apache-2.0 | snapshot tests for TUIs | Rejected (not run; licence from crates.io) |
| llama-cpp-2 0.1.157 | MIT OR Apache-2.0 | calling llama.cpp through FFI | Rejected at build time: `llama-cpp-sys-2` build-depends on `bindgen`, which pulls `clang-sys` 1.9.1 (Apache-2.0) |
| ratatui 0.30.2 | MIT | the TUI library | Rejected only on `ryu` 1.0.23, `Apache-2.0 OR BSL-1.0` — resolved by allowing `BSL-1.0`, which the FSF lists as GPL-compatible (Sources, item 1) |

Other facts:

- **What this repository distributes.** Source only. It publishes no binaries, packages or images.
  GPL version 2 covers copying, distribution and modification; running a program is outside its
  scope (the repository's own `LICENSE`, Section 0), and its binary-distribution terms (Section 3)
  apply only when object code is distributed.
- **Other repositories are coming.** Anything substantial that is built — the LLM inference code, the
  Syntek OS tools — gets its own repository when its build starts, with a licence Sam chooses
  (`ADR-MS001-ROADMAP-KERNEL-OS-UI-LLM-TRACKS-27-09-2026.md`).
- **Python is outside cargo-deny.** The Python packages the L-track uses for training (PyTorch, and
  Apache-2.0 packages such as `safetensors`, `tokenizers`, `transformers` and vLLM) are installed per
  project by uv; nothing in this repository audits their licences automatically.

## Options considered

### Option A — Stay GPL-2.0-only and avoid every Apache-2.0-only crate

- **Summary:** Hand-write what the crates provide: a safetensors reader (an 8-byte little-endian
  header length, a JSON header, raw tensor bytes), a BPE merge loop at inference, `TestBackend` buffer
  assertions instead of snapshot crates.
- **Pros:** No exception ever enters `deny.toml`; the hand-written readers are good lessons in their
  own right.
- **Cons:** Rules out candle, the standard tokenizer crate and the Hub client entirely, and even
  llama-cpp-2 fails on a build-time dependency — so the FFI route to llama.cpp is blocked as well.

### Option B — Stay GPL-2.0-only; admit named crates by documented per-crate exception

- **Summary:** Keep the allow list as it is (plus `BSL-1.0`); add one `[[licenses.exceptions]]` entry
  per Apache-2.0-only crate a lesson needs, each with a comment naming this record, the lesson and the
  reason.
- **Pros:** Lessons can use the ecosystem's standard crates. Each exception is visible, local and
  reviewable, and the policy still rejects every crate nobody chose.
- **Cons:** An exception does not remove the FSF incompatibility; it records a judgement that the
  incompatibility does not bite here because nothing is distributed. A repository that did distribute
  binaries could not rely on it.

### Option C — License the LLM crates GPL-3.0-or-later

- **Summary:** Apache-2.0 is compatible with GPLv3, so crates that link Apache-2.0 code take a GPLv3
  licence while kernel-facing code stays GPL-2.0-only.
- **Pros:** Removes the incompatibility for those crates.
- **Cons:** Two licences in one learning repository, and a boundary to police between them; GPLv3
  code cannot be combined back into GPL-2.0-only code (Sources, item 1).

### Option D — Relicense the whole repository

- **Summary:** Move to a permissive licence or GPL-3.0.
- **Pros:** No exceptions anywhere.
- **Cons:** Breaks the deliberate match with the Linux kernel's licence, which the kernel lessons
  rely on.

## Decision

**We will take Option B, with licences decided per repository.** This learning repository stays
GPL-2.0-only. Apache-2.0-only Rust crates that lessons need — candle's dependencies, safetensors,
tokenizers, hf-hub, insta, and build-time dependencies such as clang-sys — are admitted by documented
per-crate exceptions in `code/src/rust/deny.toml`, each citing this record. The deciding factor
(Sam's decision after the critique, 27/09/2026) is that this repository is for learning and
distributes no binaries, so the incompatibility the FSF describes, which arises on distribution, does
not arise here. Option A was the runner-up and remains the preferred route wherever the hand-written
version is itself the lesson.

Product repositories choose their own licences; `tooling-05-licensing-and-collaboration` teaches how,
including reading `cargo deny` output and writing an exception ADR.

**Python dependencies** are installed per project by uv into a local environment that is never
committed, and no Python package is vendored into this repository. Their licences are recorded in the
lesson's `RESOURCES.md`; whether importing one forms a combined work is not decided here, because it
only matters for a repository that distributes.

This answer changes if this repository ever distributes binaries, images or packages, or if an
admitted crate's licence changes; either is argued in a new ADR.

## Consequences

- **Positive:** candle, the tokenizer and Hub crates, insta and the llama.cpp bindings become usable
  in lessons, one visible exception at a time. The licence gate keeps rejecting everything nobody
  chose.
- **Negative:** `deny.toml` grows a list of exceptions to keep current; an exception whose crate
  leaves the graph must be deleted, or it silently admits the crate if it returns.
- **Follow-on:**
  - `code/src/rust/deny.toml` gains `BSL-1.0` in `[licenses] allow` and one exception per admitted
    crate, each naming the licence it allows and this record.
  - A lesson that adds an Apache-2.0-only crate names its exception in its Build sketch; lessons that
    can hand-write the capability (the safetensors header reader, the BPE merge loop) still do.
  - The GUI toolkit's build-time exception is argued in `ADR-MS001-GUI-TOOLKIT-GTK4-27-09-2026.md`.
  - Correction to the planning record: llama-cpp-2 does not pass the current policy on its own, as
    the planning notes assumed; it needs the `clang-sys` build-time exception.

## Sources

1. **FSF, Various licenses and comments about them** —
   <https://www.gnu.org/licenses/license-list.html> — Apache-2.0 compatible with GPLv3 only; Boost
   Software License GPL-compatible; GPLv3 not compatible with GPLv2 by itself. gnu.org timed out on
   27/09/2026, so checked via the Wayback Machine copy of 26/09/2026,
   <https://web.archive.org/web/20260926203802/https://www.gnu.org/licenses/license-list.html>
2. **Apache Software Foundation, Apache License v2.0 and GPL Compatibility** —
   <https://www.apache.org/licenses/GPL-compatibility.html>, checked 27/09/2026
3. **crates.io API** — `https://crates.io/api/v1/crates/<name>` and
   `https://crates.io/api/v1/crates/candle-core/0.11.0/dependencies` — versions, licences and
   candle-core's dependency list, checked 27/09/2026
4. **Host commands, 27/09/2026** — `cargo generate-lockfile`, `cargo tree -i <crate> -e normal,build`
   and `cargo deny check licenses` (cargo-deny 0.19.0) with this repository's `code/src/rust/deny.toml`,
   on scratch crates outside the repository depending on candle-core, llama-cpp-2 and ratatui
5. **safetensors format** — <https://github.com/safetensors/safetensors> — the header layout Option A
   would hand-parse, checked 27/09/2026
6. **Sam's decision after the critique, 27/09/2026** — licences are per repository; exceptions in
   this repository, justified by learning use and no binary distribution
