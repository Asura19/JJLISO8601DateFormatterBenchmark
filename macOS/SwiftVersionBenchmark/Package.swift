// swift-tools-version:5.9
// Benchmark for Swift version of JJLISO8601DateFormatter

import PackageDescription

let package = Package(
    name: "SwiftVersionBenchmark",
    platforms: [
        .macOS(.v13),
        .iOS(.v16)
    ],
    dependencies: [
        // Swift version from Asura19 (master branch)
        .package(url: "https://github.com/Asura19/JJLISO8601DateFormatter.git", branch: "master"),
    ],
    targets: [
        .executableTarget(
            name: "SwiftVersionBenchmark",
            dependencies: [
                .product(name: "JJLISO8601DateFormatter", package: "JJLISO8601DateFormatter"),
            ],
            path: "Sources"
        ),
    ]
)
