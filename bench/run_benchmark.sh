#!/bin/bash
set -e

RESULTS_DIR="bench/results"
TIMESTAMP=$(date +%Y%m%d_%H%M%S)
BASELINE="${RESULTS_DIR}/baseline.json"

# Check if we need to establish baseline
if [ ! -f "$BASELINE" ]; then
    echo "=== Establishing baseline benchmark ==="
    dune build
    dune exec ./bench/bench.exe -- --json > "$BASELINE"
    echo "Baseline saved to: $BASELINE"
    exit 0
fi

# Run new benchmark
NEW_RESULT="${RESULTS_DIR}/bench_${TIMESTAMP}.json"
echo "=== Running new benchmark ==="
dune build
dune exec ./bench/bench.exe -- --json > "$NEW_RESULT"
echo "Results saved to: $NEW_RESULT"

# Compare results
echo ""
echo "=== Comparing with baseline ==="
dune exec ./bench/compare_results.exe -- "$BASELINE" "$NEW_RESULT"

# Check exit code to determine if improvement
if [ $? -eq 0 ]; then
    echo ""
    echo "✓ Net improvement detected!"
    echo "To update baseline: cp $NEW_RESULT $BASELINE"
else
    echo ""
    echo "✗ No net improvement or regression detected"
fi
