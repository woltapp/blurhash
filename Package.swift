// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

// swift build -Xswiftc "-sdk" -Xswiftc "`xcrun --sdk iphonesimulator --show-sdk-path`" -Xswiftc "-target" -Xswiftc "x86_64-apple-ios13.0-simulator"

import PackageDescription

let package = Package(
    name: "blurhash",
    defaultLocalization: "en",
    products: [
        .library(
            name: "BlurHash",
            targets: ["BlurHash"]
        ),
    ],
    dependencies: [],
    targets: [
        .target(
            name: "BlurHash",
            dependencies: [],
            path: "./Swift",
            exclude: [
                "BlurHashKit",
                "BlurHashTest",
                "License.txt",
                "Readme.md",
            ],
            sources: [
                "BlurHashDecode.swift",
                "BlurHashEncode.swift",
            ]
        ),
    ]
)
