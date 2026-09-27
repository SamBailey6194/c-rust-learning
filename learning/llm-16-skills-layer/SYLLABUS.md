# Syllabus — llm-16-skills-layer

**Track**: llm · **Phase**: L5 · **Path**: Core · **Detail**: full · **Prerequisites**: llm-01 (lessons 05–06: the three hand-written skills and the gap log); llm-14 (inference in Rust); llm-15 lesson 05 (KV bytes per token) and lesson 07 (prefix caching) recommended; P3 including async
**Status**: Planned · **Checked**: 27/09/2026 (sources re-verified by `/teach` step 3 before each lesson)

The mission says the model "works through Markdown skills, workflows and documentation"; this topic
builds that layer. Sam decided on skills, not agents: a small model follows one focused set of
instructions better than it survives a long agent loop, and a short context keeps the KV cache small.
The skill format already exists in front of him — this repository's `.claude/skills/` is its working
prototype — and llm-01 wrote three skills by hand and logged where a local model failed them. Here
the loading becomes code: discovery, a catalogue, activation, a context budget measured in tokens and
bytes, workflows and doc guidance as skill resources, then an automatic replay of llm-01's gap log and
the first skill-use training data. **Where the work lands:** small parsers and budget tools are lesson
crates at planned paths under `code/src/rust/crates/`; the skill loader wired into Sam's inference
server and the replay harness land in the inference repository (started by llm-01 lesson 05, which
already keeps the skills and gap log there), and the skill-use training data in the model-training
repository (created when this build starts, as in llm-10). Skill scripts are
never executed in this topic: running them needs the sandbox policy of llm-18. The topic feeds
llm-17 (retrieval over the same Markdown), llm-18 (the threat model of the skill loop), llm-20
(skill-use traces for post-training) and os-17 (skills shipped as a Syntek OS package).

| # | Lesson | Size | Build | Lenses |
| --- | --- | --- | --- | --- |
| 01 | Skills, not agents, for a small model | 1 sitting | no | Efficiency |
| 02 | The skill file format | 1 sitting | yes — skill lint | Security |
| 03 | Discovery and the skill catalogue in Rust | 2–3 sittings | yes — skill catalogue | Efficiency, Security |
| 04 | Activation and the context budget | 2–3 sittings | yes — skill budget | Efficiency |
| 05 | Workflows and doc guidance as skill resources | 1 sitting | no | Efficiency |
| 06 | Replaying the gap log through the Rust loader | multi-session build | yes — gap-log replay | Efficiency, Safety |
| 07 | From gap log to skill-use training data | 2–3 sittings | yes — skill-use traces | Security |

---

## 01 — Skills, not agents, for a small model

- **Objective:** Sam can explain progressive disclosure, why it suits a small local model better than
  an open-ended agent loop, and what it costs and saves in tokens and KV bytes.
- **Builds on:** llm-01 lessons 05–06 (skills written and run by hand); llm-15 lesson 05 (KV bytes per
  token); Sam's daily use of this repository's `/teach`, `/research`, `/handoff` and `/wait-what`
  skills.
- **Key ideas:**
  - An agent loop interleaves reasoning, tool calls and observations until the task ends
    (ReAct, arXiv:2210.03629); every turn stays in the context, so a long loop means a long,
    growing context.
  - Progressive disclosure loads skills in three tiers: the catalogue (name and description, loaded at
    start for every skill), the instructions (the whole SKILL.md body, loaded when activated) and the
    resources (scripts, references and assets, loaded only when needed).
  - Long contexts are not used evenly: models retrieve information at the start or end of a long
    input better than from the middle (arXiv:2307.03172) — a short, focused context is a quality
    decision as well as a memory one.
  - Every token in the context costs KV bytes per token (llm-15 lesson 05) for as long as the
    sequence lives, and prefill time before the first token.
  - The decision is recorded in
    `project-management/src/08-DECISIONS/ADR-MS001-LLM-SKILLS-NOT-AGENTS-27-09-2026.md`; this topic is
    where it is tested.
- **Recall targets:** name the three tiers and when each loads; argue for skills over an agent loop
  for a ~100M or 7B-class local model in two sentences, with the KV cost in them.
- **Build:** none — the output is Sam's note, with a worked token and KV-byte estimate for the
  catalogue of this repository's four skills.
- **Efficiency lens:** estimated tokens and KV bytes for tier 1 (all skills) against tier 2 (one
  skill), using llm-15's formula for llm-01's model.
- **Sources:** Agent Skills specification → "Progressive disclosure", <https://agentskills.io/specification>
  (read 27/09/2026); Yao et al. (ReAct), arXiv:2210.03629; Liu et al. ("Lost in the Middle"),
  arXiv:2307.03172; this repository's `.claude/skills/`;
  `project-management/src/08-DECISIONS/ADR-MS001-LLM-SKILLS-NOT-AGENTS-27-09-2026.md`.
- **Done when:** Sam's note states the tiers, the argument and the estimate unaided.

## 02 — The skill file format

- **Objective:** Sam can write and check a SKILL.md against the Agent Skills specification — the
  frontmatter fields, their limits and the body's size — and say which rules this repository's skills
  follow and which they bend.
- **Builds on:** lesson 01; Sam's Markdown and YAML from Nix and this repository.
- **Key ideas:**
  - A skill is a directory with a `SKILL.md`: YAML frontmatter between `---` lines, then a Markdown
    body; optional `scripts/`, `references/` and `assets/` sit beside it.
  - `name` is required: 1–64 characters of lowercase letters, digits and hyphens, no leading, trailing
    or doubled hyphen, and it matches the directory name. `description` is required: 1–1024
    characters, saying what the skill does and when to use it.
  - Optional fields: `license`, `compatibility` (up to 500 characters), `metadata` (string to
    string) and the experimental `allowed-tools`.
  - Size guidance: keep the body under about 5000 tokens and the file under 500 lines, and keep file
    references one level deep from `SKILL.md`.
  - The description is what the model matches against: specific keywords beat a vague summary.
- **Recall targets:** list the two required fields and their limits from memory; spot what is wrong
  with three deliberately broken frontmatter blocks.
- **Build:** `skill lint` — a Rust crate at the planned path `code/src/rust/crates/msNNN_skill_lint/`
  that reads one `SKILL.md`, splits frontmatter from body, and reports every rule it breaks (name
  characters and length, name against directory, description length, body lines). The frontmatter
  here is flat `key: value` pairs and folded scalars; parse it by hand or pick a YAML crate only
  after `cargo deny check` (serde_yaml 0.9.34 is marked deprecated on crates.io). Tests use fixture
  skills written in the test, including broken ones. Checked by `cargo test` and `cargo clippy`, then
  run against this repository's four skills.
- **Security lens:** a skill file is input from whoever wrote it; the linter treats it as untrusted
  text — bounded reads, no panics on malformed YAML, no path in a reference allowed to climb out of
  the skill directory.
- **Sources:** Agent Skills specification → "Directory structure", "SKILL.md format", "Progressive
  disclosure", "File references", <https://agentskills.io/specification> (read 27/09/2026); Claude
  Code "Extend Claude with skills", <https://code.claude.com/docs/en/skills> (read 27/09/2026);
  crates.io entry for serde_yaml (0.9.34+deprecated); `code/docs/RUST-CODING-PRINCIPLES.md` →
  Section 3.
- **Done when:** the crate's tests pass, and its report on this repository's four skills is read and
  explained by Sam, including any rule they break on purpose.

## 03 — Discovery and the skill catalogue in Rust

- **Objective:** Sam can build the tier-1 catalogue from a set of skill directories, with precedence
  between scopes, lenient validation and a trust gate, and render it for a model.
- **Builds on:** lesson 02; P3 (error handling, iterators, file I/O).
- **Key ideas:**
  - Discovery scans known scopes (a project's skill directory and a user-level one) for directories
    holding a `SKILL.md`, with bounded depth; when two share a name, the project-level skill wins.
  - Parse leniently, record diagnostics: a name that does not match its directory is a warning; a
    missing description or unparseable YAML skips the skill.
  - Each record needs at least name, description and location; the body can be read at activation
    time to save memory.
  - The catalogue is name, description and location per skill, in a structured block with a short
    instruction on how to activate; each skill adds roughly 50–100 tokens. No skills means no
    catalogue at all.
  - Project-level skills may come from an untrusted repository; load them only after the user has
    trusted the project.
- **Recall targets:** state the precedence rule and why a skill without a description is skipped;
  explain why an untrusted repository's skills are gated.
- **Build:** `skill catalogue` — a Rust crate at the planned path
  `code/src/rust/crates/msNNN_skill_catalogue/` that discovers skills under given roots, applies
  precedence and lenient validation, and renders the catalogue with a token estimate. Tests build
  temporary skill trees (duplicates across scopes, a nameless skill, a skill with bad YAML, an
  untrusted scope) and check the catalogue and the diagnostics. Checked by `cargo test` and
  `cargo clippy`.
- **Efficiency lens:** catalogue size in tokens for this repository's skills (by the
  `llama-server` `/tokenize` endpoint or llm-11's tokeniser), set against the estimate from lesson 01.
- **Security lens:** trust gating for project-level skills and bounded scanning are the first
  controls against prompt injection through skills (llm-18).
- **Sources:** Agent Skills "Adding skills support" → "Step 1: Discover skills" (including "Trust
  considerations"), "Step 2: Parse SKILL.md files", "Step 3: Disclose available skills to the
  model", <https://agentskills.io/client-implementation/adding-skills-support> (read 27/09/2026);
  llama.cpp `tools/server/README.md` → `POST /tokenize` at release b11221,
  <https://github.com/ggml-org/llama.cpp> (MIT); `code/docs/TESTING.md` → Section 2.
- **Done when:** the crate's tests pass, and its catalogue for this repository's skills matches Sam's
  predicted token count within a stated margin.

## 04 — Activation and the context budget

- **Objective:** Sam can activate a skill into a conversation — body only or whole file, wrapped and
  deduplicated — and keep the whole context inside a stated token and KV-byte budget.
- **Builds on:** lesson 03; llm-15 lessons 05 and 07 (KV arithmetic, prefix caching); llm-14's
  sampling.
- **Key ideas:**
  - Activation is model-driven (the model picks a skill from the catalogue) or user-explicit (a
    slash command); a dedicated activation tool constrains the choice to the valid names.
  - A small model is helped by constraint: llama-server's `json_schema` (or a `grammar`) can force
    the activation reply to one of the catalogue's names, so it cannot invent a skill.
  - Wrap activated content in identifying tags, list bundled resources without reading them, skip a
    skill already active, and never let context trimming drop skill instructions.
  - The budget is arithmetic: system prompt + catalogue + active skills + conversation must fit the
    context, and its KV bytes must fit beside the weights in the free VRAM.
  - Order for reuse: the stable part (system prompt, catalogue) first, so prefix caching serves it
    across requests (llm-15 lesson 07).
- **Recall targets:** state what an activation adds to the context and in what order; compute the
  headroom left for conversation under a given context and VRAM budget.
- **Build:** `skill budget` — a Rust crate at the planned path `code/src/rust/crates/msNNN_skill_budget/`
  that, given a catalogue, a set of active skills with token counts, a context limit and the KV bytes
  per token from llm-15's kv-budget crate, reports the headroom or the first item that breaks the
  budget, and deduplicates repeat activations. Tests use made-up token counts and check the
  arithmetic and the dedup. Checked by `cargo test` and `cargo clippy`. Wiring activation into the
  inference server is lesson 06's work in the inference repository.
- **Efficiency lens:** tokens and KV bytes per tier for a real session, and prefill time with the
  catalogue cached against uncached (llm-15 lesson 07's method).
- **Sources:** Agent Skills "Adding skills support" → "Step 4: Activate skills" and "Step 5: Manage
  skill context over time", <https://agentskills.io/client-implementation/adding-skills-support>;
  llama.cpp `tools/server/README.md` → `json_schema`, `grammar` and `cache_prompt` on
  `POST /completion` at release b11221.
- **Done when:** the crate's tests pass, and Sam can state the budget for llm-01's model at two
  context lengths, including how many skills fit at once.

## 05 — Workflows and doc guidance as skill resources

- **Objective:** Sam can turn a multi-step procedure and a folder's guidance into Markdown a small
  model can follow, as tier-3 resources a skill points to, without restating rules in two places.
- **Builds on:** lessons 02–04; this repository's own conventions — workflows as `STEPS.md` and
  `CHECKLIST.md`, and `CONTEXT.md`/`CLAUDE.md` pairs with "route, don't restate".
- **Key ideas:**
  - A workflow is ordered steps, each with a "done when" line: the shape a small model can tick off,
    rather than a paragraph it must interpret.
  - Doc guidance says where things live and what the rules are; one owner per rule, others route to
    it — so a skill loads one owner file, not three copies that may disagree.
  - Resources sit one level below the skill and are loaded only when a step needs them; a long
    procedure becomes a reference file, not a longer `SKILL.md`.
  - The same Markdown is a retrieval corpus for llm-17: headings and short sections serve both.
- **Recall targets:** say when content belongs in the skill body, a reference file or the folder's
  guidance; explain why duplicated rules hurt a small model more than a large one.
- **Build:** none — the output is one of llm-01's skills refactored so its long procedure moves into
  a reference file in workflow shape, done in the inference repository where llm-01 keeps its skills,
  with the before and after token counts in the note.
- **Efficiency lens:** tier-2 tokens before and after the refactor.
- **Sources:** Agent Skills specification → "Progressive disclosure" and "File references",
  <https://agentskills.io/specification>; this repository's `code/workflows/01-c-exercise/` (a
  workflow's four files) and `learning/CLAUDE.md` (a guidance file).
- **Done when:** the refactored skill passes the lesson 02 linter, and its tier-2 token count went
  down without losing a step.

## 06 — Replaying the gap log through the Rust loader

- **Objective:** Sam can rerun every gap llm-01 recorded by hand as an automatic, repeatable test of
  the Rust skill loader against a local model, and compare the results with the manual ones.
- **Builds on:** lessons 03–05; llm-01 lesson 06 (the gap log, each entry recorded with its model
  digest and settings); llm-14 (the Rust inference path) and P3 async (driving a local server).
- **Key ideas:**
  - A gap entry is a test case: the task, the skills available, the skill that should have been
    chosen, what "followed" means, and the model and settings used.
  - A replay fixes everything but the variable under test: the same model digest, quantisation,
    context, sampling settings and seed; otherwise a change in the result is noise.
  - Three outcomes per case: recognised the right skill, loaded it, followed it — the chain llm-20
    trains on.
  - Replays that would run a skill's script stop at "the script would run here"; execution waits for
    llm-18's per-skill sandbox policy.
- **Recall targets:** name what must be pinned for a replay to be comparable; say which of the three
  outcomes llm-01's gaps failed most, and why that matters for training.
- **Build:** `gap-log replay` — in the inference repository (created when this build starts), a harness
  that reads the gap log, builds catalogue and activation with the loader from lessons 03–04, sends
  each case to a local llama-server (or through llm-14's FFI path), and records the three outcomes
  per case. Checked by running it twice and getting the same outcomes, and by a table comparing it
  with llm-01's manual results in the verification record under `project-management/src/10-PROGRESS/`.
- **Efficiency lens:** tokens, time to first token and KV bytes per case, and total replay time.
- **Safety:** no skill script executes during a replay; generated code is logged, not run, until the
  llm-18 sandbox exists.
- **Sources:** Agent Skills "Adding skills support" → Steps 3–4,
  <https://agentskills.io/client-implementation/adding-skills-support>; llama.cpp
  `tools/server/README.md` → `POST /completion` (`seed`, `cache_prompt`, `timings`) at release
  b11221.
- **Done when:** the replay is repeatable run to run, and its results are compared case by case with
  llm-01's manual log.

## 07 — From gap log to skill-use training data

- **Objective:** Sam can turn replayed cases into skill-use traces — recognise, load, follow — in a
  documented format, split them for training and evaluation, and keep them free of secrets and
  unlicensed text.
- **Builds on:** lesson 06; llm-10 (licences, secret and PII scrubbing, dataset cards); llm-13
  (held-out sets and contamination).
- **Key ideas:**
  - A trace records the conversation up to the decision, the catalogue shown, the skill chosen, the
    activation, and the steps that followed — failures corrected by hand become positive examples.
  - Hold out whole tasks, not random lines, so evaluation measures skill use on unseen work.
  - Traces inherit the licence of everything quoted in them; skills and outputs written by Sam are
    his to license, third-party text needs checking.
  - Scrub before storing: paths, tokens and keys in a trace are leaks waiting for a training run.
  - The dataset gets a short card: what, where from, how split, known gaps.
- **Recall targets:** describe one trace's fields; explain why the split is by task; name two things
  a scrubber must catch in a skill-use trace.
- **Build:** `skill-use traces` — in the model-training repository, a converter from replay results to a
  documented trace format with a task-level split, a scrub pass and a dataset card. Checked by tests
  on synthetic cases (including planted fake secrets the scrub must catch) and by the card's counts
  matching the files. Datasets are never committed to this repository.
- **Security lens:** a planted fake token that survives the scrub fails the lesson; the scrubber is
  tested, not assumed (llm-10's method).
- **Sources:** Agent Skills "Adding skills support" (the catalogue and activation shapes the traces
  record), <https://agentskills.io/client-implementation/adding-skills-support>; Mitchell et al.,
  "Model Cards for Model Reporting", arXiv:1810.03993 (the reporting habit applied to a dataset card);
  Hugging Face "Chat templates", <https://huggingface.co/docs/transformers/main/en/chat_templating>
  (transformers 5.17.0, read 27/09/2026).
- **Done when:** the converter's tests pass, the split is by task, and the card describes the dataset
  llm-20 will train on.
