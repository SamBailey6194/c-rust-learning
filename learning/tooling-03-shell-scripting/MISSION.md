# Mission — tooling-03-shell-scripting

**Started**: not yet · **Family**: tooling · **Phase**: P1 · **Milestone**: not yet allocated

## Why

_Drafted from Sam's planning conversation of 27/09/2026 — confirm or rewrite in your own words at
the first lesson._

Sam asked how easy it would be to learn C "to build my own Linux distro off the kernel", and later
said plainly: "I want a clean distro" — built from scratch, not derived from another one. Most of
that work is integration rather than new C: configuring and building kernels, bootstrapping a
toolchain, and turning the Linux From Scratch book into build recipes, all driven from the shell.
This repository's own gates are already bash scripts, and every later track leans on them. Shell
that quotes correctly, fails loudly, reports "could not run" honestly and cleans up after itself is
the foundation under the kernel, Syntek OS and the build farm that will follow.

## Can do it when

- Sam can predict how many arguments a quoted and an unquoted expansion produce, including `"$@"`
  against `"$*"`.
- Sam can say whether a `set -euo pipefail` script stops for a failure in a given position, and
  name the rule that decides it.
- Sam can write a function with local variables that passes a list of paths through an array
  without splitting any of them.
- Sam can route standard output and standard error deliberately and choose an expanding or a
  literal here-document.
- Sam can make a script remove its temporary files on success, on failure and on Ctrl-C.
- Sam can say whether a script needs bash or runs under POSIX sh, and choose its shebang on purpose.
- Sam can read a ShellCheck finding and fix it at the cause.
- `verify.sh` for one C exercise passes its four checks and CI's `Syntax — Shell` is green.

## Parked for later

- make and the C build itself — the reserved `tooling-01` topic.
- A BusyBox `/init` script for an initramfs — `kernel-01`, then `os-06`.
- Build recipes and reproducible builds — `os-05`.
- Confining a script with namespaces, seccomp or Landlock — `sec-04`.
