# Resources — tooling-04-git-for-patch-series

| Lesson | Primary source (pinned) | House guide | Code |
| --- | --- | --- | --- |
| 01 The object model and refs | `man gitglossary`, `man git-cat-file`, `man gitrevisions` (git 2.43.0); Pro Git 2nd ed. 10.2, <https://git-scm.com/book/en/v2/Git-Internals-Git-Objects>, and 10.3, <https://git-scm.com/book/en/v2/Git-Internals-Git-References> | `project-management/docs/git/COMMITS.md` | — |
| 02 Crafting commits | `man git-add` → `--patch`; `man git-commit` → `--fixup`; `man git-rebase` → `--autosquash` (git 2.43.0); Git 2.44.0 release notes, <https://raw.githubusercontent.com/git/git/master/Documentation/RelNotes/2.44.0.adoc>; <https://docs.kernel.org/process/submitting-patches.html> → Separate your changes | `project-management/docs/git/COMMITS.md` — Before every commit | — |
| 03 Rebasing a series and `git rerere` | `man git-rebase` → `--onto`; `man git-rerere`; `git config --help` → `rerere.enabled`, `rerere.autoUpdate` (git 2.43.0); <https://git-scm.com/docs/git-rerere> | `project-management/docs/git/BRANCHES.md` | — |
| 04 `git range-diff` | `man git-range-diff` (git 2.43.0) → EXAMPLES; <https://git-scm.com/docs/git-range-diff> | — | — |
| 05 `format-patch`, `am` and trailers | `man git-format-patch`, `man git-am`, `man git-interpret-trailers` (git 2.43.0); DCO 1.1, <https://developercertificate.org/>; <https://docs.kernel.org/process/submitting-patches.html> → Sign your work; <https://docs.kernel.org/process/coding-assistants.html> | `project-management/docs/git/COMMITS.md` — Trailers | — |
| 06 `git bisect` and `bisect run` | `man git-bisect` (git 2.43.0) → Bisect run, EXAMPLES; <https://git-scm.com/docs/git-bisect> | `code/workflows/07-debug/` | `code/src/c/msNNN-<kebab>/` (planned — beside `tooling-03`'s `verify.sh`) |
| 07 Worktrees | `man git-worktree` (git 2.43.0); <https://git-scm.com/docs/git-worktree> | `.claude/CONTEXT.md` — the gitignored worktrees folder | — |
