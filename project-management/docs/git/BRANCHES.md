---
type: guide
---

# Git Guide — Branches

**Last Updated**: 27/09/2026 | **Version**: 0.1.0 | **Maintained By**: Sam Bailey
**Language**: British English (en_GB) | **Timezone**: Europe/London

Where work sits and what it is called: one long-lived branch, short-lived topic branches, and the
few changes allowed straight onto `main`. Index: [`project-management/docs/GIT-GUIDE.md`](../GIT-GUIDE.md).

---

## The model

```text
ms###/<short-kebab>  ─┐
docs/<desc>          ─┤
ci/<desc>            ─┼──  pull request  ──→  main
pm/<desc>            ─┘
```

`main` is the only long-lived branch, and everything on it has passed the CI checks
(`project-management/docs/git/PR-AND-CHECKS.md`). There is no `dev`, `staging` or release branch:
nothing here is deployed, and one learner working one milestone at a time has nothing to integrate.

---

## Branch prefixes

| Prefix | Use it for | Example |
| --- | --- | --- |
| `ms###/<short-kebab>` | Everything one milestone produces: its specs, plan, notes, code, verification record | `ms007/dynamic-array` |
| `pm/<desc>` | PM work owned by no single milestone: a track map, a roadmap change, a Retrospective written when no milestone branch is open | `pm/map-c-foundations` |
| `docs/<desc>` | Documentation outside a milestone: guides, `CONTEXT.md`/`CLAUDE.md` pairs, skills, a stand-alone research note | `docs/build-guide-san-target` |
| `ci/<desc>` | CI workflows, `code/src/scripts/`, hooks and repository configuration | `ci/shellcheck-hooks` |

- **Lower case, kebab-case, short.** The description says what, not how: `ms012/unix-shell-pipes`,
  not `ms012/sams-attempt-2`.
- **`ms###` is the milestone's own number**, three digits, lower-case `ms` (`ms007`, not `MS7`), so the
  branch sorts beside its siblings and names the `MS###` it serves.
- **One milestone, one branch.** The cadence runs one milestone at a time
  (`project-management/docs/planning/CADENCE.md`), so there is one `ms###/` branch in flight. It is
  opened when `02-milestone-creation` writes the milestone and merged by `13-pr-and-merge`, which is
  why the milestone's whole loop (spec, plan, study, proof) arrives on `main` as one reviewable pull
  request.

---

## Branch lifecycle

Start from an up-to-date `main`:

```bash
git switch main
git pull --ff-only
git switch -c ms007/dynamic-array
```

Push the branch the first time with an upstream, then open the pull request when the milestone reaches
`13-pr-and-merge` (or earlier as a draft, if you want CI's opinion sooner):

```bash
git push -u origin ms007/dynamic-array
```

After the merge, confirm it, then delete the branch in both places and prune the stale remote
reference:

```bash
gh pr view ms007/dynamic-array --json state -q .state   # MERGED, or stop here
git switch main
git pull --ff-only
git branch -d ms007/dynamic-array
git push origin --delete ms007/dynamic-array
git fetch --prune
```

The `gh pr view` line is the safety net: it prints `MERGED` only once the pull request is merged.
`git branch -d` (lower-case) is not one. When the branch has an upstream, as `git push -u` gave it, `-d`
checks only that its commits are on that upstream (`man git-branch`, `-d`), so it deletes a pushed branch
whether or not it reached `main`. It refuses a branch with unpushed commits; reach for `-D` only when you
mean to throw that work away.

---

## Straight to `main`

**Small documentation fixes may go straight to `main`**, and nothing else may. "Small" means all of
these hold:

- one or two files, and the change is a typo, a broken link, a formatting fix or a `Last Updated`
  refresh
- no rule, command, status word, path or figure changes meaning
- the markdown lint passes on the changed files (`npx --yes markdownlint-cli2 --no-globs <changed files>`
  from the repository root — without `--no-globs` it lints the whole repository; the full gate set is in
  `how-to/workflows/03-quality-gates/`)

Anything that fails one of those goes on a branch. Code never goes straight to `main`, however small:
the C and Rust checks are the proof that `main` still builds.

---

## Related

- [`project-management/docs/git/COMMITS.md`](COMMITS.md) — what happens on the branch, commit by commit
- [`project-management/docs/git/PR-AND-CHECKS.md`](PR-AND-CHECKS.md) — how the branch reaches `main`
- `project-management/docs/planning/CADENCE.md` — why there is one milestone, and so one branch, at a time
