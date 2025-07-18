// swift-tools-version:5.9
import PackageDescription

let package = Package(
    name: "ZKEmailSwift",
    platforms: [
        .iOS(.v14),
    ],
    products: [
        .library(
            name: "ZKEmailSwift",
            targets: ["ZKEmailSwift", "MoproBindings"]
        ),
    ],
    dependencies: [],
    targets: [
        .target(
            name: "ZKEmailSwift",
            dependencies: [
                .byName(name: "MoproBindings")
            ],
            path: "Sources/"
        ),
        .binaryTarget(
            name: "MoproBindings",
            url: "https://github.com/zkmopro/mopro-zkemail-nr/releases/download/v0.1.0/MoproiOSBindings.zip",
            checksum: "f6d168eec9a7b105cf73446b3f9de15c0b5ef9e3878fa94dde4ade24171f8cf8"
        ),
        .testTarget(
            name: "ZKEmailSwiftTests",
            dependencies: ["ZKEmailSwift"],
            path: "Tests/",
            resources: [
                .process("MoproAssets/zkemail_input.json"),
                .process("MoproAssets/srs.local"),
            ]
        )
    ]
)
