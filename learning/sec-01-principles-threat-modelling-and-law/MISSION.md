# Mission — sec-01-principles-threat-modelling-and-law

**Started**: not yet · **Family**: sec · **Phase**: S1 · **Milestone**: not yet allocated

## Why

_Drafted from Sam's planning conversation of 27/09/2026 — confirm or rewrite in your own words at
the first lesson._

Sam asked whether the project also needs "pentesting and cybersecurity lessons" and the answer was
yes. He is building things that must be **secure**: a downstream kernel, an independent Syntek OS
(with a router edition the planning conversation flagged as a real security responsibility), and a
language model whose brief is to be efficient "while being secure". Security cannot be bolted on at
the end of any of those, so it starts here, with the way of thinking: what is being protected, from
whom, and what a defence is worth. This topic also fixes the law and the ethics — authorised,
isolated work only — that make the later offensive lessons legitimate rather than reckless. It is
the source of the Security lens every kernel, OS and LLM milestone will carry.

## Can do it when

- Sam can state the CIA properties for one of his own assets and name the principle a proposed
  control serves.
- Sam can draw a data-flow diagram with trust boundaries and run a STRIDE pass over it.
- Sam can write a milestone's three-line threat model from that pass.
- Sam can state what the UK Computer Misuse Act 1990 makes an offence and why authorisation and a
  defined scope bound every offensive lesson in this track.
- Sam can describe a coordinated-disclosure process and name this repository's private-report
  channel.

## Parked for later

- The Linux security model (users, capabilities, namespaces, seccomp, LSMs) — `sec-04`.
- Applied cryptography (hashes, signatures, key management) — `sec-05`.
- Building and running an isolated lab, and any offensive technique — `sec-06` onwards.
