#!/bin/bash

# JJLISO8601DateFormatter Benchmark Runner
# Compares OC version (michaeleisel) vs Swift version (Asura19)

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
RESULTS_FILE="$SCRIPT_DIR/benchmark_results_$(date +%Y%m%d_%H%M%S).txt"

echo "=================================================="
echo " JJLISO8601DateFormatter Performance Comparison"
echo " OC Version vs Swift Version"
echo "=================================================="
echo ""
echo "Results will be saved to: $RESULTS_FILE"
echo ""

# Function to run a benchmark
run_benchmark() {
    local dir=$1
    local name=$2
    
    echo "Building and running $name..."
    cd "$SCRIPT_DIR/$dir"
    
    # Resolve dependencies and build
    swift build -c release 2>/dev/null
    
    # Run the benchmark
    swift run -c release 2>/dev/null
}

# Run both benchmarks and capture output
{
    echo "=================================================="
    echo " Benchmark Date: $(date)"
    echo " macOS Version: $(sw_vers -productVersion)"
    echo " Swift Version: $(swift --version | head -1)"
    echo "=================================================="
    echo ""
    
    echo ""
    echo "##################################################"
    echo "# OC VERSION (Original - michaeleisel)"
    echo "##################################################"
    run_benchmark "OCVersionBenchmark" "OC Version"
    
    echo ""
    echo ""
    echo "##################################################"
    echo "# SWIFT VERSION (Asura19)"  
    echo "##################################################"
    run_benchmark "SwiftVersionBenchmark" "Swift Version"
    
    echo ""
    echo "=================================================="
    echo " Benchmark Complete!"
    echo "=================================================="
    
} 2>&1 | tee "$RESULTS_FILE"

echo ""
echo "Results saved to: $RESULTS_FILE"
