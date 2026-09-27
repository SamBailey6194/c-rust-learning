---
workflow: 06-write-a-guide
phase: author
skills: [research]
---

# Write a Guide — Steps

**Last Updated**: 27/09/2026 | **Version**: 0.1.0 | **Maintained By**: Sam Bailey
**Language**: British English (en_GB) | **Timezone**: Europe/London

---

## Key references

Consult `how-to/REFERENCES.md` as you work through these steps:

| Step | Section |
| --- | --- |
| 1 | **Internal → Context files** → `how-to/docs/CONTEXT.md`, `how-to/src/CONTEXT.md` |
| 2 | **Internal → Reference guides** → `how-to/docs/GUIDE-CRAFT.md` |
| 3 | **External** tables → the primary source for each tool · **Internal → Cross-layer** → `research/CONTEXT.md` |
| 5 | **Internal → Cross-layer** → `code/docs/DOCUMENTATION-LENGTH.md` |
| 6 | **Internal → Cross-layer** → `REFERENCES.md` (root index) |
| 7 | **Internal → Cross-layer** → `project-management/docs/git/BRANCHES.md`, `project-management/docs/git/COMMITS.md` |

---

## Steps

### Step 1 — Place it

Settle five questions before drafting a word:

1. **Who is the reader, and what has just happened to them?** Usually the learner, mid-session, with
   something that does not work.
2. **Does it belong in an existing guide?** Three paragraphs added to `how-to/docs/CLI-TOOLING.md` beat a
   new file that repeats half of it.
3. **Reference or runbook?** Looked up in fragments → reference in `how-to/docs/`. Followed start to
   finish → runbook in `how-to/src/`.
4. **What is out of scope, and who owns it?** Use the table in this folder's `CONTEXT.md`.
5. **Which file owns each rule it touches?** Cite the owner (`how-to/docs/TOOLCHAIN.md` for versions,
   `how-to/workflows/03-quality-gates/` for gates) instead of restating it.

_Done when the home, the kind and the scope are written down in one line each._

### Step 2 — Draft against the shape

- **Reference (`how-to/docs/`):** `type: guide` frontmatter, the two-line metadata block, one `#`,
  sections separated by `---`, commands grouped by intent in `bash` fences with a `#` comment above each,
  and a Troubleshooting section of symptom-named `###` headings.
- **Runbook (`how-to/src/`):** the spine from `how-to/docs/GUIDE-CRAFT.md` — Purpose → Prerequisites →
  Steps (each with the command and what success looks like) → Failure modes → Rollback → Verification.

In both, show the raw command first and then the script that wraps it, write in British English, second
person and imperative, and flag any destructive command on the line above it.

_Done when every section of the chosen shape exists, even if some are still thin._

### Step 3 — Verify every command and claim

Check each command against the tool itself before trusting memory:

```bash
gcc --help=warnings | grep -- '-Wshadow'
man valgrind
cargo clippy --help
```

For behaviour that a man page does not settle, go to the primary source listed in `how-to/REFERENCES.md`,
or run `/research <question>` to write a cited note in `research/`. Link sources; do not paste their text.

_Done when every command has been checked against its tool or a primary source._

### Step 4 — Execute it from its stated prerequisites

Run the guide start to finish from the state it claims to start from. When it claims a fresh clone, make
one:

```bash
TMP_CLONE="$(mktemp -d)/c-rust-learning"
git clone --quiet . "$TMP_CLONE"
cd "$TMP_CLONE"
```

Correct the guide from what happened, not from what you expected:

- A step worked only because your shell was already set up → a missing prerequisite.
- The output differs from what you wrote → paste the real output.
- You had to stop and think → the step is under-specified.
- You recovered by instinct → that recovery belongs in Failure modes or Troubleshooting.

Kernel and QEMU material before P4 cannot be run end to end yet; label it "P4 preview" instead.

_Done when the guide has been run end to end and corrected, or its unrunnable parts are labelled._

### Step 5 — Check length and Markdown

```bash
cloc --include-lang=Markdown --quiet --csv how-to/docs/NEW-GUIDE.md
bash code/src/scripts/audits/docs-length.sh
npx --yes markdownlint-cli2 --no-globs how-to/docs/NEW-GUIDE.md
```

Replace `NEW-GUIDE.md` with the file you wrote. `--no-globs` makes markdownlint-cli2 lint only the file
named: without it, the `globs` in `.markdownlint-cli2.jsonc` are added and the whole repository is linted. The `code` column must be 300 or fewer for anything in
`how-to/docs/`. Over the cap, split it: keep `NEW-GUIDE.md` as a thin index (frontmatter, metadata, intro,
a `## Sub-documents` table, the family footer) and move the detail into `how-to/docs/<guide-name>/` with its
own `CONTEXT.md` and `CLAUDE.md`. `how-to/src/` runbooks are exempt from the cap; their folder's pair is
not.

_Done when the length audit and markdownlint both pass._

### Step 6 — Wire it into the indexes

- Add the file to the directory tree and table in its folder's `CONTEXT.md`.
- Add a row to the right table in `how-to/REFERENCES.md`, and to the root `REFERENCES.md`.
- If readers will look for it first, add it to **Key docs** in `how-to/CONTEXT.md`.
- Link it from the workflows that should route to it, and check that each link resolves.
- A new folder? Run `bash code/src/scripts/audits/docs-pairing.sh`.
- Refresh `**Last Updated**` on every `CONTEXT.md` touched.

_Done when the guide is reachable from its folder index, both `REFERENCES.md` files and every workflow that
needs it._

### Step 7 — Commit by explicit path

```bash
git switch -c docs/cli-tooling-gdb-section
git add how-to/docs/CLI-TOOLING.md how-to/REFERENCES.md how-to/docs/CONTEXT.md
git commit -m "docs(how-to): add gdb watchpoint commands to CLI-TOOLING"
```

Name the branch and message for your change; small documentation fixes may go straight to `main` per
`project-management/docs/git/BRANCHES.md`.

_Done when the guide and its index entries are committed together._

---

## Update context files

If this workflow created files or folders, or settled a new convention:

1. Add every new file or folder to the directory tree in the nearest `CONTEXT.md`; a new directory also
   gets its own `CONTEXT.md` and `CLAUDE.md`.
2. Add any new guide, workflow or external source to `how-to/REFERENCES.md`.
3. Refresh `**Last Updated**` in every `CONTEXT.md` you modified.
4. If the session ends before Completion, run `/handoff` to write
   `handoffs/HANDOFF-<SCREAMING-KEBAB-DESCRIPTOR>-DD-MM-YYYY.md`.

---

## Completion

Run through `CHECKLIST.md` before marking this workflow complete.
