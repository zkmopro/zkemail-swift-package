// swift-tools-version: 5.10
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "ZKEmailSwift",
    platforms: [
        .macOS(.v10_15),
        .iOS(.v15),
    ],
    products: [
        .library(
            name: "ZKEmailSwift",
            targets: ["ZKEmailSwift"]),
    ],
    targets: [
        .target(
            name: "ZKEmailSwift",
            dependencies: [
                .byName(name: "mopro")
            ],
            path: "Sources/"),
        .binaryTarget(
            name: "mopro",
            path: "Sources/MoproiOSBindings/MoproBindings.xcframework.zip"
        ),
        .testTarget(
            name: "ZKEmailSwiftTests",
            dependencies: ["ZKEmailSwift"],
            path: "Tests/",
            resources: [
                .process("MoproAssets/zkemail_input.json"),
                .process("MoproAssets/srs.local")
            ]
        )
    ]
)
