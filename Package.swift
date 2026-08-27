// swift-tools-version: 6.4

import PackageDescription

let package = Package(
    name: "swift-time",
    platforms: [
        .macOS(.v27),
        .iOS(.v27),
        .tvOS(.v27),
        .watchOS(.v27),
        .visionOS(.v27),
    ],
    products: [
        .library(
            name: "Time",
            targets: ["Time"]
        ),
        .library(
            name: "Time Standard Library Integration",
            targets: ["Time Standard Library Integration"]
        ),
        .library(
            name: "Time Apple Foundation Integration",
            targets: ["Time Apple Foundation Integration"]
        ),
    ],
    dependencies: [],
    targets: [
        .target(
            name: "Time",
            dependencies: []
        ),
        .target(
            name: "Time Standard Library Integration",
            dependencies: ["Time"]
        ),
        .target(
            name: "Time Apple Foundation Integration",
            dependencies: [
                "Time",
                "Time Standard Library Integration",
            ]
        ),
        .testTarget(
            name: "Time Tests",
            dependencies: ["Time"]
        ),
    ],
    swiftLanguageModes: [.v6]
)

for target in package.targets where ![.system, .binary, .plugin, .macro].contains(target.type) {
    let ecosystem: [SwiftSetting] = [
        .strictMemorySafety(),
        .enableUpcomingFeature("ExistentialAny"),
        .enableUpcomingFeature("InternalImportsByDefault"),
        .enableUpcomingFeature("MemberImportVisibility"),
        .enableUpcomingFeature("NonisolatedNonsendingByDefault"),
        .enableExperimentalFeature("Lifetimes"),
        .enableUpcomingFeature("InferIsolatedConformances"),
    ]

    let package: [SwiftSetting] = []

    target.swiftSettings = (target.swiftSettings ?? []) + ecosystem + package
}
