// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "ChatMLXCore",
    platforms: [.macOS(.v14)],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "ChatMLXCore",
            targets: ["ChatMLXCore"]
        ),
        .library(
            name: "Utilities",
            targets: ["Utilities"]
        ),
    ],
    dependencies: [
        .package(url: "https://github.com/Alamofire/Alamofire.git", from: "5.9.1"),
        .package(url: "https://github.com/elai950/AlertToast.git", from: "1.3.9"),
        .package(url: "https://github.com/buh/CompactSlider.git", from: "1.1.6"),
        .package(url: "https://github.com/sindresorhus/Defaults.git", branch: "main"),
        .package(url: "https://github.com/MrKai77/Luminare.git", branch: "main"),
        .package(url: "https://github.com/ml-explore/mlx-swift-examples.git", branch: "main"),
        .package(url: "https://github.com/johnsundell/splash.git", from: "0.16.0"),
        .package(url: "https://github.com/apple/swift-log.git", from: "1.6.1"),
        .package(url: "https://github.com/gonzalezreal/swift-markdown-ui.git", branch: "main"),
        .package(url: "https://github.com/siteline/swiftui-introspect.git", from: "1.3.0"),
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "ChatMLXCore",
            dependencies: [
                .product(name: "Alamofire", package: "Alamofire"),
                .product(name: "AlertToast", package: "AlertToast"),
                .product(name: "CompactSlider", package: "CompactSlider"),
                .product(name: "Defaults", package: "Defaults"),
                .product(name: "Luminare", package: "Luminare"),
                .product(name: "LLM", package: "mlx-swift-examples"),
                .product(name: "Logging", package: "swift-log"),
                .product(name: "MarkdownUI", package: "swift-markdown-ui"),
                .product(name: "SwiftUIIntrospect", package: "swiftui-introspect"),
            ]
        ),
        .target(
            name: "Utilities",
            dependencies: [
                .product(name: "Logging", package: "swift-log")
            ]
        ),
    ]
)
