window.BENCHMARK_DATA = {
  "lastUpdate": 1765817224012,
  "repoUrl": "https://github.com/davesnx/html_of_jsx",
  "entries": {
    "html_of_jsx Benchmarks": [
      {
        "commit": {
          "author": {
            "email": "david.sancho@ahrefs.com",
            "name": "David Sancho Moreno",
            "username": "davesnx"
          },
          "committer": {
            "email": "david.sancho@ahrefs.com",
            "name": "David Sancho Moreno",
            "username": "davesnx"
          },
          "distinct": true,
          "id": "d61cd02fa1655bcb9931981dc0fbad56b1c7e7aa",
          "message": "Fix gh-pages: preserve benchmark data when publishing docs\n\nThe crazy-max/ghaction-github-pages action was force pushing an orphan\nbranch, which wiped out the benchmark data.js that was just committed\nby github-action-benchmark.\n\nSetting keep_history: true preserves existing files on gh-pages.",
          "timestamp": "2025-12-15T16:39:08Z",
          "tree_id": "9761b02abf0283bf9d64dc3fd44b59b124a1feb9",
          "url": "https://github.com/davesnx/html_of_jsx/commit/d61cd02fa1655bcb9931981dc0fbad56b1c7e7aa"
        },
        "date": 1765817223040,
        "tool": "customBiggerIsBetter",
        "benches": [
          {
            "name": "single_no_escape/loop_all",
            "value": 14489385.48,
            "unit": "ops/sec"
          },
          {
            "name": "single_no_escape/exception",
            "value": 17087226.9,
            "unit": "ops/sec"
          },
          {
            "name": "single_no_escape/tailrec",
            "value": 16493642.83,
            "unit": "ops/sec"
          },
          {
            "name": "single_no_escape/raphael",
            "value": 16578622.39,
            "unit": "ops/sec"
          },
          {
            "name": "two_no_escape/loop_all",
            "value": 13729668.57,
            "unit": "ops/sec"
          },
          {
            "name": "two_no_escape/exception",
            "value": 15271745.42,
            "unit": "ops/sec"
          },
          {
            "name": "two_no_escape/tailrec",
            "value": 14427563.24,
            "unit": "ops/sec"
          },
          {
            "name": "two_no_escape/raphael",
            "value": 14520641.07,
            "unit": "ops/sec"
          },
          {
            "name": "single_with_escape/loop_all",
            "value": 5925461.81,
            "unit": "ops/sec"
          },
          {
            "name": "single_with_escape/exception",
            "value": 6149835.09,
            "unit": "ops/sec"
          },
          {
            "name": "single_with_escape/tailrec",
            "value": 5871721.34,
            "unit": "ops/sec"
          },
          {
            "name": "single_with_escape/raphael",
            "value": 5632996.18,
            "unit": "ops/sec"
          },
          {
            "name": "two_with_escape/loop_all",
            "value": 3964315.67,
            "unit": "ops/sec"
          },
          {
            "name": "two_with_escape/exception",
            "value": 4455608.93,
            "unit": "ops/sec"
          },
          {
            "name": "two_with_escape/tailrec",
            "value": 4295385.29,
            "unit": "ops/sec"
          },
          {
            "name": "two_with_escape/raphael",
            "value": 3872180.76,
            "unit": "ops/sec"
          }
        ]
      }
    ]
  }
}