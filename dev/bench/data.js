window.BENCHMARK_DATA = {
  "lastUpdate": 1765983167483,
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
      },
      {
        "commit": {
          "author": {
            "email": "dsnxmoreno@gmail.com",
            "name": "David Sancho",
            "username": "davesnx"
          },
          "committer": {
            "email": "noreply@github.com",
            "name": "GitHub",
            "username": "web-flow"
          },
          "distinct": true,
          "id": "5b99997e012b2240a6424ce3ff17f9f54d98706d",
          "message": "Merge pull request #36 from davesnx/issue_7",
          "timestamp": "2025-12-17T11:26:36+01:00",
          "tree_id": "209decf3ed25db92a62fac0f2daba5d6aa2c9fb6",
          "url": "https://github.com/davesnx/html_of_jsx/commit/5b99997e012b2240a6424ce3ff17f9f54d98706d"
        },
        "date": 1765967780662,
        "tool": "customBiggerIsBetter",
        "benches": [
          {
            "name": "escape_clean/no_escape",
            "value": 22466142.67,
            "unit": "ops/sec"
          },
          {
            "name": "escape_clean/JSX.escape",
            "value": 15780491.33,
            "unit": "ops/sec"
          },
          {
            "name": "escape_dirty/no_escape",
            "value": 23013325.83,
            "unit": "ops/sec"
          },
          {
            "name": "escape_dirty/JSX.escape",
            "value": 5647549.91,
            "unit": "ops/sec"
          },
          {
            "name": "optional_disabled_some/optional_disabled_some",
            "value": 8502795.5,
            "unit": "ops/sec"
          },
          {
            "name": "optional_disabled_none/optional_disabled_none",
            "value": 9493295.54,
            "unit": "ops/sec"
          },
          {
            "name": "optional_aria/optional_aria",
            "value": 7637310.26,
            "unit": "ops/sec"
          },
          {
            "name": "optional_multiple/optional_multiple",
            "value": 4751769.51,
            "unit": "ops/sec"
          },
          {
            "name": "fragment_three/fragment_three",
            "value": 14571961.78,
            "unit": "ops/sec"
          },
          {
            "name": "fragment_five/fragment_five",
            "value": 10544678.41,
            "unit": "ops/sec"
          },
          {
            "name": "dynamic_attrs_wrapper/dynamic_attrs_wrapper",
            "value": 4994711.04,
            "unit": "ops/sec"
          },
          {
            "name": "dynamic_attrs_article/dynamic_attrs_article",
            "value": 5775227.83,
            "unit": "ops/sec"
          },
          {
            "name": "large_static_page/large_static_page",
            "value": 66094.42,
            "unit": "ops/sec"
          },
          {
            "name": "render_to_string/render_to_string",
            "value": 30945694.01,
            "unit": "ops/sec"
          },
          {
            "name": "render_to_channel/render_to_channel",
            "value": 223809.31,
            "unit": "ops/sec"
          },
          {
            "name": "render_streaming/render_streaming",
            "value": 30241130.71,
            "unit": "ops/sec"
          },
          {
            "name": "scenario_trivial/trivial",
            "value": 30284455.51,
            "unit": "ops/sec"
          },
          {
            "name": "scenario_deep/deep_tree_50",
            "value": 14668.97,
            "unit": "ops/sec"
          },
          {
            "name": "scenario_shallow/shallow_tree",
            "value": 71723.6,
            "unit": "ops/sec"
          },
          {
            "name": "scenario_wide/wide_tree_100",
            "value": 4057.15,
            "unit": "ops/sec"
          },
          {
            "name": "scenario_props/props_heavy",
            "value": 3295.7,
            "unit": "ops/sec"
          },
          {
            "name": "scenario_table/table_100",
            "value": 1619.95,
            "unit": "ops/sec"
          },
          {
            "name": "scenario_form/form",
            "value": 19111.53,
            "unit": "ops/sec"
          },
          {
            "name": "scenario_dashboard/dashboard",
            "value": 14341.2,
            "unit": "ops/sec"
          },
          {
            "name": "scenario_blog/blog_50",
            "value": 2099.32,
            "unit": "ops/sec"
          },
          {
            "name": "scenario_ecommerce/ecommerce_48",
            "value": 2110.04,
            "unit": "ops/sec"
          }
        ]
      },
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
          "id": "aeba28091aaa160890d710b9c5da913257d30cb5",
          "message": "Run benchmarks with summary",
          "timestamp": "2025-12-17T14:46:11Z",
          "tree_id": "7992901fa656fd6366c3121b96f3384cd4d08fa1",
          "url": "https://github.com/davesnx/html_of_jsx/commit/aeba28091aaa160890d710b9c5da913257d30cb5"
        },
        "date": 1765983167130,
        "tool": "customBiggerIsBetter",
        "benches": [
          {
            "name": "Trivial",
            "value": 31045949.8,
            "unit": "ops/sec"
          },
          {
            "name": "Dashboard",
            "value": 14330.85,
            "unit": "ops/sec"
          },
          {
            "name": "Blog (50 comments)",
            "value": 2041.23,
            "unit": "ops/sec"
          },
          {
            "name": "Table (100 rows)",
            "value": 1645.93,
            "unit": "ops/sec"
          },
          {
            "name": "E-commerce",
            "value": 2134.24,
            "unit": "ops/sec"
          },
          {
            "name": "Form",
            "value": 18414.48,
            "unit": "ops/sec"
          },
          {
            "name": "Deep tree (50)",
            "value": 14558.13,
            "unit": "ops/sec"
          },
          {
            "name": "Wide tree (100)",
            "value": 3811.25,
            "unit": "ops/sec"
          },
          {
            "name": "Shallow tree",
            "value": 72648.71,
            "unit": "ops/sec"
          },
          {
            "name": "Props heavy",
            "value": 3285.45,
            "unit": "ops/sec"
          },
          {
            "name": "escape (clean)",
            "value": 22173583.79,
            "unit": "ops/sec"
          },
          {
            "name": "escape (dirty)",
            "value": 6410384.1,
            "unit": "ops/sec"
          }
        ]
      }
    ]
  }
}