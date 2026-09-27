# Resources — os-03-lfs-toolchain

| Lesson | Primary source (pinned) | House guide | Code |
| --- | --- | --- | --- |
| 01 Host requirements and a safe build environment | LFS 13.1-systemd Sections 2.2–2.6 and 4.3–4.5, <https://www.linuxfromscratch.org/lfs/view/stable-systemd/chapter02/hostreqs.html> | `how-to/docs/TOOLCHAIN.md` | — (the build VM lives outside the repository) |
| 02 Build, host and target triplets, and the sysroot | LFS 13.1-systemd "Toolchain Technical Notes", <https://www.linuxfromscratch.org/lfs/view/stable-systemd/partintro/toolchaintechnotes.html>; GCC "Installing GCC: Configuration", <https://gcc.gnu.org/install/configure.html> | — | — |
| 03 Reading an upstream build | Automake 1.16 manual Section 12.4 "Staged Installs" (`info automake`, host); Meson "Installing", <https://mesonbuild.com/Installing.html>; Ninja manual, <https://ninja-build.org/manual.html> | `code/docs/BUILD.md` — Sections 1 and 3 | — (build VM) |
| 04 The cross toolchain, pass 1 | LFS 13.1-systemd Chapter 5, Sections 5.2–5.6, <https://www.linuxfromscratch.org/lfs/view/stable-systemd/chapter05/introduction.html> | — | — (build VM) |
| 05 Temporary tools and host isolation | LFS 13.1-systemd Chapter 6, <https://www.linuxfromscratch.org/lfs/view/stable-systemd/chapter06/introduction.html>; `man 1 readelf` | — | — (build VM) |
| 06 Entering the chroot | LFS 13.1-systemd Sections 7.2–7.4 and 7.15, <https://www.linuxfromscratch.org/lfs/view/stable-systemd/chapter07/introduction.html>; `man 2 chroot` | — | — (build VM) |
