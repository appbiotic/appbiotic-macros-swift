// swift-tools-version: 5.10

import CompilerPluginSupport
import PackageDescription

let package = Package(
  name: "AppbioticMacros",
  platforms: [.macOS(.v10_15), .iOS(.v13), .tvOS(.v13), .watchOS(.v6), .macCatalyst(.v13)],
  products: [
    .library(
      name: "AppbioticMacros",
      targets: ["AppbioticMacros"]
    ),
    .executable(
      name: "AppbioticMacrosClient",
      targets: ["AppbioticMacrosClient"]
    ),
  ],
  dependencies: [
    .package(url: "https://github.com/apple/swift-syntax.git", from: "509.0.0")
  ],
  targets: [
    .macro(
      name: "AppbioticMacrosPlugin",
      dependencies: [
        .product(name: "SwiftSyntaxMacros", package: "swift-syntax"),
        .product(name: "SwiftCompilerPlugin", package: "swift-syntax"),
      ]
    ),
    .target(name: "AppbioticMacros", dependencies: ["AppbioticMacrosPlugin"]),
    .executableTarget(name: "AppbioticMacrosClient", dependencies: ["AppbioticMacros"]),
    .testTarget(
      name: "AppbioticMacrosTests",
      dependencies: [
        "AppbioticMacrosPlugin",
        .product(name: "SwiftSyntaxMacrosTestSupport", package: "swift-syntax"),
      ]
    ),
  ]
)
