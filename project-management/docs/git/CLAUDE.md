@./CONTEXT.md

# CLAUDE.md — project-management/docs/git/

Read order: `.claude/CLAUDE.md` → `.claude/MEMORY.md` → `project-management/docs/CONTEXT.md` → this
folder's `CONTEXT.md` (which file owns what, imported above) → this file → the one sub-document that
matches the operation in hand.

## Purpose (one line)

The three git sub-documents — `BRANCHES.md`, `COMMITS.md`, `PR-AND-CHECKS.md` — behind the thin
`project-management/docs/GIT-GUIDE.md` index; the owners of every branch and commit convention in the
repository.

## How to work here

- **Routing:** reference guides, not artefacts. To make a commit or open a pull request, read the
  matching sub-document and follow it; edit it only when the convention changes. A change to the merge
  rules is checked against `project-management/workflows/13-pr-and-merge/`, and a change to the check
  table against the files in `.github/workflows/`.
- **Concrete steps:** edit the owning sub-document → check the other two do not now contradict it →
  update `project-management/docs/GIT-GUIDE.md` and this folder's `CONTEXT.md` if what a file owns
  changed → sweep the workflows that cite a changed scope, prefix or heading → confirm each file is
  still within the cap (`bash code/src/scripts/audits/docs-length.sh`).
- **Definition of done:** each convention is stated in exactly one of the three files; the tables in
  `CONTEXT.md` and `GIT-GUIDE.md` match; every check name matches its workflow file character for
  character; British English.

## Guardrails

- **Copy a CI workflow or job name, never retype it.** Workflow names carry an em dash, branch
  protection matches a job's name by exact string, and a retyped name is a required check that never
  reports.
- **Never write an email address into these files.** Trailer examples use `{PLACEHOLDER}` values; git
  and the agent supply the real ones at commit time.
- **Never pin a model name in a rule.** The co-author trailer's model is filled in when the commit is
  made; a pinned name goes stale on the next release.
- **Never rename an H2 or H3 that other files cite.** `BRANCHES.md` → _Straight to `main`_ and
  `PR-AND-CHECKS.md` → _Required checks and path filters_ are cited by name; add a heading rather than
  rewording one.
- **Describe the process; let the workflows execute it.** Cite `project-management/workflows/13-pr-and-merge/`
  rather than restating its steps, and cite `how-to/workflows/03-quality-gates/` for the gate commands.
- **Keep scopes and prefixes in step with the layers.** A new top-level layer needs a scope in
  `COMMITS.md` in the same change, or its commits will borrow a wrong one.

## Output & naming

- **Hand-written:** `BRANCHES.md`, `COMMITS.md`, `PR-AND-CHECKS.md`; nothing here is generated.
- Files `SCREAMING-SNAKE-CASE.md` with `type: guide` frontmatter and the standard metadata line; the
  folder is `kebab-case/`.
- Branches cited as `ms###/<short-kebab>`; milestones as `MS###`; dates DD/MM/YYYY in prose.
- Commit scope for edits here: `pm`.
