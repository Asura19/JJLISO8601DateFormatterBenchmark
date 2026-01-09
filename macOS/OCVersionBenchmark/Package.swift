// swift-tools-version:5.9
// Benchmark for Original OC version of JJLISO8601DateFormatter

import PackageDescription

let package = Package(
    name: "OCVersionBenchmark",
    platforms: [
        .macOS(.v13),
        .iOS(.v16)
    ],
    dependencies: [
        // Original OC version from michaeleisel (master branch)
        .package(url: "https://github.com/michaeleisel/JJLISO8601DateFormatter.git", branch: "master"),
    ],
    targets: [
        .executableTarget(
            name: "OCVersionBenchmark",
            dependencies: [
                .product(name: "JJLISO8601DateFormatter", package: "JJLISO8601DateFormatter"),
            ],
            path: "Sources"
        ),
    ]
)
