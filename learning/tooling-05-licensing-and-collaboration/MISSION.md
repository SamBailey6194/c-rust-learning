# Mission — tooling-05-licensing-and-collaboration

**Started**: not yet · **Family**: tooling · **Phase**: P1 · **Milestone**: not yet allocated

## Why

_Drafted from Sam's planning conversation of 27/09/2026 — confirm or rewrite in your own words at
the first lesson._

Sam is happy to reuse existing desktops, and said that "friends and family could build the TUI,
file manager etc." — so Syntek OS's tools will have contributors other than him, and the licence
has to be settled before the first of them arrives. He has since decided that licences are chosen
per repository: this learning repository stays GPL-2.0-only, and each product repository picks its
own from an approved list, under inbound rules he fixed on 27/09/2026. The same literacy runs
through the rest of the plan: a downstream kernel carries GPLv2 source obligations once it is
distributed, a Syntek OS image bundles many licences at once, and the language model he wants to
build from scratch will be trained on code whose licences and terms travel with it. This topic
makes those calls informed and written down, rather than guessed.

## Can do it when

- Sam can explain copyleft against permissive and list what GPL-2.0-only requires when a binary is
  distributed.
- Sam can say whether Apache-2.0, GPL-3.0 or CDDL code can be combined with GPL-2.0-only code, read
  a `cargo deny` rejection, and write a per-crate exception that cites its ADR.
- Sam can write SPDX licence expressions, place identifier lines correctly, and say what REUSE
  would add to a repository.
- Sam can read the licence and terms of a model or dataset and record them in a ledger row.
- Sam can choose a licence for a product repository from its constraints and record it as an ADR.
- Sam can set up contributor infrastructure — guidelines, sign-off, labels, required checks — and
  explain the failure each setting prevents.
- Sam can review a contributor's pull request locally, with licence and sign-off checks and
  comments that give their reasons.
- Sam can say what an SBOM records and what it does not, write a minimal SPDX document that matches
  a crate graph, and keep a ledger row for data, weights and firmware.

## Parked for later

- Sourcing, filtering and attributing training data — `llm-10`.
- The GUI toolkit's licence decision — `ui-08`.
- Licences of the crates on the inference path (candle, safetensors, tokenizers) — `llm-14`.
- ZFS under the CDDL and the NAS profile's kernel pin — `os-13`.
- Security tracking and release engineering for Syntek OS — `os-16`.
