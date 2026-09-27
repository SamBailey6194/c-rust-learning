# Resources — os-01-anatomy-of-a-distro

| Lesson | Primary source (pinned) | House guide | Code |
| --- | --- | --- | --- |
| 01 The boot chain, end to end | `man 7 boot`, `man 7 bootup` (host, man-pages 6.7, systemd 255); "Ramfs, rootfs and initramfs", <https://docs.kernel.org/filesystems/ramfs-rootfs-initramfs.html> (7.3.0-rc4 docs, read 27/09/2026) | — | — |
| 02 The filesystem hierarchy | FHS 3.0, Chapters 2–5, <https://refspecs.linuxfoundation.org/FHS_3.0/fhs/index.html>; `man 7 hier`, `man 7 file-hierarchy` | — | — |
| 03 The toolchain trio | musl "Functional differences from glibc", <https://wiki.musl-libc.org/functional-differences-from-glibc.html>; LFS 13.1-systemd "Toolchain Technical Notes", <https://www.linuxfromscratch.org/lfs/view/stable-systemd/partintro/toolchaintechnotes.html> | `code/docs/BUILD.md` — Section 1 | — |
| 04 ELF, static and shared libraries, sonames, the loader | `man 8 ld.so`, `man 1 ld` (`-soname`), `man 5 elf`, `man 1 readelf` (binutils 2.42, glibc 2.39); Drepper, "How To Write Shared Libraries" (10/12/2011), <https://akkadia.org/drepper/dsohowto.pdf> | `code/docs/BUILD.md` — Sections 1 and 4; `code/docs/C-CODING-PRINCIPLES.md` — Section 2 | `code/src/c/msNNN-shared-library/` (planned) |
| 05 What makes a distribution independent | ArchWiki "Arch Linux", <https://wiki.archlinux.org/title/Arch_Linux>; Alpine "Apk spec", <https://wiki.alpinelinux.org/wiki/Apk_spec>; Void Handbook "About", <https://docs.voidlinux.org/about/index.html>; Gentoo "Portage", <https://wiki.gentoo.org/wiki/Portage> | — | — |
| 06 Borrowing ideas without deriving | Dolstra, "The Purely Functional Software Deployment Model" (2006), <https://edolstra.github.io/pubs/phd-thesis.pdf>; NixOS Manual 26.05, <https://nixos.org/manual/nixos/stable/> | — | — |
