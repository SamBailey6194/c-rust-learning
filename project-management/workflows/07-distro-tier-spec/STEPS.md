---
workflow: 07-distro-tier-spec
phase: specify
skills: [research]
---

# Distro Tier Spec — Steps

**Last Updated**: 27/09/2026 | **Version**: 0.1.0 | **Maintained By**: Sam Bailey
**Language**: British English (en_GB) | **Timezone**: Europe/London

---

## Key references

Consult `project-management/REFERENCES.md` → **External — Verification & Safety** (kernel and QEMU
documentation) and the root `REFERENCES.md` (external sources by track) as you work through these steps:

| Step | Section |
| --- | --- |
| 1 | `project-management/src/01-ROADMAP/ROADMAP.md` — the P5 and P6 rows: scope and exit gates |
| 1, 4, 6 | `project-management/src/07-DISTRO-TIERS/TIER-MATRIX.md` — the axes and the current comparison |
| 2 | `.claude/skills/research/SKILL.md` — one question per note, a citation per claim |
| 3 | `project-management/src/07-DISTRO-TIERS/TIER-000-TEMPLATE.md` — the tier scaffold |
| 3, 7 | `project-management/src/07-DISTRO-TIERS/CLAUDE.md` — naming and status for tier files |
| 6 | `project-management/src/08-DECISIONS/` — the ADRs a tier spec has to respect |
| 8 | `project-management/docs/git/COMMITS.md` — commit scopes and staging by explicit path |

---

## Steps

### Step 1 — Explain the tier first, then gather the inputs

Explain-first (`project-management/workflows/CONTEXT.md` → _Explain-first_): before opening any file, ask
the learner to describe, in their own words, who the tier is for, what that person already knows, and
what would make them give up. Write the answer down; it becomes the tier's
target-user paragraph. Then read:

- the P5 and P6 rows of `ROADMAP.md`, which say what the tiers have to achieve and by when
- `TIER-MATRIX.md` and the tier file being worked on
- every research note and ADR the tier file already cites
- the driving milestone in `project-management/src/02-MILESTONES/`, if one exists

_Done when the target user is recorded in the learner's words and every input above has been read._

### Step 2 — Research the axis values that rest on memory

For each axis value the tier file states without a citation, write one research question and run
`/research <question>`. The note lands in `research/<SCREAMING-KEBAB-TOPIC>.md` and cites primary
sources: the kernel documentation at docs.kernel.org, Linux From Scratch, the upstream project's own
manual. Typical questions: what init does busybox provide and what does it need from `/etc/inittab`;
what does a minimal installer have to do before first boot.

Where research cannot settle a value yet, mark it in the tier file as an assumption to test, not a fact.

_Done when every axis value cites a research note or a primary source, or is marked as an assumption._

### Step 3 — Open the tier file, or copy the template

The three tier files exist from the scaffold, so this is usually an edit. If a file has been lost, copy
`TIER-000-TEMPLATE.md` to `TIER-<TIER>.md` and follow the template's own copy instruction (replace every
`{PLACEHOLDER}`, delete the `[EXAMPLE]` rows).

A fourth tier changes the mission's three-tier scope. It goes through `08-decisions` and `ROADMAP.md`
first, never straight into this folder.

_Done when the tier file's header fields (date, driving milestone, status) are current._

### Step 4 — Fill every axis against the matrix

For each row in `TIER-MATRIX.md`, write the tier's value and a one-line reason, using the axis name
exactly as the matrix spells it. Then update the tier's column in the matrix to match. Where two tiers
share a value, say that it is shared on purpose.

_Done when every matrix axis has a value and a reason in the tier file, and the matrix column matches it._

### Step 5 — Write the hypotheses

Every axis that claims a user-facing difference gets at least one hypothesis. Each hypothesis carries an
ID, the claim, the observation that tests it, the pass condition, and the phase that tests it:

```text
H1  Claim:      a first-time user reaches a working shell from first boot by following
                only the on-screen text.
    Test:       boot the tier image with qemu-system-x86_64 on a serial console
                (-nographic, console=ttyS0); read nothing but the screen.
    Passes if:  a shell prompt appears and `uname -r` prints the tier kernel's release.
    Tested at:  P6, the milestone that first boots this tier's image.
```

_Done when every user-facing axis has a hypothesis and every hypothesis names its test, pass condition and
phase._

### Step 6 — Check the tiers against each other and against the ADRs

Read all three tier files and the matrix side by side, and look for:

1. a hypothesis in one tier contradicted by another tier's axis value
2. an axis value that conflicts with an Accepted ADR in `project-management/src/08-DECISIONS/`
3. a hard-to-reverse choice with no ADR yet: init system, package manager, bootloader, distro base

Send each item under 3 to `project-management/workflows/08-decisions/` as a `Proposed` ADR, and cite it
from the tier file. Resolve items under 1 and 2 in the tier files, or by superseding the ADR there.

_Done when no contradiction remains and every hard-to-reverse choice cites an ADR, Proposed or Accepted._

### Step 7 — Cross-link and set the status

Link the tier file to its research notes, ADRs and driving milestone by full repo-relative path, and link
the milestone back to the tier file. Set the tier file's status as
`project-management/src/07-DISTRO-TIERS/CLAUDE.md` defines it. Park ideas that belong to a later phase in
`DEFERRED.md` with a `DEFERRED (MS###)` marker instead of leaving them in the spec.

_Done when every link resolves and the status matches the folder's vocabulary._

### Step 8 — Commit by explicit path

Stage each file by name; never `git add -A` or `git add .`.

```bash
git add project-management/src/07-DISTRO-TIERS/TIER-BEGINNER.md \
        project-management/src/07-DISTRO-TIERS/TIER-MATRIX.md \
        research/<SCREAMING-KEBAB-TOPIC>.md
git commit -m "docs(distro): specify beginner tier hypotheses"
```

_Done when `git status` shows nothing from this workflow left uncommitted._

---

## Update context files

If this workflow created files or folders, or settled a new convention:

1. Add every new file or folder to the directory tree in the nearest `CONTEXT.md`.
2. Add any new artefact type or external source to `project-management/REFERENCES.md`.
3. Refresh `**Last Updated**` in every `CONTEXT.md` you modified.
4. If the session ends before Completion, run `/handoff` to write
   `handoffs/HANDOFF-<SCREAMING-KEBAB-DESCRIPTOR>-DD-MM-YYYY.md`.

---

## Completion

Run through `CHECKLIST.md` before marking this workflow complete.
