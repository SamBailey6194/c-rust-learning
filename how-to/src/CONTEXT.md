# how-to/src/ — Operator Runbooks

**Last Updated**: 27/09/2026 | **Version**: 0.1.0 | **Maintained By**: Sam Bailey
**Language**: British English (en_GB) | **Timezone**: Europe/London

The long-form documents a person follows from top to bottom: the full host setup for the toolchain, and
the pointer to where host maintenance lives. These are `how-to/src/*.md` runbooks, written in full and
exempt from the 300-line cap that applies to `how-to/docs/` and `how-to/workflows/`; this folder's own
`CONTEXT.md` and `CLAUDE.md` still keep within it.

## Directory Tree

```text
how-to/src/
├── CONTEXT.md · CLAUDE.md   ← this index · operating rules for this folder
├── MACHINE-SETUP.md         ← full Ubuntu 24.04 host setup runbook: Part A now, Part B at P4
└── HOST-MAINTENANCE.md      ← pointer stub → the reboot-purge repository, which owns host maintenance
```

## What is here

| Document | Read it when |
| --- | --- |
| `MACHINE-SETUP.md` | Setting up a machine from scratch and wanting the full runbook: prerequisites, failure modes, rollback, verification |
| `HOST-MAINTENANCE.md` | Looking for host cleanup or `apt upgrade` routines; it points at the reboot-purge repository |

## Do not use for

- Looking up a single command → `how-to/docs/CLI-TOOLING.md`
- Toolchain versions and troubleshooting → `how-to/docs/TOOLCHAIN.md`
- The short, checklist-driven setup → `how-to/workflows/01-toolchain-setup/`
- Writing code → `code/CONTEXT.md`

## Cross-references

- `how-to/CONTEXT.md` — the layer these runbooks belong to
- `how-to/docs/GUIDE-CRAFT.md` — the six-part spine every runbook here follows
- `how-to/workflows/06-write-a-guide/` — the procedure for adding a runbook here
- `https://github.com/SamBailey6194/reboot-purge` — the sibling repository `HOST-MAINTENANCE.md` points to
  (not yet published; `GAPS.md` tracks it)
