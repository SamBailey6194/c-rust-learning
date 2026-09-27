---
name: wait-what
description: >-
  Stop, that last explanation did not land. Re-pitch it at a different level: conclusion first,
  then the context it assumed, in plain words and this repo's own vocabulary, one level simpler by
  default or at the level Sam names (simpler, example, picture, via-c, deeper). Invoke by typing
  /wait-what, optionally followed by a level, when Sam says an answer was confusing, jargon-heavy
  or skipped a step. User-invoked only: Claude never loads it on its own. Where the miss was a
  knowledge gap rather than dense delivery, it then offers a detour into /teach through a
  HANDOFF-TEACH handoff.
---

# Skill: Wait-what (c-rust-learning)

The previous reply failed. Not the work behind it, the **explanation**. Re-pitch it, at a level
that meets Sam where he is.

Locale: en_GB · Europe/London · dates DD/MM/YYYY.

## Choose the level

`/wait-what` on its own means **one level simpler**. Sam can name the level instead:

- **`simpler`**: from first principles; every term defined; no jargon beyond what Sam's own
  `learning/<topic>/NOTES/` already use.
- **`example`**: a concrete worked example first (a five-line C program and what it prints), the
  general rule after it.
- **`picture`**: a diagram in a `text` block, such as a memory layout, a call stack, a pointer
  chain or an ownership graph, then the words.
- **`via-c`**: re-explain a Rust or kernel idea through the C Sam already knows, and say exactly
  where the analogy breaks.
- **`deeper`**: the same point at source level, for when the explanation was hand-wavy: the C
  standard section, the man page, the Rust Reference rule, the kernel doc, each cited.

## What went wrong (assume one of these)

- **Missing context.** It began three steps in, from a premise never stated.
- **Unshared vocabulary.** It used a term this repo has not defined, or used a defined term
  loosely (the glossaries in the nearest `CONTEXT.md`, and the topic's `NOTES/`).
- **Too dense.** Correct, and unreadable: the failure the tone rules in `.claude/CLAUDE.md` exist
  to prevent.
- **Buried answer.** The reasoning arrived before the conclusion.
- **Wrong level.** Pitched past what `learning/<topic>/PROGRESS.md` shows as consolidated, or
  below it.

## How to re-pitch

1. **Set the level.** Use the one Sam named, or one step simpler than the reply that missed.
   _Done when exactly one level from the list above is chosen._
2. **Lead with the conclusion**, in one sentence a person could repeat to someone else.
   _Done when the reply's first sentence is that conclusion._
3. **Then the context it assumed**: what was already true before this started, and why it
   matters here.
   _Done when every premise the original skipped is stated before it is used._
4. **Use simple, direct sentences in this repo's own words.** One idea each, active voice, short
   words over precise-but-obscure ones. Where a long word is load-bearing, keep it and define it
   inline, once. Stay scannable: a re-pitch spends the words differently, it does not spend more.
   _Done when every technical term is either in a glossary or note Sam already has, or defined
   inline._
5. **Check it landed.** End with one short recall question Sam can answer in a line, not "does
   that make sense?".
   _Done when the reply ends with that question and nothing after it._

## Rules

- **Do not repeat the original wording.** If it had landed, this skill would not have been
  invoked. Restating it louder is the failure mode.
- **Do not apologise, and do not narrate the correction.** Re-pitch and move on.
- **Do not simplify the substance.** Undefined behaviour stays undefined; the claim, the trade-off
  and the caveats survive intact. Only the delivery changes. An explanation that lands by being
  wrong is worse than one that missed.
- **Name what you are unsure landed.** If a specific step is the likely gap, say which, and expand
  that one hardest.
- **Tutor mode still holds.** A re-pitch explains the concept, not the answer to the exercise Sam
  is working on (`.claude/CLAUDE.md`).

## When the gap is knowledge, not delivery

**Too dense** and **buried answer** are delivery failures: the re-pitch is the whole fix, and the
turn ends there. **Missing context**, **unshared vocabulary** and **wrong level** are knowledge
gaps: the re-pitch closes the gap for this one reply and leaves it open for the next. Only then,
offer the durable fix, **after** the re-pitch and in two lines at most; an offer to teach that
arrives ahead of the explanation reads as a deflection.

1. **Name the topic as a slug**: `<track>-NN-<topic>`, the `learning/` folder `teach` will use,
   taking the next free `NN` in that track for a new topic.
   _Done when the slug is named._
2. **Check whether that folder already exists.** If it does, offer to **resume** it; if not, say
   the first session scaffolds it.
   _Done when the offer says resume or scaffold, correctly._
3. **Name the opening lesson.** The concept that just missed _is_ the lesson at the edge of Sam's
   level; carrying it across is the point (it is `teach` step 2's job, already done).
   _Done when the opening lesson is one concept._
4. **Offer the route**: `/handoff` writes the detour handoff, then Sam opens a new session, loads
   it, and runs `/teach <topic>`.
   _Done when the offer is made once, in two lines or fewer._

Ask **once per topic per session**. If Sam declines, drop it and carry on; repeating the offer is
the same failure as repeating the original wording.

### The handoff that carries the detour

`.claude/skills/handoff/SKILL.md` owns the shape and this skill does not restate it. The detour
handoff is written in full as that skill defines, plus three things that mark it as a detour:

- **Descriptor**: `HANDOFF-TEACH-<TOPIC>-DD-MM-YYYY.md`, so the file names its own purpose.
- **A `Teaching detour` line**: the topic slug, the concept that missed, and the opening lesson.
- **Next session loads**: `/teach <topic>` first, then whatever resumes the work beneath it.

The work's own state is still recorded in full: the lesson comes first, and the work resumes from
the same file afterwards. Handoff's final step prints the path and ends the turn; that is where
this stops too.

## Governing procedures (route here — do not restate at length)

**None.** This is a conversational mechanic, not a step in any workflow. It gates nothing, and the
one artefact it can lead to is written by `handoff`, not here.

## Cross-references

- `.claude/CLAUDE.md`: the tone rules a re-pitch still obeys, and tutor mode.
- `.claude/skills/teach/SKILL.md`: where a knowledge gap goes to be closed durably.
- `.claude/skills/handoff/SKILL.md`: the session boundary the teaching detour crosses.
- `learning/CONTEXT.md`: the tracks and topic slugs a detour names.
- `code/docs/C-CODING-PRINCIPLES.md` · `code/docs/RUST-CODING-PRINCIPLES.md`: the house vocabulary
  for C and Rust explanations.
