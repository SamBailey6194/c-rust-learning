# how-to/docs/ — Operational Reference Guides

**Last Updated**: 27/09/2026 | **Version**: 0.1.0 | **Maintained By**: Sam Bailey
**Language**: British English (en_GB) | **Timezone**: Europe/London

Reference guides for **operating** this repository rather than writing its code: which toolchain it runs
on, which command does what, and how a guide here is written. They sit apart from `code/docs/` because
their reader is mid-session and looking something up, not deciding how code should be written. Each is
read in fragments and capped at 300 cloc code lines.

## Directory Tree

```text
how-to/docs/
├── CONTEXT.md · CLAUDE.md   ← this index · operating rules for this folder
├── TOOLCHAIN.md             ← owner of toolchain versions: prerequisites, P4, P6, L1–L2 and security packages, troubleshooting
├── CLI-TOOLING.md           ← every command by intent: C build, memory, debugging, Rust, docs, P4 preview
└── GUIDE-CRAFT.md           ← the reader, two homes, the runbook spine, command discipline
```

## Files

| Guide | Scope |
| --- | --- |
| `TOOLCHAIN.md` | The recorded tool versions (owner), including the later-track tools already installed; Ubuntu 24.04 and rustup prerequisites; the P4 kernel and Rust-for-Linux, P6 Syntek OS, L1–L2 LLM and security-track packages not yet installed; toolchain troubleshooting |
| `CLI-TOOLING.md` | The raw commands and the scripts that wrap them, grouped by intent, with a P4 preview of kernel and QEMU commands |
| `GUIDE-CRAFT.md` | The conventions behind every guide a person executes: the reader, the two homes and their length standards, the six-part spine, command discipline, execute-to-verify, scope |

## Cross-references

- `how-to/CONTEXT.md` — the layer these guides belong to
- `how-to/src/CONTEXT.md` — the other home: long-form runbooks, exempt from the length cap
- `how-to/workflows/06-write-a-guide/` — the procedure for adding or restructuring a guide here
- `code/docs/DOCUMENTATION-LENGTH.md` — the 300-line rule and the thin-index split
- `code/docs/BUILD.md` — the build flags and targets `CLI-TOOLING.md` shows how to run
