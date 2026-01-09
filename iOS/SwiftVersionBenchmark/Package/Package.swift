// swift-tools-version: 5.9
// JJLISO8601DateFormatter Benchmark - Swift Version (Asura19)

import PackageDescription

let package = Package(
    name: "iOSSwiftVersionBenchmarkFeature",
    platforms: [.iOS(.v16)],
    products: [
        .library(
            name: "iOSSwiftVersionBenchmarkFeature",
            targets: ["iOSSwiftVersionBenchmarkFeature"]
        ),
    ],
    dependencies: [
        // Swift version from Asura19
        .package(url: "https://github.com/Asura19/JJLISO8601DateFormatter.git", branch: "master"),
    ],
    targets: [
        .target(
            name: "iOSSwiftVersionBenchmarkFeature",
            dependencies: [
                .product(name: "JJLISO8601DateFormatter", package: "JJLISO8601DateFormatter"),
            ]
        ),
        .testTarget(
            name: "iOSSwiftVersionBenchmarkFeatureTests",
            dependencies: [
                "iOSSwiftVersionBenchmarkFeature"
            ]
        ),
    ]
)
