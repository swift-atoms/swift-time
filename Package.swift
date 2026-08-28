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
            name: "Time Primitive",
            targets: ["Time Primitive"]
        ),

        .library(
            name: "Time Format",
            targets: ["Time Format"]
        ),

        .library(
            name: "Time Julian",
            targets: ["Time Julian"]
        ),

        .library(
            name: "Time",
            targets: ["Time"]
        ),
        .library(
            name: "Time Test Support",
            targets: ["Time Test Support"]
        ),
    ],
    dependencies: [
        .package(
            url: "https://github.com/swift-molecules/swift-dimension.git",
            branch: "main"
        ),
        .package(
            url: "https://github.com/swift-molecules/swift-format.git",
            branch: "main"
        ),
        .package(
            url: "https://github.com/swift-molecules/swift-formatter.git",
            branch: "main"
        ),
    ],
    targets: [

        .target(
            name: "Time Primitive",
            dependencies: []
        ),

        .target(
            name: "Time Format",
            dependencies: [
                "Time Primitive",
                .product(name: "Format", package: "swift-format"),
                .product(name: "Formatter", package: "swift-formatter"),
            ]
        ),

        .target(
            name: "Time Julian",
            dependencies: [
                "Time Primitive",
                .product(name: "Dimension", package: "swift-dimension"),
            ]
        ),

        .target(
            name: "Time",
            dependencies: [
                "Time Primitive",
                "Time Format",
                "Time Julian",
            ]
        ),

        .testTarget(
            name: "Time Tests",
            dependencies: [
                "Time Primitive",
                "Time",
            ]
        ),

        .target(
            name: "Time Test Support",
            dependencies: [
                "Time",
                .product(
                    name: "Dimension Test Support",
                    package: "swift-dimension"
                ),
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
