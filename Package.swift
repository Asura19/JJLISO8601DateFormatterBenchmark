// swift-tools-version:5.9
// Performance comparison between OC and Swift versions of JJLISO8601DateFormatter

import PackageDescription

let package = Package(
    name: "JJLISO8601DateFormatterBenchmark",
    platforms: [
        .macOS(.v13),
        .iOS(.v16)
    ],
    products: [
        .executable(
            name: "OCBenchmark",
            targets: ["OCBenchmark"]
        ),
        .executable(
            name: "SwiftBenchmark",
            targets: ["SwiftBenchmark"]
        ),
        .executable(
            name: "FullBenchmark",
            targets: ["FullBenchmark"]
        ),
    ],
    dependencies: [
        // Original OC version from michaeleisel
        .package(url: "https://github.com/michaeleisel/JJLISO8601DateFormatter.git", from: "0.1.4"),
        // Swift version from Asura19
        .package(url: "https://github.com/Asura19/JJLISO8601DateFormatter.git", branch: "master"),
    ],
    targets: [
        .target(
            name: "BenchmarkCore",
            dependencies: []
        ),
        .executableTarget(
            name: "OCBenchmark",
            dependencies: [
                "BenchmarkCore",
                .product(name: "JJLISO8601DateFormatter", package: "JJLISO8601DateFormatter"),
            ]
        ),
        .executableTarget(
            name: "SwiftBenchmark",
            dependencies: [
                "BenchmarkCore",
                .product(name: "JJLISO8601DateFormatter", package: "JJLISO8601DateFormatter"),
            ]
        ),
        .executableTarget(
            name: "FullBenchmark",
            dependencies: [
                "BenchmarkCore"
            ]
        ),
    ]
)
