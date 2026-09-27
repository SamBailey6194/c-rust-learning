@./CONTEXT.md

# CLAUDE.md — .claude/skills/

Read order: `.claude/CLAUDE.md` → `.claude/MEMORY.md` → this folder's `CONTEXT.md` (roster and
when-to-load table, imported above) → this file → the `SKILL.md` being written or edited.

## Purpose (one line)

The authoring rules for this repo's skills: how a `SKILL.md` is shaped, sized, routed and checked.

## How to work here

- **Routing:** edit a skill when the session mechanic it captures changes, with the weight of a
  docs change. A new procedure with numbered steps and a checklist is a workflow under a layer's
  `workflows/`, not a skill. The four names (`teach`, `handoff`, `research`, `wait-what`) are cited
  across the repository, and the first three in workflows' `skills:` frontmatter (`wait-what` is
  user-invoked only, so no workflow lists it); keep them stable, as a rename is a repo-wide change.
- **Concrete steps:** edit `<name>/SKILL.md` → keep the `description` an accurate trigger → keep
  every numbered step ending in a `_Done when ..._` line → check that every path in
  `## Governing procedures` and `## Cross-references` exists → update the tree and the table in
  `CONTEXT.md` if a skill is added, renamed or removed → run the checks below.
- **Definition of done:** `bash code/src/scripts/audits/docs-length.sh` and
  `bash code/src/scripts/audits/docs-pairing.sh` exit 0;
  `npx --yes markdownlint-cli2 --no-globs ".claude/skills/**/*.md"` reports no errors (CI runs the
  same check over every file as `Markdown — Lint`); every backticked path exists or is labelled planned; British English.

## Guardrails

- **Frontmatter is `name` and `description`, nothing else.** This is a repo narrowing, not the
  specification: the Agent Skills specification defines six fields (`name`, `description`,
  `license`, `compatibility`, `metadata`, `allowed-tools`) and Claude Code reads more
  (`disable-model-invocation`, `argument-hint`, `when_to_use` and others). Adding a key is a
  decision: record it as an ADR from `project-management/src/08-DECISIONS/ADR-MS000-TEMPLATE.md`
  first.
- **`name` equals the folder name.** Lower-case letters, digits and single hyphens, 1 to 64
  characters, no leading or trailing hyphen; the specification requires the match (checked
  27/09/2026 at agentskills.io/specification).
- **`description` is a `>-` folded block: the job first, then the triggers.** Open with what the
  skill does, then `Invoke by typing /<name>, or when ...`. Keep it within 1,024 characters (the
  specification's limit; Claude Code truncates its listing at 1,536). A user-invoked-only skill
  says so in words, as `wait-what` does.
- **Every numbered step ends with a verifiable `_Done when ..._` line.** Name an observable state:
  a file exists, a field is filled, a command exits 0, the turn has stopped. "Sam understands" is
  not observable; "Sam recalled it unaided" is.
- **Every skill ends with `## Governing procedures (route here — do not restate at length)` then
  `## Cross-references`.** The first names the workflow folders the skill hands work to, or says
  **No governing workflow** and why. The second lists repo-relative paths in backticks.
- **Every skill carries the locale line** `Locale: en_GB · Europe/London · dates DD/MM/YYYY.`
  beneath its opening paragraph, and an H1 of the form `# Skill: <Name> (c-rust-learning)`.
- **At most 300 cloc code lines per `SKILL.md`** (the rule and its measure are owned by
  `code/docs/DOCUMENTATION-LENGTH.md`). An oversized skill moves detail into
  `SCREAMING-SNAKE-CASE.md` sub-documents beside it and keeps `SKILL.md` as a thin index.
- **Route, don't restate.** A skill cites the owner of a rule rather than copying it: build flags
  → `code/docs/BUILD.md`; commits → `project-management/docs/git/`; non-negotiables and tutor mode
  → `.claude/CLAUDE.md`; phases → `project-management/src/01-ROADMAP/ROADMAP.md`.
- **Tutor mode holds inside every skill.** No skill instructs Claude to write an exercise solution
  unless Sam explicitly asks for one.
- **Public repo, so no private detail.** No absolute paths, session IDs, email addresses, secrets
  or pasted copyrighted text in a skill, nor in anything a skill tells Claude to write.

## Output & naming

- **Hand-written:** every `SKILL.md` and sub-document; nothing here is generated.
- Skill folders `kebab-case/`; the entry file is always `SKILL.md`; sub-documents
  `SCREAMING-SNAKE-CASE.md`.
- Skill folders are exempt from pairing because `SKILL.md` orients (the glob lives in
  `code/src/scripts/audits/docs-pairing.exempt`); this folder's own pair is checked.
