#!/bin/bash

# Test the release action locally with dry-run mode
echo "🧪 Testing release action locally (dry-run mode)"
echo "================================================"

# Clean up any previous test runs
if [ -d "/tmp/opam-repository-test" ]; then
  echo "🧹 Cleaning up previous test directory..."
  rm -rf /tmp/opam-repository-test
fi

# Set up environment variables as GitHub Actions would
export GITHUB_REF="refs/tags/v1.0.0-test"
export GITHUB_REPOSITORY="davesnx/html_of_jsx"
export GITHUB_WORKSPACE="/Users/davesnx/Code/github/davesnx/html_of_jsx"
export GITHUB_ACTOR="davesnx"

# Set up action inputs (GitHub Actions passes these as INPUT_ env vars)
# GitHub Actions converts hyphens to underscores in env var names
# But @actions/core expects the underscore version
export INPUT_PACKAGE_NAME="html_of_jsx"
export INPUT_CHANGELOG="./CHANGES.md"
export INPUT_GITHUB_TOKEN="${GH_TOKEN:-test-token}" # Use real token if available
export INPUT_DRY_RUN="false"  # Running WITHOUT dry-run - will attempt real submission!

# Override the opam-repository local path for local testing
export INPUT_OPAM_REPO_LOCAL="/tmp/opam-repository-test"

# Change to workspace directory
cd "$GITHUB_WORKSPACE"

echo "📦 Package: $INPUT_PACKAGE_NAME"
echo "📝 Changelog: $INPUT_CHANGELOG"
echo "🏷️  Tag: ${GITHUB_REF#refs/tags/}"
if [ "$INPUT_DRY_RUN" = "true" ]; then
  echo "🔧 Mode: DRY RUN (safe)"
else
  echo "🚨 Mode: FULL RELEASE (will submit to opam-repository!)"
fi
echo ""

# Run the compiled action with properly formatted environment variables
# @actions/core expects hyphens in the variable names, which bash doesn't allow in export
echo "🚀 Running action..."
env \
  "INPUT_PACKAGE-NAME=$INPUT_PACKAGE_NAME" \
  "INPUT_CHANGELOG=$INPUT_CHANGELOG" \
  "INPUT_GITHUB-TOKEN=$INPUT_GITHUB_TOKEN" \
  "INPUT_DRY-RUN=$INPUT_DRY_RUN" \
  "INPUT_OPAM-REPO-LOCAL=$INPUT_OPAM_REPO_LOCAL" \
  node .github/scripts/release/dist/index.js

echo ""
echo "✅ Test completed!"

# Optional cleanup
echo "🧹 Cleaning up test directory..."
rm -rf /tmp/opam-repository-test 2>/dev/null || true
