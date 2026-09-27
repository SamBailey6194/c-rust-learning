# Teach — What to Teach, by Family

**Last Updated**: 27/09/2026 | **Version**: 0.1.0 | **Maintained By**: Sam Bailey
**Language**: British English (en_GB) | **Timezone**: Europe/London

A sub-document of `.claude/skills/teach/SKILL.md`: for each of the eight families a lesson can
belong to, the phases it serves, the house guides it follows, the primary sources a `RESOURCES.md`
row cites, and the rules that bind it. The phases and their gates are owned by
`project-management/src/01-ROADMAP/ROADMAP.md`; the non-negotiables quoted here in brief are owned
by `.claude/CLAUDE.md` Section 5. Every link below was opened on 27/09/2026 unless its entry says
otherwise.

Locale: en_GB · Europe/London · dates DD/MM/YYYY.

**Where a lesson's build lands.** A small exercise lands under `code/src/` here, on the paths
`code/src/CLAUDE.md` → Output & naming numbers. Anything substantial (the downstream kernel tree,
the Syntek OS build system, package manager, installer and tools, the LLM data, training and
inference code) gets its own repository when its build starts; a Build sketch then names "the
<thing> repository (created when this build starts)". Names and licences of those repositories are
Sam's to choose; until he does, lessons use these placeholders and no others: the downstream kernel
repository; the Syntek OS build-system, package-manager, installer, system-tools, file-manager,
GUI-tools and web-dashboard repositories; the sandbox-launcher repository; and the model-training,
inference and model-release repositories. One more is private and holds no build: the private
infrastructure repository, created at the first graduation, where Sam's real network configuration
lives (`project-management/src/08-DECISIONS/ADR-MS001-NETWORK-LAB-FIRST-GRADUATION-PATH-27-09-2026.md`);
it is never published and carries no licence, and lessons name it but never link it, cite a path in
it or quote from it. **Until a topic's phase opens**, in any family, its lessons are reading, recall
and a note only, and its Builds wait for a milestone in that phase
(`.claude/skills/teach/SKILL.md` step 1 lists Sam's routes).

---

## c — the language and its memory model (P1–P2)

House guides: `code/docs/C-CODING-PRINCIPLES.md`, `code/docs/BUILD.md`, `code/docs/TESTING.md`,
`code/docs/MEMORY-SAFETY.md`, `code/docs/DEBUGGING.md`. Primary sources:

- The C standard. C17 is pinned
  (`project-management/src/08-DECISIONS/ADR-MS001-C-STANDARD-C17-27-09-2026.md`). Its ballot draft,
  WG14 N2176, is listed on open-std.org but served password-protected (checked 27/09/2026), so
  read [N2310](https://www.open-std.org/jtc1/sc22/wg14/www/docs/n2310.pdf) (the first C2x working
  draft, which marks its changes against the C17 text, ISO/IEC 9899:2018: the closest readable text
  to C17) or [N1570](https://www.open-std.org/jtc1/sc22/wg14/www/docs/n1570.pdf) (the C11
  committee draft; C17 fixed defects and added no features). For the C23 revisit,
  [N3096](https://www.open-std.org/jtc1/sc22/wg14/www/docs/n3096.pdf). Cite by draft and section:
  "N2310 Section 6.5.6"; an N1570 citation is fine where the section number is the same.
- Man pages: `man 3 <function>` (C library), `man 2 <syscall>`, `man 7 <overview>` such as
  `man 7 signal`. POSIX `3p` pages are not installed on the host (checked 27/09/2026).
- [cppreference's C pages](https://en.cppreference.com/w/c) as a readable index into the standard.

## rust — ownership to `unsafe`, FFI and async (P3)

House guides: `code/docs/RUST-CODING-PRINCIPLES.md`, `code/docs/TESTING.md`, `code/docs/FFI.md`.
Primary sources through Context7: The Rust Book (`/rust-lang/book`), The Rust Reference
(`/rust-lang/reference`), The Rustonomicon (`/rust-lang/nomicon`); cite the doc.rust-lang.org page,
not Context7. For P3's async topic, the [tokio tutorial](https://tokio.rs/tokio/tutorial).

## tooling — the shared foundations (from P1)

House guides: `how-to/docs/TOOLCHAIN.md`, `how-to/docs/CLI-TOOLING.md`, `code/docs/BUILD.md`,
`code/docs/DEBUGGING.md`, and `code/src/scripts/CONTEXT.md` for the script contract a shell exercise
follows. Primary sources:

- The toolchain: `man gcc`, `man make`, `man gdb`, `man valgrind`, and the GNU manuals online.
  Practise on `code/src/c/ms001-hello/` before a new exercise.
- Shell: `man bash`, and [ShellCheck](https://www.shellcheck.net/)'s page per SC code (shellcheck
  runs in CI; it is not installed locally, `GAPS.md`).
- Git for patch series: [git-range-diff](https://git-scm.com/docs/git-range-diff),
  [git-format-patch](https://git-scm.com/docs/git-format-patch),
  [git-rerere](https://git-scm.com/docs/git-rerere), [git-bisect](https://git-scm.com/docs/git-bisect).
  Sam runs any interactive rebase himself.
- Licensing and collaboration: the [SPDX licence list](https://spdx.org/licenses/),
  [REUSE](https://reuse.software/), the [Developer Certificate of Origin](https://developercertificate.org/),
  and the FSF's licence list (`REFERENCES.md` → External — Process). Licences are per repository:
  this one is GPL-2.0-only, and a product repository chooses its own.

## kernel — build, boot, modules, Kconfig and the downstream tree (P4–P5)

Primary sources: [docs.kernel.org](https://docs.kernel.org/) and the kernel tree's
`Documentation/`; [kernel.org releases](https://www.kernel.org/category/releases.html) for the
mainline, stable and longterm lines; [KSPP Recommended Settings](https://kspp.github.io/Recommended_Settings)
and [kernel-hardening-checker](https://github.com/a13xp0p0v/kernel-hardening-checker) for the
hardening baseline; the [kernel CVE process](https://docs.kernel.org/process/cve.html) and the CNA's
`vulns.git` (`git ls-remote https://git.kernel.org/pub/scm/linux/security/vulns.git`) for CVE
triage; [The Linux Kernel Module Programming Guide](https://sysprog21.github.io/lkmpg/) as a
stepping stone, re-authored rather than quoted.

- **QEMU only.** Every build boots in QEMU and never on the host (`.claude/CLAUDE.md` Section 5);
  until P4 a kernel lesson is reading and notes only. Specs live in `project-management/src/06-KERNEL/`.
- **Where it lands.** Exercises and modules under `code/src/kernel/` (planned — added at P4); the
  downstream kernel tree itself in the downstream kernel repository, created in
  `kernel-05-downstream-tree` lesson 02.
- **Rust-for-Linux** is blocked until clang/LLVM, libclang and bindgen are installed (`GAPS.md`).

## os — Syntek OS, built from scratch (P6)

Primary sources: the [LFS 13.1-systemd book](https://www.linuxfromscratch.org/lfs/view/stable-systemd/)
(published 01/09/2026) and [BLFS 13.1 systemd](https://www.linuxfromscratch.org/blfs/view/stable-systemd/)
(03/09/2026); the System V book stays at [LFS 12.4](https://www.linuxfromscratch.org/lfs/view/stable/)
and is no longer updated ([LFS news](https://www.linuxfromscratch.org/news.html)), so it is a
historical reference only. The [FHS 3.0](https://refspecs.linuxfoundation.org/FHS_3.0/fhs/index.html);
the package managers studied — [pacman](https://man.archlinux.org/man/pacman.8),
[apk](https://wiki.alpinelinux.org/wiki/Alpine_Package_Keeper), [xbps](https://docs.voidlinux.org/xbps/index.html);
[reproducible-builds.org](https://reproducible-builds.org/) and its
[SOURCE_DATE_EPOCH spec](https://reproducible-builds.org/specs/source-date-epoch/);
the [TUF specification](https://theupdateframework.github.io/specification/latest/) and
[minisign](https://jedisct1.github.io/minisign/); [systemd](https://systemd.io/),
[runit](https://smarden.org/runit/) and [s6](https://skarnet.org/software/s6/);
[nftables](https://wiki.nftables.org/wiki-nftables/index.php/Main_Page),
[WireGuard](https://www.wireguard.com/), [Samba](https://www.samba.org/samba/docs/) and
[OpenZFS](https://openzfs.github.io/openzfs-docs/); [QEMU disk images](https://www.qemu.org/docs/master/system/images.html).

- **VMs and QEMU disk images only; isolated virtual networks for labs.** Real hardware only when a
  milestone names dedicated, wiped test hardware (`.claude/CLAUDE.md` Section 5). No hardware is
  chosen yet for any profile; each is chosen by ADR when its topic opens (`GAPS.md`). A lab-proven
  config reaches a real device only by the graduation path
  (`project-management/src/08-DECISIONS/ADR-MS001-NETWORK-LAB-FIRST-GRADUATION-PATH-27-09-2026.md`;
  checklist in `project-management/docs/SAFETY-GUIDE.md`): Sam applies it, never Claude.
- **The learning build follows the LFS 13.1 systemd book.** A minimal init in C is a lesson; the
  init Syntek OS ships is chosen later by ADR, fed by the `INIT-SYSTEM-CHOICE` research note
  (`DEFERRED.md`).
- **Specs and decisions.** Profiles live in `project-management/src/07-OS-PROFILES/`; the
  independence and one-base decisions are ADRs in `project-management/src/08-DECISIONS/`.
- **Where it lands.** Small exercises under `code/src/os/` (planned — added at P6); the build
  system, package manager and installer in the Syntek OS build-system, package-manager and installer
  repositories, each created when its build starts.

## ui — TUI and GUI tools (U1–U3)

Primary sources: `man 3 termios` and `man 4 console_codes` (installed); [ratatui](https://ratatui.rs/)
and its [API docs](https://docs.rs/ratatui/latest/ratatui/); [crossterm](https://docs.rs/crossterm/latest/crossterm/);
the [tokio tutorial](https://tokio.rs/tokio/tutorial); [Yazi](https://github.com/sxyazi/yazi) as
the architecture studied; the [gtk4-rs book](https://gtk-rs.org/gtk4-rs/stable/latest/book/) and
[API docs](https://gtk-rs.org/gtk4-rs/stable/latest/docs/gtk4/); [zbus](https://docs.rs/zbus/latest/zbus/)
and [polkit](https://www.freedesktop.org/software/polkit/docs/latest/); the
[Wayland documentation](https://wayland.freedesktop.org/docs/html/) and [The Wayland Book](https://wayland-book.com/);
[Slint](https://slint.dev/) for its model only.

- **Toolkits.** Lessons here use gtk4-rs
  (`project-management/src/08-DECISIONS/ADR-MS001-GUI-TOOLKIT-GTK4-27-09-2026.md`). Syntek OS
  products are written in Slint, in their own repositories; no Slint crate enters this one.
- **Licences.** A crate outside `code/src/rust/deny.toml`'s allow list enters only as a documented
  per-crate exception citing the ADR that admits it, in the milestone that first needs it.
- **Where it lands.** Lesson crates under `code/src/rust/crates/msNNN_<snake>/`; a substantial tool
  (and any tool taking outside contributions) moves to its own repository when its build starts —
  the Syntek OS file-manager, package-manager, installer, system-tools, GUI-tools or web-dashboard
  repository.

## llm — the language model (L1–L6)

Primary sources: the [PyTorch 2.14 docs](https://docs.pytorch.org/docs/2.14/) (notably
[serialization](https://docs.pytorch.org/docs/2.14/notes/serialization.html) and
[AMP](https://docs.pytorch.org/docs/2.14/amp.html)); NVIDIA's [CUDA programming guide](https://docs.nvidia.com/cuda/cuda-programming-guide/),
[installation guide for Linux](https://docs.nvidia.com/cuda/cuda-installation-guide-linux/) and
[Turing architecture whitepaper](https://images.nvidia.com/aem-dam/en-zz/Solutions/design-visualization/technologies/turing-architecture/NVIDIA-Turing-Architecture-Whitepaper.pdf);
[llm.c pinned at commit f1e2ace](https://github.com/karpathy/llm.c/tree/f1e2ace651495b74ae22d45d1723443fd00ecd3a)
(MIT; its last commit, 10/05/2025); [nanochat](https://github.com/karpathy/nanochat) (MIT, the
maintained successor); [nanoGPT](https://github.com/karpathy/nanoGPT) (MIT, deprecated by its
author — reading only); [micrograd](https://github.com/karpathy/micrograd); Hugging Face
[tokenizers](https://huggingface.co/docs/tokenizers/) and [safetensors](https://huggingface.co/docs/safetensors/)
([repository](https://github.com/safetensors/safetensors)); [candle](https://github.com/huggingface/candle);
[llama.cpp](https://github.com/ggml-org/llama.cpp) and the [GGUF spec](https://github.com/ggml-org/ggml/blob/master/docs/gguf.md);
[vLLM](https://docs.vllm.ai/); [ollama](https://github.com/ollama/ollama); the
[Stack v2 dataset card](https://huggingface.co/datasets/bigcode/the-stack-v2) and its terms, and the
[Stack v3 dataset card](https://huggingface.co/datasets/HuggingFaceCode/stack-v3-train) (ODC-By); the
[OWASP Top 10 for LLM Applications 2025](https://genai.owasp.org/llm-top-10/) and the
[OWASP Top 10 for Agentic Applications for 2026](https://genai.owasp.org/resource/owasp-top-10-for-agentic-applications-for-2026/);
papers by arXiv ID, listed in `REFERENCES.md` → External — LLM. The 2025 LLM Top 10 IDs are this
repository's citation key; the [2026 edition](https://genai.owasp.org/resource/owasp-genai-llm-top-10-2026/)
(03/08/2026) re-ranks them, mapped in `learning/llm-18-secure-llm-systems/` lesson 01.

- **Budgets are measured, on this machine.** The RTX 2080 Ti also drives the desktop (1474 MiB of
  its 11264 MiB in use at idle on 27/09/2026, with about 470 MiB more reserved by the driver, per
  `nvidia-smi`; idle use varies with the desktop), so a VRAM budget is set against the free memory
  read on the day (`nvidia-smi`'s `memory.free`, or `torch.cuda.memory.mem_get_info()`), not the
  card's total.
- **Profiling without sudo.** `perf` counters and GPU counters are locked for Sam's user
  (`GAPS.md`). A lesson that needs them shows Sam how to relax the restriction for one session and
  restore it — he runs the commands — and also teaches the fallback (`valgrind --tool=cachegrind`,
  `torch.profiler`).
- **Weights, data and generated code** follow `.claude/CLAUDE.md` Section 5: safetensors or a
  `weights_only=True` checkpoint this machine produced; licence-checked, scrubbed data; sandboxed
  execution.
- **Skills, not agents** (`project-management/src/08-DECISIONS/ADR-MS001-LLM-SKILLS-NOT-AGENTS-27-09-2026.md`):
  this repository's `.claude/skills/` is the working prototype of the skill format.
- **Where it lands.** Python under `code/src/python/` (planned — added at L1), CUDA under
  `code/src/cuda/` (planned — added at L2), Rust as lesson crates; the data pipeline and training
  code in the model-training repository, the inference server and skill loader in the inference
  repository, and the released weights, model card and evaluations in the model-release repository
  (`llm-21` lesson 07), each created when its build starts. `llm-01`'s three skills and gap log are
  the inference repository's first contents (its lesson 05 starts it). Prices are never tabled: a
  lesson teaches the estimate and says to check prices on the day.

## sec — security, defensive and authorised offensive (S1–S3)

Primary sources: the UK [Computer Misuse Act 1990](https://www.legislation.gov.uk/ukpga/1990/18/contents);
[NIST SP 800-115](https://csrc.nist.gov/pubs/sp/800/115/final) (security testing) and
[NIST SP 800-61 Rev. 3](https://csrc.nist.gov/pubs/sp/800/61/r3/final) (incident response); the
[OWASP Top 10](https://owasp.org/www-project-top-ten/), the [Web Security Testing Guide](https://owasp.org/www-project-web-security-testing-guide/)
and [Juice Shop](https://owasp.org/www-project-juice-shop/); [MITRE CWE](https://cwe.mitre.org/) and
[ATT&CK](https://attack.mitre.org/) (its [Linux matrix](https://attack.mitre.org/matrices/enterprise/linux/));
[CVSS v4.0](https://www.first.org/cvss/v4-0/specification-document); [RFC 9116](https://www.rfc-editor.org/rfc/rfc9116)
(security.txt); the kernel's [self-protection](https://docs.kernel.org/security/self-protection.html),
[Landlock](https://docs.kernel.org/userspace-api/landlock.html),
[seccomp](https://docs.kernel.org/userspace-api/seccomp_filter.html) and
[dm-verity](https://docs.kernel.org/admin-guide/device-mapper/verity.html) docs; the
[EICAR test file](https://www.eicar.org/download-anti-malware-testfile/), [ClamAV](https://github.com/Cisco-Talos/clamav),
[YARA](https://yara.readthedocs.io/) and [AIDE](https://aide.github.io/); man pages; and the rules
of each training platform used ([OverTheWire](https://overthewire.org/wargames/),
[pwn.college](https://pwn.college/), [picoCTF](https://picoctf.org/)).

- **Authorised and isolated.** Offensive techniques run only against systems Sam owns or is
  authorised in writing to test, inside isolated lab networks, with attack tooling in VMs; no
  malware is written or handled, and detection is tested with EICAR and synthetic files
  (`.claude/CLAUDE.md` Section 5; the lab rules ADR,
  `project-management/src/08-DECISIONS/ADR-MS001-SECURITY-TRACK-AND-LAB-RULES-27-09-2026.md`).
- **Deliberately vulnerable builds** sit under a clearly named target that CI does not ship, and are
  never installed.
- **Write-ups** of a platform's challenges are published only where that platform permits it.
- **Licences.** The OWASP GenAI project's site states CC BY-SA 4.0 for its content, a share-alike
  licence, so it is re-authored and never quoted; other OWASP pages are treated the same until
  their own licence is checked (`.claude/skills/research/SKILL.md` → the licence ladder).
- **Where it lands.** Notes, rules and lab records stay in the topic folder; small exercises and VM
  harnesses go under `code/src/` (a deliberately vulnerable build is a never-shipped target); a
  build that hardens or tests a product lands in that product's repository. `sec-04`'s sandbox
  launcher starts as a lesson crate here and moves to the sandbox-launcher repository (created at
  the first lesson that runs it from a product repository, `os-05` lesson 03 or `llm-13` lesson 03),
  which the product repositories that run untrusted or generated code depend on.

---

_Part of the `teach` skill (`.claude/skills/teach/SKILL.md`)._
