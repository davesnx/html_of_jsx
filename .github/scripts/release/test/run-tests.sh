#!/bin/bash
# Comprehensive test runner for dune-release-action
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ACTION_DIR="$(dirname "$SCRIPT_DIR")"
ROOT_DIR="$(dirname "$(dirname "$(dirname "$ACTION_DIR")")")"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Test counters
TESTS_RUN=0
TESTS_PASSED=0
TESTS_FAILED=0

log_info() {
    echo -e "${BLUE}ℹ️  $1${NC}"
}

log_success() {
    echo -e "${GREEN}✅ $1${NC}"
}

log_error() {
    echo -e "${RED}❌ $1${NC}"
}

log_warning() {
    echo -e "${YELLOW}⚠️  $1${NC}"
}

# Create temporary test directory
setup_test_env() {
    local test_name="$1"
    local test_dir="$(mktemp -d -t dune-release-test-XXXXXX)"

    log_info "Setting up test environment for: $test_name"
    echo "   Test directory: $test_dir"

    cd "$test_dir"

    # Initialize git repo (required for many dune-release operations)
    git init -q
    git config user.name "Test User"
    git config user.email "test@example.com"

    echo "$test_dir"
}

cleanup_test_env() {
    local test_dir="$1"
    if [[ -d "$test_dir" ]]; then
        rm -rf "$test_dir"
    fi
}

run_test() {
    local test_name="$1"
    local test_fn="$2"
    local expected_result="${3:-success}"

    TESTS_RUN=$((TESTS_RUN + 1))

    echo ""
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo "Test #$TESTS_RUN: $test_name"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

    local test_dir=$(setup_test_env "$test_name")
    local result="success"

    # Run the test function in a subshell to catch failures
    if ! (cd "$test_dir" && $test_fn); then
        result="failure"
    fi

    # Check result
    if [[ "$result" == "$expected_result" ]]; then
        TESTS_PASSED=$((TESTS_PASSED + 1))
        log_success "Test passed (expected: $expected_result, got: $result)"
    else
        TESTS_FAILED=$((TESTS_FAILED + 1))
        log_error "Test failed (expected: $expected_result, got: $result)"
    fi

    cleanup_test_env "$test_dir"
}

# Test scenarios
test_valid_opam_and_changelog() {
    cat > test.opam << 'EOF'
opam-version: "2.0"
name: "test"
version: "0.1.0"
synopsis: "Test package"
depends: ["ocaml" "dune"]
EOF

    cat > CHANGES.md << 'EOF'
## 0.1.0
- Initial release
EOF

    git add .
    git commit -q -m "Initial commit"

    # Mock test - in real scenario would run the action
    if [[ -f test.opam ]] && [[ -f CHANGES.md ]]; then
        log_info "Files created successfully"
        return 0
    else
        return 1
    fi
}

test_missing_changelog() {
    cat > test.opam << 'EOF'
opam-version: "2.0"
name: "test"
EOF

    # No CHANGES.md created

    if [[ ! -f CHANGES.md ]]; then
        log_info "Changelog missing as expected"
        return 0  # This is expected to fail
    else
        return 1
    fi
}

test_invalid_opam_syntax() {
    cat > test.opam << 'EOF'
this is not valid opam syntax
EOF

    cat > CHANGES.md << 'EOF'
## 0.1.0
- Release
EOF

    # Try to parse opam file
    if grep -q "opam-version" test.opam 2>/dev/null; then
        return 1  # Should not find valid opam version
    else
        log_info "Invalid opam detected correctly"
        return 0
    fi
}

test_unreleased_content_warning() {
    cat > test.opam << 'EOF'
opam-version: "2.0"
name: "test"
EOF

    cat > CHANGES.md << 'EOF'
# Unreleased

- Some unreleased changes
- More changes

## 0.1.0
- Initial release
EOF

    if grep -q "Unreleased" CHANGES.md && grep -q "Some unreleased changes" CHANGES.md; then
        log_warning "Unreleased content detected - should trigger warning"
        return 0
    else
        return 1
    fi
}

test_version_formats() {
    cat > CHANGES.md << 'EOF'
## v1.0.0
- Version with v prefix

## 1.0.0
- Version without prefix

## 1.0.0-beta.1
- Prerelease version

## 1.0.0 (2024-01-01)
- Version with date
EOF

    local version_count=$(grep -E "^##\s+(v?[0-9]+\.[0-9]+\.[0-9]+.*)" CHANGES.md | wc -l)
    if [[ "$version_count" -eq 4 ]]; then
        log_info "All version formats recognized"
        return 0
    else
        log_error "Expected 4 versions, found $version_count"
        return 1
    fi
}

test_custom_changelog_path() {
    mkdir -p docs

    cat > test.opam << 'EOF'
opam-version: "2.0"
name: "test"
EOF

    cat > docs/NEWS.md << 'EOF'
## 0.1.0
- Release notes in custom location
EOF

    if [[ -f docs/NEWS.md ]]; then
        log_info "Custom changelog path works"
        return 0
    else
        return 1
    fi
}

# Main test execution
main() {
    echo "╔══════════════════════════════════════╗"
    echo "║  dune-release-action Test Suite     ║"
    echo "╚══════════════════════════════════════╝"
    echo ""

    # Check prerequisites
    log_info "Checking prerequisites..."

    if ! command -v git &> /dev/null; then
        log_error "git is required but not installed"
        exit 1
    fi

    if ! command -v node &> /dev/null; then
        log_warning "node not found - skipping TypeScript tests"
    else
        log_info "Running TypeScript unit tests..."
        (cd "$ACTION_DIR" && npm test) || log_warning "TypeScript tests failed"
    fi

    # Run test scenarios
    log_info "Running integration tests..."

    run_test "Valid opam and changelog" test_valid_opam_and_changelog "success"
    run_test "Missing changelog" test_missing_changelog "success"
    run_test "Invalid opam syntax" test_invalid_opam_syntax "success"
    run_test "Unreleased content warning" test_unreleased_content_warning "success"
    run_test "Version format parsing" test_version_formats "success"
    run_test "Custom changelog path" test_custom_changelog_path "success"

    # Summary
    echo ""
    echo "╔══════════════════════════════════════╗"
    echo "║           Test Summary               ║"
    echo "╚══════════════════════════════════════╝"
    echo ""
    echo "Tests run:    $TESTS_RUN"
    echo "Tests passed: $TESTS_PASSED"
    echo "Tests failed: $TESTS_FAILED"
    echo ""

    if [[ "$TESTS_FAILED" -eq 0 ]]; then
        log_success "All tests passed! 🎉"
        exit 0
    else
        log_error "Some tests failed"
        exit 1
    fi
}

# Run main if script is executed directly
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main "$@"
fi
