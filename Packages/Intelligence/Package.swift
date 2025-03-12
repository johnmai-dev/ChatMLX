// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Intelligence",
    platforms: [.macOS(.v14)],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "Intelligence",
            targets: ["Intelligence"]),
    ],
    dependencies: [
        .package(name: "HuggingfaceHub", path: "../../../../maiqingqiang/HuggingfaceHub"),
        .package(url: "https://github.com/ml-explore/mlx-swift-examples/", branch: "main"),
        .package(url: "https://github.com/MacPaw/OpenAI.git", branch: "0.3.6")
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "Intelligence",
            dependencies: [
                "HuggingfaceHub",
                "OpenAI",
                .product(name: "MLXLMCommon", package: "mlx-swift-examples"),
                .product(name: "MLXLLM", package: "mlx-swift-examples"),
                .product(name: "MLXVLM", package: "mlx-swift-examples"),
            ]
        ),
        .testTarget(
            name: "IntelligenceTests",
            dependencies: ["Intelligence"]
        ),
    ]
)
