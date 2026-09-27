---
type: guide
---

# Coding Principles

**Last Updated**: 27/09/2026 | **Version**: 0.1.0 | **Maintained By**: Sam Bailey
**Language**: British English (en_GB) | **Timezone**: Europe/London

These principles apply to **all code** in this repository: the C exercises, the Rust crates, and from
P4 the kernel modules. They are few on purpose — three sources, each short enough to hold in your head,
chosen because they were written by people doing exactly this kind of work: C, operating systems, and
code that has to keep working. Language-specific rules live in the companions:

| Scope | Companion |
| --- | --- |
| C — style, headers and linkage, error handling, C17 | `code/docs/C-CODING-PRINCIPLES.md` |
| Rust — formatting, the lint policy, errors, `unsafe` | `code/docs/RUST-CODING-PRINCIPLES.md` |
| The boundary between them (P3) | `code/docs/FFI.md` |

The sources are paraphrased here and linked below; each original is short, and worth reading whole.

---

## 1. Rob Pike's five rules

From Rob Pike's _Notes on Programming in C_ (1989) —
[doc.cat-v.org/bell_labs/pikestyle](https://doc.cat-v.org/bell_labs/pikestyle).

**Rule 1 — You cannot tell where a program spends its time.** Bottlenecks turn up in surprising places,
so no speed hack goes in until a measurement proves that is where the bottleneck is.

**Rule 2 — Measure.** No tuning for speed without a measurement, and even then only when one part of the
code overwhelms the rest.

**Rule 3 — Fancy algorithms are slow when n is small, and n is usually small.** Fancy algorithms carry
big constants. Until you know n is frequently large, do not get fancy — and if it is, apply Rule 2 first.

**Rule 4 — Fancy algorithms are buggier than simple ones**, and much harder to implement. Use simple
algorithms, and simple data structures.

**Rule 5 — Data dominates.** Choose the right data structures and organise them well, and the algorithms
become almost self-evident. Data structures, not algorithms, are central to programming.

**Applied here.**

- A linear scan over a small array beats a hash table you wrote yourself and now have to debug — until a
  measurement says otherwise. Rules 1 and 2 matter little in P1, where nothing needs to be fast; they
  matter from P2, when the allocator and the shell have real workloads.
- A measurement is a tool's output, not an impression: `time ./build/prog`, or
  `valgrind --tool=callgrind ./build/prog` for a per-function breakdown.
- In Rust, Rule 5 is the type system at work: an `enum` whose variants carry their own data makes whole
  families of `if` statements unnecessary.
- Rule 4 is why `code/src/c/include/check.h` is a page of macros rather than a framework.

---

## 2. Linus Torvalds — data structures, good taste, short functions

From the Linux kernel coding style —
[docs.kernel.org/process/coding-style.html](https://docs.kernel.org/process/coding-style.html) — his
2006 mailing-list remark on data structures, quoted by [LWN](https://lwn.net/Articles/193245/), and his
2016 TED interview, [The mind behind Linux](https://www.ted.com/talks/linus_torvalds_the_mind_behind_linux).

**Data structures before code.** _"Bad programmers worry about the code. Good programmers worry about
data structures and their relationships."_ It is Pike's Rule 5 from the other direction: get the shape of
the data right and the code that walks it gets short.

**Good taste: remove the special case instead of handling it.** In the TED interview he shows two ways
to remove an entry from a singly linked list. The version below is written for this guide in kernel
style; the idea is his.

```c
struct node {
	int value;
	struct node *next;
};

/* Walks the nodes, so the head needs a branch of its own. */
void list_remove_naive(struct node **head, struct node *target)
{
	struct node *prev = NULL;
	struct node *cur = *head;

	while (cur != target) {
		prev = cur;
		cur = cur->next;
	}
	if (!prev)
		*head = target->next;
	else
		prev->next = target->next;
}

/* Walks the links. The head is just the first link, so the branch disappears. */
void list_remove(struct node **head, struct node *target)
{
	struct node **link = head;

	while (*link != target)
		link = &(*link)->next;
	*link = target->next;
}
```

Both assume `target` is in the list — a precondition the header comment would state. The second has
one path through it instead of two: one fewer branch to test, and one fewer place for a bug to live. When
a fix adds an `if` for "the first one" or "the last one", look for a representation in which that case
is not special.

**Short functions that do one thing.** Kernel style Section 6: a function fits on one or two screenfuls
(80x24), does one thing, and keeps to five to ten local variables; past that, split it. The permissible
length shrinks as complexity grows — a long but flat `switch` is fine, a short but tangled function is
not.

**Shallow nesting.** Kernel style Section 1 uses 8-column tabs precisely so that deep nesting hurts:
more than three levels of indentation means the function needs restructuring. Guard clauses that return
early, and the `goto` cleanup ladder (`code/docs/C-CODING-PRINCIPLES.md` Section 3), keep the main path
at the left margin.

**One thing per line.** No multiple statements or assignments on one line, and no tricky expressions.
Clarity beats cleverness, and stability beats novelty.

**In Rust** the same limits hold. clippy's pedantic `too_many_lines` lint makes the point mechanically,
and `?` plays the part of the early return.

---

## 3. Kent Beck's four rules of simple design

From Kent Beck's work on Extreme Programming, as summarised by Martin Fowler —
[martinfowler.com/bliki/BeckDesignRules.html](https://martinfowler.com/bliki/BeckDesignRules.html). In
priority order:

1. **Passes the tests.** Here "the tests" means the whole gate, not only the assertions: `make test` and
   `cargo test`, and for C a clean `make san`, `make memcheck` and `make lint` as well
   (`code/docs/TESTING.md`, `code/docs/MEMORY-SAFETY.md`). Code that passes its checks and leaks has not
   passed.
2. **Reveals intention.** Names say what; the comment above a declaration says what the function
   promises and why it exists. In C that comment sits on the declaration in the `.h` file — see
   `code/src/c/ms001-hello/greet.h`. In Rust it is the `///` doc comment, with `# Errors`, `# Panics` and
   `# Safety` sections where they apply.
3. **No duplication.** Every piece of knowledge has one authoritative representation — the rule this
   repository applies to its own documents as "route, do not restate"
   (`code/docs/DOCUMENTATION-PAIRING.md` Section 6). Tolerate a second copy of code; extract on the
   third, because a premature abstraction is harder to remove than duplication.
4. **Fewest elements.** Remove anything that does not serve the first three: unused parameters
   (`-Wunused-parameter` already complains), dead code, and generality nobody has asked for yet.

---

## 4. When the principles pull against each other

- **The exercise objective beats Rule 3.** If an exercise exists to teach a hash table, write the hash
  table. These rules govern code meant to be used; a drill that teaches a part is judged by what it
  teaches (its `EX-MS###` spec in `project-management/src/04-EXERCISES/`).
- **Extract for a reason, not a line count.** Pulling out a helper that removes duplication serves Beck
  and Torvalds at once; pulling one out only to get under a length serves neither.
- **Make it work, then make it right, then — only with a measurement — make it fast.** The order is the
  lesson: correctness first, then structure, then speed, and never the last without Pike's Rule 2.

## 5. How the principles are checked

`code/workflows/05-review/` reads finished code against this guide and its two companions, and points at
the section that applies rather than rewriting the code. `code/workflows/08-refactor/` is where a change
made purely to improve structure happens, one behaviour-preserving step at a time.

---

## Cross-references

- `code/docs/C-CODING-PRINCIPLES.md` — the C companion: kernel style, headers, errors, C17
- `code/docs/RUST-CODING-PRINCIPLES.md` — the Rust companion: rustfmt, clippy, errors, `unsafe`
- `code/docs/TESTING.md` — what "passes the tests" means in practice
- `code/workflows/05-review/` — the review that applies these principles
- `code/REFERENCES.md` — the sources above, with the rest of the layer's external references

_Part of the `code/docs/` documentation family._
