# research/ — Primary-Source Research Notes

**Last Updated**: 28/09/2026 | **Version**: 0.1.0 | **Maintained By**: Sam Bailey
**Language**: British English (en_GB) | **Timezone**: Europe/London

The evidence layer beneath decisions. Each note answers one question (a C standard choice, a
warning-flag set, a kernel configuration baseline, an init system for Syntek OS, a crate licence)
against primary sources, with a citation on every claim, and feeds something that acts on it: an
ADR in `project-management/src/08-DECISIONS/`, a Syntek OS profile spec in
`project-management/src/07-OS-PROFILES/`, a kernel spec in `project-management/src/06-KERNEL/`, or
a learning topic's `RESOURCES.md`. The `research` skill writes every note.

## Directory Tree

```text
research/
├── CONTEXT.md · CLAUDE.md          ← this orientation · the citation and licence guardrails
└── <SCREAMING-KEBAB-TOPIC>.md      ← one note per question, created by /research (none yet)
```

Source documents are not stored here. A PDF of a standard or a chapter of a book committed to a
public repo is redistribution, so each note pins its sources by URL plus version, tag, commit or
retrieval date instead.

## Suggested first questions

The scaffold's defaults were set before any note existed, so the first notes back them with
evidence or challenge them. A `C-STANDARD-CHOICE-C11-C17-C23.md` note would ground the C17 ADR
(`project-management/src/08-DECISIONS/ADR-MS001-C-STANDARD-C17-27-09-2026.md`) and set out what C23
changes before the planned revisit. A `GCC-WARNING-FLAG-SET.md` note would trace each flag in
`code/docs/BUILD.md` to the GCC manual and say what each one catches.

Before P4, a `RUST-FOR-LINUX-STATUS.md` note would establish what the kernel's Rust support covers
at the kernel version the repo pins, and what toolchain it needs (the host has no clang or bindgen
yet; `how-to/docs/TOOLCHAIN.md`). A `KERNEL-CONFIG-BASELINE-TINYCONFIG-VS-DEFCONFIG.md` note would
choose the starting configuration the per-profile fragments build on, and
`LTS-VS-STABLE-PER-PROFILE.md` which kernel line each Syntek OS profile tracks — the follow-on the
downstream-kernel ADR names.

Before P6, four notes shape Syntek OS itself: `INIT-SYSTEM-CHOICE.md` (the init Syntek OS ships,
parked in `DEFERRED.md` until an ADR settles it), `BOOTLOADER-CHOICE.md`,
`PACKAGE-SIGNING-SCHEME.md`, and `SYNTEK-OS-PROFILE-DEFINITIONS.md`, which feeds
`project-management/src/07-OS-PROFILES/PROFILE-MATRIX.md`. How Syntek OS is built is already
answered, by `project-management/src/08-DECISIONS/ADR-MS001-SYNTEK-OS-INDEPENDENT-FROM-SCRATCH-27-09-2026.md`.

For the UI and LLM tracks, `GUI-TOOLKIT-LICENCE.md` and `LLM-RUST-CRATE-LICENCES.md` would ground
the two licence ADRs with evidence, as the C17 note grounds its ADR. `PYTORCH-SM75-SUPPORT.md` and
`CUDA-TOOLKIT-FOR-DRIVER-580.md` would settle, before L1 and L2, which PyTorch build and which CUDA
toolkit suit this machine's RTX 2080 Ti (compute capability 7.5, driver 580). `LLM-SANDBOX-DESIGN.md`
would design the sandbox that model- and skill-generated code runs in.

For the security track, `PENTEST-LAB-NETWORK-ISOLATION.md` would show how the lab network is kept
from reaching the home LAN, and `VULNERABLE-TARGET-LICENCES.md` which intentionally vulnerable
targets the lab may use and publish work on.

The networking and licensing round of 27/09/2026 planned thirteen more, grouped by what they feed.
Sam's own network rests on `HOME-NETWORK-OPERATION-LAW.md` (`os-18` lessons 03 and 07). The
remote-help tool's ADR waits on `REMOTE-HELP-CONSENT-AND-THE-COMPUTER-MISUSE-ACT.md` (also `ui-11`
lesson 01 and `os-18` lesson 10), `REMOTE-HELP-TOOL-AND-SECTION-3A.md`,
`REMOTE-HELP-SESSION-RECORDS-AND-UK-GDPR.md` (`ui-11` lesson 06) and `DUAL-USE-TOOLS-ON-GITHUB.md`
(with the section 3A note, `ui-11` lesson 09); `RUST-MTLS-STACK-LICENCES.md` picks its crypto
provider (`ui-11` lesson 03). The private CA's ADR waits on `PRIVATE-CA-CLIENT-SUPPORT.md` (also
`sec-05` lessons 09 and 12), and `PRIVATE-CA-ACME-ISSUER.md` chooses its issuer (`sec-05` lesson 13).
The three product-licence records wait on `PRODUCT-CONTRIBUTIONS-DCO-AND-CLA.md`,
`PRODUCT-OUTBOUND-LICENCE-COMPATIBILITY.md` and `SBOM-FORMATS-AND-GENERATORS.md` (also `tooling-05`
lesson 08). Two open questions in `GAPS.md` that block first public releases wait on
`SYNTEK-OS-TRADEMARK-POLICY.md` and `CRYPTOGRAPHY-EXPORT-RULES.md`.

The scripted-recorder round of the same day planned one: `HYPRLAND-HEADLESS-CAPTURE-AND-INPUT.md`,
written when `ui-12` opens, on how headless Hyprland runs in a guest. The portal questions of `ui-13`
wait on a note named when that topic opens. All thirty named here are planned, not yet written.

## Boundary with Context7

For one library's or tool's own API (a `std` function, a crate, a cargo or clippy flag), the
Context7 MCP answers directly. A note here is for synthesis across primary sources: a comparison,
the groundwork for an ADR, or how a standard or the kernel actually behaves.

## When to read this

- Before proposing an ADR, a kernel spec or an OS profile spec whose choice is not obvious.
- When a lesson's source is contested, or two sources disagree.
- Before quoting any external text anywhere in the repo: the licence guardrails in
  `research/CLAUDE.md` apply repo-wide.

## Do not use for

- A single library or tool lookup → the Context7 MCP (`resolve-library-id` → `query-docs`)
- A durable fact that feeds no decision → `.claude/MEMORY.md`
- Lesson notes in Sam's words → `learning/CONTEXT.md`
- The decision itself → `project-management/src/08-DECISIONS/`

## Key docs

| Guide | When to read |
| --- | --- |
| `.claude/skills/research/SKILL.md` | Before any note: the steps, the primary-source list, the licence ladder, the note format |
| `project-management/workflows/08-decisions/` | When a note feeds an ADR |
| `project-management/workflows/07-os-profile-spec/` | When a note feeds a Syntek OS profile spec |
| `REFERENCES.md` | The index of external primary sources the repo cites repeatedly |

## Cross-references

- `research/CLAUDE.md`: how to work here, and the two guardrails that matter most in a public repo.
- `project-management/src/08-DECISIONS/ADR-MS000-TEMPLATE.md`: the ADR a note usually feeds.
- `project-management/src/07-OS-PROFILES/PROFILE-000-TEMPLATE.md`: the profile spec an OS note feeds.
- `LICENSE`: the GPL-2.0-only licence any quotation sits beside.
