// swift-tools-version:5.5
import PackageDescription

let package = Package(
    name: "netMon",
    platforms: [
        .macOS(.v11)
    ],
    products: [
        .executable(name: "netMon", targets: ["netMon"]),
        .library(name: "netMonCore", targets: ["netMonCore"])
    ],
    targets: [
        .target(
            name: "netMonCore",
            dependencies: []
        ),
        .executableTarget(
            name: "netMon",
            dependencies: ["netMonCore"]
        ),
        .testTarget(
            name: "netMonTests",
            dependencies: ["netMonCore"],
            path: "Tests"
        )
    ]
)
