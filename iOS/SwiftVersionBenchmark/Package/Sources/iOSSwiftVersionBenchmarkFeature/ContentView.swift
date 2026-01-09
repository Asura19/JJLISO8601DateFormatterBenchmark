// Copyright (c) 2024 JJLISO8601DateFormatter Benchmark
// iOS Benchmark for Swift version of JJLISO8601DateFormatter

import SwiftUI
import QuartzCore
import JJLISO8601DateFormatter

// MARK: - Benchmark Result Model

public struct BenchmarkResult: Identifiable {
    public let id = UUID()
    let name: String
    let jjlTime: Double
    let appleTime: Double
    
    var speedup: Double {
        appleTime / jjlTime
    }
    
    var speedupText: String {
        if speedup > 1 {
            return String(format: "%.2fx faster", speedup)
        } else {
            return String(format: "%.2fx slower", 1 / speedup)
        }
    }
}

public struct TimeZoneResults: Identifiable {
    public let id = UUID()
    let timeZoneName: String
    let recentResult: BenchmarkResult
    let epochResult: BenchmarkResult
}

// MARK: - Benchmark Engine

@MainActor
public class BenchmarkEngine: ObservableObject {
    @Published public var isRunning = false
    @Published public var currentPhase = ""
    @Published public var progress: Double = 0
    @Published public var constructionResult: BenchmarkResult?
    @Published public var stringToDateResults: [TimeZoneResults] = []
    @Published public var dateToStringResults: [TimeZoneResults] = []
    @Published public var logOutput = ""
    
    // Constants
    private let SECONDS: TimeInterval = 1
    private let MINUTES: TimeInterval = 60
    private let HOURS: TimeInterval = 3600
    private let DAYS: TimeInterval = 86400
    
    private let fullOptions: ISO8601DateFormatter.Options = [
        .withInternetDateTime,
        .withColonSeparatorInTimeZone,
        .withFractionalSeconds
    ]
    
    private let timeZones: [(TimeZone, String)] = [
        (TimeZone(abbreviation: "BRT")!, "America/Sao_Paulo"),
        (TimeZone(identifier: "America/Indiana/Indianapolis")!, "America/Indiana/Indianapolis"),
        (TimeZone(identifier: "GMT")!, "GMT")
    ]
    
    public init() {}
    
    private func log(_ message: String) {
        logOutput += message + "\n"
        print(message)
    }
    
    public func runBenchmark() async {
        isRunning = true
        logOutput = ""
        stringToDateResults = []
        dateToStringResults = []
        constructionResult = nil
        progress = 0
        
        log("======================================================================")
        log(" 🚀 JJLISO8601DateFormatter Benchmark - Swift Version (Asura19)")
        log("======================================================================")
        log("Repository: https://github.com/Asura19/JJLISO8601DateFormatter")
        log("Date: \(Date())")
        log("Device: \(UIDevice.current.model) - \(UIDevice.current.systemName) \(UIDevice.current.systemVersion)")
        
        // Test Construction
        currentPhase = "测试构造性能..."
        log("\n----- Construction Performance -----")
        let constructResult = await testConstructionPerformance()
        constructionResult = constructResult
        log(String(format: "  JJL (Swift)           : %.6f seconds", constructResult.jjlTime))
        log(String(format: "  Apple ISO8601         : %.6f seconds", constructResult.appleTime))
        log("  📈 \(constructResult.speedupText)")
        progress = 0.1
        
        let currentStartDate = Date(timeIntervalSinceNow: -15 * DAYS)
        let currentEndDate = Date(timeIntervalSinceNow: 15 * DAYS)
        let epochDate = Date(timeIntervalSince1970: 0)
        
        // String to Date
        log("\n----- String to Date Performance -----")
        currentPhase = "测试字符串转日期..."
        
        for (index, (timeZone, tzName)) in timeZones.enumerated() {
            log("\n  TimeZone: \(tzName)")
            
            log("    Recent dates (±15 days):")
            let recentS2D = await testPerformance(
                startDate: currentStartDate,
                endDate: currentEndDate,
                timeZone: timeZone,
                stringToDate: true
            )
            log(String(format: "      JJL (Swift)       : %.6f seconds", recentS2D.jjlTime))
            log(String(format: "      Apple ISO8601     : %.6f seconds", recentS2D.appleTime))
            log("      📈 \(recentS2D.speedupText)")
            
            log("    Dates from 1970 until now:")
            let epochS2D = await testPerformance(
                startDate: epochDate,
                endDate: currentEndDate,
                timeZone: timeZone,
                stringToDate: true
            )
            log(String(format: "      JJL (Swift)       : %.6f seconds", epochS2D.jjlTime))
            log(String(format: "      Apple ISO8601     : %.6f seconds", epochS2D.appleTime))
            log("      📈 \(epochS2D.speedupText)")
            
            stringToDateResults.append(TimeZoneResults(
                timeZoneName: tzName,
                recentResult: BenchmarkResult(name: "Recent ±15 days", jjlTime: recentS2D.jjlTime, appleTime: recentS2D.appleTime),
                epochResult: BenchmarkResult(name: "From 1970", jjlTime: epochS2D.jjlTime, appleTime: epochS2D.appleTime)
            ))
            
            progress = 0.1 + Double(index + 1) * 0.15
        }
        
        // Date to String
        log("\n----- Date to String Performance -----")
        currentPhase = "测试日期转字符串..."
        
        for (index, (timeZone, tzName)) in timeZones.enumerated() {
            log("\n  TimeZone: \(tzName)")
            
            log("    Recent dates (±15 days):")
            let recentD2S = await testPerformance(
                startDate: currentStartDate,
                endDate: currentEndDate,
                timeZone: timeZone,
                stringToDate: false
            )
            log(String(format: "      JJL (Swift)       : %.6f seconds", recentD2S.jjlTime))
            log(String(format: "      Apple ISO8601     : %.6f seconds", recentD2S.appleTime))
            log("      📈 \(recentD2S.speedupText)")
            
            log("    Dates from 1970 until now:")
            let epochD2S = await testPerformance(
                startDate: epochDate,
                endDate: currentEndDate,
                timeZone: timeZone,
                stringToDate: false
            )
            log(String(format: "      JJL (Swift)       : %.6f seconds", epochD2S.jjlTime))
            log(String(format: "      Apple ISO8601     : %.6f seconds", epochD2S.appleTime))
            log("      📈 \(epochD2S.speedupText)")
            
            dateToStringResults.append(TimeZoneResults(
                timeZoneName: tzName,
                recentResult: BenchmarkResult(name: "Recent ±15 days", jjlTime: recentD2S.jjlTime, appleTime: recentD2S.appleTime),
                epochResult: BenchmarkResult(name: "From 1970", jjlTime: epochD2S.jjlTime, appleTime: epochD2S.appleTime)
            ))
            
            progress = 0.55 + Double(index + 1) * 0.15
        }
        
        log("\n======================================================================")
        log(" ✅ Benchmark Complete")
        log("======================================================================")
        
        currentPhase = "测试完成!"
        progress = 1.0
        isRunning = false
    }
    
    private func testConstructionPerformance() async -> BenchmarkResult {
        return await Task.detached(priority: .userInitiated) {
            let iterations = 10_000
            
            var jjlTime: CFTimeInterval = 0
            var appleTime: CFTimeInterval = 0
            
            // JJL Construction
            autoreleasepool {
                let startTime = CACurrentMediaTime()
                for _ in 0..<iterations {
                    _ = JJLISO8601DateFormatter()
                }
                jjlTime = CACurrentMediaTime() - startTime
            }
            
            // Apple Construction
            autoreleasepool {
                let startTime = CACurrentMediaTime()
                for _ in 0..<iterations {
                    _ = ISO8601DateFormatter()
                }
                appleTime = CACurrentMediaTime() - startTime
            }
            
            return BenchmarkResult(name: "Construction", jjlTime: jjlTime, appleTime: appleTime)
        }.value
    }
    
    private func testPerformance(
        startDate: Date,
        endDate: Date,
        timeZone: TimeZone,
        stringToDate: Bool
    ) async -> BenchmarkResult {
        return await Task.detached(priority: .userInitiated) { [fullOptions] in
            let appleFormatter = ISO8601DateFormatter()
            let jjlFormatter = JJLISO8601DateFormatter()
            
            appleFormatter.formatOptions = fullOptions
            jjlFormatter.formatOptions = fullOptions
            appleFormatter.timeZone = timeZone
            jjlFormatter.timeZone = timeZone
            
            let iterations = stringToDate ? 100_000 : 1_000_000
            let endInterval = endDate.timeIntervalSince1970
            let startInterval = startDate.timeIntervalSince1970
            let increment = (endInterval - startInterval) / Double(iterations)
            
            var dates: [Date] = []
            var strings: [String] = []
            
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
                jjlTime = CACurrentMediaTime() - startTime
            }
            
            usleep(200_000)
            
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
                appleTime = CACurrentMediaTime() - startTime
            }
            
            usleep(200_000)
            
            let name = stringToDate ? "String → Date" : "Date → String"
            return BenchmarkResult(name: name, jjlTime: jjlTime, appleTime: appleTime)
        }.value
    }
}

// MARK: - UI Components

struct SpeedupBadge: View {
    let speedup: Double
    
    var body: some View {
        HStack(spacing: 4) {
            Image(systemName: speedup > 1 ? "arrow.up.right" : "arrow.down.right")
                .font(.caption2.bold())
            Text(String(format: "%.1fx", speedup > 1 ? speedup : 1/speedup))
                .font(.caption.monospacedDigit().bold())
        }
        .padding(.horizontal, 8)
        .padding(.vertical, 4)
        .background(speedup > 1 ? Color.green.opacity(0.2) : Color.red.opacity(0.2))
        .foregroundColor(speedup > 1 ? .green : .red)
        .cornerRadius(6)
    }
}

struct ResultRow: View {
    let result: BenchmarkResult
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(result.name)
                    .font(.subheadline.bold())
                Spacer()
                SpeedupBadge(speedup: result.speedup)
            }
            
            HStack(spacing: 16) {
                VStack(alignment: .leading, spacing: 2) {
                    Text("JJL (Swift)")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    Text(String(format: "%.4fs", result.jjlTime))
                        .font(.footnote.monospacedDigit())
                        .foregroundColor(.teal)
                }
                
                VStack(alignment: .leading, spacing: 2) {
                    Text("Apple")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    Text(String(format: "%.4fs", result.appleTime))
                        .font(.footnote.monospacedDigit())
                        .foregroundColor(.blue)
                }
            }
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(12)
    }
}

struct TimeZoneResultCard: View {
    let results: TimeZoneResults
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: "globe")
                    .foregroundColor(.teal)
                Text(results.timeZoneName)
                    .font(.headline)
            }
            
            ResultRow(result: results.recentResult)
            ResultRow(result: results.epochResult)
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(16)
        .shadow(color: .black.opacity(0.1), radius: 8, y: 4)
    }
}

// MARK: - Main Content View

public struct ContentView: View {
    @StateObject private var engine = BenchmarkEngine()
    @State private var showLog = false
    
    public init() {}
    
    public var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    // Header
                    headerSection
                    
                    if engine.isRunning {
                        runningSection
                    } else if engine.constructionResult != nil {
                        resultsSection
                    } else {
                        instructionSection
                    }
                }
                .padding()
            }
            .background(Color(.systemGroupedBackground))
            .navigationTitle("Swift 版本基准测试")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    if engine.constructionResult != nil {
                        Button {
                            showLog = true
                        } label: {
                            Image(systemName: "doc.text")
                        }
                    }
                }
            }
            .sheet(isPresented: $showLog) {
                logSheet
            }
        }
    }
    
    private var headerSection: some View {
        VStack(spacing: 8) {
            Image(systemName: "gauge.with.dots.needle.67percent")
                .font(.system(size: 50))
                .foregroundStyle(
                    LinearGradient(
                        colors: [.teal, .cyan],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
            
            Text("JJLISO8601DateFormatter")
                .font(.title2.bold())
            
            Text("Swift Version (Asura19)")
                .font(.subheadline)
                .foregroundColor(.secondary)
            
            Link("GitHub Repository", destination: URL(string: "https://github.com/Asura19/JJLISO8601DateFormatter")!)
                .font(.caption)
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(Color(.systemBackground))
        .cornerRadius(16)
        .shadow(color: .black.opacity(0.1), radius: 8, y: 4)
    }
    
    private var instructionSection: some View {
        VStack(spacing: 16) {
            Image(systemName: "play.circle.fill")
                .font(.system(size: 60))
                .foregroundColor(.teal)
            
            Text("点击下方按钮开始基准测试")
                .font(.headline)
            
            Text("测试将对比 JJL 和 Apple ISO8601DateFormatter 的性能")
                .font(.subheadline)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
            
            startButton
        }
        .padding(32)
        .background(Color(.systemBackground))
        .cornerRadius(16)
        .shadow(color: .black.opacity(0.1), radius: 8, y: 4)
    }
    
    private var runningSection: some View {
        VStack(spacing: 16) {
            ProgressView(value: engine.progress)
                .progressViewStyle(.linear)
                .tint(.teal)
            
            HStack {
                ProgressView()
                    .scaleEffect(0.8)
                Text(engine.currentPhase)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(16)
        .shadow(color: .black.opacity(0.1), radius: 8, y: 4)
    }
    
    private var resultsSection: some View {
        VStack(spacing: 20) {
            // Construction Result
            if let result = engine.constructionResult {
                VStack(alignment: .leading, spacing: 12) {
                    HStack {
                        Image(systemName: "hammer.fill")
                            .foregroundColor(.teal)
                        Text("构造性能")
                            .font(.headline)
                    }
                    ResultRow(result: result)
                }
                .padding()
                .background(Color(.systemBackground))
                .cornerRadius(16)
                .shadow(color: .black.opacity(0.1), radius: 8, y: 4)
            }
            
            // String to Date Results
            if !engine.stringToDateResults.isEmpty {
                VStack(alignment: .leading, spacing: 12) {
                    HStack {
                        Image(systemName: "text.badge.plus")
                            .foregroundColor(.blue)
                        Text("字符串 → 日期")
                            .font(.headline)
                    }
                    .padding(.horizontal)
                    
                    ForEach(engine.stringToDateResults) { result in
                        TimeZoneResultCard(results: result)
                    }
                }
            }
            
            // Date to String Results
            if !engine.dateToStringResults.isEmpty {
                VStack(alignment: .leading, spacing: 12) {
                    HStack {
                        Image(systemName: "calendar.badge.plus")
                            .foregroundColor(.green)
                        Text("日期 → 字符串")
                            .font(.headline)
                    }
                    .padding(.horizontal)
                    
                    ForEach(engine.dateToStringResults) { result in
                        TimeZoneResultCard(results: result)
                    }
                }
            }
            
            // Run Again Button
            startButton
        }
    }
    
    private var startButton: some View {
        Button {
            Task {
                await engine.runBenchmark()
            }
        } label: {
            HStack {
                Image(systemName: engine.constructionResult == nil ? "play.fill" : "arrow.clockwise")
                Text(engine.constructionResult == nil ? "开始测试" : "重新测试")
            }
            .font(.headline)
            .foregroundColor(.white)
            .frame(maxWidth: .infinity)
            .padding()
            .background(
                LinearGradient(
                    colors: [.teal, .cyan],
                    startPoint: .leading,
                    endPoint: .trailing
                )
            )
            .cornerRadius(12)
        }
        .disabled(engine.isRunning)
    }
    
    private var logSheet: some View {
        NavigationStack {
            ScrollView {
                Text(engine.logOutput)
                    .font(.system(.caption, design: .monospaced))
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding()
            }
            .navigationTitle("测试日志")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("完成") {
                        showLog = false
                    }
                }
                ToolbarItem(placement: .navigationBarLeading) {
                    ShareLink(item: engine.logOutput) {
                        Image(systemName: "square.and.arrow.up")
                    }
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
