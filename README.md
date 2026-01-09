# JJLISO8601DateFormatter Benchmark

Performance comparison between the **Original Objective-C version** and **Swift port** of JJLISO8601DateFormatter.

📊 **[View Full Benchmark Report](BENCHMARK_REPORT.md)**

## Quick Summary: OC vs Swift Direct Comparison

### iOS (iPhone 16, iOS 26.1)

| Benchmark | OC | Swift | Winner |
|-----------|:--:|:-----:|:------:|
| **Construction** | 0.053s | 0.057s | OC (7% faster) |
| **String → Date** | 0.117s | 0.116s | ≈ Tie |
| **Date → String** | 0.159s | 0.105s | **Swift (34% faster)** ⭐ |

### macOS (MacBook Pro M4 Pro)

| Benchmark | OC | Swift | Winner |
|-----------|:--:|:-----:|:------:|
| **Construction** | 0.024s | 0.027s | OC (11% faster) |
| **String → Date** | 0.122s | 0.109s | **Swift (11% faster)** |
| **Date → String** | 0.136s | 0.092s | **Swift (48% faster)** ⭐ |

### Key Takeaway

**Date → String formatting is 34-48% faster in Swift version** - This is the most significant performance difference.

## Project Structure

```
JJLISO8601DateFormatterBenchmark/
├── iOS/                                    # iOS Benchmark Apps
│   ├── OCVersionBenchmark/                 # OC version iOS app
│   │   └── iOSOCVersionBenchmark.xcworkspace  ← Open this
│   └── SwiftVersionBenchmark/              # Swift version iOS app
│       └── iOSSwiftVersionBenchmark.xcworkspace  ← Open this
│
├── macOS/                                  # macOS Command Line Tools
│   ├── OCVersionBenchmark/                 # OC version CLI
│   ├── SwiftVersionBenchmark/              # Swift version CLI
│   └── compare_versions.sh                 # Run both benchmarks
│
├── BENCHMARK_REPORT.md                     # 📊 Full benchmark report
└── README.md
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

## Recommendations

| Use Case | Recommendation |
|----------|----------------|
| **High-volume date formatting** | ✅ **Swift** (34-48% faster) |
| **High-volume date parsing** | ✅ Swift / Either |
| **Frequent formatter creation** | ✅ OC (7-11% faster) |
| **Pure Swift projects** | ✅ **Swift** |
| **General use** | ✅ **Swift** |

---

## Tips for Accurate Results

1. Run on physical devices (not simulators) for iOS
2. Use Release build configuration
3. Close other applications
4. Run multiple times and average results

---

## License

MIT License - See [LICENSE](LICENSE) for details.
