// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription
import CompilerPluginSupport

let package = Package(
    name: "GigMacros",
    platforms: [.macOS(.v11), .iOS(.v14), .tvOS(.v14), .watchOS(.v8), .macCatalyst(.v14)],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "GigMacros",
            targets: ["GigMacros"]
        ),
        .executable(
            name: "GigMacrosClient",
            targets: ["GigMacrosClient"]
        ),
    ],
    dependencies: [
        // Depend on SwiftSyntax 509.1.1 to align with Xcode 16+ toolchains
        .package(url: "https://github.com/apple/swift-syntax.git", from: "509.1.1"),
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        // Macro implementation that performs the source transformation of a macro.
        .macro(
            name: "GigMacrosPlugin",
            dependencies: [
                .product(name: "SwiftSyntaxMacros", package: "swift-syntax"),
                .product(name: "SwiftCompilerPlugin", package: "swift-syntax")
            ]
        ),

        // Library that exposes a macro as part of its API, which is used in client programs.
        .target(name: "GigMacros", dependencies: ["GigMacrosPlugin"]),

        // A client of the library, which is able to use the macro in its own code.
        .executableTarget(name: "GigMacrosClient", dependencies: ["GigMacros"]),

        // A test target used to develop the macro implementation.
        .testTarget(
            name: "GigMacrosTests",
            dependencies: [
                "GigMacrosPlugin",
                .product(name: "SwiftSyntaxMacrosTestSupport", package: "swift-syntax"),
            ]
        ),
    ]
)
