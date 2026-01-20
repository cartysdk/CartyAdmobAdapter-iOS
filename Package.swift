
// swift-tools-version:5.3
import PackageDescription

let package = Package(
    name: "CartyAdmobAdapter",
    platforms: [
        .iOS(.v13)
    ],
    products: [
        .library(
            name: "CartyAdmobAdapter",
            targets: ["CartyAdmobAdapter"]
        ),
    ],
    targets: [
        .target(
            name: "CartyAdmobAdapter",
            path: "CartyAdmobAdapter",
        ),

    ]
)
