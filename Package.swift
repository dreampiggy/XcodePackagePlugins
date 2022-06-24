// swift-tools-version: 5.6
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "XcodePackagePlugins",
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(
            name: "XcodePackagePlugins",
            targets: ["XcodePackagePlugins"]),
        .plugin(
            name: "CountSourceLines",
            targets: ["CountSourceLines"]),
        .plugin(
            name: "RegenerateContributorsList",
            targets: ["RegenerateContributorsList"])
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        // .package(url: /* package url */, from: "1.0.0"),
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .target(
            name: "XcodePackagePlugins",
            dependencies: []),
        .testTarget(
            name: "XcodePackagePluginsTests",
            dependencies: ["XcodePackagePlugins"]),
        .plugin(
            name: "CountSourceLines",
            capability: .command(
                intent: .custom(
                    verb: "count-source-lines",
                    description: "Count all the source code lines number")
            )
        ),
        .plugin(
            name: "RegenerateContributorsList",
            capability: .command(
                intent: .custom(
                    verb: "regenerate-contributors-list",
                    description: "Regenerate the contributors list and write into CONTRIBUTORS.txt"),
                permissions: [.writeToPackageDirectory(reason: "This command create a CONTRIBUTORS.txt file in the package directory")]
            )
        )
    ]
)
