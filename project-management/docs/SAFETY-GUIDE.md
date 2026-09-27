---
type: guide
---

# Safety Guide — c-rust-learning

**Last Updated**: 28/09/2026 | **Version**: 0.1.0 | **Maintained By**: Sam Bailey
**Language**: British English (en_GB) | **Timezone**: Europe/London

Hazards run through this curriculum at every level. C's undefined behaviour and memory bugs corrupt a
program quietly. Rust's `unsafe` hands the same bugs back to you behind a keyword. Kernel code can take
the whole machine down with it. OS images and network labs, remote help on someone else's device, an
LLM that loads files and runs generated code, and the security track's offensive work each carry
hazards of their own. This guide says what a
milestone has to **plan** for each of them, at the PM stage, so the right gates and the threat model are
set before any code exists. The rules themselves are owned by `.claude/CLAUDE.md` Section 5, and each
section here routes there.

---

## C — undefined behaviour and memory bugs

Undefined behaviour means the C standard places no requirement on what happens: the program may crash,
may appear to work, or may work until the optimisation level changes. The classes below are the ones
this curriculum meets most, and no single tool catches all of them, which is why the Memory flag runs
two.

| Bug class | Typical shape | Caught by |
| --- | --- | --- |
| Heap buffer overflow | writing `buf[len]` in a `malloc(len)` block | AddressSanitizer; valgrind memcheck; `-fanalyzer` on some paths |
| Stack or global buffer overflow | `char name[8];` then an unchecked `strcpy` | AddressSanitizer (valgrind does **not** see these) |
| Use after free | reading a list node after `free(node)` | AddressSanitizer; valgrind; `-fanalyzer` |
| Double free | two error paths that both `free(p)` | AddressSanitizer; valgrind; `-fanalyzer` |
| Memory leak | an early `return` that skips the `free` | LeakSanitizer (part of ASan); valgrind; `-fanalyzer` |
| Uninitialised read | branching on a local that was never assigned | valgrind (`--track-origins=yes` shows where it came from); `-fanalyzer`; **not** ASan |
| Signed integer overflow | `INT_MAX + 1`, often inside a size calculation | UndefinedBehaviorSanitizer |
| Invalid shift | `1 << 32` on a 32-bit `int` | UndefinedBehaviorSanitizer; gcc warns at compile time when the count is a constant |
| NULL dereference | using `malloc`'s result without checking it | `-fanalyzer`; UndefinedBehaviorSanitizer; a crash otherwise |
| Format mismatch | `printf("%d", some_long)` | `-Wformat=2` at compile time |
| Data race | two threads updating a counter without a lock | ThreadSanitizer (`-fsanitize=thread`, cannot be combined with ASan); valgrind's Helgrind or DRD |

**What a C milestone plans for:**

- **The Memory flag is set whenever the milestone allocates**, and then both `make san` and
  `make memcheck` run: each tool is blind where the other sees.
- **The Lint flag is set whenever the milestone has non-trivial control flow**: `make lint` runs GCC's
  `-fanalyzer`, which follows paths across functions. It is a bug-finder, neither sound nor complete, so
  a clean run is evidence, not proof.
- **The exercise spec names the classes it risks.** A linked-list exercise risks use-after-free; a
  string exercise risks overflow and a missing terminator. Naming them in
  `project-management/src/04-EXERCISES/` turns each into a test the learner writes on purpose.
- **Threads get their own plan.** ThreadSanitizer is not part of `make san`; a P2 threads milestone
  flags it in its plan and records how it ran.

The full treatment, with examples and what each tool's report means, is owned by
`code/docs/MEMORY-SAFETY.md`; the warning and sanitiser flags by `code/docs/BUILD.md`.

---

## Rust — the `unsafe` policy

The workspace denies `unsafe` code outright (`unsafe_code = "deny"` in `code/src/rust/Cargo.toml`), so
safe Rust is the default and every exception is visible. Because it is `deny` and not `forbid`, a
single item can opt out with `#[allow(unsafe_code)]`, which is exactly the point: the opt-out is
deliberate, local and reviewable.

**What a Rust milestone plans for:**

- **`unsafe` arrives only in milestones that are about it** (P3's `unsafe` and FFI milestones, and the
  FFI crate). Any other milestone that finds itself needing `unsafe` has found a design question, not a
  shortcut: record it and ask.
- **Every `unsafe` block carries a `// SAFETY:` comment** on the line before it, stating the invariant
  that makes it sound. Review enforces it: clippy's restriction lint `undocumented_unsafe_blocks`
  would check for exactly this, but it is not enabled in the workspace
  (`code/docs/RUST-CODING-PRINCIPLES.md` Section 4).
- **Edition 2024 tightens the edges**, and the pinned 1.92.0 toolchain enforces it: `extern` blocks
  have to be written `unsafe extern "C" { ... }`, attributes such as `no_mangle` have to be written
  `#[unsafe(no_mangle)]`, and an unsafe operation inside an `unsafe fn` needs its own `unsafe { }`
  block (the `unsafe_op_in_unsafe_fn` lint).
- **An FFI milestone sets the Memory flag.** The C half of an FFI pair still runs under the
  sanitisers and valgrind, because Rust's guarantees stop at the boundary.
- **Relaxing the workspace lint is an ADR**, raised through `08-decisions`, never a line edit.

The rules and their reasons are owned by `code/docs/RUST-CODING-PRINCIPLES.md`, and the C and Rust
boundary by `code/docs/FFI.md`.

---

## Kernel — QEMU only

**Custom kernels and kernel modules run in QEMU only. They are never installed on the host, never
booted on it, and never `insmod`-ed into it.** Kernel source trees, build output and disk images are
never committed. The rule is non-negotiable and is owned by `.claude/CLAUDE.md`; this section explains
why it exists and what it costs a milestone to follow it.

**Why:**

- **A module is not a program.** It runs in ring 0 with the kernel's own privileges and no process
  boundary around it. A stray pointer in a module does not segfault; it corrupts the running kernel,
  and whatever it corrupts (a filesystem's cache, a device driver's state) can outlive the reboot.
- **A wedged module cannot always be removed.** A module stuck in use or crashed mid-init can leave the
  host needing a hard reset, with any unsaved work lost.
- **A kernel you built may not boot your hardware.** A config missing the right storage or filesystem
  driver leaves the host unbootable, and recovery needs a rescue medium.
- **The host is also the study machine.** Everything else in this repository runs on it; putting it at
  risk to learn a lesson QEMU teaches equally well is a bad trade.

**What QEMU gives instead:** a machine you can crash and restart in seconds; `-snapshot`, which writes
disk changes to temporary files so the image is never modified; `-nographic` with `console=ttyS0`, so
the whole boot log arrives as text you can paste into a record; and `-gdb tcp:127.0.0.1:1234 -S`,
which opens a gdb stub on loopback port 1234 and holds the CPU until gdb tells it to continue, so a
kernel can be debugged from its first instruction
(https://docs.kernel.org/process/debugging/gdb-kernel-debugging.html). Not the bare `-s` shorthand:
it means `-gdb tcp::1234`, which listens on every interface (`code/docs/DEBUGGING.md` Section 6).

**What a kernel milestone plans for** (in its `project-management/src/06-KERNEL/` plan):

- the exact `qemu-system-x86_64` command line, including the kernel image, the initramfs and the
  kernel command line
- where the kernel source and build output live: outside the repository, so they cannot be committed
- modules built against that kernel's build tree (`make -C <kernel-build-dir> M=$PWD`), never against
  the host's `/lib/modules/$(uname -r)/build`
- the missing build dependencies as blockers: flex, bison, libelf-dev and dwarves (for pahole) are not
  yet installed, and Rust-for-Linux also needs clang/LLVM and bindgen, so those milestones stay
  `Blocked` with a `GAPS.md` entry until they are

---

## OS images and network labs — VMs and isolated networks only

The kernel QEMU-only rule extends to the OS track. **OS images, installers and partitioning run in VMs
or on QEMU disk images; network and router labs run on isolated virtual networks.** Real-hardware tests
run only on dedicated, wiped test hardware named in the milestone — never the host, never the home
network. No hardware is chosen for any Syntek OS profile yet
(`project-management/src/07-OS-PROFILES/PROFILE-MATRIX.md` → Hardware target). What a profile milestone
plans for: a `qemu-system-x86_64` command against a disk image, `-snapshot` so the image is never
modified, and, for a router or a pentest lab, an isolated network (QEMU `restrict=on`, a libvirt
isolated network, or `os-09`'s unprivileged network-namespace lab) proved to have no route to the home
LAN before anything offensive runs. The rules are owned by `.claude/CLAUDE.md` Section 5; the network
half is argued in
`project-management/src/08-DECISIONS/ADR-MS001-NETWORK-LAB-FIRST-GRADUATION-PATH-27-09-2026.md`.

### Graduating a lab-proven config to Sam's own devices

A **test** finds out whether a config works, and it stays in the isolated lab (or, for real hardware,
on the dedicated wiped hardware a milestone names). A **graduation** puts a config the lab has already
proved into service on one of Sam's own devices; nothing is learned by experiment on a real device.
This section owns the checklist a graduating milestone runs, in order; the ADR above argues it.

- **Lab evidence first.** The config's lab tests pass, and the milestone's verification record says
  so. The deployed config differs from the lab-proven one only by a listed set of substitutions
  (keys, addresses, names).
- **Named devices.** Each target is a device Sam owns, named in the milestone by a role label only.
  The study host takes userspace configuration only; kernels, modules and OS images never graduate.
- **Rollback rehearsed.** The way back to the last known-good config is rehearsed in the lab first. A
  change that can cut remote access runs behind a confirm-or-revert timer, with console access to hand.
- **Sam runs root.** Sam runs every command on a real device. Claude never runs `sudo`, never opens a
  session to a real device and never holds a credential for one.
- **No secrets or topology here.** Real addresses, peers, device names and topology live only in the
  private infrastructure repository, which this repository never links, cites a path in or quotes.
  Private keys are generated on their device and committed to no repository, the private one included.
  Examples here use the documentation ranges (RFC 5737, RFC 3849) and reserved names (RFC 2606).
- **No offensive tooling on the LAN.** No scans, floods, fuzzing or capture of other people's traffic.
  A graduated config is verified by inspection on the device itself: `nft list ruleset`, `ss -tulpn`,
  `wg show`.
- **The household is told first.** Anyone whose connectivity the change touches knows when it
  happens and how to reach Sam if something breaks.
- **Logs and personal data stated per milestone.** The milestone says what the config logs, for how
  long and where, keeping it to the minimum the service needs. Filled consent records and remote-help
  session logs stay on the helped device, and on Sam's machine only if the helped person agrees; they
  enter no git repository, and only a blank consent template may live in the private one.

---

## Remote help — consent first, by construction

Software that lets Sam see and type into a family member's terminal is the same kind of software an
intruder uses to keep control of a machine, so a remote-help milestone plans for being mistaken for
one, or becoming one. Its threat model's mitigations are the ten constraints of
`project-management/src/08-DECISIONS/ADR-MS001-REMOTE-HELP-TOOL-CONSENT-FIRST-27-09-2026.md`
(Proposed): the helped person starts every session, grants view and control separately, sees an
indicator the helper cannot hide, keeps the log and can end it with one key, and nothing persists,
hides or gains a privilege. What such a milestone plans for:

- **Lab first.** Every build, and the abuse-case suite, is proved between two VM guests on `os-09`'s
  isolated lab network before any real session.
- **A real session only under the graduation path.** It reaches only a family device named in the
  milestone, under the family-device clause of the graduation-path ADR (Section "Graduating a
  lab-proven config to Sam's own devices" above), with a written consent record from whoever controls
  the device, made before the session starts.
- **Records stay with the helped person.** Filled consent records and session logs stay on the helped
  device, and on Sam's machine only if the helped person agrees; they enter no git repository, and
  only a blank template may live in the private infrastructure repository.
- **Sam runs it.** Claude never runs `sudo`, never opens a session to a real device and never holds a
  credential for one (`.claude/CLAUDE.md` Section 5).

---

## LLM — untrusted weights, licensed data, sandboxed code

An LLM milestone plans for three hazards, all owned by `.claude/CLAUDE.md` Section 5 and argued in
`project-management/src/08-DECISIONS/ADR-MS001-LLM-EFFICIENCY-AND-SECURITY-FIRST-27-09-2026.md`:

- **Weights load from safetensors, or from a torch checkpoint this machine produced with
  `weights_only=True` — never an untrusted pickle.** `torch.load` unpickles, which can execute
  arbitrary code; safetensors is a data-only format.
- **Training data is licence-checked and scrubbed of secrets and personal data** before it enters a
  run; what may be trained on is decided per file licence and per dataset terms.
- **Code a model or a skill generates runs sandboxed** — no network, rlimits and timeouts, over the
  `sec-04` launcher. Every LLM milestone also states a resource budget (the `Budget` flag) and measures
  it, because the machine's ~9 GiB of free VRAM makes fitting the first question a plan must answer.

---

## Security track — authorised and isolated

Offensive security work is a discipline this curriculum teaches, under rules that make it lawful and
safe (owned by `.claude/CLAUDE.md` Section 5 and
`project-management/src/08-DECISIONS/ADR-MS001-SECURITY-TRACK-AND-LAB-RULES-27-09-2026.md`):

- Techniques run only against systems Sam owns, or is authorised in writing to test, inside isolated
  lab networks; attack tooling runs in VMs, never on the host.
- A training or CTF platform's rules on publishing solutions are respected; the public repository never
  holds a working exploit for an unpatched third-party vulnerability (coordinated disclosure first), and
  a deliberately vulnerable exercise build is confined to a clearly named target that is never installed
  or shipped.
- No malware is written or distributed; no live malware sample enters the repository, the host or CI —
  detection is tested with the EICAR test file and synthetic, harmless files.

A security milestone's `## Threat model` names which of these it runs under, and its lab-setup milestone
proves the network's isolation in its verification record before any offensive step.

---

## Public-repository hygiene

This repository is public, so safety includes what it publishes. No secrets, no absolute paths from
your machine, no pasted copyrighted text (cite and link instead), no email addresses. The
`Audit — Secrets` check scans every push (`project-management/docs/git/PR-AND-CHECKS.md`), but it is
the last line, not the first: read `git diff --staged` before every commit
(`project-management/docs/git/COMMITS.md`). The hygiene rules are owned by `.claude/CLAUDE.md`.

---

## Related

- `code/docs/MEMORY-SAFETY.md` — memory-bug classes and tool reports in depth
- `code/docs/RUST-CODING-PRINCIPLES.md` — the `unsafe` rules and their reasons
- `code/docs/FFI.md` — the C and Rust boundary
- `.claude/CLAUDE.md` — the kernel QEMU-only rule and the public-repository rules
- `project-management/src/08-DECISIONS/ADR-MS001-NETWORK-LAB-FIRST-GRADUATION-PATH-27-09-2026.md` —
  why network labs stay isolated and how a lab-proven config graduates
- `project-management/src/08-DECISIONS/ADR-MS001-REMOTE-HELP-TOOL-CONSENT-FIRST-27-09-2026.md` —
  the constraints a remote-help tool is built inside (Proposed)
- `project-management/docs/VERIFICATION-GUIDE.md` — how the flagged gates are proved afterwards
- `project-management/workflows/06-kernel-spec/` — where a kernel milestone's safety plan is written
