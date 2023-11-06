// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
  name: "Platform",
  platforms: [.iOS(.v14)],
  products: [
    // Products define the executables and libraries a package produces, and make them visible to other packages.
    .library(
      name: "CombineUtil",
      targets: ["CombineUtil"]
    ),
    .library(
      name: "RIBsUtil",
      targets: ["RIBsUtil"]
    ),
    .library(
      name: "SuperUI",
      targets: ["SuperUI"]
    ),
  ],
  dependencies: [
    .package(url: "https://github.com/CombineCommunity/CombineExt", exact: "1.8.0"),
    .package(url: "https://github.com/DevYeom/ModernRIBs", exact: "1.0.1"),
    
  ],
  targets: [
    // Targets are the basic building blocks of a package. A target can define a module or a test suite.
    // Targets can depend on other targets in this package, and on products in packages this package depends on.
    .target(
      name: "CombineUtil",
      dependencies: [
        "CombineExt"
      ]
    ),
    .target(
      name: "RIBsUtil",
      dependencies: [
        "ModernRIBs",
      ]
    ),
    .target(
      name: "SuperUI",
      dependencies: [
        "RIBsUtil"
      ]
    ),
  ]
)
