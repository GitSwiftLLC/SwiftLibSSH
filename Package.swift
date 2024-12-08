// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SwiftLibSSH",
    platforms: [
        .macOS(.v13),
        .iOS(.v16),
        .tvOS(.v16),
        .watchOS(.v10),
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
                "clib"
            ]
        ),
        .target(
            name: "clib",
            dependencies: [],
            sources: [
                "./sshkey.c",
                "./include/sshkey.h",
                "./dns.c",
                "./include/dns.h"
            ],
            cSettings: [
                .headerSearchPath("./include")
            ]
        )
    ]
)
