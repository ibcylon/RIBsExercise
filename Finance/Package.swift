// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
  name: "Finance",
  platforms: [.iOS( .v14)],
  products: [
    // Products define the executables and libraries a package produces, and make them visible to other packages.
    .library(
      name: "AddPaymentMethod",
      targets: ["AddPaymentMethod"]
    ),
    .library(
      name: "FinanceEntity",
      targets: ["FinanceEntity"]
    ),
    .library(
      name: "FinanceRepository",
      targets: ["FinanceRepository"]
    ),
    .library(
      name: "Topup",
      targets: ["Topup"]
    ),
    .library(
      name: "TopupImp",
      targets: ["TopupImp"]
    ),

    .library(
      name: "FinanceHome",
      targets: ["FinanceHome"]
    ),
    .library(
      name: "FinanceHomeImp",
      targets: ["FinanceHomeImp"]
    ),
  ],
  dependencies: [
    .package(url: "https://github.com/DevYeom/ModernRIBs", exact: "1.0.1"),
    .package(path: "../Platform"),
    // Dependencies declare other packages that this package depends on.
    // .package(url: /* package url */, from: "1.0.0"),
  ],
  targets: [
    .target(
      name: "AddPaymentMethod",
      dependencies: [
        "ModernRIBs",
        "FinanceEntity",
        "FinanceRepository",
        .product(name: "RIBsUtil", package: "Platform"),
        .product(name: "SuperUI", package: "Platform"),
      ]
    ),
    .target(
      name: "FinanceEntity",
      dependencies: [
      ]
    ),
    .target(
      name: "FinanceRepository",
      dependencies: [
        "FinanceEntity",
        .product(name: "CombineUtil", package: "Platform"),
        
      ]
    ),
    .target(
      name: "Topup",
      dependencies: [
        "ModernRIBs",
      ]
    ),
    .target(
      name: "TopupImp",
      dependencies: [
        "ModernRIBs",
        "FinanceEntity",
        "FinanceRepository",
        "AddPaymentMethod",
        .product(name: "RIBsUtil", package: "Platform"),
        .product(name: "SuperUI", package: "Platform"),
      ]
    ),
    .target(
      name: "FinanceHome",
      dependencies: [
        "ModernRIBs",
      ]
    ),
    .target(
      name: "FinanceHomeImp",
      dependencies: [
        "ModernRIBs",
        "FinanceEntity",
        "FinanceRepository",
        "AddPaymentMethod",
        "Topup",
        .product(name: "RIBsUtil", package: "Platform"),
        .product(name: "SuperUI", package: "Platform"),
      ]
    ),
    
  ]
)
