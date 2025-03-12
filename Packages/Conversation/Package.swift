// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Conversation",
    platforms: [.macOS(.v14)],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "Conversation",
            targets: ["Conversation"])
    ],
    dependencies: [
        .package(name: "Utilities", path: "../Utilities"),
        .package(name: "Database", path: "../Database"),
        .package(name: "UltraUI", path: "../UltraUI"),
        .package(name: "Intelligence", path: "../Intelligence"),
        .package(url: "https://github.com/markiv/SwiftUI-Shimmer", from: "1.5.1"),
        .package(url: "https://github.com/gonzalezreal/swift-markdown-ui", from: "2.0.2"),
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "Conversation",
            dependencies: [
                "Intelligence",
                "UltraUI",
                "Utilities",
                "Database",
                .product(name: "MarkdownUI", package: "swift-markdown-ui"),
                .product(name: "Shimmer", package: "SwiftUI-Shimmer"),
            ]
        ),
        .testTarget(
            name: "ConversationTests",
            dependencies: ["Conversation"]
        ),
    ]
)
