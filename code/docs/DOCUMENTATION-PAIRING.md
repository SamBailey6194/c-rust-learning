---
type: guide
---

# CONTEXT.md and CLAUDE.md — the pairing standard

**Last Updated**: 27/09/2026 | **Version**: 0.1.0 | **Maintained By**: Sam Bailey
**Language**: British English (en_GB) | **Timezone**: Europe/London

Every directory in this repository that a person or an agent works in carries two files. This guide
owns the line between them. `.claude/CLAUDE.md` states the rule in one line and routes here for the
decision procedure; `code/src/scripts/audits/docs-pairing.sh` enforces the mechanical half, locally and
in the `Audit — Docs` CI workflow. Its sibling, `code/docs/DOCUMENTATION-LENGTH.md`, owns how long
either file may grow; this one owns what goes in each.

---

## 1. The split, in one sentence

**`CONTEXT.md` says what is here and why it is here. `CLAUDE.md` says how to work here.**

Orientation is a description of a place. Operating rules are instructions to whoever arrives. A reader
who wants to know whether they are in the right directory reads `CONTEXT.md`; a reader who has decided
to work there reads `CLAUDE.md`.

## 2. The decision test

Ask of any sentence: **would it still be true if nobody ever worked in this directory again?**

- **Yes** — it describes the place, so it belongs in `CONTEXT.md`. _"`mk/` holds the flag and rule
  files every exercise Makefile includes."_
- **No** — it constrains an actor, so it belongs in `CLAUDE.md`. _"Fix a warning in the source, never by
  deleting a flag from `mk/flags.mk`."_

Two reliable tells that a sentence has landed in the wrong file:

- **Modal verbs** — _must_, _never_, _always_, _do not_. A description does not need them. Rewrite the
  sentence as a fact, or move it.
- **A second person, stated or implied** — _read X first_, _run Y before Z_. Reading order is an
  instruction, however useful it is on arrival.

The test is about the sentence, not the subject. "Exercise numbers are frozen and never reused" is a
rule; "exercise numbers are identifiers, not a running order" is the same knowledge as orientation, and
is what `CONTEXT.md` carries.

---

## 3. What `CONTEXT.md` holds

In this order. The opening paragraph and the tree are never optional.

1. **An H1** — `# <path>/ — <Title Case descriptor>` for a layer or folder (`# code/docs/ — Coding
   Reference Guides`), or `# Workflow: <Name>` for a workflow folder.
2. **The metadata line** — the full form below in layer-root and workflow files; folders below layer
   level may use the short form `**Last Updated**: 27/09/2026`.
3. **An opening paragraph saying what the directory is and why it exists.** The _why_ is the part that
   matters: a directory whose reason for existing is unrecorded gets merged away or duplicated by the
   next person who cannot see the point of it.
4. **`## Directory Tree`** — a fenced `text` block whose first line is the directory path with a
   trailing `/`. Every row carries a `←` note saying what that entry is. A pair sits on one row as
   `├── CONTEXT.md · CLAUDE.md`, and workflow families are marked by separator rows such as
   `│   ── Build (01–04) ──`.
5. **A what-is-here table**, where the tree notes are too short to carry the meaning — `## Files`,
   `## Sub-layers` or a similarly descriptive heading.
6. **Layer roots only:** `## When to read this`, `## Do not use for` (routing arrows, such as
   ``- Writing code → `code/CONTEXT.md` ``) and `## Key docs` (a `| Guide | When to read |` table).
7. **`## Cross-references`** — always the last section: the parent, sibling and owner documents a reader
   continues to.

The full metadata line, exactly:

```markdown
**Last Updated**: 27/09/2026 | **Version**: 0.1.0 | **Maintained By**: Sam Bailey
**Language**: British English (en_GB) | **Timezone**: Europe/London
```

A workflow folder's `CONTEXT.md` follows the same order with its own fixed sections — `## When to use
this`, `## Key concepts`, and `## Cross-references` split into `### Governing documents` and `### Related
reading`. The four-file workflow contract itself is described in `code/workflows/CONTEXT.md`.

Sections that explain **why the structure is the way it is** are welcome — `## Why two build trees and
not one`. Rationale is orientation of the highest value.

## 4. What `CLAUDE.md` holds

A fixed shape, scaled to the folder: a leaf stays short, a layer root is fuller.

```text
@./CONTEXT.md
@./REFERENCES.md                 (line 2, only where a REFERENCES.md sits in the same folder)

# CLAUDE.md — <path>/

Read order: `.claude/CLAUDE.md` → `.claude/MEMORY.md` → this folder's `CONTEXT.md`
(<what it gives>, imported above) → this file → <what comes next>

## Purpose (one line)
## How to work here             (bold-led bullets: **Routing:**, **Concrete steps:** a → b → c,
                                 **Definition of done:**)
## Guardrails                   (each bullet opens with a bold imperative sentence)
## Output & naming
```

**Exactly four H2s, in that order.** The `@./CONTEXT.md` import is what keeps the orientation loaded
whenever the operating rules are, so a `CLAUDE.md` is never a bare import stub and never carries a
directory tree of its own: the tree is imported from the file that owns it, and a second copy drifts.

**Tutor mode.** Every `CLAUDE.md` under `code/` and `learning/`, and the one in
`project-management/workflows/10-study-and-build/`, states in **How to work here** that tutor mode
applies: Claude asks how the learner plans to approach a problem before helping, explains and asks
guiding questions, writes no exercise solution unless explicitly asked, and in review points at the
relevant `code/docs/` section rather than rewriting the code. The posture itself is owned by
`.claude/CLAUDE.md`; a pair only says that it applies here and what it means for this folder.

---

## 5. The sections that do not belong in a `CONTEXT.md`

Each of these is an instruction wearing an orientation heading. The right-hand column is where the
content goes instead.

| Heading in a `CONTEXT.md` | Move it to |
| --- | --- |
| `## Rules`, `## Guardrails`, `## Constraints` | `CLAUDE.md` → **Guardrails** |
| `## Requirements`, `## Prerequisites`, `## Quality gates` | `CLAUDE.md` → **How to work here**, as the entry condition |
| `## Standards`, `## Global constraints` | the owning `code/docs/` guide (Section 6), or `CLAUDE.md` → **Guardrails** |
| `## Conventions`, `## Naming conventions`, `## File naming` | `CLAUDE.md` → **Output & naming** |
| `## How to work here`, `## Definition of done` | `CLAUDE.md` → the section of that name |

The same applies to **modal verbs in body prose** (_must_, _never_, _always_, _do not_): a sentence
that needs one is a rule, and rules live in `CLAUDE.md`.

Four headings look like rules and are not, so they stay:

- **`## When to use this` / `## When to read this`** — what the directory is for, written as a trigger.
  Keep it descriptive: _"use this workflow when an exercise leaks"_, not _"you must run this before
  every PR"_.
- **`## Do not use for`** — the boundary of the directory. It describes what is **not** here and routes
  elsewhere, which is orientation, not a prohibition on conduct.
- **`## Dependencies`** — what the things here need in order to work. "`memcheck` needs valgrind" is
  still true if nobody ever runs it.
- **`## Key concepts`** — domain facts, with one trap: **a fact that already has an owner is a
  restatement whatever its grammar.** Naming the flag set in a workflow's key concepts is Section 6's
  _Bad_ case under a different heading.

## 6. Route, do not restate

Each rule has **one owner file**. Every other file cites the owner by its repo-relative path in
backticks and does not repeat the substance.

- **Good** — _"builds clean under the flags in `code/docs/BUILD.md`"_.
- **Bad** — _"builds clean with `-Wall -Wextra -Wpedantic -Werror`"_ in a file that does not own the
  flag set. The day `code/src/c/mk/flags.mk` gains a flag, the bad version is incomplete as well as
  duplicated, and nothing about it reads as stale — which is exactly why a reader would believe it. The
  good version needs no edit, because a citation does not go out of date when the thing it cites
  changes.

| Rule | Owner |
| --- | --- |
| Roadmap phases and their exit gates | `project-management/src/01-ROADMAP/ROADMAP.md` |
| Status vocabulary | `project-management/docs/planning/MILESTONES.md` |
| Build flags and make targets | `code/docs/BUILD.md` |
| C style | `code/docs/C-CODING-PRINCIPLES.md` |
| Rust lint policy and `unsafe` rules | `code/docs/RUST-CODING-PRINCIPLES.md` |
| FFI crate layout, export prefix and free functions | `code/docs/FFI.md` Section 7 |
| Exercise and crate numbering (`NNN`, C ↔ Rust ports) | `code/src/CLAUDE.md` → Output & naming |
| The `CONTEXT.md` / `CLAUDE.md` split | this guide |
| Instructional file length | `code/docs/DOCUMENTATION-LENGTH.md` |
| Branches and commits | `project-management/docs/git/` |
| The quality gates and their order | `how-to/workflows/03-quality-gates/` |
| Toolchain versions | `how-to/docs/TOOLCHAIN.md` |
| Non-negotiables, tutor mode, the kernel safety rule | `.claude/CLAUDE.md` |
| Characters allowed beyond ASCII in Markdown | `.claude/CLAUDE.md` Section 4 |

Restate a rule only in the file where it is actually decided. That is the test for whether a
`CLAUDE.md` bullet is carrying its own weight.

---

## 7. Which directories are bound

**A directory carries the pair when a person or an agent works in it.** That is the whole test, and it
follows from what the pair is for: orientation for someone about to make a decision there.

Seven classes fall outside it. The exact globs live in
`code/src/scripts/audits/docs-pairing.exempt` (one bash `[[ == ]]` glob per line, `#` for comments);
this section owns the classes and the reason for each, and the two change together.

- **The repository root.** The root holds `CONTEXT.md` only; the operating manual that a root
  `CLAUDE.md` would hold is `.claude/CLAUDE.md`.
- **Git internals** — `.git/`. Owned by git; nobody authors it.
- **GitHub configuration** — `.github/` and everything below it. Templates and CI workflows are read by
  GitHub, and each workflow file opens with a comment block explaining why its gate exists.
- **Skill folders** — `.claude/skills/*/`. A skill's `SKILL.md` and its `description` frontmatter are
  its orientation; the folder above carries the pair and the roster. A third file would restate the
  skill.
- **Build output** — `**/build/**`, `**/target/**`. Remade by every build rather than authored, and
  never committed.
- **Support folders covered by their parent's pair** — `code/src/c/mk/`, `code/src/c/include/`, the
  sub-folders of `code/src/scripts/`, the internals of a C exercise (`code/src/c/ms*/*`), the
  internals of a crate (`code/src/rust/crates/*/*`), and `code/src/rust/crates/` itself. Each is
  explained row by row in its parent's tree; a second pair would describe the same files twice.
- **Sandbox content** — everything below `learning/`, `research/` and `handoffs/`. The layer roots
  themselves keep their pair; the topic folders and notes beneath them follow formats owned by the
  skills that write them (`.claude/skills/`).

Everything else a person or an agent edits is bound, in every layer. Three failures follow from that:
a `CONTEXT.md` with no `CLAUDE.md`, a `CLAUDE.md` with no `CONTEXT.md`, and a bound directory holding
**neither**. The third is invisible to a check that starts from files, which is why the audit
enumerates directories instead.

A new class of exemption is a change to this section and to `docs-pairing.exempt` in the same commit —
never a line added to the glob file alone.

## 8. How it is enforced

The raw check is the script itself; it prints one line per problem and exits 0 (pass), 1 (problems
found) or 2 (it could not run):

```bash
bash code/src/scripts/audits/docs-pairing.sh                 # the whole repository
bash code/src/scripts/audits/docs-pairing.sh --path code/docs  # one subtree
```

| Check | Enforced by |
| --- | --- |
| Every bound directory holds both files; the exempt globs are honoured | `docs-pairing.sh` |
| `CLAUDE.md` line 1 is `@./CONTEXT.md`; line 2 is `@./REFERENCES.md` exactly when one sits beside it | `docs-pairing.sh` |
| `CLAUDE.md` has an H1 `# CLAUDE.md — <path>/`, a `Read order:` line, and exactly the four H2s in order | `docs-pairing.sh` |
| No directory tree inside a `CLAUDE.md` | `docs-pairing.sh` |
| `CONTEXT.md` has a `## Directory Tree` section | `docs-pairing.sh` |
| No `Rules`, `Guardrails`, `Constraints`, `Requirements`, `Prerequisites`, `Standards`, `Conventions` or `Definition of done` heading in a `CONTEXT.md` | `docs-pairing.sh` |
| The remaining Section 5 headings, and modal verbs in `CONTEXT.md` prose | review |
| The opening _why_ paragraph is present and says something | review |
| Tree rows match what is on disk | review, in each workflow's `## Update context files` step |

`.claude/CLAUDE.md` is the one `CLAUDE.md` the shape checks skip: it is the manual, and it owns its own
shape. CI runs the same script in the `Audit — Docs` workflow (`.github/workflows/audit-docs.yml`).

The review rows are deliberately not mechanical. A script can prove a paragraph exists; only a reader can
tell whether it explains anything. Treat a `CONTEXT.md` whose opening restates the directory name as
unwritten.

---

## Governing procedures

- `how-to/workflows/06-write-a-guide/` — writing or restructuring a guide, including its pair
- `how-to/workflows/03-quality-gates/` — running the audit with every other gate

## Cross-references

- `.claude/CLAUDE.md` — the one-line statement of this rule, and the owner of tutor mode
- `code/docs/DOCUMENTATION-LENGTH.md` — how long either file may be
- `code/src/scripts/audits/docs-pairing.sh` — the mechanical gate
- `code/src/scripts/audits/docs-pairing.exempt` — the exemption globs for Section 7's classes
- `how-to/docs/GUIDE-CRAFT.md` — writing style for guides and operator documents

_Part of the `code/docs/` documentation family._
