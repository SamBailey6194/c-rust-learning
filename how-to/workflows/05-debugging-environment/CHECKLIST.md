---
workflow: 05-debugging-environment
phase: diagnose
skills: []
---

# Debugging the Environment — Checklist

**Last Updated**: 27/09/2026 | **Version**: 0.1.0 | **Maintained By**: Sam Bailey
**Language**: British English (en_GB) | **Timezone**: Europe/London

---

> **See** `how-to/REFERENCES.md` → **Internal → Reference guides** (`how-to/docs/TOOLCHAIN.md`,
> `how-to/docs/CLI-TOOLING.md`) · **External — Debugging and memory** for supporting references.

## Execution Checklist

### Step 1 — Capture the exact error

- [ ] Command, directory, exit code and first error line written down

### Step 2 — Check the toolchain is present

- [ ] `toolchain/check.sh` exited 0, or the missing tool is named

### Step 3 — Confirm which versions are actually running

- [ ] gcc and the active Rust toolchain compared with `how-to/docs/TOOLCHAIN.md`
- [ ] Cargo commands were run from inside `code/src/rust/`

### Step 4 — Match the symptom to a known environment fault

- [ ] The first error line matched a known fault, or was confirmed as none of them

### Step 5 — Fix the environment and re-run the original command

- [ ] The learner ran every privileged command; Claude ran none
- [ ] The original command was re-run unchanged, in the same directory

### Step 6 — Route what is left

- [ ] A new symptom was added to `how-to/docs/TOOLCHAIN.md` → Troubleshooting
- [ ] A persisting code fault was handed to `code/workflows/07-debug/` with the evidence
- [ ] An unfixable gap has a `GAPS.md` entry with **Type:** Toolchain gap

---

## Context

- [ ] Directory trees in the relevant `CONTEXT.md` files show every file or folder this workflow created
- [ ] `how-to/REFERENCES.md` lists any new guide, workflow or external source
- [ ] `**Last Updated**` is refreshed in every `CONTEXT.md` modified
- [ ] If the session ended mid-work, a handoff exists in `handoffs/`

---

## Definition of Done

- [ ] The cause is named as environment or code, with the evidence that decided it
- [ ] Any temporary host change (`ptrace_scope`, `ulimit -c`) has been set back or has expired
- [ ] No gate was skipped or loosened to get past the fault
- [ ] No source file was edited in this workflow
