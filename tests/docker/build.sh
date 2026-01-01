#!/bin/bash
# Build the ReaWrap test Docker image
#
# Usage:
#   ./build.sh          # Build image
#   ./build.sh run      # Build and run interactively
#   ./build.sh test     # Build and run tests (requires TEST_ACTION_ID)

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$(dirname "$SCRIPT_DIR")")"

cd "$PROJECT_ROOT"

echo "Building ReaWrap test Docker image..."
docker build -f tests/docker/Dockerfile -t reawrap-test .

case "${1:-}" in
    run)
        echo ""
        echo "Starting REAPER in Docker..."
        echo "Web interface will be at http://localhost:8080"
        echo ""
        docker run --rm -it -p 8080:8080 reawrap-test
        ;;
    test)
        if [ -z "$TEST_ACTION_ID" ]; then
            echo "ERROR: TEST_ACTION_ID not set"
            echo "Usage: TEST_ACTION_ID=_RSxxxx ./build.sh test"
            exit 1
        fi
        echo ""
        echo "Running tests with action: $TEST_ACTION_ID"
        docker run --rm -e TEST_ACTION_ID="$TEST_ACTION_ID" reawrap-test
        ;;
    *)
        echo ""
        echo "Image built: reawrap-test"
        echo ""
        echo "Usage:"
        echo "  ./build.sh run      # Run interactively"
        echo "  ./build.sh test     # Run tests (set TEST_ACTION_ID)"
        ;;
esac
