@./CONTEXT.md

# CLAUDE.md — code/docs/

Read order: `.claude/CLAUDE.md` → `.claude/MEMORY.md` → this folder's `CONTEXT.md` (the guide catalogue
and the rule each guide owns, imported above) → this file → the guide being read or changed.

## Purpose (one line)

The coding reference guides — where each rule for `code/src/` is decided once, for every other file to
cite.

## How to work here

- **Routing:** learning from a guide → teach from it in tutor mode (below); changing a rule that came from
  an ADR → a new ADR in `project-management/src/08-DECISIONS/` first (`project-management/workflows/08-decisions/`),
  then the guide; writing a new guide → `how-to/workflows/06-write-a-guide/`, with the style in
  `how-to/docs/GUIDE-CRAFT.md`.
- **Tutor mode:** when Sam is learning from a guide, ask what he expects a flag, tool or rule to do
  before explaining it, then point at the section. Guides explain concepts with small worked examples of
  their own; they never contain the solution to an exercise in `project-management/src/04-EXERCISES/`.
- **Concrete steps:** read the guide in full → make the change → verify every technical claim against the
  installed tool (`man gcc`, `valgrind --help`, `qemu-system-x86_64 --help`) or a primary source
  (docs.kernel.org, doc.rust-lang.org, the Context7 MCP for library docs), or by running it → if the guide
  would pass 300 cloc code lines, split it (`code/docs/DOCUMENTATION-LENGTH.md` Section 3) → update the
  tree and table in this folder's `CONTEXT.md`, `code/REFERENCES.md` and the root `REFERENCES.md` →
  `bash code/src/scripts/audits/docs-length.sh --path code/docs` →
  `bash code/src/scripts/audits/docs-pairing.sh --path code/docs` → `npx --yes markdownlint-cli2 --no-globs "code/docs/**/*.md"`.
- **Definition of done:** at most 300 cloc code lines; `type: guide` frontmatter, the full metadata line,
  one H1, `---` between major sections and the family footer; every repo path cited exists in the tree
  or is labelled planned; every command shown has been run; British English; the length, pairing and
  Markdown gates pass.

## Guardrails

- **Keep one owner per rule.** A guide states a rule only if it owns it (the owners are listed in
  `code/docs/DOCUMENTATION-PAIRING.md` Section 6); everywhere else it cites the owner by path.
- **Verify before writing.** No flag, default, option or output format goes into a guide from memory;
  say which tool version it was checked against, and flag anything that could not be checked.
- **Show the raw command first, then the script.** The command teaches; the script in
  `code/src/scripts/` is what CI and Claude's verification run.
- **Change a guide and the file it describes together.** A guide that explains `mk/flags.mk`,
  `Cargo.toml`, `clippy.toml` or a script changes in the same commit as that file.
- **Summarise and link; never paste copyrighted text.** The kernel coding style, the C standard and
  man pages are cited, not copied; short attributed quotations only.
- **Write nothing private.** This repository is public: repo-relative paths in backticks, no absolute
  paths, email addresses or secrets.

## Output & naming

- **Guides:** `SCREAMING-SNAKE-CASE.md` in this folder, ending with the footer
  ``_Part of the `code/docs/` documentation family._``
- **Sub-folders**, only when a guide splits: `kebab-case/` with their own `CONTEXT.md` + `CLAUDE.md`;
  sub-documents in `SCREAMING-SNAKE-CASE.md`, titled `# <Parent> — <Part>`.
- **Code fences** always carry a language: `bash`, `c`, `rust`, `make`, `toml`, `text`.
- **Hand-written only:** nothing in this folder is generated.
