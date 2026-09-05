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
    dependencies: [
        .package(url: "https://github.com/swift-atoms/swift-addition.git", branch: "main"),
        .package(url: "https://github.com/swift-atoms/swift-magnitude.git", branch: "main"),
        .package(url: "https://github.com/swift-atoms/swift-polarity.git", branch: "main"),
        .package(url: "https://github.com/swift-atoms/swift-affine.git", branch: "main"),
        .package(url: "https://github.com/swift-atoms/swift-cardinal.git", branch: "main"),
        .package(url: "https://github.com/swift-atoms/swift-difference.git", branch: "main"),
        .package(url: "https://github.com/swift-atoms/swift-division.git", branch: "main"),
        .package(url: "https://github.com/swift-atoms/swift-rational.git", branch: "main"),
        .package(url: "https://github.com/swift-atoms/swift-ratio.git", branch: "main"),
        .package(url: "https://github.com/swift-atoms/swift-tagged.git", branch: "main"),
    ],
    targets: [

        .target(
            name: "Time",
            dependencies: [
                .product(name: "Addition", package: "swift-addition"),
                .product(name: "Magnitude", package: "swift-magnitude"),
                .product(name: "Polarity", package: "swift-polarity"),
                .product(name: "Affine", package: "swift-affine"),
                .product(name: "Cardinal", package: "swift-cardinal"),
                .product(name: "Difference", package: "swift-difference"),
                .product(name: "Division", package: "swift-division"),
                .product(name: "Rational", package: "swift-rational"),
                .product(name: "Ratio", package: "swift-ratio"),
                .product(name: "Tagged", package: "swift-tagged")
            ]
        ),

        .testTarget(
            name: "Time Tests",
            dependencies: [
                .target(name: "Time"),
                .product(name: "Affine", package: "swift-affine"),
                .product(name: "Cardinal", package: "swift-cardinal"),
                .product(name: "Difference", package: "swift-difference"),
                .product(name: "Division", package: "swift-division"),
                .product(name: "Rational", package: "swift-rational"),
                .product(name: "Ratio", package: "swift-ratio"),
                .product(name: "Tagged", package: "swift-tagged")
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
