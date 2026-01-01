#!/bin/bash
# Run ReaWrap integration tests using REAPER CLI
#
# Usage:
#   ./run_tests.sh [--test-project path/to/project.rpp]
#
# Requirements:
#   - REAPER installed at /Applications/REAPER.app (macOS)
#   - ReaImGui extension installed (for ImGui tests)
#
# The script will:
#   1. Launch REAPER with the test script
#   2. Wait for tests to complete
#   3. Check the log file for results
#   4. Return appropriate exit code

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(dirname "$(dirname "$SCRIPT_DIR")")"
LOG_FILE="$SCRIPT_DIR/test_results.log"

# Default REAPER path (macOS)
REAPER_PATH="/Applications/REAPER.app/Contents/MacOS/REAPER"

# Test script to run
TEST_SCRIPT="$SCRIPT_DIR/test_core_classes.lua"

# Optional test project
TEST_PROJECT=""

# Parse arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        --test-project)
            TEST_PROJECT="$2"
            shift 2
            ;;
        --reaper-path)
            REAPER_PATH="$2"
            shift 2
            ;;
        --imgui)
            TEST_SCRIPT="$SCRIPT_DIR/test_imgui_integration.lua"
            shift
            ;;
        --visual)
            TEST_SCRIPT="$SCRIPT_DIR/test_imgui_visual.lua"
            shift
            ;;
        --help)
            echo "Usage: $0 [options]"
            echo ""
            echo "Options:"
            echo "  --test-project PATH   Open a specific project file for testing"
            echo "  --reaper-path PATH    Path to REAPER executable"
            echo "  --imgui               Run ImGui integration tests"
            echo "  --visual              Run ImGui visual tests (interactive)"
            echo "  --help                Show this help"
            echo ""
            echo "Examples:"
            echo "  $0                                    # Run core class tests"
            echo "  $0 --imgui                            # Run ImGui tests"
            echo "  $0 --test-project tests/TestProject/TestProject.RPP"
            exit 0
            ;;
        *)
            echo "Unknown option: $1"
            exit 1
            ;;
    esac
done

# Check REAPER exists
if [[ ! -f "$REAPER_PATH" ]]; then
    echo "ERROR: REAPER not found at $REAPER_PATH"
    echo "       Use --reaper-path to specify location"
    exit 1
fi

# Check test script exists
if [[ ! -f "$TEST_SCRIPT" ]]; then
    echo "ERROR: Test script not found: $TEST_SCRIPT"
    exit 1
fi

# Remove old log file
rm -f "$LOG_FILE"

echo "ReaWrap Integration Tests"
echo "========================="
echo ""
echo "REAPER: $REAPER_PATH"
echo "Test Script: $TEST_SCRIPT"
if [[ -n "$TEST_PROJECT" ]]; then
    echo "Project: $TEST_PROJECT"
fi
echo ""

# Build REAPER command
REAPER_CMD="$REAPER_PATH"
REAPER_ARGS=(-newinst)

if [[ -n "$TEST_PROJECT" ]]; then
    REAPER_ARGS+=("$TEST_PROJECT")
fi

# Note: REAPER's -script option doesn't work in all versions
# We'll need to use an alternative approach
echo "Starting REAPER..."
echo ""
echo "IMPORTANT: This will open REAPER with a new instance."
echo "           You need to manually run the test script:"
echo ""
echo "  1. In REAPER, go to Actions > Show action list"
echo "  2. Click 'New action...' > 'Load ReaScript...'"
echo "  3. Select: $TEST_SCRIPT"
echo "  4. Run the script"
echo ""
echo "After tests complete, check: $LOG_FILE"
echo ""

# For now, just open REAPER - full CLI automation requires more setup
if [[ -n "$TEST_PROJECT" ]]; then
    "$REAPER_PATH" -newinst "$TEST_PROJECT" &
else
    "$REAPER_PATH" -newinst &
fi

echo "REAPER launched. Waiting for tests..."
echo ""

# Wait for log file to be created (with timeout)
TIMEOUT=300  # 5 minutes
ELAPSED=0

while [[ ! -f "$LOG_FILE" ]] && [[ $ELAPSED -lt $TIMEOUT ]]; do
    sleep 2
    ELAPSED=$((ELAPSED + 2))
    echo -n "."
done
echo ""

if [[ ! -f "$LOG_FILE" ]]; then
    echo ""
    echo "Timeout waiting for test results."
    echo "Please run the test script manually in REAPER."
    exit 1
fi

# Give a moment for file to be fully written
sleep 2

# Display results
echo ""
echo "Test Results:"
echo "============="
cat "$LOG_FILE"
echo ""

# Check for failures
if grep -q "Failed:  0" "$LOG_FILE"; then
    echo "✓ All tests passed!"
    exit 0
else
    echo "✗ Some tests failed"
    exit 1
fi
