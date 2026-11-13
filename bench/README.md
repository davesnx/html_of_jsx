# Benchmarks

## Goals

- Run each scenario with warmup + repeated measurements.
- Report robust statistics (`median`, `p95`, `mad`).
- Track allocation and GC counters per scenario (`minor_words`, `major_words`, `promoted_words`, collection counts).
- Compare against a baseline while accounting for run-to-run noise.
- Persist raw runs in JSON for later analysis.

## What scenarios measure

Every scenario constructs the element tree **inside** the timed function:
construction evaluates the dynamic parts eagerly and the PPX compiles the
markup to writer closures, so building and rendering together is the cost a
request pays.

Two deliberate exceptions:

- `Trivial (static)`: fully static markup. The PPX collapses it to a
  constant string at compile time; ~0us is the correct result and it exists
  to demonstrate (and guard) the static-collapse optimization.
- `Table (100 rows, prebuilt writer)`: renders an element that was built
  once outside the timed function. It measures only the write pass (the
  closures run again on every render), so it tracks the cost of the writer
  path without element construction.

Input data (users, products, comments) is precomputed at module init: we
measure rendering, not test-data generation.

## Baselines are local

Benchmark results are machine-specific, so nothing under `bench/results/` is
tracked (`bench/results/.gitignore` ignores `*.json`). Cross-commit tracking
happens in CI via `benchmark-action` instead.

Before starting performance work, generate baselines on the commit you want
to compare against:

- `baseline.json`: runtime benchmark baseline (`make bench-baseline`).
- `compile_baseline.json`: compile-time baseline
  (`dune exec bench/compile_bench.exe -- --runs 3 --save bench/results/compile_baseline.json`).

Then compare with `make bench-compare` and
`dune exec bench/compile_bench.exe -- --compare bench/results/compile_baseline.json`.

## Usage

```sh
dune exec bench/bench.exe
dune exec bench/bench.exe -- --json
dune exec bench/bench.exe -- --json-benchmark-action
dune exec bench/bench.exe -- --save bench/results/latest.json
dune exec bench/bench.exe -- --compare bench/results/baseline.json
```

Compile-time benchmark usage:

```sh
dune exec bench/compile_bench.exe
dune exec bench/compile_bench.exe -- --runs 3 --save bench/results/compile_baseline.json
dune exec bench/compile_bench.exe -- --compare bench/results/compile_baseline.json --threshold-ppx 10 --threshold-total 10
```

Tune measurement rigor:

```sh
dune exec bench/bench.exe -- --runs 15 --warmup 5 --seconds 2
```

Tune allocation sampling rigor:

```sh
dune exec bench/bench.exe -- --alloc-iters 2000 --alloc-runs 7
```

## CLI flags

- `--json`: print JSON report.
- `--json-benchmark-action`: print benchmark-action compatible JSON array (`customBiggerIsBetter`).
- `--save <file>`: write JSON report to a file.
- `--compare <file>`: compare to baseline JSON.
- `--runs <n>`: measured runs per scenario (default `9`).
- `--warmup <n>`: warmup runs per scenario (default `3`).
- `--seconds <n>`: seconds per measured run (default `2`).
- `--alloc-iters <n>`: renders per allocation sample (default `1000`).
- `--alloc-runs <n>`: allocation samples per scenario (default `5`).
- `--noise-threshold <pct>`: minimum noise band in percent (default `3.0`).

Compile benchmark flags:

- `--runs <n>`: compile runs per fixture (default `5`).
- `--save <file>`: persist compile benchmark JSON.
- `--compare <file>`: compare with prior compile benchmark JSON.
- `--threshold-ppx <pct>`: guardrail max PPX median regression (default `10.0`).
- `--threshold-total <pct>`: guardrail max total compile median regression (default `10.0`).

## Reading the output

- `med (us)`: median latency across measured runs.
- `p95 (us)`: 95th percentile latency.
- `mad%`: median absolute deviation as a percentage of median.
- `minor w/op`: median minor heap words allocated per render (lower is better).
- JSON includes `major_words`, `promoted_words`, and GC collection deltas per render.
- Baseline compare markers:
  - `✓`: statistically meaningful improvement.
  - `!`: statistically meaningful regression.
  - `~`: change is inside noise band, treat as inconclusive.

Noise band is computed as:

- `max(noise_threshold_pct, 2 * max(baseline_mad%, current_mad%))`

This keeps small deltas from being over-interpreted when variance is high.

## Comparison with other libraries

`bench/vs` renders the same pages with html_of_jsx, TyXML, and pure-html (the
core of dream-html). The pages are the "stress" page from
[dream_templaters_comparison](https://github.com/katel0k/dream_templaters_comparison)
with 100, 1000, 10000, and 100000 items, and the 100-row table from
`bench/scenarios/Table.mlx`.

Each page is measured in two modes:

- `build+render`: the timed function builds the tree and renders it to a
  string. This is the cost a request pays.
- `render only`: the tree is built once, and only the render to a string is
  timed.

Both modes exist because libraries split work differently between building
and rendering. Comparing one library's build+render with another library's
render only gives a wrong result.

Before timing, the benchmark checks that all libraries produce the same
content. It then runs several rounds and measures every library once per
round, so load changes on the host affect all libraries equally. It reports
the median and minimum time per render, the ratio to html_of_jsx, and the
minor words allocated per render.

It needs TyXML and pure-html, which are not dependencies of this package, so
dune builds it only when `BENCH_VS=true` is set. `make bench-vs` sets it:

```sh
opam install tyxml pure-html
make bench-vs
BENCH_VS=true dune exec bench/vs/vs.exe -- --rounds 15 --seconds 1
```

On a busy machine, pin the process to one core, for example
`taskset -c 3 make bench-vs`.

## Compile fixture coverage

Compile-time benchmark includes synthetic fixtures for:

- `static-heavy`: many mostly static JSX trees.
- `attr-heavy`: many attributes and dynamic attribute values.
- `nested-mixed`: deep nesting with mixed string/int/float/element children.
- `large-mixed`: ~800 generated components (~7k lines) rotating through the
  four main PPX codegen paths (fully static, dynamic attributes, optional
  attributes, dynamic children). Large enough that per-attribute-lookup
  regressions in the PPX are unmistakable. Regenerate with
  `ocaml bench/compile_fixtures/large_mixed/gen.ml > bench/compile_fixtures/large_mixed/large_mixed.mlx`.
