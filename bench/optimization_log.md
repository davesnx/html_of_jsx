# Optimization Log

## Optimization 1: Buffer Size Estimation
**Status:** ❌ Rejected - Overhead > Benefit

**Approach:** Calculate element size before creating buffer
**Result:** ~12% overall regression
**Reason:** Tree traversal overhead exceeds benefit of right-sizing buffer

**Alternative Tested:** Simple 4K buffer (up from 1K)
**Result:** Mixed - minor improvements in some scenarios, but adds 3KB memory overhead per render
**Decision:** Keep 1K buffer, investigate other optimizations

## Optimization 2: Escape Lookup Table
**Status:** ❌ Rejected - Slower than pattern matching

**Approach:** Replace pattern match with array lookup table
**Result:** ~4% overall regression
**Reason:** Array bounds check + memory access slower than compiled pattern match
**Insight:** OCaml's pattern matching is highly optimized - hard to beat manually

## Optimization 3: Compiler Flags (-O3 -inline 100)
**Status:** ❌ Rejected - Mixed results, net negative

**Approach:** Enable aggressive compiler optimizations
**Result:** ~2.5% overall regression
**Reason:** Mixed improvements/regressions, no clear benefit
**Note:** Default compiler settings are well-tuned

## Optimization 4: Printf.bprintf for Int/Float Attributes
**Status:** ❌ Rejected - Slower than manual operations

**Approach:** Use Printf.bprintf instead of Buffer.add_string + Int.to_string
**Result:** ~3.7% overall regression  
**Reason:** Printf overhead exceeds benefit of single call
**Note:** `props_heavy` showed +7.5% but overall net negative

## Optimization 5: Direct Array Support (User Pattern Optimization)
**Status:** ⚠️ Documentation Only - Not a Code Change

**Observation:** Wide_tree and other scenarios use `JSX.list (Array.to_list array)`
**Issue:** `Array.to_list` allocates cons cells (2 words per element)
**Solution:** Use `JSX.array` directly instead
**Impact:** Would save ~2KB allocation for 100-element array
**Action:** Document best practices for users

## Key Insights from Optimization Session

### What We Learned:
1. **Current implementation is already well-optimized** - The codebase uses efficient patterns
2. **OCaml compiler is excellent** - Default settings beat manual micro-optimizations
3. **Pattern matching is fast** - Faster than lookup tables for small sets
4. **Buffer operations are optimized** - Manual batching doesn't help
5. **Micro-optimizations backfire** - Overhead often exceeds benefit

### Why Optimizations Failed:
- **Buffer size estimation**: Tree traversal cost > benefit of right-sizing
- **Escape lookup table**: Array access + bounds check > pattern match
- **Compiler flags (-O3)**: No consistent benefit, some regressions
- **Printf.bprintf**: Format parsing overhead > manual Buffer ops

### Real Bottlenecks Identified:
1. **Array.to_list conversions** - Users should use `JSX.array` directly
2. **Large document allocation** - But buffer grows efficiently
3. **Benchmark variance** - Need longer runs for stable measurements

### Recommendations:
1. **Keep current implementation** - It's well-optimized
2. **Document best practices**:
   - Use `JSX.array` not `JSX.list (Array.to_list ...)`
   - Pre-size buffers for known-large renders if needed
3. **Improve benchmarks**:
   - Longer durations for stable measurements
   - Add warmup phase
   - Track memory allocations separately
4. **Future optimizations to explore**:
   - Custom Buffer implementation with arenas (advanced)
   - Streaming rendering without intermediate string (medium effort)
   - PPX-time optimizations (already good, but could go further)

## Benchmark Stability Notes
- `trivial` benchmark shows high variance (65M → 3M ops/sec between runs)
- Need longer benchmark duration for micro-benchmarks
- Scenario benchmarks (table, ecommerce, etc.) are stable within 5%

---
