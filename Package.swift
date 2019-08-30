// swift-tools-version:4.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "gxclient-swift",
    products: [
        // Products define the executables and libraries produced by a package, and make them visible to other packages.
        .library(
            name: "gxclient-swift",
            targets: ["gxclient-swift"]),
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        // .package(url: /* package url */, from: "1.0.0"),
        .package(url: "https://github.com/Flight-School/AnyCodable.git", .revision("396ccc3dba5bdee04c1e742e7fab40582861401e")),
        .package(url: "https://github.com/jnordberg/OrderedDictionary.git", .branch("swiftpm")),
        .package(url: "https://github.com/krzyzanowskim/CryptoSwift.git", from: "0.15.0"),
        .package(url: "https://github.com/yannickl/AwaitKit.git", from: "5.2.0"),
        .package(url: "https://github.com/Alamofire/Alamofire.git", from: "4.8.2"),
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages which this package depends on.
        .target(
            name: "Crypto",
            dependencies: []
        ),
        .target(
            name: "secp256k1",
            dependencies: []
        ),
        .target(
            name: "uecc",
            dependencies: []
        ),
        .target(
            name: "gxclient-swift",
            dependencies: ["Crypto", "AnyCodable", "OrderedDictionary", "secp256k1", "CryptoSwift", "AwaitKit", "uecc", "Alamofire"]),
        .testTarget(
            name: "gxclient-swiftTests",
            dependencies: ["gxclient-swift"]),
    ]
)
