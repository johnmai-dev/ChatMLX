// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "UltraUI",
    platforms: [.macOS(.v14)],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "UltraUI",
            targets: ["UltraUI"])
    ],
    dependencies: [
        .package(url: "https://github.com/krzyzanowskim/STTextView", from: "2.0.0"),
        .package(url: "https://github.com/siteline/swiftui-introspect", from: "1.0.0"),
        .package(url: "https://github.com/buh/CompactSlider", from: "2.0.7"),
        
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "UltraUI",
            dependencies: [
                "STTextView",
                "CompactSlider",
                .product(name: "SwiftUIIntrospect", package: "swiftui-introspect"),
            ]
        ),
        .testTarget(
            name: "UltraUITests",
            dependencies: ["UltraUI"]
        ),
    ]
)
