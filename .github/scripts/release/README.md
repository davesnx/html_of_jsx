# dune-release-action

Automatically release OCaml packages to opam using `dune-release` in GitHub Actions workflows 🚀

## Requirements

The action expects these tools to be available in your GitHub Actions environment:
- `opam` - OCaml package manager
- `dune-release` - Release automation tool

Install with:
```yaml
- uses: ocaml/setup-ocaml@v3
  with:
    ocaml-compiler: 5.3.0

- run: opam install dune-release -y
```

## Usage

### Simple example

```yaml
name: Release

on:
  push:
    # Trigger this workflow when a tag is pushed
    tags:
      - '*' # any tag push (e.g., v1.0.0, 0.0.6)

permissions:
  contents: write        # Required to create GitHub releases and push commits
  pull-requests: write   # Required to create PRs to opam-repository

jobs:
  release:
    runs-on: ubuntu-latest

    steps:
      - uses: actions/checkout@v4
        with:
          fetch-depth: 0

      # This is your current workflow
      - uses: ocaml/setup-ocaml@v3
        with:
          ocaml-compiler: 5.3.0
      - run: opam install . --deps-only
      - run: opam install dune-release -y

      # Add the dune-release-action
      - uses: ./.github/scripts/release
        with:
          package-name: 'your-package'
          github-token: ${{ secrets.GH_TOKEN }}
```

### Advanced example (all options)

```yaml
- uses: ./.github/scripts/release
  with:
    package-name: 'your-package'          # (required) The package's name to publish to the opam-repository
    changelog: './CHANGES.md'             # (required) Filename to extract PR descriptions and validate tag
    github-token: ${{ secrets.GH_TOKEN }} # (required) Personal token (classic) with `repo` and `workflow` scopes
    verbose: true                         # Show detailed logs
    to-opam-repository: true              # Submit PR to opam-repository
    to-github-releases: true              # Create GitHub release
```

## Inputs

### Required

| Input | Description | Example |
|-------|-------------|---------|
| `package-name` | Name of the package to release | `html_of_jsx` |
| `github-token` | GitHub token for API access | `${{ secrets.GH_TOKEN }}` |

Your `github-token` secret must have these scopes:
- ✅ `repo` - Full control of private repositories
- ✅ `workflow` - Update GitHub Action workflows (required for opam-repository PRs)

**To create or update your token:**

1. Go to https://github.com/settings/tokens
2. Create a new token (classic) or edit existing
3. Enable `repo` and `workflow` scopes
4. Add it to your repository secrets as `GH_TOKEN`

### Optional

| Input | Description | Default |
|-------|-------------|---------|
| `changelog` | Path to changelog file | `./CHANGES.md` |
| `verbose` | If true, shows detailed logging output | `false` |
| `to-opam-repository` | If true, submits a PR to opam-repository | `true` |
| `to-github-releases` | If true, creates a GitHub release | `true` |

### Changelog Format

Your `CHANGES.md` should follow this format:

```markdown
# Unreleased

(Optional - will trigger a warning if not empty)

## 0.0.6 (2025-10-13)

- Added new feature X
- Fixed bug in Y
- Improved performance of Z

## 0.0.5 (2025-10-01)

- Previous version changes
```

#### Supported Formats

- `## v1.0.0` - With 'v' prefix
- `## 1.0.0` - Without prefix
- `## 1.0.0 (2025-10-13)` - With date
- `## 1.0.0-beta.1` - Pre-release versions

## Outputs

| Output | Description |
|--------|-------------|
| `version` | Extracted version from git tag |
| `release-status` | Status of the release (`success` or `failed`) |

## License

MIT License - See [LICENSE](./LICENSE)
