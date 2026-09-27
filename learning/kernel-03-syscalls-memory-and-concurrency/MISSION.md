# Mission — kernel-03-syscalls-memory-and-concurrency

**Started**: not yet · **Family**: kernel · **Phase**: P4 · **Milestone**: not yet allocated

## Why

_Drafted from Sam's planning conversation of 27/09/2026 — confirm or rewrite in your own words at the first lesson._

Sam's route runs from C through system calls to the kernel proper, and in the same conversation he asked whether C and
Rust could make a language model read memory more efficiently. The answer tied the two together: paging, `mmap` and
the page cache — kernel ideas — are exactly what efficient model loading and a KV cache borrow. This topic is where Sam
learns how the kernel itself handles memory and shared data: what a system call really does, how pages and faults
work, how kernel code allocates in the right context, and how it keeps concurrent users from corrupting each other.
It is also the core-kernel knowledge a downstream maintainer needs to read the patches he carries.

## Can do it when

- Trace a system call from user space with strace and through the kernel with ftrace's function_graph tracer.
- Explain pages, page tables, minor and major faults and the page cache, and predict the faults a small program makes.
- Choose the right kernel allocator and GFP flags for a size and a context, with kmemleak clean afterwards.
- Keep kernel objects on a `list_head` list with `kref` lifetimes and no leaks.
- Choose between a spinlock, a mutex, an atomic and RCU, and make a driver safe for concurrent users.
- Provoke, read and fix a lockdep report in the QEMU guest.

## Parked for later

- The scheduler, workqueues and interrupt handling in depth → not planned yet; `DEFERRED.md` if a milestone needs them.
- Memory-mapped model loading and KV-cache paging → llm-15-efficient-inference.
- Namespaces, cgroups and seccomp from the kernel's side → sec-04-linux-security-model.
- Lock-free data structures and memory barriers beyond RCU's API → not planned yet.
