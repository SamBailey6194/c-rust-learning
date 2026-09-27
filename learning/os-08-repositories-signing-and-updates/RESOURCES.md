# Resources — os-08-repositories-signing-and-updates

| Lesson | Primary source (pinned) | House guide | Code |
| --- | --- | --- | --- |
| 01 Repository metadata and mirrors | Alpine "Apk spec", Section 3, <https://wiki.alpinelinux.org/wiki/Apk_spec>; `repo-add(8)`, <https://man.archlinux.org/man/repo-add.8.en> | — | the Syntek OS package-manager repository |
| 02 Signing a repository | minisign, <https://jedisct1.github.io/minisign/>; `signify(1)`, <https://man.openbsd.org/signify>; RFC 9580, <https://www.rfc-editor.org/rfc/rfc9580>; `minisign-verify` 0.3.0, <https://docs.rs/minisign-verify/latest/minisign_verify/> | `code/docs/RUST-CODING-PRINCIPLES.md` — Section 2 | `code/src/rust/crates/msNNN_repo_verify/` (planned) |
| 03 The Update Framework's threat model | TUF specification 1.0.36, Sections 1.5.2, 2.1, 2.2, <https://theupdateframework.github.io/specification/latest/>; Samuel et al., CCS 2010, <https://theupdateframework.io/papers/survivable-key-compromise-ccs2010.pdf> | — | — |
| 04 Key management, rotation and compromise recovery | TUF specification 1.0.36, Sections 5.3 and 6.1, <https://theupdateframework.github.io/specification/latest/>; `pacman-key(8)`, <https://man.archlinux.org/man/pacman-key.8.en> | `research/CLAUDE.md` | `code/src/rust/crates/msNNN_repo_verify/` (planned); `research/PACKAGE-SIGNING-SCHEME.md` (planned) |
| 05 The secure update flow | TUF specification 1.0.36, Section 5 "Detailed client workflow", <https://theupdateframework.github.io/specification/latest/> | — | the Syntek OS package-manager repository |
| 06 Building, signing and publishing a repository | TUF specification 1.0.36, Sections 6.2–6.3, <https://theupdateframework.github.io/specification/latest/>; GitHub Docs "Secure use reference", <https://docs.github.com/en/actions/reference/security/secure-use> | — | the Syntek OS build-system repository |
