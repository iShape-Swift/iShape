// swift-tools-version: 5.7
import PackageDescription

let package = Package(
    name: "iShape",
    products: [
        .library(
            name: "iShape",
            targets: ["iShape"]),
    ],
    dependencies: [
        .package(url: "https://github.com/iShape-Swift/iFixFloat", from: "1.6.0")
//         .package(path: "../iFixFloat"),  // Local path to iFixFloat
    ],
    targets: [
        .target(
            name: "iShape",
            dependencies: ["iFixFloat"]),
        .testTarget(
            name: "iShapeTests",
            dependencies: ["iShape"]),
    ]
)
