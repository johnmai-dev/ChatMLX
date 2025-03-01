// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Common",
    platforms: [.macOS(.v14)],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "Common",
            targets: ["Common"])
    ],
    dependencies: [
        .package(name: "HuggingfaceHub", path: "../../../../maiqingqiang/HuggingfaceHub"),
        .package(name: "Models", path: "../Models"),
        .package(url: "https://github.com/sindresorhus/Defaults", from: "9.0.2"),
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "Common",
            dependencies: [
                "Models",
                "Defaults",
                "HuggingfaceHub",
            ]
        ),
        .testTarget(
            name: "CommonTests",
            dependencies: ["Common"]
        ),
    ]
)
