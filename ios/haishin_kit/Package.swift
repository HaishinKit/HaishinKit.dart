// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "haishin_kit",
    platforms: [
        .iOS("13.0")
    ],
    products: [
        .library(name: "haishin-kit", targets: ["haishin_kit"])
    ],
    dependencies: [
        .package(url: "https://github.com/HaishinKit/HaishinKit.swift", exact: "2.1.2")
    ],
    targets: [
        .target(
            name: "haishin_kit",
            dependencies: [
                .product(name: "HaishinKit", package: "HaishinKit.swift")
            ],
            resources: [
            ]
        )
    ]
)
