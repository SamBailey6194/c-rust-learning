# Syllabus — os-17-local-model-integration

**Track**: os · **Phase**: P6 · **Path**: Later · **Detail**: outline · **Prerequisites**: `os-12-homelab-edition`; `os-08-repositories-signing-and-updates`; `os-06-init-and-services`; `llm-16-skills-layer` (the skill format and the Rust loader); `llm-18-secure-llm-systems` lesson 04 (a per-skill sandbox policy); through them `llm-14-inference-in-rust`, `llm-15-efficient-inference` and `sec-04-linux-security-model` lessons 04, 06 and 07 (cgroups v2, Landlock, the sandbox launcher); `llm-06-cpu-performance-in-c` lesson 01 (measuring honestly)
**Status**: Planned · **Checked**: 27/09/2026 (sources re-verified by `/teach` step 3 before each lesson)

This is where the Syntek OS and LLM tracks meet: a Syntek OS machine that runs Sam's own efficient
local model, with its skills built in. The topic packages the Rust inference server with the build
system, ships the model file as a signed package, runs the server as a supervised service inside a
memory budget, ships skills as a package with a per-skill Landlock policy, gives it a TUI, and
measures the whole on the server edition in QEMU. It is an **outline** and **Later**: it opens only
after the L5 skills and security topics, when the model, the inference server and the skill loader
exist, so each lesson names its objective, key ideas and the sources to re-verify, and its Build
sketch is written when the topic opens. A QEMU guest gets no GPU here: this machine's RTX 2080 Ti
also drives the desktop, so the guest runs the CPU path, or the model runs on the host as a
documented exception. The work lands in the Syntek OS build-system repository (the recipes, packages and
service units), the inference repository (the server and the skill loader) and the Syntek OS system-tools
repository (the TUI), each created when its build starts.

| # | Lesson | Size | Build | Lenses |
| --- | --- | --- | --- | --- |
| 01 | A build-system recipe for the Rust inference server | 2–3 sittings | yes — sketched at topic open | Efficiency, Security |
| 02 | The model file as a signed, large package | 2–3 sittings | yes — sketched at topic open | Efficiency, Security |
| 03 | Running the model as a supervised service within a memory budget | 2–3 sittings | yes — sketched at topic open | Efficiency, Security |
| 04 | Skills as a package with a per-skill Landlock policy | 2–3 sittings | yes — sketched at topic open | Security |
| 05 | A TUI front-end for the local model | 2–3 sittings | yes — sketched at topic open | — |
| 06 | Measuring the resource budget on the server edition in QEMU | 2–3 sittings | yes — sketched at topic open | Efficiency, Safety |

---

## 01 — A build-system recipe for the Rust inference server

- **Objective:** Sam can write a recipe that builds the inference server from pinned sources,
  offline and reproducibly, with its licence exceptions recorded.
- **Builds on:** `os-05-build-system-and-reproducibility` lessons 01, 03 and 04 (recipes, isolated
  builds, reproducible builds);
  `llm-14-inference-in-rust` (the server).
- **Key ideas:**
  - A Rust recipe fetches every crate before the build and builds without network access, from a
    lock file.
  - Reproducibility applies to the server binary as to any package (`os-05`).
  - Crate licences: this learning repository admits Apache-2.0-only crates only by documented
    per-crate exceptions
    (`project-management/src/08-DECISIONS/ADR-MS001-LLM-RUST-CRATE-LICENCES-27-09-2026.md`); a
    product repository chooses its own licence and repeats the check there.
- **Recall targets:** why the build runs offline; where a licence exception is recorded.
- **Build:** sketched when this topic opens (Detail: outline).
- **Efficiency lens:** build time and binary size.
- **Security lens:** a recipe that fetches at build time is a supply-chain hole.
- **Sources:** (to re-verify at topic open) SOURCE_DATE_EPOCH,
  <https://reproducible-builds.org/docs/source-date-epoch/>; the crate-licence ADR above.
- **Done when:** the recipe builds the server twice with identical output, offline.

## 02 — The model file as a signed, large package

- **Objective:** Sam can ship a multi-gigabyte model file as a Syntek OS package that is signed,
  verified before it is loaded, mirrored and budgeted on disk.
- **Builds on:** `os-07-package-manager` lesson 02 (package format); `os-08-repositories-signing-and-updates`
  (signing and mirrors); `llm-15-efficient-inference` lesson 04 (mmap loading).
- **Key ideas:**
  - The model file is a tensor format meant for safe loading — safetensors, or GGUF for llama.cpp,
    which is designed for mmap loading — never a pickle (`.claude/CLAUDE.md` Section 5, weights).
  - A detached signature (minisign, Ed25519) and a checksum are verified before the server maps the
    file.
  - Large packages change the mirror and update design: resumable downloads, a disk budget, and not
    keeping two copies during an update without room for both.
- **Recall targets:** what is verified, and when, before loading; what a large file changes in
  updates.
- **Build:** sketched when this topic opens (Detail: outline).
- **Efficiency lens:** disk footprint and download size.
- **Security lens:** a tampered model is a poisoned model (`llm-18`).
- **Sources:** (to re-verify at topic open) GGUF specification (ggml, commit 353b63b),
  <https://github.com/ggml-org/ggml/blob/353b63b439f27ab2cc19dac97ab1681ba6d2d084/docs/gguf.md>;
  safetensors documentation, <https://huggingface.co/docs/safetensors/>; minisign,
  <https://jedisct1.github.io/minisign/>.
- **Done when:** a tampered model package is refused and a valid one installs within the disk budget.

## 03 — Running the model as a supervised service within a memory budget

- **Objective:** Sam can run the inference server as a supervised service under a cgroup memory
  limit, and state what happens when it exceeds it.
- **Builds on:** `os-06-init-and-services` lesson 04 (supervision and cgroups); `sec-04-linux-security-model` lesson 04
  (cgroups v2); `os-12-homelab-edition` lesson 04 (pressure and memory events).
- **Key ideas:**
  - `memory.max` is a hard limit — the OOM killer runs inside the cgroup if usage cannot be reclaimed
    — and `memory.peak` records the highest use.
  - The learning build expresses the limit with systemd's `MemoryMax=`; Syntek OS's own init, chosen
    later by ADR, must offer the same.
  - cgroup v2 tracks page cache as well as anonymous memory, charged to the cgroup that brought it in,
    so the pages of an mmapped model count towards the service's budget when the service first brings
    them in; pages cached by the verification step (lesson 02's checksum and signature pass) stay
    charged to its cgroup, so measure with the file dropped from the cache, or have the verifier use
    `POSIX_FADV_DONTNEED`.
  - VRAM is budgeted separately and read with `nvidia-smi` on the host.
- **Recall targets:** what `memory.max` does at the limit; when the mapped model counts against the
  service and when it does not; where the VRAM number comes from.
- **Build:** sketched when this topic opens (Detail: outline).
- **Efficiency lens:** peak memory and restart time against the budget.
- **Security lens:** the service runs unprivileged; limits also bound a denial of service.
- **Sources:** (to re-verify at topic open) docs.kernel.org, "Control Group v2" (`memory.max`,
  `memory.peak`), <https://docs.kernel.org/admin-guide/cgroup-v2.html> ("Memory Ownership" too);
  `man 5 systemd.resource-control` (systemd 255, `MemoryMax=`); `man 1 nvidia-smi`.
- **Done when:** the service holds its budget under load and restarts cleanly when pushed past it.

## 04 — Skills as a package with a per-skill Landlock policy

- **Objective:** Sam can package a set of skills so each one installs with its own Landlock policy,
  enforced by the loader when the skill runs.
- **Builds on:** `llm-16-skills-layer` lessons 02–04 (the skill file format, discovery, activation);
  `llm-18-secure-llm-systems` lesson 04 (a per-skill sandbox policy); `sec-04-linux-security-model`
  lessons 06–07 (Landlock, the sandbox launcher).
- **Key ideas:**
  - Landlock lets an unprivileged process restrict its own filesystem and network access; a skill's
    policy says what that skill may touch.
  - The policy ships inside the skill package, is signed with it, and is updated with it (`os-08`).
  - The loader applies the policy before the skill's script runs, through `sec-04`'s launcher.
- **Recall targets:** what Landlock restricts and who may apply it; where the policy lives and why.
- **Build:** sketched when this topic opens (Detail: outline).
- **Security lens:** excessive agency and prompt injection through skills (`llm-18`).
- **Sources:** (to re-verify at topic open) docs.kernel.org, "Landlock: unprivileged access control",
  <https://docs.kernel.org/userspace-api/landlock.html>; `man 7 landlock`.
- **Done when:** a skill that reaches outside its policy is denied, and the denial is logged.

## 05 — A TUI front-end for the local model

- **Objective:** Sam can build a terminal front-end that streams the model's answers and shows which
  skills were used.
- **Builds on:** `ui-03-tui-architecture-and-testing` (the Elm Architecture, background work, testing
  the rendered screen); lesson 03.
- **Key ideas:**
  - Streaming tokens is background work that must never block the render loop (`ui-03`).
  - The front-end talks to the service over a local interface and holds no model state.
  - Custom tools are Rust TUIs first
    (`project-management/src/08-DECISIONS/ADR-MS001-SYNTEK-OS-TOOLS-RUST-TUI-FIRST-27-09-2026.md`).
- **Recall targets:** why streaming belongs off the render loop; what the front-end must not hold.
- **Build:** sketched when this topic opens (Detail: outline).
- **Sources:** (to re-verify at topic open) ratatui documentation, <https://ratatui.rs/>.
- **Done when:** the TUI streams an answer and its screen tests pass.

## 06 — Measuring the resource budget on the server edition in QEMU

- **Objective:** Sam can measure the local model's resource budget on the server edition in QEMU and
  compare it with the `llm-01` baseline.
- **Builds on:** `llm-01-local-models-and-skills-baseline` lesson 03 (the baseline); `llm-06-cpu-performance-in-c`
  lesson 01 (measuring honestly); `os-10-profiles-and-installer` lesson 07 (the boot-test harness);
  lessons 01–05.
- **Key ideas:**
  - Measure tokens per second, load time, peak memory and disk on the CPU path in the guest, and say
    which path each number came from.
  - GPU passthrough (VFIO) would hand this machine's only GPU, which drives the desktop, to a guest,
    so it is out of scope; a GPU measurement runs on the host as a documented exception.
  - `perf` counters are locked on this host; the lesson shows Sam how to relax
    `kernel.perf_event_paranoid` for one session and restore it himself, and teaches the unprivileged
    fallback (`valgrind --tool=cachegrind`).
- **Recall targets:** which numbers make up the budget; why the guest has no GPU; the unprivileged
  fallback.
- **Build:** sketched when this topic opens (Detail: outline).
- **Efficiency lens:** the whole lesson.
- **Safety:** QEMU guest only; Claude never runs `sudo`.
- **Sources:** (to re-verify at topic open) docs.kernel.org, "VFIO - Virtual Function I/O",
  <https://docs.kernel.org/driver-api/vfio.html>; `man 1 qemu-system`; `man 1 nvidia-smi`.
- **Done when:** the budget is measured against the baseline and recorded in the milestone's
  verification record.
