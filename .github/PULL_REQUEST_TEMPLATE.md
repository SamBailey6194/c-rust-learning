# Pull Request

## What this changes

<!-- One or two sentences. What is different after this merges? -->

## Why

<!-- The problem being solved, or what this adds to the learning path. Link the issue if there is one: Closes #123 -->

## Type

- [ ] Lesson/exercise (C)
- [ ] Lesson/exercise (Rust)
- [ ] Kernel
- [ ] Syntek OS
- [ ] TUI / GUI tools
- [ ] LLM
- [ ] Security
- [ ] Notes, syllabus or research
- [ ] Tooling / CI
- [ ] Fix

---

## Build & test

CI runs every gate below on this pull request; tick what you ran locally before pushing.
`bash code/src/scripts/gates/all.sh` runs them all and prints one summary table.

- [ ] `make -C code/src/c test` passes — warnings are errors (`-Wall -Wextra -Werror` and the rest of `code/src/c/mk/flags.mk`)
- [ ] `make -C code/src/c san` and `make -C code/src/c memcheck` are clean wherever the change allocates memory
- [ ] `cargo fmt --check`, `cargo clippy --all-targets -- -D warnings` and `cargo test` pass inside `code/src/rust/`
- [ ] Kernel work ran in QEMU only — nothing was installed or `insmod`-ed on the host
- [ ] OS images, installers and network labs ran in VMs / isolated virtual networks only
- [ ] No build output or kernel source tree is committed
- [ ] No model weights, checkpoints, datasets or disk images are committed; no untrusted pickle was loaded

## Documentation gate

- [ ] Directory trees in every affected `CONTEXT.md` are updated
- [ ] Any new directory has both a `CONTEXT.md` and a `CLAUDE.md` (`bash code/src/scripts/audits/docs-pairing.sh`)
- [ ] Instructional `.md` files are within 300 cloc code lines (`bash code/src/scripts/audits/docs-length.sh`)
- [ ] Cross-references and `REFERENCES.md` entries resolve
- [ ] Prose is British English

## Quality

- [ ] markdownlint passes (`npx --yes markdownlint-cli2` from the repository root)
- [ ] Commit messages follow the conventions in `project-management/docs/git/COMMITS.md`
- [ ] No secrets, tokens, personal details or absolute home paths

---

## Anything reviewers should know

<!-- Trade-offs you weighed, things you were unsure about, what you deliberately left out. -->
