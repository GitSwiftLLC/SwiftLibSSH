// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SwiftLibSSH",
    platforms: [
        .macOS(.v10_15),
        .iOS(.v13),
        .tvOS(.v13),
        .watchOS(.v6),
        .visionOS(.v1)
    ],
    products: [
        .library(
            name: "SwiftLibSSH",
            targets: ["SwiftLibSSH"]),
    ],
    dependencies: [
        .package(url: "https://github.com/GitSwiftLLC/SwiftCSSH.git", .upToNextMajor(from: "1.11.1")),
    ],
    targets: [
        .target(
            name: "SwiftLibSSH",
            dependencies: [
                .product(name: "SwiftCSSH", package: "SwiftCSSH"),
            ]
        )
    ]
)
