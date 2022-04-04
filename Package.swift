// swift-tools-version:5.5

import PackageDescription

let package = Package(
    name: "Montage",
    platforms: [.iOS(.v13)],
    products: [
        .library(name: "Montage", targets: ["Montage"])
    ],
    dependencies: [],
    targets: [
        .target(
            name: "Montage",
            dependencies: [],
            resources: [
                .copy("Asset/Icon.xcassets"),
                .copy("Asset/Color.xcassets")
            ]
        ),
        .testTarget(
            name: "MontageTests",
            dependencies: ["Montage"]
        )
    ],
    swiftLanguageVersions: [.v5]
)
