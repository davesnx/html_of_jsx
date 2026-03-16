window.BENCHMARK_DATA = {
  "lastUpdate": 1773689219399,
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
          "id": "5c4e0e7ceb6f2f118c32150adbd11e96edc7a220",
          "message": "Remove unused field",
          "timestamp": "2025-12-17T15:51:53Z",
          "tree_id": "6ead52409de09a49ece0d66e0cb3cdb2bce4baec",
          "url": "https://github.com/davesnx/html_of_jsx/commit/5c4e0e7ceb6f2f118c32150adbd11e96edc7a220"
        },
        "date": 1765987103999,
        "tool": "customBiggerIsBetter",
        "benches": [
          {
            "name": "Trivial",
            "value": 30636256.88,
            "unit": "ops/sec"
          },
          {
            "name": "Dashboard",
            "value": 13838.7,
            "unit": "ops/sec"
          },
          {
            "name": "Blog (50 comments)",
            "value": 2005.57,
            "unit": "ops/sec"
          },
          {
            "name": "Table (100 rows)",
            "value": 1637.24,
            "unit": "ops/sec"
          },
          {
            "name": "E-commerce",
            "value": 2090.27,
            "unit": "ops/sec"
          },
          {
            "name": "Form",
            "value": 18210.8,
            "unit": "ops/sec"
          },
          {
            "name": "Deep tree (50)",
            "value": 14415.07,
            "unit": "ops/sec"
          },
          {
            "name": "Wide tree (100)",
            "value": 3806.69,
            "unit": "ops/sec"
          },
          {
            "name": "Shallow tree",
            "value": 71524.75,
            "unit": "ops/sec"
          },
          {
            "name": "Props heavy",
            "value": 3232.29,
            "unit": "ops/sec"
          },
          {
            "name": "escape (clean)",
            "value": 21504900.57,
            "unit": "ops/sec"
          },
          {
            "name": "escape (dirty)",
            "value": 6391537.98,
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
          "id": "6c9c62f483334d26174bdf5076659549f24bc572",
          "message": "Remove unused field",
          "timestamp": "2025-12-17T15:52:58Z",
          "tree_id": "0464ae98a4379dc350fd8c2223a3bc0d26228d37",
          "url": "https://github.com/davesnx/html_of_jsx/commit/6c9c62f483334d26174bdf5076659549f24bc572"
        },
        "date": 1765987180310,
        "tool": "customBiggerIsBetter",
        "benches": [
          {
            "name": "Trivial",
            "value": 30887586.2,
            "unit": "ops/sec"
          },
          {
            "name": "Dashboard",
            "value": 14069.28,
            "unit": "ops/sec"
          },
          {
            "name": "Blog (50 comments)",
            "value": 2003.65,
            "unit": "ops/sec"
          },
          {
            "name": "Table (100 rows)",
            "value": 1627.6,
            "unit": "ops/sec"
          },
          {
            "name": "E-commerce",
            "value": 2095.75,
            "unit": "ops/sec"
          },
          {
            "name": "Form",
            "value": 18451.69,
            "unit": "ops/sec"
          },
          {
            "name": "Deep tree (50)",
            "value": 14495.56,
            "unit": "ops/sec"
          },
          {
            "name": "Wide tree (100)",
            "value": 3710.25,
            "unit": "ops/sec"
          },
          {
            "name": "Shallow tree",
            "value": 71102.9,
            "unit": "ops/sec"
          },
          {
            "name": "Props heavy",
            "value": 3287.75,
            "unit": "ops/sec"
          },
          {
            "name": "escape (clean)",
            "value": 22033476.67,
            "unit": "ops/sec"
          },
          {
            "name": "escape (dirty)",
            "value": 6455333.82,
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
          "id": "37b734524b3a7818a7bd58df0103ffbf0e1aa842",
          "message": "Merge pull request #39 from davesnx/windows-latest-in-ci",
          "timestamp": "2025-12-17T18:15:18+01:00",
          "tree_id": "9819f895566fe6690aab380d1be3fb496c9c698e",
          "url": "https://github.com/davesnx/html_of_jsx/commit/37b734524b3a7818a7bd58df0103ffbf0e1aa842"
        },
        "date": 1765992274783,
        "tool": "customBiggerIsBetter",
        "benches": [
          {
            "name": "Trivial",
            "value": 32966409.79,
            "unit": "ops/sec"
          },
          {
            "name": "Dashboard",
            "value": 14378.07,
            "unit": "ops/sec"
          },
          {
            "name": "Blog (50 comments)",
            "value": 1993.85,
            "unit": "ops/sec"
          },
          {
            "name": "Table (100 rows)",
            "value": 1610.32,
            "unit": "ops/sec"
          },
          {
            "name": "E-commerce",
            "value": 2107.32,
            "unit": "ops/sec"
          },
          {
            "name": "Form",
            "value": 18651.24,
            "unit": "ops/sec"
          },
          {
            "name": "Deep tree (50)",
            "value": 15640.78,
            "unit": "ops/sec"
          },
          {
            "name": "Wide tree (100)",
            "value": 3880.75,
            "unit": "ops/sec"
          },
          {
            "name": "Shallow tree",
            "value": 72942.41,
            "unit": "ops/sec"
          },
          {
            "name": "Props heavy",
            "value": 3290.66,
            "unit": "ops/sec"
          },
          {
            "name": "escape (clean)",
            "value": 22212261.03,
            "unit": "ops/sec"
          },
          {
            "name": "escape (dirty)",
            "value": 7126226.28,
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
          "id": "01bf4e06407c9dbfaa44310b30c15e43a6567d60",
          "message": "Delete guide",
          "timestamp": "2025-12-18T14:05:53Z",
          "tree_id": "de38b2e989182ff438f885cfe4ec58bb0eb48464",
          "url": "https://github.com/davesnx/html_of_jsx/commit/01bf4e06407c9dbfaa44310b30c15e43a6567d60"
        },
        "date": 1766067286315,
        "tool": "customBiggerIsBetter",
        "benches": [
          {
            "name": "Trivial",
            "value": 32360374.27,
            "unit": "ops/sec"
          },
          {
            "name": "Dashboard",
            "value": 14265.05,
            "unit": "ops/sec"
          },
          {
            "name": "Blog (50 comments)",
            "value": 2037.31,
            "unit": "ops/sec"
          },
          {
            "name": "Table (100 rows)",
            "value": 1642.48,
            "unit": "ops/sec"
          },
          {
            "name": "E-commerce",
            "value": 2143.24,
            "unit": "ops/sec"
          },
          {
            "name": "Form",
            "value": 18865.94,
            "unit": "ops/sec"
          },
          {
            "name": "Deep tree (50)",
            "value": 15832.11,
            "unit": "ops/sec"
          },
          {
            "name": "Wide tree (100)",
            "value": 3970.39,
            "unit": "ops/sec"
          },
          {
            "name": "Shallow tree",
            "value": 73642.21,
            "unit": "ops/sec"
          },
          {
            "name": "Props heavy",
            "value": 3349.73,
            "unit": "ops/sec"
          },
          {
            "name": "escape (clean)",
            "value": 22451151.97,
            "unit": "ops/sec"
          },
          {
            "name": "escape (dirty)",
            "value": 7292166.49,
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
          "id": "e3fa4bce6b0eee909ea1a2c6b569f463be429fbf",
          "message": "Merge pull request #40 from davesnx/Implement-polyvariants-as-attributes\n\nImplement polyvariants as attributes",
          "timestamp": "2026-02-23T18:32:09+01:00",
          "tree_id": "86e6d8c0c59c6e347fbf132b9bb2717d3e3bafa7",
          "url": "https://github.com/davesnx/html_of_jsx/commit/e3fa4bce6b0eee909ea1a2c6b569f463be429fbf"
        },
        "date": 1771868571277,
        "tool": "customBiggerIsBetter",
        "benches": [
          {
            "name": "Trivial",
            "value": 31150096.64,
            "unit": "ops/sec"
          },
          {
            "name": "Dashboard",
            "value": 14525.47,
            "unit": "ops/sec"
          },
          {
            "name": "Blog (50 comments)",
            "value": 1957.02,
            "unit": "ops/sec"
          },
          {
            "name": "Table (100 rows)",
            "value": 1586.76,
            "unit": "ops/sec"
          },
          {
            "name": "E-commerce",
            "value": 2093.12,
            "unit": "ops/sec"
          },
          {
            "name": "Form",
            "value": 18880.62,
            "unit": "ops/sec"
          },
          {
            "name": "Deep tree (50)",
            "value": 15670.21,
            "unit": "ops/sec"
          },
          {
            "name": "Wide tree (100)",
            "value": 4007.71,
            "unit": "ops/sec"
          },
          {
            "name": "Shallow tree",
            "value": 73088.41,
            "unit": "ops/sec"
          },
          {
            "name": "Props heavy",
            "value": 3308.35,
            "unit": "ops/sec"
          },
          {
            "name": "escape (clean)",
            "value": 22219013.6,
            "unit": "ops/sec"
          },
          {
            "name": "escape (dirty)",
            "value": 6655067.59,
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
          "id": "89ab09261d97a7bfeb10754358c3875c6b7d3b49",
          "message": "feat: create html_of_jsx.htmx lib",
          "timestamp": "2026-02-24T00:27:28Z",
          "tree_id": "d974654ca04f08bcc3aa580e62f3fbb062dbb934",
          "url": "https://github.com/davesnx/html_of_jsx/commit/89ab09261d97a7bfeb10754358c3875c6b7d3b49"
        },
        "date": 1771893266665,
        "tool": "customBiggerIsBetter",
        "benches": [
          {
            "name": "Trivial",
            "value": 31011107.25,
            "unit": "ops/sec"
          },
          {
            "name": "Dashboard",
            "value": 14258.62,
            "unit": "ops/sec"
          },
          {
            "name": "Blog (50 comments)",
            "value": 2008.6,
            "unit": "ops/sec"
          },
          {
            "name": "Table (100 rows)",
            "value": 1616.65,
            "unit": "ops/sec"
          },
          {
            "name": "E-commerce",
            "value": 2114.9,
            "unit": "ops/sec"
          },
          {
            "name": "Form",
            "value": 18492.5,
            "unit": "ops/sec"
          },
          {
            "name": "Deep tree (50)",
            "value": 15319.89,
            "unit": "ops/sec"
          },
          {
            "name": "Wide tree (100)",
            "value": 3938.07,
            "unit": "ops/sec"
          },
          {
            "name": "Shallow tree",
            "value": 71819.3,
            "unit": "ops/sec"
          },
          {
            "name": "Props heavy",
            "value": 3272.85,
            "unit": "ops/sec"
          },
          {
            "name": "escape (clean)",
            "value": 22070978.29,
            "unit": "ops/sec"
          },
          {
            "name": "escape (dirty)",
            "value": 7038810.56,
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
          "id": "44d47d1ae603ea3f75a201664bab00104ba6f2eb",
          "message": "Prepare 0.0.8",
          "timestamp": "2026-02-24T00:32:20Z",
          "tree_id": "5f74b93c97e32427dc6e78e8d43a484e20ebf56f",
          "url": "https://github.com/davesnx/html_of_jsx/commit/44d47d1ae603ea3f75a201664bab00104ba6f2eb"
        },
        "date": 1771893560170,
        "tool": "customBiggerIsBetter",
        "benches": [
          {
            "name": "Trivial",
            "value": 30693959.38,
            "unit": "ops/sec"
          },
          {
            "name": "Dashboard",
            "value": 14153.99,
            "unit": "ops/sec"
          },
          {
            "name": "Blog (50 comments)",
            "value": 1989.22,
            "unit": "ops/sec"
          },
          {
            "name": "Table (100 rows)",
            "value": 1601.62,
            "unit": "ops/sec"
          },
          {
            "name": "E-commerce",
            "value": 2093.61,
            "unit": "ops/sec"
          },
          {
            "name": "Form",
            "value": 18558.63,
            "unit": "ops/sec"
          },
          {
            "name": "Deep tree (50)",
            "value": 15614.2,
            "unit": "ops/sec"
          },
          {
            "name": "Wide tree (100)",
            "value": 3881.22,
            "unit": "ops/sec"
          },
          {
            "name": "Shallow tree",
            "value": 71528.81,
            "unit": "ops/sec"
          },
          {
            "name": "Props heavy",
            "value": 3282.74,
            "unit": "ops/sec"
          },
          {
            "name": "escape (clean)",
            "value": 22681401.91,
            "unit": "ops/sec"
          },
          {
            "name": "escape (dirty)",
            "value": 7080117.39,
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
          "id": "92d19df93289eda22d90e5a77fe0cc7770122252",
          "message": "Merge pull request #43 from davesnx/docs/odoc-audit-improvements\n\nImprove documentation",
          "timestamp": "2026-03-15T19:17:26+01:00",
          "tree_id": "864550b24f90c2ad0ac2b1b7ade38cacdb1ca0e3",
          "url": "https://github.com/davesnx/html_of_jsx/commit/92d19df93289eda22d90e5a77fe0cc7770122252"
        },
        "date": 1773599089413,
        "tool": "customBiggerIsBetter",
        "benches": [
          {
            "name": "Trivial",
            "value": 30801010.14,
            "unit": "ops/sec"
          },
          {
            "name": "Dashboard",
            "value": 14101.71,
            "unit": "ops/sec"
          },
          {
            "name": "Blog (50 comments)",
            "value": 2008.4,
            "unit": "ops/sec"
          },
          {
            "name": "Table (100 rows)",
            "value": 1600.07,
            "unit": "ops/sec"
          },
          {
            "name": "E-commerce",
            "value": 2113.2,
            "unit": "ops/sec"
          },
          {
            "name": "Form",
            "value": 18710.02,
            "unit": "ops/sec"
          },
          {
            "name": "Deep tree (50)",
            "value": 15474.05,
            "unit": "ops/sec"
          },
          {
            "name": "Wide tree (100)",
            "value": 3904.77,
            "unit": "ops/sec"
          },
          {
            "name": "Shallow tree",
            "value": 73047.37,
            "unit": "ops/sec"
          },
          {
            "name": "Props heavy",
            "value": 3290.35,
            "unit": "ops/sec"
          },
          {
            "name": "escape (clean)",
            "value": 21694624.36,
            "unit": "ops/sec"
          },
          {
            "name": "escape (dirty)",
            "value": 7143956.36,
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
          "id": "8ee97cb076cdd5a4d9356d2fbf4856f5d1aa8cbc",
          "message": "Fix CI and fonts",
          "timestamp": "2026-03-16T19:09:33Z",
          "tree_id": "34f90f36140c55c5fdb54cae9685ec621cb99ca4",
          "url": "https://github.com/davesnx/html_of_jsx/commit/8ee97cb076cdd5a4d9356d2fbf4856f5d1aa8cbc"
        },
        "date": 1773689219082,
        "tool": "customBiggerIsBetter",
        "benches": [
          {
            "name": "Trivial",
            "value": 29615623.45,
            "unit": "ops/sec"
          },
          {
            "name": "Dashboard",
            "value": 19586.52,
            "unit": "ops/sec"
          },
          {
            "name": "Blog (50 comments)",
            "value": 48940.8,
            "unit": "ops/sec"
          },
          {
            "name": "Table (100 rows)",
            "value": 28360.69,
            "unit": "ops/sec"
          },
          {
            "name": "E-commerce",
            "value": 40935.2,
            "unit": "ops/sec"
          },
          {
            "name": "Form",
            "value": 25428.88,
            "unit": "ops/sec"
          },
          {
            "name": "Deep tree (50)",
            "value": 9085.25,
            "unit": "ops/sec"
          },
          {
            "name": "Wide tree (100)",
            "value": 4551.76,
            "unit": "ops/sec"
          },
          {
            "name": "Shallow tree",
            "value": 67779.43,
            "unit": "ops/sec"
          },
          {
            "name": "Props heavy",
            "value": 4798.51,
            "unit": "ops/sec"
          },
          {
            "name": "escape (clean)",
            "value": 21366062.87,
            "unit": "ops/sec"
          },
          {
            "name": "escape (dirty)",
            "value": 6284313.11,
            "unit": "ops/sec"
          }
        ]
      }
    ]
  }
}