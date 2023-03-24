// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SimpleVideoPlayer",
    platforms: [.iOS(.v14), .macOS(.v10_15)],
    products: [
        .library(
            name: "SimpleVideoPlayer",
            targets: ["SimpleVideoPlayer"]
        )
    ],
    dependencies: [],
    targets: [
        .target(
            name: "SimpleVideoPlayer",
            dependencies: []
        )
    ]
)
