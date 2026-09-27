@./CONTEXT.md

# CLAUDE.md — learning/

Read order: `.claude/CLAUDE.md` → `.claude/MEMORY.md` → this folder's `CONTEXT.md` (tracks and topic
layout, imported above) → this file → the `teach` skill (`.claude/skills/teach/SKILL.md`) → the
topic's `SYLLABUS.md` (where it has one), `MISSION.md` and `PROGRESS.md`.

## Purpose (one line)

The concept-notes and recall layer for the `teach` skill: Sam's syllabi, missions, sources, notes and review
journal, with every runnable example kept under `code/src/`.

## How to work here

- **Routing:** all work here runs through the `teach` skill, which owns the lesson loop, the
  spacing rule and the file formats. A lesson runs inside
  `project-management/workflows/10-study-and-build/`; its build step goes through
  `code/workflows/01-c-exercise/` to `code/workflows/04-ffi-bridge/`.
- **Concrete steps:** `/teach <topic>` → read `MISSION.md` and `PROGRESS.md`, due reviews first →
  the next lesson (the first untaught `SYLLABUS.md` lesson, re-pitched to Sam's level) → one
  lesson: recall, then Sam builds the example under `code/src/` → Sam writes
  `NOTES/NN-<concept>.md`, linking the code by path → a dated journal entry with the next review
  date in `PROGRESS.md`.
- **Definition of done:** a fresh session can resume the topic from `MISSION.md` and
  `PROGRESS.md` alone; every code path a note references builds and passes its tests under
  `code/` (`make -C code/src/c test`, `(cd code/src/rust && cargo test)`); no
  text is pasted from a book, standard or manual.

## Guardrails

- **Tutor mode: Sam writes the code.** Ask how Sam plans to approach the problem before helping;
  explain and ask guiding questions; write no exercise solution unless Sam explicitly asks for
  one. Point a review at the relevant `code/docs/` section rather than rewriting Sam's code.
- **Write notes here, runnable code under `code/src/`.** A C example goes in
  `code/src/c/msNNN-<kebab>/` and a Rust example in `code/src/rust/crates/msNNN_<snake>/`, so CI
  builds both; later homes arrive with their phase (`code/src/kernel/`, planned — added at P4;
  `code/src/os/`, planned — added at P6; `code/src/python/`, planned — added at L1;
  `code/src/cuda/`, planned — added at L2). A substantial build lands in its own repository once
  it starts (`.claude/skills/teach/FAMILIES.md`). A snippet in a note is a copy of lines that
  compile there, cited with its `path:line` range.
- **Never paste book text.** Re-author in Sam's words and cite the source by section or URL; the
  licence rules live in `research/CLAUDE.md`.
- **Notes stay in Sam's words.** Check a note against its source and flag errors; do not rewrite
  it into Claude's prose, because writing it is part of the learning.
- **Kernels, OS images and labs run in QEMU, VMs and isolated virtual networks only.** The
  non-negotiables in `.claude/CLAUDE.md` Section 5 hold here too: offensive techniques only in the
  authorised lab, no malware, no untrusted pickle, and Claude never runs `sudo`.
- **A pre-seeded mission is a draft.** Confirm or rewrite its Why with Sam at the topic's first
  lesson; never present a drafted line as his words.
- **Revise a syllabus by appending.** New lessons go at the end; a taught lesson keeps its number.
- **British English (en_GB)**; dates DD/MM/YYYY in prose.

## Output & naming

- **Hand-written:** everything here, created and updated through `/teach`.
- Topic folders `<track>-NN-<topic>/`: track `c`, `rust`, `kernel`, `os`, `ui`, `llm`, `sec` or
  `tooling`; `NN` a two-digit running number within the track, appended and never renumbered;
  topic in kebab-case. Example: `c-01-foundations/`.
- Fixed files `MISSION.md`, `RESOURCES.md`, `PROGRESS.md`, and `SYLLABUS.md` where the topic was
  planned ahead; notes `NOTES/NN-<concept>.md`, where `NN` is the lesson number within the topic,
  the syllabus number when there is one (for example `NOTES/03-pointer-arithmetic.md`).
- Each session appends one `PROGRESS.md` journal entry headed `### DD/MM/YYYY — NN <concept>`,
  with **Recall** (question → pass, partial or miss), **Built** (code path, command, result, gate
  results), **Misconception to re-drill**, **Note** (the `NOTES/` file) and **Next review** (date
  and interval). Dead ends are recorded too. The full templates are in
  `.claude/skills/teach/SKILL.md`.
- Topic folders are exempt from pairing and length checks (`code/docs/DOCUMENTATION-PAIRING.md`,
  `code/docs/DOCUMENTATION-LENGTH.md`); this `CONTEXT.md` and `CLAUDE.md` pair is checked.
