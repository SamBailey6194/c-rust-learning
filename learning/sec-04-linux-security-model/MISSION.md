# Mission — sec-04-linux-security-model

**Started**: not yet · **Family**: sec · **Phase**: S1 · **Milestone**: not yet allocated

## Why

_Drafted from Sam's planning conversation of 27/09/2026 — confirm or rewrite in your own words at
the first lesson._

Sam is building an independent OS with server, homelab, NAS and router profiles, and a language
model whose brief is to be secure and to run skill scripts and generated code safely. All of that
rests on the kernel's own access-control machinery: users and permissions, capabilities, namespaces,
cgroups, seccomp and the LSMs. This topic teaches those primitives and ends by composing them into a
single least-privilege sandbox — the boundary the LLM's generated-code evaluation, the skill loader,
the build system's isolation and the TUI's privileged-helper separation all reuse. It is where "run
it, but safely" stops being a hope and becomes a mechanism Sam can build and test.

## Can do it when

- Sam can explain the discretionary model (UID/GID, permissions, setuid) and capabilities, and read
  a process's IDs and capability sets.
- Sam can say what each namespace isolates and set a cgroup resource limit.
- Sam can write a seccomp filter and a Landlock ruleset that restrict a process.
- Sam can compose these into a sandbox launcher that runs a test program with network and
  out-of-scope file access provably denied.

## Parked for later

- Applied cryptography (signatures, key management) — `sec-05`.
- Privilege-escalation techniques against misconfigured systems — `sec-09`, lab only.
- Runtime and kernel integrity (IMA/EVM, eBPF monitoring) — a later S3 topic.
