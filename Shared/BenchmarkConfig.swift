// Copyright (c) 2024 JJLISO8601DateFormatter Benchmark
// Shared benchmark configuration

import Foundation

/// Benchmark configuration constants
public enum BenchmarkConfig {
    public static let seconds: TimeInterval = 1
    public static let minutes: TimeInterval = 60 * seconds
    public static let hours: TimeInterval = 60 * minutes
    public static let days: TimeInterval = 24 * hours
    public static let years: TimeInterval = 365 * days
    
    /// Number of iterations for different test types
    public static let constructionIterations = 10_000
    public static let stringToDateIterations = 100_000
    public static let dateToStringIterations = 1_000_000
    
    /// Sleep time between tests (microseconds)
    public static let sleepMicros: useconds_t = 200_000
}

/// Time zones used for benchmarking
public enum BenchmarkTimeZones {
    public static let brazil = TimeZone(abbreviation: "BRT")!
    public static let america = TimeZone(identifier: "America/Indiana/Indianapolis")!
    public static let gmt = TimeZone(identifier: "GMT")!
    
    public static let all = [brazil, america, gmt]
}

/// Console output formatting
public enum Console {
    public static func printHeader(_ title: String) {
        print("\n" + String(repeating: "=", count: 60))
        print(" \(title)")
        print(String(repeating: "=", count: 60))
    }
    
    public static func printSubheader(_ title: String) {
        print("\n----- \(title) -----")
    }
    
    public static func printResult(name: String, time: CFTimeInterval) {
        print(String(format: "  %-20s: %.6f seconds", (name as NSString).utf8String!, time))
    }
    
    public static func printSpeedup(baseline: CFTimeInterval, compared: CFTimeInterval) {
        let speedup = baseline / compared
        if speedup > 1 {
            print(String(format: "  Speedup: %.2fx faster", speedup))
        } else {
            print(String(format: "  Speedup: %.2fx slower", 1 / speedup))
        }
    }
}
