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
    dependencies: [
        .package(url: "https://github.com/applidium/OverlayContainer.git", from: "3.5.2")
    ],
    targets: [
        .target(
            name: "DynamicOverlay",
            dependencies: ["OverlayContainer"],
            path: "Source"
        ),
        .testTarget(
            name: "DynamicOverlayTests",
            dependencies: [
                "DynamicOverlay",
            ]
        )
    ],
    swiftLanguageVersions: [.v5]
)
