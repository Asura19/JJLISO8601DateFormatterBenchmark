#!/bin/bash

# JJLISO8601DateFormatter Version Comparison Script
# Directly compares OC version vs Swift version performance

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
RESULTS_FILE="$SCRIPT_DIR/comparison_results_$(date +%Y%m%d_%H%M%S).txt"

# Colors for terminal output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}"
echo "=================================================================="
echo " JJLISO8601DateFormatter Version Comparison"
echo " OC Version (michaeleisel) vs Swift Version (Asura19)"
echo "=================================================================="
echo -e "${NC}"

# Build both versions
echo -e "${YELLOW}Building OC Version...${NC}"
cd "$SCRIPT_DIR/OCVersionBenchmark"
swift build -c release 2>/dev/null

echo -e "${YELLOW}Building Swift Version...${NC}"
cd "$SCRIPT_DIR/SwiftVersionBenchmark"
swift build -c release 2>/dev/null

echo -e "${GREEN}Both versions built successfully!${NC}"
echo ""

# Create results file header
{
    echo "=================================================================="
    echo " JJLISO8601DateFormatter Performance Comparison Report"
    echo "=================================================================="
    echo ""
    echo "Date: $(date)"
    echo "macOS Version: $(sw_vers -productVersion)"
    echo "Swift Version: $(swift --version | head -1)"
    echo ""
    echo "=================================================================="
    echo ""
} > "$RESULTS_FILE"

echo -e "${BLUE}Running OC Version Benchmark...${NC}"
echo ""
{
    echo "### OC VERSION (michaeleisel/JJLISO8601DateFormatter) ###"
    echo ""
} >> "$RESULTS_FILE"

cd "$SCRIPT_DIR/OCVersionBenchmark"
swift run -c release 2>/dev/null | tee -a "$RESULTS_FILE"

echo ""
echo -e "${BLUE}Running Swift Version Benchmark...${NC}"
echo ""
{
    echo ""
    echo ""
    echo "### SWIFT VERSION (Asura19/JJLISO8601DateFormatter) ###"
    echo ""
} >> "$RESULTS_FILE"

cd "$SCRIPT_DIR/SwiftVersionBenchmark"
swift run -c release 2>/dev/null | tee -a "$RESULTS_FILE"

echo ""
echo -e "${GREEN}=================================================================="
echo " Comparison Complete!"
echo "==================================================================${NC}"
echo ""
echo -e "Results saved to: ${YELLOW}$RESULTS_FILE${NC}"
echo ""
echo -e "${BLUE}Summary:${NC}"
echo "  - OC Version: Original implementation by michaeleisel"
echo "  - Swift Version: Swift rewrite by Asura19"
echo ""
echo "Compare the results above to see the performance difference!"
