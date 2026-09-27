---
type: guide
---

# Git Guide — Pull Requests and CI Checks

**Last Updated**: 27/09/2026 | **Version**: 0.1.0 | **Maintained By**: Sam Bailey
**Language**: British English (en_GB) | **Timezone**: Europe/London

How a branch reaches `main`: the pull request, its template, the six CI checks it has to pass, and the
one trap in making any of them required. Index: [`project-management/docs/GIT-GUIDE.md`](../GIT-GUIDE.md).

---

## Opening the pull request

A milestone branch is opened as a pull request by `13-pr-and-merge`
(`project-management/workflows/13-pr-and-merge/`), once the milestone is verified and reviewed. A
`pm/`, `docs/` or `ci/` branch is opened when its change is complete.

```bash
git push -u origin ms007/dynamic-array
gh pr create --base main --web
```

`--web` opens GitHub's form, which pre-fills the body from `.github/PULL_REQUEST_TEMPLATE.md`;
`gh pr create --base main --template .github/PULL_REQUEST_TEMPLATE.md` does the same in your editor.
Add `--draft` to get CI's verdict before the milestone is finished.

- **Title:** a Conventional Commits summary with the milestone in it, for example
  `feat(c): MS007 dynamic array`. The format is owned by
  `project-management/docs/git/COMMITS.md`.
- **One milestone per pull request.** The loop runs one milestone at a time, so its pull request
  carries that milestone's specs, plan, notes, code and verification record together, and the review
  sees the claim and its evidence side by side.
- GitHub's own _Milestones_ feature is not used; `MS###` lives in the branch, the title and the body.

---

## The pull request template

`.github/PULL_REQUEST_TEMPLATE.md` is the body every pull request starts from, and its headings are
authoritative; this section only explains what each part is for.

- **What this changes / Why** — one or two sentences each, and the `MS###` the change serves.
- **Type** — tick the kind of change. The list (fixed here, and written identically in
  `.github/PULL_REQUEST_TEMPLATE.md`): `Lesson/exercise (C)` · `Lesson/exercise (Rust)` · `Kernel` ·
  `Syntek OS` · `TUI / GUI tools` · `LLM` · `Security` · `Notes, syllabus or research` ·
  `Tooling / CI` · `Fix`.
- **Build & test** — what you ran locally before pushing: the C targets, the Rust format, lint and
  test commands, the memory tools where the change allocates, and the two kernel boxes (QEMU only;
  nothing built committed). For a milestone, the evidence already sits in its
  `project-management/src/10-PROGRESS/` record; point at it rather than re-describing it.
- **Documentation gate** — trees updated, every new directory paired, instructional files within the
  length cap, links resolving, British English.
- **Quality** — markdownlint, commit messages per `project-management/docs/git/COMMITS.md`, and no
  secrets, personal details or absolute home paths.
- **Anything reviewers should know** — the trade-offs weighed and what was deliberately left out.

---

## The six CI checks

Every workflow runs on `ubuntu-24.04`, on pushes to `main`, on every pull request and on manual
dispatch. The C, Rust and docs workflows call the scripts in `code/src/scripts/` rather than holding
their own logic; the shell, Markdown and secrets workflows run their tools directly (ShellCheck,
markdownlint-cli2, TruffleHog). Each file opens with a comment explaining why the gate exists.

| Check (workflow `name:`) | Workflow file | What it proves |
| --- | --- | --- |
| `Syntax — C` | `.github/workflows/syntax-c.yml` | Every C exercise builds warning-free and passes its tests, sanitisers, valgrind and analyser |
| `Syntax — Rust` | `.github/workflows/syntax-rust.yml` | The workspace is formatted, clippy-clean at `-D warnings` and tested on the pinned toolchain; a second job runs cargo-deny |
| `Syntax — Shell` | `.github/workflows/syntax-shell.yml` | Every shell script parses (`bash -n`) and passes ShellCheck |
| `Markdown — Lint` | `.github/workflows/markdown-lint.yml` | Every Markdown file passes markdownlint-cli2 with `.markdownlint-cli2.jsonc` |
| `Audit — Docs` | `.github/workflows/audit-docs.yml` | Instructional Markdown stays within the length cap and every directory is paired |
| `Audit — Secrets` | `.github/workflows/audit-secrets.yml` | TruffleHog finds no verified secret in the pushed commits |

The exact steps are in each workflow file; the commands they run are the ones in
`how-to/workflows/03-quality-gates/`. A green `gates/all.sh` covers the scripted gates only (1 to 11 in
that workflow); a green CI run also needs the three lints it lists as CI gates.
**All six are unfiltered today, deliberately**, and each file's header says so: none is required yet,
and running on every change keeps every one of them eligible to become required without an edit.

---

## Required checks and path filters

**A workflow may be path-filtered, or it may be a required status check. Never both.**

GitHub treats a required check as satisfied only when it reports. A workflow skipped by a path filter
never runs, so its check stays _Pending_ and the pull request cannot merge, with nothing to re-run
(GitHub's own troubleshooting page for required status checks says exactly this). A documentation-only
pull request blocked forever by a required C check is the usual way it is discovered.

So each workflow makes one choice, and says which in the comment at the top of its file:

| Kind | Path filter | Why |
| --- | --- | --- |
| **Required** | None | It has to report on every pull request, including ones it has no work for |
| **Advisory** | Allowed | It runs only when its own inputs change, and never blocks a merge |

**Making a check required means deleting its path filter in the same change.** Adding it to branch
protection while it still carries `paths:` is the failure above, and the first pull request to trip it
will look like a GitHub outage.

**Require the job, and copy its name.** For a workflow, the name branch protection matches is the
**job's** `name:`, not the workflow's (`C build, tests, sanitisers, valgrind and analyser`, not
`Syntax — C`), and a workflow with two jobs, like `Syntax — Rust`, is two checks. Copy the names from a
finished run's _Checks_ tab, never retype them: the workflow names carry an em dash (`—`), not a hyphen,
and a name retyped wrongly is a required check that never arrives, which is the same pending-forever
failure reached by a second route.

**Branch protection is optional for a solo repository.** If you turn it on, require the checks and
nothing more: **do not require approving reviews.** GitHub does not let a pull request's author
approve it, so a one-person repository would have to bypass its own rule on every merge.

---

## Merging

1. Every check is green, the template's boxes are honest, and the milestone's
   `project-management/src/10-PROGRESS/` record is in the diff.
2. Merge with **Create a merge commit** for a milestone branch: it keeps the red → green → refactor
   commits that show how the concept was learned, and the merge commit marks where the milestone
   landed. **Squash and merge** suits a `docs/` or `ci/` branch that is one logical change.
3. Delete the branch (`project-management/docs/git/BRANCHES.md` → _Branch lifecycle_).
4. `13-pr-and-merge` then records the merge against the milestone; the status rules are owned by
   `project-management/docs/planning/MILESTONES.md` → _Statuses_.

---

## Related

- [`project-management/docs/git/BRANCHES.md`](BRANCHES.md) — branch names and what may skip a pull request
- [`project-management/docs/git/COMMITS.md`](COMMITS.md) — the commits the pull request is made of
- `how-to/workflows/03-quality-gates/` — the same gates, run locally
- `.github/PULL_REQUEST_TEMPLATE.md` — the template itself
