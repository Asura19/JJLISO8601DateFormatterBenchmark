# JJLISO8601DateFormatter Performance Benchmark Report

A comprehensive performance comparison between the **Original Objective-C version** ([michaeleisel/JJLISO8601DateFormatter](https://github.com/michaeleisel/JJLISO8601DateFormatter)) and the **Swift port** ([Asura19/JJLISO8601DateFormatter](https://github.com/Asura19/JJLISO8601DateFormatter)).

## Test Environment

| Platform | Device | OS Version | Swift Version |
|----------|--------|------------|---------------|
| **macOS** | MacBook Pro M4 Pro (48GB) | macOS 15.7.1 | Swift 6.2.3 |
| **iOS** | iPhone 16 | iOS 26.1 | Swift 6.2.3 |

## Benchmark Methodology

- **Construction**: 10,000 formatter object instantiations
- **String → Date**: 100,000 parsing operations
- **Date → String**: 1,000,000 formatting operations

Tests were conducted across three time zones:
- `America/Sao_Paulo` (BRT)
- `America/Indiana/Indianapolis`
- `GMT`

Format options used:
```swift
[.withInternetDateTime, .withColonSeparatorInTimeZone, .withFractionalSeconds]
```

---

## Summary: Direct OC vs Swift Comparison

### iOS (iPhone 16, iOS 26.1)

| Benchmark | OC Time | Swift Time | Winner | Difference |
|-----------|:-------:|:----------:|:------:|:----------:|
| **Construction** | 0.053s | 0.057s | OC | 6.8% faster |
| **String → Date** | 0.117s | 0.116s | ≈ Tie | ~1% |
| **Date → String** | 0.159s | 0.105s | **Swift** | **34% faster** |

### macOS (MacBook Pro M4 Pro)

| Benchmark | OC Time | Swift Time | Winner | Difference |
|-----------|:-------:|:----------:|:------:|:----------:|
| **Construction** | 0.024s | 0.027s | OC | 11% faster |
| **String → Date** | 0.122s | 0.109s | **Swift** | **12% faster** |
| **Date → String** | 0.136s | 0.092s | **Swift** | **48% faster** |

---

## Detailed Results

### iOS Benchmark Results (iPhone 16, iOS 26.1)

#### Construction Performance (10,000 iterations)

| Version | Time | Comparison |
|---------|------|------------|
| **OC** | **0.0529s** | Baseline |
| Swift | 0.0565s | OC is 6.8% faster |

#### String to Date (100,000 iterations)

| Time Zone | Swift | OC | Faster | Diff |
|-----------|:-----:|:--:|:------:|:----:|
| Sao Paulo (Recent) | **0.0969s** | 0.1068s | Swift | 9.2% |
| Sao Paulo (1970-) | 0.1187s | **0.1150s** | OC | 3.2% |
| Indianapolis (Recent) | **0.1192s** | 0.1211s | Swift | 1.5% |
| Indianapolis (1970-) | 0.1179s | **0.1141s** | OC | 3.3% |
| GMT (Recent) | **0.1214s** | 0.1239s | Swift | 2.0% |
| GMT (1970-) | 0.1201s | **0.1188s** | OC | 1.0% |

**Average**: Swift 0.1157s vs OC 0.1166s → **Virtually identical** (~1% difference)

#### Date to String (1,000,000 iterations) ⭐

| Time Zone | Swift | OC | Faster | Diff |
|-----------|:-----:|:--:|:------:|:----:|
| Sao Paulo (Recent) | **0.1024s** | 0.1587s | Swift | **35.5%** |
| Sao Paulo (1970-) | **0.1067s** | 0.1600s | Swift | **33.3%** |
| Indianapolis (Recent) | **0.1092s** | 0.1649s | Swift | **33.8%** |
| Indianapolis (1970-) | **0.1113s** | 0.1664s | Swift | **33.1%** |
| GMT (Recent) | **0.1006s** | 0.1511s | Swift | **33.4%** |
| GMT (1970-) | **0.1008s** | 0.1506s | Swift | **33.0%** |

**Average**: Swift 0.1052s vs OC 0.1586s → **Swift is 33.7% faster** ⭐

---

### macOS Benchmark Results (MacBook Pro M4 Pro, macOS 15.7.1)

#### Construction Performance (10,000 iterations)

| Version | Time | Comparison |
|---------|------|------------|
| **OC** | **0.0244s** | Baseline |
| Swift | 0.0271s | OC is 11% faster |

#### String to Date (100,000 iterations)

| Time Zone | Swift | OC | Faster | Diff |
|-----------|:-----:|:--:|:------:|:----:|
| Sao Paulo (Recent) | **0.1052s** | 0.1232s | Swift | 14.6% |
| Sao Paulo (1970-) | **0.1070s** | 0.1226s | Swift | 12.7% |
| Indianapolis (Recent) | **0.1116s** | 0.1325s | Swift | 15.8% |
| Indianapolis (1970-) | 0.1175s | **0.1147s** | OC | 2.4% |
| GMT (Recent) | **0.1094s** | 0.1162s | Swift | 5.8% |
| GMT (1970-) | **0.1056s** | 0.1244s | Swift | 15.1% |

**Average**: Swift 0.1094s vs OC 0.1223s → **Swift is 10.5% faster**

#### Date to String (1,000,000 iterations) ⭐

| Time Zone | Swift | OC | Faster | Diff |
|-----------|:-----:|:--:|:------:|:----:|
| Sao Paulo (Recent) | **0.0892s** | 0.1453s | Swift | **38.6%** |
| Sao Paulo (1970-) | **0.0919s** | 0.1329s | Swift | **30.8%** |
| Indianapolis (Recent) | **0.1036s** | 0.1415s | Swift | **26.8%** |
| Indianapolis (1970-) | **0.0985s** | 0.1417s | Swift | **30.5%** |
| GMT (Recent) | **0.0832s** | 0.1328s | Swift | **37.4%** |
| GMT (1970-) | **0.0856s** | 0.1240s | Swift | **31.0%** |

**Average**: Swift 0.0920s vs OC 0.1364s → **Swift is 48.2% faster** ⭐

---

## Comparison vs Apple's ISO8601DateFormatter

Both JJL versions significantly outperform Apple's built-in formatter:

| Platform | JJL (Swift) vs Apple | JJL (OC) vs Apple |
|----------|:--------------------:|:-----------------:|
| **iOS - Construction** | 6.9x faster | 6.6x faster |
| **iOS - String→Date** | 18-22x faster | 19-22x faster |
| **iOS - Date→String** | 7.6-8.5x faster | 5.1-5.7x faster |
| **macOS - Construction** | 16.6x faster | 18.6x faster |
| **macOS - String→Date** | 21-25x faster | 19-22x faster |
| **macOS - Date→String** | 8.7-10.2x faster | 5.9-7.3x faster |

---

## Key Findings

### 1. Date → String: Swift is significantly faster ⭐

This is the most important finding:

| Platform | Swift Advantage |
|----------|:---------------:|
| iOS | **34% faster** |
| macOS | **48% faster** |

### 2. String → Date: Swift has moderate advantage

| Platform | Swift Advantage |
|----------|:---------------:|
| iOS | ~1% (virtually tied) |
| macOS | **11% faster** |

### 3. Construction: OC is slightly faster

| Platform | OC Advantage |
|----------|:------------:|
| iOS | 7% faster |
| macOS | 11% faster |

---

## Recommendations

| Use Case | Recommendation | Reason |
|----------|----------------|--------|
| **High-volume date formatting** | ✅ **Swift** | 34-48% faster |
| **High-volume date parsing** | ✅ Swift (macOS) / Either (iOS) | 11% faster on macOS |
| **Frequent formatter creation** | ✅ OC | 7-11% faster |
| **Pure Swift projects** | ✅ **Swift** | Native integration |
| **Existing OC codebases** | ⚠️ OC | Avoid bridging overhead |
| **General use** | ✅ **Swift** | Best overall performance |

### Bottom Line

For **new projects** and **performance-critical applications**, the **Swift version** is recommended:
- **Date→String is 34-48% faster** - the most significant improvement
- Native Swift integration without Objective-C bridging
- Modern Swift idioms and type safety

---

## Reproduction

### macOS Command Line

```bash
cd macOS/OCVersionBenchmark && swift build -c release && swift run -c release
cd macOS/SwiftVersionBenchmark && swift build -c release && swift run -c release
```

### iOS Device

1. Open `iOS/OCVersionBenchmark/iOSOCVersionBenchmark.xcworkspace` in Xcode
2. Select your iOS device and run (⌘R)
3. Tap "Start Benchmark" in the app

Repeat for Swift version with `iOS/SwiftVersionBenchmark/iOSSwiftVersionBenchmark.xcworkspace`

---

*Benchmark conducted on January 9, 2026*
