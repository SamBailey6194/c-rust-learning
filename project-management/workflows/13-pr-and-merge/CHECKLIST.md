---
workflow: 13-pr-and-merge
phase: record
skills: []
---

# PR and Merge — Checklist

**Last Updated**: 27/09/2026 | **Version**: 0.1.0 | **Maintained By**: Sam Bailey
**Language**: British English (en_GB) | **Timezone**: Europe/London

---

> **See** `project-management/docs/GIT-GUIDE.md` (branches, commits, pull requests) ·
> `project-management/docs/git/PR-AND-CHECKS.md` (the CI checks, merging) ·
> `project-management/REFERENCES.md` for supporting references.

## Execution Checklist

### Step 1 — Confirm the branch is ready

- [ ] The branch is named per `project-management/docs/git/BRANCHES.md`
- [ ] `git status --short` prints nothing
- [ ] For a milestone branch: the verification, review and finding records are on the branch, and the
      Status reads `Verifying`

### Step 2 — Run the local gates

- [ ] `bash code/src/scripts/gates/all.sh` exited 0 (an exit 2 is not a pass)
- [ ] The markdown lint reports no issues on the changed files

### Step 3 — Push and open the pull request from the template

- [ ] The pull request targets `main` and started from `.github/PULL_REQUEST_TEMPLATE.md`
- [ ] The title is a Conventional Commits summary naming the milestone
- [ ] Every template section is filled, with build-and-test lines quoted from the `10-PROGRESS` record
- [ ] The milestone, plan and records are linked by repo-relative path

### Step 4 — Wait for the checks

- [ ] `Syntax — C`, `Syntax — Rust` (two jobs), `Syntax — Shell`, `Markdown — Lint`, `Audit — Docs` and
      `Audit — Secrets` all passed on the latest commit: seven checks from six workflows
- [ ] Every failure was fixed on the branch with a new commit, not by rewriting history
- [ ] A fix that changed code sent the milestone back through `11-verification` from Step 1

### Step 5 — Read the diff one last time

- [ ] No build output, kernel tree, disk image, scratch file, absolute host path or credential in the diff

### Step 6 — Set the milestone to `Completed` in the final commit

- [ ] For a milestone branch: the Status change, the `ROADMAP.md` "You are here" update and any `13-BUGS`
      record moved from `Fixed` to `Verified` are the branch's last commit, staged by path
- [ ] Every check passed again on that commit

### Step 7 — Confirm the learner is ready to merge

- [ ] The learner confirmed the merge after seeing the checks, the records and the merge method

### Step 8 — Merge by the branch's method

- [ ] Milestone branch merged with a merge commit; `docs/` or `ci/` branch squashed
- [ ] `--admin` was not used

### Step 9 — Delete the branch and prune

- [ ] `gh pr view` printed `MERGED` before any branch was deleted
- [ ] The branch is deleted locally and on GitHub
- [ ] `git fetch --prune` ran and `git branch -a` shows no stale reference
- [ ] Any `-D` was used only after the learner's go-ahead and a confirmed merge

### Step 10 — Hand on to what comes next

- [ ] For a sprint's last milestone: the Retrospective is finished on a `pm/<desc>` branch
- [ ] Anything CI exposed and not yet fixed is in `GAPS.md`

---

## Context

- [ ] Directory trees in the relevant `CONTEXT.md` files show every file or folder this workflow created
- [ ] `project-management/REFERENCES.md` lists any new artefact type or external source
- [ ] `**Last Updated**` is refreshed in every `CONTEXT.md` modified
- [ ] If the session ended mid-work, a handoff exists in `handoffs/`

---

## Definition of Done

- [ ] The pull request is merged into `main` with all seven checks green
- [ ] For a milestone: `main` shows it `Completed`, with its verification record
- [ ] The branch is gone locally and on GitHub
- [ ] The next milestone is named, ready for `project-management/workflows/02-milestone-creation/`
