// swift-tools-version: 5.9

import Foundation
import PackageDescription

let flutterFrameworkPath = "../FlutterFramework"
let hasFlutterFramework = FileManager.default.fileExists(atPath: flutterFrameworkPath)

var packageDependencies: [Package.Dependency] = []
var products: [Product] = []
var targets: [Target] = [
  .target(
    name: "flutter_wk_core",
    dependencies: [],
    path: "Sources/flutter_wk_core"
  ),
  .testTarget(
    name: "flutter_wk_coreTests",
    dependencies: [
      "flutter_wk_core"
    ],
    path: "Tests/flutter_wk_coreTests"
  ),
]

if hasFlutterFramework {
  packageDependencies.append(
    .package(name: "FlutterFramework", path: flutterFrameworkPath)
  )
  products.append(
    .library(name: "flutter-wk", targets: ["flutter_wk"])
  )
  targets.insert(
    .target(
      name: "flutter_wk",
      dependencies: [
        "flutter_wk_core",
        .product(name: "FlutterFramework", package: "FlutterFramework")
      ],
      path: "Sources/flutter_wk"
    ),
    at: 1
  )
}

let package = Package(
  name: "flutter_wk",
  platforms: [
    .iOS("13.0")
  ],
  products: products,
  dependencies: packageDependencies,
  targets: targets
)