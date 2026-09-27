# Mission — os-17-local-model-integration

**Started**: not yet · **Family**: os · **Phase**: P6 · **Milestone**: not yet allocated

## Why

_Drafted from Sam's planning conversation of 27/09/2026 — confirm or rewrite in your own words at
the first lesson._

Sam's plan runs from C and Rust through kernel development and his own distribution to a language
model built in C, Rust and Python that works through Markdown skills, workflows and documentation,
and uses CPU, RAM, GPU, VRAM and cache efficiently and securely. The planning conversation named the
point where those two tracks meet as the destination: "a Syntek OS that runs your own efficient
local model with skills built in". This topic builds that meeting point once both halves exist:
the model and its skills shipped as signed Syntek OS packages, run as a supervised service inside a
measured budget, with each skill confined by its own policy.

## Can do it when

- Sam's recipe builds the inference server offline and reproducibly, with its licence exceptions
  recorded.
- A tampered model package is refused, and a valid one installs within the disk budget.
- The inference server runs as a supervised service that holds its memory budget under load.
- A skill that reaches outside its Landlock policy is denied and the denial is logged.
- Sam's TUI streams the model's answers and its screen tests pass.
- The local model's resource budget is measured on the server edition in QEMU and compared with the
  `llm-01` baseline.

## Parked for later

- GPU passthrough into a guest — out of scope while this machine's only GPU drives the desktop.
- A GUI front-end — the UI track (`ui-08-gui-foundations`, `ui-09-gui-tools`).
- Serving several users or adapters at once — `llm-18-secure-llm-systems` (multi-tenant isolation)
  and `llm-20-post-training-and-adapters` (multi-adapter serving).
