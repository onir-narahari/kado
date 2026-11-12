// swift-tools-version: 6.0

import PackageDescription

let package = Package(
    name: "HabitLogic",
    platforms: [.iOS(.v18), .macOS(.v15)],
    products: [
        .library(name: "HabitLogic", targets: ["HabitLogic"])
    ],
    targets: [
        .target(name: "HabitLogic"),
        .testTarget(name: "HabitLogicTests", dependencies: ["HabitLogic"])
    ]
)
