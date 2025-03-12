// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Database",
    platforms: [.macOS(.v14)],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "Database",
            targets: ["Database"]),
    ],
    dependencies: [
        .package(name: "Intelligence", path: "../Intelligence"),
        .package(url: "https://github.com/groue/GRDB.swift.git", from: "7.3.0"),
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "Database",
            dependencies: [
                "Intelligence",
                .product(name: "GRDB", package: "GRDB.swift")
            ]
        ),
        .testTarget(
            name: "DatabaseTests",
            dependencies: ["Database"]
        ),
    ]
)
