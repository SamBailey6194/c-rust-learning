---
type: guide
---

# Instructional file length — the 300-line limit

**Last Updated**: 27/09/2026 | **Version**: 0.1.0 | **Maintained By**: Sam Bailey
**Language**: British English (en_GB) | **Timezone**: Europe/London

This guide owns the length rule for files that instruct — guides, workflow steps, skills, and every
`CONTEXT.md` / `CLAUDE.md` pair. `.claude/CLAUDE.md` states it in one line and routes here;
`code/src/scripts/audits/docs-length.sh` enforces it, locally and in the `Audit — Docs` CI workflow. Its
sibling, `code/docs/DOCUMENTATION-PAIRING.md`, owns what goes in a pair; this one owns how big anything
may grow.

---

## 1. The limit

An instructional Markdown file may not exceed **300 code lines**, as counted by
`cloc --include-lang=Markdown`. Blank lines and HTML comments do not count, so the budget is spent on
content rather than on formatting: a table that breathes is not penalised. Everything else counts —
headings, list items, table rows, and every line inside a code fence.

The raw measurement, for one file:

```bash
cloc --include-lang=Markdown --quiet --csv code/docs/BUILD.md
```

```text
files,language,blank,comment,code,"github.com/AlDanial/cloc v 1.98  T=0.01 s (...)"
1,Markdown,52,0,186
1,SUM,52,0,186
```

The columns are `files,language,blank,comment,code`; the `code` column of the `Markdown` row — 186 for
`BUILD.md` when this was written — is the number the limit applies to.

**Why 300.** Past about three hundred lines an instructional file stops being read and starts being
skimmed, which for a rule is the same as not being there. The remedy is always the same shape (Section
3): split the detail into a sub-folder and leave the entry point a thin index.

## 2. What is bound

Instructional means it tells a reader, human or agent, how to work.

| Bound | Exempt |
| --- | --- |
| Every `CONTEXT.md`, `CLAUDE.md` and `AGENTS.md`, wherever it sits | Other root-level `*.md` — `README.md`, `REFERENCES.md`, `GAPS.md`, `DEFERRED.md` and the rest |
| `**/docs/**/*.md` | `how-to/src/*.md` — operator guides, written in full for a person at a terminal |
| `**/workflows/**/*.md` | `project-management/src/**` — artefacts and templates, which are records rather than instructions |
| `.claude/**/*.md` | Content inside `learning/`, `research/` and `handoffs/` — session material |

**A `CONTEXT.md`, `CLAUDE.md` or `AGENTS.md` inside an exempt tree is still bound.** These files are
instructional wherever they live, so `learning/CONTEXT.md` and the root `CONTEXT.md` are measured even
though their neighbours are not.

A Markdown file matching no row on the left is simply not measured — the layer index files such as
`code/REFERENCES.md`, for example, and the templates under `.github/`.

**Source files** — `.c`, `.h`, `.rs`, `.sh`, makefiles — have their own limit of **750 lines**, counted
plainly with `wc -l`. Past that a source file is doing more than one job. No script measures it yet;
`code/workflows/05-review/` checks it.

## 3. The split — a thin index and a `kebab-case/` folder

When a guide in `code/docs/` would pass 300 lines:

1. **Create a sub-folder beside it**, named in `kebab-case/` after the guide — `BUILD.md` → `build/`. A
   shorter name is fine where it reads better.
2. **Move the detail into sub-documents** named in `SCREAMING-SNAKE-CASE.md` and titled
   `# <Parent> — <Part>` (`# Build — GCC Flags`). Each keeps the guide frontmatter and metadata line, and
   ends with a footer linking back:
   ``_Part of the `code/docs/` documentation family. See [`../BUILD.md`](../BUILD.md) for the full index._``
3. **Give the folder its own `CONTEXT.md` and `CLAUDE.md`** (`code/docs/DOCUMENTATION-PAIRING.md`). The
   `CONTEXT.md` opens by naming the parent guide and saying why the folder was split out, then gives a
   "which document, when" table.
4. **Cut the entry point down to an index**: frontmatter, the metadata line, one intro paragraph, a
   `## Sub-documents` table (`| Document | Covers |`), and the family footer
   ``_Part of the `code/docs/` documentation family._`` An index may keep a little substance that
   genuinely orients — a gate question, the three rules in one place — as long as it stays well inside
   the limit.
5. **Update every index in the same change**: the tree in `code/docs/CONTEXT.md` (a second row under the
   guide, `│   └── build/  ← what it holds`), `code/REFERENCES.md`, the root `REFERENCES.md`, and every citation
   that pointed at a section that moved.

Other instructional files split differently, because their shape is fixed:

- **A workflow's `STEPS.md` or `CHECKLIST.md`** cannot grow a sub-folder — a workflow holds exactly four
  files. Past the limit, the workflow is doing two jobs: split it into two workflows, the new one taking
  the next free number.
- **A `CONTEXT.md` or `CLAUDE.md`** past the limit is carrying content that has another owner. Move the
  content to its owner — usually a guide — and cite it.
- **A skill** follows the layout in `.claude/skills/CLAUDE.md`.

## 4. Nothing is exempt for growing by design

A register, an index, a roster: the argument is always that this particular file is the sort that
naturally accumulates. It is not a defence. A catalogue that outgrows the limit becomes an index over
sub-catalogues, like anything else.

## 5. Shrinking by relocation is not shrinking

A `CONTEXT.md` has a `CLAUDE.md` beside it, and the cheapest way to get a file under the limit is to push
text across the gap. The count falls, the gate passes, and the pair holds exactly as much as before.

Moving a line is legitimate when `code/docs/DOCUMENTATION-PAIRING.md` says it belongs on the other side:
an operating rule found in a `CONTEXT.md` **should** move to `CLAUDE.md`. Moving a line to buy space is
not, and the tell is rationale arriving in the operating half — the pairing guide names rationale as
orientation of the highest value. When a file is reduced, say in the commit how much was deleted and how
much was moved, so the difference is visible.

---

## 6. How it is enforced

The gate is `code/src/scripts/audits/docs-length.sh`. It lists Markdown files through git (so ignored
build output is never measured), keeps the bound ones from Section 2, and measures each with `cloc`:

```bash
bash code/src/scripts/audits/docs-length.sh                   # every bound file
bash code/src/scripts/audits/docs-length.sh --path code/docs  # one subtree
bash code/src/scripts/audits/docs-length.sh --verbose         # also list every count
```

| Exit | Meaning |
| --- | --- |
| 0 | Every bound file is within 300 code lines |
| 1 | One or more files are over the limit; each is named with its count |
| 2 | The script could not run — bad arguments, or `cloc` is not installed |

A missing `cloc` is exit 2, **COULD NOT RUN**, and never a pass: a check that did not look cannot report
that it found nothing. From 270 code lines (90% of the limit) the script prints a warning and the run
still passes — that is the moment to plan the split, before a routine edit is refused at 301.

CI runs the same script in `Audit — Docs` (`.github/workflows/audit-docs.yml`). Markdown style is a
separate gate, `Markdown — Lint`.

---

## Governing procedures

- `how-to/workflows/06-write-a-guide/` — writing a guide, including the split when it outgrows the limit
- `how-to/workflows/03-quality-gates/` — running this audit alongside every other gate

## Cross-references

- `code/docs/DOCUMENTATION-PAIRING.md` — the shape of the pair this rule sizes
- `.claude/CLAUDE.md` — the one-line statement that routes here
- `code/src/scripts/audits/docs-length.sh` — the gate
- `how-to/docs/GUIDE-CRAFT.md` — writing style for guides and operator documents

_Part of the `code/docs/` documentation family._
