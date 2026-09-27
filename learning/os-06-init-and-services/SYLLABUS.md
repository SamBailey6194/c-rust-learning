# Syllabus — os-06-init-and-services

**Track**: os · **Phase**: P6 · **Path**: Core · **Detail**: full · **Prerequisites**: os-04 (a booted LFS system under systemd); P2 (processes, signals, `fork`/`exec`/`wait`); kernel-01 lessons 05–06 (the initramfs and the QEMU boot harness); sec-04 lesson 04 (cgroups v2)
**Status**: Planned · **Checked**: 27/09/2026 (sources re-verified by `/teach` step 3 before each lesson)

What runs as PID 1 decides how a Syntek OS profile boots, supervises its services and shuts down. This topic teaches
the duties of PID 1, has Sam write a minimal init in C and boot it in kernel-01's initramfs-plus-QEMU harness (both
syllabi say so), surveys systemd, runit, s6 and OpenRC against what each profile needs, and then builds supervision,
logging and shutdown on top. The learning build follows the LFS 13.1 systemd book; **Syntek OS's own init is chosen
later by an ADR fed by the INIT-SYSTEM-CHOICE research note** (planned — `research/INIT-SYSTEM-CHOICE.md`), and the
choice is parked in `DEFERRED.md` until then. The C code here is a small exercise in this repository; it is not a
candidate for Syntek OS's init.

| # | Lesson | Size | Build | Lenses |
| --- | --- | --- | --- | --- |
| 01 | What PID 1 owes the system | 1 sitting | no | Safety |
| 02 | A minimal init in C | multi-session build | yes — minimal-init | Security, Safety |
| 03 | Init systems, and what each profile needs from one | 2–3 sittings | no | Security |
| 04 | Supervision, dependencies and cgroups | 2–3 sittings | yes — supervisor | Efficiency, Security |
| 05 | Logging and shutdown | 2–3 sittings | yes — clean shutdown | Safety |

---

## 01 — What PID 1 owes the system

- **Objective:** Sam can list the duties of PID 1 — reaping orphans, handling signals, never exiting — explain what
  happens when each is neglected, and say how the kernel finds the program to run.
- **Builds on:** P2 processes and signals; os-01 lesson 01 (the boot chain); kernel-01 lesson 05 (`/init` in an
  initramfs).
- **Key ideas:**
  - A child that exits stays a zombie until its parent waits for it; orphans are re-parented to init (or the nearest
    subreaper), and init must wait for them or the process table fills.
  - PID 1 receives only the signals it has installed handlers for — the kernel protects it from accidental kills.
  - If PID 1 exits, the kernel panics ("Attempted to kill init!" in `kernel/exit.c`).
  - The kernel runs `/init` from an initramfs (or `rdinit=`), else `init=`, else tries `/sbin/init`, `/etc/init`,
    `/bin/init` and `/bin/sh` in turn; when none runs it panics with "No working init found".
  - The same rules apply to the first process of a PID namespace, which makes an unprivileged test of init code on
    the host possible (on this host, `unshare --user --map-root-user --pid --fork --mount-proc`, checked 27/09/2026).
- **Recall targets:** each duty and the failure when it is skipped; what `PR_SET_CHILD_SUBREAPER` changes; where the
  kernel looks for init.
- **Build:** none — Sam predicts, then observes in kernel-01's harness, what `rdinit=/bin/sh` followed by `exit` does.
- **Safety:** observations run in QEMU or inside an unprivileged PID namespace; nothing replaces the host's PID 1.
- **Sources:** `man 2 wait` (NOTES, zombies and adoption), `man 2 kill` (NOTES, signals to PID 1), `man 2 prctl`
  (`PR_SET_CHILD_SUBREAPER`), `man 7 pid_namespaces` ("The namespace init process") — man-pages 6.7 on the host;
  `kernel/exit.c` at v7.2.8, the "Attempted to kill init!" panic
  (<https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/plain/kernel/exit.c?h=v7.2.8>); "Explaining the
  'No working init found.' boot hang message" (<https://docs.kernel.org/admin-guide/init.html>); "The kernel's
  command-line parameters", `init=` and `rdinit=` (<https://docs.kernel.org/admin-guide/kernel-parameters.html>);
  `init/main.c` at v7.2.8, the fallback list
  (<https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/plain/init/main.c?h=v7.2.8>).
- **Done when:** Sam predicts the panic before seeing it, and explains why a zombie-filled process table is PID 1's
  fault.

## 02 — A minimal init in C

- **Objective:** Sam can write a small, statically linked init in C that mounts the kernel's pseudo-filesystems,
  starts a shell or a getty, reaps every child, and survives the signals it should — and boot it in QEMU.
- **Builds on:** lesson 01; kernel-01 lessons 05–06 (the initramfs builder and QEMU boot script); P2 (`fork`,
  `execve`, `waitpid`, `sigaction`); `code/docs/C-CODING-PRINCIPLES.md` Section 3 (error handling).
- **Key ideas:**
  - The init mounts `/proc`, `/sys` and `/dev` (devtmpfs) itself before anything can rely on them.
  - It links statically, because an initramfs holds no shared libraries unless someone adds them — the kernel doc's
    "binary exists but dependencies not available" case.
  - Its main loop is a wait loop: reap any child, restart the shell or getty if that was the one that died.
  - It installs handlers only for the signals it means to act on, and never exits.
  - Keep the logic that can be tested (argument parsing, the restart decision) separate from the system calls that
    only make sense as PID 1.
- **Recall targets:** why static linking; the order of the first system calls and why; what the wait loop does when
  an orphan it never started exits.
- **Build:** `code/src/c/msNNN-minimal-init/` (planned code path), built by `make` and CI like every C exercise, and
  packed into kernel-01's initramfs harness (`code/src/kernel/msNNN-qemu-harness/`, planned — added at P4) for the
  boot test. Checked by the exercise's `make test`, `san` and `memcheck` on the testable parts; by a host-side run as
  PID 1 of an unprivileged PID namespace that shows orphans reaped (the mounts are skipped or expected to fail there);
  and by a QEMU boot log reaching the shell with the pseudo-filesystems mounted.
- **Security lens:** PID 1 runs as root with every capability — no parsing of untrusted input, and every system
  call's error checked.
- **Safety:** the init only ever runs as PID 1 inside QEMU or an unprivileged PID namespace — never as the host's PID 1.
- **Sources:** `man 2 mount`, `man 2 waitpid` (in `man 2 wait`), `man 2 sigaction`, `man 2 execve`,
  `man 7 pid_namespaces` (host); "Ramfs, rootfs and initramfs"
  (<https://docs.kernel.org/filesystems/ramfs-rootfs-initramfs.html>); "Explaining the 'No working init found.' boot
  hang message" (<https://docs.kernel.org/admin-guide/init.html>, "Binary exists but dependencies not available");
  GCC "Options for Linking" (<https://gcc.gnu.org/onlinedocs/gcc/Link-Options.html>, `-static`).
- **Done when:** the exercise passes its gates, the namespace run shows orphans reaped, and the QEMU boot reaches a
  shell through Sam's init.

## 03 — Init systems, and what each profile needs from one

- **Objective:** Sam can compare systemd, runit, s6 and OpenRC, map each Syntek OS profile's needs onto them, and
  write that comparison up as the INIT-SYSTEM-CHOICE research note.
- **Builds on:** lessons 01–02; os-04 lesson 03 (systemd in LFS).
- **Key ideas:**
  - systemd is a system and service manager that runs as PID 1 and also starts a manager per logged-in user; LFS 13.1
    is built around it.
  - runit runs as PID 1 in three stages — one-time start-up, `runsvdir` supervising services until shutdown, then
    shutdown.
  - s6 is a supervision suite (with s6-linux-init to run as PID 1); it starts from the observation that daemons die
    and should be restarted automatically.
  - OpenRC is a dependency-based service manager that works with the system's own `/sbin/init`.
  - Profiles need different things: the desktops need seats and sessions (`systemd-logind`, or elogind — logind
    extracted as a standalone package — without systemd); servers, NAS, homelab and routers need supervision above
    all.
- **Recall targets:** one defining trait of each init system; which profile needs logind or elogind and why; what
  "supervision" means that plain start-up scripts lack.
- **Build:** none in code — the output is the INIT-SYSTEM-CHOICE research note (planned —
  `research/INIT-SYSTEM-CHOICE.md`), written through `/research`, which feeds the later ADR. Checked by the note citing
  a primary source for every claim.
- **Security lens:** the init and service manager is the most privileged user-space code on the system — its size and
  attack surface are part of the comparison.
- **Sources:** `systemd(1)` from systemd 262 (<https://www.freedesktop.org/software/systemd/man/latest/systemd.html>);
  `systemd-logind.service(8)` (<https://www.freedesktop.org/software/systemd/man/latest/systemd-logind.service.html>);
  `runit(8)` (<https://smarden.org/runit/runit.8.html>) and runit (<https://smarden.org/runit/>); s6 overview
  (<https://skarnet.org/software/s6/overview.html>) and s6-linux-init (<https://skarnet.org/software/s6-linux-init/>);
  OpenRC (<https://github.com/OpenRC/openrc>, README); elogind (<https://github.com/elogind/elogind>, README).
- **Done when:** the research note exists with a per-profile table and cited claims, and Sam states which constraint
  (seats and sessions) rules options in or out for the desktop profiles.

## 04 — Supervision, dependencies and cgroups

- **Objective:** Sam can write a supervisor that restarts a failing service with backoff, starts services in
  dependency order once each reports ready, and contains a service's processes in a cgroup with a resource limit.
- **Builds on:** lessons 02–03; sec-04 lesson 04 (cgroups v2); os-05 lesson 02 (ordering a graph).
- **Key ideas:**
  - Supervision means the supervisor is the service's parent, so it learns of the exit at once and restarts it; a
    backoff stops a crash loop from eating the machine.
  - Ordering needs readiness, not just start-up: systemd's `sd_notify` `READY=1` and s6's notification file descriptor
    let a service say when it can actually serve.
  - A service can fork away from its supervisor's view of PIDs; a cgroup contains all of its processes, which is how
    systemd tracks and kills a service (`KillMode=control-group`).
  - cgroup v2's `memory.max` caps a service's memory, and `memory.events` counts OOM kills.
- **Recall targets:** why the supervisor must be the parent; readiness against start-up; what a cgroup adds that PID
  tracking lacks.
- **Build:** a supervisor in `code/src/c/msNNN-supervisor/` (planned code path) — or grown inside the minimal-init
  exercise — that runs a test service, restarts it with backoff, and orders two services by readiness. It needs no
  PID 1 and runs as an ordinary process. Checked by `make test`, `san` and `memcheck` (a crashing test service is
  restarted with growing delays; a dependant starts only after readiness), and by one run inside a delegated cgroup
  with `memory.max` set (on this host `systemd-run --user --scope -p MemoryMax=50M` works unprivileged, checked
  27/09/2026) showing the limit enforced.
- **Efficiency lens:** the memory limit and the restart backoff are budgets — measure a service's peak memory against
  its `memory.max` and the CPU a crash loop burns with and without backoff.
- **Security lens:** resource limits stop one runaway service from starving the rest; a service's cgroup is also what
  lets its supervisor kill every process it spawned.
- **Sources:** s6 overview, "Process supervision" (<https://skarnet.org/software/s6/overview.html>) and "Service
  startup notifications" (<https://skarnet.org/software/s6/notifywhenup.html>); `sd_notify(3)`, `READY=1`
  (<https://www.freedesktop.org/software/systemd/man/latest/sd_notify.html>); `systemd.kill(5)`, `KillMode=`
  (<https://www.freedesktop.org/software/systemd/man/latest/systemd.kill.html>); "Control Group v2", `memory.max` and
  `memory.events` (<https://docs.kernel.org/admin-guide/cgroup-v2.html>); `man 1 systemd-run`.
- **Done when:** the supervisor passes its gates, and the cgroup run shows the limit enforced and counted.

## 05 — Logging and shutdown

- **Objective:** Sam can route services' output to a log, and give his init an orderly shutdown — stop services, give
  them time, kill what remains, sync, unmount or remount read-only, then power off — proved in QEMU.
- **Builds on:** lessons 02 and 04.
- **Key ideas:**
  - A supervisor owns its services' standard output and error, so it can hand them to a logger (s6-log, journald)
    instead of letting them vanish.
  - Shutdown order: `SIGTERM` to services, a grace period, `SIGKILL` for what remains, `sync`, unmount or remount
    read-only, then `reboot(2)` — whose man page warns that data not synced first is lost.
  - runit's stage 3 and systemd's shutdown follow the same shape; the order exists so filesystems are clean on the
    next boot.
  - `reboot(2)` called inside a PID namespace only ends that namespace's init, which makes the last step testable on
    the host.
- **Recall targets:** the shutdown steps in order and what each prevents; why the grace period; what `reboot(2)` does
  inside a PID namespace.
- **Build:** add logging and an orderly shutdown to the minimal-init exercise. Checked by `make test`, `san` and
  `memcheck` on the shutdown sequencing, an unprivileged PID-namespace run whose `reboot(2)` ends only the namespace,
  and a QEMU run in kernel-01's harness where the guest powers itself off and QEMU exits by itself.
- **Safety:** `reboot(2)` is only ever called by the exercise inside QEMU or a PID namespace.
- **Sources:** `man 2 reboot` ("Behavior inside PID namespaces", `RB_POWER_OFF`), `man 2 sync`,
  `man 7 pid_namespaces` (host); `runit(8)`, "STAGE 3" (<https://smarden.org/runit/runit.8.html>);
  `systemd-journald.service(8)`
  (<https://www.freedesktop.org/software/systemd/man/latest/systemd-journald.service.html>);
  LFS 13.1-systemd Section 9.10.7 "Working with the Systemd Journal"
  (<https://www.linuxfromscratch.org/lfs/view/stable-systemd/chapter09/systemd-custom.html>).
- **Done when:** the gates pass, the namespace test shows `reboot(2)` ending only the namespace, and the QEMU guest
  powers off cleanly under Sam's init.
