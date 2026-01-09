// swift-tools-version: 5.9
// JJLISO8601DateFormatter Benchmark - OC Version (michaeleisel)

import PackageDescription

let package = Package(
    name: "iOSOCVersionBenchmarkFeature",
    platforms: [.iOS(.v16)],
    products: [
        .library(
            name: "iOSOCVersionBenchmarkFeature",
            targets: ["iOSOCVersionBenchmarkFeature"]
        ),
    ],
    dependencies: [
        // Original OC version from michaeleisel
        .package(url: "https://github.com/michaeleisel/JJLISO8601DateFormatter.git", branch: "master"),
    ],
    targets: [
        .target(
            name: "iOSOCVersionBenchmarkFeature",
            dependencies: [
                .product(name: "JJLISO8601DateFormatter", package: "JJLISO8601DateFormatter"),
            ]
        ),
        .testTarget(
            name: "iOSOCVersionBenchmarkFeatureTests",
            dependencies: [
                "iOSOCVersionBenchmarkFeature"
            ]
        ),
    ]
)
