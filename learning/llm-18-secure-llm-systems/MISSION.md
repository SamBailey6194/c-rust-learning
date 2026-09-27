# Mission — llm-18-secure-llm-systems

**Started**: not yet · **Family**: llm · **Phase**: L5 · **Milestone**: not yet allocated

## Why

_Drafted from Sam's planning conversation of 27/09/2026 — confirm or rewrite in your own words at
the first lesson._

Sam's brief for the model is that it uses computing resources properly "while being secure", and he
chose a design — skills, retrieved docs, scripts a skill can run — that gives outside text a path to
the model and the model a path to his machine. His request for "pentesting and cybersecurity lessons"
added a whole security track; this topic is where that track meets the LLM. It turns the threat model
into controls he builds and tests on his own server: a gate on untrusted skills, an allow-list and a
per-skill sandbox for scripts, verified weights, a hardened local server, isolation where caches and
memory are shared, and limits on what any client can consume. The same controls are what a Syntek OS
that ships a local model with skills built in (os-17) has to carry.

## Can do it when

- Sam can draw his LLM system's data-flow diagram, run STRIDE over it and map each threat to its
  OWASP LLM (2025 and 2026) or Agentic entry, with a decision for each.
- Sam can keep untrusted project-level skills out of the catalogue until trusted, and stop retrieved
  text from activating skills.
- Sam can refuse any model-requested action outside a skill's declared commands and paths.
- Sam can enforce a per-skill Landlock, seccomp and resource policy over sec-04's launcher, and refuse
  a skill with no policy.
- Sam can verify every model file against a pinned digest before loading, failing closed.
- Sam can configure and probe the local server so no secret, endpoint or origin is exposed that
  should not be.
- Sam can demonstrate the prefix-cache timing side channel on his own server and state the isolation a
  multi-user deployment needs.
- Sam can bound tokens, context, time, memory and request rate per client, and see it in the logs.
- Every control crate passes `cargo test` and `cargo clippy`.

## Parked for later

- Attacking the system with an adversarial suite — sec-15.
- Detection and incident response around the server — sec-16.
- Shipping skills with per-skill policies as a Syntek OS package — os-17.
- Serving several users or adapters from one server — llm-20, with lesson 07's isolation rules.
