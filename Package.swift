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
            name: "Time Test Support",
            targets: ["Time Test Support"]
        ),
    ],
    dependencies: [],
    targets: [

        .target(
            name: "Time",
            dependencies: []
        ),

        .testTarget(
            name: "Time Tests",
            dependencies: [
                .target(name: "Time"),
            ]
        ),

        .target(
            name: "Time Test Support",
            dependencies: [
                .target(name: "Time"),
            ],
            path: "Tests/Support"
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
