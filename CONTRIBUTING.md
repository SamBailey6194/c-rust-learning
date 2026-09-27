# Contributing

Thanks for looking. c-rust-learning is a **personal learning repository** — one person working
through C and Rust, then a downstream Linux kernel, the Syntek OS distribution and its tools, and a
small language model, in public. That shapes what kind of help is useful.

The Syntek OS tools that take outside contributions will each live in a repository of their own,
with its own contribution guide, once their build starts; this repository keeps the lessons and the
learner's own exercises.

## Welcome

- **Corrections.** A wrong claim in a note or guide, a misread of the C standard, an outdated
  kernel detail, a broken link. Please cite the primary source (the standard clause, the man
  page, the kernel documentation page) so the fix can be checked.
- **Bug reports** in the scripts, CI workflows or build files — use the bug report form under
  **Issues → New issue**.
- **Topic suggestions** — a concept, exercise or resource worth adding to the curriculum — use
  the topic suggestion form.

## Please don't

- **Send solutions to open exercises.** The point of each exercise is for the learner to work it
  out; a finished answer, however good, removes the lesson. Hints and pointers to reading are
  welcome in an issue instead.
- **Open a public issue for a security problem** — see `SECURITY.md`.

## Pull requests

Pull requests are read, but may not be merged: most changes here are part of a learning
sequence and are made by the learner. For a small correction, a pull request is the quickest
route; for anything larger, open an issue first.

If you do open one:

- Branch names, Conventional Commit messages and the pull-request checklist are described in
  `project-management/docs/GIT-GUIDE.md`; the template in `.github/PULL_REQUEST_TEMPLATE.md`
  carries the checklist.
- The CI gates (C, Rust, shell, Markdown, docs, secrets) run on every pull request and need to
  pass.
- Write in British English (en_GB).
- Contributions are accepted under the repository's licence, GPL-2.0-only (`LICENSE`). A
  `Signed-off-by:` trailer in the Linux kernel's Developer Certificate of Origin style
  (<https://developercertificate.org/>) is welcome but optional.

## Conduct

Be kind and specific. Explain the why behind a correction — this is a place for learning, and
the reasoning is the useful part.
