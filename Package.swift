// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "AutoThemeKit",

    platforms: [
        .iOS(.v15)
    ],

    products: [
        .library(
            name: "AutoThemeKit",
            targets: ["AutoThemeKit"]
        )
    ],

    targets: [
        .target(
            name: "AutoThemeKit",
            path: "Sources/AutoThemeKit"
        )
    ]
)
