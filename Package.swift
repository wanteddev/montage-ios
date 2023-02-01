// swift-tools-version:5.5

import PackageDescription

let package = Package(
    name: "Montage",
    platforms: [.iOS(.v14)],
    products: [
        .library(name: "Montage", targets: ["Montage"])
    ],
    dependencies: [
        .package(
            url: "https://github.com/wanteddev/pretendard-ios",
            "0.1.0" ..< "1.0.0"
        )
    ],
    targets: [
        .target(
            name: "Montage",
            dependencies: [
                .product(name: "Pretendard", package: "pretendard-ios")
            ],
            resources: [
                .process("Asset")
            ]
        ),
        .testTarget(
            name: "MontageTests",
            dependencies: ["Montage"]
        )
    ],
    swiftLanguageVersions: [.v5]
)
