window.BENCHMARK_DATA = {
  "lastUpdate": 1776084881199,
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
          "id": "94b71453830cca30aa8a98f9ab16c26862ece290",
          "message": "Fix docs contents",
          "timestamp": "2026-03-16T20:28:11Z",
          "tree_id": "bf4241103716ed5c045a7cd3a70a015726a0ba96",
          "url": "https://github.com/davesnx/html_of_jsx/commit/94b71453830cca30aa8a98f9ab16c26862ece290"
        },
        "date": 1773693919370,
        "tool": "customBiggerIsBetter",
        "benches": [
          {
            "name": "Trivial",
            "value": 31005498.25,
            "unit": "ops/sec"
          },
          {
            "name": "Dashboard",
            "value": 19882.16,
            "unit": "ops/sec"
          },
          {
            "name": "Blog (50 comments)",
            "value": 49888.44,
            "unit": "ops/sec"
          },
          {
            "name": "Table (100 rows)",
            "value": 29023.4,
            "unit": "ops/sec"
          },
          {
            "name": "E-commerce",
            "value": 41976.02,
            "unit": "ops/sec"
          },
          {
            "name": "Form",
            "value": 25574.13,
            "unit": "ops/sec"
          },
          {
            "name": "Deep tree (50)",
            "value": 9319.3,
            "unit": "ops/sec"
          },
          {
            "name": "Wide tree (100)",
            "value": 4682.75,
            "unit": "ops/sec"
          },
          {
            "name": "Shallow tree",
            "value": 68952.89,
            "unit": "ops/sec"
          },
          {
            "name": "Props heavy",
            "value": 4880.5,
            "unit": "ops/sec"
          },
          {
            "name": "escape (clean)",
            "value": 21102204.36,
            "unit": "ops/sec"
          },
          {
            "name": "escape (dirty)",
            "value": 6449018.58,
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
          "id": "276073d13355ddbeea1f35e456f513968650e7fc",
          "message": "Create dark theme",
          "timestamp": "2026-03-16T22:49:47Z",
          "tree_id": "c0bfbb5e12756f2661797e5188bfb3c7b7bb3300",
          "url": "https://github.com/davesnx/html_of_jsx/commit/276073d13355ddbeea1f35e456f513968650e7fc"
        },
        "date": 1773702436086,
        "tool": "customBiggerIsBetter",
        "benches": [
          {
            "name": "Trivial",
            "value": 30412125,
            "unit": "ops/sec"
          },
          {
            "name": "Dashboard",
            "value": 19764.22,
            "unit": "ops/sec"
          },
          {
            "name": "Blog (50 comments)",
            "value": 52839.76,
            "unit": "ops/sec"
          },
          {
            "name": "Table (100 rows)",
            "value": 29614.17,
            "unit": "ops/sec"
          },
          {
            "name": "E-commerce",
            "value": 42669.8,
            "unit": "ops/sec"
          },
          {
            "name": "Form",
            "value": 25515.92,
            "unit": "ops/sec"
          },
          {
            "name": "Deep tree (50)",
            "value": 9298.89,
            "unit": "ops/sec"
          },
          {
            "name": "Wide tree (100)",
            "value": 4710.67,
            "unit": "ops/sec"
          },
          {
            "name": "Shallow tree",
            "value": 68100.21,
            "unit": "ops/sec"
          },
          {
            "name": "Props heavy",
            "value": 4852.75,
            "unit": "ops/sec"
          },
          {
            "name": "escape (clean)",
            "value": 21446167.25,
            "unit": "ops/sec"
          },
          {
            "name": "escape (dirty)",
            "value": 6263676.2,
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
          "id": "1564cb8ea06bd2c6bc5041eefb58c2bad295e303",
          "message": "Polish links on docs",
          "timestamp": "2026-03-17T01:50:16Z",
          "tree_id": "db6b0a3f76deaad5c8b011f8d00ce4e8c9823748",
          "url": "https://github.com/davesnx/html_of_jsx/commit/1564cb8ea06bd2c6bc5041eefb58c2bad295e303"
        },
        "date": 1773713247891,
        "tool": "customBiggerIsBetter",
        "benches": [
          {
            "name": "Trivial",
            "value": 29601293.55,
            "unit": "ops/sec"
          },
          {
            "name": "Dashboard",
            "value": 19509.54,
            "unit": "ops/sec"
          },
          {
            "name": "Blog (50 comments)",
            "value": 51858.1,
            "unit": "ops/sec"
          },
          {
            "name": "Table (100 rows)",
            "value": 28411.48,
            "unit": "ops/sec"
          },
          {
            "name": "E-commerce",
            "value": 40726.49,
            "unit": "ops/sec"
          },
          {
            "name": "Form",
            "value": 25337.06,
            "unit": "ops/sec"
          },
          {
            "name": "Deep tree (50)",
            "value": 9275.83,
            "unit": "ops/sec"
          },
          {
            "name": "Wide tree (100)",
            "value": 4653.82,
            "unit": "ops/sec"
          },
          {
            "name": "Shallow tree",
            "value": 68547.13,
            "unit": "ops/sec"
          },
          {
            "name": "Props heavy",
            "value": 4849.07,
            "unit": "ops/sec"
          },
          {
            "name": "escape (clean)",
            "value": 21457761.24,
            "unit": "ops/sec"
          },
          {
            "name": "escape (dirty)",
            "value": 6439640.08,
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
          "id": "44ac00365970b712c64465dd54a0d82548bfd4be",
          "message": "Polish links on docs",
          "timestamp": "2026-03-17T01:51:40Z",
          "tree_id": "a94160ac10b6d9e8a87477c7f0091de4f064831e",
          "url": "https://github.com/davesnx/html_of_jsx/commit/44ac00365970b712c64465dd54a0d82548bfd4be"
        },
        "date": 1773713335693,
        "tool": "customBiggerIsBetter",
        "benches": [
          {
            "name": "Trivial",
            "value": 30258421.09,
            "unit": "ops/sec"
          },
          {
            "name": "Dashboard",
            "value": 19212.25,
            "unit": "ops/sec"
          },
          {
            "name": "Blog (50 comments)",
            "value": 50557.26,
            "unit": "ops/sec"
          },
          {
            "name": "Table (100 rows)",
            "value": 29337.07,
            "unit": "ops/sec"
          },
          {
            "name": "E-commerce",
            "value": 42284.73,
            "unit": "ops/sec"
          },
          {
            "name": "Form",
            "value": 25282.3,
            "unit": "ops/sec"
          },
          {
            "name": "Deep tree (50)",
            "value": 9136.53,
            "unit": "ops/sec"
          },
          {
            "name": "Wide tree (100)",
            "value": 4691.19,
            "unit": "ops/sec"
          },
          {
            "name": "Shallow tree",
            "value": 67874.66,
            "unit": "ops/sec"
          },
          {
            "name": "Props heavy",
            "value": 4833.93,
            "unit": "ops/sec"
          },
          {
            "name": "escape (clean)",
            "value": 21462138.09,
            "unit": "ops/sec"
          },
          {
            "name": "escape (dirty)",
            "value": 6319189.25,
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
          "id": "e3569fd8bb814345bc744c2b21e59de038e398ab",
          "message": "More docs",
          "timestamp": "2026-03-17T03:31:21Z",
          "tree_id": "cad1cf4153d76b775cc9ad8c47ca224a96a726a5",
          "url": "https://github.com/davesnx/html_of_jsx/commit/e3569fd8bb814345bc744c2b21e59de038e398ab"
        },
        "date": 1773719336968,
        "tool": "customBiggerIsBetter",
        "benches": [
          {
            "name": "Trivial",
            "value": 31418401.67,
            "unit": "ops/sec"
          },
          {
            "name": "Dashboard",
            "value": 19800.1,
            "unit": "ops/sec"
          },
          {
            "name": "Blog (50 comments)",
            "value": 50399.23,
            "unit": "ops/sec"
          },
          {
            "name": "Table (100 rows)",
            "value": 29096.16,
            "unit": "ops/sec"
          },
          {
            "name": "E-commerce",
            "value": 41252.57,
            "unit": "ops/sec"
          },
          {
            "name": "Form",
            "value": 25332.03,
            "unit": "ops/sec"
          },
          {
            "name": "Deep tree (50)",
            "value": 9209.67,
            "unit": "ops/sec"
          },
          {
            "name": "Wide tree (100)",
            "value": 4602.79,
            "unit": "ops/sec"
          },
          {
            "name": "Shallow tree",
            "value": 68543.87,
            "unit": "ops/sec"
          },
          {
            "name": "Props heavy",
            "value": 4767.56,
            "unit": "ops/sec"
          },
          {
            "name": "escape (clean)",
            "value": 22036187.32,
            "unit": "ops/sec"
          },
          {
            "name": "escape (dirty)",
            "value": 6435231.82,
            "unit": "ops/sec"
          }
        ]
      },
      {
        "commit": {
          "author": {
            "email": "dsnxmoreno@gmail.com",
            "name": "David Sancho Moreno",
            "username": "davesnx"
          },
          "committer": {
            "email": "dsnxmoreno@gmail.com",
            "name": "David Sancho Moreno",
            "username": "davesnx"
          },
          "distinct": true,
          "id": "00e20ac20a83496b3cff25c074607f3edfaa6f86",
          "message": "Delete old design doc",
          "timestamp": "2026-03-17T12:05:15+01:00",
          "tree_id": "c98093cefd9c863e87cd4e145eea116914cbe645",
          "url": "https://github.com/davesnx/html_of_jsx/commit/00e20ac20a83496b3cff25c074607f3edfaa6f86"
        },
        "date": 1773746549599,
        "tool": "customBiggerIsBetter",
        "benches": [
          {
            "name": "Trivial",
            "value": 30284894.06,
            "unit": "ops/sec"
          },
          {
            "name": "Dashboard",
            "value": 19684.59,
            "unit": "ops/sec"
          },
          {
            "name": "Blog (50 comments)",
            "value": 50480.63,
            "unit": "ops/sec"
          },
          {
            "name": "Table (100 rows)",
            "value": 29417.83,
            "unit": "ops/sec"
          },
          {
            "name": "E-commerce",
            "value": 42637.21,
            "unit": "ops/sec"
          },
          {
            "name": "Form",
            "value": 25624.37,
            "unit": "ops/sec"
          },
          {
            "name": "Deep tree (50)",
            "value": 9185.55,
            "unit": "ops/sec"
          },
          {
            "name": "Wide tree (100)",
            "value": 4693.95,
            "unit": "ops/sec"
          },
          {
            "name": "Shallow tree",
            "value": 68265.97,
            "unit": "ops/sec"
          },
          {
            "name": "Props heavy",
            "value": 4800.38,
            "unit": "ops/sec"
          },
          {
            "name": "escape (clean)",
            "value": 21626677.03,
            "unit": "ops/sec"
          },
          {
            "name": "escape (dirty)",
            "value": 6225916.69,
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
          "id": "b0cfe862ac1ed7679934617cacc0d6ee7892aae8",
          "message": "Add dependencies from docs",
          "timestamp": "2026-03-17T19:01:29Z",
          "tree_id": "c596ccc7509857995778f78ae1c69e7b505ce760",
          "url": "https://github.com/davesnx/html_of_jsx/commit/b0cfe862ac1ed7679934617cacc0d6ee7892aae8"
        },
        "date": 1773775189734,
        "tool": "customBiggerIsBetter",
        "benches": [
          {
            "name": "Trivial",
            "value": 29823888.72,
            "unit": "ops/sec"
          },
          {
            "name": "Dashboard",
            "value": 19816.29,
            "unit": "ops/sec"
          },
          {
            "name": "Blog (50 comments)",
            "value": 53284.96,
            "unit": "ops/sec"
          },
          {
            "name": "Table (100 rows)",
            "value": 29594.74,
            "unit": "ops/sec"
          },
          {
            "name": "E-commerce",
            "value": 42609.74,
            "unit": "ops/sec"
          },
          {
            "name": "Form",
            "value": 25430.24,
            "unit": "ops/sec"
          },
          {
            "name": "Deep tree (50)",
            "value": 9229.92,
            "unit": "ops/sec"
          },
          {
            "name": "Wide tree (100)",
            "value": 4660.49,
            "unit": "ops/sec"
          },
          {
            "name": "Shallow tree",
            "value": 67975.6,
            "unit": "ops/sec"
          },
          {
            "name": "Props heavy",
            "value": 4816.27,
            "unit": "ops/sec"
          },
          {
            "name": "escape (clean)",
            "value": 21898860.13,
            "unit": "ops/sec"
          },
          {
            "name": "escape (dirty)",
            "value": 6374620.25,
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
          "id": "670ddd491be2c4aca4ad445c94dbdbcf9ac0e6c8",
          "message": "Add gh link",
          "timestamp": "2026-03-18T19:53:34Z",
          "tree_id": "8980dc99c60cc3c43ec03f203fb9145b2cacdcc2",
          "url": "https://github.com/davesnx/html_of_jsx/commit/670ddd491be2c4aca4ad445c94dbdbcf9ac0e6c8"
        },
        "date": 1773864710390,
        "tool": "customBiggerIsBetter",
        "benches": [
          {
            "name": "Trivial",
            "value": 30751985.89,
            "unit": "ops/sec"
          },
          {
            "name": "Dashboard",
            "value": 19513.74,
            "unit": "ops/sec"
          },
          {
            "name": "Blog (50 comments)",
            "value": 51736.12,
            "unit": "ops/sec"
          },
          {
            "name": "Table (100 rows)",
            "value": 28615.32,
            "unit": "ops/sec"
          },
          {
            "name": "E-commerce",
            "value": 40884.88,
            "unit": "ops/sec"
          },
          {
            "name": "Form",
            "value": 24895.24,
            "unit": "ops/sec"
          },
          {
            "name": "Deep tree (50)",
            "value": 9213.95,
            "unit": "ops/sec"
          },
          {
            "name": "Wide tree (100)",
            "value": 4690.65,
            "unit": "ops/sec"
          },
          {
            "name": "Shallow tree",
            "value": 67433.68,
            "unit": "ops/sec"
          },
          {
            "name": "Props heavy",
            "value": 4747.46,
            "unit": "ops/sec"
          },
          {
            "name": "escape (clean)",
            "value": 20881831.58,
            "unit": "ops/sec"
          },
          {
            "name": "escape (dirty)",
            "value": 6305288.28,
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
          "id": "3c2c37344d47f1e5fbccf4b84bcd503703d25105",
          "message": "Pin dependencies in ci",
          "timestamp": "2026-03-18T19:56:35Z",
          "tree_id": "57a00a65253489e42eba4d77ac2ea28309db8e30",
          "url": "https://github.com/davesnx/html_of_jsx/commit/3c2c37344d47f1e5fbccf4b84bcd503703d25105"
        },
        "date": 1773865032436,
        "tool": "customBiggerIsBetter",
        "benches": [
          {
            "name": "Trivial",
            "value": 29677132.73,
            "unit": "ops/sec"
          },
          {
            "name": "Dashboard",
            "value": 19405.29,
            "unit": "ops/sec"
          },
          {
            "name": "Blog (50 comments)",
            "value": 50911.82,
            "unit": "ops/sec"
          },
          {
            "name": "Table (100 rows)",
            "value": 27988.06,
            "unit": "ops/sec"
          },
          {
            "name": "E-commerce",
            "value": 40787.17,
            "unit": "ops/sec"
          },
          {
            "name": "Form",
            "value": 25350.51,
            "unit": "ops/sec"
          },
          {
            "name": "Deep tree (50)",
            "value": 9182.15,
            "unit": "ops/sec"
          },
          {
            "name": "Wide tree (100)",
            "value": 4663.52,
            "unit": "ops/sec"
          },
          {
            "name": "Shallow tree",
            "value": 67839.85,
            "unit": "ops/sec"
          },
          {
            "name": "Props heavy",
            "value": 4774.35,
            "unit": "ops/sec"
          },
          {
            "name": "escape (clean)",
            "value": 21511544.21,
            "unit": "ops/sec"
          },
          {
            "name": "escape (dirty)",
            "value": 6415188.47,
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
          "id": "073301584c1821a3163149dd033fc8f9ad6001ba",
          "message": "Format build_site",
          "timestamp": "2026-03-19T18:43:53Z",
          "tree_id": "c47a50b40ef73ac2d90fc7ad08e886208b4e45f7",
          "url": "https://github.com/davesnx/html_of_jsx/commit/073301584c1821a3163149dd033fc8f9ad6001ba"
        },
        "date": 1773946923059,
        "tool": "customBiggerIsBetter",
        "benches": [
          {
            "name": "Trivial",
            "value": 30817860.2,
            "unit": "ops/sec"
          },
          {
            "name": "Dashboard",
            "value": 19391.84,
            "unit": "ops/sec"
          },
          {
            "name": "Blog (50 comments)",
            "value": 51975.98,
            "unit": "ops/sec"
          },
          {
            "name": "Table (100 rows)",
            "value": 28466.46,
            "unit": "ops/sec"
          },
          {
            "name": "E-commerce",
            "value": 40870.75,
            "unit": "ops/sec"
          },
          {
            "name": "Form",
            "value": 25045.15,
            "unit": "ops/sec"
          },
          {
            "name": "Deep tree (50)",
            "value": 9258.05,
            "unit": "ops/sec"
          },
          {
            "name": "Wide tree (100)",
            "value": 4678.8,
            "unit": "ops/sec"
          },
          {
            "name": "Shallow tree",
            "value": 66941.46,
            "unit": "ops/sec"
          },
          {
            "name": "Props heavy",
            "value": 4814.9,
            "unit": "ops/sec"
          },
          {
            "name": "escape (clean)",
            "value": 21904159.94,
            "unit": "ops/sec"
          },
          {
            "name": "escape (dirty)",
            "value": 6219439.34,
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
          "id": "5647a3d5c758b5a4e7ca3b6134b3cfc199800b0e",
          "message": "Improve watch mode and remove md from the repo",
          "timestamp": "2026-03-20T17:35:02Z",
          "tree_id": "ca22ac1d6eaccdcbf9aead1178b5908dafb6755c",
          "url": "https://github.com/davesnx/html_of_jsx/commit/5647a3d5c758b5a4e7ca3b6134b3cfc199800b0e"
        },
        "date": 1774029199924,
        "tool": "customBiggerIsBetter",
        "benches": [
          {
            "name": "Trivial",
            "value": 29946399.73,
            "unit": "ops/sec"
          },
          {
            "name": "Dashboard",
            "value": 19666.62,
            "unit": "ops/sec"
          },
          {
            "name": "Blog (50 comments)",
            "value": 48824.99,
            "unit": "ops/sec"
          },
          {
            "name": "Table (100 rows)",
            "value": 26452.67,
            "unit": "ops/sec"
          },
          {
            "name": "E-commerce",
            "value": 37261.67,
            "unit": "ops/sec"
          },
          {
            "name": "Form",
            "value": 25031.02,
            "unit": "ops/sec"
          },
          {
            "name": "Deep tree (50)",
            "value": 9347.4,
            "unit": "ops/sec"
          },
          {
            "name": "Wide tree (100)",
            "value": 4763.89,
            "unit": "ops/sec"
          },
          {
            "name": "Shallow tree",
            "value": 67557.43,
            "unit": "ops/sec"
          },
          {
            "name": "Props heavy",
            "value": 4782.32,
            "unit": "ops/sec"
          },
          {
            "name": "escape (clean)",
            "value": 21810290.7,
            "unit": "ops/sec"
          },
          {
            "name": "escape (dirty)",
            "value": 6510867.28,
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
          "id": "81d9c58700d0dffa5aaa43265ac725d53eca7a84",
          "message": "Update pins",
          "timestamp": "2026-03-20T19:06:21Z",
          "tree_id": "2cb821d5b4c516a0388bf8a1fb20f3f1a74412a0",
          "url": "https://github.com/davesnx/html_of_jsx/commit/81d9c58700d0dffa5aaa43265ac725d53eca7a84"
        },
        "date": 1774034672402,
        "tool": "customBiggerIsBetter",
        "benches": [
          {
            "name": "Trivial",
            "value": 30193911.7,
            "unit": "ops/sec"
          },
          {
            "name": "Dashboard",
            "value": 19603.62,
            "unit": "ops/sec"
          },
          {
            "name": "Blog (50 comments)",
            "value": 49600.16,
            "unit": "ops/sec"
          },
          {
            "name": "Table (100 rows)",
            "value": 28613.41,
            "unit": "ops/sec"
          },
          {
            "name": "E-commerce",
            "value": 39932.17,
            "unit": "ops/sec"
          },
          {
            "name": "Form",
            "value": 25226.17,
            "unit": "ops/sec"
          },
          {
            "name": "Deep tree (50)",
            "value": 9266.42,
            "unit": "ops/sec"
          },
          {
            "name": "Wide tree (100)",
            "value": 4630.8,
            "unit": "ops/sec"
          },
          {
            "name": "Shallow tree",
            "value": 67584.08,
            "unit": "ops/sec"
          },
          {
            "name": "Props heavy",
            "value": 4817.94,
            "unit": "ops/sec"
          },
          {
            "name": "escape (clean)",
            "value": 22109783.91,
            "unit": "ops/sec"
          },
          {
            "name": "escape (dirty)",
            "value": 6268073.37,
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
          "id": "8cbdb2358543a70b14e90ff82deee66fa05e0b2c",
          "message": "Fix header flex",
          "timestamp": "2026-03-20T20:01:18Z",
          "tree_id": "6756f8d0f27c523830b3c7dce84c8dafc6c39349",
          "url": "https://github.com/davesnx/html_of_jsx/commit/8cbdb2358543a70b14e90ff82deee66fa05e0b2c"
        },
        "date": 1774037977788,
        "tool": "customBiggerIsBetter",
        "benches": [
          {
            "name": "Trivial",
            "value": 31112052.91,
            "unit": "ops/sec"
          },
          {
            "name": "Dashboard",
            "value": 19521.11,
            "unit": "ops/sec"
          },
          {
            "name": "Blog (50 comments)",
            "value": 52048.49,
            "unit": "ops/sec"
          },
          {
            "name": "Table (100 rows)",
            "value": 28941.43,
            "unit": "ops/sec"
          },
          {
            "name": "E-commerce",
            "value": 41122.18,
            "unit": "ops/sec"
          },
          {
            "name": "Form",
            "value": 25351.58,
            "unit": "ops/sec"
          },
          {
            "name": "Deep tree (50)",
            "value": 9306.75,
            "unit": "ops/sec"
          },
          {
            "name": "Wide tree (100)",
            "value": 4667.37,
            "unit": "ops/sec"
          },
          {
            "name": "Shallow tree",
            "value": 67944.28,
            "unit": "ops/sec"
          },
          {
            "name": "Props heavy",
            "value": 4852.17,
            "unit": "ops/sec"
          },
          {
            "name": "escape (clean)",
            "value": 21043989.84,
            "unit": "ops/sec"
          },
          {
            "name": "escape (dirty)",
            "value": 6247157.41,
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
          "id": "1285d17aeb9d7b293c96a0a2c8de2bad109e5109",
          "message": "Fix windows ci, by avoiding pinning",
          "timestamp": "2026-03-20T20:27:19Z",
          "tree_id": "cee52fa8831ffc69365055fda18e2a57807c3d98",
          "url": "https://github.com/davesnx/html_of_jsx/commit/1285d17aeb9d7b293c96a0a2c8de2bad109e5109"
        },
        "date": 1774039524160,
        "tool": "customBiggerIsBetter",
        "benches": [
          {
            "name": "Trivial",
            "value": 30713478.59,
            "unit": "ops/sec"
          },
          {
            "name": "Dashboard",
            "value": 19360.62,
            "unit": "ops/sec"
          },
          {
            "name": "Blog (50 comments)",
            "value": 51996.9,
            "unit": "ops/sec"
          },
          {
            "name": "Table (100 rows)",
            "value": 28117.57,
            "unit": "ops/sec"
          },
          {
            "name": "E-commerce",
            "value": 41579.31,
            "unit": "ops/sec"
          },
          {
            "name": "Form",
            "value": 24662.05,
            "unit": "ops/sec"
          },
          {
            "name": "Deep tree (50)",
            "value": 9140.71,
            "unit": "ops/sec"
          },
          {
            "name": "Wide tree (100)",
            "value": 4486.2,
            "unit": "ops/sec"
          },
          {
            "name": "Shallow tree",
            "value": 64466.31,
            "unit": "ops/sec"
          },
          {
            "name": "Props heavy",
            "value": 4767.19,
            "unit": "ops/sec"
          },
          {
            "name": "escape (clean)",
            "value": 20911681.61,
            "unit": "ops/sec"
          },
          {
            "name": "escape (dirty)",
            "value": 6257673.16,
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
          "id": "9bd5b77ca2acfdacef73e8f4f32bf5a13b776c30",
          "message": "Implement JSX.pp",
          "timestamp": "2026-04-13T10:37:07Z",
          "tree_id": "52880fe87a6c43defc5cfd6d0aeb22f461124a0b",
          "url": "https://github.com/davesnx/html_of_jsx/commit/9bd5b77ca2acfdacef73e8f4f32bf5a13b776c30"
        },
        "date": 1776077956780,
        "tool": "customBiggerIsBetter",
        "benches": [
          {
            "name": "Trivial",
            "value": 30678515.03,
            "unit": "ops/sec"
          },
          {
            "name": "Dashboard",
            "value": 19467.31,
            "unit": "ops/sec"
          },
          {
            "name": "Blog (50 comments)",
            "value": 53878.9,
            "unit": "ops/sec"
          },
          {
            "name": "Table (100 rows)",
            "value": 30322.34,
            "unit": "ops/sec"
          },
          {
            "name": "E-commerce",
            "value": 42480.34,
            "unit": "ops/sec"
          },
          {
            "name": "Form",
            "value": 25055.91,
            "unit": "ops/sec"
          },
          {
            "name": "Deep tree (50)",
            "value": 9171.73,
            "unit": "ops/sec"
          },
          {
            "name": "Wide tree (100)",
            "value": 4676.38,
            "unit": "ops/sec"
          },
          {
            "name": "Shallow tree",
            "value": 66427.39,
            "unit": "ops/sec"
          },
          {
            "name": "Props heavy",
            "value": 4714.6,
            "unit": "ops/sec"
          },
          {
            "name": "escape (clean)",
            "value": 21352437.01,
            "unit": "ops/sec"
          },
          {
            "name": "escape (dirty)",
            "value": 6510390.15,
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
          "id": "db73ecf18bcfd356ac72344159c8e193ca249318",
          "message": "Prepare 0.0.9",
          "timestamp": "2026-04-13T10:38:19Z",
          "tree_id": "e3e5414c6a39762d19cf7f886a46a254dc649f98",
          "url": "https://github.com/davesnx/html_of_jsx/commit/db73ecf18bcfd356ac72344159c8e193ca249318"
        },
        "date": 1776078010901,
        "tool": "customBiggerIsBetter",
        "benches": [
          {
            "name": "Trivial",
            "value": 31059885.46,
            "unit": "ops/sec"
          },
          {
            "name": "Dashboard",
            "value": 20176.69,
            "unit": "ops/sec"
          },
          {
            "name": "Blog (50 comments)",
            "value": 51663.98,
            "unit": "ops/sec"
          },
          {
            "name": "Table (100 rows)",
            "value": 30163.43,
            "unit": "ops/sec"
          },
          {
            "name": "E-commerce",
            "value": 43181.05,
            "unit": "ops/sec"
          },
          {
            "name": "Form",
            "value": 25582,
            "unit": "ops/sec"
          },
          {
            "name": "Deep tree (50)",
            "value": 9187.11,
            "unit": "ops/sec"
          },
          {
            "name": "Wide tree (100)",
            "value": 4628.68,
            "unit": "ops/sec"
          },
          {
            "name": "Shallow tree",
            "value": 67454.58,
            "unit": "ops/sec"
          },
          {
            "name": "Props heavy",
            "value": 4716.74,
            "unit": "ops/sec"
          },
          {
            "name": "escape (clean)",
            "value": 21076908.98,
            "unit": "ops/sec"
          },
          {
            "name": "escape (dirty)",
            "value": 6517676.25,
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
          "id": "13345d5e38d76b8ac01061245e4b964262301817",
          "message": "Fix data attributes",
          "timestamp": "2026-04-13T11:02:28Z",
          "tree_id": "e601d4941137af2f8e316f7564621bf6dfe86495",
          "url": "https://github.com/davesnx/html_of_jsx/commit/13345d5e38d76b8ac01061245e4b964262301817"
        },
        "date": 1776079254807,
        "tool": "customBiggerIsBetter",
        "benches": [
          {
            "name": "Trivial",
            "value": 31233018.15,
            "unit": "ops/sec"
          },
          {
            "name": "Dashboard",
            "value": 19752.93,
            "unit": "ops/sec"
          },
          {
            "name": "Blog (50 comments)",
            "value": 45473.08,
            "unit": "ops/sec"
          },
          {
            "name": "Table (100 rows)",
            "value": 27144.27,
            "unit": "ops/sec"
          },
          {
            "name": "E-commerce",
            "value": 38636.03,
            "unit": "ops/sec"
          },
          {
            "name": "Form",
            "value": 24839.85,
            "unit": "ops/sec"
          },
          {
            "name": "Deep tree (50)",
            "value": 9002.92,
            "unit": "ops/sec"
          },
          {
            "name": "Wide tree (100)",
            "value": 4640.48,
            "unit": "ops/sec"
          },
          {
            "name": "Shallow tree",
            "value": 68210.2,
            "unit": "ops/sec"
          },
          {
            "name": "Props heavy",
            "value": 4764.77,
            "unit": "ops/sec"
          },
          {
            "name": "escape (clean)",
            "value": 21562528.54,
            "unit": "ops/sec"
          },
          {
            "name": "escape (dirty)",
            "value": 6384460.31,
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
          "id": "a2b1b8456df05abff743df6d14b5f0514f90d31b",
          "message": "Update actions to latest in ci",
          "timestamp": "2026-04-13T11:11:15Z",
          "tree_id": "4043a3b241a572b453d6004d3865488748cc76c9",
          "url": "https://github.com/davesnx/html_of_jsx/commit/a2b1b8456df05abff743df6d14b5f0514f90d31b"
        },
        "date": 1776079979704,
        "tool": "customBiggerIsBetter",
        "benches": [
          {
            "name": "Trivial",
            "value": 30550331.09,
            "unit": "ops/sec"
          },
          {
            "name": "Dashboard",
            "value": 19852.79,
            "unit": "ops/sec"
          },
          {
            "name": "Blog (50 comments)",
            "value": 49932.3,
            "unit": "ops/sec"
          },
          {
            "name": "Table (100 rows)",
            "value": 28194.39,
            "unit": "ops/sec"
          },
          {
            "name": "E-commerce",
            "value": 38736.54,
            "unit": "ops/sec"
          },
          {
            "name": "Form",
            "value": 24918.68,
            "unit": "ops/sec"
          },
          {
            "name": "Deep tree (50)",
            "value": 9418.9,
            "unit": "ops/sec"
          },
          {
            "name": "Wide tree (100)",
            "value": 4872.55,
            "unit": "ops/sec"
          },
          {
            "name": "Shallow tree",
            "value": 67970.43,
            "unit": "ops/sec"
          },
          {
            "name": "Props heavy",
            "value": 4850.75,
            "unit": "ops/sec"
          },
          {
            "name": "escape (clean)",
            "value": 22992830.83,
            "unit": "ops/sec"
          },
          {
            "name": "escape (dirty)",
            "value": 6409875.67,
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
          "id": "a9258e5a811ff0dd459f239aacf01b2db1683a89",
          "message": "Fix links for README and docs",
          "timestamp": "2026-04-13T11:31:38Z",
          "tree_id": "2d274af6155f5d89e4c5e0ddcf734448eabff333",
          "url": "https://github.com/davesnx/html_of_jsx/commit/a9258e5a811ff0dd459f239aacf01b2db1683a89"
        },
        "date": 1776081002206,
        "tool": "customBiggerIsBetter",
        "benches": [
          {
            "name": "Trivial",
            "value": 30966610.2,
            "unit": "ops/sec"
          },
          {
            "name": "Dashboard",
            "value": 18842.03,
            "unit": "ops/sec"
          },
          {
            "name": "Blog (50 comments)",
            "value": 52461.16,
            "unit": "ops/sec"
          },
          {
            "name": "Table (100 rows)",
            "value": 28833.72,
            "unit": "ops/sec"
          },
          {
            "name": "E-commerce",
            "value": 41401.48,
            "unit": "ops/sec"
          },
          {
            "name": "Form",
            "value": 24606.9,
            "unit": "ops/sec"
          },
          {
            "name": "Deep tree (50)",
            "value": 9100.15,
            "unit": "ops/sec"
          },
          {
            "name": "Wide tree (100)",
            "value": 4625,
            "unit": "ops/sec"
          },
          {
            "name": "Shallow tree",
            "value": 67256.04,
            "unit": "ops/sec"
          },
          {
            "name": "Props heavy",
            "value": 4684.24,
            "unit": "ops/sec"
          },
          {
            "name": "escape (clean)",
            "value": 21007374.66,
            "unit": "ops/sec"
          },
          {
            "name": "escape (dirty)",
            "value": 6492431.57,
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
          "id": "d3297551fea3adc2f6fec4ada0b4c8e756988c6d",
          "message": "Does this fix the ci in windows?",
          "timestamp": "2026-04-13T12:36:27Z",
          "tree_id": "515f98aadad4b2bcefa5d2ab08dc33289824393f",
          "url": "https://github.com/davesnx/html_of_jsx/commit/d3297551fea3adc2f6fec4ada0b4c8e756988c6d"
        },
        "date": 1776084880536,
        "tool": "customBiggerIsBetter",
        "benches": [
          {
            "name": "Trivial",
            "value": 31502567.2,
            "unit": "ops/sec"
          },
          {
            "name": "Dashboard",
            "value": 19702.64,
            "unit": "ops/sec"
          },
          {
            "name": "Blog (50 comments)",
            "value": 54302.79,
            "unit": "ops/sec"
          },
          {
            "name": "Table (100 rows)",
            "value": 30391.69,
            "unit": "ops/sec"
          },
          {
            "name": "E-commerce",
            "value": 43377.07,
            "unit": "ops/sec"
          },
          {
            "name": "Form",
            "value": 25289.58,
            "unit": "ops/sec"
          },
          {
            "name": "Deep tree (50)",
            "value": 9342.75,
            "unit": "ops/sec"
          },
          {
            "name": "Wide tree (100)",
            "value": 4679.01,
            "unit": "ops/sec"
          },
          {
            "name": "Shallow tree",
            "value": 67873.01,
            "unit": "ops/sec"
          },
          {
            "name": "Props heavy",
            "value": 4654,
            "unit": "ops/sec"
          },
          {
            "name": "escape (clean)",
            "value": 21500345.81,
            "unit": "ops/sec"
          },
          {
            "name": "escape (dirty)",
            "value": 6478635.48,
            "unit": "ops/sec"
          }
        ]
      }
    ]
  }
}