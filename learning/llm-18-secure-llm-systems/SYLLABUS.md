# Syllabus — llm-18-secure-llm-systems

**Track**: llm · **Phase**: L5 · **Path**: Core · **Detail**: full · **Prerequisites**: sec-01 (lessons 03–04: STRIDE over a data-flow diagram, a milestone's threat model); sec-04 (lesson 06: Landlock; lesson 07: the sandbox launcher); llm-16 (the skills layer); llm-17 (retrieval, and its injection lesson); llm-15 lessons 07 and 11 (prefix caching, batching) recommended
**Status**: Planned · **Checked**: 27/09/2026 (sources re-verified by `/teach` step 3 before each lesson)

The mission asks for a model that is efficient "while being secure", and Sam's own design gives it
three ways in from outside: the skills it loads, the documents it retrieves and the weights it runs —
plus one way out that matters most, the skill scripts it can ask to execute. This topic threat-models
that system and builds its controls, organised by the OWASP Top 10 for LLM Applications (the 2025 IDs
the rest of this repository cites, each mapped to the re-ranked 2026 list of 03/08/2026) and, for the
skill loop, the OWASP Top 10 for Agentic Applications 2026. Every control is tested on Sam's own
server and model, never assumed, and the record of each is milestone evidence. **Where the work
lands:** the threat model goes into the milestone's Threat model section and the verification record
under `project-management/src/10-PROGRESS/`; small, testable controls are lesson crates at planned
paths under `code/src/rust/crates/`; the hardened server configuration and the per-skill policies land
in the inference repository (created when this build starts). It is the defensive twin of sec-15 (which
attacks the same system), and it feeds os-17, where skills ship with a per-skill Landlock policy.

| # | Lesson | Size | Build | Lenses |
| --- | --- | --- | --- | --- |
| 01 | Threat-modelling the local model, skills and retrieval | 2–3 sittings | no | Security |
| 02 | Prompt injection through skills, docs and repositories | 2–3 sittings | yes — injection gate | Security |
| 03 | Excessive agency and improper output handling | 1 sitting | yes — script allow-list | Security, Safety |
| 04 | A per-skill sandbox policy | multi-session build | yes — skill policy | Efficiency, Security, Safety |
| 05 | Supply chain and poisoning: weights, data and skills | 2–3 sittings | yes — weight manifest | Security |
| 06 | Sensitive information, hidden context and secrets in serving | 1 sitting | yes — server hardening | Security |
| 07 | Multi-tenant isolation: cache timing and memory reuse | 2–3 sittings | yes — timing probe | Efficiency, Security, Safety |
| 08 | Unbounded consumption: limits, rate limiting and logging | 2–3 sittings | yes — token bucket | Efficiency, Security |

---

## 01 — Threat-modelling the local model, skills and retrieval

- **Objective:** Sam can draw the data-flow diagram of his LLM system with its trust boundaries, run
  STRIDE over it, map each threat to an OWASP LLM or Agentic entry, and write the milestone's threat
  model from it.
- **Builds on:** sec-01 lessons 03–04; llm-16 and llm-17 (the components being modelled);
  `project-management/src/08-DECISIONS/ADR-MS001-LLM-EFFICIENCY-AND-SECURITY-FIRST-27-09-2026.md`
  (every LLM milestone carries a threat model).
- **Key ideas:**
  - The assets: Sam's code and secrets on this machine, the model weights, the training data, the
    skill files and the integrity of the model's actions.
  - The boundaries: the HTTP port, the skill directories, the retrieval corpus, the model file, the
    skill-script executor — each is where untrusted input crosses in or authority leaks out.
  - The OWASP LLM Top 10 is a checklist, not a model: prompt injection (LLM01:2025, LLM01:2026),
    sensitive information disclosure (LLM02 in both), supply chain (LLM03:2025, LLM04:2026), data and
    model poisoning (LLM04:2025, LLM05:2026), improper output handling (LLM05:2025, LLM10:2026),
    excessive agency (LLM06:2025, LLM03:2026), system prompt leakage (LLM07:2025, now hidden context
    exposure, LLM08:2026), vector and embedding weaknesses (LLM08:2025, LLM09:2026), misinformation
    (LLM09:2025, LLM07:2026) and unbounded consumption (LLM10:2025, LLM06:2026).
  - Once the model chooses and runs skills it is also an actor, and the Agentic list applies: goal
    hijack (ASI01), tool misuse (ASI02), privilege abuse (ASI03), agentic supply chain (ASI04),
    unexpected code execution (ASI05), memory and context poisoning (ASI06).
  - A threat model ends in decisions: for each threat, a mitigation, an accepted risk, or a
    non-negotiable it runs under (`.claude/CLAUDE.md` Section 5).
- **Recall targets:** draw the boundaries from memory; name the entry for a described attack in both
  list years; say which lessons below mitigate which threat.
- **Build:** none — the output is the data-flow diagram and the threat model, written into the
  milestone's Threat model section and the lesson's note; every later lesson ticks one of its rows.
- **Security lens:** this lesson is the Security lens for every LLM milestone that follows.
- **Sources:** OWASP Top 10 for LLM Applications 2025, <https://genai.owasp.org/llm-top-10/>; OWASP
  Top 10 for LLM Applications 2026 (03/08/2026, "What's New in the 2026 Top 10"),
  <https://genai.owasp.org/resource/owasp-genai-llm-top-10-2026/>; OWASP Top 10 for Agentic
  Applications for 2026 (09/12/2025),
  <https://genai.owasp.org/resource/owasp-top-10-for-agentic-applications-for-2026/>; llama.cpp
  `SECURITY.md` → "Using llama.cpp securely", <https://github.com/ggml-org/llama.cpp> (MIT, release
  b11221, commit 136887b).
- **Done when:** the milestone's threat model names assets, boundaries, threats with their list IDs
  and a decision for each, and Sam can defend each decision.

## 02 — Prompt injection through skills, docs and repositories

- **Objective:** Sam can show how instructions reach his model through a skill file, a retrieved
  document and a cloned repository, and build the gate that stops untrusted skills from loading
  without consent.
- **Builds on:** lesson 01; llm-16 lesson 03 (trust gating); llm-17 lesson 07 (injection through
  retrieval).
- **Key ideas:**
  - Direct injection comes from the user; indirect injection arrives inside content the system
    reads — a skill's body, a retrieved chunk, a file in a repository the model is asked to work on
    (LLM01; arXiv:2302.12173).
  - The model sees instructions and data as one token stream, so the defences are structural: which
    content may be loaded at all, what it may cause, and who confirms.
  - Skills are the sharpest case: a skill is instructions by design, so a project-level skill from an
    untrusted repository is untrusted code; it is gated until Sam trusts the project, and its
    activation is logged.
  - Retrieved text never changes the skill catalogue, never activates a skill and never widens a
    policy (ASI01 goal hijack).
- **Recall targets:** give one example of each injection path; state the rule that keeps retrieved
  text from activating skills.
- **Build:** `injection gate` — extends llm-16's skill-catalogue crate (planned path
  `code/src/rust/crates/msNNN_skill_catalogue/`) with a trust decision per scope and an activation
  log. Tests: a fixture repository with a hostile project-level skill must not appear in the catalogue
  until trusted; a retrieved chunk naming a skill must not activate it. Checked by `cargo test` and
  `cargo clippy`.
- **Security lens:** the gate is complete mediation for the one path that turns text into
  instructions.
- **Sources:** OWASP LLM01:2025 Prompt Injection, <https://genai.owasp.org/llmrisk/llm01-prompt-injection/>;
  Greshake et al., arXiv:2302.12173; Agent Skills "Adding skills support" → "Trust considerations",
  <https://agentskills.io/client-implementation/adding-skills-support> (read 27/09/2026); OWASP
  Agentic Top 10 2026, ASI01.
- **Done when:** the gate's tests pass, and Sam can demonstrate the hostile skill staying out of the
  catalogue.

## 03 — Excessive agency and improper output handling

- **Objective:** Sam can treat everything the model emits as untrusted input to whatever consumes it,
  and cut each skill's authority to the minimum its task needs.
- **Builds on:** lessons 01–02; llm-13 (running generated code in the sandbox).
- **Key ideas:**
  - Excessive agency is too much functionality, too many permissions or too much autonomy
    (LLM06:2025; in 2026 it climbed to LLM03, which the list calls its most consequential move); the
    fix is to remove the extra, not to ask the model to behave.
  - Model output that reaches a shell, a file path, SQL or HTML is an injection vector (LLM05:2025,
    LLM10:2026): pass arguments as argument vectors, never through a shell string; validate paths
    against an allow-list.
  - Tool misuse and unexpected code execution (ASI02, ASI05) are the agentic names for the same
    failure.
  - llama-server's experimental `--tools` can expose file read and write and shell execution to the
    model and is off by default; it stays off here.
  - Side effects need a human: a skill that writes, deletes or sends asks Sam first.
- **Recall targets:** name the three forms of excessive agency; explain why "the model decides the
  command line" is the bug.
- **Build:** `script allow-list` — a Rust crate at the planned path
  `code/src/rust/crates/msNNN_script_allowlist/` that turns a model's requested action into an
  argument vector only when it matches a skill's declared commands and path rules, and refuses
  otherwise. Tests feed hostile requests (shell metacharacters, `..` paths, an undeclared command) and
  check each is refused. Checked by `cargo test` and `cargo clippy`. Nothing is executed here.
- **Security lens:** least privilege applied to the model itself.
- **Safety:** no generated command runs in this lesson; execution happens only inside lesson 04's
  sandbox.
- **Sources:** OWASP LLM06:2025 Excessive Agency, <https://genai.owasp.org/llmrisk/llm062025-excessive-agency/>;
  OWASP LLM05:2025 Improper Output Handling,
  <https://genai.owasp.org/llmrisk/llm052025-improper-output-handling/>; OWASP Agentic Top 10 2026,
  ASI02 and ASI05; llama.cpp `tools/server/README.md` → `--tools` at b11221.
- **Done when:** the crate's tests pass on every hostile request, and Sam explains each refusal.

## 04 — A per-skill sandbox policy

- **Objective:** Sam can declare, for each skill, what its scripts may read, write and connect to, and
  enforce that with Landlock, a seccomp filter and resource limits on top of sec-04's sandbox
  launcher.
- **Builds on:** sec-04 lessons 05–07 (seccomp, Landlock, the sandbox launcher); lesson 03 (the
  allow-list);
  llm-16 lesson 02 (the skill format's optional `compatibility`, `metadata` and experimental
  `allowed-tools` fields).
- **Key ideas:**
  - Landlock lets an unprivileged process restrict itself: a ruleset of handled access rights,
    rules granting some of them beneath chosen paths (and, from ABI 4, for chosen TCP ports), then
    `landlock_restrict_self`; it needs `no_new_privs` and is inherited by children.
  - Best effort across kernels: ask the kernel its Landlock ABI version and drop the rights it does
    not know, rather than failing.
  - seccomp filters the syscalls themselves; an unprivileged process must set `no_new_privs` first.
  - Limits bound what a well-behaved script can consume: rlimits per process, a cgroup v2 memory and
    CPU ceiling per run.
  - Where the policy lives is a design choice Sam makes and records: skill metadata, a sidecar file
    beside `SKILL.md`, or a central table — the loader must refuse a skill whose scripts have no
    policy.
- **Recall targets:** list what each layer stops; explain why a skill with no policy is refused rather
  than run unrestricted.
- **Build:** `skill policy` — a Rust crate at the planned path `code/src/rust/crates/msNNN_skill_policy/`
  that reads a skill's declared policy and applies it through sec-04's launcher, using the `landlock`
  crate (0.4.7, MIT OR Apache-2.0; `cargo deny check` after adding). Tests run a harmless test
  program under a policy and check that a read outside its directory, a write where none is granted
  and a TCP connect are each denied, and that the allowed file read succeeds. Checked by `cargo test`
  and `cargo clippy`. The per-skill policies for real skills land in the inference repository.
- **Efficiency lens:** start-up cost of the sandbox per script run, measured with llm-06 lesson 01's
  method.
- **Security lens:** defence in depth: lesson 03 limits what may be asked; this lesson limits what can
  happen if the ask gets through.
- **Safety:** only harmless test programs run; Claude never runs `sudo` — every layer here works
  unprivileged.
- **Sources:** kernel "Landlock: unprivileged access control",
  <https://docs.kernel.org/userspace-api/landlock.html>, and "Seccomp BPF",
  <https://docs.kernel.org/userspace-api/seccomp_filter.html> (docs.kernel.org, 7.3.0-rc4, read
  27/09/2026); `man 7 landlock`, `man 2 seccomp`, `man 2 setrlimit` (man-pages 6.7); landlock crate
  0.4.7, <https://docs.rs/landlock/latest/landlock/>; Agent Skills specification → "Frontmatter",
  <https://agentskills.io/specification>.
- **Done when:** the crate's tests show each denied action denied and the allowed one allowed, and the
  loader refuses a skill whose scripts carry no policy.

## 05 — Supply chain and poisoning: weights, data and skills

- **Objective:** Sam can make every model file, dataset and skill package prove where it came from
  before it is loaded, and explain what poisoning looks like at each stage.
- **Builds on:** llm-01 lesson 02 (models as untrusted inputs); llm-10 (data provenance and
  scrubbing); llm-14 (safetensors read by hand); sec-05 (hashes and signatures); os-08 (signed
  repositories), where taken.
- **Key ideas:**
  - Supply chain (LLM03:2025, LLM04:2026) covers weights, adapters, datasets, libraries and skills;
    the 2026 list adds a promoted model artefact that is not what it claims to be.
  - Poisoning (LLM04:2025, LLM05:2026) plants behaviour in training or fine-tuning data; the defence is
    provenance and filtering upstream (llm-10) plus evaluation downstream (llm-13).
  - Loading is where code can run: safetensors only for third-party weights; Sam's own torch
    checkpoints only with `weights_only=True`, which narrows but does not remove the attack surface
    (PyTorch's own documentation).
  - Verify before load, fail closed: a pinned SHA-256 digest at minimum, a signature where the
    publisher offers one (model-signing supports Sigstore and key-based signatures; minisign is the
    os-08 choice for packages).
  - Skills are supply chain too (ASI04): a skill package is pinned and verified like a model.
- **Recall targets:** say what a digest proves and what a signature adds; explain why
  `weights_only=True` is not a full defence.
- **Build:** `weight manifest` — a Rust crate at the planned path
  `code/src/rust/crates/msNNN_weight_manifest/` that checks a file against a manifest of expected
  SHA-256 digests (streaming, so a multi-gigabyte file is not read into memory) and refuses to report
  success on any mismatch or missing entry. Tests use small files the test creates, a tampered copy
  and a missing entry. Checked by `cargo test` and `cargo clippy`.
- **Security lens:** fail closed — an unverifiable model is not loaded, however convenient.
- **Sources:** OWASP LLM03:2025 Supply Chain, <https://genai.owasp.org/llmrisk/llm032025-supply-chain/>;
  OWASP LLM04:2025 Data and Model Poisoning,
  <https://genai.owasp.org/llmrisk/llm042025-data-and-model-poisoning/>; PyTorch 2.14 serialization →
  "weights_only security", <https://docs.pytorch.org/docs/2.14/notes/serialization.html>; safetensors
  documentation, <https://huggingface.co/docs/safetensors/index>; model-signing 1.1.1,
  <https://github.com/sigstore/model-transparency> (Apache-2.0); `man sha256sum`.
- **Done when:** the crate's tests pass, including the tampered file, and every model Sam runs has a
  recorded digest.

## 06 — Sensitive information, hidden context and secrets in serving

- **Objective:** Sam can keep secrets out of prompts, skills and logs, treat the system prompt as
  public, and configure the local server so nothing is exposed that should not be.
- **Builds on:** lessons 01 and 05; llm-01 lesson 02 (a local-only server).
- **Key ideas:**
  - Sensitive information disclosure (LLM02) is anything private reaching an output: training data,
    retrieved documents, other users' prompts, or secrets pasted into context.
  - System prompt leakage (LLM07:2025), broadened to hidden context exposure (LLM08:2026): assume the
    system prompt, skill bodies and retrieved context can be read out, so none of them may hold a
    credential or a rule whose secrecy is the control.
  - llama-server listens on 127.0.0.1 by default; keep it there. Its CORS default reflects any
    origin with credentials allowed — fine for stateless endpoints, but a reason to set
    `--cors-origins localhost` and an API key (`--api-key-file`, never a key on the command line).
  - Endpoints and logs leak too: `/slots` is on by default and reports per-slot state and sampling
    parameters (`--no-slots` turns it off), `/metrics` reports usage, and anything the server logs is
    only as private as its log file; turn off what is not used.
- **Recall targets:** name three places a secret can leak in serving; explain why the system prompt is
  not a security boundary.
- **Build:** `server hardening` — a measurement and a configuration: Sam writes the server's launch
  configuration for the inference repository (localhost, API key from a file, CORS restricted, unused
  endpoints and the web UI off where not needed), then probes it from a second local process and
  records each check (unauthenticated request refused, `/slots` absent, foreign origin refused) in the
  verification record.
- **Security lens:** every open endpoint is attack surface; the probe proves the configuration rather
  than trusting the flags.
- **Sources:** OWASP LLM02:2025 Sensitive Information Disclosure,
  <https://genai.owasp.org/llmrisk/llm022025-sensitive-information-disclosure/>; OWASP LLM07:2025 System
  Prompt Leakage, <https://genai.owasp.org/llmrisk/llm072025-system-prompt-leakage/>; OWASP Top 10 for
  LLM Applications 2026 → LLM08:2026 Hidden Context Exposure,
  <https://genai.owasp.org/resource/owasp-genai-llm-top-10-2026/>; llama.cpp `tools/server/README.md`
  (`--host`, `--api-key-file`, `--cors-origins`, `--no-slots`, `--metrics`, "CORS") at b11221.
- **Done when:** every probe in the record behaves as configured, and no secret appears in any prompt,
  skill or log Sam inspects.

## 07 — Multi-tenant isolation: cache timing and memory reuse

- **Objective:** Sam can demonstrate, on his own server, that a shared prompt cache reveals which
  prefixes another user sent, and name the isolation a multi-user deployment would need for caches and
  GPU memory.
- **Builds on:** llm-15 lessons 07 and 11 (prefix caching, batching); lesson 01.
- **Key ideas:**
  - A cached prefix is served faster; if the cache is shared across users, response time tells an
    attacker whether a guessed prefix was recently sent — an audit found shared caches at several real
    API providers (arXiv:2502.07776).
  - vLLM tracks this as a timing side channel (CVE-2025-46570) and isolates caches with a secret,
    per-tenant `cache_salt` mixed into the first block's hash; llama-server's README (b11221) documents
    no equivalent for its shared slots and host-RAM prompt cache, so one server per trust boundary is
    the simple answer.
  - GPU memory is reused: `torch.empty` returns uninitialised memory, whose contents are whatever was
    there before; whether another process's data can survive into it on this driver is tested, not
    assumed.
  - llama.cpp's own security policy asks for tenant isolation, resource limits and sandboxing when
    models run side by side, and notes GPU side channels as a hardware risk.
- **Recall targets:** explain the prefix-cache side channel and the salt that closes it; say why "one
  server per trust boundary" is the default for this project.
- **Build:** `timing probe` — a measurement on Sam's own local server only: send a "victim" prompt from
  one client, then time guessed prefixes from another, and record the separation between hit and miss
  timings over repeated trials; then repeat with the cache off. A second experiment reads a freshly
  allocated `torch.empty` tensor after another process freed a filled one, and records what, if
  anything, is visible. Both results go in the verification record.
- **Efficiency lens:** the cost of isolation — prefill time lost when the cache is off or salted.
- **Security lens:** isolation is designed per trust boundary; caches and memory are shared state.
- **Safety:** timing and memory experiments target only Sam's own processes and server on this
  machine (the sec track's authorised-lab rule).
- **Sources:** Gu et al., "Auditing Prompt Caching in Language Model APIs", arXiv:2502.07776; vLLM
  "Security" → "Prefix Cache Timing Side-Channel Mitigation (Cache Salting)",
  <https://docs.vllm.ai/en/latest/usage/security.html> (vLLM 0.30.0, read 27/09/2026); llama.cpp
  `SECURITY.md` → "Multi-Tenant environments" at b11221; PyTorch 2.14 `torch.empty`,
  <https://docs.pytorch.org/docs/2.14/generated/torch.empty.html>.
- **Done when:** the record shows the timing separation with the cache on and its absence with the
  cache off, and the memory experiment's result, and Sam explains both.

## 08 — Unbounded consumption: limits, rate limiting and logging

- **Objective:** Sam can bound what one client can make the server consume — tokens, context, time,
  memory, requests — and see it happening in logs and metrics.
- **Builds on:** llm-15 lesson 11 (the batch and context limits found there); sec-04 lesson 04
  (cgroups v2).
- **Key ideas:**
  - Unbounded consumption (LLM10:2025, LLM06:2026) is denial of service, runaway cost and model
    extraction by volume; the controls are limits at every layer.
  - Per request: cap output tokens (llama-server's `n_predict` defaults to unlimited) and context;
    per server: slots, timeouts (`--timeout`); per client: a rate limit.
  - A token bucket allows short bursts while holding a long-run rate; it is simple to test with a fake
    clock.
  - Per process: a cgroup v2 memory ceiling — `systemd-run --user --scope -p MemoryMax=<bytes>` works
    unprivileged here, because this user's systemd manager has the memory controller delegated
    (checked 27/09/2026).
  - Logs and `/metrics` show who used what; they must not log prompt text (lesson 06).
- **Recall targets:** list the limits by layer; explain what a token bucket's two parameters control.
- **Build:** `token bucket` — a Rust crate at the planned path `code/src/rust/crates/msNNN_rate_limit/`
  implementing a per-client token bucket over an injectable clock. Tests drive the fake clock through
  bursts, refills and a client that never stops. Checked by `cargo test` and `cargo clippy`. Placing
  it in front of the server, with the cgroup ceiling and output caps, is recorded in the verification
  record.
- **Efficiency lens:** the server's memory ceiling and the rate limit are the same budget numbers
  llm-15 measured, now enforced.
- **Security lens:** availability is a security property; limits are its controls.
- **Sources:** OWASP LLM10:2025 Unbounded Consumption,
  <https://genai.owasp.org/llmrisk/llm102025-unbounded-consumption/>; llama.cpp `tools/server/README.md`
  (`-n`, `--timeout`, `--parallel`, `--metrics`) at b11221; kernel "Control Group v2" → memory
  interface files, <https://docs.kernel.org/admin-guide/cgroup-v2.html> (7.3.0-rc4);
  `man 1 systemd-run`; `man 5 systemd.resource-control` (`MemoryMax=`).
- **Done when:** the crate's tests pass, and the record shows a flooding client throttled and a
  runaway request stopped by its caps.
