# Resources — sec-04-linux-security-model

| Lesson | Primary source (pinned) | House guide | Code |
| --- | --- | --- | --- |
| 01 Discretionary model | `man 7 credentials`; `man 2 setuid`; `man 2 execve` | — | `code/src/c/msNNN-<kebab>/` (planned) |
| 02 Capabilities | `man 7 capabilities`; <https://man7.org/linux/man-pages/man7/capabilities.7.html> | — | `code/src/c/msNNN-<kebab>/` (planned) |
| 03 Namespaces | `man 7 namespaces`; `man 2 unshare`; `man 7 user_namespaces` | — | `code/src/c/msNNN-<kebab>/` (planned) |
| 04 cgroups v2 | `man 7 cgroups`; kernel cgroup v2, <https://docs.kernel.org/admin-guide/cgroup-v2.html> | — | `code/src/c/msNNN-<kebab>/` (planned) |
| 05 seccomp | `man 2 seccomp`; kernel seccomp filter, <https://docs.kernel.org/userspace-api/seccomp_filter.html> | — | `code/src/c/msNNN-<kebab>/` (planned) |
| 06 MAC: AppArmor, SELinux, Landlock | kernel LSM index, <https://docs.kernel.org/admin-guide/LSM/index.html>; kernel Landlock, <https://docs.kernel.org/userspace-api/landlock.html> | — | `code/src/rust/crates/msNNN_<snake>/` (planned) |
| 07 Sandbox launcher | `man 7 namespaces`; `man 2 seccomp`; kernel Landlock, <https://docs.kernel.org/userspace-api/landlock.html>; auditd, <https://www.man7.org/linux/man-pages/man8/auditd.8.html> | `code/docs/FFI.md` (unsafe boundary) | `code/src/rust/crates/msNNN_<snake>/` (planned); the production launcher in the sandbox-launcher repository (created when that build starts) |
