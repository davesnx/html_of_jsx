# Performance Guide for html_of_jsx

## Overview

This guide provides performance optimization strategies and profiling techniques for `html_of_jsx`. The library is already well-optimized, but understanding these patterns will help you write high-performance HTML rendering code.

## Quick Wins - Best Practices

### 1. Use `JSX.array` Instead of `JSX.list (Array.to_list ...)`

**❌ Slow - Allocates list cons cells:**
```ocaml
let items = Array.init 100 make_item in
<ul>
  (JSX.list (Array.to_list items))
</ul>
```

**✅ Fast - No intermediate allocation:**
```ocaml
let items = Array.init 100 make_item in
<ul>
  (JSX.array items)
</ul>
```

**Impact:** Saves ~2 words per element (800 bytes for 100 elements)

### 2. Pre-compute Static Content

**❌ Slow - Re-escapes on every render:**
```ocaml
let render user =
  <div>(JSX.string user.bio)</div>
```

**✅ Fast - Escape once, reuse:**
```ocaml
let render user =
  <div>(JSX.unsafe user.bio_html)</div>  (* Pre-escaped *)
```

**Caveat:** Only use `JSX.unsafe` with trusted, pre-escaped content!

### 3. Avoid Dynamic Attribute Computation in Hot Paths

**❌ Slow - Computes on every render:**
```ocaml
List.map (fun item ->
  <div class_=(compute_class item.status)>...</div>
) items
```

**✅ Fast - Compute once:**
```ocaml
List.map (fun item ->
  let cls = compute_class item.status in
  <div class_=cls>...</div>
) items
```

### 4. Use Static Optimization Where Possible

The PPX automatically optimizes fully static elements:

```ocaml
(* This is optimized to a single string constant *)
let header = <header><h1>(JSX.string "My Site")</h1></header>

(* This cannot be optimized - dynamic content *)
let header title = <header><h1>(JSX.string title)</h1></header>
```

**Tip:** Keep static parts separate from dynamic parts when possible.

## Profiling Your Application

### CPU Profiling with `perf` (Linux)

1. **Install perf:**
   ```bash
   sudo apt-get install linux-tools-generic
   ```

2. **Build with debug symbols:**
   ```bash
   dune build --profile=release
   ```

3. **Profile your application:**
   ```bash
   perf record -F 999 -g -- ./_build/default/your_app.exe
   perf report -g --stdio
   ```

4. **Look for:**
   - Functions taking > 5% CPU time
   - High cache miss rates
   - Branch mispredictions

5. **Advanced metrics:**
   ```bash
   perf stat -e cycles,instructions,cache-misses,branch-misses ./your_app.exe
   ```

   **Interpretation:**
   - `IPC < 1.0`: Memory bound (cache misses)
   - `cache-miss% > 5%`: Improve data locality
   - `branch-miss% > 5%`: Reduce conditional logic

### Memory Profiling with `memtrace`

1. **Install memtrace:**
   ```bash
   opam install memtrace memtrace-viewer
   ```

2. **Add to your dune file:**
   ```lisp
   (executable
     (name your_app)
     (libraries html_of_jsx memtrace))
   ```

3. **Instrument your code:**
   ```ocaml
   let () =
     Memtrace.trace_if_requested ();
     (* your rendering code *)
   ```

4. **Run and analyze:**
   ```bash
   MEMTRACE=trace.ctf ./your_app.exe
   memtrace-viewer trace.ctf
   ```

5. **Look for:**
   - Allocation hotspots
   - Unexpected allocations in loops
   - Short-lived objects (GC pressure)

### Benchmark Your Code

Use the fast benchmark suite:

```bash
# Run benchmarks
dune exec ./bench/bench_fast.exe > results.json

# Compare with baseline
dune exec ./bench/compare_results.exe -- baseline.json results.json
```

### Custom Benchmarking

```ocaml
let () =
  let times = 10000 in
  let start = Unix.gettimeofday () in
  for _ = 1 to times do
    ignore (JSX.render your_element)
  done;
  let elapsed = Unix.gettimeofday () -. start in
  Printf.printf "Avg: %.2f µs/render\n" (elapsed *. 1_000_000. /. float times)
```

## Common Performance Questions

### Q: Should I use a larger initial buffer size?

**A:** No. The default 1024-byte buffer is optimal for most cases. Larger buffers waste memory, and OCaml's `Buffer` grows efficiently when needed.

### Q: Is `JSX.render` faster than `JSX.render_to_channel`?

**A:** `render_to_channel` is slightly faster for large documents because it avoids the final `Buffer.contents` allocation. For small documents (< 10KB), the difference is negligible.

### Q: Should I cache rendered HTML?

**A:** Yes, if the content is static or changes infrequently. But don't optimize prematurely - measure first!

```ocaml
let cached_header = lazy (JSX.render header_element)

let render_page () =
  let header_html = Lazy.force cached_header in
  (* ... *)
```

### Q: How do I render a million-row table efficiently?

**A:** Don't render it all at once! Use pagination or streaming:

```ocaml
(* Paginated approach *)
let render_page ~page ~page_size rows =
  let start = page * page_size in
  let rows_slice = Array.sub rows start (min page_size (Array.length rows - start)) in
  render_table rows_slice

(* Streaming approach for truly huge data *)
let render_streaming_table chan rows =
  output_string chan "<table>";
  Array.iter (fun row ->
    let row_html = JSX.render (render_row row) in
    output_string chan row_html
  ) rows;
  output_string chan "</table>"
```

## Performance Characteristics

### Time Complexity

| Operation | Complexity | Notes |
|-----------|------------|-------|
| `JSX.render` | O(n) | n = number of nodes |
| `JSX.escape` | O(m) | m = string length |
| `JSX.list` | O(n) | n = list length |
| `JSX.array` | O(n) | n = array length |

### Space Complexity

| Element Type | Memory Overhead |
|--------------|-----------------|
| `String` node | ~2 words (16 bytes) |
| `Node` with 3 attrs | ~8 words (64 bytes) |
| `List` of 100 elements | ~300 words (2.4 KB) |
| `Array` of 100 elements | ~101 words (808 bytes) |

### Typical Performance

Based on benchmarks on a modern Linux machine:

| Scenario | Ops/Second | Notes |
|----------|------------|-------|
| Trivial (`<div>Hello</div>`) | ~60M | Single element |
| Table (100 rows) | ~3K | Complex structure |
| E-commerce page (48 products) | ~4K | Real-world load |
| Dashboard | ~28K | Mixed content |

## Advanced Optimizations

### Custom Buffer Size (Rarely Needed)

If you know your output size in advance:

```ocaml
(* Not exposed in public API, but you can wrap it *)
let render_large element =
  let buf = Buffer.create 16384 in  (* 16KB for large pages *)
  JSX.write buf element;
  Buffer.contents buf
```

### Avoid Escaping When Safe

If you control the input and know it's safe:

```ocaml
(* Instead of: *)
<div>(JSX.string trusted_content)</div>

(* Use: *)
<div>(JSX.unsafe trusted_content)</div>
```

**Warning:** Never use `JSX.unsafe` with user input!

### Pre-compute Static Attributes

```ocaml
(* Compute once at module load time *)
let static_class = "btn btn-primary mt-4"

(* Reuse in renders *)
let button ~label =
  <button class_=static_class>(JSX.string label)</button>
```

## Debugging Performance Issues

### Step 1: Measure

Don't guess - measure! Use `perf` or add timing code:

```ocaml
let time_it name f =
  let start = Unix.gettimeofday () in
  let result = f () in
  let elapsed = Unix.gettimeofday () -. start in
  Printf.eprintf "%s: %.2fms\n" name (elapsed *. 1000.);
  result

let () =
  let html = time_it "render" (fun () -> JSX.render my_page) in
  Printf.printf "%s\n" html
```

### Step 2: Profile

Find the hotspot using `perf`:

```bash
perf record -g ./your_app.exe
perf report
```

### Step 3: Optimize

Focus on the hotspot. Common issues:
- **Repeated escaping**: Use `JSX.unsafe` for pre-escaped content
- **List allocations**: Use `JSX.array` instead
- **Recomputation**: Cache static content
- **Large documents**: Consider streaming or pagination

### Step 4: Verify

Run benchmarks before and after:

```bash
# Before
dune exec ./bench/bench_fast.exe > before.json

# After making changes
dune exec ./bench/bench_fast.exe > after.json

# Compare
dune exec ./bench/compare_results.exe -- before.json after.json
```

## When to Optimize

**Don't optimize prematurely!** Optimize when:

1. ✅ Profiling shows HTML rendering is a bottleneck
2. ✅ You've measured and confirmed the slow path
3. ✅ You have a benchmark to verify improvements

**Don't optimize when:**

1. ❌ "It feels slow" without measurement
2. ❌ HTML rendering isn't the bottleneck
3. ❌ The optimization would make code less maintainable

## Summary

- Use `JSX.array` not `JSX.list (Array.to_list ...)`
- Cache static content
- Use `JSX.unsafe` only for trusted, pre-escaped content
- Profile before optimizing
- The library is already fast - focus on your application logic

For more details, see the [optimization log](../bench/optimization_log.md).
