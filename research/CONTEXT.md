# research/ — Primary-Source Research Notes

**Last Updated**: 27/09/2026 | **Version**: 0.1.0 | **Maintained By**: Sam Bailey
**Language**: British English (en_GB) | **Timezone**: Europe/London

The evidence layer beneath decisions. Each note answers one question (a C standard choice, a
warning-flag set, a kernel configuration baseline, a distro build system) against primary sources,
with a citation on every claim, and feeds something that acts on it: an ADR in
`project-management/src/08-DECISIONS/`, a distro tier spec in `project-management/src/07-DISTRO-TIERS/`,
a kernel spec in `project-management/src/06-KERNEL/`, or a learning topic's `RESOURCES.md`. The
`research` skill writes every note.

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
choose the starting configuration the per-tier fragments build on.

Before P6, four notes shape the distributions themselves:
`DISTRO-BUILD-SYSTEM-LFS-VS-BUILDROOT-VS-YOCTO.md`, `INIT-SYSTEM-CHOICE.md`, `BOOTLOADER-CHOICE.md`,
and `DISTRO-TIER-DEFINITIONS.md`, which feeds
`project-management/src/07-DISTRO-TIERS/TIER-MATRIX.md`. All eight are planned, not yet written.

## Boundary with Context7

For one library's or tool's own API (a `std` function, a crate, a cargo or clippy flag), the
Context7 MCP answers directly. A note here is for synthesis across primary sources: a comparison,
the groundwork for an ADR, or how a standard or the kernel actually behaves.

## When to read this

- Before proposing an ADR, a kernel spec or a tier spec whose choice is not obvious.
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
| `project-management/workflows/07-distro-tier-spec/` | When a note feeds a tier spec |
| `REFERENCES.md` | The index of external primary sources the repo cites repeatedly |

## Cross-references

- `research/CLAUDE.md`: how to work here, and the two guardrails that matter most in a public repo.
- `project-management/src/08-DECISIONS/ADR-MS000-TEMPLATE.md`: the ADR a note usually feeds.
- `project-management/src/07-DISTRO-TIERS/TIER-000-TEMPLATE.md`: the tier spec a distro note feeds.
- `LICENSE`: the GPL-2.0-only licence any quotation sits beside.
