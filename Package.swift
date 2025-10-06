// swift-tools-version: 6.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SwiftNetworkKit",
    platforms: [
        .macOS(.v13),
        .tvOS(.v12),
        .watchOS(.v9),
        .iOS(.v16),
        .visionOS(.v1),
    ],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "SwiftNetworkKit",
            targets: ["SwiftNetworkKit"]
        )
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "SwiftNetworkKit"
        ),
        .testTarget(
            name: "SwiftNetworkKitTests",
            dependencies: ["SwiftNetworkKit"]
        ),
    ]
)
