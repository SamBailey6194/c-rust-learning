---
workflow: 06-write-a-guide
phase: author
skills: [research]
---

# Write a Guide — Checklist

**Last Updated**: 27/09/2026 | **Version**: 0.1.0 | **Maintained By**: Sam Bailey
**Language**: British English (en_GB) | **Timezone**: Europe/London

---

> **See** `how-to/REFERENCES.md` → **Internal → Reference guides** (`how-to/docs/GUIDE-CRAFT.md`) ·
> **Internal → Context files** (`how-to/docs/CONTEXT.md`, `how-to/src/CONTEXT.md`) · the **External**
> tables for primary sources.

## Execution Checklist

### Step 1 — Place it

- [ ] Reader, home (`how-to/docs/` or `how-to/src/`), kind (reference or runbook) and scope decided
- [ ] Extending an existing guide was considered before creating a new file
- [ ] Every rule the guide touches is cited from its owner, not restated

### Step 2 — Draft against the shape

- [ ] Reference: `type: guide` frontmatter, metadata block, `---` between sections, symptom-named
      Troubleshooting headings
- [ ] Runbook: Purpose → Prerequisites → Steps → Failure modes → Rollback → Verification
- [ ] Raw command first, then the script that wraps it; destructive commands flagged on the line above

### Step 3 — Verify every command and claim

- [ ] Every command checked against `--help`, a man page or a primary source
- [ ] Sources linked, not pasted

### Step 4 — Execute it from its stated prerequisites

- [ ] Run start to finish from the stated starting state
- [ ] Every quoted output is what the command actually printed
- [ ] Anything recovered by instinct is now in Failure modes or Troubleshooting
- [ ] Anything not runnable yet (P4 material) is labelled "P4 preview"

### Step 5 — Check length and Markdown

- [ ] `how-to/docs/` guide ≤ 300 cloc code lines, or split into a thin index plus a `kebab-case/` sub-folder
- [ ] markdownlint-cli2 clean

### Step 6 — Wire it into the indexes

- [ ] Listed in its folder `CONTEXT.md`, `how-to/REFERENCES.md` and the root `REFERENCES.md`
- [ ] Linked from every workflow that should route to it; every link resolves

### Step 7 — Commit by explicit path

- [ ] Guide and index entries committed together, by explicit path, with scope `how-to`

---

## Context

- [ ] Directory trees in the relevant `CONTEXT.md` files show every file or folder this workflow created
- [ ] `how-to/REFERENCES.md` lists any new guide, workflow or external source
- [ ] `**Last Updated**` is refreshed in every `CONTEXT.md` modified
- [ ] If the session ended mid-work, a handoff exists in `handoffs/`

---

## Definition of Done

- [ ] The guide was executed end to end from its own prerequisites and corrected from what happened
- [ ] A reader with those prerequisites and no other context can follow it without guessing
- [ ] Discoverable from its folder index, both `REFERENCES.md` files and the workflows that need it
- [ ] No absolute home path, email address or secret anywhere in it
