// swift-tools-version:5.7

import PackageDescription

let package = Package(
    name: "Montage",
    defaultLocalization: "ko",
    platforms: [.iOS(.v16)],
    products: [
        .library(name: "Montage", targets: ["Montage"])
    ],
    dependencies: [
        .package(
            url: "https://github.com/wanteddev/pretendard-ios",
            "1.0.0"..<"2.0.0"
        ),
        .package(
            url: "https://github.com/airbnb/lottie-ios",
            exact: "4.5.0"
        ),
        .package(
            url: "https://github.com/SDWebImage/SDWebImageSwiftUI.git",
            from: "3.0.0"
        ),
        .package(url: "https://github.com/apple/swift-docc-plugin", from: "1.0.0"),
    ],
    targets: [
        .target(
            name: "Montage",
            dependencies: [
                .product(name: "Pretendard", package: "pretendard-ios"),
                .product(name: "Lottie", package: "lottie-ios"),
                .product(name: "SDWebImageSwiftUI", package: "SDWebImageSwiftUI"),
            ],
            resources: [
                .process("Asset")
            ]
        ),
    ],
    swiftLanguageVersions: [.v5]
)
