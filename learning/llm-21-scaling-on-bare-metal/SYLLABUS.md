# Syllabus — llm-21-scaling-on-bare-metal

**Track**: llm · **Phase**: L6 · **Path**: Later · **Detail**: outline · **Prerequisites**: llm-12 (pre-training the ~100M model on this machine); llm-19 lesson 06 (the base-architecture ADR); a compute-budget ADR, not yet written (`GAPS.md` → "L6 compute budget and provider not chosen"); llm-18 lesson 05 (verifying weights) recommended
**Status**: Planned · **Checked**: 27/09/2026 (sources re-verified by `/teach` step 3 before each lesson)

The ~100M model is sized to train on this RTX 2080 Ti (llm-12); the ~1B base is sized for rented
multi-GPU machines, and lesson 01 computes by how much it outgrows one card. This topic is how to rent
that capacity without wasting money, data or trust: estimate the compute and
its cost before spending, learn data parallelism and sharding by rehearsing them locally with several
CPU processes (and the one GPU) before any machine is rented, treat the rented machine as hostile
ground for secrets and data, survive failures with sharded checkpoints, and finish with a release
that has a model card, a licence, evaluations and a signature. It is an **outline**: L6 is a far
phase, and providers, prices and library features move, so objectives, key ideas and sources are
checked on 27/09/2026 and the builds are sketched; no price is recorded — every lesson teaches the
estimate and says to check prices on the day. **Where the work lands:** training code, launch
scripts and checkpoints in the model-training repository (created when this build starts); estimates and run
records in the verification record under `project-management/src/10-PROGRESS/`; the budget and
provider choice as an ADR in `project-management/src/08-DECISIONS/`; the released model in the
model-release repository (created when the release build starts).

| # | Lesson | Size | Build | Lenses |
| --- | --- | --- | --- | --- |
| 01 | From FLOPs to GPU-hours: estimating a run | 1 sitting | yes — budget ADR | Efficiency |
| 02 | Data parallelism with DDP, rehearsed locally | 2–3 sittings | yes — DDP rehearsal | Efficiency |
| 03 | Sharding with ZeRO and FSDP, rehearsed locally | 2–3 sittings | yes — FSDP rehearsal | Efficiency |
| 04 | Interconnects and collectives (reading) | 1 sitting | no | Efficiency |
| 05 | Renting safely: secrets, data residency and wiping | 1 sitting | yes — rental checklist | Security, Safety |
| 06 | Checkpointing and fault tolerance at scale | 2–3 sittings | yes — resume drill | Efficiency, Security |
| 07 | From run to release: model card, licence, evaluation | 2–3 sittings | yes — release bundle | Security |

---

## 01 — From FLOPs to GPU-hours: estimating a run

- **Objective:** Sam can estimate the training compute of a planned run, turn it into GPU-hours under
  a stated utilisation, and write the budget ADR that decides whether and where to rent.
- **Builds on:** llm-12's compute estimation for the ~100M run; llm-19 lesson 06 (the chosen size
  and token budget).
- **Key ideas:**
  - Training compute is about `6 * N * D` FLOPs, with `N` the non-embedding parameters and `D` the
    training tokens (arXiv:2001.08361, Sections 1.3 and 2.1); Chinchilla's Table 3 gives the
    compute-optimal `D` for a size (arXiv:2203.15556).
  - `GPU-hours = FLOPs / (peak_flops_per_second * utilisation * 3600)`; utilisation is never 100% —
    "model FLOPs utilisation" is the ratio reported for real systems (arXiv:2211.05102).
  - The local ~100M run gives Sam his own measured utilisation on this card, the honest starting
    point for the estimate.
  - Cost = GPU-hours times the hourly price on the day, plus storage, transfer and failed runs; prices are
    checked when the decision is made, never tabled.
- **Recall targets:** compute FLOPs and GPU-hours for a stated `N`, `D` and utilisation; name what
  the estimate leaves out.
- **Build:** outline — `budget ADR`: the compute-budget ADR in `project-management/src/08-DECISIONS/`
  (closing the `GAPS.md` open question), with the estimate, its assumptions and a stop-loss.
- **Efficiency lens:** estimated against measured utilisation from the local run.
- **Sources:** (checked 27/09/2026; re-verify when L6 opens) Kaplan et al., arXiv:2001.08361,
  Sections 1.3 and 2.1; Hoffmann et al., arXiv:2203.15556, Table 3; Pope et al., arXiv:2211.05102
  (MFU); `project-management/workflows/08-decisions/`.
- **Done when:** the ADR states the estimate, the assumptions, the price checked on the day and the
  stop-loss.

## 02 — Data parallelism with DDP, rehearsed locally

- **Objective:** Sam can explain how DistributedDataParallel keeps replicas in step by all-reducing
  gradients, and run his training loop under it on several local processes before renting anything.
- **Builds on:** llm-12 (the training loop); P2 (processes).
- **Key ideas:**
  - Each process holds a full model replica and a shard of each batch; after backward, gradients are
    averaged across processes with all-reduce, so every replica takes the same step.
  - DDP groups gradients into buckets and reduces them while backward is still running, overlapping
    communication with computation (`bucket_cap_mb` sets the size).
  - `torchrun --nproc-per-node N` starts the processes and sets their ranks; the gloo backend runs
    collectives on the CPU, so a multi-process rehearsal needs no second GPU.
  - Data parallelism does not shrink per-GPU memory: every replica holds the full model and optimiser
    state (lesson 03).
- **Recall targets:** explain why every replica takes the same step; say what bucketing overlaps.
- **Build:** outline — `DDP rehearsal`: in the model-training repository, the ~100M training loop under DDP on
  four gloo CPU processes with a tiny model, then one GPU process, checking the loss matches a
  single-process run.
- **Efficiency lens:** step time and communication time by process count.
- **Sources:** (checked 27/09/2026; re-verify when L6 opens) PyTorch 2.14 "Distributed Data Parallel"
  notes, <https://docs.pytorch.org/docs/2.14/notes/ddp.html>; "Getting Started with Distributed Data
  Parallel", <https://docs.pytorch.org/tutorials/intermediate/ddp_tutorial.html>; `torch.distributed`
  backends, <https://docs.pytorch.org/docs/2.14/distributed.html>; torchrun,
  <https://docs.pytorch.org/docs/2.14/elastic/run.html>.
- **Done when:** the rehearsal's loss curve matches the single-process run within noise.

## 03 — Sharding with ZeRO and FSDP, rehearsed locally

- **Objective:** Sam can explain how sharding optimiser state, gradients and parameters across
  workers cuts per-GPU memory, what it costs in communication, and rehearse FSDP locally.
- **Builds on:** lesson 02; llm-07's VRAM budget formula.
- **Key ideas:**
  - ZeRO removes data parallelism's memory redundancy in three stages: partition optimiser states,
    then gradients, then parameters (arXiv:1910.02054).
  - PyTorch's FSDP applies the same idea (arXiv:2304.11277); its current `fully_shard` shards each
    parameter on dimension 0, all-gathers the parameters before forward, and reduce-scatters the
    gradients after backward.
  - Grouping matters: `fully_shard` is applied bottom-up, layer by layer, so each group's all-gather
    overlaps compute and peak memory stays low.
  - The device mesh's type decides the communication device; whether every FSDP feature works on a
    CPU mesh over gloo is checked when L6 opens, before relying on the rehearsal.
- **Recall targets:** state what each ZeRO stage partitions and its memory effect; name the two
  collectives FSDP uses and when.
- **Build:** outline — `FSDP rehearsal`: in the model-training repository, the training loop under `fully_shard`
  on a local multi-process mesh, with per-process memory compared against lesson 02's DDP run.
- **Efficiency lens:** per-process memory and step time against DDP.
- **Sources:** (checked 27/09/2026; re-verify when L6 opens) Rajbhandari et al. (ZeRO),
  arXiv:1910.02054; Zhao et al. (PyTorch FSDP), arXiv:2304.11277; PyTorch 2.14 `fully_shard`,
  <https://docs.pytorch.org/docs/2.14/distributed.fsdp.fully_shard.html>; "Getting Started with Fully
  Sharded Data Parallel (FSDP2)", <https://docs.pytorch.org/tutorials/intermediate/FSDP_tutorial.html>.
- **Done when:** the FSDP rehearsal runs and its memory saving against DDP is recorded and explained.

## 04 — Interconnects and collectives (reading)

- **Objective:** Sam can say what the collectives of lessons 02–03 move between GPUs, what NVLink and
  InfiniBand change, and read a rental offer's interconnect line for what it means to his run.
- **Builds on:** lessons 02–03.
- **Key ideas:**
  - All-reduce, all-gather and reduce-scatter are the collectives data parallelism and sharding use;
    NCCL implements them over PCIe, NVLink, InfiniBand and plain sockets.
  - Within a node, GPU-to-GPU links set how fast sharded parameters and gradients move; across
    nodes, the network does.
  - Tensor parallelism splits single layers across GPUs (arXiv:1909.08053) and needs the fastest
    links; it is reading here, not a build.
- **Recall targets:** match each collective to where lessons 02–03 use it; say why a sharded run is
  more sensitive to the interconnect than a data-parallel one.
- **Build:** none — the output is a note that reads two rental offers' interconnect lines against
  lesson 01's plan.
- **Efficiency lens:** estimated communication volume per step for DDP against FSDP.
- **Sources:** (checked 27/09/2026; re-verify when L6 opens) NCCL 2.32.3 "Overview",
  <https://docs.nvidia.com/deeplearning/nccl/user-guide/docs/overview.html>; Shoeybi et al.
  (Megatron-LM), arXiv:1909.08053.
- **Done when:** Sam's note explains the interconnect's effect on his planned run.

## 05 — Renting safely: secrets, data residency and wiping

- **Objective:** Sam can rent a machine without leaving credentials, data or trust behind: short-lived
  secrets, known data location, verified images and wiped disks.
- **Builds on:** llm-18 lessons 05–06 (supply chain, secrets in serving); sec-05 (keys); llm-10 (the
  data's licence terms).
- **Key ideas:**
  - The rented machine is someone else's: no long-lived token goes on it, access keys are scoped and
    revoked after the run, and nothing secret is baked into an image or a script.
  - Data residency: know which country the machine and its storage are in, and whether the dataset's
    terms allow the data to go there — a question for the provider's terms and the dataset's licence,
    answered in the budget ADR.
  - Verify what you run: images and weights by digest (llm-18 lesson 05).
  - Wiping is not deleting: NIST SP 800-88 Rev. 2 sets out media sanitisation, and `shred` warns that
    journalling filesystems and some storage do not overwrite in place — so the plan also relies on
    encryption and the provider's documented sanitisation.
  - A cost alarm and a hard stop are safety controls too.
- **Recall targets:** list what must not be on the rented machine after the run; explain why
  `shred` is not enough on its own.
- **Build:** outline — `rental checklist`: a pre-flight and post-flight checklist in the model-training
  repository, each item with how it is verified, used first on a short test rental.
- **Security lens:** the rented node is outside Sam's trust boundary; the checklist is its threat
  model in action form.
- **Safety:** no personal data in training sets (llm-10); secrets never committed; nothing run on the
  node that has not been verified.
- **Sources:** (checked 27/09/2026; re-verify when L6 opens) NIST SP 800-88 Rev. 2, "Guidelines for
  Media Sanitization" (September 2025), <https://csrc.nist.gov/pubs/sp/800/88/r2/final>; `man shred`
  (the CAUTION note); llama.cpp `SECURITY.md` → "Untrusted environments or networks",
  <https://github.com/ggml-org/llama.cpp> (MIT, release b11221, commit 136887b).
- **Done when:** the checklist exists, every item has a verification, and a short test rental passes
  it.

## 06 — Checkpointing and fault tolerance at scale

- **Objective:** Sam can save and resume a sharded training run, survive a lost process, and prove
  resume works before the expensive run starts.
- **Builds on:** llm-12 (checkpoints and resume on one GPU); lessons 02–03.
- **Key ideas:**
  - Distributed Checkpoint saves and loads from every rank in parallel, writes at least one file per
    rank, and reshards at load time so a run can resume on a different topology.
  - `torchrun` restarts failed workers up to `--max-restarts`; the training script must be written to
    resume from its latest checkpoint when it starts.
  - Checkpoint cost is a budget item: time to write, storage used, and how much work a failure loses.
  - Checkpoints Sam's own run produced are loaded as his own; the released weights leave as
    safetensors (lesson 07).
- **Recall targets:** explain load-time resharding; compute the work lost per failure for a given
  checkpoint interval.
- **Build:** outline — `resume drill`: in the model-training repository, kill a worker mid-run in the local
  rehearsal and resume from the distributed checkpoint on a different process count, with the loss
  curve continuing.
- **Efficiency lens:** checkpoint write time and size against the interval chosen.
- **Security lens:** checkpoints are integrity-critical: digests recorded at save, checked at resume.
- **Sources:** (checked 27/09/2026; re-verify when L6 opens) PyTorch 2.14 "Distributed Checkpoint",
  <https://docs.pytorch.org/docs/2.14/distributed.checkpoint.html>; torchrun (`--max-restarts`),
  <https://docs.pytorch.org/docs/2.14/elastic/run.html>.
- **Done when:** the drill resumes on a different topology with a continuous loss curve.

## 07 — From run to release: model card, licence, evaluation

- **Objective:** Sam can turn a finished run into a release someone else could trust: safetensors
  weights, a model card, a licence chosen on purpose, evaluation results and a signature.
- **Builds on:** llm-13 (evaluation); tooling-05 (licences of data and weights); llm-18 lesson 05
  (digests and signatures); lesson 06.
- **Key ideas:**
  - A model card reports model details, intended use, factors, metrics, evaluation and training
    data, quantitative analyses, ethical considerations, and caveats (arXiv:1810.03993); a Hugging
    Face model repository renders its `README.md`, with a YAML metadata block, as the card.
  - The weights' licence must respect the training data's licences and state what users may do.
  - If the corpus includes The Stack v2, its terms bind the release to Software Heritage's
    principles (llm-10 lesson 02): the model under a suitable open licence with the documentation and
    tooling to use it, and the training data identified precisely (its SWHIDs published). The Stack
    v3 (ODC-By) carries no such clause, so the release notes which version was used.
  - Evaluation results are the ones llm-13's suite produces, with the contamination check stated.
  - Release safetensors only, with digests and a signature, in the model-release repository.
- **Recall targets:** list the sections a model card needs; explain why the data's licences constrain
  the model's.
- **Build:** outline — `release bundle`: in the model-release repository (created when the release
  build starts), the weights as safetensors, the model card, the licence, evaluation results, digests and signature.
- **Security lens:** a release is a supply-chain artefact for everyone downstream; it ships verifiable.
- **Sources:** (checked 27/09/2026; re-verify when L6 opens) Mitchell et al., arXiv:1810.03993;
  Hugging Face "Model Cards", <https://huggingface.co/docs/hub/model-cards>; safetensors
  documentation, <https://huggingface.co/docs/safetensors/index>; model-signing 1.1.1,
  <https://github.com/sigstore/model-transparency>; Software Heritage, "Statement on Large Language
  Models for Code" (19/10/2023), "Principles",
  <https://www.softwareheritage.org/2023/10/19/swh-statement-on-llm-for-code/>.
- **Done when:** the release bundle is complete and its signature verifies from a clean checkout.
