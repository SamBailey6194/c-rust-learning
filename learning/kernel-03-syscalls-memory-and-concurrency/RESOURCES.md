# Resources — kernel-03-syscalls-memory-and-concurrency

| Lesson | Primary source (pinned) | House guide | Code |
| --- | --- | --- | --- |
| 01 The system call boundary with strace | `man 2 syscall`; `man 2 syscalls`; `man 1 strace` (strace 6.8) | `code/docs/C-CODING-PRINCIPLES.md` — 3. Error handling (`errno`) | — |
| 02 function_graph tracing in the guest | <https://docs.kernel.org/trace/ftrace.html> (The File System; The Tracers; docs build 7.3.0-rc4); kernel/trace/Kconfig at v7.2 | `code/docs/DEBUGGING.md` — 6. The kernel under QEMU and gdb | — |
| 03 Virtual memory and the page cache | <https://docs.kernel.org/admin-guide/mm/concepts.html>; <https://docs.kernel.org/mm/page_tables.html>; `man 2 mmap`; `man 1 time` | `code/docs/MEMORY-SAFETY.md` — 3. Who owns an allocation | `code/src/c/msNNN-mmap-faults/` (planned — created by the milestone that specifies it) |
| 04 Allocation contexts and GFP flags | <https://docs.kernel.org/core-api/memory-allocation.html>; <https://docs.kernel.org/dev-tools/kmemleak.html> | `code/docs/MEMORY-SAFETY.md` — 4. The tools | `code/src/kernel/msNNN-misc-device/` (planned — added at P4) |
| 05 Kernel lists and reference counting | <https://docs.kernel.org/core-api/list.html>; <https://docs.kernel.org/core-api/kref.html> (Kref rules); include/linux/refcount.h at v7.2 | — | `code/src/kernel/msNNN-misc-device/` (planned — added at P4) |
| 06 Spinlocks, mutexes, atomics and RCU | <https://docs.kernel.org/kernel-hacking/locking.html>; <https://docs.kernel.org/RCU/whatisRCU.html> (2. What is RCU's core API?) | — | `code/src/kernel/msNNN-misc-device/` (planned — added at P4) |
| 07 Finding a locking bug with lockdep | <https://docs.kernel.org/locking/lockdep-design.html>; lib/Kconfig.debug at v7.2 (PROVE_LOCKING) | `code/docs/DEBUGGING.md` — 6. The kernel under QEMU and gdb | `code/src/kernel/msNNN-lockdep-demo/` (planned — added at P4) |
