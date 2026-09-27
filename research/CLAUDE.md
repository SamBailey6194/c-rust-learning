@./CONTEXT.md

# CLAUDE.md — research/

Read order: `.claude/CLAUDE.md` → `.claude/MEMORY.md` → this folder's `CONTEXT.md` (purpose and
suggested first questions, imported above) → this file → the `research` skill
(`.claude/skills/research/SKILL.md`).

## Purpose (one line)

The committed home for `/research` notes: one question each, answered from primary sources, feeding
an ADR, a kernel or OS profile spec, or a lesson.

## How to work here

- **Routing:** all writes here run through the `research` skill
  (`.claude/skills/research/SKILL.md`), which owns the steps, the licence ladder and the note format.
- **Concrete steps:** `/research` frames one question → reads the primary sources → checks each
  licence before quoting → writes `<SCREAMING-KEBAB-TOPIC>.md` (Question, bold-first Verdict,
  numbered claim sections, What is not settled, Sources, Note on quoting) → the consuming ADR, spec
  or `RESOURCES.md` links back to the note by path.
- **Definition of done:** every claim cites a primary source that was opened; every source is
  pinned by URL plus version, tag, commit or retrieval date; the note is wired to its consumer and
  its **Feeds** field names it.

## Guardrails

- **Cite the primary source for every claim.** Blogs and threads are scouts that lead to the
  primary; the citation kept is always the primary.
- **Never quote a source that grants no licence.** Check the licence before writing a verbatim
  line: a source with no licence grants nothing, so quoting it here **publishes** text there is no
  permission to publish. Take the fact, re-author the wording, cite the URL and section. A
  share-alike source (CC BY-SA, the GFDL) is read as a checklist of concerns and never quoted
  either. Permissive sources (MIT, BSD, ISC) and GPL-2.0-compatible kernel files may be quoted
  with attribution beside the quotation and in the note's `## Sources`.

  > **Why it bites in this folder specifically.** Notes here are committed, and this repository
  > is public, so a quotation in a note is a quotation published to the world, under a
  > GPL-2.0-only repo. Reading a source and republishing it are different acts needing different
  > permissions, and the licence check is what separates them. The ladder in
  > `.claude/skills/research/SKILL.md` records the position for the sources this repo reads most.

- **Never commit a source file.** No PDF of a standard, no book chapter, no copied manual page:
  pin the URL and version in the note instead.
- **A durable fact not tied to a decision** belongs in `.claude/MEMORY.md`, not a note here.
- **British English (en_GB)**; external primaries the repo keeps citing are indexed in
  `REFERENCES.md`.

## Output & naming

- **Hand-written** via `/research`; nothing here is generated.
- Files `<SCREAMING-KEBAB-TOPIC>.md`, named for the question, for example
  `KERNEL-CONFIG-BASELINE-TINYCONFIG-VS-DEFCONFIG.md` (planned).
- Notes are exempt from the length check; this `CONTEXT.md` and `CLAUDE.md` pair is checked.
