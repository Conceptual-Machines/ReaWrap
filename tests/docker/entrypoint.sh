#!/bin/bash
# REAPER Docker Entrypoint
#
# Starts REAPER with virtual display and web interface

set -e

# Start virtual framebuffer
echo "Starting Xvfb..."
Xvfb :99 -screen 0 1024x768x24 &
export DISPLAY=:99
sleep 2

# Start REAPER with portable config
echo "Starting REAPER..."
/opt/reaper/REAPER -cfgfile /opt/reaper-config/reaper.ini &
REAPER_PID=$!
sleep 5

# Wait for web interface to be ready
echo "Waiting for web interface on port 8080..."
for i in {1..30}; do
    if curl -s http://localhost:8080/ > /dev/null 2>&1; then
        echo "Web interface ready!"
        break
    fi
    sleep 1
done

# If an action ID is provided, run it
if [ -n "$TEST_ACTION_ID" ]; then
    echo "Running test action: $TEST_ACTION_ID"
    curl -s "http://localhost:8080/_/action:$TEST_ACTION_ID"

    # Wait for test to complete (check for log file)
    LOG_FILE="/opt/reawrap/tests/test_results.log"
    echo "Waiting for test results..."
    for i in {1..60}; do
        if [ -f "$LOG_FILE" ]; then
            echo ""
            echo "=== Test Results ==="
            cat "$LOG_FILE"

            # Check for success
            if grep -q "Failed:  0" "$LOG_FILE"; then
                echo "=== All tests passed! ==="
                exit 0
            else
                echo "=== Some tests failed ==="
                exit 1
            fi
        fi
        sleep 1
    done

    echo "Timeout waiting for test results"
    exit 1
else
    # Interactive mode - keep REAPER running
    echo ""
    echo "REAPER running with web interface at http://localhost:8080"
    echo "Press Ctrl+C to stop"
    echo ""
    wait $REAPER_PID
fi
