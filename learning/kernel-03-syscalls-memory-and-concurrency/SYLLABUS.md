# Syllabus — kernel-03-syscalls-memory-and-concurrency

**Track**: kernel · **Phase**: P4 · **Path**: Core · **Detail**: full · **Prerequisites**: kernel-02-modules (all lessons); P2 (threads and `mmap`)
**Status**: Planned · **Checked**: 27/09/2026 (sources re-verified by `/teach` step 3 before each lesson)

What happens on the far side of a system call: Sam follows one call from user space into the kernel, then learns the
kernel's view of memory — pages, page tables, page faults and the page cache — how kernel code allocates memory in the
right context, the kernel's lists and reference counts, and its locks, ending with lockdep finding a locking bug in
the QEMU guest. It turns the misc device from kernel-02-modules into a small concurrent, reference-counted driver, and
it gives the rest of the mission its vocabulary: the Syntek OS lessons on init, packages and isolation, and the LLM
lessons on memory-mapped model files and the page cache (llm-15-efficient-inference), all lean on it. It covers the
P4 topics "kernel data structures" and "system calls" in `project-management/src/01-ROADMAP/ROADMAP.md`.

Version pins for this syllabus: docs.kernel.org pages were read on 27/09/2026 (documentation build 7.3.0-rc4);
kernel-tree files are cited at tag v7.2; the host runs strace 6.8.

| # | Lesson | Size | Build | Lenses |
| --- | --- | --- | --- | --- |
| 01 | The system call boundary, seen from user space with strace | 1 sitting | no | — |
| 02 | The same call inside the kernel with ftrace's function_graph tracer | 1 sitting | no | Safety |
| 03 | Virtual memory: pages, page tables, page faults and the page cache | 2–3 sittings | yes — page-fault counter | Efficiency |
| 04 | Allocation contexts: kmalloc, vmalloc, slab caches and GFP flags | 2–3 sittings | yes — misc device buffer | Security, Safety |
| 05 | Kernel lists and reference counting | 2–3 sittings | yes — misc device records | Safety |
| 06 | Spinlocks, mutexes, atomics and RCU | 2–3 sittings | yes — concurrent misc device | Safety |
| 07 | Finding a locking bug with lockdep | 1 sitting | yes — lock-order bug | Safety |

---

## 01 — The system call boundary, seen from user space with strace

- **Objective:** Sam can trace a program's system calls, read strace's output, and say how an x86-64 program asks the
  kernel for a service.
- **Builds on:** P2 POSIX system calls, file I/O and `errno`; the P2 shell project as a program worth tracing.
- **Key ideas:**
  - On x86-64 a program puts the call number in `rax` and up to six arguments in `rdi`, `rsi`, `rdx`, `r10`, `r8` and
    `r9`, executes the `syscall` instruction, and finds the result in `rax`.
  - The C library wrapper turns a negative kernel return into `-1` plus `errno`; strace shows both sides.
  - `strace -f` follows children, `-e trace=` filters by call or class, and `-c` counts calls and time.
  - strace runs Sam's own program on the host as his user; nothing here needs privilege.
- **Recall targets:** which register carries what for a given call; how a kernel error return becomes `errno`; which
  calls a simple `cat` of a file makes, predicted before tracing.
- **Build:** none — Sam traces a program from P2 and annotates the trace in the lesson note.
- **Sources:** `man 2 syscall` (the architecture calling-convention tables); `man 2 syscalls`; `man 1 strace`
  (strace 6.8 on the host); "Adding a New System Call" (<https://docs.kernel.org/process/adding-syscalls.html>) as
  reading on how calls are defined.
- **Done when:** Sam predicts, then confirms with strace, the calls and return values of a small program, including
  one failing call and its `errno`.

## 02 — The same call inside the kernel with ftrace's function_graph tracer

- **Objective:** Sam can trace the kernel functions one system call runs through, inside the QEMU guest.
- **Builds on:** lesson 01; kernel-01-build-and-boot-in-qemu lessons 03–06 (a config fragment and the boot harness).
- **Key ideas:**
  - ftrace is controlled through the tracefs filesystem, mounted at `/sys/kernel/tracing`.
  - Writing `function_graph` to `current_tracer` records entry, exit and duration of each kernel function;
    `set_graph_function` narrows it to one entry point, and `set_ftrace_pid` to one process.
  - `available_filter_functions` lists what can be traced, which is how the call's entry function is found.
  - `CONFIG_FUNCTION_GRAPH_TRACER` depends on `CONFIG_FUNCTION_TRACER`; both go in the QEMU config fragment.
  - The kernel's threat model treats tracing as an administrator's facility — fine as root in a guest, not something
    to open to users.
- **Recall targets:** which tracefs files set up a function-graph trace of one call; what the durations in the output
  mean; why the trace is taken in the guest.
- **Build:** none — the tracing options join the kernel-01 QEMU fragment, and the captured trace is annotated in the
  lesson note.
- **Safety:** tracing runs in the QEMU guest only; the host's tracing stays closed.
- **Sources:** "ftrace - Function Tracer" (<https://docs.kernel.org/trace/ftrace.html>, "The File System" and "The
  Tracers"); kernel/trace/Kconfig at v7.2
  (<https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/plain/kernel/trace/Kconfig?h=v7.2>,
  FUNCTION_GRAPH_TRACER); "The Linux Kernel threat model" (<https://docs.kernel.org/process/threat-model.html>).
- **Done when:** a function-graph trace of one call from lesson 01 is captured in the guest, and Sam walks it from the
  entry point to the return.

## 03 — Virtual memory: pages, page tables, page faults and the page cache

- **Objective:** Sam can explain how a virtual address becomes a physical one, when a page fault happens, and what
  `mmap` of a file and of anonymous memory each do — and measure the faults.
- **Builds on:** lessons 01–02; P2 dynamic memory (`brk`, `mmap`) and file I/O.
- **Key ideas:**
  - Memory is managed in pages; page tables translate virtual to physical addresses through a hierarchy (Linux models
    five levels: PGD, P4D, PUD, PMD, PTE), and the TLB caches translations.
  - A page fault is the CPU finding no valid translation: a minor fault is fixed from memory, a major one needs I/O.
  - Anonymous memory reads map a shared zero page until the first write allocates a real page.
  - File data read or written goes through the page cache; dirty pages are written back later.
  - `mmap` of a file maps page-cache pages into the process (`MAP_SHARED` or `MAP_PRIVATE`); nothing is read until a
    page is touched.
- **Recall targets:** the steps of a translation; minor versus major fault; what the first read and the first write to
  an anonymous mapping each cost; what a second read of the same file skips.
- **Build:** a small user-space C program that maps a file and an anonymous region and touches them in a chosen
  pattern, in `code/src/c/msNNN-mmap-faults/` (planned — created by the milestone that specifies it; a C exercise
  under the P1 build contract, so CI compiles it). Checked by its tests under `make test`, `make san` and
  `make memcheck`, and by fault counts matching Sam's prediction.
- **Efficiency lens:** count minor and major faults with `/usr/bin/time -v` for a first and a repeated run, and relate
  the difference to the page cache — the arithmetic llm-15-efficient-inference reuses for memory-mapped model files.
- **Sources:** "Concepts overview" (<https://docs.kernel.org/admin-guide/mm/concepts.html>, "Virtual Memory Primer",
  "Page cache" and "Anonymous Memory"); "Page Tables" (<https://docs.kernel.org/mm/page_tables.html>); `man 2 mmap`;
  `man 2 mincore`; `man 1 time`.
- **Done when:** the exercise passes its gates, and the measured faults match Sam's written prediction or the
  difference is explained.

## 04 — Allocation contexts: kmalloc, vmalloc, slab caches and GFP flags

- **Objective:** Sam can choose the right kernel allocator and GFP flags for a given size and calling context, and
  free each allocation with its matching call.
- **Builds on:** lesson 03; kernel-02-modules lessons 03 and 06 (error paths; the misc device).
- **Key ideas:**
  - `kmalloc`/`kzalloc` for small, physically contiguous objects; `vmalloc` for large, only virtually contiguous
    areas; `kvmalloc` tries the first and falls back to the second; `kmem_cache_create` for many identical objects.
  - `GFP_KERNEL` may sleep to reclaim memory, so it is for contexts that can sleep; atomic context uses `GFP_NOWAIT`,
    and `GFP_ATOMIC` when dipping into reserves is justified.
  - Allocations triggered by untrusted user space are accounted to it with `__GFP_ACCOUNT` (`GFP_KERNEL_ACCOUNT`).
  - Every allocator has its matching free (`kfree`, `vfree`, `kvfree`, `kmem_cache_free`); a failed allocation is
    checked, not assumed away.
  - kmemleak, enabled in a debug config, reports orphaned kernel allocations much as valgrind's leak check does in
    user space.
- **Recall targets:** which allocator fits a given size and use; which GFP flag fits a given context; what "sleeping
  function called from invalid context" means.
- **Build:** the kernel-02 misc device keeps each write in a buffer it allocates, sized from the request with an upper
  bound, in `code/src/kernel/msNNN-misc-device/` (planned — added at P4). Checked in the guest by the user-space test
  plus a kmemleak scan after unload that reports nothing.
- **Security lens:** user-controlled sizes are bounded before allocation and accounted to the caller, so user space
  cannot exhaust kernel memory through the device.
- **Safety:** the debug kernel and the module run in QEMU only.
- **Sources:** "Memory Allocation Guide" (<https://docs.kernel.org/core-api/memory-allocation.html>, "Get Free Page
  flags", "GFP flags and reclaim behavior" and "Selecting memory allocator"); "Kernel Memory Leak Detector"
  (<https://docs.kernel.org/dev-tools/kmemleak.html>); "Unreliable Guide To Hacking The Linux Kernel"
  (<https://docs.kernel.org/kernel-hacking/hacking.html>, "kmalloc()/kfree()").
- **Done when:** the device passes its tests with bounded allocations, kmemleak is clean after unload, and Sam
  justifies each GFP flag he used.

## 05 — Kernel lists and reference counting

- **Objective:** Sam can keep a set of kernel objects on a `list_head` list and manage each object's lifetime with a
  `kref`.
- **Builds on:** lesson 04; P2 data structures (linked lists with written-down ownership); `container_of` as pointer
  arithmetic from P1.
- **Key ideas:**
  - The kernel's list is circular and doubly linked, and the `list_head` is embedded in the object, not the other way
    round; `container_of` gets from the link back to the object.
  - `list_add`, `list_del` and `list_for_each_entry` (and its `_safe` form when deleting while walking) are the core.
  - A `kref` counts references: `kref_init` on creation, `kref_get` before handing a pointer on, `kref_put` with a
    release function that frees the object on the last put.
  - Taking a new reference without already holding one needs a lock (or RCU) so the object cannot be released in
    between; `refcount_t`, under `kref`, saturates rather than wrapping.
- **Recall targets:** how `container_of` finds the object; when deletion during a walk needs the safe iterator; which
  kref rule applies when a pointer is passed to another thread.
- **Build:** the misc device keeps one reference-counted record per open file on a list, in
  `code/src/kernel/msNNN-misc-device/` (planned — added at P4). Checked in the guest by opening and closing the device
  from the test program in different orders, with kmemleak clean afterwards.
- **Safety:** QEMU only.
- **Sources:** "Linked Lists in Linux" (<https://docs.kernel.org/core-api/list.html>); "Adding reference counters
  (krefs) to kernel objects" (<https://docs.kernel.org/core-api/kref.html>, "Kref rules"); "refcount_t API compared to
  atomic_t" (<https://docs.kernel.org/core-api/refcount-vs-atomic.html>); the tree's include/linux/refcount.h at v7.2
  (<https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/plain/include/linux/refcount.h?h=v7.2>,
  "Saturation semantics").
- **Done when:** every order of open and close leaves no leak, and Sam explains each `kref_get` and `kref_put` in his
  code.

## 06 — Spinlocks, mutexes, atomics and RCU

- **Objective:** Sam can choose between a spinlock, a mutex, an atomic and RCU for a given piece of shared kernel
  data, and make the misc device safe for concurrent users.
- **Builds on:** lessons 04–05; P2 threads (POSIX mutexes and condition variables; ThreadSanitizer).
- **Key ideas:**
  - A spinlock is a small single-holder lock that busy-waits; nothing that can sleep runs while one is held, and it is
    held for a few lines at most.
  - A mutex may sleep while waiting, so it is only for contexts that can sleep; `mutex_lock_interruptible` returns
    when a signal arrives.
  - When data is shared with interrupt or softirq context, the `_irqsave` or `_bh` spinlock variants are needed.
  - Atomics (and `refcount_t` for counts) cover single values without a lock.
  - RCU lets readers run without taking a lock while an updater publishes a new version and waits for a grace period
    (`synchronize_rcu` or `call_rcu`) before freeing the old one.
- **Recall targets:** which lock fits a given context; why sleeping under a spinlock is a bug; what an RCU grace period
  waits for.
- **Build:** the misc device protects its list and records for many concurrent openers, and a multithreaded
  user-space test hammers it from the guest, in `code/src/kernel/msNNN-misc-device/` (planned — added at P4). Checked
  by the test passing repeatedly on a guest with several virtual CPUs and a debug config with
  `CONFIG_DEBUG_ATOMIC_SLEEP` quiet.
- **Safety:** QEMU only.
- **Sources:** "Unreliable Guide To Locking" (<https://docs.kernel.org/kernel-hacking/locking.html>, "Two Main Types
  of Kernel Locks: Spinlocks and Mutexes" and "Cheat Sheet For Locking"); "Locking lessons"
  (<https://docs.kernel.org/locking/spinlocks.html>); "Generic Mutex Subsystem"
  (<https://docs.kernel.org/locking/mutex-design.html>); "What is RCU? — Read, Copy, Update"
  (<https://docs.kernel.org/RCU/whatisRCU.html>, 2. What is RCU's core API?); lib/Kconfig.debug at v7.2
  (<https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/plain/lib/Kconfig.debug?h=v7.2>,
  DEBUG_ATOMIC_SLEEP).
- **Done when:** the concurrent test passes repeatedly with the debug checks quiet, and Sam justifies each lock choice.

## 07 — Finding a locking bug with lockdep

- **Objective:** Sam can enable lockdep in a QEMU kernel, provoke a report with a deliberate lock-order inversion, and
  read the report back to the two code paths that cause it.
- **Builds on:** lesson 06.
- **Key ideas:**
  - `CONFIG_PROVE_LOCKING` (which selects `CONFIG_LOCKDEP`) checks locking rules as they happen, not only when a
    deadlock actually occurs.
  - Lockdep reasons about lock classes — every lock of the same kind counts as one class — and records the order in
    which classes are taken.
  - Taking A then B on one path and B then A on another forms a cycle that lockdep reports as a possible deadlock; a
    lock used in interrupt context but taken elsewhere with interrupts enabled is reported too.
  - Loading and unloading a module repeatedly leaks lock classes, so the guest is rebooted between experiments.
- **Recall targets:** what lockdep proves and what it cannot; how to read a report back to the two acquisition paths;
  the fix for an inversion.
- **Build:** a small module with two locks taken in opposite orders on two paths, in
  `code/src/kernel/msNNN-lockdep-demo/` (planned — added at P4). Checked by lockdep's report in the guest, then by the
  corrected ordering running quiet.
- **Safety:** a deliberately buggy module runs in QEMU only.
- **Sources:** "Runtime locking correctness validator" (<https://docs.kernel.org/locking/lockdep-design.html>,
  "Lock-class", "Single-lock state rules" and "Multi-lock dependency rules"); lib/Kconfig.debug at v7.2
  (<https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/plain/lib/Kconfig.debug?h=v7.2>,
  PROVE_LOCKING).
- **Done when:** Sam reads the lockdep report to the two paths without help, and the fixed module runs without a
  report.
