---
workflow: 13-pr-and-merge
phase: record
skills: []
---

# PR and Merge — Steps

**Last Updated**: 27/09/2026 | **Version**: 0.1.0 | **Maintained By**: Sam Bailey
**Language**: British English (en_GB) | **Timezone**: Europe/London

---

## Key references

Consult `project-management/REFERENCES.md` → **External — Version Control & CI** (Conventional Commits,
required status checks, GitHub Actions) as you work through these steps:

| Step | Section |
| --- | --- |
| 1, 9 | `project-management/docs/git/BRANCHES.md` — prefixes and the branch lifecycle |
| 2 | `how-to/workflows/03-quality-gates/` — the local gates and the markdown lint command |
| 3 | `project-management/docs/git/PR-AND-CHECKS.md` — opening the pull request, the template |
| 4 | `project-management/docs/git/PR-AND-CHECKS.md` — the six CI checks, required checks and path filters |
| 4 to 6 | `project-management/docs/git/COMMITS.md` — staging, message format, trailers |
| 6 | `project-management/docs/planning/MILESTONES.md` — _Statuses_ |
| 8 | `project-management/docs/git/PR-AND-CHECKS.md` — _Merging_ |

---

## Steps

### Step 1 — Confirm the branch is ready

For a milestone branch, check that the records exist and the tree is clean:

```bash
git branch --show-current     # ms###/<short-kebab>
git status --short            # prints nothing
git log --oneline main..HEAD  # the milestone's commits, red-green-refactor included
ls project-management/src/10-PROGRESS/MS###-VERIFICATION.md
```

The review and finding records from `12-review-and-reflect` are on the branch, and the milestone's Status
reads `Verifying`. A `pm/`, `docs/` or `ci/` branch skips the record checks.

_Done when the branch name, a clean tree and every record the milestone needs are confirmed._

### Step 2 — Run the local gates

```bash
bash code/src/scripts/gates/all.sh
```

Then run the markdown lint on the changed Markdown files, using the command in
`how-to/workflows/03-quality-gates/`. Shellcheck is not installed on the host
(`how-to/docs/TOOLCHAIN.md`), so `Syntax — Shell` first runs in CI; read its result there with care.

_Done when `gates/all.sh` exits 0 and the markdown lint reports no issues._

### Step 3 — Push and open the pull request from the template

```bash
git push -u origin ms###/<short-kebab>
gh pr create --base main --title "feat(c): MS### <short description>" \
    --template .github/PULL_REQUEST_TEMPLATE.md
```

`--template` seeds the body with the repository template; `gh pr create --base main --web` does the same
in GitHub's form. Fill every section: the `MS###` served, the type of change, the build-and-test summary
lines quoted from the `10-PROGRESS` record, the documentation gate, and anything a reader should know.
Link the milestone, its plan and its verification, review and finding records by repo-relative path.

_Done when the pull request exists against `main` with every template section filled._

### Step 4 — Wait for the checks

```bash
gh pr checks --watch --fail-fast
```

All six workflows report and pass: `Syntax — C`, `Syntax — Rust`, `Syntax — Shell`, `Markdown — Lint`,
`Audit — Docs`, `Audit — Secrets`. `gh pr checks` lists seven checks, because `Syntax — Rust` runs two
jobs (`project-management/docs/git/PR-AND-CHECKS.md` → _Required checks and path filters_). On a failure,
open the run's log (`gh pr checks --web`) and fix the cause on the branch with a new commit:

- **A fix that changes code** (anything a gate builds, tests or lints) sends the milestone back to
  `project-management/workflows/11-verification/` from Step 1, because the verification record describes
  one complete run at one commit (`project-management/src/10-PROGRESS/CLAUDE.md`).
- **Any other fix** (Markdown, a CI file, a stray file) is pushed, and the checks are watched again.

A check that stays pending for ever is usually the path-filter trap described in
`project-management/docs/git/PR-AND-CHECKS.md` → _Required checks and path filters_.

_Done when all seven checks show as passed on the latest commit._

### Step 5 — Read the diff one last time

```bash
gh pr diff --name-only
```

Look for anything that does not belong: build output (`build/`, `target/`), a kernel source tree, a disk
image, a scratch file, an absolute path from the host, anything that looks like a credential. The
repository is public. A stray file is removed on the branch with a new commit, and Step 4 runs again.

_Done when every file in the diff is one the milestone meant to change._

### Step 6 — Set the milestone to `Completed` in the final commit

This comes last, once the checks are green and the diff is right, so nothing lands after it. For a
milestone branch, set the milestone's `**Status:**` to `Completed`, tick its Definition of Done, move each
of the milestone's `project-management/src/13-BUGS/` records whose Fix state reads `Fixed` on to `Verified`
(`project-management/src/13-BUGS/CLAUDE.md`), and move the "You are here" row in
`project-management/src/01-ROADMAP/ROADMAP.md` on to what comes next
(`project-management/workflows/01-roadmap-map/STEPS.md` → Step 11 says what the row records). Lint the
changed files, then commit them by path, in one commit, so the marker never lands without its status or
the status without its marker:

```bash
npx --yes markdownlint-cli2 --no-globs project-management/src/02-MILESTONES/MS###-<TITLE>.md \
    project-management/src/01-ROADMAP/ROADMAP.md
git add project-management/src/02-MILESTONES/MS###-<TITLE>.md \
        project-management/src/01-ROADMAP/ROADMAP.md \
        project-management/src/13-BUGS/BUG-MS###-<DESCRIPTOR>-DD-MM-YYYY.md   # any the milestone has
git commit -m "docs(pm): mark MS### completed on merge"
git push
gh pr checks --watch --fail-fast
```

`Completed` means merged to `main` with a verification record. The status reaches `main` only through
this merge, so `main` never shows it early; if the pull request is abandoned, revert the commit and the
milestone stays `Verifying`.

_Done when the branch's last commit carries the status change and the marker move together, and every
check is green on it._

### Step 7 — Confirm the learner is ready to merge

Summarise for the learner: the checks, the records linked, and the merge method Step 8 will use. Merging
publishes the work on `main`; wait for their go-ahead.

_Done when the learner has confirmed the merge._

### Step 8 — Merge by the branch's method

Run the one line that matches the branch:

```bash
gh pr merge --merge     # ms###/ milestone branch: a merge commit keeps the learning history
gh pr merge --squash    # docs/ or ci/ branch: one logical change, one commit
```

`project-management/docs/git/PR-AND-CHECKS.md` → _Merging_ owns which method applies. Never add
`--admin`.

_Done when GitHub shows the pull request as merged._

### Step 9 — Delete the branch and prune

```bash
gh pr view ms###/<short-kebab> --json state -q .state   # MERGED
git switch main
git pull --ff-only
git branch -d ms###/<short-kebab>
git push origin --delete ms###/<short-kebab>
git fetch --prune
```

Go past the first line only when it prints `MERGED`: that is the check that the work reached `main`.
`git branch -d` is not one. With an upstream set, as `git push -u` set it, `-d` only checks that the
branch's commits are on its upstream (`man git-branch`, `-d`), so it deletes a pushed branch whether or
not it was merged, and a squash-merged one without complaint. It refuses only a branch with unpushed
commits; stop there and ask the learner before using `-D`.

_Done when the branch is gone locally and on GitHub, and `git branch -a` shows no stale reference._

### Step 10 — Hand on to what comes next

The milestone is now `Completed` on `main`. If it was the last member of a `Full` study sprint, or the
sprint's two weeks are up, finish the sprint's Retrospective on a `pm/<desc>` branch (`12-review-and-reflect`
Step 8). Record anything CI exposed that is not yet fixed in `GAPS.md`. The next milestone starts at
`project-management/workflows/02-milestone-creation/`, on its own `ms###/` branch.

_Done when the sprint and registers are current and the next step is named._

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
