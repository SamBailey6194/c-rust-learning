---
type: guide
---

# Guide Craft

**Last Updated**: 27/09/2026 | **Version**: 0.1.0 | **Maintained By**: Sam Bailey
**Language**: British English (en_GB) | **Timezone**: Europe/London

The standing conventions for **documentation a person executes** — the guides in `how-to/docs/` and the
runbooks in `how-to/src/` — as distinct from documentation Claude reads to orient itself (`CONTEXT.md` and
`CLAUDE.md`) or the standards for writing code (`code/docs/`). These are rules, not a procedure: the
procedure is `how-to/workflows/06-write-a-guide/`.

---

## The reader

Usually the learner, mid-session, with a build that has just failed or a tool that will not start; later,
anyone who finds this public repository and wants to reproduce it. They are scanning for their step.
Everything below follows from that:

- **Headings are navigation**, not decoration: they survive a skim and name the thing being looked for.
- **No preamble.** Someone whose valgrind run just failed does not read an introduction.
- **Second person, imperative.** "Run `make -C code/src/c memcheck`", not "one might wish to run".
- **The happy path is the easy half.** The value is in what to do when step 4 errors.

---

## Two homes, two standards

Choosing the wrong home means writing to the wrong standard, so choose deliberately:

| Home | Kind | Length |
| --- | --- | --- |
| `how-to/docs/` | Instructional reference, read in fragments | **≤ 300 cloc code lines**: split and leave an index |
| `how-to/src/` | Runbook, executed top to bottom | **Exempt**: write it in full |

If it will be followed start to finish, it is a runbook: give it the spine below. If it will be looked up,
it is a reference: group it by intent and give it a Troubleshooting section.

The exemption is narrower than it looks. A `CONTEXT.md` or `CLAUDE.md` **inside** `how-to/src/` is still
bound by the 300-line cap, and `code/src/scripts/audits/docs-length.sh` checks it. The rule itself lives in
`code/docs/DOCUMENTATION-LENGTH.md`. A reference that outgrows the cap becomes a thin index
(`TOPIC.md`: frontmatter, metadata, intro paragraph, a `## Sub-documents` table, the family footer) over a
`kebab-case/` sub-folder that carries its own `CONTEXT.md` and `CLAUDE.md`.

---

## The spine

Every runbook has these six sections, in this order. Omit one only when you can say why.

1. **Purpose** — one line: what this achieves, and when to reach for it.
2. **Prerequisites** — state, access and tools required _before_ step 1. This is the section that
   execute-to-verify corrects most often.
3. **Steps** — numbered, each with the command, **what success looks like**, and a pointer to Failure
   modes for when it does not.
4. **Failure modes** — what actually went wrong when you ran it, with the recovery.
5. **Rollback** — how to undo it. Mandatory for anything that changes the host.
6. **Verification** — how to prove it worked, independently of the steps' own output.

---

## The reference shape

A guide in `how-to/docs/` carries `type: guide` frontmatter, the two-line metadata block, one `#`
heading, and `---` between its major sections. Commands sit in `bash` fences grouped by intent (C build,
memory and sanitisers, debugging, Rust, docs audits), each preceded by a `#` comment saying what it does.
Where a script wraps the commands, a small `| Script | Wraps |` table follows the fence. It ends with a
Troubleshooting section whose `###` headings are the symptom as printed, and the family footer line
``_Part of the `how-to/docs/` documentation family._``

---

## Command discipline

- **The command is the lesson; the script is the habit.** Show the raw `gcc`, `make`, `valgrind`, `gdb` or
  `cargo` command first, because learning to invoke it is the point, then name the
  `code/src/scripts/**/*.sh` script that wraps it, which is what CI and Claude run.
- **A repeatable operation with no script is a finding.** Write the script and document it, record the gap
  in `GAPS.md`, or state plainly that the step is manual and why. Do not document around it.
- **Copy-pasteable.** No placeholder the reader has to guess. Where a value genuinely varies (a branch
  name, an exercise folder), use a real example and say what to change.
- **Quote real output.** Paste what the command printed on this machine, not what you expect it to print.
- **Mark privileged commands.** A line needing `sudo` is run by the learner, never by Claude; say so above
  it, and say how to undo it if it changes a setting.
- **Flag destructive commands on the line above them**, and say what is lost.
- **Nothing private.** No secrets, no email addresses, no absolute paths into anyone's home directory:
  paths are repo-relative or system paths such as `/proc/sys/…`. The repository is public.
- **A `CHECKLIST.md` box names a command; `STEPS.md` owns how to run it.** A box carries the bare name
  (`gates/all.sh` green end to end) or the exact form its `STEPS.md` twin uses, never a third, shortened
  variant: that is how a correction to `STEPS.md` misses the box that gates it.

---

## Execute to verify

**A guide you have not run is a guess.** Run it start to finish from a state matching its stated
prerequisites (a fresh clone, a clean `build/`, a new shell), then correct it from what happened:

| What you observe | What it means |
| --- | --- |
| A step worked only because your environment was already set up | A prerequisite is missing |
| Output differs from what you wrote | Correct the guide, not your memory |
| You had to stop and think | The step is under-specified |
| You recovered by instinct | That belongs in Failure modes |

Prose review cannot find any of these. This is the single highest-value step, and the one most often
skipped.

**Material that cannot run yet is labelled.** Kernel and QEMU commands written before P4 carry a
"P4 preview" heading, say which prerequisites are missing, and cite the primary source they follow. They
become tested steps in the planned kernel workflows.

---

## Sources

Tool behaviour is checked against primary sources before it is written down: the tool's `--help` and man
page, the GCC, GDB, Valgrind and Rust manuals, and docs.kernel.org (all listed in `how-to/REFERENCES.md`).
Link them; do not paste their text. A factual question that needs more than a lookup gets a research note
(`/research`, written to `research/`), and the guide cites the note.

---

## Scope boundaries

- **The two how-to homes, and only those**, plus the `how-to/workflows/` procedures and the
  `CONTEXT.md`/`CLAUDE.md` pairs inside `how-to/`.
- **Host maintenance lives in the reboot-purge repository.** `how-to/src/HOST-MAINTENANCE.md` is a pointer
  stub on purpose; never grow it into a runbook.
- **Code standards** (C and Rust principles, build flags, testing, memory safety) belong to `code/docs/`.
- **Study notes** belong to `learning/`; **primary-source notes** to `research/`; **plans, specs and
  decisions** to `project-management/`.
- **Toolchain versions** are owned by `how-to/docs/TOOLCHAIN.md` and **the gate list** by
  `how-to/workflows/03-quality-gates/`: cite them, never restate them.

---

## Indexing is part of writing

A guide nothing links to will not be found. Every new file lands in its folder's `CONTEXT.md` tree, in
`how-to/REFERENCES.md` and in the root `REFERENCES.md` in the same change, and `**Last Updated**` is
refreshed on every `CONTEXT.md` touched.

_Part of the `how-to/docs/` documentation family._
