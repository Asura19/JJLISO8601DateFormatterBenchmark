# JJLISO8601DateFormatter Benchmark

Performance comparison between the **Original Objective-C version** and **Swift port** of JJLISO8601DateFormatter.

📊 **[View Full Benchmark Report](BENCHMARK_REPORT.md)**

## Quick Summary

| Benchmark | OC Version | Swift Version | Winner |
|-----------|:----------:|:-------------:|:------:|
| **Construction** | ~18x | ~17x | ≈ Tie |
| **String → Date** | ~20x | ~23x | **Swift** |
| **Date → String** | ~6x | ~10x | **Swift** |

> All speedups relative to Apple's `ISO8601DateFormatter`

## Project Structure

```
JJLISO8601DateFormatterBenchmark/
├── iOS/                                    # iOS Benchmark Apps
│   ├── OCVersionBenchmark/                 # OC version iOS app
│   │   ├── iOSOCVersionBenchmark.xcworkspace  ← Open this
│   │   ├── App/
│   │   └── Package/
│   ├── SwiftVersionBenchmark/              # Swift version iOS app
│   │   ├── iOSSwiftVersionBenchmark.xcworkspace  ← Open this
│   │   ├── App/
│   │   └── Package/
│   └── Config/                             # Shared Xcode configs
│
├── macOS/                                  # macOS Command Line Tools
│   ├── OCVersionBenchmark/                 # OC version CLI
│   ├── SwiftVersionBenchmark/              # Swift version CLI
│   ├── compare_versions.sh                 # Run both benchmarks
│   └── benchmark_results_*.txt             # Saved results
│
├── BENCHMARK_REPORT.md                     # 📊 Full benchmark report
├── README.md
└── LICENSE
```

## Dependencies

- **OC Version**: https://github.com/michaeleisel/JJLISO8601DateFormatter
- **Swift Version**: https://github.com/Asura19/JJLISO8601DateFormatter

---

## 🍎 iOS Testing

### OC Version

```bash
open iOS/OCVersionBenchmark/iOSOCVersionBenchmark.xcworkspace
```

1. Select your iPhone device
2. Run (⌘R)
3. Tap "Start Benchmark"

### Swift Version

```bash
open iOS/SwiftVersionBenchmark/iOSSwiftVersionBenchmark.xcworkspace
```

1. Select your iPhone device
2. Run (⌘R)
3. Tap "Start Benchmark"

---

## 💻 macOS Testing

### Quick Compare

```bash
cd macOS && ./compare_versions.sh
```

### Individual Tests

```bash
# OC Version
cd macOS/OCVersionBenchmark
swift build -c release && swift run -c release

# Swift Version
cd macOS/SwiftVersionBenchmark
swift build -c release && swift run -c release
```

---

## Benchmark Details

### Test Cases

| Test | Iterations | Description |
|------|------------|-------------|
| Construction | 10,000 | Formatter object creation |
| String → Date | 100,000 | Parse ISO8601 strings |
| Date → String | 1,000,000 | Format dates to strings |

### Time Zones Tested

- `America/Sao_Paulo` (BRT)
- `America/Indiana/Indianapolis`
- `GMT`

### Format Options

```swift
[.withInternetDateTime, .withColonSeparatorInTimeZone, .withFractionalSeconds]
```

---

## Tips for Accurate Results

1. Run on physical devices (not simulators) for iOS
2. Use Release build configuration
3. Close other applications
4. Run multiple times and average results

---

## License

MIT License - See [LICENSE](LICENSE) for details.
