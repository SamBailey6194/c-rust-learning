# Kernel Build Record — MS000: {BUILD TITLE}

_Template — copy to `KERNEL-IMPL-MS###-<DESCRIPTOR>.md` (the same descriptor as its plan), replace
every `{PLACEHOLDER}`, delete the `[EXAMPLE]` rows. This is the **post-build** record: what was
actually built and booted, with the evidence that closes the plan. **Paste real output, trimmed to
the relevant lines — never a paraphrase.** A check that was not run is written as not run, never as
passed._

| Field | Value |
| --- | --- |
| **Milestone** | `MS###` — {short title} |
| **Plan** | `project-management/src/06-KERNEL/KERNEL-PLAN-MS###-<DESCRIPTOR>.md` |
| **Kernel built** | {x.y.z} — from {tarball, signature verified / git tag `v{x.y.z}`} |
| **Host compiler** | {`gcc --version` first line} |
| **QEMU** | {`qemu-system-x86_64 --version` first line} |
| **Fragment** | `code/src/kernel/{fragment-name}.config` (planned — the folder is added at P4) |
| **Status** | {Draft / Verified} |
| **Date** | {DD/MM/YYYY} |

---

## 1. Planned against built

Every row of the plan, with what actually happened. **A divergence is recorded with its reason,
never silently accepted** — that is how the next plan gets better.

| Plan item | Planned | Built | Verdict / reason |
| --- | --- | --- | --- |
| Version | [EXAMPLE] {x.y.z} longterm | [EXAMPLE] {x.y.z} | as planned |
| Base config | [EXAMPLE] `x86_64_defconfig` + `kvm_guest.config` | [EXAMPLE] same | as planned |
| Fragment options | [EXAMPLE] 6 options | [EXAMPLE] 6 survived `olddefconfig` | as planned |
| Patches | {...} | {...} | {...} |
| Modules | {...} | {...} | {...} |
| Initramfs | {...} | {...} | {...} |

---

## 2. Source verification

```text
[EXAMPLE]
$ xz -cd linux-{x.y.z}.tar.xz | gpg2 --verify linux-{x.y.z}.tar.sign -
gpg: Good signature from "{signer} <{signer address}>" [unknown]
```

{Keep the "Good signature" line and the key fingerprint line; a signer's address may be trimmed.}

---

## 3. Config as built

The delta between the base and the final `.config`:

```text
[EXAMPLE]
$ scripts/diffconfig <base-config-copy> <build-dir>/.config
 {one line per option that changed}
```

- [ ] Every fragment option is present in the final `.config`
- [ ] Every option that changed without being in the fragment is explained below

{Explanations for unexpected changes, if any.}

---

## 4. Build

```text
[EXAMPLE]
$ make O=<build-dir> -j"$(nproc)"
{the last few lines, ending with the bzImage line}
```

- **Warnings:** {none / count and the notable ones}

---

## 5. QEMU boot evidence

The command exactly as run:

```bash
{qemu-system-x86_64 ... exactly as run}
```

Serial console, from the `Linux version` line to the proof-of-boot line named in the plan:

```text
[EXAMPLE]
[    0.000000] Linux version {x.y.z} ({build user}@{build host}) ...
...
{the proof-of-boot line, e.g. the shell prompt}
```

---

## 6. dmesg excerpt

The lines that matter for this milestone — driver probes, warnings, anything the plan predicted.

```text
[EXAMPLE]
/ # dmesg | tail -n 5
{...}
```

---

## 7. Module evidence

{`None` if the milestone built no module.}

```text
[EXAMPLE] inside the QEMU guest
/ # insmod /lib/modules/hello.ko
/ # dmesg | tail -n 1
[   12.345678] hello: loaded
/ # rmmod hello
/ # dmesg | tail -n 1
[   15.678901] hello: unloaded
```

---

## 8. Debugging evidence

{Only when the Debugger flag runs: the gdb session — breakpoint, backtrace, the value that mattered.
`None` otherwise.}

---

## 9. Divergences and gaps

| Item | What happened | Follow-up |
| --- | --- | --- |
| [EXAMPLE] a fragment option dropped | its dependency `CONFIG_{...}` was off | added to the fragment; re-verified |
| {PLACEHOLDER} | {PLACEHOLDER} | {`GAPS.md` entry / `DEFERRED.md` entry / a `13-BUGS` record / none} |

---

## 10. Host safety confirmation

- [ ] Nothing was installed on the host: no `make install`, no `make modules_install` without
      `INSTALL_MOD_PATH` pointing into the initramfs staging directory
- [ ] No module was loaded into the host kernel; every `insmod` above ran inside QEMU
- [ ] No `sudo` was used for any step in this record
- [ ] `git status` shows no kernel source, build output, `bzImage`, initramfs or disk image in the
      repository

---

## Cross-references

- `project-management/src/06-KERNEL/KERNEL-PLAN-MS###-<DESCRIPTOR>.md` — the plan this record closes
- `project-management/src/02-MILESTONES/MS###-<TITLE>.md` — the driving milestone
- `project-management/src/10-PROGRESS/` — the verification record that cites this one
- `project-management/docs/VERIFICATION-GUIDE.md` — what counts as evidence
