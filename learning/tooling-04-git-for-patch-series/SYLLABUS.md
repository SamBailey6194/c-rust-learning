# Syllabus — tooling-04-git-for-patch-series

**Track**: tooling · **Phase**: P1 · **Path**: Core · **Detail**: full · **Prerequisites**: none (lesson 06's Build uses `tooling-03` lesson 08's script)
**Status**: Planned · **Checked**: 27/09/2026 (sources re-verified by `/teach` step 3 before each lesson)

A downstream kernel is a small patch series carried across every stable release (`kernel-05`):
each release means rebasing the series, resolving the same conflicts again, checking what changed
between the old and new versions, and — when something breaks — bisecting. This topic teaches those
git moves on material Sam already has: this repository's own history, and throwaway practice
repositories created outside this working tree and never committed. Lessons 01–02 come before
`kernel-01`, the whole topic before `kernel-05`, lesson 06 before `kernel-06`, and lesson 05 is
what `kernel-07`'s email workflow builds on. The host runs git 2.43.0 while git-scm.com documents the
newest release, so every version-sensitive fact is checked against the installed `man git-<command>`;
Sam runs every interactive command (an editor-driven rebase, `add -p`) himself. The downstream
kernel tree itself lives in the downstream kernel repository, created in `kernel-05` lesson 02
(`.claude/CLAUDE.md` Section 5).

| # | Lesson | Size | Build | Lenses |
| --- | --- | --- | --- | --- |
| 01 | The object model and refs, read with `git log --graph` | 1 sitting | no | — |
| 02 | Crafting commits: `add -p`, fixup commits and `--autosquash` | 1 sitting | no | Safety |
| 03 | Rebasing a series onto a new base, conflicts and `git rerere` | 2–3 sittings | no | Safety |
| 04 | Comparing two versions of a series with `git range-diff` | 1 sitting | no | — |
| 05 | Patches as files: `format-patch`, `am` and trailers (Signed-off-by, DCO) | 2–3 sittings | no | Security |
| 06 | Finding a regression with `git bisect`, by hand then with `bisect run` | 2–3 sittings | yes — bisect adapter | Safety |
| 07 | Worktrees: several branches checked out at once | 1 sitting | no | — |

---

## 01 — The object model and refs, read with `git log --graph`

- **Objective:** Sam can draw the commits, trees and blobs behind a short history and say what a
  branch, a tag and `HEAD` each point at.
- **Builds on:** Sam's everyday use of git in this repository, with its commit conventions in
  `project-management/docs/git/COMMITS.md`.
- **Key ideas:**
  - Git stores four object types — blob, tree, commit and tag — each named by the hash of its
    content.
  - A commit points at one tree (the snapshot) and at its parent commits; history is a graph of
    commits, not a list of diffs.
  - A branch is a ref under `refs/heads/` that moves as commits are added; `HEAD` normally names a
    branch, and is "detached" when it names a commit directly.
  - A lightweight tag is only a ref; an annotated tag is an object of its own with a message.
  - Amending or rebasing never edits a commit: it writes new ones, and the old ones stay reachable
    through the reflog for a while.
  - `git log --graph --oneline --decorate --all` draws the graph with every ref on it;
    `git cat-file -t` and `-p` walk the objects by hand.
- **Recall targets:** after an amend, predict which hashes change and where the old commit can still
  be found; explain what `main` is, on disk, in this repository.
- **Build:** none — read this repository's own history.
- **Sources:** `man gitglossary` (git 2.43.0) → object type, ref, HEAD, detached HEAD, reflog, and
  <https://git-scm.com/docs/gitglossary>; `man git-cat-file`; `man gitrevisions`; Pro Git, 2nd
  edition, 10.2 Git Objects, <https://git-scm.com/book/en/v2/Git-Internals-Git-Objects>, and 10.3
  Git References, <https://git-scm.com/book/en/v2/Git-Internals-Git-References>.
- **Done when:** Sam walks from `HEAD` to a commit, its tree and one file's blob in this repository
  with `git cat-file -p`, unaided, explaining each step.

## 02 — Crafting commits: `add -p`, fixup commits and `--autosquash`

- **Objective:** Sam can split a mixed working tree into logical commits and fold a later correction
  into the right earlier commit before the series is shared.
- **Builds on:** lesson 01.
- **Key ideas:**
  - One logical change per commit, and every commit builds: the kernel asks for exactly this so that
    anyone bisecting can stop on any patch.
  - `git add -p` stages hunk by hunk (and can split a hunk); `git diff --staged` shows what the
    commit will hold before it is made.
  - `git commit --fixup=<commit>` records a correction as a `fixup!` commit aimed at an earlier one.
  - `git rebase -i --autosquash <base>` moves each fixup next to its target and folds it in. On this
    host's git 2.43.0, `--autosquash` without `-i` does nothing (checked 27/09/2026); git 2.44 made
    it work for non-interactive rebases too.
  - Rewrite only history nobody else has fetched; Sam runs the interactive rebase himself, because
    it opens an editor.
- **Recall targets:** explain why a fixup folded into its target beats a separate "fix typo" commit
  in a series someone will bisect; predict what `git rebase --autosquash` without `-i` does on git
  2.43.
- **Build:** none — practised in a throwaway practice repository outside this working tree, then
  used on Sam's next milestone branch.
- **Safety:** `git reflog` finds the pre-rebase commit if a rebase goes wrong; practise any rewrite in
  the throwaway repository first.
- **Sources:** `man git-add` (git 2.43.0) → `--patch`, Interactive mode; `man git-commit` →
  `--fixup`; `man git-rebase` → `--autosquash`, and <https://git-scm.com/docs/git-rebase>; Git 2.44.0
  release notes, <https://raw.githubusercontent.com/git/git/master/Documentation/RelNotes/2.44.0.adoc>;
  "Submitting patches" → Separate your changes, <https://docs.kernel.org/process/submitting-patches.html>.
- **Done when:** in the practice repository, a mixed working tree becomes two commits via `add -p`,
  a fixup is folded in with `rebase -i --autosquash`, and `git log -p` shows two clean commits that
  each build.

## 03 — Rebasing a series onto a new base, conflicts and `git rerere`

- **Objective:** Sam can move a series onto a newer upstream with `git rebase --onto`, resolve a
  conflict, and have git replay that resolution the next time the same conflict appears.
- **Builds on:** lessons 01–02.
- **Key ideas:**
  - A rebase replays each commit of the series on a new base, so every replayed commit gets a new
    hash.
  - `git rebase --onto <newbase> <upstream> <branch>` names three things: where the series goes, where
    it used to start, and which branch holds it.
  - A conflict stops the replay: resolve the file, `git add` it, `git rebase --continue` — or
    `--abort` to return to the start.
  - With `rerere.enabled` set, git records each hand resolution and reuses it when the same conflict
    comes back; it still stops so the result can be reviewed, unless `rerere.autoUpdate` is set.
  - This is the per-release chore of a downstream kernel: the same small series, the same conflicts,
    on each new stable tag.
- **Recall targets:** say what each argument of `--onto` means; explain what rerere records, when it
  reuses it, and why the rebase still pauses.
- **Build:** none — a practice repository whose "upstream" branch moves twice under a two-commit
  series.
- **Safety:** `git rebase --abort` and the reflog undo a rebase; nothing here touches a shared branch.
- **Sources:** `man git-rebase` (git 2.43.0) → `--onto`, and <https://git-scm.com/docs/git-rebase>;
  `man git-rerere`, and <https://git-scm.com/docs/git-rerere>; `git config --help` →
  `rerere.enabled`, `rerere.autoUpdate`.
- **Done when:** Sam rebases the practice series across both upstream moves, and on the second git
  reports that it resolved the file using the previous resolution.

## 04 — Comparing two versions of a series with `git range-diff`

- **Objective:** Sam can compare version 1 and version 2 of a series and say, patch by patch, what
  changed.
- **Builds on:** lesson 03.
- **Key ideas:**
  - After a rebase, `git diff` between the old and new tips mixes upstream's changes with your own;
    range-diff pairs each old commit with its new counterpart and compares the patches themselves.
  - Ranges can be given as `<base> <rev1> <rev2>`, as `<rev1>...<rev2>`, or as two explicit ranges.
  - In the output, `=` marks a patch that did not change, `!` one that did (with the diff of the
    diffs), `<` a patch that was dropped and `>` a patch that is new.
  - `git format-patch --range-diff=<previous>` puts the same comparison in a cover letter for
    reviewers (lesson 05).
- **Recall targets:** say what `=`, `!`, `<` and `>` mean; explain why a plain diff between two tips is
  the wrong tool after a rebase.
- **Build:** none — run on the two versions of lesson 03's practice series.
- **Sources:** `man git-range-diff` (git 2.43.0) → DESCRIPTION, EXAMPLES, and
  <https://git-scm.com/docs/git-range-diff>.
- **Done when:** Sam runs range-diff on the lesson 03 series and explains every line of the output.

## 05 — Patches as files: `format-patch`, `am` and trailers (Signed-off-by, DCO)

- **Objective:** Sam can turn a series into numbered patch files with a cover letter, apply them in
  another clone with `git am`, and sign off his own work knowing what the sign-off certifies.
- **Builds on:** lessons 02–04.
- **Key ideas:**
  - `git format-patch -o <dir> <base>..` writes one mail-formatted file per commit; `-v <n>` marks a
    re-roll (`[PATCH v2 1/3]`) and `--cover-letter` adds a patch 0 that introduces the series.
  - `git am` applies such files as commits, keeping author and message; `-3` falls back to a three-way
    merge when a patch does not apply cleanly.
  - Trailers are the final block of `Key: value` lines in a message; `git interpret-trailers` reads
    and writes them, and `git commit -s` adds `Signed-off-by`.
  - `Signed-off-by` certifies the Developer's Certificate of Origin 1.1 — that the contributor has
    the right to submit the work under the project's licence — so it is a statement, not a courtesy.
  - The kernel's guidance says a coding assistant must not add `Signed-off-by`: only a human can
    certify the DCO, and assistant use is acknowledged with an `Assisted-by` tag instead. In this
    repository sign-off is optional (`project-management/docs/git/COMMITS.md` → Trailers).
  - Sending patches by email (`git send-email`, b4) belongs to `kernel-07`; neither is installed here.
- **Recall targets:** state in plain words what the DCO certifies; explain why a coding assistant
  cannot sign off for Sam; say what `-v 2` changes in the output.
- **Build:** none — in the practice repository, format a two-patch series with a cover letter and
  apply it to a fresh clone.
- **Security lens:** `git am` turns text from outside into commits; read every patch before applying
  it, and treat an unsigned or re-routed patch as unverified provenance.
- **Sources:** `man git-format-patch` (git 2.43.0) → `-o`, `-v`, `--cover-letter`, `--range-diff`;
  `man git-am` → `-3`, `-s`; `man git-interpret-trailers`; Developer Certificate of Origin 1.1,
  <https://developercertificate.org/>; "Submitting patches" → Sign your work,
  <https://docs.kernel.org/process/submitting-patches.html>; "AI Coding Assistants",
  <https://docs.kernel.org/process/coding-assistants.html>.
- **Done when:** the practice patches apply cleanly with `git am` in a fresh clone, each commit
  carries Sam's own sign-off, and Sam restates the four DCO clauses in his own words.

## 06 — Finding a regression with `git bisect`, by hand then with `bisect run`

- **Objective:** Sam can bisect a regression by hand, then automate it with a script whose exit
  codes `git bisect run` understands.
- **Builds on:** lesson 02 (a series where every commit builds); `tooling-03` lessons 02 and 08 for
  the Build.
- **Key ideas:**
  - Bisect is a binary search over history: `start`, mark one `good` and one `bad`, and each test
    halves the range, so about ten steps cover a thousand commits.
  - `skip` handles a commit that cannot be tested; `reset` returns to where the search began; `log`
    and `replay` record and repeat a session.
  - `bisect run` reads its script's exit code: 0 good, 1 to 127 except 125 bad, 125 skip, anything
    else aborts.
  - The repository's gate contract clashes with that: its 2 ("could not run") would be read as
    "bad", so an adapter maps it to 125.
  - The run script is safer outside the repository being bisected, because bisect checks out other
    commits underneath it.
- **Recall targets:** predict what bisect concludes when the test script exits 2 because a tool is
  missing; estimate the number of steps for a given range; say why the script sits outside the
  bisected tree.
- **Build:** bisect adapter — a thin script that runs `tooling-03` lesson 08's `verify.sh` and maps
  its 0, 1 and 2 onto bisect's 0, 1 and 125. Planned path beside that script,
  `code/src/c/msNNN-<kebab>/` (planned: `NNN` from its milestone's `EX-MS###` spec), invoked from
  this checkout against a separate practice clone of this repository with a planted regression, so
  it stays outside the tree being bisected. Checked by: `bisect run` names the planted commit; a
  commit where a needed tool is unavailable is skipped, not blamed; `bash -n` locally, and
  ShellCheck in CI once its folder is among the roots `.github/workflows/syntax-shell.yml` scans
  (as for `verify.sh`). A small exercise, so it lives in this repository.
- **Safety:** bisect checks out old commits, whose scripts are run as they were then — never as root;
  `git bisect reset` restores the branch.
- **Sources:** `man git-bisect` (git 2.43.0) → Bisect run, EXAMPLES, and
  <https://git-scm.com/docs/git-bisect>; "Submitting patches" → Separate your changes (every patch
  builds), <https://docs.kernel.org/process/submitting-patches.html>.
- **Done when:** Sam finds the planted commit by hand first, then with `bisect run` and the adapter,
  and the skipped commit appears as skipped in `git bisect log`.

## 07 — Worktrees: several branches checked out at once

- **Objective:** Sam can check out a second branch in its own directory to build, test or review it
  without stashing, and remove it cleanly afterwards.
- **Builds on:** lesson 01.
- **Key ideas:**
  - One repository can have several working trees: the objects and refs are shared, while each
    worktree has its own `HEAD`, index and files.
  - `git worktree add <path> <branch>` checks out an existing branch; `add -d <path>` makes a
    throwaway detached one; `list`, `remove` and `prune` manage them.
  - `add` refuses a branch already checked out in another worktree, so two trees can never fight
    over one branch.
  - Uses ahead: building the previous stable line while editing the current one (`kernel-05`),
    reviewing a contributor's pull request (`tooling-05`), running a bisect without disturbing work.
  - This repository's `.gitignore` excludes the folder where Claude Code keeps worktrees of its own
    (`.claude/CONTEXT.md` lists it), so they never reach a commit.
- **Recall targets:** say what worktrees share and what each keeps to itself; explain why `add`
  refuses a branch that is already checked out.
- **Build:** none.
- **Sources:** `man git-worktree` (git 2.43.0) → DESCRIPTION, `add`, `--force`, and
  <https://git-scm.com/docs/git-worktree>.
- **Done when:** Sam adds a worktree for a second branch, builds there, removes it, and
  `git worktree list` shows only the main worktree again.
