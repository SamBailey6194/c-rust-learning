# Resources — os-06-init-and-services

| Lesson | Primary source (pinned) | House guide | Code |
| --- | --- | --- | --- |
| 01 What PID 1 owes the system | `man 2 wait`, `man 2 kill`, `man 2 prctl`, `man 7 pid_namespaces` (man-pages 6.7); `kernel/exit.c` at v7.2.8, <https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/plain/kernel/exit.c?h=v7.2.8> | — | — |
| 02 A minimal init in C | `man 2 mount`, `man 2 sigaction`, `man 2 execve`; "Explaining the 'No working init found.' boot hang message", <https://docs.kernel.org/admin-guide/init.html> | `code/docs/C-CODING-PRINCIPLES.md` — Section 3; `code/docs/MEMORY-SAFETY.md` | `code/src/c/msNNN-minimal-init/` (planned); harness `code/src/kernel/msNNN-qemu-harness/` (planned — added at P4) |
| 03 Init systems and profile needs | `systemd(1)`, systemd 262, <https://www.freedesktop.org/software/systemd/man/latest/systemd.html>; `runit(8)`, <https://smarden.org/runit/runit.8.html>; s6 overview, <https://skarnet.org/software/s6/overview.html>; OpenRC, <https://github.com/OpenRC/openrc>; elogind, <https://github.com/elogind/elogind> | `research/CLAUDE.md` | — (`research/INIT-SYSTEM-CHOICE.md`, planned) |
| 04 Supervision, dependencies and cgroups | "Control Group v2", <https://docs.kernel.org/admin-guide/cgroup-v2.html>; `sd_notify(3)`, <https://www.freedesktop.org/software/systemd/man/latest/sd_notify.html>; s6 "Service startup notifications", <https://skarnet.org/software/s6/notifywhenup.html> | `code/docs/TESTING.md` — Section 1 | `code/src/c/msNNN-supervisor/` (planned) |
| 05 Logging and shutdown | `man 2 reboot`, `man 2 sync` (host); `runit(8)` "STAGE 3", <https://smarden.org/runit/runit.8.html> | `code/docs/DEBUGGING.md` — Section 6 | `code/src/c/msNNN-minimal-init/` (planned) |
