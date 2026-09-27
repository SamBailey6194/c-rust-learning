# Workflow: Refactor

**Last Updated**: 27/09/2026

A refactor that also changes behaviour cannot be checked, because there is no longer a fixed point to
compare against. The test suite is that fixed point: green before, green after every single move, and
unchanged throughout — which is what turns "no behaviour change" from a claim into something checkable.

## Directory Tree

```text
code/workflows/08-refactor/
├── CONTEXT.md · CLAUDE.md   ← orientation (this file) · operating rules for the workflow
├── STEPS.md                 ← ordered steps, each closing on a "Done when" line
└── CHECKLIST.md             ← the gate ticked before the workflow counts as complete
```

## When to use this

- Working, tested code that is hard to read or change: a long function, nesting deeper than the style
  guide allows, duplicated logic, magic numbers, a header that exposes internals, a source file heading
  past 750 lines.
- After `code/workflows/07-debug/` noted a design problem behind a fix.
- After `code/workflows/05-review/` raised readability or style findings.
- Not for a change in behaviour: a bug goes to `code/workflows/07-debug/` and new behaviour to
  `code/workflows/01-c-exercise/` or `03-rust-exercise/`. Not for a C → Rust port, which is a new crate
  (`03-rust-exercise`).

## Key concepts

- **Behaviour-preserving.** The same outputs, the same error returns, the same memory behaviour — the
  sanitisers, valgrind and the analyzer stay clean. Speed and structure may change; results stay the same.
- **Green before, green after every move.** The baseline is recorded first. A move that turns anything
  red is undone rather than debugged forward, because a refactor that needs debugging has stopped being
  one.
- **Tests stay unchanged.** Tests that assert outcomes through the public interface need no edits when
  internals move. A test that has to change is a sign the public contract changed — which makes the work a
  behaviour change, not a refactor.
- **One named move at a time.** Rename, extract a function, introduce a struct, replace a magic number with
  a named constant or `enum`, split a file, invert a condition to flatten nesting — one per step, built and
  tested after each, committed at green points.
- **The kernel style guide sets the targets.** Short functions that do one thing, shallow indentation,
  names that say what; `code/docs/CODING-PRINCIPLES.md` carries the reasoning (Pike, Torvalds, Beck).
- **Clippy's pedantic group suggests, the learner decides.** In Rust a pedantic lint often names a
  worthwhile move; the lint list explains why before any `#[allow]` is considered.

## Cross-references

### Governing documents

- `code/docs/CODING-PRINCIPLES.md` — what better structure looks like and why
- `code/docs/TESTING.md` — why tests through the public interface survive a refactor

### Related reading

- `code/docs/C-CODING-PRINCIPLES.md` — kernel style, headers and linkage when splitting files
- `code/docs/RUST-CODING-PRINCIPLES.md` — module structure and idiomatic Rust
- `code/workflows/02-tdd-cycle/` — the suite this workflow leans on
- `code/workflows/06-memory-check/` — the memory baseline that also has to hold
- `code/workflows/07-debug/` — where behaviour changes go instead
- `code/docs/DOCUMENTATION-LENGTH.md` — the 750-line limit on source files
