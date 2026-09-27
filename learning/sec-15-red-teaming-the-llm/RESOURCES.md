# Resources — sec-15-red-teaming-the-llm

| Lesson | Primary source (pinned) | House guide | Code |
| --- | --- | --- | --- |
| 01 The LLM threat model for a skills system | OWASP Top 10 for LLM Applications 2025 (<https://genai.owasp.org/llm-top-10/>; <https://owasp.org/www-project-top-10-for-large-language-model-applications/>); OWASP Top 10 for Agentic Applications for 2026 (<https://genai.owasp.org/resource/owasp-top-10-for-agentic-applications-for-2026/>) | — | — (threat-model note in this topic folder) |
| 02 Prompt injection through skills, docs and repositories | OWASP LLM01 Prompt Injection 2025 (<https://genai.owasp.org/llm-top-10/>); llm-17 injected-instructions, llm-18 (repo topics) | — | the inference repository test corpus (created when that build starts), or `code/src/rust/crates/msNNN_injection_corpus/` (planned) |
| 03 Jailbreak and data-extraction testing | OWASP LLM02 and LLM07 2025 (<https://genai.owasp.org/llm-top-10/>) | — | extends the lesson 02 harness |
| 04 Building an adversarial test suite | OWASP Top 10 for LLM Applications 2025 (<https://genai.owasp.org/llm-top-10/>); llm-14, llm-18 (repo topics) | — | the inference repository (created when that build starts), or `code/src/rust/crates/msNNN_adversarial_suite/` (planned) |
| 05 Defences and their limits | OWASP LLM01 and LLM06 2025 (<https://genai.owasp.org/llm-top-10/>); kernel Landlock (<https://docs.kernel.org/userspace-api/landlock.html>); llm-18, sec-04 (repo topics) | — | — (defences note in this topic folder) |
