// swift-tools-version: 5.7

import PackageDescription

let package = Package(
    name: "RESTKit",
    platforms: [
        .iOS(.v15),
    ],
    products: [
        .library(
            name: "RESTKit",
            targets: ["RESTKit"]),
    ],
    targets: [
        .target(
            name: "RESTKit",
            dependencies: []),
        .testTarget(
            name: "RESTKitTests",
            dependencies: ["RESTKit"]),
    ]
)
