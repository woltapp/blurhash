// swift-tools-version:5.0
import PackageDescription

let package = Package(
    name: "BlurHashKit",
    platforms: [
        .iOS(.v12)
    ],
    products: [
        .library(name: "BlurHashKit", targets: ["BlurHashKit"]),
    ],
    targets: [
        .target(name: "BlurHashKit",
                dependencies: [],
                path: "./Swift/BlurHashKit"
        ),
        .target(name: "BlurHashKitCodable",
                dependencies: [],
                path: "./Swift/BlurHashKitCodable"
        ),
        .testTarget(name: "BlurHashTest",
                    dependencies: [
                        "BlurHashKit",
                        "BlurHashKitCodable",
                    ],
                    path: "./Swift/BlurHashTest"
        ),
    ]
)
