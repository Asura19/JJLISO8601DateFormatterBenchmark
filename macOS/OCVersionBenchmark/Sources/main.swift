// Copyright (c) 2024 JJLISO8601DateFormatter Benchmark
// Benchmark for Original OC version of JJLISO8601DateFormatter

import Foundation
import QuartzCore
import JJLISO8601DateFormatter

// MARK: - Constants

let SECONDS: TimeInterval = 1
let MINUTES: TimeInterval = 60 * SECONDS
let HOURS: TimeInterval = 60 * MINUTES
let DAYS: TimeInterval = 24 * HOURS
let YEARS: TimeInterval = 365 * DAYS

// MARK: - Time Zones

let brazilTimeZone = TimeZone(abbreviation: "BRT")!
let americaTimeZone = TimeZone(identifier: "America/Indiana/Indianapolis")!
let gmtTimeZone = TimeZone(identifier: "GMT")!

// MARK: - Format Options

let fullOptions: ISO8601DateFormatter.Options = [
    .withInternetDateTime,
    .withColonSeparatorInTimeZone,
    .withFractionalSeconds
]

// MARK: - Benchmark Functions

func printHeader(_ title: String) {
    print("\n" + String(repeating: "=", count: 70))
    print(" \(title)")
    print(String(repeating: "=", count: 70))
}

func printSubheader(_ title: String) {
    print("\n----- \(title) -----")
}

func printResult(name: String, time: CFTimeInterval) {
    print(String(format: "  %-25s: %.6f seconds", (name as NSString).utf8String!, time))
}

func printSpeedup(baseline: CFTimeInterval, compared: CFTimeInterval) {
    let speedup = baseline / compared
    if speedup > 1 {
        print(String(format: "  📈 Speedup: %.2fx faster", speedup))
    } else {
        print(String(format: "  📉 Slowdown: %.2fx slower", 1 / speedup))
    }
}

// MARK: - Construction Benchmark

func testConstructionPerformance() -> (jjl: CFTimeInterval, apple: CFTimeInterval) {
    let iterations = 10_000
    
    var jjlTime: CFTimeInterval = 0
    var appleTime: CFTimeInterval = 0
    
    // JJL Construction
    autoreleasepool {
        let startTime = CACurrentMediaTime()
        for _ in 0..<iterations {
            _ = JJLISO8601DateFormatter()
        }
        let endTime = CACurrentMediaTime()
        jjlTime = endTime - startTime
    }
    
    // Apple Construction
    autoreleasepool {
        let startTime = CACurrentMediaTime()
        for _ in 0..<iterations {
            _ = ISO8601DateFormatter()
        }
        let endTime = CACurrentMediaTime()
        appleTime = endTime - startTime
    }
    
    return (jjlTime, appleTime)
}

// MARK: - Formatting Benchmark

func testPerformance(
    startDate: Date,
    endDate: Date,
    timeZone: TimeZone,
    formatOptions: ISO8601DateFormatter.Options,
    stringToDate: Bool
) -> (jjl: CFTimeInterval, apple: CFTimeInterval) {
    
    let appleFormatter = ISO8601DateFormatter()
    let jjlFormatter = JJLISO8601DateFormatter()
    
    appleFormatter.formatOptions = formatOptions
    jjlFormatter.formatOptions = formatOptions
    appleFormatter.timeZone = timeZone
    jjlFormatter.timeZone = timeZone
    
    let iterations = stringToDate ? 100_000 : 1_000_000
    let endInterval = endDate.timeIntervalSince1970
    let startInterval = startDate.timeIntervalSince1970
    let increment = (endInterval - startInterval) / Double(iterations)
    
    var dates: [Date] = []
    var strings: [String] = []
    
    let sleepMicros: useconds_t = 200_000
    
    // Prepare test data
    var interval = startInterval
    while interval < endInterval {
        let date = Date(timeIntervalSince1970: interval)
        if stringToDate {
            let string = jjlFormatter.string(from: date)
            strings.append(string)
        } else {
            dates.append(date)
        }
        interval += increment
    }
    
    var jjlTime: CFTimeInterval = 0
    var appleTime: CFTimeInterval = 0
    
    // JJL Benchmark
    autoreleasepool {
        let startTime = CACurrentMediaTime()
        if stringToDate {
            for string in strings {
                _ = jjlFormatter.date(from: string)
            }
        } else {
            for date in dates {
                _ = jjlFormatter.string(from: date)
            }
        }
        let endTime = CACurrentMediaTime()
        jjlTime = endTime - startTime
    }
    
    usleep(sleepMicros)
    
    // Apple Benchmark
    autoreleasepool {
        let startTime = CACurrentMediaTime()
        if stringToDate {
            for string in strings {
                _ = appleFormatter.date(from: string)
            }
        } else {
            for date in dates {
                _ = appleFormatter.string(from: date)
            }
        }
        let endTime = CACurrentMediaTime()
        appleTime = endTime - startTime
    }
    
    usleep(sleepMicros)
    
    return (jjlTime, appleTime)
}

// MARK: - Main Benchmark

func runBenchmark() {
    printHeader("🚀 JJLISO8601DateFormatter Benchmark - OC Version (michaeleisel)")
    print("Repository: https://github.com/michaeleisel/JJLISO8601DateFormatter")
    print("Date: \(Date())")
    
    let currentStartDate = Date(timeIntervalSinceNow: -15 * DAYS)
    let currentEndDate = Date(timeIntervalSinceNow: 15 * DAYS)
    let epochDate = Date(timeIntervalSince1970: 0)
    
    // Construction Benchmark
    printSubheader("Construction Performance")
    let constructionResults = testConstructionPerformance()
    printResult(name: "JJL (OC)", time: constructionResults.jjl)
    printResult(name: "Apple ISO8601", time: constructionResults.apple)
    printSpeedup(baseline: constructionResults.apple, compared: constructionResults.jjl)
    
    // String to Date Benchmark
    printSubheader("String to Date Performance")
    for timeZone in [brazilTimeZone, americaTimeZone, gmtTimeZone] {
        print("\n  TimeZone: \(timeZone.identifier)")
        
        print("    Recent dates (±15 days):")
        let recentS2D = testPerformance(
            startDate: currentStartDate,
            endDate: currentEndDate,
            timeZone: timeZone,
            formatOptions: fullOptions,
            stringToDate: true
        )
        printResult(name: "    JJL (OC)", time: recentS2D.jjl)
        printResult(name: "    Apple ISO8601", time: recentS2D.apple)
        printSpeedup(baseline: recentS2D.apple, compared: recentS2D.jjl)
        
        print("    Dates from 1970 until now:")
        let epochS2D = testPerformance(
            startDate: epochDate,
            endDate: currentEndDate,
            timeZone: timeZone,
            formatOptions: fullOptions,
            stringToDate: true
        )
        printResult(name: "    JJL (OC)", time: epochS2D.jjl)
        printResult(name: "    Apple ISO8601", time: epochS2D.apple)
        printSpeedup(baseline: epochS2D.apple, compared: epochS2D.jjl)
    }
    
    // Date to String Benchmark
    printSubheader("Date to String Performance")
    for timeZone in [brazilTimeZone, americaTimeZone, gmtTimeZone] {
        print("\n  TimeZone: \(timeZone.identifier)")
        
        print("    Recent dates (±15 days):")
        let recentD2S = testPerformance(
            startDate: currentStartDate,
            endDate: currentEndDate,
            timeZone: timeZone,
            formatOptions: fullOptions,
            stringToDate: false
        )
        printResult(name: "    JJL (OC)", time: recentD2S.jjl)
        printResult(name: "    Apple ISO8601", time: recentD2S.apple)
        printSpeedup(baseline: recentD2S.apple, compared: recentD2S.jjl)
        
        print("    Dates from 1970 until now:")
        let epochD2S = testPerformance(
            startDate: epochDate,
            endDate: currentEndDate,
            timeZone: timeZone,
            formatOptions: fullOptions,
            stringToDate: false
        )
        printResult(name: "    JJL (OC)", time: epochD2S.jjl)
        printResult(name: "    Apple ISO8601", time: epochD2S.apple)
        printSpeedup(baseline: epochD2S.apple, compared: epochD2S.jjl)
    }
    
    printHeader("✅ Benchmark Complete")
}

// Run the benchmark
runBenchmark()
