# Workflow: Write a Guide

**Last Updated**: 27/09/2026

A guide written from memory reads well and fails at the first step nobody ran. This workflow places a new
reference or runbook in the right home, holds it to that home's standard, and proves it by running it
before it is published.

## Directory Tree

```text
how-to/workflows/06-write-a-guide/
├── CONTEXT.md · CLAUDE.md   ← when to use, key concepts (this file) · operating rules
├── STEPS.md                 ← ordered steps, each closing on a "Done when" line
└── CHECKLIST.md             ← verification before the guide counts as published
```

## When to use this

- Adding a reference guide to `how-to/docs/` or a long-form runbook to `how-to/src/`.
- Restructuring or splitting an existing guide, for instance one that has grown past 300 cloc lines.
- Turning a procedure that has now been run twice by hand into something written down.

| Documentation kind | Where it goes |
| --- | --- |
| Operating the toolchain and host: setup, gates, environment faults | **here** → `how-to/docs/` or `how-to/src/` |
| How code is written: C and Rust principles, build, testing, memory safety | `code/docs/` |
| A `CONTEXT.md` / `CLAUDE.md` pair | the folder it describes, shaped per `code/docs/DOCUMENTATION-PAIRING.md` |
| Study notes on a topic | `learning/`, through `/teach` |
| A primary-source note settling a factual question | `research/`, through `/research` |
| Host maintenance (cleanup, upgrades) | the reboot-purge repository (`how-to/src/HOST-MAINTENANCE.md`) |
| Plans, specs and decisions | `project-management/` |

## Key concepts

- **Two homes, two standards.** `how-to/docs/` holds references read in fragments, capped at 300 cloc code
  lines. `how-to/src/` holds runbooks executed top to bottom, exempt from the cap. The standing rules are
  `how-to/docs/GUIDE-CRAFT.md`.
- **Reference or runbook.** A reference is looked up; a runbook is followed start to finish and takes the
  six-part spine: Purpose → Prerequisites → Steps → Failure modes → Rollback → Verification.
- **A guide you have not run is a guess.** Executing it from its own stated prerequisites is the step that
  finds the missing prerequisite and the under-specified step.
- **The command is the lesson.** Guides show the raw `gcc`, `make`, `gdb` or `cargo` command first, then
  name the `code/src/scripts/` script that wraps it.
- **Cite rather than paste.** Tool behaviour is checked against primary sources (man pages, the GCC and Rust
  manuals, docs.kernel.org) and linked; copyrighted text stays where it is.
- **Indexing is part of writing.** A new file lands in its folder's `CONTEXT.md` tree and in
  `how-to/REFERENCES.md` in the same change.

## Cross-references

### Governing documents

- `how-to/docs/GUIDE-CRAFT.md` — the reader, the two homes, the spine, command discipline
- `code/docs/DOCUMENTATION-LENGTH.md` — the 300-line rule and the thin-index split

### Related reading

- `how-to/docs/CONTEXT.md` and `how-to/src/CONTEXT.md` — the two homes and what already lives in each
- `code/docs/DOCUMENTATION-PAIRING.md` — the pair a new folder needs
- `.claude/skills/research/SKILL.md` — grounding a contested claim in a primary source
- `how-to/workflows/03-quality-gates/` — the docs audits and Markdown lint the guide passes
- `REFERENCES.md` — the root index, which also lists every guide
