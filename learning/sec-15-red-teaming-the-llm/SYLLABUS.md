# Syllabus — sec-15-red-teaming-the-llm

**Track**: sec · **Phase**: S3 · **Path**: Later · **Detail**: outline · **Prerequisites**: sec-01 (threat modelling), llm-16 (skills layer), llm-18 (secure LLM systems), llm-14 (inference in Rust)
**Status**: Planned · **Checked**: 27/09/2026 (sources re-verified by `/teach` step 3 before each lesson)

Sam's model works through Markdown skills, docs and repositories — which is exactly the surface a prompt-injection attacker aims at. This topic red-teams Sam's own model and skill loader: it builds the threat model, crafts injection and jailbreak tests, measures data-extraction risk, and turns the corpus into an automated adversarial suite that runs on every model or skill change. It is the offensive counterpart to llm-18's defences, and it runs only against Sam's own systems. Every test targets Sam's model and loader; no third-party service is attacked. It is an **outline** topic because S3 is a far phase: its builds are sketched and its sources, checked on 27/09/2026, are re-verified when the topic opens.

| # | Lesson | Size | Build | Lenses |
| --- | --- | --- | --- | --- |
| 01 | The LLM threat model for a skills system | 2–3 sittings | no | Security |
| 02 | Prompt injection through skills, docs and repositories | multi-session build | yes — injection-corpus | Safety |
| 03 | Jailbreak and data-extraction testing | 2–3 sittings | yes — extraction-set | Safety |
| 04 | Building an adversarial test suite | multi-session build | yes — adversarial-suite | Efficiency |
| 05 | Defences and their limits | 2–3 sittings | no | Security |

---

## 01 — The LLM threat model for a skills system

- **Objective:** Sam can map the OWASP Top 10 for LLM Applications onto his own skill loader, docs and repositories.
- **Builds on:** sec-01's threat modelling (STRIDE, data-flow diagrams); llm-16's skills layer; llm-18's threat model.
- **Key ideas:**
  - The 2025 list includes LLM01 Prompt Injection, LLM02 Sensitive Information Disclosure, LLM03 Supply Chain, LLM04 Data and Model Poisoning, LLM06 Excessive Agency and LLM07 System Prompt Leakage — each has a home in a skills system. The 2025 IDs are this repository's citation key; the 2026 edition (03/08/2026) re-ranks them (LLM01 and LLM02 unchanged, supply chain LLM04, poisoning LLM05, excessive agency LLM03, system prompt leakage broadened to hidden context exposure LLM08), mapped in full in `llm-18-secure-llm-systems` lesson 01.
  - Trust boundaries: a skill file, a retrieved document and a repository are all inputs that can carry an attacker's instructions.
  - Assets to protect: the system prompt and skill contents, any secrets the loader holds, and the actions skill scripts can take.
  - The OWASP Top 10 for Agentic Applications for 2026 adds the skill loop's own risks.
- **Recall targets:** which OWASP LLM entries apply to a skills loader; where the trust boundaries sit in Sam's architecture.
- **Build:** none (a threat-model note and data-flow diagram over the skills architecture, drawn on sec-01's method).
- **Security lens:** the whole lesson — naming assets, threats and trust boundaries before testing.
- **Sources:** (checked 27/09/2026; re-verify when S3 opens) OWASP Top 10 for LLM Applications 2025 (<https://genai.owasp.org/llm-top-10/>; project page <https://owasp.org/www-project-top-10-for-large-language-model-applications/>); OWASP Top 10 for LLM Applications 2026 (03/08/2026), <https://genai.owasp.org/resource/owasp-genai-llm-top-10-2026/>; OWASP Top 10 for Agentic Applications for 2026 (09/12/2025), <https://genai.owasp.org/resource/owasp-top-10-for-agentic-applications-for-2026/>.
- **Done when:** Sam's note maps each relevant OWASP LLM entry to a concrete part of his skills system and its trust boundaries.

---

## 02 — Prompt injection through skills, docs and repositories

- **Objective:** Sam can build a corpus of prompt-injection test inputs that exercise his skill loader's trust boundaries.
- **Builds on:** lesson 01's threat model; llm-16's skill discovery and loading; llm-17's retrieval (injected instructions in retrieved documents).
- **Key ideas:**
  - Direct injection (in the user turn) versus indirect injection (in a skill file, a retrieved document, or repository content the model reads).
  - Instruction/data confusion: the model treating attacker-supplied text as instructions.
  - The skill loader and doc guidance are the delivery path — the corpus targets each entry point.
  - A test input is defensive: it probes whether the system is fooled, it is not a weapon against anyone else.
- **Recall targets:** direct versus indirect injection; why retrieved documents and skill files are injection vectors.
- **Build:** a corpus of injection test inputs for the skill loader, organised by entry point, with the expected safe behaviour for each. Planned code path: a test corpus in the inference repository (created when that build starts), or a lesson-scale harness under `code/src/rust/crates/` (planned).
- **Safety:** tests run only against Sam's own model and skill loader; generated code from the model is never executed outside the sec-04 sandbox.
- **Sources:** (checked 27/09/2026; re-verify when S3 opens) OWASP LLM01 Prompt Injection 2025 (<https://genai.owasp.org/llm-top-10/>); llm-17's injected-instructions lesson and llm-18's threat model (repo topics).
- **Done when:** the corpus covers each entry point and each case states the behaviour that would count as a pass or a failure.

---

## 03 — Jailbreak and data-extraction testing

- **Objective:** Sam can measure how susceptible his own model is to jailbreaks and to leaking its system prompt, skill contents or training data.
- **Builds on:** lesson 02's corpus; llm-18's sensitive-information-disclosure and system-prompt-leakage threats.
- **Key ideas:**
  - Jailbreaks aim to elicit output the model's policy should refuse; measure the rate, do not just find one.
  - Data extraction targets the system prompt (LLM07:2025, LLM08:2026), skill contents, and memorised training data (LLM02 in both editions).
  - Scoring: a susceptibility metric over a set, so a change can be shown to help or hurt.
  - This is testing of Sam's own model; results are for hardening, not publication of a technique against someone else's system.
- **Recall targets:** what a jailbreak versus a data-extraction test is aiming at; why a rate over a set beats a single anecdote.
- **Build:** an adversarial prompt set run against Sam's own model, scoring jailbreak and extraction outcomes. Planned: extends the lesson 02 harness.
- **Safety:** Sam's own model only; no attempt against any third-party model or service.
- **Sources:** (checked 27/09/2026; re-verify when S3 opens) OWASP LLM02 Sensitive Information Disclosure and LLM07 System Prompt Leakage 2025 (<https://genai.owasp.org/llm-top-10/>).
- **Done when:** Sam produces a susceptibility score for his own model over a defined set and can say what would move it.

---

## 04 — Building an adversarial test suite

- **Objective:** Sam can turn the injection and jailbreak corpus into an automated suite that runs on every model or skill change.
- **Builds on:** lessons 02–03; llm-14's inference server (the thing under test); llm-18's defences (what the suite verifies).
- **Key ideas:**
  - Each case gets a pass/fail assertion, so the suite is a gate, not a demo.
  - Running it CI-like on each model or skill change tracks regressions in safety, the way the code gates track correctness.
  - Scoring over time shows whether a defence held; a new failure is a regression to triage.
  - CI has no GPU, so the suite runs against a small model or locally with recorded evidence (`GAPS.md` → "CI has no GPU").
- **Recall targets:** why safety needs a regression suite like correctness does; what makes a case a gate rather than a demo.
- **Build:** an adversarial test runner that executes the corpus against the model and asserts outcomes. Planned code path: the runner in the inference repository (created when that build starts), or a lesson-scale runner under `code/src/rust/crates/` (planned).
- **Efficiency lens:** measure the suite's run time and cost; keep a fast subset for every change and a full run less often.
- **Sources:** (checked 27/09/2026; re-verify when S3 opens) OWASP Top 10 for LLM Applications 2025 (<https://genai.owasp.org/llm-top-10/>); llm-14 and llm-18 (repo topics).
- **Done when:** the suite runs against Sam's model, asserts pass/fail per case, and a deliberately weakened defence makes it fail.

---

## 05 — Defences and their limits

- **Objective:** Sam can name the defences against these attacks and explain why none is complete.
- **Builds on:** the whole topic; llm-18's per-skill Landlock/seccomp policy; sec-04's sandbox launcher.
- **Key ideas:**
  - Input and output filtering, instruction/data separation, and least-privilege tool access reduce but do not eliminate injection.
  - Privilege separation for skill scripts (per-skill Landlock/seccomp over sec-04's sandbox) limits the blast radius of a successful injection.
  - Human-in-the-loop for high-impact actions bounds excessive agency (LLM06:2025, LLM03:2026).
  - Defence in depth: no single control is trusted, because prompt injection has no complete fix today.
- **Recall targets:** which defences reduce injection risk; why privilege separation matters when filtering fails.
- **Build:** none (a defences note cross-referencing llm-18 and sec-04, mapping each defence to the threat it bounds).
- **Security lens:** the whole lesson — matching each control to its threat and stating its limit.
- **Sources:** (checked 27/09/2026; re-verify when S3 opens) OWASP LLM01 Prompt Injection and LLM06 Excessive Agency 2025 (<https://genai.owasp.org/llm-top-10/>); llm-18 and sec-04 (repo topics); kernel Landlock (<https://docs.kernel.org/userspace-api/landlock.html>).
- **Done when:** Sam's note pairs each defence with the threat it bounds and states where it stops working.
