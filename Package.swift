// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "UIDevice-DisplayName",
    platforms: [
        .iOS(.v12),
        .tvOS(.v12),
    ],
    products: [
        .library(
            name: "UIDevice-DisplayName",
            targets: ["UIDevice-DisplayName"]
        ),
    ],
    dependencies: [],
    targets: [
        .target(
            name: "UIDevice-DisplayName",
            dependencies: [],
            resources: [.process("Resources")]
        ),
        .testTarget(
            name: "UIDevice-DisplayNameTests",
            dependencies: ["UIDevice-DisplayName"]
        ),
    ],
    swiftLanguageVersions: [.v5]
)
