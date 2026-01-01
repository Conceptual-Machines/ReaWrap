#!/bin/bash
# Run ReaWrap tests via REAPER Web Interface
#
# Usage:
#   ./cli_runner.sh                    # Run core class tests
#   ./cli_runner.sh --imgui            # Run ImGui tests
#   ./cli_runner.sh --action <ID>      # Run specific action
#   ./cli_runner.sh --all              # Run all tests
#
# Requires: Portable REAPER running with web interface on port 8080

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Load action IDs from config
if [ -f "$SCRIPT_DIR/test_actions.env" ]; then
    source "$SCRIPT_DIR/test_actions.env"
fi

REAPER_PORT="${REAPER_PORT:-8080}"
REAPER_URL="http://localhost:$REAPER_PORT"
LOG_FILE="$SCRIPT_DIR/test_results.log"

# Action IDs (from test_actions.env or hardcoded fallback)
CORE_TESTS_ACTION="${CORE_TESTS_ACTION:-_RS8dfa8b4971e4fe118fb08585e61bb5c22a1cc941}"
IMGUI_TESTS_ACTION="${IMGUI_TESTS_ACTION:-_RSd6ac0813b222615301caec4c8d1f6f75a2a25627}"

# Check if REAPER web interface is available
check_reaper() {
    if ! curl -s "$REAPER_URL/" > /dev/null 2>&1; then
        echo "ERROR: REAPER web interface not available at $REAPER_URL"
        echo ""
        echo "Please start portable REAPER first:"
        echo "  open tests/reaper-portable/REAPER.app"
        exit 1
    fi
    echo "✓ REAPER web interface connected"
}

# Get action ID for a script (must be registered first)
get_action_id() {
    local script_name="$1"
    # This queries REAPER's action list - but we need the ID
    # For now, user needs to provide it or register manually
    echo ""
}

# Run an action by ID
run_action() {
    local action_id="$1"
    echo "Running action: $action_id"
    curl -s "$REAPER_URL/_/$action_id"
}

# Wait for test results
wait_for_results() {
    local timeout="${1:-60}"
    local elapsed=0

    rm -f "$LOG_FILE"

    echo "Waiting for test results..."
    while [ $elapsed -lt $timeout ]; do
        if [ -f "$LOG_FILE" ]; then
            sleep 1  # Let file finish writing
            echo ""
            echo "=== Test Results ==="
            cat "$LOG_FILE"
            echo "===================="

            if grep -q "Failed:  0" "$LOG_FILE"; then
                echo "✓ All tests passed!"
                return 0
            else
                echo "✗ Some tests failed"
                return 1
            fi
        fi
        sleep 1
        elapsed=$((elapsed + 1))
        echo -n "."
    done

    echo ""
    echo "Timeout waiting for results"
    return 1
}

# Main
check_reaper

case "${1:-}" in
    --action)
        if [ -z "$2" ]; then
            echo "Usage: $0 --action <action_id>"
            exit 1
        fi
        run_action "$2"
        wait_for_results
        ;;
    --imgui)
        echo "Running ImGui integration tests..."
        run_action "$IMGUI_TESTS_ACTION"
        echo "ImGui tests triggered - check REAPER for results window"
        ;;
    --core)
        echo "Running Core Classes tests..."
        run_action "$CORE_TESTS_ACTION"
        wait_for_results
        ;;
    --all)
        echo "Running all tests..."
        echo ""
        echo "=== Core Classes Tests ==="
        run_action "$CORE_TESTS_ACTION"
        wait_for_results 60 || true
        echo ""
        echo "=== ImGui Tests ==="
        run_action "$IMGUI_TESTS_ACTION"
        echo "ImGui tests triggered - check REAPER for results window"
        ;;
    --help)
        echo "ReaWrap CLI Test Runner"
        echo ""
        echo "Usage:"
        echo "  $0                    Show status and help"
        echo "  $0 --core             Run Core Classes tests"
        echo "  $0 --imgui            Run ImGui tests"
        echo "  $0 --all              Run all tests"
        echo "  $0 --action <ID>      Run action by command ID"
        echo ""
        echo "Environment:"
        echo "  REAPER_PORT           Web interface port (default: 8080)"
        echo ""
        echo "Action IDs:"
        echo "  Core:  $CORE_TESTS_ACTION"
        echo "  ImGui: $IMGUI_TESTS_ACTION"
        ;;
    *)
        echo "ReaWrap CLI Test Runner"
        echo ""
        echo "REAPER web interface: $REAPER_URL ✓"
        echo ""
        echo "Quick commands:"
        echo "  $0 --core     Run Core Classes tests"
        echo "  $0 --imgui    Run ImGui tests"
        echo "  $0 --all      Run all tests"
        echo "  $0 --help     Show all options"
        ;;
esac
