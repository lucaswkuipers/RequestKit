// swift-tools-version: 5.7

import PackageDescription

let package = Package(
    name: "RESTKit",
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
