// swift-tools-version:5.1
import PackageDescription

let package = Package(
    name: "DynamicOverlay",
    platforms: [
        .iOS(.v13)
    ],
    products: [
        .library(
            name: "DynamicOverlay",
            targets: ["DynamicOverlay"]
        ),
    ],
    targets: [
        .target(
            name: "DynamicOverlay",
            path: "Source/Classes"
        ),
    ],
    swiftLanguageVersions: [.v5]
)
