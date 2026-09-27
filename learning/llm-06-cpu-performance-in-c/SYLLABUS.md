# Syllabus — llm-06-cpu-performance-in-c

**Track**: llm · **Phase**: L2 · **Path**: Core · **Detail**: full · **Prerequisites**: P2 (C systems, including threads); no earlier LLM topic needed
**Status**: Planned · **Checked**: 27/09/2026 (sources re-verified by `/teach` step 3 before each lesson)

How to make C fast on this machine's Intel Core i9-9900K, and how to prove it. The topic opens with
the measurement method the rest of the repository cites (**lesson 01 is the method kernel-04, os-05
and the security topics point to**), then walks down the memory hierarchy with this machine's own
numbers, through cache lines, false sharing and AVX2/FMA vectorisation, to the roofline model that
explains why token-by-token decoding is limited by memory bandwidth rather than arithmetic — the
reason quantisation and memory layout matter so much in llm-15. It ends by tiling a matrix multiply
for the cache, the same idea llm-08 applies with GPU shared memory and llm-09 meets in llm.c.

| # | Lesson | Size | Build | Lenses |
| --- | --- | --- | --- | --- |
| 01 | Measuring honestly: warm-up, repeats, variance and a budget | 2–3 sittings | yes — timing harness | Efficiency, Safety |
| 02 | The memory hierarchy with this machine's numbers | 1 sitting | yes — pointer-chase sweep | Efficiency |
| 03 | Cache lines, locality and false sharing | 2–3 sittings | yes — traversal and false-sharing pair | Efficiency |
| 04 | SIMD on AVX2 and FMA: auto-vectorisation, then intrinsics | 2–3 sittings | yes — three dot products | Efficiency |
| 05 | The roofline: arithmetic intensity and why decode is memory-bound | 1 sitting | yes — bandwidth and peak probes | Efficiency |
| 06 | Tiling a matrix multiply for the cache | 2–3 sittings | yes — naive against tiled matmul | Efficiency |

**Where the work lands.** Small C exercises in this repository under `code/src/c/msNNN-<kebab>/`,
built by the house make targets. The house build is `-g3 -O0` for debugging (`code/docs/BUILD.md` →
Section 2); a measured build overrides it for one run, for example
`make -C code/src/c/msNNN-<kebab> clean all DBG="-g -O2"`, and says so in the record. Tests check
correctness only — timings are measurements, not tests — and every exercise stays clean under
`make test`, `make san` and `make memcheck` at the default flags.

---

## 01 — Measuring honestly: warm-up, repeats, variance and a budget

- **Objective:** Sam can measure a program's time and memory so that the result is repeatable,
  report it with its spread and environment, and set it against a budget stated beforehand — with or
  without `perf` counters.
- **Builds on:** P2 (processes, `clock_gettime`); llm-02 lesson 04 if taken (the GPU version of the
  same discipline).
- **Key ideas:**
  - The first runs pay for cold caches, page faults and frequency ramp-up; warm up, then repeat and
    report the median and the spread, never one number.
  - `CLOCK_MONOTONIC` does not jump with the wall clock; time inside the program around the work,
    not around process start-up.
  - `/usr/bin/time -v` needs no privileges and reports wall and CPU time and the maximum resident
    set size.
  - `perf stat -r N` repeats a command and prints the mean and standard deviation of hardware
    counters (cycles, instructions, cache misses) — but this host sets
    `kernel.perf_event_paranoid` to 4, above the upstream-documented range, and perf refuses
    unprivileged use.
  - Without counters, `valgrind --tool=cachegrind` counts instructions exactly and, with
    `--cache-sim=yes`, simulates the caches — slowly, and as a model, not the hardware.
  - Pinning to one core (`taskset -c`) and recording the load on the machine reduce noise; the
    record states the build flags, compiler version and command.
- **Recall targets:** list what must be in a measurement record; explain why warm runs and cold
  runs differ; name the unprivileged fallback for each `perf` counter used.
- **Build:** a small timing harness in C (warm-up count, repeat count, median, minimum and maximum
  from `clock_gettime`) with `check.h` tests of the statistics on fixed inputs; one measured run of
  a trivial kernel recorded as "budget against measured" in the milestone's verification record
  under `project-management/src/10-PROGRESS/`.
- **Efficiency lens:** this lesson is the method — every later efficiency figure in the repository
  cites it.
- **Safety:** Claude never runs `sudo`. To use `perf` counters for one session, Sam himself runs
  `sudo sysctl -w kernel.perf_event_paranoid=2` (upstream: 2 or less allows counting a user's own
  processes without kernel profiling), and afterwards `sudo sysctl -w kernel.perf_event_paranoid=4`
  to restore it; the change is not persistent unless written to a sysctl configuration file, which
  this lesson does not do. The unprivileged path (cachegrind, `time -v`, `clock_gettime`) is taught
  either way.
- **Sources:** `man perf-stat` (perf 7.0.14, `-r`/`--repeat`); `man 1 time` (GNU time, `-v`);
  `man 2 clock_gettime`; `man 1 taskset`; `man 8 sysctl`; Linux kernel documentation → "Documentation
  for /proc/sys/kernel/ → perf_event_paranoid" (<https://docs.kernel.org/admin-guide/sysctl/kernel.html>)
  and "Perf events and tool security" (<https://docs.kernel.org/admin-guide/perf-security.html>);
  Valgrind User Manual, Section 5 "Cachegrind" (<https://valgrind.org/docs/manual/cg-manual.html>,
  online 3.27.1; this host runs 3.22.0, where `--cache-sim` defaults to `no`).
- **Done when:** the harness tests pass under `make test`, `san` and `memcheck`, and one record holds
  a budget, a median with its spread, the environment and the command.

## 02 — The memory hierarchy with this machine's numbers

- **Objective:** Sam can state this machine's cache sizes and line size, predict where memory
  latency steps up as a working set grows, and show the steps in a measurement.
- **Builds on:** lesson 01.
- **Key ideas:**
  - `lscpu -C` on this host: L1d 32 KiB per core (8-way), L2 256 KiB per core (4-way), L3 16 MiB
    shared (16-way), 64-byte lines; 8 cores and 16 threads; 32 GB of RAM.
  - Each level is larger and slower than the one above; a load that misses every level goes to
    DRAM.
  - A pointer chase (each load's address comes from the previous load) defeats the prefetcher and
    exposes latency; a sequential scan hides it.
  - Plotting time per load against working-set size shows a step near each cache size.
- **Recall targets:** recite the cache sizes and line size; predict the shape of the latency curve
  and where its steps fall.
- **Build:** a pointer-chase sweep over working sets from a few KiB to well past 16 MiB, recording
  nanoseconds per load; tests check that the chase visits every element exactly once; checked by the
  steps appearing near the `lscpu -C` sizes.
- **Efficiency lens:** nanoseconds per dependent load at each level, measured on this machine.
- **Sources:** `man lscpu` (`-C`/`--caches`); Drepper, "What Every Programmer Should Know About
  Memory" (21/11/2007), Section 3 "CPU Caches", especially 3.3.2 "Measurements of Cache Effects"
  (<https://www.akkadia.org/drepper/cpumemory.pdf>).
- **Done when:** the sweep's steps are recorded beside the `lscpu -C` sizes and Sam explains each
  one.

## 03 — Cache lines, locality and false sharing

- **Objective:** Sam can predict which access patterns waste cache lines, measure the waste with
  cachegrind, and fix false sharing between threads by padding.
- **Builds on:** lesson 02; P2 threads.
- **Key ideas:**
  - Memory moves in 64-byte lines: touching one float loads fifteen neighbours, so walking a C
    array row by row is cheap and column by column is not.
  - cachegrind with `--cache-sim=yes` reports first-level and last-level data misses per function
    and per line, without hardware counters.
  - False sharing: two threads writing different variables in the same line force the line to
    move between cores on every write.
  - The fix is layout: give each thread's data its own line with an alignment specifier
    (`_Alignas(64)`, C17) or padding — and measure that it helped.
- **Recall targets:** explain why column-order traversal of a row-major array is slow; describe
  false sharing and its fix without naming a tool.
- **Build:** a traversal pair (row order against column order) and a false-sharing pair (two threads
  incrementing adjacent counters against padded ones); tests check the results are equal; timings
  and cachegrind miss counts recorded for each pair.
- **Efficiency lens:** data-cache misses and time for each variant, with the ratio stated.
- **Sources:** Drepper, Sections 6.2.1 "Optimizing Level 1 Data Cache Access" and 6.4.1
  "Concurrency Optimizations" (false sharing) (<https://www.akkadia.org/drepper/cpumemory.pdf>);
  Valgrind User Manual, Section 5.2.11 "Cache and Branch Simulation"
  (<https://valgrind.org/docs/manual/cg-manual.html>); WG14 N2310, Section 6.7.5 "Alignment
  specifier" (<https://www.open-std.org/jtc1/sc22/wg14/www/docs/n2310.pdf>).
- **Done when:** both pairs are measured, the padded version is faster by a recorded margin, and Sam
  explains the miss counts.

## 04 — SIMD on AVX2 and FMA: auto-vectorisation, then intrinsics

- **Objective:** Sam can get a loop vectorised by gcc and confirm it, write the same loop with AVX2
  and FMA intrinsics, and explain why the vector result can differ in the last bits.
- **Builds on:** lessons 01–03.
- **Key ideas:**
  - AVX2 registers hold eight floats; FMA computes `a * b + c` with one rounding. This CPU has AVX2
    and FMA and no AVX-512 (`lscpu` flags).
  - gcc 13 turns on loop vectorisation at `-O2` with a "very cheap" cost model, and a dynamic one
    at `-O3`; `-fopt-info-vec` and `-fopt-info-vec-missed` report what vectorised and why not.
  - This gcc targets baseline x86-64 by default (`gcc -Q --help=target` shows `-march=x86-64`);
    `-mavx2 -mfma` or `-march=native` allows the wider instructions, and a binary built that way may
    not run on another machine.
  - A vectorised float sum adds in a different order; ISO C does not permit that reassociation by
    default (`-fassociative-math` would), so the vectoriser may refuse a reduction — and when a
    result does change, it is rounding, checked with a tolerance.
  - Intrinsics (`immintrin.h`, such as `_mm256_fmadd_ps`) make the vector code explicit; a runtime
    check with `__builtin_cpu_supports("avx2")` keeps the program correct on a CPU without it.
- **Recall targets:** say what `-fopt-info-vec-missed` is for; explain why a float reduction may not
  vectorise; name the risk of `-march=native`.
- **Build:** a dot product three ways — scalar, auto-vectorised (confirmed by `-fopt-info-vec`) and
  intrinsics behind a runtime AVX2 check — with tests comparing each against the scalar result
  within a tolerance; GFLOP/s of each recorded.
- **Efficiency lens:** GFLOP/s of the three versions at an L1-sized and a DRAM-sized input.
- **Sources:** GCC 13.3 manual → "Options That Control Optimization" (`-ftree-loop-vectorize`,
  `-fvect-cost-model`, `-fassociative-math`) (<https://gcc.gnu.org/onlinedocs/gcc-13.3.0/gcc/Optimize-Options.html>),
  "GCC Developer Options" (`-fopt-info`) (<https://gcc.gnu.org/onlinedocs/gcc-13.3.0/gcc/Developer-Options.html>),
  "x86 Options" (`-march`, `-mavx2`, `-mfma`) (<https://gcc.gnu.org/onlinedocs/gcc-13.3.0/gcc/x86-Options.html>)
  and "x86 Built-in Functions" (`__builtin_cpu_supports`)
  (<https://gcc.gnu.org/onlinedocs/gcc-13.3.0/gcc/x86-Built-in-Functions.html>); gcc 13's own
  `avxintrin.h` and `fmaintrin.h` (found with `gcc -print-file-name=include`) — the Intel Intrinsics
  Guide refused scripted fetches on 27/09/2026, so the headers were checked instead.
- **Done when:** all three versions pass their tests, the vectorisation report is saved, and Sam
  explains the GFLOP/s differences at both sizes.

## 05 — The roofline: arithmetic intensity and why decode is memory-bound

- **Objective:** Sam can place a kernel on this machine's roofline from its arithmetic intensity and
  explain why generating one token at a time is limited by memory bandwidth.
- **Builds on:** lessons 01–04.
- **Key ideas:**
  - Operational (arithmetic) intensity is FLOPs per byte moved to and from DRAM; attainable
    performance is the lower of the compute peak and bandwidth times intensity.
  - The ridge point, peak FLOP/s divided by bandwidth, is the intensity a kernel needs before
    compute rather than memory limits it.
  - Both roofs are measured here: bandwidth with a STREAM-style triad, the compute peak with an
    FMA loop that stays in registers. The theoretical peak from the core count, vector width, FMA
    units and clock is worked out too, with the per-core FMA throughput marked "to verify" against
    Intel's optimisation manual.
  - Decoding one token multiplies a vector by every weight matrix: each weight is read once for
    about two FLOPs, so the intensity is roughly two divided by the bytes per weight — far left of
    the ridge. Fewer bytes per weight (llm-15's quantisation) moves it right.
- **Recall targets:** state the roofline formula; compute the intensity of a dot product and of a
  matrix-vector product in fp32; explain why a 4-bit model decodes faster than an fp16 one on the
  same hardware.
- **Build:** a triad bandwidth probe and an FMA peak probe, then the lesson 04 dot product and a
  matrix-vector product placed on the resulting roofline (a table of intensity, attainable and
  achieved); tests check the kernels' results.
- **Efficiency lens:** measured bandwidth (GB/s), measured peak (GFLOP/s), the ridge point, and each
  kernel's achieved fraction of its roof.
- **Sources:** Williams, Waterman and Patterson, "Roofline: An Insightful Visual Performance Model
  for Floating-Point Programs and Multicore Architectures", Section 3 "The Roofline Model"
  (<https://people.eecs.berkeley.edu/~kubitron/cs252/handouts/papers/RooflineVyNoYellow.pdf>);
  McCalpin, STREAM benchmark (<https://www.cs.virginia.edu/stream/>) and its run rules
  (<https://www.cs.virginia.edu/stream/ref.html>); Drepper, Section 3.5.1 "Cache and Memory
  Bandwidth".
- **Done when:** the roofline table is recorded and Sam explains, from it, why decode is
  memory-bound.

## 06 — Tiling a matrix multiply for the cache

- **Objective:** Sam can raise a matrix multiply's effective arithmetic intensity by reordering and
  tiling its loops so each tile is reused while it is in cache, and measure the gain.
- **Builds on:** lessons 02–05; llm-03 lesson 01 (matmul FLOPs).
- **Key ideas:**
  - The naive loop order streams one operand column-wise, missing the cache on almost every
    access; swapping the inner loops makes both streams sequential.
  - Tiling splits the matrices into blocks that fit a cache level and finishes all the work on a
    block before moving on, so each byte fetched is used many times.
  - Tile sizes come from lesson 02's numbers, then are tuned by measurement.
  - The same idea on a GPU uses shared memory as the tile store (llm-08); llm.c's CPU matmul is
    read with this lesson in mind (llm-09).
- **Recall targets:** explain why loop order changes speed without changing the result; choose a
  starting tile size from the cache sizes and justify it.
- **Build:** naive, reordered and tiled matmul (tiled with the lesson 04 vectorisation where it
  helps), tested equal to each other within a tolerance; GFLOP/s and cachegrind misses recorded for
  each and placed on the lesson 05 roofline.
- **Efficiency lens:** GFLOP/s and last-level misses for each version at a size larger than L3.
- **Sources:** Drepper, Section 6.2.1 "Optimizing Level 1 Data Cache Access" (the matrix
  multiplication example) (<https://www.akkadia.org/drepper/cpumemory.pdf>); roofline paper,
  Section 3; Valgrind User Manual, Section 5 "Cachegrind".
- **Done when:** the three versions agree, the tiled one's gain is measured and explained by the
  miss counts, and its point is on the roofline table.
