# Resources — os-05-build-system-and-reproducibility

| Lesson | Primary source (pinned) | House guide | Code |
| --- | --- | --- | --- |
| 01 From book steps to recipes | `PKGBUILD(5)`, pacman 7.1.0, <https://man.archlinux.org/man/PKGBUILD.5.en>; Alpine "APKBUILD Reference", <https://wiki.alpinelinux.org/wiki/APKBUILD_Reference>; void-packages "Manual", <https://github.com/void-linux/void-packages/blob/master/Manual.md> | `code/docs/RUST-CODING-PRINCIPLES.md` — Section 3 | `code/src/rust/crates/msNNN_recipe/` (planned) |
| 02 The dependency graph and build order | LFS 13.1-systemd Appendix C, <https://www.linuxfromscratch.org/lfs/view/stable-systemd/appendices/dependencies.html>; `man 1 tsort` (coreutils 9.4) | `code/docs/TESTING.md` — Section 2 | `code/src/rust/crates/msNNN_build_order/` (planned) |
| 03 Isolated builds | `man 7 namespaces`, `man 7 user_namespaces`, `man 1 unshare`, `man 1 bwrap` (host); `man 2 chroot` | — | the Syntek OS build-system repository (created when this build starts) |
| 04 Reproducible builds and `SOURCE_DATE_EPOCH` | "SOURCE_DATE_EPOCH specification" rev. 1.1, <https://reproducible-builds.org/specs/source-date-epoch/>; "Archive metadata", <https://reproducible-builds.org/docs/archives/>; arXiv:2104.06020 | — | the Syntek OS build-system repository |
| 05 Independent rebuilds and diffoscope | diffoscope, <https://diffoscope.org/>; reproducible-builds.org "Tools", <https://reproducible-builds.org/tools/> | — | the Syntek OS build-system repository |
| 06 CI and build farms | Hydra, <https://github.com/NixOS/hydra>; GitHub Docs "Secure use reference", <https://docs.github.com/en/actions/reference/security/secure-use> | `how-to/workflows/03-quality-gates/` | the Syntek OS build-system repository |
