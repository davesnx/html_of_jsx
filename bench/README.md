# Benchmarks

## Goals

- Run each scenario with warmup + repeated measurements.
- Report robust statistics (`median`, `p95`, `mad`).
- Track allocation and GC counters per scenario (`minor_words`, `major_words`, `promoted_words`, collection counts).
- Compare against a baseline while accounting for run-to-run noise.
- Persist raw runs in JSON for later analysis.

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

## Compile fixture coverage

Compile-time benchmark includes synthetic fixtures for:

- `static-heavy`: many mostly static JSX trees.
- `attr-heavy`: many attributes and dynamic attribute values.
- `nested-mixed`: deep nesting with mixed string/int/float/element children.
